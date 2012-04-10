function Get-TFSIdentity {
    [CmdletBinding(DefaultParameterSetName='Search')]
    param (
        [Parameter(Mandatory=$true, Position = 0)]
        [Alias('Collection', 'Server', 'ConfigurationServer')]
        [Microsoft.TeamFoundation.Client.TfsConnection]
        $Connection,

        [Parameter(ParameterSetName='Search', Mandatory=$true, Position = 1)]
        [Alias('DisplayName', 'AccountName')]
        [string]
        $Name,

        [Parameter(ParameterSetName='Search')]
        [Microsoft.TeamFoundation.Framework.Common.IdentitySearchFactor]
        $SearchFactor = 'DisplayName',

        [Parameter(ParameterSetName='Descriptor', Mandatory=$true)]
        [Microsoft.TeamFoundation.Framework.Client.IdentityDescriptor[]]
        $Descriptor,

        [Microsoft.TeamFoundation.Framework.Common.MembershipQuery]
        $Membership = 'None',

        [Microsoft.TeamFoundation.Framework.Common.ReadIdentityOptions]
        $Options = 'None'
    )

    $IdentityManagementService = $Connection.GetService([Microsoft.TeamFoundation.Framework.Client.IIdentityManagementService])

    switch ($PSCmdlet.ParameterSetname) {
        Descriptor {
            $IdentityManagementService.ReadIdentity($Descriptor, $Membership, $Options)
        }
        default {
            $IdentityManagementService.ReadIdentity($SearchFactor, $Name, $Membership, $Options)
        }
    }
}
