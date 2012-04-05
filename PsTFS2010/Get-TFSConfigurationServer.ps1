function Get-TFSConfigurationServer {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
        $Uri
    )

    process {
        return [Microsoft.TeamFoundation.Client.TfsConfigurationServerFactory]::GetConfigurationServer($Uri)
    }

}
