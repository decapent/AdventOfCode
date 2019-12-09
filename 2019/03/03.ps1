function global:Resolve-WireIntersection {
    [CmdletBinding()]
    Param (
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
        [string]$WireSchemasPath,

        [switch]$Distance,
        [switch]$LeastSteps
    )

    Write-Verbose "Parsing raw wire schema into vectors of X and Y coordinates"
    $positionVectors = @()
    Get-Content $WireSchemasPath | ForEach-Object {
        $positionVectors += , ($_ | Initialize-PositionVector)
    }   
    
    Write-Verbose "Obtaining wires"
    $wire1 = $positionVectors[0]
    $wire2 = $positionVectors[1]
    $intersections = @()
    $steps = @()

    # Starting from origin
    $wire1LastPos = New-WirePosition -X 0 -Y 0
    $wire1Steps = 0
    $wire1 | ForEach-Object {
        
        Write-Verbose "Obtaining first wire segment"
        $line1 = @($wire1LastPos, $_)
        $wire1Steps += Resolve-CoveredSteps -Line $line1

        $wire2LastPos = New-WirePosition -X 0 -Y 0
        $wire2Steps = 0
        $wire2 | ForEach-Object {

            Write-Verbose "Obtaining second wire segment"
            $line2 = @($wire2LastPos, $_)
            $wire2Steps += Resolve-CoveredSteps -Line $line2

            Write-Verbose "Testing for intersection"
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2
            if ($intersection) {
                Write-Verbose "Found intersection"
                $intersections += $intersection

                $subLine1 = @($line1[1], $intersection)
                $subLine2 = @($line2[1], $intersection)
                $subCover1 = Resolve-CoveredSteps -Line $subLine1
                $subCover2 = Resolve-CoveredSteps -Line $subLine2

                $steps += ($wire1Steps - $subCover1) + ($wire2Steps - $subCover2)
            }

            $wire2LastPos = $_
        }

        $wire1LastPos = $_
    }
    
    if($Distance.IsPresent) {
        Write-Verbose "Resolving closest manhattan distance from origin"
        return ConvertTo-ManhattanDistance -Intersections $intersections -FromOrigin `
        | Sort-Object `
        | Select-Object -First 1
    }

    if($LeastSteps.IsPresent) {
        Write-Verbose "Resolving closest manhattan distance from origin"
        return $steps `
        | Sort-Object `
        | Select-Object -First 1
    }
}

function global:New-WirePosition {
    Param (
        [int]$X,
        [int]$Y
    )

    $props = @{"X" = $X; "Y" = $Y; }
    return New-Object -TypeName PSObject -Property $props
}

function global:Initialize-PositionVector {
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

function global:Test-WireIntersect {
    Param (
        [PSObject[]]$Line1,
        [PSObject[]]$Line2
    )

    # Line 1
    $a1 = $Line1[1].Y - $Line1[0].Y
    $b1 = $Line1[0].X - $Line1[1].X
    
    # Line 2
    $a2 = $Line2[1].Y - $Line2[0].Y
    $b2 = $Line2[0].X - $Line2[1].X

    $delta = $a1 * $b2 - $a2 * $b1
    if ($delta -eq 0) {
        return $null #Parallel Line
    }
    else {
        $c1 = $a1 * $Line1[0].X + $b1 * $Line1[0].Y
        $c2 = $a2 * $Line2[0].X + $b2 * $Line2[0].Y

        $x = ($b2 * $c1 - $b1 * $c2) / $delta
        $y = ($a1 * $c2 - $a2 * $c1) / $delta

        # Discard if intersection is at origin
        if ($x -eq 0 -and $y -eq 0) {
            return $null
        }

        $intersection = New-WirePosition -X $x -Y $y
        $intersect1 = $intersection | Assert-PointOnSegment -Line $Line1
        $intersect2 = $intersection | Assert-PointOnSegment -Line $Line2
        if ($intersect1 -and $intersect2) {
            return $intersection
        }

        # Discard if the intersection found is not on both lines 
        # but rather on the projection of the line function
        return $null
    }
}

function global:Assert-PointOnSegment {
    Param(
        [Parameter(ValueFromPipeline)]
        [PSObject]$Point,

        [PSObject[]]$Line
    )

    $isBetweenX = $Point.X -ge $Line[0].X -and $Point.X -le $Line[1].X
    $isBetweenY = $Point.Y -ge $Line[0].Y -and $Point.Y -le $Line[1].Y

    if ($isBetweenX -and !$isBetweenY) {
        # horizontal crossing vertical shenanigans   
        return $Point.Y -ge $Line[1].Y -and $Point.Y -le $Line[0].Y
    }

    if (!$isBetweenX -and $isBetweenY) {
        # vertical crossing horizontal shenanigans
        return $Point.X -ge $Line[1].X -and $Point.X -le $Line[0].X
    }

    return $true
}

function global:ConvertTo-ManhattanDistance {
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
            $distances += [Math]::Abs($_.X) + [Math]::Abs($_.Y)
        }
        else {
            throw "Not implemented"
        }
    }
    
    return $distances
}

function global:Resolve-CoveredSteps {
    Param (
        [PSObject[]]$Line
    )

    return [Math]::Abs($Line[0].X - $Line[1].X) + [Math]::Abs($Line[0].Y - $Line[1].Y)
}