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

            $groupsList = Get-ADGroup -Filter * -SearchBase $OUPath | ForEach-Object {$_.Name}

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
                        :addLoop while ($true) {

                            Write-IndentedLog "Provide a member or members you wish to add to the '$groupName' group"
                            Write-IndentedLog "(if you want to add multiple members, separate them with a comma)"
                            Write-IndentedLog "or type [Cancel/C] if you want to cancel operation (case insensitive)"
                            $username = Read-IndentedLog "Type username "

                            $usersList = $username.Split(",").Trim()

                            if ($usersList.Length -eq 0) {
                                Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                            }  elseif ( ($username -eq "cancel") -or ($username -eq "c") ) {
                                Write-IndentedLog "Removing user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                break # breaks user validation loop #
                            } else {
                                foreach ($user in $usersList) {
                                    if ($user -in $membersList) {                                
                                        $Indent
                                        Write-IndentedLog "'$user' is already a member of '$groupName' group!"  -BackgroundColor Yellow -ForegroundColor Black
                                        Write-IndentedLog "Processing to the next user on the list..."
                                        $Indent
                                    } else {
                                        try {
                                            Get-ADUser -Identity $user -ErrorAction Stop | Out-Null
                                            Write-IndentedLog "'$user' found in Active Directory database!"  -BackgroundColor Green -ForegroundColor White
                                            Write-IndentedLog "Are you sure you want to add '$user' to the '$groupName' group?"
                                            $decision = Read-IndentedLog "Type [Yes/y] or [No/n]"

                                            if ($decision -in $yesList) {
                                                Write-IndentedLog "Adding '$user' to the '$groupName' group..."  -BackgroundColor Yellow -ForegroundColor Black
                                                try {
                                                Add-ADGroupMember -Identity $groupName -Members $user -ErrorAction Stop
                                                
                                                $Indent
                                                Write-IndentedLog "Adding member completed sucessfully!" -BackgroundColor Green -ForegroundColor White
                                                } catch {
                                                Write-IndentedLog "CRITICAL: Failed to add '$user'. Verify your AD permissions." -BackgroundColor Red -ForegroundColor White
                                                }
                                                $Indent
                                            } elseif ($decision -in $noList) {
                                                Write-IndentedLog "Adding user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                            } else {
                                                Write-IndentedLog "Passed Invalid value!" -BackgroundColor Red -ForegroundColor White
                                                Write-IndentedLog "User joining aborted"
                                            }
                                        } catch {
                                            $Indent
                                            Write-IndentedLog "'$user' not found in Active Directory database!"  -BackgroundColor Red -ForegroundColor White
                                            Write-IndentedLog "Processing to the next user on the list..."
                                            $Indent
                                        }
                                    }  
                                }
                                Write-IndentedLog "No more users left to add"
                                break addLoop # break user validation loop
                            }
                        }
                    }
                    
                    1 { # OPTION 2 - REMOVE MEMBER (or Members!) #
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
                                }
                                
                                1 {
                                    # USER VALIDATION LOOP #
                                    :removeLoop2 while ($true) {

                                        Write-IndentedLog "Provide a member or members of the '$groupName' group you wish to remove"
                                        Write-IndentedLog "(if you want to remove multiple members, separate them with a comma)"
                                        Write-IndentedLog "or type [Cancel/C] if you want to cancel operation (case insensitive)"
                                        $username = Read-IndentedLog "Type username "

                                        $usersList = $username.Split(",").Trim()

                                        if ($usersList.Length -eq 0) {
                                            Write-IndentedLog "No input passed" -BackgroundColor Red -ForegroundColor White
                                        } elseif ( ($username -eq "cancel") -or ($username -eq "c") ) {
                                            Write-IndentedLog "Removing user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                            break # breaks user validation loop #
                                        } else {
                                            foreach ($user in $usersList) {
                                                if ($user -in $membersList) {                                
                                                    $Indent
                                                    Write-IndentedLog "'$user' is a member of '$groupName' group!"  -BackgroundColor Green -ForegroundColor White
                                                    $Indent
                                                    Write-IndentedLog "Are you sure you want to remove '$user' from the '$groupName' group?"
                                                    $decision = Read-IndentedLog "Type [Yes/y] or [No/n]"

                                                    if ($decision -in $yesList) {
                                                        Write-IndentedLog "Removing '$user' from the '$groupName' group..."  -BackgroundColor Yellow -ForegroundColor Black
                                                        try {
                                                        Remove-ADGroupMember -Identity $groupName -Members $user -Confirm:$false -ErrorAction Stop
                                                        $Indent
                                                        Write-IndentedLog "Removing member completed sucessfully!" -BackgroundColor Green -ForegroundColor White
                                                        } catch {
                                                        Write-IndentedLog "CRITICAL: Failed to remove '$user'. Verify your AD permissions." -BackgroundColor Red -ForegroundColor White
                                                        }
                                                    } elseif ($decision -in $noList) {
                                                        Write-IndentedLog "Removing user canceled" -BackgroundColor Yellow -ForegroundColor Black
                                                    } else {
                                                        Write-IndentedLog "Passed Invalid value!" -BackgroundColor Red -ForegroundColor White
                                                        Write-IndentedLog "User removal aborted"
                                                    }
                                                } else {
                                                    $Indent
                                                    Write-IndentedLog "'$user' is not a member of '$groupName' group!" -BackgroundColor Red -ForegroundColor White
                                                    Write-IndentedLog "Processing to the next user on the list..."
                                                    $Indent
                                                }
                                            }
                                            $Indent
                                            Write-IndentedLog "No more users left to remove"

                                            $membersList = Get-ADGroupMember -Identity $groupName | Select-Object Name -ExpandProperty Name
                                            break removeLoop2 # breaks user validation loop

                                        }
                                    }
                                }
                                
                                2 {
                                    Write-IndentedLog "Getting back to Main Menu" -BackgroundColor Yellow -ForegroundColor Black
                                    break removeLoop # break remove menu loop
                                }
                            }
                        }
                    }
                    
                    2 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 3 - Show Group Members" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        Write-IndentedLog "'$groupName' group Members:"
                        Write-Host ""
                        $membersList | ForEach-Object -Process {
                                Write-IndentedLog "* $_"
                            } 
                    }
                    
                    3 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 4 - Choose Other Group" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        break mainLoop # breaks MAIN MENU loop
                    }
                    
                    4 {
                        Write-Host ""
                        Write-IndentedLog "Chose Option 5 - Exit" -BackgroundColor Yellow -ForegroundColor Black
                        Write-Host ""
                        break firstLoop # Terminates the program
                    }
                }
            }

        }
        
        1 {
        Write-IndentedLog "Chose to exit the program" -BackgroundColor Yellow -ForegroundColor Black
        break firstLoop # breaks FIRST MENU loop #
        }
    }  
}     

Write-IndentedLog "Program closed" -BackgroundColor Blue -ForegroundColor White