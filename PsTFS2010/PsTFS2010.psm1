Set-StrictMode -Version Latest
$script:ErrorActionPreference = 'Stop'

Add-Type -Path $PSScriptRoot\AuthorizationProjectPermissions.cs

. $PSScriptRoot\Get-TFSConfigurationServer.ps1
. $PSScriptRoot\Get-TFSTeamProjectCollection.ps1
. $PSScriptRoot\Get-TFSTeamProject.ps1
. $PSScriptRoot\Get-TFSTeamProjectPermission.ps1
. $PSScriptRoot\Set-TFSTeamProjectPermission.ps1
. $PSScriptRoot\Get-TFSIdentity.ps1
. $PSScriptRoot\Get-TFSBuildPermission.ps1
