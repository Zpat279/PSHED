Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set preferences to run silently
$ConfirmPreference = 'None'
$ErrorActionPreference = 'SilentlyContinue'

# SHOW LOADING SCREEN

# Add a label to display ASCII art
$asciiArt = @"
   __   ____  ___   ___  _____  _______
  / /  / __ \/ _ | / _ \/  _/ |/ / ___/
 / /__/ /_/ / __ |/ // // //    / (_ / 
/____/\____/_/ |_/____/___/_/|_/\___/
"@

$label = New-Object System.Windows.Forms.Label
$label.Text = $HackEmDown
$label.Font = New-Object System.Drawing.Font("Consolas", 20)
$label.ForeColor = 'Yellow'
$label.AutoSize = $true

# Center the label within the form
$label.Location = New-Object System.Drawing.Point(
    [int](($form.ClientSize.Width - $label.PreferredWidth) / 2),
    [int](($form.ClientSize.Height - $label.PreferredHeight) / 2)
)
$form.Controls.Add($label)

# Adjust the label's location when the form resizes
$form.add_SizeChanged({
    $label.Location = New-Object System.Drawing.Point(
        [int](($form.ClientSize.Width - $label.PreferredWidth) / 2),
        [int](($form.ClientSize.Height - $label.PreferredHeight) / 2)
    )
})

# Show the form
$form.Show()

# END OF LOADING SCREEN

# MAKE THE PARTITION --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Ensure the directory exists
$vdiskPath = "C:\temp\ddr.vhd"
$vdiskSizeMB = 2048 # Size of the virtual disk in MB (2 GB)

# Step 1: Check if the virtual disk already exists and remove it if it does
if (Test-Path -Path $vdiskPath) {
  Remove-Item -Path $vdiskPath -Force
}

# Step 2: Create the virtual disk (expandable)
$createVHDScript = @"
create vdisk file=`"$vdiskPath`" maximum=$vdiskSizeMB type=expandable
"@
$scriptFileCreate = "C:\temp\$(Get-Random -Minimum 10000 -Maximum 99999)"
$createVHDScript | Set-Content -Path $scriptFileCreate

# Execute the diskpart command to create the virtual disk
diskpart /s $scriptFileCreate

# Step 3: Attach the virtual disk
$attachVHDScript = @"
select vdisk file=`"$vdiskPath`"
attach vdisk
"@
$scriptFileAttach = "C:\temp\$(Get-Random -Minimum 10000 -Maximum 99999)"
$attachVHDScript | Set-Content -Path $scriptFileAttach

# Execute the diskpart command to attach the virtual disk
diskpart /s $scriptFileAttach

# Step 4: Wait for the disk to be detected by the system
Start-Sleep -Seconds 5  # Allow a moment for the disk to be registered by the OS

# Retrieve the attached disk (assuming it's the last disk created)
$disk = Get-Disk | Sort-Object -Property Number | Select-Object -Last 1

# Check if the disk is offline, and set it online if needed
if ($disk.IsOffline -eq $true) {
    Set-Disk -Number $disk.Number -IsOffline $false
}

# Initialize the disk if it's in raw state (uninitialized)
if ($disk.PartitionStyle -eq 'Raw') {
    Initialize-Disk -Number $disk.Number -PartitionStyle MBR
}

# Step 5: Create a new partition and explicitly assign drive letter Z
$partition = New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter Z

# Step 6: Format the volume with FAT32 and set label
Format-Volume -DriveLetter Z -FileSystem FAT32 -NewFileSystemLabel "Local Disk" -Confirm:$false

# END OF MAKING PARTITION ------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Close the old form
$form.Close()

# Hide PowerShell console window
Add-Type -Name Win -Namespace Console -MemberDefinition @'
    [DllImport("user32.dll")]
    public static extern bool ShowWindow(IntPtr hWnd, int nCmdShow);
    [DllImport("kernel32.dll")]
    public static extern IntPtr GetConsoleWindow();
'@

$consolePtr = [Console.Win]::GetConsoleWindow()
[Console.Win]::ShowWindow($consolePtr, 0)

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = 'ASCII UI'
$form.Size = New-Object System.Drawing.Size(650, 400)
$form.StartPosition = 'CenterScreen'
$form.BackColor = 'Black'

# ASCII Art Label
$asciiArt = @"
  __  __     ______     ______     __  __     ______     __    __     _____     ______     __     __     __   __    
 /\ \_\ \   /\  __ \   /\  ___\   /\ \/ /    /\  ___\   /\ "-./  \   /\  __-.  /\  __ \   /\ \  _ \ \   /\ "-.\ \   
 \ \  __ \  \ \  __ \  \ \ \____  \ \  _"-.  \ \  __\   \ \ \-./\ \  \ \ \/\ \ \ \ \/\ \  \ \ \/ ".\ \  \ \ \-.  \  
  \ \_\ \_\  \ \_\ \_\  \ \_____\  \ \_\ \_\  \ \_____\  \ \_\ \ \_\  \ \____-  \ \_____\  \ \__/".~\_\  \ \_\\"\_\ 
   \/_/\/_/   \/_/\/_/   \/_____/   \/_/\/_/   \/_____/   \/_/  \/_/   \/____/   \/_____/   \/_/   \/_/   \/_/ \/_/
 ===================================================================================================================
"@

$label = New-Object System.Windows.Forms.Label
$label.Text = $asciiArt
$label.Font = New-Object System.Drawing.Font('Courier New', 9)
$label.ForeColor = 'Yellow'
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(50, 50)

# Define Main Menu Buttons
$injectButton = New-Object System.Windows.Forms.Button
$injectButton.Text = 'Inject'
$injectButton.Width = 100
$injectButton.Height = 40
$injectButton.Location = New-Object System.Drawing.Point(162, 200)
$injectButton.BackColor = 'Green'
$injectButton.ForeColor = 'Black'

$destructButton = New-Object System.Windows.Forms.Button
$destructButton.Text = 'Destruct'
$destructButton.Width = 100
$destructButton.Height = 40
$destructButton.Location = New-Object System.Drawing.Point(280, 200)
$destructButton.BackColor = 'Red'
$destructButton.ForeColor = 'Black'

# Function to return to main menu
function Show-MainMenu {
    $form.Controls.Clear()
    $form.Controls.Add($label)
    $form.Controls.Add($injectButton)
    $form.Controls.Add($destructButton)
}

# Inject Button Click: Show Prestige and Vape buttons
$injectButton.Add_Click({
    $form.Controls.Clear()
    $form.Controls.Add($label)

    # Back Button
    $backButton = New-Object System.Windows.Forms.Button
    $backButton.Text = 'Back'
    $backButton.Width = 100
    $backButton.Height = 40
    $backButton.Location = New-Object System.Drawing.Point(500, 300)
    $backButton.BackColor = 'DarkRed'
    $backButton.ForeColor = 'Black'
    $backButton.Add_Click({ Show-MainMenu })

    # Prestige Button
    $prestigeButton = New-Object System.Windows.Forms.Button
    $prestigeButton.Text = 'Prestige'
    $prestigeButton.Width = 120
    $prestigeButton.Height = 40
    $prestigeButton.Location = New-Object System.Drawing.Point(150, 200)
    $prestigeButton.BackColor = 'Purple'
    $prestigeButton.ForeColor = 'White'

    # Vape Button
    $vapeButton = New-Object System.Windows.Forms.Button
    $vapeButton.Text = 'Vape'
    $vapeButton.Width = 120
    $vapeButton.Height = 40
    $vapeButton.Location = New-Object System.Drawing.Point(300, 200)
    $vapeButton.BackColor = 'LightBlue'
    $vapeButton.ForeColor = 'Black'

    # Add buttons to form
    $form.Controls.Add($prestigeButton)
    $form.Controls.Add($vapeButton)
    $form.Controls.Add($backButton)

    # === YOUR CUSTOM PRESTIGE LOGIC HERE ===
    $prestigeButton.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("Prestige logic placeholder", "Prestige")
        # Replace this with your real code
    })

    # === YOUR CUSTOM VAPE LOGIC HERE ===
    $vapeButton.Add_Click({
        [System.Windows.Forms.MessageBox]::Show("Vape logic placeholder", "Vape")
        # Replace this with your real code
    })
        # ============================== DESTRUCT BUTTON =================================================================================================================================
    $destructButton.Add_Click({
# Define the virtual disk path and disk number (from your previous setup)
$vdiskPath = "C:\temp\ddr.vhd"
$diskNumber = 3  # Replace with the correct disk number from your system

# Step 1: Dismount (detach) the virtual disk if attached
$detachScript = @"
select vdisk file='$vdiskPath'
detach vdisk
"@
$detachVhdFile = "C:\temp\$(Get-Random -Minimum 10000 -Maximum 99999)"
$detachScript | Set-Content -Path $detachVhdFile
diskpart /s $detachVhdFile
Remove-Item -Path $detachVhdFile -Force

# Step 2: Initialize the disk (if it's not initialized already)
$initializeDiskScript = @"
select disk $diskNumber
online disk
convert mbr
"@
$initializeDiskFile = "C:\temp\$(Get-Random -Minimum 10000 -Maximum 99999)"
$initializeDiskScript | Set-Content -Path $initializeDiskFile
diskpart /s $initializeDiskFile
Remove-Item -Path $initializeDiskFile -Force

# Step 3: Create a partition if none exists and assign Z: drive letter
$createPartitionScript = @"
select disk $diskNumber
create partition primary
assign letter=Z
"@
$createPartitionFile = "C:\temp\$(Get-Random -Minimum 10000 -Maximum 99999)"
$createPartitionScript | Set-Content -Path $createPartitionFile
diskpart /s $createPartitionFile
Remove-Item -Path $createPartitionFile -Force

# Step 4: Remove the virtual disk file from the system
Remove-Item -Path $vdiskPath -Force

# Step 5: Delete shortcut files from the Recent folder
$recentFolderPath = [Environment]::GetFolderPath("Recent")
Get-ChildItem -Path $recentFolderPath -Filter "*.lnk" | Where-Object { 
    $_.Name -like "javaruntime.ps1*" -or $_.Name -like "powershell*" 
} | ForEach-Object {
    Remove-Item -Path $_.FullName -Force -ErrorAction SilentlyContinue
}

# Output a confirmation message
Write-Host "Destruction complete: Virtual disk, partitions, and recent files removed successfully."

# Remove drive letter association from the registry (if applicable)
Remove-ItemProperty -Path "HKLM:\SYSTEM\MountedDevices" -Name "\DosDevices\Z:" -ErrorAction SilentlyContinue

# END OF DESTRUCT LOGIC =============================================================
    })
})

# Destruct Button Click: Do nothing for now
$destructButton.Add_Click({
    # === PLACEHOLDER FOR FUTURE DESTRUCT LOGIC ===
    # Nothing happens yet — safe to click!
    # Add your destruct logic here when ready
})

# Initial Load
Show-MainMenu

# Run the form
[void]$form.ShowDialog()
