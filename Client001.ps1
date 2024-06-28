# Variables
$DomainName = Read-Host "Wat is je Domeinnaam?"
$DomainNetbiosName = Read-Host "Wat is je netbios naam"
$Password = Read-Host "Wat wil je als standaarwachtwoord gebruiken"
$AdminPassword = ConvertTo-SecureString $Password -AsPlainText -Force

# Configure Network Settings
New-NetIPAddress -InterfaceAlias "Ethernet" -IPAddress "10.10.10.2" -PrefixLength 8 -DefaultGateway "10.10.10.1"
Set-DnsClientServerAddress -InterfaceAlias "Ethernet" -ServerAddresses ("10.10.10.2")

# Create OUs and Users
Import-Module ActiveDirectory

# Create OUs
New-ADOrganizationalUnit -Name "Directie" -Path "DC=$DomainNetbiosName,DC=local"
New-ADOrganizationalUnit -Name "Inkoop" -Path "DC=$DomainNetbiosName,DC=local"
New-ADOrganizationalUnit -Name "Klantenservice" -Path "DC=$DomainNetbiosName,DC=local"
New-ADOrganizationalUnit -Name "TestUsers" -Path "DC=$DomainNetbiosName,DC=local"

# Create Users in Directie
New-ADUser -Name "Gerrit" -GivenName "Gerrit" -Surname "Directie" -UserPrincipalName "Gerrit@$DomainName" -Path "OU=Directie,DC=$DomainNetbiosName,DC=local" -AccountPassword $AdminPassword -Enabled $true
New-ADUser -Name "Eva" -GivenName "Eva" -Surname "Directie" -UserPrincipalName "Eva@$DomainName" -Path "OU=Directie,DC=$DomainNetbiosName,DC=local" -AccountPassword $AdminPassword -Enabled $true

# Create Users in Inkoop
$InkoopUsers = @("Erik", "Chris", "Jolanda", "Gerda", "Jules", "Julia", "Maarten", "Cleo")
foreach ($user in $InkoopUsers) {
    New-ADUser -Name $user -GivenName $user -Surname "Inkoop" -UserPrincipalName "$user@$DomainName" -Path "OU=Inkoop,DC=$DomainNetbiosName,DC=local" -AccountPassword $AdminPassword -Enabled $true
}

# Create Users in Klantenservice
$KlantenserviceUsers = @("MaartenL", "ElsM", "Pieter", "Perry")
foreach ($user in $KlantenserviceUsers) {
    New-ADUser -Name $user -GivenName $user -Surname "Klantenservice" -UserPrincipalName "$user@$DomainName" -Path "OU=Klantenservice,DC=$DomainNetbiosName,DC=local" -AccountPassword $AdminPassword -Enabled $true
}

# Create Test Users
for ($i=1; $i -le 20; $i++) {
    $testUser = "test$i"
    New-ADUser -Name $testUser -GivenName $testUser -Surname "Test" -UserPrincipalName "$testUser@$DomainName" -Path "OU=TestUsers,DC=$DomainNetbiosName,DC=local" -AccountPassword $AdminPassword -Enabled $true
}
