@echo off
REM This script creates a postgreSQL datacluster for the pokedex project if it does not already
REM  exist. This script also will create a pokedex database, and user with appropriate permissions
REM This script should be only ran once as changes made by this script are persistent beyond

REM executions and shutdowns.

REM This script is for linux operating systems
REM THIS SCRIPT IS RAN indirectly THROUGH THE setup.js FILE


setlocal
setlocal enabledelayedexpansion

REM Remember the space after call that sets ERRORLEVEL to 0
REM Checking if postgreSQL is installed by testing if there exists subkeys in the PostgreSQL\Installations registry

REG QUERY HKEY_LOCAL_MACHINE\SOFTWARE\PostgreSQL\Installations\ /S >nul && (
    echo Setting up PostgreSQL data cluster

    set "postgre_data=..\postgre_files\postgre_data"
    set "postgre_log=..\postgre_files\postgre.log"
    REM Checking if there is content in the postgre_data directory to determine if a datacluster exists there
    dir /A /B "!postgre_data!" | findstr "." >nul || (
        echo Creating new local postgre cluster
        REM finding the initdb file path
        set "pg_ctlPath=empty"
        call :filepath "\Program Files" pg_ctl.exe pg_ctlPath || call :filepath "\Program Files (x86)" pg_ctl.exe pg_ctlPath
        "!pg_ctlPath!" -D "!postgre_data!" initdb
        "break>!pg_ctlPath!"
        REM"!pg_ctlPath!" -D "!postgre_data!" -l "!postgre_log!" start
    )    
    call 
) || (
    echo "ERROR: Need to install PostgreSQL" 1>&2
    echo "1) Be sure to install PostgeSQL files in \Program Files directory" 1>&2
    echo "2) After install be sure to reboot computer" 1>&2
)

EXIT \b 0

REM This subroutine finds the filepath of an executable and then returns that filepath
REM input: Filepath which has the executable, name of executable, variable to store executable path
REM output: Filepath of executabele
:filepath
FOR /R %1 %%a in ("*%2*") do (
    set "%3=%%a"
)
EXIt /b 1

REM This subroutine finds the filepath of the executable in the parent directory and then runs that executable
REM input: "parent directory to search for executable" "executable name" "flags and parameters of executable"
REM output: exit code is based on wether there was a succesful execution of the executabe
:execute
for /R %1 %%a in ("*%~2*") do (
    "%%a" %~3
    EXIT /b 0
)
EXIT /b 1