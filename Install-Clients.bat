@echo off

:: Ensure the script is run with administrator privileges
net session >nul 2>&1
if %errorLevel% neq 0 (
    echo Please run this script as an administrator.
    pause
    exit /b
)

:: Install Chocolatey using the provided script
powershell -NoProfile -ExecutionPolicy Bypass -Command "Set-ExecutionPolicy Bypass -Scope Process; iex ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/Milanotje/Eindopdracht-Netwerken/main/Chocolatey-Install.ps1'))"

:: Verify Chocolatey installation
choco -v
if %errorLevel% neq 0 (
    echo Chocolatey installation failed.
    pause
    exit /b
)

:: Update Chocolatey
choco upgrade chocolatey -y

:: Install requested programs
choco install openoffice -y
choco install 7zip -y
choco install malwarebytes -y
choco install avgantivirusfree -y
choco install adobe-reader -y
choco install googlechrome -y
choco install teamviewer -y

:: Update all installed packages
choco upgrade all -y

:: Enable Windows Firewall
netsh advfirewall set allprofiles state on

:: Run a virus scan
"%ProgramFiles%\AVG\Antivirus\avgscan" /scan /report

echo.
echo All installations and configurations are complete.
echo Please restart your computer for all changes to take effect.
pause
