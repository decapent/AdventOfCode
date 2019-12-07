function script:Expand-OpCode {
    Param (
        [string[]]$OpCode,
        [string[]]$Memory
    )

    $firstOperand = [int]::Parse($Memory[$OpCode[1]])
    $secondOperand = [int]::Parse($Memory[$OpCode[2]])

    switch ($OpCode[0]) {
        "1" {
            Write-Verbose "Executing addition command"
            return $firstOperand + $secondOperand
        }
        "2" {            
            Write-Verbose "Executing multiplication command"
            return $firstOperand * $secondOperand
        }
        default {
            throw "Unsupported opCode operation!"
        }
    }
}

function global:Invoke-IntCode {
    [CmdletBinding()]
    Param (
        [ValidateScript( { $_ | Test-Path -PathType Leaf })]
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

        if ($opCode[0] -eq "99") {
            $shouldRun = $false
        }
        else {
            $memory[$opCode[3]] = Expand-OpCode -OpCode $opCode -Memory $memory
        }

        $currentPos += 4
    }
    while ($shouldRun)

    return $memory
}