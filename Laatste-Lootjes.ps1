# Variables
$domainName = "Milan.local"
$backupLocation = "\\MilanDC002\BackupShare"

# Function to configure screen lock
function Configure-ScreenLock {
    param (
        [string]$gpoName,
        [string]$targetOU
    )

    # Check if GPO exists, otherwise create it
    if (-not (Get-GPO -Name $gpoName -ErrorAction SilentlyContinue)) {
        New-GPO -Name $gpoName
    }

    # Set GPO settings
    $gpo = Get-GPO -Name $gpoName
    Set-GPRegistryValue -Name $gpoName -Key "HKCU\Control Panel\Desktop" -ValueName "ScreenSaveActive" -Type String -Value "1"
    Set-GPRegistryValue -Name $gpoName -Key "HKCU\Control Panel\Desktop" -ValueName "ScreenSaverIsSecure" -Type String -Value "1"
    Set-GPRegistryValue -Name $gpoName -Key "HKCU\Control Panel\Desktop" -ValueName "ScreenSaveTimeOut" -Type String -Value "600"

    # Link GPO to the target OU
    New-GPLink -Name $gpoName -Target $targetOU
}

# Function to configure scheduled backups
function Configure-Backups {
    param (
        [string]$backupLocation
    )

    # Install Windows Server Backup feature
    Install-WindowsFeature -Name Windows-Server-Backup

    # Create a scheduled task for backup
    $action = New-ScheduledTaskAction -Execute "wbadmin" -Argument "start backup -backupTarget:$backupLocation -include:C: -allCritical -quiet"
    $trigger = New-ScheduledTaskTrigger -Daily -At "02:00AM"
    $principal = New-ScheduledTaskPrincipal -UserId "SYSTEM" -LogonType ServiceAccount -RunLevel Highest

    $taskName = "DailySystemBackup"
    Register-ScheduledTask -Action $action -Trigger $trigger -Principal $principal -TaskName $taskName -Description "Daily backup of critical system files and C: drive"
}

# Configure screen lock for both DCs
Configure-ScreenLock -gpoName "ScreenLockPolicy" -targetOU "DC=$domainName"

# Configure backups for both DCs
Configure-Backups -backupLocation $backupLocation

# Output
Write-Output "Screen lock and scheduled backups have been configured for both DCs."
