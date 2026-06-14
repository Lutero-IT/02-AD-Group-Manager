$oldCampList = "Ore Barons", "Guards", "Shadows", "Fire Mages", "Diggers"
$newCampList = "Mercenaries", "Rogues", "Water Mages", "Moles"
$sectCampList = "Gurus", "Temple Guards", "Novices"
$chooseRole = "Choose your role"

$campList = "Old Camp", "New Camp", "Sect Camp"
$chooseCamp = "Choose your camp"

. "C:\Users\Dom\Desktop\ShareFolder\02-AD-Group-Manager\Show-ArrowMenu.ps1"

$chooseCamp
$userChoice = Show-ArrowMenu $campList

$chooseRole
if ($userChoice -eq "Old Camp") {
    Show-ArrowMenu $oldCampList
} elseif ($userChoice -eq "New Camp") {
    Show-ArrowMenu $newCampList
} elseif ($userChoice -eq "Sect Camp") {
    Show-ArrowMenu $sectCampList
} else {
    Write-Host "You haven't choosen any camp!"
}


