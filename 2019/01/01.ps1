Push-Location $PSScriptRoot

$totalFuel = 0
Get-Content .\input.txt | ForEach-Object {
    $mass = [int]::Parse($_)
    $totalFuel += [Math]::Floor($mass/3)-2
}

Write-Host $totalFuel