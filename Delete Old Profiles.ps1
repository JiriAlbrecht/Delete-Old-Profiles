#######################
# Delete Old Profiles #
#######################
###
###
###################################
# Author: Jiri Albrecht           #
# https://github.com/JiriAlbrecht #
###################################
###
###
###################################
# Run PowerShell as administrator #
###################################
###
###
###
################################################
# Delete profiles unused for more than 60 days #
################################################
# 
# set-executionpolicy remotesigned # Run in case of error #
#
$MaxInactiveTime = 60 # Set maximum inactivity time #

# Exclude List
$ExcludeList = @("public","administrator","default","all users","ladmin","default user","admin") # Exceptions in deletion #

# Setting the inactivity profile in days #
$InactiveTime = (Get-Date).AddDays(-$MaxInactiveTime) 

$Users = Get-CimInstance -Class Win32_UserProfile | Where-Object { $_.Special -eq $false -and $_.LastUseTime -lt $InactiveTime }

$Number = 0

:OuterLoop
foreach ($User in $Users) {

    foreach ($name in $ExcludeList) {
   
        if ($User.localpath -like "*\$name") {
            continue OuterLoop
        }
    }

    Remove-CimInstance -InputObject $User
    $Number ++
    
}

Write-Host "Delete old profiles: " $Number

