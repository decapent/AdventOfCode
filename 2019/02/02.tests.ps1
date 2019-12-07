Describe "Given the Advent of Code 2019 - Day 02" {

    BeforeAll {
        Push-Location $PSScriptRoot

        # Source functions
        . $(Resolve-Path ".\02.ps1")
        
        # Setting up Test data to Test Drive
        $testData = Resolve-Path ".\test-data\"
        Get-ChildItem $testData | Copy-Item -Destination $TestDrive

        Set-Location $TestDrive
    }

    AfterAll {
        Pop-Location
    }


    Context "Part01 - When executing an IntCode program " {
        It "Throws if the program input path is invalid" {
            # Arrange
            $invalidPath = ".\doesnotexists"

            # Act & Assert
            { Invoke-IntCode -ProgramInputPath $invalidPath } | Should -Throw
        }

        It "Throws if the program input is not a file" {
            # Arrange
            $validFolderPath = ".\dummyFolder"

            # Act & Assert
            { Invoke-IntCode -ProgramInputPath $validFolderPath } | Should -Throw
        }

        It "Throws if the OpCode operation is unrecognised (+, *, exit)" {
            # Arrange
            $program = ".\opcodeInvalid.txt"

            # Act & Assert
            { Invoke-IntCode -ProgramInputPath $program } | Should -Throw
        }

        It "Computes and addition without corrupting the memory" {
            # Arrange
            $program = ".\opcodeAdd.txt"

            # Act
            $memoryDump = Invoke-IntCode -ProgramInputPath $program

            # Assert
            $memoryDump[0] | Should -Be 2
        }

        It "Computes a multiplication without corrupting the memory" {
            # Arrange
            $program = ".\opcodeMultiply.txt"

            # Act
            $memoryDump = Invoke-IntCode -ProgramInputPath $program

            # Assert
            $memoryDump[0] | Should -Be 9801
        }

        It "Computes a simple program without corrupting the memory" {
            # Arrange
            $program = ".\simpleProgram.txt"

            # Act
            $memoryDump = Invoke-IntCode -ProgramInputPath $program

            # Assert
            $memoryDump[0] | Should -Be 3500
            $memoryDump[3] | Should -Be 70
        }

        It "Computes a complex program without corrupting the memory" {
            # Arrange
            $program = ".\complexProgram.txt"

            # Act
            $memoryDump = Invoke-IntCode -ProgramInputPath $program

            # Assert
            $memoryDump[0] | Should -Be 337076            
        }
    } 

    Context "Part02 - When executing an IntCode program " {
        It "Computes a complex program without corrupting the memory and with modified verb and noun" {
            # Arrange
            $program = ".\complexProgramPt2.txt"

            # Act
            $memoryDump = Invoke-IntCode02 -ProgramInputPath $program

            # Assert
            $memoryDump[0] | Should -Be 19690720
        }
    }
}