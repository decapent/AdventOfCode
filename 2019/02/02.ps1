function global:Invoke-IntCode {
    [CmdletBinding()]
    Param (
        [ValidateScript( { Test-Path $_ -PathType Leaf })]
        [string]$ProgramInputPath
    )

    Write-Verbose "Loading IntCode in memory"
    $memory = Get-Content $ProgramInputPath | ForEach-Object { $_ -split "," }
    
    $shouldRun = $true
    $currentPos = 0
    
    do {
        Write-Verbose "Getting new Opcode"
        $seek = $currentPos + 3
        $opCode = $memory[$currentPos..$seek]

        switch ($opCode[0]) {
            "1" {
                Write-Verbose "Executing addition command"
                $firstOperand = [int]::Parse($memory[$opCode[1]])
                $secondOperand = [int]::Parse($memory[$opCode[2]])
                $memory[$opCode[3]] = $firstOperand + $secondOperand
                break;
            }
            "2" {            
                Write-Verbose "Executing multiplication command"
                $firstOperand = [int]::Parse($memory[$opCode[1]])
                $secondOperand = [int]::Parse($memory[$opCode[2]])
                $memory[$opCode[3]] = $firstOperand * $secondOperand
                break;
            }
            "99" {
                Write-Verbose "Time to finish and go home"
                $shouldRun = $false
                break;
            }
            default {
                throw "Unsupported opCode operation!"
            }
        }

        $currentPos += 4
    }
    while ($shouldRun)

    return $memory
}

Invoke-IntCode -ProgramInputPath .\modifiedInput.txt -Verbose