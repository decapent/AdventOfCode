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
            $result1 | Should -Be $password1
            $result2 | Should -Be $password2
            $result3 | Should -Be $password3
            $result4 | Should -Be $password4
            $result5 | Should -Be ''
        }

        It "Finds all the valid password given a valid input" {
            # Arrange
            # $input = "234208-765869"

            # # Act
            # $numberOfPasswords = Resolve-AllPassword -Tabarnak $input

            # # Assert
            # $numberOfPasswords | Should -Be 1246
        }
    } 

    Context "Part02 - When cracking the password" {
        It "Detects that a group no more than 2 digits are adjacent" {
            # Arrange
            $password1 = "122222"
            $password2 = "123455"
            $password3 = "123444"
            $password4 = "111122"
            $password5 = "123245"
            
            # Act
            $result1 = $password1 | Test-AdjacentDigits -Part2
            $result2 = $password2 | Test-AdjacentDigits -Part2
            $result3 = $password3 | Test-AdjacentDigits -Part2
            $result4 = $password4 | Test-AdjacentDigits -Part2
            $result5 = $password5 | Test-AdjacentDigits -Part2
            
            # Assert
            $result1 | Should -Be ''
            $result2 | Should -Be $password2
            $result3 | Should -Be ''
            $result4 | Should -Be $password4
            $result5 | Should -Be ''
        }

        It "Finds all the valid password given a valid input" {
            # Arrange
            $input = "234208-765869"

            # Act
            $numberOfPasswords = Resolve-AllPassword -Tabarnak $input -Part2

            # Assert
            $numberOfPasswords | Should -Be 0
        }
    }
}