function global:Resolve-WireIntersection {
    [CmdletBinding()]
    Param (
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
        [string]$WireSchema
    )
}