Describe "Given the Advent of Code 2019 - Day 02" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\02.ps1")
        
        # Setting up Test data to Test Drive
        $testData = Resolve-Path ".\test-data\"
        Get-ChildItem $testData | Copy-Item -Destination $TestDrive

        # 
        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }


    Context "Part01 - When " {
        It "Computes stuff" {
            # Arrange
            

            # Act
            

            # Assert
            Set-TestInconclusive
        }
    } 
}