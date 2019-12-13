function global:Resolve-AllPassword {
    [CmdletBinding()]
    Param (
        [string]$Tabarnak
    )

    $passwordRanges = $Tabarnak.Split("-")
    $validPasswords = @()

    $currentPassword = [int]::Parse($passwordRanges[0])
    $lastPassword = [int]::Parse($passwordRanges[1])
    while ($currentPassword -le $lastPassword) {
        # Check if digit increases in the password
        $testResult = $currentPassword.ToString() `
        | Test-DigitsNeverDecrease `
        | Test-AdjacentDigits

        if (![string]::IsNullOrEmpty($currentPassword.ToString($testResult))) {
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
        [string]$Password
    )

    if (![string]::IsNullOrEmpty($Password)) {
        for ($i = 0; $i -lt $Password.Length - 1; $i++) {
            if ($Password[$i] -eq $Password[$i + 1]) {
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