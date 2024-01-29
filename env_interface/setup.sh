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
	echo "Setting up PostgreSQL data cluster"
	postgre_data="../postgre_files/postgre_data"
	postgre_log="../postgre_files/postgre.log"
	if [ -z "$(ls ../postgre_files/postgre_data)" ]
	then
		echo "Creating new local postgre cluster"
		#Repeat loging three times untill root password is valid
		loginAttempt=0
		isLoginSuccess="false"
		loginAttempts=3
		stty -echo
		while [ $loginAttempt -lt $loginAttempts ] && [ $isLoginSuccess = "false" ]
		do
			read -p "Enter root password: " psswd
			echo
			if echo $psswd | sudo -S -k echo worked 2>/dev/null 1>/dev/null
			then
				isLoginSuccess="true"
			else
				echo "root password incorrect try again"
			fi
			
			loginAttempt=$((loginAttempt+1))
		done
		stty echo
		echo
		#$(execute initdb) -D $postgre_data

		#$(execute createdb)
		#$(execute psql) -f ./setup.sql
	fi
	if [ -z $(cat /etc/group | grep -G '^postgres' | cut -f 4 -d ':' | grep -E "$USER(,(.*))?$") ]
	then
		echo "Adding user to postgres group"
		#sudo usermod -a -G postgres $USER
	fi
	#$(execute pg_ctl) -D $postgre_data start > $postgre_log
	#$(execute pg_ctl) -D $postgre_data status
fi
