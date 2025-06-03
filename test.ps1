Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Set preferences to run silently
$ConfirmPreference = 'None'
$ErrorActionPreference = 'SilentlyContinue'

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
