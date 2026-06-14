
# ============= PROGRAM ================= #

function Show-ArrowMenu {

    # PARAMETER #
    param (
        [string[]]$menuList = ""
    )

    # VARIABLES #
    $pressedKey = ""
    $selectIndex = 0
    $maxIndex = ($menuList.Length - 1)

    # MAIN BODY #
    while ($pressedKey -ne "Enter") {
        
        if ( $selectIndex -gt $maxIndex ) {
            $selectIndex = 0    
        } elseif ( $selectIndex -lt 0 ) {
            $selectIndex = $maxIndex
        }

        foreach ($option in $menuList) {
            if ($menuList.IndexOf($option) -eq $selectIndex) {
                Write-Host $option -BackgroundColor Yellow -ForegroundColor Black
            } else {
                Write-Host $option -ForegroundColor White
            }
        }
            
        $key = [Console]::ReadKey($true)
        $pressedKey = ($key.Key).ToString()

        switch ($pressedKey) {
            "UpArrow" {$selectIndex--}
            "DownArrow" {$selectIndex++}
            "Enter" { $userChoice = $menuList[$selectIndex]}
        }

        Clear-Host
    }

    # OUTPUT #
    Write-Host "You chose:" $userChoice
    return $userChoice
}

<# TO DO:
    1. Change WinRM protocole (Enter PS-Session) to SSH protocole
    so the ReadKey method of [Console] class can work on a remote session.
    2. 

    TO COMMIT:
        1. Turned script into a function with a parameter. Deleted hardcoded values like $oldCampList.
        2. Parameter takes menu list as an input and displays all the options
        with arrow navigation and option highlighting.

#>