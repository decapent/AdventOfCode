Describe "Given the Advent of Code 2019 - Day 03" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\03.ps1")
        
        # Setting up Test data to Test Drive
        $testData = Resolve-Path ".\test-data\"
        Get-ChildItem $testData | Copy-Item -Destination $TestDrive -Force

        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }

    Context "Part01 - When resolving the closest intersection between wires " {
        It "Throws if the program input path is invalid" {
            # Arrange
            $invalidPath = ".\doesnotexists"

            # Act & Assert
            { Resolve-WireIntersection -WireSchema $invalidPath -ClosestDistance } | Should -Throw
        }

        It "Throws if the program input path is not a file" {
            # Arrange
            $validPathToFolder = ".\dummyFolder"

            # Act & Assert
            { Resolve-WireIntersection -WireSchema $validPathToFolder -ClosestDistance } | Should -Throw
        }

        It "Detects if two lines are parallel" {
            # Arrange
            $line1Start = New-WirePosition -X 10 -Y 25
            $line1End = New-WirePosition -X 30 -Y 25
            $line2Start = New-WirePosition -X 10 -Y 10
            $line2End = New-WirePosition -X 45 -Y 10

            $line1 = @($line1Start, $line1End)
            $line2 = @($line2Start, $line2End)

            # Act
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2

            # Assert
            $intersection | Should -Be $null
        }

        It "Detects if two lines are intersecting long enough to touch each other" {
            # Arrange
            $line1Start = New-WirePosition -X 10 -Y 25
            $line1End = New-WirePosition -X 30 -Y 25
            $line2Start = New-WirePosition -X 15 -Y 20
            $line2End = New-WirePosition -X 15 -Y 30

            $line1 = @($line1Start, $line1End)
            $line2 = @($line2Start, $line2End)

            # Act
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2

            # Assert
            $intersection.X | Should -Be 15
            $intersection.Y | Should -Be 25
        }

        It "Detects if two lines are intersecting but not long enough to touch (horizontal intersect)" {
            # Arrange
            $line1Start = New-WirePosition -X 0 -Y 0
            $line1End = New-WirePosition -X 0 -Y 75
            $line2Start = New-WirePosition -X 66 -Y 62
            $line2End = New-WirePosition -X 66 -Y 117

            $line1 = @($line1Start, $line1End)
            $line2 = @($line2Start, $line2End)

            # Act
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2

            # Assert
            $intersection | Should -Be $null
        }

        It "Detects if two lines are intersecting but not long enough to touch (vertical intersects)" {
            # Arrange
            $line1Start = New-WirePosition -X 75 -Y 0
            $line1End = New-WirePosition -X 75 -Y (-30)
            $line2Start = New-WirePosition -X 66 -Y 117
            $line2End = New-WirePosition -X 100 -Y 117

            $line1 = @($line1Start, $line1End)
            $line2 = @($line2Start, $line2End)

            # Act
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2

            # Assert
            $intersection | Should -Be $null
        }

        It "Discards if lines intersect at the origin (0,0)" {
            # Arrange
            $line1Start = New-WirePosition -X 0 -Y 0
            $line1End = New-WirePosition -X 30 -Y 0
            $line2Start = New-WirePosition -X 0 -Y 0
            $line2End = New-WirePosition -X 0 -Y 30

            $line1 = @($line1Start, $line1End)
            $line2 = @($line2Start, $line2End)

            # Act
            $intersection = Test-WireIntersect -Line1 $line1 -Line2 $line2

            # Assert
            $intersection | Should -Be $null
        }

        It "Calculates the manhattan distance of a given point from the Origin" {
            # Arrange
            $intersection = New-WirePosition -X 3 -Y 3

            # Act
            $distance = ConvertTo-ManhattanDistance -Intersections $intersection -FromOrigin | Select-Object -First 1

            # Assert
            $distance | Should -Be 6
        }

        It "Calculates the manhattan distance of a given point from the Origin" {
            # Arrange
            $intersection = New-WirePosition -X 15 -Y 25

            # Act
            $distance = ConvertTo-ManhattanDistance -Intersections $intersection -FromOrigin | Select-Object -First 1

            # Assert
            $distance | Should -Be 40
        }

        It "Resolves simple wire intersections problem" {
            # Act
            $distance1 = Resolve-WireIntersection -WireSchema ".\distance159.txt" -Distance
            $distance2 = Resolve-WireIntersection -WireSchema ".\distance135.txt" -Distance

            # Assert
            $distance1 | Should -Be 159
            $distance2 | Should -Be 135
        }
    }

    Context "Part02 - When resolving the steps necessary to an intersection" {
        It "Calculates the covered steps for a vertical segment from the origin" {
            # Arrange
            $pt1 = New-WirePosition -X 0 -Y 0
            $pt2 = New-WirePosition -X 0 -Y 50
            $line = @($pt1, $pt2)
            
            # Act
            $steps = Resolve-CoveredSteps -Line $line

            # Assert
            $steps | Should -Be 50
        }

        It "Calculates the covered steps for an horizontal segment from the origin" {
            # Arrange
            $pt1 = New-WirePosition -X 0 -Y 0
            $pt2 = New-WirePosition -X 75 -Y 0
            $line = @($pt1, $pt2)
            
            # Act
            $steps = Resolve-CoveredSteps -Line $line

            # Assert
            $steps | Should -Be 75
        }

        It "Resolves simple wire intersections problem" {
            # Act
            $distance1 = Resolve-WireIntersection -WireSchema ".\distance159.txt" -LeastSteps
            $distance2 = Resolve-WireIntersection -WireSchema ".\distance135.txt" -LeastSteps

            # Assert
            $distance1 | Should -Be 610
            $distance2 | Should -Be 410
        }
    }
}