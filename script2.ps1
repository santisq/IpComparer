Add-Type -AssemblyName System.Windows.Forms

$FormObject=[System.Windows.Forms.Form]
$LabelObject=[System.Windows.Forms.Label]

$DefaultFont='Gadugi, 10'
$HeaderFont='Gadugi, 16'

# Design the form now
$AppForm=New-Object $FormObject

$AppForm.ClientSize='1000,700'
$AppForm.Text='Your Favorite IT Team'
$AppForm.BackColor='#ffffff'
$AppForm.Font=$DefaultFont
$AppForm.StartPosition = "CenterScreen"


# MAIN WELCOME IMAGE
$img = [System.Drawing.Image]::Fromfile('\\Mac\Home\Desktop\GUI-AutoPilot\bg\Welcome.png')
$WelcomeBox = new-object Windows.Forms.PictureBox
$WelcomeBox.Width = $img.Size.Width
$WelcomeBox.Height = $img.Size.Height
$WelcomeBox.Location=New-Object System.Drawing.Point(15,30)
$WelcomeBox.Image = $img


# O365 Related Image
$img = [System.Drawing.Image]::Fromfile('\\Mac\Home\Desktop\GUI-AutoPilot\bg\O365Suite.png')
$OfficeBox = new-object Windows.Forms.PictureBox
$OfficeBox.Width = $img.Size.Width
$OfficeBox.Height = $img.Size.Height
$OfficeBox.Location=New-Object System.Drawing.Point(15,30)
$OfficeBox.Image = $img


# Firefox Related Image
$img = [System.Drawing.Image]::Fromfile('\\Mac\Home\Desktop\GUI-AutoPilot\bg\BrowserImage.png')
$BrowserBox = new-object Windows.Forms.PictureBox
$BrowserBox.Width = $img.Size.Width
$BrowserBox.Height = $img.Size.Height
$BrowserBox.Location=New-Object System.Drawing.Point(15,30)
$BrowserBox.Image = $img



# DisplayLink Related Image
$img = [System.Drawing.Image]::Fromfile('\\Mac\Home\Desktop\GUI-AutoPilot\bg\DriversImage.png')
$DriversBox = new-object Windows.Forms.PictureBox
$DriversBox.Width = $img.Size.Width
$DriversBox.Height = $img.Size.Height
$DriversBox.Location=New-Object System.Drawing.Point(15,30)
$DriversBox.Image = $img



# Filezilla Related Image
$img = [System.Drawing.Image]::Fromfile('\\Mac\Home\Desktop\GUI-AutoPilot\bg\OtherUtilities.png')
$FileZillaBox = new-object Windows.Forms.PictureBox
$FileZillaBox.Width = $img.Size.Width
$FileZillaBox.Height = $img.Size.Height
$FileZillaBox.Location=New-Object System.Drawing.Point(15,30)
$FileZillaBox.Image = $img


# NOW CALL THE WELCOME IMAGE ONLY

    $AppForm.Controls.AddRange(@($WelcomeBox ))
    $AppForm.ShowDialog()


# App Related STATUS DISPLAY #1
# Check if O365 is installed then add O365 icon in the form.
# First O365 Suite

$software1 = "Microsoft Office 18.19.20”;
$installed = (Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | Where { $_.DisplayName -eq $software1 }) -ne $null

If(-Not $installed) {
    Write-Host "'$software' is NOT installed.";
} else {
    Write-Host "'$software' is installed."
    # So if its installed, lets show it on the Windows form and let the user know.
    $AppFo
}