function global:Resolve-AllPassword {
    [CmdletBinding()]
    Param (
        [string]$Tabarnak,
        [switch]$Part2
    )

    $passwordRanges = $Tabarnak.Split("-")
    $validPasswords = @()

    $currentPassword = [int]::Parse($passwordRanges[0])
    $lastPassword = [int]::Parse($passwordRanges[1])
    while ($currentPassword -le $lastPassword) {
        # Check if digit increases in the password
        $testResult = $currentPassword.ToString() `
        | Test-DigitsNeverDecrease `
        | Test-AdjacentDigits -Part2:$Part2

        if (![string]::IsNullOrEmpty($testResult)) {
            $validPasswords += $testResult
        }

        $currentPassword++
    }

    return $validPasswords.Length
}

function global:Test-AdjacentDigits {
    Param (
        [OutputType("Password")]
        [Parameter(ValueFromPipeline)]
        [string]$Password,

        [switch]$Part2
    )

    if (![string]::IsNullOrEmpty($Password)) {
        if (!$Part2.IsPresent) {
            for ($i = 0; $i -lt $Password.Length - 1; $i++) {
                if ($Password[$i] -eq $Password[$i + 1]) {
                    return $Password
                }
            }
        }
        else {
            # Welcome to part 2
            $adjacentGroups = @()
            $adjacentDigits = $Password[0]
            for ($i = 0; $i -lt $Password.Length - 1; $i++) {
                if ($Password[$i] -eq $Password[$i + 1]) {
                    $adjacentDigits += $Password[$i + 1]
                }
                else {
                    $adjacentGroups += $adjacentDigits
                    $adjacentDigits = $Password[$i + 1]
                }
            }

            # one last check
            if ($adjacentDigits.Length -gt 1) {
                $adjacentGroups += $adjacentDigits
            }

            $match = $adjacentGroups `
            | Select-Object -Skip 1 `
            | Where-Object { $_.Length -eq 2 }

            if ($match) {
                return $Password
            }
        }
    }
    
    return [string]::Empty
}

function global:Test-DigitsNeverDecrease {
    Param (
        [OutputType("Password")]
        [Parameter(ValueFromPipeline)]
        [string]$Password
    )

    if (![string]::IsNullOrEmpty($Password)) {
        for ($i = 0; $i -lt $Password.Length - 1; $i++) {
            if (!($Password[$i] -le $Password[$i + 1])) {
                return [string]::Empty
            }
        }
    }

    return $Password
}