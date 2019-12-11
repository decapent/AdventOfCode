Describe "Given the Advent of Code 2019 - Day 04" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\04.ps1")

        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }


    Context "Part01 - When the cracking the password" {

        It "Detects that all digit increases in the password" {
            # Arrange
            $password1 = "123434"
            $password2 = "123456"
            $password3 = "654321"
            $password4 = "234455"
            $password4 = "256555"

            # Act
            $result1 = Test-DigitsNeverDecrease -Password $password1
            $result2 = Test-DigitsNeverDecrease -Password $password2
            $result3 = Test-DigitsNeverDecrease -Password $password3
            $result4 = Test-DigitsNeverDecrease -Password $password4
            $result5 = Test-DigitsNeverDecrease -Password $password5

            # Assert
            $result1 | Should -Be $false
            $result2 | Should -Be $true
            $result3 | Should -Be $false
            $result4 | Should -Be $true
            $result5 | Should -Be $false
        }

        It "Detects that a group of 2 digits are adjacent" {
            # Arrange
            $password1 = "122222"
            $password2 = "123455"
            $password3 = "112233"
            $password4 = "237899"
            $password5 = "123245"

            # Act
            $result1 = Test-DigitsNeverDecrease -Password $password1
            $result2 = Test-DigitsNeverDecrease -Password $password2
            $result3 = Test-DigitsNeverDecrease -Password $password3
            $result4 = Test-DigitsNeverDecrease -Password $password4
            $result5 = Test-DigitsNeverDecrease -Password $password5

            # Assert
            $result1 | Should -Be $true
            $result2 | Should -Be $true
            $result3 | Should -Be $true
            $result4 | Should -Be $true
            $result5 | Should -Be $false
        }

        It "Finds all the valid password given a valid input" {
            # Arrange
            $input = "234208-765869"

            # Act
            $numberOfPasswords = Resolve-AllPassword -Tabarnak $input

            # Assert
            $numberOfPasswords | Should -Be 11

        }
    } 

    Context "Part02 - When the required fuel calculation is computed" {
        It "WE ALL KNOW THIS COMING" {
            Set-ItResult -Inconclusive -Because "PART 01 NOT COMPLETED"
        }
    }
}