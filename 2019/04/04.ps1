function global:Resolve-Password {
    [CmdletBinding()]
    Param (
        [ValidateScript({
            $ranges = $_ -split "-" | ForEach-Object { [int]::Parse($_) }
            if($ranges.Length -ne 2) {
                throw "Invalid input range"
            }

            if($ranges[0].Length -ne 6 -and $ranges[1].Length -ne 6) {
                throw "Invalid range length"
            }
        })]
        [string]$Input
    )
}