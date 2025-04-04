#
# Downloads and installs a local 64bit Windows Atom
#
# $User: The user to use when authenticating against AtomSphere
# $Password: The user's password
# $AtomName: The name to use for the new Atom
# $AccountId = The account where the Atom is being installed
# $AtomDirectory = The base directory where the Atom will be installed

Param(
    [string]$BoomiAuthenticationType,
    [string]$User,
    [string]$Password,
    [string]$installToken,
    [string]$AtomName=$(throw "AtomName is mandatory, please provide a value."),
    [string]$AccountId=$(throw "AccountId is mandatory, please provide a value."),
    [string]$AtomDirectory=$(throw "AtomDirectory is mandatory, please provide a value.")
)

$Installer = "$PSScriptRoot\installer.sh"

# Force TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

# Create a custom User Agent
$UserAgent = 'Boomi/AzureMarketplace'

# Download the latest installer from platform
Invoke-WebRequest -Uri 'https://platform.boomi.com/atom/atom_install64.sh' -UserAgent $UserAgent -OutFile $Installer

# Create Args

if ( $BoomiAuthenticationType.Trim() -eq "Token" )
{
    $InstallerArgs = @("-q", "`"-VinstallToken=$installToken`"", "`"-VatomName=$AtomName`"", "`"-VaccountId=$AccountId`"",  "-dir", "`"$AtomDirectory`"")
}
else {
    $InstallerArgs = @("-q", "`"-Vusername=$User`"", "`"-Vpassword=$Password`"", "`"-VatomName=$AtomName`"", "`"-VaccountId=$AccountId`"",  "-dir", "`"$AtomDirectory`"")  
}

# Run the installer
Start-Process -FilePath $Installer -ArgumentList $InstallerArgs -WindowStyle Hidden -Wait
