# This script creates a postgreSQL datacluster for the pokedex project if it does not already
# exist. This script also will create a pokedex database, and user with appropriate permissions.
# This script should be only ran once as changes made by this script are persistent beyond
# executions and shutdowns.

# This script is for linux operating systems
# THIS SCRIPT IS RAN indirectly THROUGH THE setup.js FILE

psql_path=$(which psql)

# This function finds the path for the command passed into it and then runs the command
# @param: command name
# @outpu: command is ran after finding its path
execute(){
	echo -n $(find /opt -name $1; find /bin -name $1; find /usr -name $1)
}


if [ -z $psql_path ]
then
	echo "ERROR: Need to install PostgreSQL. " 1>&2
	echo "1) Be sure to not install pg_ctl and initdb in /sbin" 1>&2
	echo "2) After install be sure to reboot computer" 1>&2
else
	#Getting root password to run files and edit permissions
	loginAttempt=0
	isLoginSuccess="false"
	loginAttempts=3
	while [ $loginAttempt -lt $loginAttempts ] && [ $isLoginSuccess = "false" ]
	do
		stty -echo
		read -p "Enter root password: " psswd
		stty echo
		echo
		if echo $psswd | sudo -S -k echo worked 2>/dev/null 1>/dev/null
		then
			isLoginSuccess="true"
		elif [ $loginAttempt -eq $((loginAttempts-1)) ]
		then
			echo "root password incorrect"
			echo "exiting script"
			exit 1
		else
			echo "root password incorrect try again"
		fi
		
		loginAttempt=$((loginAttempt+1))
	done
	echo

	echo "Setting up PostgreSQL data cluster"
	postgre_data="../postgre_files/postgre_data"
	postgre_log="../postgre_files/postgre.log"
	if [ -z "$(ls ../postgre_files/postgre_data)" ]
	then
		echo "Creating new local postgre cluster"

		initdbPath=$(execute initdb)
		createdbPath=$(execute createdb)
		psqlPath=$(execute psql)

		#Change file permissions on setup programs to current user
		echo $psswd | sudo -S -k chown $USER $initdbPath 2>err.txt 1>/dev/null
		echo $psswd | sudo -S -k chown $USER $createdbPath 2>>err.txt 1>/dev/null
		echo $psswd | sudo -S -k chown $USER $psqlPath 2>>err.txt 1>/dev/null

		#running setup programs 
		$initdbPath -D $postgre_data
		$createdbPath
		$psqlPath -f ./setup.sql
	fi
	if [ -z $(cat /etc/group | grep -G '^postgres' | cut -f 4 -d ':' | grep -E "$USER(,(.*))?$") ]
	then
		echo "Adding user to postgres group"
		echo $psswd | sudo -S -k usermod -a -G postgres $USER
	fi
	pg_ctlPath=$(execute pg_ctl)
	$pg_ctlPath -D $postgre_data start > $postgre_log
	$pg_ctlPath -D $postgre_data status
fi
