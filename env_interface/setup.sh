psql_path=$(which psql)

init_dbF(){
	echo -n $(find /opt -name initdb; find /bin -name initdb; find /usr -name initdb)
}

pg_ctlF(){
	echo -n $(find /opt -name pg_ctl; find /bin -name pg_ctl; find /usr -name pg_ctl)
}

if [ -z $psql_path ]
then
	echo  "ERROR: Need to install PostgreSQL. Install and then run program again. " 1>&2
else
	echo "Setting up PostgreSQL data cluster"
	postgre_data="../postgre_files/postgre_data"
	postgre_log="../postgre_files/postgre.log"
	if [ -z "$(ls ../postgre_files/postgre_data)" ]
	then
		echo "Creating new local postgre cluster"
		$(init_dbF) -D $postgre_data
		su $(pg_ctlF) -D $postgre_data start > $postgre_log
	elif [ -z "hi" ]
	then
		echo "hi"
	else
		su $(pg_ctlF) -D $postgre_data start > $postgre_log
		$(pg_ctlF) -D $postgre_data status
	fi
fi
