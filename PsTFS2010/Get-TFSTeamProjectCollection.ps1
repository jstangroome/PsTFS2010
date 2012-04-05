function Get-TFSTeamProjectCollection {
    [CmdletBinding(DefaultParameterSetName='Collection')]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true, ParameterSetName='Collection')]
        [ValidatePattern('^https?://')]
        [Alias('Uri')]
        [string]
        $CollectionUri,

        [Parameter(Mandatory=$true, ParameterSetName='Server')]
        [Alias('Server')]
        $ConfigurationServer,
        
        [Parameter(ParameterSetName='Server')]
        [Alias('Name')]
        [string]
        $CollectionName = '*'
    )
    begin {
        $CollectionFactoryType = [Microsoft.TeamFoundation.Client.TfsTeamProjectCollectionFactory]
        $ResourceTypes = [Microsoft.TeamFoundation.Framework.Common.CatalogResourceTypes]
        [Guid[]]$CollectionFilter = @($ResourceTypes::ProjectCollection)
    }
    process {
        switch ($PSCmdlet.ParameterSetName) {
            Server {
                if ($ConfigurationServer -is [string]) {
                    $ConfigurationServer = Get-TfsConfigurationServer -Uri $ConfigurationServer
                }
                $LocationService = $ConfigurationServer.GetService([Microsoft.TeamFoundation.Framework.Client.ILocationService])
                $ConfigurationServer.CatalogNode.QueryChildren($CollectionFilter, $false, 'None') |
                    Where-Object { $_.Resource.DisplayName -like $CollectionName } |
                    ForEach-Object {
                        $CollectionFactoryType::GetTeamProjectCollection(
                            $LocationService.LocationForCurrentConnection(
                                $_.Resource.ServiceReferences['Location']            
                            )
                        )
                    }
            }
            Collection {
                $CollectionFactoryType::GetTeamProjectCollection($CollectionUri)
            }
        }
    }
}
