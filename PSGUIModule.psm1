<#
Created by: Raph.Gallardo
        Raph.Gallardo@gmail.com
        Created on 11/18/2015
#>

Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing
<# Examples



To open the panel:
    [void] $mainWindow.ShowDialog()

To add something to another panel:
    $mainWindow.Controls.Add($button)

To get an item from a text box:
    $button.text

To get an item from a dropdown:
    $dropdown.selectedItem

To add a click action to a button:
    $SelectFolder.Add_Click({
        ::do stuff::
    })
To import this module:
    $PSGUIModule = Import-Module -name "c:\DirectoryName" -AsCustomObject -Force -NoClobber
    *Note: DirectoryName needs to be the same as the .psm1 file.*

#>



function mainWindow {
    param (
    [string]$text, [int32]$w, [int32]$h
    )
    $mainWindow = New-Object System.Windows.Forms.Form
    $mainWindow.width = $w
    $mainWindow.height = $h
    $mainWindow.Text = $text
    $mainWindow.StartPosition = "CenterScreen"
    return $mainWindow
}

function textLabel {
    param (
        [string]$text, [int32]$x, [int32]$y, [int32]$w, [int32]$h
        )
    $textlabel = New-Object System.Windows.Forms.Label
    $textlabel.Location = New-Object System.Drawing.Size($x,$y)
    $textlabel.Size = New-Object System.Drawing.Size($w,$h)
    $textlabel.Text = "$text"
    return $textlabel
}

function button {
    param (
        [string]$text, [int32]$x, [int32]$y, [int32]$w, [int32]$h
        )
    $button = new-object System.Windows.Forms.Button
    $button.Location = new-object System.Drawing.size($x,$y)
    $button.Size = new-object System.Drawing.Size($w,$h)
    $button.Text = "$text"
    return $button
}

function outputBox {
    param (
        [string]$text, [int32]$x, [int32]$y, [int32]$w, [int32]$h
        )
    $outputBox = New-Object System.Windows.Forms.TextBox
    $outputBox.Location = New-Object System.Drawing.Size($x,$y)
    $outputBox.Size = New-Object System.Drawing.Size($w,$h)
    $outputBox.MultiLine = $true
    $outputBox.Enabled = $false
    $outputBox.text = "$text"
    return $outputBox
}

function calendarSelection {
    param (
        [int32]$x,[int32]$y
        )
    $objCalendar = New-Object System.Windows.Forms.MonthCalendar
    $objCalendar.Location = new-object System.Drawing.size($x,$y)
    $objCalendar.ShowTodayCircle = $false
    $objCalendar.MaxSelectionCount = 1
    return $objCalendar
}

function dropDownBox {
    param (
        [int32]$x, [int32]$y, [int32]$w, [int32]$h, [array]$list
        )

    $dropDownBox = New-Object System.Windows.Forms.ComboBox
    $dropDownBox.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
    $dropDownBox.Location = New-Object System.Drawing.Size($x,$y)
    $dropDownBox.Size = New-Object System.Drawing.Size($w,$h)
    ForEach ($item in $list | Sort) {
        $dropDownBox.Items.Add($item) | Out-Null
    }
    $dropDownBox.SelectedIndex = 0
    return $dropDownBox
}

function createListbox {
    param (
        [int32]$x, [int32]$y, [int32]$w, [int32]$h, [array]$list
        )
    $listbox               = New-Object System.Windows.Forms.Listbox
    $listbox.Location         = New-Object System.Drawing.Size($x,$y)
    $listbox.Size             = New-Object System.Drawing.Size($w,$h)

    if ($list) {
        foreach ($item in $list| Sort) {
		#$item | select *
            [void] $listbox.Items.Add($item)
        }
    }
    return $listbox
}

function yesNoOKPrompt {
    param (
        [string]$title,[string]$text,[int32]$type
        )
    $yesnoprompt  = new-object -comobject wscript.shell
    $Answer = $yesnoprompt.popup($text, 0,$title,$type)
    return $Answer
    <#
    $type Description
    0 	Show OK button.
    1 	Show OK and Cancel buttons.
    2 	Show Abort, Retry, and Ignore buttons.
    3 	Show Yes, No, and Cancel buttons.
    4 	Show Yes and No buttons.
    5 	Show Retry and Cancel buttons.

    Return Values:
    OK	1
    Cancel	2 (if using option #3 above)
    Abort	3
    Retry	4
    Cancel	5 (if using option #5 above)
    Yes	6
    No	7
    #>

}

function checkbox{
	param(
		[string]$text, [int32]$x, [int32]$y, [int32]$w, [int32]$h
	)
	$checkbox = New-Object System.Windows.Forms.CheckBox
	$checkbox.UseVisualStyleBackColor = $True
	$checkbox.Size = New-Object System.Drawing.Size($w,$h)
	$checkbox.Location = New-Object System.Drawing.Size($x,$y)
	$checkbox.Text = $text

	$checkbox.TabIndex = 2
	$checkbox.DataBindings.DefaultDataSourceUpdateMode = 0

	return $checkbox
}
