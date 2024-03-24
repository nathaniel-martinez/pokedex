$pidForPort5432 = @(netstat -abon)# | findstr 5432)# | foreach-object {($_ -split " ")})#[-1]
Write-Host $pidForPort5432
#if(-not ($null -eq $pidForPort5432)){
#    throw "Error Port 5432 is already in use by a process with id: $pidForPort5432`n`tTo run script, first kill the process"
#}