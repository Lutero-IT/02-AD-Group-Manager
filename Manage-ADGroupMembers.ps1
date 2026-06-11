### IMPORTANT ###
<#
!!! TO KEEP IN MIND !!!
    KEEP THE PROGRAM AS SIMPLE AS POSSIBLE!
    DO NOT COMPLICATE IT AND DO NOT OVERDO IT!

WHEN YOU WRITE LOGIC AND DO BASIC STYLING, THEN THINK ABOUT DEVELOPING PROGRAM!
#>


# Functions created to change classical Write-Host and Read-Host behaviour
# by adding indentation in the beginning of each message and newline below it
# for better readability

$Indent = "`t"

function Write-IndentedLog ($Message) {
    Write-Host "${Indent}$Message" @Args
}

function Read-IndentedLog ($Message) {
    Read-Host "${Indent}$Message"
    Write-Host ""
}

# PREDIFINIED WHITELISTS #
$exitOptions = "exit e" -split" "
$listGroupsOptions = "list groups l g" -split" "

# STARTING MENU #
$title = "Active Directory Group Member Manager"

# ================== #

Write-IndentedLog ("="*80)
Write-IndentedLog (" " * ((80 - [int]$title.Length) / 2 ) ) $title
Write-IndentedLog ("="*80)

Write-Host ""
Write-IndentedLog "Welcome in Group Member Manager!"
Write-IndentedLog "In this program you can add, remove or get members of any group"
Write-IndentedLog "present in your Active Directory database."
Write-IndentedLog "To start, provide name of a an AD group you wish to modify"
Write-IndentedLog "If you wish to get a list of existing groups in AD, type [List/l] or [Groups/g] (case insensitive)"

# FIRST LOOP #
while ($true) {
    $groupName = Read-IndentedLog

<# CODE TO TEST INPUT - delete in final version of the script!!!
    Write-Host "The input: $groupname"
    Write-Host "The type: " $groupname.GetType()
    Write-Host "The length: " $groupName.Length
#>
    if ($groupName.Length -eq 0) {
        Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
        Write-IndentedLog "Pass valid AD group name or exit the program by typing [Exit/E] (case insensitive)"
    } elseif ($groupName -in $exitOptions) {
        Write-IndentedLog "Chose to exit the program" -BackgroundColor Yellow -ForegroundColor Black
        break
    } elseif ($groupName -in $listGroupsOptions) {
        Write-IndentedLog "Getting all groups in Active Directory..."
        Write-Host ""
        # HARDCODED VALUE BELOW #
        $groupsList = Get-ADGroup -Filter * -SearchBase "OU=User Groups,OU=Groups,OU=Camp,DC=oldcamp,DC=gothic,DC=inc"
        foreach ($group in $groupsList) {
            Write-IndentedLog $group.Name
        }

        Write-Host ""
        Write-IndentedLog "Choose one of the existing groups from the list above to modify or exit the program by typing [Exit/E] (case insensitive)"
    } else {
        Write-IndentedLog "Validating user input..."
        $groupExists = [bool](Get-ADGroup -Filter "Name -eq '$groupName'")
            if ($groupExists) {
                Write-IndentedLog "$groupName found in Active Directory!" -BackgroundColor Green -ForegroundColor White
                break
            } else {
                Write-IndentedLog "Group $groupName doesn't exist in Active Directory!" -BackgroundColor Red -ForegroundColor White
                Write-IndentedLog "Pass valid AD group name or exit the program by typing [Exit/E] (case insensitive)"
            }        
    }
}

# CHECK IF GROUP EXISTS IN DATABASE #



Write-IndentedLog "Program closed" -BackgroundColor Blue -ForegroundColor White

# MAIN MENU #


<# TO DO:

Write while loop that will check wheher $groupName:
2. is a valid group name, meaning if the group exists in database. If not, inform the user
and repeat the request or offer exit option. - DONE
2a. In addition to prompt for a group name or exit option, offer to list all the groups in Active Directory
to user to choose from.
3. if it is valid, proceed with the program and present main menu. 
#>
