function Get-TFSBuildPermission {
    [CmdletBinding()]
    [OutputType('PsTFS2010.AccessControlEntry')]
    param (
        [Parameter(Mandatory=$true)]
        $Collection,

        [Parameter(Mandatory=$true)]
        $ProjectName,

        [Microsoft.TeamFoundation.Build.Client.IBuildDefinition]
        $BuildDefinition,

        [Microsoft.TeamFoundation.Framework.Client.IdentityDescriptor[]]
        $Descriptor = @()
    )

    if ($Collection -is [string] -or $Collection -is [Uri]) {
        $Collection = Get-TfsTeamProjectCollection -CollectionUri $Collection
    }

    $SecurityService = $Collection.GetService([Microsoft.TeamFoundation.Framework.Client.ISecurityService])
    $BuildSecurityNamespace = $SecurityService.GetSecurityNamespace([Microsoft.TeamFoundation.Build.Common.BuildSecurity]::BuildNamespaceId)

    $Project = Get-TFSTeamProject -Collection $Collection -ProjectName $ProjectName
    $SecurityToken = [Microsoft.TeamFoundation.LinkingUtilities]::DecodeUri($Project.Uri).ToolSpecificId

    if ($BuildDefinition) {
        $SecurityToken += [Microsoft.TeamFoundation.Build.Common.BuildSecurity]::NamespaceSeparator +
            [Microsoft.TeamFoundation.LinkingUtilities]::DecodeUri($BuildDefinition.Uri).ToolSpecificId
    }

    $IncludeExtendedInfo = $false
    $ACL = $BuildSecurityNamespace.QueryAccessControlList($SecurityToken, $Descriptor, $IncludeExtendedInfo)

    $Descriptors = $ACL.AccessControlEntries | Select-Object -ExpandProperty Descriptor
    $Identities = Get-TFSIdentity -Connection $Collection -Descriptor $Descriptors

    $ACL.AccessControlEntries |
        ForEach-Object {
            $ACE = $_
            $Result = New-Object -TypeName PSObject -Property @{
                Identity = $Identities |
                    Where-Object {
                        $_.Descriptor.Identifier -eq $ACE.Descriptor.Identifier -and
                        $_.Descriptor.IdentityType -eq $ACE.Descriptor.IdentityType
                    }
                Allow = [PsTFS2010.BuildPermissions]$_.Allow
                Deny = [PsTFS2010.BuildPermissions]$_.Deny
            }
            $Result.PSTypeNames.Insert(0, 'PsTFS2010.AccessControlEntry')
            Write-Output $Result
        }

}
