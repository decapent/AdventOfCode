Describe "Given the Advent of Code 2019 - Day 01" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\01.ps1")
        
        # Setting up Test data to Test Drive
        $testData = Resolve-Path ".\test-data\"
        Get-ChildItem $testData | Copy-Item -Destination $TestDrive

        # 
        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }


    Context "Part01 - When the required fuel calculation is computed" {
        It "Computes the proper mass of the modules" {
            # Arrange
            $inputFilePath = Resolve-Path .\testdata.txt

            # Act
            $totalFuel = Measure-RequiredFuel01 -InputFilePath $inputFilePath

            # Assert
            $totalFuel | Should -Be 34241
        }
    } 

    Context "Part02 - When the required fuel calculation is computed" {
        It "Computes recursively the proper mass of the modules" {
            # Arrange
            $inputFilePath = Resolve-Path .\testdata.txt

            # Act
            $totalFuel = Measure-RequiredFuel02 -InputFilePath $inputFilePath

            # Assert
            $totalFuel | Should -Be 51316
        }
    }
}