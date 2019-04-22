#Import the GUI module
$PSGUIModule = Import-Module -name "$PSScriptRoot\PSGUIModule.psm1" -AsCustomObject -Force

function loadSecondWindow(){
	$form.Hide()
	#Main windows holding everything together
	$box = $PSGUIModule.mainWindow("macRObot v1.1", 166, 425)

	#Text just below text box
	$outputBoxTXT = $PSGUIModule.textLabel("Account", 53, 15, 175, 25)

	$Hotkey1TXT = $PSGUIModule.textLabel("HK1", 25, 75, 75, 25)
	$HotKey2TXT = $PSGUIModule.textLabel("HK2", 25, 145, 75, 25)
	$HotKey3TXT = $PSGUIModule.textLabel("HK3", 25, 215, 75, 25)

	$CoolDown1TXT = $PSGUIModule.textLabel("CD1", 100, 75, 75, 25)
	$CoolDown2TXT = $PSGUIModule.textLabel("CD2", 100, 145, 75, 25)
	$CoolDown3TXT = $PSGUIModule.textLabel("CD3", 100, 215, 75, 25)
	#Text for active running script
	$isrunning = $PSGUIModule.textLabel("Currently Active", 33, 358, 175, 25)
	$isrunning.ForeColor = 'green'

	#Start button
	$Start = $PSGUIModule.button("Start", 25, 290, 50, 25)

	#action for start button
	$Start.Add_Click({

		#Add the active button to the window
		$box.Controls.Add($isrunning)
		$outputBox.Enabled = $false
		$Stop.Enabled = $true

		$allcd = @($CoolDown1.text, $CoolDown2.text, $CoolDown3.text)
		foreach ($i in @($CoolDown1.text, $CoolDown2.text, $CoolDown3.text)){
			 if ($i -match '^\d+$'){
				 continue
			 }else{
			 	$PSGUIModule.yesNoOKPrompt("Bad Entry!", "$i is an invalid number to sleep.  Try again.", 0)
				$box.Hide()
				break
				loadFirstWindow
			}
		}

		#start a job in the background as another process
		start-job -name runMACRO -scriptblock { param($windowname, $HotKey1, $CoolDown1, $HotKey2, $CoolDown2, $HotKey3, $CoolDown3)
			# While the $windowname still exists do all the thingsa3
			while(get-process | Where-Object {$_.MainWindowTitle -eq $windowname}){

				#create and take focus on a window
				$wshell = New-Object -ComObject wscript.shell;
				$wshell.AppActivate($windowname)
				Sleep 1

				if($HotKey1){
					$wshell.SendKeys($HotKey1)
					Sleep $CoolDown1

					if($HotKey2){
						$wshell.SendKeys($HotKey2)
						Sleep $CoolDown2

						if($HotKey3){
							$wshell.SendKeys($HotKey3)
							Sleep $CoolDown3
						}
					}
				}
			}
		} -ArgumentList $box.text, $HotKey1.text, $CoolDown1.text, $HotKey2.text, $CoolDown2.text, $HotKey3.text, $CoolDown3.text #This arg is the name of the window you are passing
		$Start.Enabled = $false
	})
	#stop button
	$Stop = $PSGUIModule.button("Stop", 75, 290, 50, 25)
	#actions for stop button
	$Stop.Add_Click({
		$outputBox.Enabled = $true
		$Start.Enabled = $true
		$Stop.Enabled = $false

		#Remove the active text
		$box.Controls.Remove($isrunning)

		#Check to see if a job is running in the background
		if ((get-job | Where-Object {$_.name -eq "runMACRO"}).count -gt 0){

			#stop the running job
			stop-job -name (get-job | Where-Object {$_.name -eq "runMACRO"}).name

			#Delete the running job
			remove-job -name (get-job | Where-Object {$_.name -eq "runMACRO"}).name
		}else{write-host "Job already stopped."}
	})
	$Stop.Enabled = $false

	$CloseProgram = $PSGUIModule.button("Exit", 50, 320, 50, 25)

	#actions for stop button
	$CloseProgram.Add_Click({
		$box.Hide()
		loadFirstWindow
	})
	$CloseProgram.Enabled = $true


	$outputBox = $PSGUIModule.outputBox($dropDown.SelectedItem, 25, 35, 100, 25)
	$HotKey1 = $PSGUIModule.outputBox('', 25, 95, 25, 25)
	$HotKey2 = $PSGUIModule.outputBox('', 25, 165, 25, 25)
	$HotKey3 = $PSGUIModule.outputBox('', 25, 235, 25, 25)
	$CoolDown1 = $PSGUIModule.outputBox('', 100, 95, 25, 25)
	$CoolDown2 = $PSGUIModule.outputBox('', 100, 165, 25, 25)
	$CoolDown3 = $PSGUIModule.outputBox('', 100, 235, 25, 25)

	#This makes it so that the text box is editable
	$outputBox.Enabled = $true
	$HotKey1.Enabled = $true
	$HotKey2.Enabled = $true
	$HotKey3.Enabled = $true
	$CoolDown1.Enabled = $true
	$CoolDown2.Enabled = $true
	$CoolDown3.Enabled = $true



	# This line physically adds the objects.  Without this lines below it nothing would appear in the window
	$box.Controls.Add($Start)
	$box.Controls.Add($Stop)
	$box.Controls.Add($CloseProgram)
	$box.Controls.Add($outputBox)
	$box.Controls.Add($HotKey1)
	$box.Controls.Add($HotKey2)
	$box.Controls.Add($HotKey3)
	$box.Controls.Add($CoolDown1)
	$box.Controls.Add($CoolDown2)
	$box.Controls.Add($CoolDown3)
	$box.Controls.Add($outputBoxTXT)
	$box.Controls.Add($HotKey1TXT)
	$box.Controls.Add($HotKey2TXT)
	$box.Controls.Add($HotKey3TXT)
	$box.Controls.Add($CoolDown1TXT)
	$box.Controls.Add($CoolDown2TXT)
	$box.Controls.Add($CoolDown3TXT)
	[void] $box.ShowDialog()
}

function loadFirstWindow(){
	#################### The first form to select BlueStacks account
	$form = $PSGUIModule.mainWindow("BlueStacks macRObot", 300, 300)
	$form.StartPosition = 'CenterScreen'

	$OKButton = $PSGUIModule.button("OK", 75, 120, 75, 23)
	$OKButton.Add_Click({
		loadSecondWindow
	})
	$form.Controls.Add($OKButton)


	$CancelButton = $PSGUIModule.button("Cancel", 150, 120, 75, 23)
	$CancelButton.Add_Click({
		$form.Close()
	})
	$form.Controls.Add($CancelButton)

	$label = $PSGUIModule.textLabel("Select a BlueStacks Account", 10, 20, 280, 20)
	$form.Controls.Add($label)

	$allbsboxes = @("BlueStacks", "BlueStacks Boon", "BlueStacks Setjinra/Raph")
	$dropDown = $PSGUIModule.dropDownBox(10, 40, 260, 20, $allbsboxes)
	$dropDown.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
	$form.Controls.Add($dropDown)
	$form.ShowDialog()
}

loadFirstWindow
