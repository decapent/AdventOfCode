        # [ValidateScript({
        #     $ranges = $_ -split "-" | ForEach-Object { [int]::Parse($_) }
        #     if($ranges.Length -ne 2) {
        #         throw "Invalid input range"
        #     }

        #     # if($ranges[0].Length -ne 6 -and $ranges[1].Length -ne 6) {
        #     #     throw "Invalid range length"
        #     # }
        # })]

function global:Resolve-AllPassword {
    [CmdletBinding()]
    Param (
        [string]$Tabarnak
    )

    $passwordRanges = $Tabarnak.Split("-")

    $validPasswords = @()

    $currentPassword = [int]::Parse($passwordRanges[0])
    $lastPassword = [int]::Parse($passwordRanges[1])
    while($currentPassword -le $lastPassword) {
        # Check if digit increases in the password
        if(Test-DigitsNeverDecrease -Password $currentPassword.ToString()) {
            if(Test-AdjacentDigits -Password $currentPassword.ToString()) {
                $validPasswords += $currentPassword
            }
        }

        $currentPassword++
    }

    return $validPasswords.Length
}

function global:Test-AdjacentDigits {
    Param (
        [string]$Password
    )

    return $Password -match "(\d)\1{1}"
}

function global:Test-DigitsNeverDecrease {
    Param (
        [string]$Password
    )

    $previous = 0
    $neverDecrease = $true
    $Password.ToCharArray() | ForEach-Object {
        
        $currentDigit = [int]::Parse($_)
        $neverDecrease = $previous -le  $currentDigit
        if($neverDecrease) {
            $previous = $currentDigit
        }
    }

    return $neverDecrease
}