function global:Invoke-IntCode {
    [CmdletBinding()]
    Param (
        [ValidateScript( { Test-Path $_ -PathType Leaf })]
        [string]$ProgramInputPath
    )

    Write-Verbose "Loading IntCode in memory"
    $memory = Get-Content $ProgramInputPath | ForEach-Object { $_ -split "," }
    $currentPos = 0
    
    do {
        $shouldRun = $true

        Write-Verbose "Getting new Opcode"
        $seek = $currentPos + 3
        $opCode = $memory[$currentPos..$seek]

        Write-Verbose "Obtaining operands"
        $firstOperand = [int]::Parse($memory[$opCode[1]])
        $secondOperand = [int]::Parse($memory[$opCode[2]])

        switch ($opCode[0]) {
            "1" {
                Write-Verbose "Executing addition command"
                $memory[$opCode[4]] = $firstOperand + $secondOperand
            }
            "2" {            
                Write-Verbose "Executing multiplication command"
                $memory[$opCode[4]] = $firstOperand * $secondOperand
            }
            "99" {
                Write-Verbose "Time to finish and go home"
                $shouldRun = $false
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