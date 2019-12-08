function global:Resolve-WireIntersection {
    [CmdletBinding()]
    Param (
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
        [string]$WireSchemasPath
    )

    Write-Verbose "Parsing raw wire schema into vectors of X and Y coordinate"
    $positionVectors = @()
    Get-Content $WireSchemasPath | ForEach-Object {
        $positionVectors += , ($_ | Initialize-PositionVector)
    }   
    
    $wire1 = $positionVectors[0]
    $wire2 = $positionVectors[1]
    
    # Starting from origin
    $wire1LastPos = New-WirePosition -X 0 -Y 0
    $intersections = @()

    $wire1 | ForEach-Object {
        
        $line1 = @($wire1LastPos, $_)
        $wire2LastPos = New-WirePosition -X 0 -Y 0

        $wire2 | ForEach-Object {

            $line2 = @($wire2LastPos, $_)
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2
            if ($intersection) {
                $intersections += $intersection
            }

            $wire2LastPos = $_
        }

        $wire1LastPos = $_
    }
    
    # Get closest manhattan distance from the origin
    return ConvertTo-ManhattanDistance -Intersections $intersections -FromOrigin `
    | Sort-Object `
    | Select-Object -First 1
}

function script:New-WirePosition {
    Param (
        [int]$X,
        [int]$Y
    )

    $props = @{"X" = $X; "Y" = $Y; }
    return New-Object -TypeName PSObject -Property $props
}

function script:Initialize-PositionVector {
    Param (
        [Parameter(ValueFromPipeline)]
        [string]$WireSchema
    )

    # Start at origin
    $currentPosition = New-WirePosition -X 0 -Y 0
    $vector = @()

    $WireSchema -split "," | ForEach-Object {
        $direction = $_[0]
        $position = [int]::Parse($_.Substring(1))
        switch ($direction) {
            "U" {
                $currentPosition.Y += $position
                break;
            }
            "D" {
                $currentPosition.Y -= $position
                break;
            }
            "R" {
                $currentPosition.X += $position
                break;
            }
            "L" {
                $currentPosition.X -= $position
                break;
            }
            default {
                throw "Crosse twe la direction!"
            }
        }

        $vector += New-WirePosition -X $currentPosition.X -Y $currentPosition.Y
    }

    return $vector
}

function script:Test-WireIntersect {
    Param (
        [PSObject[]]$Line1,
        [PSObject[]]$Line2,

        [switch]$DiscardOrigin
    )

    # Line 1
    $a1 = $Line1[1].Y - $Line1[0].Y
    $b1 = $Line1[0].X - $Line1[1].X
    
    # Line 2
    $a2 = $Line2[1].Y - $Line2[0].Y
    $b2 = $Line2[0].X - $Line2[1].X

    $det = $a1 * $b2 - $a2 * $b1
    if ($det -eq 0) {
        return $null #Parallel Line
    }
    else {
        $c1 = $a1 * $Line1[0].X + $b1 * $Line1[0].Y
        $c2 = $a2 * $Line2[0].X + $b2 * $Line2[0].Y

        $x = ($b2 * $c1 - $b1 * $c2) / $det
        $y = ($a1 * $c2 - $a2 * $c1) / $det

        # Discard if intersection is at origin
        if ($x -eq 0 -and $y -eq 0) {
            return $null
        }

        return New-WirePosition -X $x -Y $y
    }
}

function script:ConvertTo-ManhattanDistance {
    Param (
        [PSObject[]]$Intersections,

        [Parameter(ParameterSetName = "Origin")]
        [switch]$FromOrigin,

        [Parameter(ParameterSetName = "Custom")]
        [PSObject]$From
    )

    $distances = @()
    $Intersections | ForEach-Object {
        if ($FromOrigin.IsPresent) {
            $distances += [Math]::Abs(0 - ($_.X + $_.Y))
        }
        else {
            $distances += [Math]::Abs(($From.X + $From.Y) - ($_.X + $_.Y))
        }
    }
    
    return $distances
}