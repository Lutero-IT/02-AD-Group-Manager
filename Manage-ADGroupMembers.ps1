# Functions created to change classical Write-Host and Read-Host behaviour
# by adding indentation in the beginning of each message and newline below it
# for better readability

$Indent = "`t"

function Write-IndentedLog ($Message) {
    Write-Host "${Indent}$Message" @Args
    Write-Host ""
}

function Read-IndentedLog ($Message) {
    Read-Host "${Indent}$Message"
}

# PREDIFINIED WHITELISTS #
$exitOptions = "exit e" -split" "
Write-Host $exitOptions
Write-Host $exitOptions.GetType()

Write-IndentedLog "Welcome in Group Member Manager!"
Write-IndentedLog "In this program you can add, remove or get members of any group"
Write-IndentedLog "present in your Active Directory database."
Write-IndentedLog "To start, provide name of a an AD group you wish to modify"

while ($true) {
    $groupName = Read-IndentedLog

    Write-Host "The input: $groupname"
    Write-Host "The type: " $groupname.GetType()
    Write-Host "The length: " $groupName.Length

    if ($groupName.Length -eq 0) {
        Write-IndentedLog "No input passed" # style it to look like warning
        Write-IndentedLog "Pass valid AD group name or..."
        Write-IndentedLog "...exit the program by typing [Exit/E] (case insesitive)"
    } elseif ($groupName -in $exitOptions) {
        Write-IndentedLog "Chose to exit the program"
        break
    } else {
        Write-IndentedLog "Chose to continue..."
        break
    }
}
Write-IndentedLog "Program closed"

<# TO DO:
Write while loop that will check wheher $groupName:
1. is not empty. If it is, inform the user and repeat the request or offer to exit the program.
2. is a valid group name, meaning if the group exists in database. If not, inform the user
and repeat the request or offer exit option.
3. if it is valid, proceed with the program and present main menu. #>
