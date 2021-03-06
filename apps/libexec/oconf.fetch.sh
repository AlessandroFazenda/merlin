#!/bin/sh

usage()
{
	cat << END_OF_HELP
usage: mon oconf fetch [options] <node>

Where options can be any of:

	<node>           Try to fetch config from this node
	--help           This helptext

NOTE: this script requires that you have a object_config variable
named fetch_name where it equals to the name the node has on the 
master, to be able to fetch the right config.
	
END_OF_HELP
exit
}

source=
while test "$#" -ne 0; do
	case "$1" in
	--help|-h)
		usage
	;;
	*)
		echo "Fetch config from node: $1"
		oconf_ssh_port=false
		source=$(mon node show "$1" | sed -n 's/^ADDRESS=//p')
		oconf_ssh_port=$(mon node show "$1" | sed -n 's/^OCONF_SSH_PORT=//p')
		fetch_name=$(mon node show "$1" | sed -n 's/^OCONF_FETCH_NAME=//p')
		if [ $oconf_ssh_port ]; then
			if [ ! $oconf_ssh_port -eq $oconf_ssh_port 2>/dev/null ]; then
				source="$source"
			else
				source="$source:$oconf_ssh_port"
			fi
		fi
	;;
	esac
	shift
done

ssh_prefix=
scp_prefix=
dest=

for dest in $source; do
	master=$(echo $dest | cut -d':' -f 1)
	oconf_ssh_port=$(echo $dest | cut -d':' -f 2)

	if [ $oconf_ssh_port -eq $oconf_ssh_port 2>/dev/null ]; then
		ssh_prefix="-p $oconf_ssh_port"
		scp_prefix="-P $oconf_ssh_port"
	else
		ssh_prefix=
		scp_prefix=
	fi

if [ $dest ]; then
	echo "Fetching config from $source"
	echo "ssh $ssh_prefix root@$master mon oconf nodesplit"
	ssh $ssh_prefix root@$master mon oconf nodesplit

	echo "Verify if a update is needed"
	local_md5=$(cat /opt/monitor/etc/oconf/from-master.cfg | md5sum)
	remote_md5=$(ssh $ssh_prefix root@$master cat /var/cache/merlin/config/$fetch_name.cfg | md5sum)

	if [ "$local_md5" == "$remote_md5" ]; then
		echo "Same md5sum, no need for a fetch, exiting"
		exit
	else
		echo "scp $scp_prefix root@$master:/var/cache/merlin/config/$fetch_name.cfg /opt/monitor/etc/oconf/from-master.cfg"
		scp $scp_prefix root@$master:/var/cache/merlin/config/$fetch_name.cfg /opt/monitor/etc/oconf/from-master.cfg
		echo "Restarting local instance"
		mon restart
	fi
fi
done
