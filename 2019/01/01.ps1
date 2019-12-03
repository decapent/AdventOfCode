
function global:Measure-RequiredFuel01 {
    Param(
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$InputFilePath
    )

    $totalFuel = 0
    Get-Content $InputFilePath | ForEach-Object {
        $totalFuel += [Math]::Floor([int]::Parse($_)/3)-2
    }

    return $totalFuel
}

function global:Measure-RequiredFuel02 {
    Param(
        [ValidateScript({Test-Path $_ -PathType Leaf})]
        [string]$InputFilePath
    )

    $totalFuel = 0
    # Get-Content $InputFilePath | ForEach-Object {
    #     $totalFuel += [Math]::Floor([int]::Parse($_)/3)-2
    # }

    Write-Host "The total fuel required is --> $totalFuel"
}