### IMPORTANT ###
<#
!!! TO KEEP IN MIND !!!
    KEEP THE PROGRAM AS SIMPLE AS POSSIBLE!
    DO NOT COMPLICATE IT AND DO NOT OVERDO IT!

WHEN YOU WRITE LOGIC AND DO BASIC STYLING, THEN THINK ABOUT DEVELOPING PROGRAM!
#>

### HEAD ###

# SCRIPT PARAMETERS #
param(
    [string]$OUPath = "OU=User Groups,OU=Groups,OU=Camp,DC=oldcamp,DC=gothic,DC=inc"
)

# GLOBAL VARIABLES #
$Indent = "`t"

# WRAPPER FUNCTIONS #
# Functions created to change classical Write-Host and Read-Host behaviour
# by adding indentation in the beginning of each message and newline below it
# for better readability

function Write-IndentedLog ($Message) {
    Write-Host "${Indent}$Message" @Args
}

function Read-IndentedLog ($Message) {
    Read-Host "${Indent}$Message"
    Write-Host ""
}

# GLOBAL PREDIFINIED WHITELISTS #
$yesList = "yes y"-split" "
$noList = "no n"-split" "

# STARTING MENU #
$title = "Active Directory Group Member Manager"
Write-IndentedLog ("="*80)
Write-IndentedLog (" " * ((80 - [int]$title.Length) / 2 ) ) $title
Write-IndentedLog ("="*80)

Write-Host ""
Write-IndentedLog "Welcome in Group Member Manager!"
Write-IndentedLog "In this program you can add, remove or get members of any group"
Write-IndentedLog "present in your Active Directory database."
Write-Host ""
Write-IndentedLog "To start, provide name of a an AD group you wish to modify"
Write-IndentedLog "or choose one of the other options by typing option number"
Write-IndentedLog "or option word in square brackets"

# FIRST LOOP #
while ($true) {
    Write-Host ""
    Write-IndentedLog ("-"*80)
    Write-IndentedLog "1. List Active Directory Groups [list/groups]"
    Write-IndentedLog "2. Exit [exit]"
    Write-IndentedLog ("-"*80)
    Write-Host ""
    $groupName = Read-IndentedLog "Type group name or choose other option"

    # WHITELISTS #
    $listGroupsOptions = "list groups l g 1 one" -split" "
    $exitOptions = "exit e 2 two" -split" "

    if ($groupName.Length -eq 0) {
        Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
        Write-IndentedLog "Pass valid AD group name or exit the program by typing [Exit/E] (case insensitive)"
    } elseif ($groupName -in $exitOptions) {
        Write-IndentedLog "Chose to exit the program" -BackgroundColor Yellow -ForegroundColor Black
        break # breaks FIRST MENU loop #
    } elseif ($groupName -in $listGroupsOptions) {
        Write-IndentedLog "Getting all groups in Active Directory..."
        Write-Host ""
        $groupsList = Get-ADGroup -Filter * -SearchBase $OUPath

        Write-IndentedLog "| Active Directory Groups: |"
        Write-Host ""
        foreach ($group in $groupsList) {
            Write-IndentedLog $group.Name
        }

        Write-Host ""
        Write-IndentedLog "Choose one of the existing groups from the list above"
    } else {
        Write-IndentedLog "Validating user input..."
        $groupExists = [bool](Get-ADGroup -Filter "Name -eq '$groupName'")

        if ($groupExists) {
            Write-IndentedLog "$groupName found in Active Directory!" -BackgroundColor Green -ForegroundColor White

            # SECOND LOOP #
            while ($true) {

                # MAIN MENU #
                $menu = "Main Menu"
                Write-Host ""
                Write-IndentedLog ("="*80)
                Write-IndentedLog (" " * ((80 - [int]$menu.Length) / 2 ) ) $menu
                Write-IndentedLog ("="*80)

                Write-Host ""
                Write-IndentedLog "You are currently editing '$groupName' group" -BackgroundColor Yellow -ForegroundColor Black
                Write-Host ""

                Write-IndentedLog "What operation do you want to perform?"
                Write-IndentedLog "1. Add Member"
                Write-IndentedLog "2. Remove Member"
                Write-IndentedLog "3. Show Group Memebers"
                Write-IndentedLog "4. Choose Other Group"
                Write-IndentedLog "5. Exit"
                # make arrow navigation here or type option number

                # WHITELISTS #
                $option1 = "1 one add" -split" "
                $option2 = "2 two remove" -split" "
                $option3 = "3 three show" -split" "
                $option4 = "4 four choose" -split" "
                $option5 = "5 five exit e" -split" "

                $userChoice = Read-IndentedLog "Type option number or first word (case insensitive)"

                if ($userChoice.Length -eq 0) {
                    Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                    Write-IndentedLog "Choose one of the available options"
                
                # OPTION 1 - ADD MEMBER #
                } elseif ($userChoice -in $option1) {
                    Write-IndentedLog "Chose Option 1 - Add Member" -BackgroundColor Yellow -ForegroundColor Black
                    
                    # USER VALIDATION LOOP #
                    while ($true) {
                        Write-IndentedLog "Provide existing AD user account you wish to add to the '$groupName' group"
                        $username = Read-IndentedLog "Type username"

                        if ($username.Length -eq 0) {
                            Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                        } else {
                            try {
                                Get-ADUser -Identity $username -ErrorAction Stop | Out-Null
                                Write-IndentedLog "'$username' found in Active Directory database!"  -BackgroundColor Green -ForegroundColor White
                                Write-IndentedLog "Are you sure you want to add '$username' to the '$groupName' group?"
                                $decision = Read-IndentedLog "Type [Yes/y] or [No/n]"

                                if ($decision -in $yesList) {
                                    Write-IndentedLog "Adding '$username' to the '$groupName' group..."  -BackgroundColor Yellow -ForegroundColor Black
                                    Add-ADGroupMember -Identity $groupName -Members $username
                                    Write-IndentedLog "Adding member completed sucessfully!" -BackgroundColor Green -ForegroundColor White
                                } elseif ($decision -in $noList) {
                                    Write-IndentedLog "Adding user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                } else {
                                    Write-IndentedLog "Passed Invalid value!" -BackgroundColor Red -ForegroundColor White
                                    Write-IndentedLog "User joining aborted"
                                }

                                break # break user validation loop
                            } catch {
                                Write-IndentedLog "'$username' not found in Active Directory database!"  -BackgroundColor Red -ForegroundColor White
                            }
                        }
                    }

                # OPTION 2 - REMOVE MEMBER (or Members!) #
                } elseif ($userChoice -in $option2) {
                    Write-IndentedLog "Chose Option 2 - Remove Member" -BackgroundColor Yellow -ForegroundColor Black

                    
                    while ($true) {

                        # REMOVE MENU #
                        $removeMenu = "Remove Menu"
                        Write-Host ""
                        Write-IndentedLog ("="*80)
                        Write-IndentedLog (" " * ((80 - [int]$removeMenu.Length) / 2 ) ) $removeMenu
                        Write-IndentedLog ("="*80)

                        Write-Host ""
                        Write-IndentedLog "You are currently editing '$groupName' group" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""

                        Write-IndentedLog "1. List Group Members [list/users]"
                        Write-IndentedLog "2. Type Username [user] "
                        Write-IndentedLog "3. Back to Main Menu [back/menu]"
                        Write-IndentedLog "Type option number or option word in square brackets (case insensitive)"
                        $userChoice = Read-IndentedLog "Option"

                        $option1 = "1 one list users"-split" "
                        $option2 = "2 two user"-split" "
                        $option3 = "3 three back menu"-split" "

                        if ($userChoice -in $option1) {
                            Write-IndentedLog "| '$groupName' group Members: |"
                            Write-Host ""
                            Get-ADGroupMember -Identity $groupName | Select-Object Name -ExpandProperty Name |
                                ForEach-Object -Process {
                                    Write-IndentedLog $_
                                } 

                        } elseif ($userChoice -in $option2) {
                            
                            # USER VALIDATION LOOP #
                            while ($true) {
                                Write-IndentedLog "Provide a member of the '$groupName' group you wish to remove"
                                $username = Read-IndentedLog "Type username"

                                $membersList = Get-ADGroupMember -Identity $groupName | Select-Object Name -ExpandProperty Name

                                if ($username.Length -eq 0) {
                                    Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                                } else {
                                    if ($username -in $membersList) {                                
                                        Write-IndentedLog "'$username' is a member of '$groupName' group!"  -BackgroundColor Green -ForegroundColor White
                                        Write-IndentedLog "Are you sure you want to remove '$username' from the '$groupName' group?"
                                        $decision = Read-IndentedLog "Type [Yes/y] or [No/n]"

                                        if ($decision -in $yesList) {
                                            Write-IndentedLog "Removing '$username' from the '$groupName' group..."  -BackgroundColor Yellow -ForegroundColor Black
                                            Remove-ADGroupMember -Identity $groupName -Members $username -Confirm:$false
                                            Write-IndentedLog "Removing member completed sucessfully!" -BackgroundColor Green -ForegroundColor White
                                        } elseif ($decision -in $noList) {
                                            Write-IndentedLog "Removing user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                        } else {
                                            Write-IndentedLog "Passed Invalid value!" -BackgroundColor Red -ForegroundColor White
                                            Write-IndentedLog "User removal aborted"
                                        }

                                        break # break user validation loop

                                    } else {
                                        Write-IndentedLog "'$username' is not a member of '$groupName' group!" -BackgroundColor Red -ForegroundColor White
                                    }
                                }
                            }

                        } elseif ($userChoice -in $option3) {
                            Write-IndentedLog "Getting back to Main Menu" -BackgroundColor Yellow -ForegroundColor Black
                            break # break remove menu loop
                        } else {
                            Write-IndentedLog "Passed invalid value!" -BackgroundColor Red -ForegroundColor White
                            Write-IndentedLog "Choose one of the available options (or exit/go back)"
                        }
                    }

                } elseif ($userChoice -in $option3) {
                    Write-IndentedLog "Chose Option 3 - Show Group Members" -BackgroundColor Yellow -ForegroundColor Black
                    Write-Host ""
                    Write-IndentedLog "'$groupName' group Members:"
                    Write-Host ""
                    Get-ADGroupMember -Identity $groupName | Select-Object Name -ExpandProperty Name |
                        ForEach-Object -Process {
                            Write-IndentedLog $_
                        } 

                } elseif ($userChoice -in $option4) {
                    Write-IndentedLog "Chose Option 4 - Choose Other Group" -BackgroundColor Yellow -ForegroundColor Black
                    break # breaks MAIN MENU loop
                } elseif ($userChoice -in $option5) {
                    Write-IndentedLog "Chose Option 5 - Exit" -BackgroundColor Yellow -ForegroundColor Black
                    exit # Terminates the program
                } else {
                    Write-IndentedLog "Invalid value!" -BackgroundColor Red -ForegroundColor White
                    Write-IndentedLog "Passed value is not an option list or name"
                    Write-IndentedLog "Choose one of the available options"
                }

            }
                # break
                # breaks FIRST MENU loop
                # this break belongs to the if statement
                # it breaks the nearest while loop and that is the first one

        } else {
                Write-IndentedLog "Group $groupName doesn't exist in Active Directory!" -BackgroundColor Red -ForegroundColor White
                Write-IndentedLog "Pass valid AD group name or exit the program by typing [Exit/E] (case insensitive)"
        }        
    }
}

Write-IndentedLog "Program closed" -BackgroundColor Blue -ForegroundColor White


<# TO DO:

1. After you finish create options for MANY users (Add MemberS, Remove MemberS)
add functionality to add and remove multiple members!
2. Change all 'Type option number or...' to arrow navigation!
#>
