# Check if the ticketNumber variable exists
if (-not $ticketIdOrNumber) {
    Write-Host "Ticket number is missing. Script will not continue."
    exit
}

# Define the directory path where you want to save the screenshot
$DirectoryPath = "C:\Support"

# Ensure the directory exists, create it if it doesn't
if (-not (Test-Path -Path $DirectoryPath -PathType Container)) {
    New-Item -Path $DirectoryPath -ItemType Directory
}

# Define the file path where you want to save the screenshot
$FileName = "screenshot.jpg"
$FilePath = Join-Path -Path $DirectoryPath -ChildPath $FileName

# Import the Syncro module
Import-Module $env:SyncroModule -WarningAction SilentlyContinue

# Take a screenshot and save it to the specified file path
Get-ScreenCapture -FullFileName $FilePath

# Verify if the file exists
if (Test-Path -Path $FilePath -PathType Leaf) {
    Write-Host "Screenshot saved to $FilePath"

    # Upload the screenshot file to Syncro and attach it to the ticket
    $uploadedFile = Upload-File -FilePath $FilePath
    
    # Attach the uploaded file to the ticket
    Attach-FileToSyncroTicket -TicketIdOrNumber $ticketNumber -FileId $uploadedFile.id
    
    # Delete the local screenshot file
    Remove-Item -Path $FilePath
} else {
    Write-Host "Failed to save the screenshot."
}
