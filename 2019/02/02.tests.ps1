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


    Context "Part01 - When executing an ADD OpCode " {
        BeforeAll {
            $opcodeAdd = Get-Content .\opcodeAdd.txt | ForEach-Object { $_ -split "," }
            $opcodeMultiply = Get-Content .\opcodeMultiply.txt | ForEach-Object { $_ -split "," }
            $opcodeTooLong = Get-Content .\opcodeMultiply.txt | ForEach-Object { $_ -split "," }
        }

        It "Throws if the first operation is not an Addition" {
            # Act
            { Expand-AddOpCode -OpCode $opcodeMultiply } | Should -Throw
        }

        It "Throws if the opcode is longer than 4 elements" {
            # Act
            { Expand-AddOpCode -OpCode $opcodeTooLong } | Should -Throw
        }
    } 
}