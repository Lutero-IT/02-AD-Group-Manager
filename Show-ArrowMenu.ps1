
# ============= PROGRAM ================= #

function Show-ArrowMenu {

    # PARAMETER #
    param (
        [string[]]$Menu = "",
        [string]$Title = "",
        [string]$Group = "None"
    )

    # VARIABLES #
    $pressedKey = ""
    $selectIndex = 0
    $maxIndex = ($Menu.Length - 1)

    # MAIN BODY #
    while ($pressedKey -ne "Enter") {

        Write-Host ""
        Write-IndentedLog ("="*80)
        Write-IndentedLog (" " * ((80 - [int]$Title.Length) / 2 ) ) $Title
        Write-IndentedLog ("="*80)


        Write-Host ""
        Write-IndentedLog "You are currently editing '$Group' group" -BackgroundColor Yellow -ForegroundColor Black
        Write-Host ""
        
        if ( $selectIndex -gt $maxIndex ) {
            $selectIndex = 0    
        } elseif ( $selectIndex -lt 0 ) {
            $selectIndex = $maxIndex
        }

        foreach ($option in $Menu) {
            if ($Menu.IndexOf($option) -eq $selectIndex) {
                Write-IndentedLog $option -BackgroundColor Yellow -ForegroundColor Black
            } else {
                Write-IndentedLog $option -ForegroundColor White
            }
        }
            
        $key = [Console]::ReadKey($true)
        $pressedKey = ($key.Key).ToString()

        switch ($pressedKey) {
            "UpArrow" {$selectIndex--}
            "DownArrow" {$selectIndex++}
            "Enter" { return $selectIndex }
        }

        Clear-Host
    }
}