REM This script creates a postgreSQL datacluster for the pokedex project if it does not already
REM  exist. This script also will create a pokedex database, and user with appropriate permissions
REM This script should be only ran once as changes made by this script are persistent beyond

REM executions and shutdowns.

REM This script is for linux operating systems
REM THIS SCRIPT IS RAN indirectly THROUGH THE setup.js FILE

@echo off
setlocal
setlocal enabledelayedexpansion

where \q psqlj
where \q psqlj
