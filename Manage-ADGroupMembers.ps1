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


### HEAD ###

# SCRIPT PARAMETERS #
param(
    [string]$OUPath = "OU=User Groups,OU=Groups,OU=Camp,DC=oldcamp,DC=gothic,DC=inc"
)

$Indent = "`t"

# WRAPPER FUNCTIONS #
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
$option1 = "1 one add" -split" "
$option2 = "2 two remove" -split" "
$option3 = "3 three show" -split" "
$option4 = "4 four choose" -split" "
$option5 = "5 five exit e" -split" "

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
    $groupName = Read-IndentedLog "Type group name or list the groups"

    if ($groupName.Length -eq 0) {
        Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
        Write-IndentedLog "Pass valid AD group name or exit the program by typing [Exit/E] (case insensitive)"
    } elseif ($groupName -in $exitOptions) {
        Write-IndentedLog "Chose to exit the program" -BackgroundColor Yellow -ForegroundColor Black
        break
    } elseif ($groupName -in $listGroupsOptions) {
        Write-IndentedLog "Getting all groups in Active Directory..."
        Write-Host ""
        $groupsList = Get-ADGroup -Filter * -SearchBase $OUPath

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

                # SECOND LOOP #
                while ($true) {

                # MAIN MENU #
                $menu = "Main Menu"
                Write-IndentedLog ("="*80)
                Write-IndentedLog (" " * ((80 - [int]$menu.Length) / 2 ) ) $menu
                Write-IndentedLog ("="*80)

                Write-IndentedLog "You are currently editing $groupName group" -BackgroundColor Yellow -ForegroundColor Black
                Write-IndentedLog "What operation do you want to perform?"
                Write-IndentedLog "1. Add Member"
                Write-IndentedLog "2. Remove Member"
                Write-IndentedLog "3. Show Group Memebers"
                Write-IndentedLog "4. Choose Other Group"
                Write-IndentedLog "5. Exit"
                # make arrows work here or type option number

                $userChoice = Read-IndentedLog "Type option number or first word (case insensitive)"

                if ($userChoice.Length -eq 0) {
                    Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                } elseif ($userChoice -in $option1) {
                    Write-IndentedLog "Chose Option 1 - Add Member" -BackgroundColor Yellow -ForegroundColor Black
                } elseif ($userChoice -in $option2) {
                    Write-IndentedLog "Chose Option 2 - Remove Member" -BackgroundColor Yellow -ForegroundColor Black
                } elseif ($userChoice -in $option3) {
                    Write-IndentedLog "Chose Option 3 - Show Group Members" -BackgroundColor Yellow -ForegroundColor Black
                } elseif ($userChoice -in $option4) {
                    Write-IndentedLog "Chose Option 4 - Choose Other Group" -BackgroundColor Yellow -ForegroundColor Black
                } elseif ($userChoice -in $option1) {
                    Write-IndentedLog "Chose Option 5 - Exit" -BackgroundColor Yellow -ForegroundColor Black
                } else {
                    Write-IndentedLog "Invalid value!" -BackgroundColor Red -ForegroundColor White
                    Write-IndentedLog "Passed value is not an option list or name"
                    Write-IndentedLog "Choose one of the available options"
                }

                # make arrows work here or type option number
                break # breaks second loop, to the first while loop

                }
                break # breaks first loop

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
