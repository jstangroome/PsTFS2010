function Get-TFSTeamProjectPermission {
    [CmdletBinding()]
    [OutputType([PsTFS2010.AuthorizationProjectPermissions])]
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [Microsoft.TeamFoundation.Client.TfsTeamProjectCollection]
        $Collection,

        [Parameter(Mandatory=$true, Position = 1)]
        [string]
        $ProjectName,

        [Parameter(Mandatory=$true, Position = 2)]
        [Microsoft.TeamFoundation.Framework.Client.IdentityDescriptor]
        $IdentityDescriptor
    )
    
    $SecurityService = $Collection.GetService([Microsoft.TeamFoundation.Framework.Client.ISecurityService])
    $ProjectSecurityNamespace = $SecurityService.GetSecurityNamespace([Microsoft.TeamFoundation.Server.AuthorizationSecurityConstants]::ProjectSecurityGuid)

    $Project = Get-TFSTeamProject -Collection $Collection -ProjectName $ProjectName
    $SecurityToken = [Microsoft.TeamFoundation.Server.AuthorizationSecurityConstants]::ProjectSecurityPrefix + $Project.Uri

    [PsTFS2010.AuthorizationProjectPermissions]$ProjectSecurityNamespace.QueryEffectivePermissions($SecurityToken, $IdentityDescriptor)
}
