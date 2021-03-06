#!/usr/bin/php
<?php

require_once('MerlinPDO.inc.php');
require_once('object_importer.inc.php');

$imp = new nagios_object_importer;
$imp->db_type = 'mysql';
$imp->db_host = 'localhost';
$imp->db_user = 'merlin';
$imp->db_pass = 'merlin';
$imp->db_database = 'merlin';
$imp->db_port = false;
$imp->db_conn_str = false;
#$imp->debug = TRUE;

if (PHP_SAPI !== 'cli') {
	$msg = "This program must be run from the command-line version of PHP\n";
	echo $msg;
	die($msg);
}

$progname = basename($argv[0]);
function usage($msg = false)
{
	global $progname;

	if ($msg) {
		echo $msg . "\n";
	}

	echo "Usage: $progname <options> --cache=/path/to/objects.cache\n";
	echo "\n";
	echo "--db-name    name of database to import to\n";
	echo "--db-user    database username\n";
	echo "--db-host    database host\n";
	echo "--db-pass    database password\n";
	echo "--db-type    database type (mysql is the only supported for now)\n";
	echo "--db-port    database port to connect to\n";
	echo "--cache      path to the objects.cache file to import\n";
	echo "--status-log path to the status.log file to import\n";
	echo "--nagios-cfg path to nagios' main configuration file\n";
	echo "--force      force re-import even if objects.cache hasn't changed\n";
	exit(1);
}

function read_nagios_cfg($cfgfile)
{
	if (!file_exists($cfgfile))
		return false;

	$cfg = false;
	$lines = explode("\n", file_get_contents($cfgfile));
	foreach ($lines as $line) {
		$line = trim($line);
		if (!strlen($line) || $line{0} === '#')
			continue;
		$ary = explode('=', $line);
		$k = $ary[0];
		$v = $ary[1];
		if (isset($cfg[$k])) {
			if (!is_array($cfg[$k]))
				$cfg[$k] = array($cfg[$k]);
			$cfg[$k][] = $v;
			continue;
		}
		$cfg[$k] = $v;
	}

	return $cfg;
}

if (PHP_SAPI !== 'cli') {
	usage("This program can only be run from the command-line\n");
}

$force_import = $nagios_cfg = $dry_run = $cache = $status_log = false;
for ($i = 1; $i < $argc; $i++) {
	$arg = $argv[$i];
	if (substr($arg, 0, 2) !== '--') {
		$cache = $arg;
		continue;
	}
	$arg = substr($arg, 2);

	if ($arg === 'dry-run') {
		$dry_run = true;
		continue;
	} else if ($arg === 'force') {
		$force_import = true;
		continue;
	}

	$opt = false;
	$optpos = strpos($arg, '=');
	if ($optpos !== false) {
		# must set 'opt' first
		$opt = substr($arg, $optpos + 1);
		$arg = substr($arg, 0, $optpos);
	} elseif ($i < $argc - 1) {
		$opt = $argc[++$i];
	} else {
		usage("$arg requires an option\n");
	}
	switch ($arg) {
	 case 'db-name': $imp->db_database = $opt; break;
	 case 'db-user': $imp->db_user = $opt; break;
	 case 'db-pass': $imp->db_pass = $opt; break;
	 case 'db-type': $imp->db_type = $opt; break;
	 case 'db-host': $imp->db_host = $opt; break;
	 case 'db-port': $imp->db_port = $opt; break;
	 case 'db-conn_str': $imp->db_conn_str = $opt; break;
	 case 'cache': $cache = $opt; break;
	 case 'status-log': $status_log = $opt; break;
	 case 'nagios-cfg': $nagios_cfg = $opt; break;
	 default:
		usage("Unknown argument: $arg\n");
		break;
	}
}

# sensible defaults for op5 systems
if (!$nagios_cfg && !$cache && !$status_log) {
	$nagios_cfg = "/opt/monitor/etc/nagios.cfg";
}

$config = false;
if ($nagios_cfg) {
	$config = read_nagios_cfg($nagios_cfg);
}

if (!empty($config)) {
	if (!$cache && isset($config['object_cache_file'])) {
		$cache = $config['object_cache_file'];
	}
	if (!$status_log) {
		if (isset($config['status_file']))
			$status_log = $config['status_file'];
		elseif (isset($config['xsddefault_status_file']))
			$status_log = $config['xsddefault_status_file'];
	}
}

$imp->prepare_import();

if (!$cache && !$status_log)
	usage("Neither --cache nor --status-log given.\nImporting nothing\n");

if (!$dry_run) {
	echo "Disabling indexes\n";
	$imp->disable_indexes();
}
echo "Importing objects to database $imp->db_database\n";
if ($cache) {
	$lastimport = $cache.'.lastimport';
	$mtime = filemtime($cache);
	$importtime = file_exists($lastimport) ? filemtime($lastimport) : 0;
	if ($mtime > $importtime || $force_import) {
		echo "importing objects from $cache\n";
		if (!$dry_run) {
			$imp->import_objects_from_cache($cache, true);
			# If the server clock is busted, this prevents that $mtime > date()
			touch($lastimport, $mtime);
		}
	} else {
		echo "objects.cache hasn't changed - skipping\n";
	}
}

if ($status_log) {
	echo "importing status from $status_log\n";
	if (!$dry_run)
		$imp->import_objects_from_cache($status_log, false);
}

if (!$dry_run) {
	$imp->finalize_import();
	if (!empty($imp->db_quote_special)) {
		echo "Special quoting used. pdo_oci appears to be buggy.\n";
	}
}
