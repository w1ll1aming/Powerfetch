#region Include required files
try {
    Import-Module ("$PSScriptRoot/retrive-data.psm1") -Force <# Include script to retrive system data from host system. #>
    Import-Module ("$PSScriptRoot/logos.psm1") -Force <# Include a variety of usefull functions. #>
    Import-Module ("$PSScriptRoot/misc.psm1") -Force <# Include a variety of usefull functions. #>
}
catch [System.SystemException] { Write-Host "Fetch.ps1: Error while loading supporting PowerShell scripts;"; Write-Host "error: '$_'" }
#endregion

$asciicolor = "Blue"
$textcolor = "Blue"
$textcolor_username = "Blue"

$pslogo = getLogo;
$SystemInfo_Titles = getInfo_Titles;
$SystemInfo = getInfo;

$i=-1;
$delimiter = "@"
foreach ($part in $pslogo) {
    $i++;
    Write-Color "${part}","" "$asciicolor" $false
    if ($i -eq 1) { $delimiter = "" }
    if ($i -eq 2) { $delimiter = ": " }
    foreach ($info in $SystemInfo[$i]) {
        Write-Color "$($SystemInfo_Titles[$i])","${delimiter}$($info) " "$textcolor" "$textcolor_username"
    }
    if ($i -gt $SystemInfo.count-1 ) { Write-Host "" }
}; Clear-Variable i