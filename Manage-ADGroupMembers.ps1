### IMPORTANT ###
<#
!!! TO KEEP IN MIND !!!
    KEEP THE PROGRAM AS SIMPLE AS POSSIBLE!
    DO NOT COMPLICATE IT AND DO NOT OVERDO IT!

WHEN YOU WRITE LOGIC AND DO BASIC STYLING, THEN THINK ABOUT DEVELOPING PROGRAM!
#>

### HEAD ###

# SCRIPT PARAMETERS ( must be first in script! only comments before allowed! )#
param(
    [string]$OUPath = "OU=User Groups,OU=Groups,OU=Camp,DC=oldcamp,DC=gothic,DC=inc"
)

# IMPORTED FUNCTIONS #
. ".\Show-ArrowMenu.ps1"

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
Write-IndentedLog "Choose one of the available options below"

# FIRST LOOP #
:firstLoop while ($true) { # OBSOLETE LOOP - REMOVE AFTER YOU FINISH !!!

    $optionsList = @(
        "1. Choose group from a list"
        "2. Exit"
    )

    $optionIndex = Show-ArrowMenu -Title "Choose Group Menu" -Menu $optionsList

    switch ($optionIndex) {
        0 {
            Write-IndentedLog "Getting all groups in Active Directory..."
            Write-Host ""
            Write-IndentedLog "Choose one of the existing groups from the list below"

            $groupsList = Get-ADGroup -Filter * -SearchBase "OU=User Groups,OU=Groups,OU=Camp,DC=oldcamp,DC=gothic,DC=inc" | ForEach-Object {$_.Name}

            $optionIndex = Show-ArrowMenu -Title "List of Active Directory Groups" -Menu $groupsList

            $groupName = $groupsList[$optionIndex]

            # SECOND LOOP #
            :mainLoop while ($true) {

                # MAIN MENU #
                $optionsList = @(
                    "1. Add Member",
                    "2. Remove Member",
                    "3. Show Group Memebers",
                    "4. Choose Other Group",
                    "5. Exit"
                )

                # VARIABLES #
                $optionIndex = Show-ArrowMenu -Title "Main Menu" -Group $groupName -Menu $optionsList
                $membersList = Get-ADGroupMember -Identity $groupName | Select-Object Name -ExpandProperty Name

                # OPTION 1 - ADD MEMBER #
                switch ($optionIndex) {
                    0 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 1 - Add Member" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        
                        # USER VALIDATION LOOP #
                        while ($true) {
                            Write-IndentedLog "Provide existing AD user account you wish to add to the '$groupName' group"
                            Write-IndentedLog "or type [Cancel/C] (case insensitive)"
                                
                            $username = Read-IndentedLog "Type username"

                            if ($username.Length -eq 0) {
                                Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                            } elseif ($username -in $membersList) {
                                Write-IndentedLog "'$username' is already a member of '$groupName' group" -BackgroundColor Red -ForegroundColor White
                            }  elseif ( ($username -eq "cancel") -or ($username -eq "c") ) {
                                Write-IndentedLog "Removing user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                break # breaks user validation loop #
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
                    } 1 { # OPTION 2 - REMOVE MEMBER (or Members!) #
                        Write-Host ""
                        Write-IndentedLog "Chose Option 2 - Remove Member" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""

                        :removeLoop while ($true) {
                                
                            # REMOVE MENU #
                            $optionsList = @(
                                "1. List Group Members ",
                                "2. Type Username ",
                                "3. Back to Main Menu "
                            )

                            $optionIndex = Show-ArrowMenu -Title "Remove Menu" -Group $groupName -Menu $optionsList

                            switch ($optionIndex) {
                                0 {
                                    Write-IndentedLog "| '$groupName' group Members: |"
                                    Write-Host ""
                                    $membersList | ForEach-Object -Process {
                                            Write-IndentedLog "* $_"
                                        } 
                                } 1 {
                                    # USER VALIDATION LOOP #
                                    while ($true) {
                                    Write-IndentedLog "Provide a member of the '$groupName' group you wish to remove"
                                    Write-IndentedLog "or type [Cancel/C] (case insensitive)"
                                    $username = Read-IndentedLog "Type username"

                                        if ($username.Length -eq 0) {
                                            Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                                        } elseif ( ($username -eq "cancel") -or ($username -eq "c") ) {
                                            Write-IndentedLog "Removing user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                            break # breaks user validation loop #
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

                                                break # breaks user validation loop

                                            } else {
                                                Write-IndentedLog "'$username' is not a member of '$groupName' group!" -BackgroundColor Red -ForegroundColor White
                                            }
                                        }
                                    }
                                } 2 {
                                    Write-IndentedLog "Getting back to Main Menu" -BackgroundColor Yellow -ForegroundColor Black
                                    break removeLoop # break remove menu loop
                                }
                            }
                        }
                    } 2 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 3 - Show Group Members" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        Write-IndentedLog "'$groupName' group Members:"
                        Write-Host ""
                        $membersList | ForEach-Object -Process {
                                Write-IndentedLog "* $_"
                            } 
                    } 3 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 4 - Choose Other Group" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        break mainLoop # breaks MAIN MENU loop
                    } 4 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 5 - Exit" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        break firstLoop # Terminates the program
                    }
                }
            }

        } 1 {
        Write-IndentedLog "Chose to exit the program" -BackgroundColor Yellow -ForegroundColor Black
        break firstLoop # breaks FIRST MENU loop #
        }
    }  
}     

Write-IndentedLog "Program closed" -BackgroundColor Blue -ForegroundColor White


<# TO DO:

1. After you finish create options for MANY users (Add MemberS, Remove MemberS)
add functionality to add and remove multiple members!
2. Change all 'Type option number or...' to arrow navigation!
#>
