# Zorg ervoor dat je het script uitvoert met administrator rechten

# Installeer Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; 
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; 
iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

# Wacht even tot Chocolatey is geïnstalleerd
Start-Sleep -Seconds 20

# Installeer OpenOffice
choco install openoffice -y

# Installeer 7zip
choco install 7zip -y

# Installeer Malwarebytes
choco install malwarebytes -y

# Installeer AVG Antivirus Free (let op: dit is geen demo, maar de gratis versie)
choco install avgantivirusfree -y

# Installeer Adobe Acrobat Reader
choco install adobereader -y

# Installeer Google Chrome
choco install googlechrome -y

# Installeer TeamViewer
choco install teamviewer -y

# Update alle geïnstalleerde pakketten
choco upgrade all -y

# Zorg ervoor dat de Windows Firewall is ingeschakeld
Set-NetFirewallProfile -Profile Domain,Public,Private -Enabled True

# Voer een snelle virusscan uit met Windows Defender
Start-MpScan -ScanType QuickScan

Write-Output "Alle taken zijn voltooid."