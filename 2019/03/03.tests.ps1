Describe "Given the Advent of Code 2019 - Day 03" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\03.ps1")
        
        # Setting up Test data to Test Drive
        $testData = Resolve-Path ".\test-data\"
        Get-ChildItem $testData | Copy-Item -Destination $TestDrive

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
            { Resolve-WireIntersection -WireSchema $invalidPath } | Should -Throw
        }

        It "Throws if the program input path is not a file" {
            # Arrange
            $invalidPath = ".\dummyFolder"

            # Act & Assert
            { Resolve-WireIntersection -WireSchema $invalidPath } | Should -Throw
        }
    }
}