# This script creates a postgreSQL datacluster for the pokedex project if it does not already
# exist. This script also will create a pokedex database, and user with appropriate permissions.
# This script should be only ran once as changes made by this script are persistent beyond
# executions and shutdowns.

# This script is for linux operating systems
# THIS SCRIPT IS RAN indirectly THROUGH THE setup.js FILE

psql_path=$(which psql)


init_dbF(){
	echo -n $(find /opt -name initdb; find /bin -name initdb; find /usr -name initdb)
}

pg_ctlF(){
	echo -n $(find /opt -name pg_ctl; find /bin -name pg_ctl; find /usr -name pg_ctl)
}

psqlF(){
        echo -n $(find /opt -name psql; find /bin -name psql; find /usr -name psql)
}


if [ -z $psql_path ]
then
	echo "ERROR: Need to install PostgreSQL. " 1>&2
	echo "1) Be sure to not install pg_ctl and initdb in /sbin" 1>&2
    echo "2) After install be sure to reboot computer" 1>&2
else
	echo "Setting up PostgreSQL data cluster"
	postgre_data="../postgre_files/postgre_data"
	postgre_log="../postgre_files/postgre.log"
	if [ -z "$(ls ../postgre_files/postgre_data)" ]
	then
		echo "Creating new local postgre cluster"
		$(init_dbF) -D $postgre_data
		$(psqlF) -f ./setup.sql
	fi
	if [ -z $(cat /etc/group | grep -G '^postgres' | cut -f 4 -d ':' | grep -E "$USER(,(.*))?$") ]
	then
		echo "Adding user to postgres group"
		sudo usermod -a -G postgres $USER
	fi
	$(pg_ctlF) -D $postgre_data start > $postgre_log
	$(pg_ctlF) -D $postgre_data status
fi
