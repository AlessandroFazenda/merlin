<?php
require_once('oci8topdo.php');
/*
 * Copyright(C) 2004, 2005, 2007, 2010 op5 AB
 * All rights reserved.
 *
 */

/**
 * Singleton-like PDO database handle provider. It is intended to be
 * used like this:
 *
 * $db = PDOProvider::db();
 *
 * That returns a shared PDO database object.
 */
class PDOProvider
{
	private static $db = NULL;

	private static $conf = array();
	/**
	 * Returns a shared PDO database instance.  It establishes the
	 * connection during the first call, and throws an error if
	 * connection fails. On subsequent calls it will return the same
	 * instance.
	 *
	 * The $key parameter is used to figure out which configuration
	 * information to use for the connection. The connection parameters
	 * are taken from config($key), and that object must be populated by
	 * the client before calling this.
	 *
	 * To use a custom (non-default) configuration:
	 *
	 * $c =& PDOProvider::config('someDbIdentifier');
	 * $c['host'] = ...;
	 * ...
	 *
	 * If $c['dsn'] is set then the host/port/dbname parameters are
	 * ignored, and are assumed to be encoded in the DSN (if they are
	 * needed at all).
	 *
	 * Then:
	 *
	 * $db = PDOProvider::db('someDbIdentifier');
	 *
	 *
	 * TODO:
	 *
	 * - Add an optional boolean param $forceReconnect, which will cause
	 * a new connection to be established (and cached for future calls
	 * to this function). It's not yet clear if we need that capability.
	 */
	public static function db($key = 'default'/* not yet used*/)
	{
		if( NULL != self::$db ) return self::$db;
		// reminder: the globals here will go away once PDO is completely in place.
		$c =& self::config($key);
		$dsn = @$c['dsn'];
		if( ! $dsn )
		{
			$dsn = $c['type']
				.':host='.$c['host']
				;
			$port = @$c['port'];
			if( $port ) {
				$dsn .= ';port='.$c['port'];
			}
			$dsn .= ';dbname='.$c['database'];
		}
		$attr = array(PDO::ATTR_ERRMODE=>PDO::ERRMODE_EXCEPTION);
		if (strncmp($dsn, 'oci', 3) == 0) {
			self::$db = new Oci8ToPdo($c['host'], $c['name'], $c['user'], $c['passwd'], $c['port'], $c['conn_str']);
		} else {
			self::$db = new PDO($dsn, $c['user'], $c['passwd'], $attr);
		}
		self::$db->driverName = substr($dsn, 0, strpos($dsn,':',3/*3==length of "oci"*/));
		return self::$db;
	}

	/**
	 * Returns a reference to a configuration object (array) which
	 * stores the db-related parameters for this class. $key is key
	 * string suitable for passing to db(), and db() calls config($key)
	 * to fetch its configuratio data.
	 *
	 * The returned reference is an array object, and the following array
	 * keys are relevant for purposes of this class:
	 *
	 * 'type' = db type (must currently be "mysql")
	 *
	 * 'host', 'port' = the host name/port numbers for the db
	 * server. The 'port' option is optional, and its default value
	 * is backend-specific.
	 *
	 * 'user', 'passwd' = the db login credentials
	 *
	 * 'dbname' = the name of the db within the db server.
	 *
	 * BE SURE, when modifying the returned object, that you catch it
	 * by reference:
	 *
	 * $foo =& PDOProvider::config();
	 */
	public static function & config($key='default')
	{
		$c =& self::$conf[$key];
		if( ! $c )
		{
			self::$conf[$key] = array();
			$c =& self::$conf[$key];
			/**
			 * Reminder to self:
			 *
			 * $c =& self::$conf[$key] = array();
			 *
			 * does not work.
			 *
			 * We're also not allowed to use a '@' prefix in combination
			 * with =&, but it works as expected with the = operator.
			 */
		}
		return $c;
	}
};

class MerlinPDO
{
	private static $pdo = NULL;
	const DBKEY = 'merlin';
	public static function db($type = 'mysql', $name = 'merlin', $user = 'merlin', $passwd = 'merlin', $host = 'localhost', $port = 3306, $conn_str=false)
	{
		if (NULL != self::$pdo)
			return $pdo;

		$c =& PDOProvider::config(self::DBKEY);
		if (stristr($type, 'mysql') !== false) {
			$c['dsn'] = "mysql:host=$host;dbname=$name";
		} elseif ($type === 'oci' || $type === 'oracle' || $type === 'ocilib') {
			$c['dsn'] = "oci:dbname=$name";
		}
		$c['host'] = $host;
		$c['name'] = $name;
		$c['user'] = $user;
		$c['passwd'] = $passwd;
		$c['port'] = $port;
		$c['conn_str'] = $conn_str;
		//print_r( $c );
		self::$pdo = PDOProvider::db(self::DBKEY)
			/* set up initial connection. will throw if a connection cannot be established. */;
		return self::$pdo;
	}
};
