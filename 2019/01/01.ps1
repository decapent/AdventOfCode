
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
    Get-Content $InputFilePath | ForEach-Object {
        $totalFuel += Measure-Mass -Mass ([int]::Parse($_))
    }

    return $totalFuel
}

function script:Measure-Mass {
    Param (
        [int]$Mass
    )

    $subMass = [Math]::Floor($Mass/3)-2

    if($subMass -gt 0) {
        $subMass += Measure-Mass -Mass $subMass
    } else {
        return 0
    }

    return $subMass
}
