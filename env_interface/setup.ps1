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
    [string]$parentFolder,
    [string]$file
  )
  try{
    Get-ChildItem -Path $parentFolder -Recurse -Filter $file -ErrorAction SilentlyContinue
    write-host $childItems
  }
  catch{
    write-host "err"
  }
}

# Test if PostgreSQL is installed
$versionsInstalled = Get-Item -LiteralPath "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\PostgreSQL\Installations"
if($versionsInstalled.GetSubKeyNames() -gt 0){
    #Remember that these are relative paths. You must set the correct cwd in the setup.js for this script to function properly
    $postgre_data = "..\postgre_files\postgre_data"
    $postgre_log = "..\postgre_files\postgre.log"
    #Check to see if a datacluster was set up in postgre_data folder
    if(-not (Test-Path "$postgre_data\*")){
        Write-Host "Checking if access to necessary files is allowed"
        #Finding the pg_ctl file path and the psql file path
        $pg_ctlPath = findFile -parentFolder "\Program Files (x86)" -file "pg_ctl.exe"
        write-host $pg_ctlPath.FullNamer
        <#
        if($null -eq $pg_ctlPath){
            $pg_ctlPath = Get-ChildItem -Path "\Program Files" -Recurse -Filter "pg_ctl.exe"
        }
        write-host $pg_ctlPath.FullName#>
    }
}
else{
    Write-Host "ERROR: Need to install PostgreSQL"
    Write-Host "1) Be sure to install PostgeSQL files in \Program Files directory"
    Write-Host "2) After install be sure to reboot computer"
}