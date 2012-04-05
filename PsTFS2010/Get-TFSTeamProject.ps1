function Get-TFSTeamProject {
    [CmdletBinding()]
    param (
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        $Collection,

        [Parameter(Position=1)]
        [Alias('Name')]
        [string]
        $ProjectName = '*',

        [switch]
        $All
    )

    process {
        if ($Collection -is [string] -or $Collection -is [Uri]) {
            $Collection = Get-TfsTeamProjectCollection -CollectionUri $Collection
        }

        $StructureService = $Collection.GetService([Microsoft.TeamFoundation.Server.ICommonStructureService3])
        if ($All) {
            $Projects = $StructureService.ListAllProjects()
        } else {
            $Projects = $StructureService.ListProjects()
        }

        $Projects |
            Where-Object { $_.Name -like $ProjectName } |
            Add-Member -MemberType NoteProperty -Name Collection -Value $Collection -PassThru
    }
}