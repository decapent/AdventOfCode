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
            $password5 = "256555"

            # Act
            $result1 = $password1 | Test-DigitsNeverDecrease
            $result2 = $password2 | Test-DigitsNeverDecrease
            $result3 = $password3 | Test-DigitsNeverDecrease
            $result4 = $password4 | Test-DigitsNeverDecrease
            $result5 = $password5 | Test-DigitsNeverDecrease

            # Assert
            $result1 | Should -Be ''
            $result2 | Should -Be $password2
            $result3 | Should -Be ''
            $result4 | Should -Be $password4
            $result5 | Should -Be ''
        }

        It "Detects that a group of 2 digits are adjacent" {
            # Arrange
            $password1 = "122222"
            $password2 = "123455"
            $password3 = "112233"
            $password4 = "237899"
            $password5 = "123245"

            # Act
            $result1 = $password1 | Test-AdjacentDigits
            $result2 = $password2 | Test-AdjacentDigits
            $result3 = $password3 | Test-AdjacentDigits
            $result4 = $password4 | Test-AdjacentDigits
            $result5 = $password5 | Test-AdjacentDigits

            # Assert
            $result1 | Should -Be $true
            $result2 | Should -Be $true
            $result3 | Should -Be $true
            $result4 | Should -Be $true
            $result5 | Should -Be $false
        }

        It "Finds all the valid password given a valid input" {
            # Arrange
            $input = "234208-76586"

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