<#
This script creates a postgreSQL datacluster for the pokedex project if it does not already
exist. This script also will create a pokedex database, and user with appropriate permissions

This script should be only ran once as changes made by this script are persistent beyond executions and shutdowns.

This script is for Windows operating systems with powershell
THIS SCRIPT IS RAN indirectly THROUGH THE setup.js FILE
#>

<#
This function loops through a directory to find the given file. If it is unable to access the file, it will throw an error and return $null
@param: parentFolder Name, file pattern to match
@ouput: realFile path or null 
#>
function findFile{
    param(
        [string]$file
    )
    $x64Path = @(Get-ChildItem -Path "C:\Program Files" -Recurse -Filter $file -ErrorAction SilentlyContinue | ForEach-Object {if($_.FullName -notmatch "pgAdmin"){$_.FullName}})
    $x32Path = @(Get-ChildItem -Path "C:\Program Files (x86)" -Recurse -Filter $file -ErrorAction SilentlyContinue | ForEach-Object { if($_.FullName -notmatch "pgAdmin"){$_.FullName}})
    if(($x64Path.Length -eq 1) -and ($x32Path.Length -eq 0)){
        Write-Output $x64Path[0]
    }
    elseif(($x64Path.Length -eq 0) -and ($x32Path.Length -eq 1)){
        Write-Output $x32Path[0]
    }
    elseif(($x64Path.Length -eq 0) -and ($x32Path.Length -eq 0)){
        throw "ERROR: $file is not found`nChecked '\Program Files' and '\Program Files (x86)'`n"+ $x64Path + "`n" + $x32Path
    }
    else{  
        throw "ERROR: More then one $file found`nChecked '\Program Files' and '\Program Files (x86)'`n" + $x64Path + "`n" + $x32Path
    }
}

try{
    # Test if PostgreSQL is installed
    $versionsInstalled = Get-Item -LiteralPath "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\PostgreSQL\Installations" -ErrorAction Stop
    #    if($versionsInstalled.GetSubKeyNames() -gt 0){

    #Remember that these are relative paths. You must set the correct cwd in the setup.js for this script to function properly

    $postgre_data = "..\postgre_files\postgre_data"
    $postgre_log = "..\postgre_files\postgre.log"
    $pg_ctlPath = $(findFile -file "pg_ctl.exe")
    $psqlPath = $(findFile -file "psql.exe")

    #Check to see if a datacluster was set up in postgre_data folder
    if(-not (Test-Path "$postgre_data\*")){
        Write-Host '***Creating DataBase***'
        & "$pg_ctlPath" init -D "$postgre_data"
    }

    $pidForPort5432 = @(netstat -aon | findstr 5432 | foreach-object {($_ -split " ")[-1]})[-1]
    if(-not ($null -eq $pidForPort5432)){
        throw "Error Port 5432 is already in use by a process with id: $pidForPort5432`n`tTo run script, first kill the process"
    }

    Write-Host '***Starting Process***'
    Clear-Content -Path "$postgre_log"
    & "$pg_ctlPath" -D "$postgre_data" -l "$postgre_log" start

    $name = [System.Security.Principal.WindowsIdentity]::GetCurrent().Name.split("\\")[-1]
    write-host $name
    Write-Host '***Modifying Database***'
    $psqlInstr = @"
CREATE USER pokedexuser WITH PASSWORD 'pokedex';
CREATE DATABASE "$name";
CREATE DATABASE pokedexuser;
CREATE DATABASE pokedexdb;
REVOKE ALL ON DATABASE pokedexdb FROM pokedexuser;
GRANT CONNECT ON DATABASE pokedexdb TO pokedexuser;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO pokedexuser;
"@
    #Write-Host $psqlInstr
    $psqlInstr | & "$psqlPath" -d template1
}
catch [System.Management.Automation.ItemNotFoundException]{
    Write-Host @"
ERROR Need to install PostgreSQL:
    1) Be sure to install PostgeSQL files in \Program Files directory
    2) After install be sure to reboot computer
"@
}
catch {
    Write-Host $_.Exception.Message
}