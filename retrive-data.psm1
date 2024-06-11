try { Import-Module ("$PSScriptRoot/misc.psm1") -Force <# Include a variety of usefull functions. #> }
catch [System.SystemException] { Write-Host "Error while loading supporting PowerShell scripts;"; Write-Host "error: '$_'" }

$CPU = ((Get-WMIObject win32_Processor).Name)
$Machinename = ((Get-WmiObject Win32_OperatingSystem).CSName)
$Machinemodel = ((Get-WmiObject Win32_ComputerSystem).Model)

$User = ($env:Username)

$baseboard_inf = (Get-WmiObject win32_baseboard)
$Baseboard = "$($baseboard_inf.Manufacturer) $($baseboard_inf.Model)"

$OS_Version = (([System.Environment]::OSVersion.Version).Build)
$OS = (Get-CimInstance -ClassName Win32_OperatingSystem)

$Shell_name = "Powershell"
$Shell_version = $($PSVersionTable.PSVersion.ToString())
$Shell = $Shell_name+" "+$Shell_version

$Lastreboot = (Get-Date -Date $os.LastBootUpTime -Format 'MMM dd, yyyy HH:mm:ss fffff')
$shellhost_pid=((gwmi win32_process -Filter "processid='$pid'").parentprocessid)
$Terminal = ((Get-Process -id $shellhost_pid).Name)

$disk_info = (Get-CimInstance -ClassName Win32_DiskDrive)
$Disk_labels = ($disk_info | foreach-object {(
    "$($_.Model)")
})

$gpu_inf = (Get-CimInstance Win32_DisplayConfiguration)
$GPUs = ($gpu_inf | foreach-object {(
    "$($_.Caption)")
})

$Total_ram = ([math]::Truncate((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1MB));
$Free_ram = ([math]::Truncate((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1KB));
$Used_ram = $Total_ram - $Free_ram;
$Free_ram_percent = "{0:N0}" -f ($Free_ram / $Total_ram * 100);
$Used_ram_percent = "{0:N0}" -f ($Used_ram / $Total_ram * 100);

$RAM = "${used_ram}MB / ${total_ram}MB ($Used_ram_percent%)"

$disk_inf = (Get-CimInstance win32_logicaldisk)
$Disks = ($disk_inf | foreach-object {(
    "$('{0:N2}GB' -f ($_.FreeSpace/1gb)) / $('{0:N2}GB' -f ($_.Size/1gb))") 
})

$disk_captions = ($disk_inf | foreach-object {(
    "$($_.Caption)")
})

$divider = cgen '-' ($Machinename + "@" + $User).length

function getInfo() {
    [System.Collections.ArrayList] $SystemInfo = 
        $User,
        $divider,
        $os.Caption,
        $OS_Version,
        $Lastreboot,
        $Baseboard,
        $Shell,
        $Terminal,
        $CPU,
        $GPUs,
        $Machinemodel,
        $RAM
    ;
    
    foreach ($disk in $Disks) { [void]$SystemInfo.Add($disk) }
    return $SystemInfo
}

function getInfo_Titles {
    $SystemInfo_Titles = @{
        0 = $Machinename;
        1 = "";
        2 = "OS"; 
        3 = "OS Version";
        4 = "Last reboot";
        5 = "Baseboard";
        6 = "Shell";
        7 = "Terminal";
        8 = "CPU";
        9 = "GPU";
        10 = "Machine Model";
        11 = "RAM";
    };

    foreach ($disk_caption in $disk_captions) {
        [void]$SystemInfo_Titles.Add($SystemInfo_Titles.count, $disk_caption.split(":", [System.StringSplitOptions]::RemoveEmptyEntries))
    }

    return $SystemInfo_Titles
}