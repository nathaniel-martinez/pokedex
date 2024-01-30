# This script creates a postgreSQL datacluster for the pokedex project if it does not already
# exist. This script also will create a pokedex database, and user with appropriate permissions.
# This script should be only ran once as changes made by this script are persistent beyond
# executions and shutdowns.

# This script is for linux operating systems
# THIS SCRIPT IS RAN indirectly THROUGH THE setup.js FILE

psql_path=$(which psql)

# This function finds the path for the command name passed into it and then runs the command
# Can also filter the file paths returned based on conditional tests pased to the function
# @param: [ -c "conditionalFunction" must be coverd in quotes ] command name
# @outpu: command is ran after finding its path
filePaths(){
	case $1 in
		"-c")
			local allPaths path filteredPaths onlyPath
			allPaths="$(find /opt -name $3; find /bin -name $3; find /usr -name $3)"
			onlyPath="true"
			for path in $allPaths
			do
				if [ $onlyPath = "true" ] && test $2 $path
				then
					filteredPaths=$path
					onlyPath="false"
				elif test $2 $path
				then
					filteredPaths="$filteredPaths $path"
				fi
			done
			echo -n $filteredPaths
			;;
		*)
			echo -n "$(find /opt -name $1; find /bin -name $1; find /usr -name $1)"
	esac
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
	loginAttempts=0
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


	pg_ctlPath=$(filePaths pg_ctl)
	psqlPath=$(filePaths -c "-h" psql)


	postgre_data="../postgre_files/postgre_data"
	postgre_log="../postgre_files/postgre.log"
	if [ -z "$(ls ../postgre_files/postgre_data)" ]
	then
		echo "Creating new local postgre cluster"

		#initdbPath=$(filePaths initdb)
		#createdbPath=$(filePaths createdb)
		#psqlPath=$(filePaths psql)
		#pg_ctlPath=$(filePaths pg_ctl)

		#initdbPath=$(realpath $(filePaths initdb))
		#createdbPath=$(realpath $(filePaths createdb))
		#psqlPath=$(realpath $(filePaths psql))
		#printf "\n\n Printing out real paths"
		#echo $initdbPath
		#echo $createdbPath
		#echo $psqlPath

		#Change file permissions on setup programs to current user
		#echo $psswd | sudo -S -k chown $USER $initdbPath 2>err.txt 1>/dev/null
		#echo $psswd | sudo -S -k chown $USER $createdbPath 2>>err.txt 1>/dev/null
		#echo $psswd | sudo -S -k chown $USER $psqlPath 2>>err.txt 1>/dev/null

		#running setup programs 
		$pg_ctlPath init -D $postgre_data
		$pg_ctlPath -D $postgre_data -l $postgre_log start
		$psqlPath -f ./setup.sql
	fi
	if [ -z $(cat /etc/group | grep -G '^postgres' | cut -f 4 -d ':' | grep -E "$USER(,(.*))?$") ]
	then
		echo "Adding user to postgres group"
		echo $psswd | sudo -S -k usermod -a -G postgres $USER
	fi
	#$pg_ctlPath -D $postgre_data start > $postgre_log
	#$pg_ctlPath -D $postgre_data status
fi
