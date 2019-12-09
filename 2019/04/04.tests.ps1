Describe "Given the Advent of Code 2019 - Day 04" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\04.ps1")
        
        # Setting up Test data to Test Drive
        $testData = Resolve-Path ".\test-data\"
        Get-ChildItem $testData | Copy-Item -Destination $TestDrive

        # 
        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }


    Context "Part01 - When the cracking the password" {
        BeforeAll {
            $validInput = "234208-765869"
            $invalidRangeInput = "12341234"
            $invalidRangeLengthInput = "1234-1234"
        }

        It "Throws if the input does not contains 2 integers" {
            { Resolve-Password -Input $invalidRangeInput } | Should -Throw
        }

        It "Throws if the input integers are not of a length 6" {
            { Resolve-Password -Input $invalidRangeLengthInput } | Should -Throw
        }
    } 

    Context "Part02 - When the required fuel calculation is computed" {
        It "WE ALL KNOW THIS COMING" {
            Set-ItResult -Inconclusive -Because "PART 01 NOT COMPLETED"
        }
    }
}