function global:Expand-AddOpCode {
    Param(
        #[ValidateScript({$_[0] -eq "1"})]
        [string[]]$Opcode,

        [Parameter(ValueFromPipeline)]
        [ValidateNotNullOrEmpty()]
        [object[]]$ProgramState
    )

    Write-Host $Opcode
    Write-Host $ProgramState
}

function global:do-stuff {

    $programState = get-content .\test-data\opcodeAdd.txt | ForEach-Object { $_ -split "," }

    $currentPos = 0
    do 
    {
        $shouldRun = $true

        $seek = $currentPos + 3
        $opCode = $programState[$currentPos..$seek]

        Write-Warning "Premier Caractere du Opcode"
        Write-Host $opCode[0]
        switch($opCode[0]){
            "1" {
                Write-Warning "Je rentre ici"
                $programState | Expand-AddOpCode -Opcode $opCode
                # Write-Warning "After"
                # Write-Host $programState
                break;
            }
            "2" {
                "Two"
                break;
            }
            "99" {
                $shouldRun = $false
                break;
            }
            default {
                Write-Host $opCode
                throw "Unsupported Opcode"
            }
        }
        
        $currentPos += 4
    }
    while($shouldRun)
}