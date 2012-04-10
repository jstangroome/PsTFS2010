function Set-TFSTeamProjectPermission {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection]
        $Collection,

        [Parameter(Mandatory=$true, Position = 1)]
        [string]
        $ProjectName,

        [Parameter(Mandatory=$true, Position = 2)]
        [Microsoft.TeamFoundation.Framework.Client.IdentityDescriptor]
        $IdentityDescriptor,

        [PsTFS2010.AuthorizationProjectPermissions]
        $Allow = 0,

        [PsTFS2010.AuthorizationProjectPermissions]
        $Deny = 0,

        [switch]
        $Replace
    )
    
    $SecurityService = $Collection.GetService([Microsoft.TeamFoundation.Framework.Client.ISecurityService])
    $ProjectSecurityNamespace = $SecurityService.GetSecurityNamespace([Microsoft.TeamFoundation.Server.AuthorizationSecurityConstants]::ProjectSecurityGuid)

    $Project = Get-TFSTeamProject -Collection $Collection -Project $ProjectName
    $SecurityToken = [Microsoft.TeamFoundation.Server.AuthorizationSecurityConstants]::ProjectSecurityPrefix + $Project.Uri

    $Merge = -not [bool]$Replace
    $ProjectSecurityNamespace.SetPermissions($SecurityToken, $IdentityDescriptor, $Allow, $Deny, $Merge) | Out-Null
}
