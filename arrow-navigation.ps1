<# TO USE LATER !!!
$oldCampList = "Ore Barons", "Guards", "Shadows", "Fire Mages", "Diggers"
$newCampList = "Mercenaries, Rogues, Water Mages, Moles"
$sectCampList = "Gurus", "Temple Guards", "Novices"
$chooseRole = "Choose your role"

$chooseRole
$key = [Console]::ReadKey($true)
$key.Key

#>

$campList = "Old Camp", "New Camp", "Sect Camp"
$maxIndex = ($campList.Length - 1)
$chooseCamp = "Choose your camp"
$exitOption = "exit"

$chooseCamp

$pressedKey = ""
$selectIndex = 0

while ($pressedKey -ne "Enter") { # CONDITION DONE
    
    # INDEX VALIDATION DONE
    if ( $selectIndex -gt $maxIndex ) {
        $selectIndex = 0    
    } elseif ( $selectIndex -lt 0 ) {
        $selectIndex = $maxIndex
    }

    foreach ($camp in $campList) {
        if ($campList.IndexOf($camp) -eq $selectIndex) {
            Write-Host $camp -BackgroundColor Yellow -ForegroundColor Black
        } else {
            Write-Host $camp -ForegroundColor White
        }
    } # FOREACH DONE
        
    $key = [Console]::ReadKey($true)
    $pressedKey = ($key.Key).ToString()
    # $key.Key type change DONE

    # SWITCH HERE
    switch ($pressedKey) {
        "UpArrow" {$selectIndex++} # what if index more than max. index
        "DownArrow" {$selectIndex--} # what if index less than min. index
        "Enter" { $userCamp = $campList[$selectIndex]}
    }
    # FINISH SWITCH and TEST PROGRAM

    Clear-Host
}

Write-Host "You chose:" $userCamp

<# TO DO:
    1. DO COMMIT! Commit the arrow-navigation.ps1 script and in the next commit turn it into a function
    that you will make use of in Manage-ADGroupMembers.ps1
    2. after you write the function with parrameters, test it with two lists above: $campList and Roles' Lists!
    3. When script will be ready check how to launch it in Windows Terminal and not CMD or PowerShell ( Error !)
    4. make program versatile by chaning all harcoded values like $campList or $userCamp to the function parameters
    like $list or $userChoice
#>

# READ about [Console], [Convert], [math], etc.
# Elementy Arrow Navigation: Switch ustawiony na wciśnięcie Enter, co zapisze wybraną opcję
# i wykona odpowiednią operację
# POCZYTAĆ O SWITCH
# stworzyć kod, któy będzie pokazywał aktualnie wybraną opcję