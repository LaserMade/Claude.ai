#Requires AutoHotkey v2
; --------------------------------------------------------------------------------
#Include <Paths>
#Include <Tools\ToggleInfo>
#Include <Abstractions\Text>

; --------------------------------------------------------------------------------

class Script {

	static Reload() => Run(A_ScriptFullPath)

	static Suspend() {
		if A_IsSuspended {
			Suspend(false)
			ToggleInfo("Script On")
		} else {
			Suspend(true)
			ToggleInfo("Script Off")
		}
	}

	static Test() => Run(Paths.Ptf["AhkTest"])

	static ExitTest() {
		WriteFile(Paths.Ptf["test-state"], 0)
	}

	static RunTests() => Run(Paths.Ptf["Tests"])

	;---------------------------------------------------------------------------
	;                        Add Script to Startup Folder 
	;---------------------------------------------------------------------------
	
	class startup extends Script{
		static CheckStartupStatus(*)
		{
		Startup_Shortcut := A_Startup "\" A_ScriptName ".lnk"
		scStartup := A_Startup '\' A_ScriptName ' - Shortcut.lnk'
		Startup_Shortcut_Shortcut := A_Startup "\" A_ScriptName " - Shortcut"
		If !(FileExist(Startup_Shortcut) or FileExist(scStartup))
			{
				myGui := Gui(,"Add Script to Startup Folder",)
				myGui.Opt("AlwaysOnTop")
				myGui.SetFont("s12")
				myGui.Add("Text",, "It is recommended you add this script to your Startup folder so`nthat it is active every time your computer starts.`n`nMake sure that the script is in the location you want to save`nit in before adding it to the startup folder.`n`nWould you like to add this script to the startup folder now?")
				myGui.Add("Button","x15 +default", "Add to Startup").OnEvent("Click", ClickedAdd)
				myGui.Add("Button","x+m", "Cancel").OnEvent("Click", ClickedCancel)
				myGui.Show("w500")
				
				ClickedAdd(*)
				{
					myGui.Destroy()
					FileCreateShortcut(A_ScriptDir "\" A_ScriptName, Startup_Shortcut)
					Run "shell:startup"
					MsgBox("Shortcut added to your Startup folder at:`n`n" Startup_Shortcut "`n`nYour Startup folder has been opened for you. Please delete any old shortcuts.")
					Return
				}
		
				ClickedCancel(*)
				{
					myGui.Destroy()
					MsgBox("Please move the file to the location you want to save it, then run it again.")
					Return
				}
			} 
		Else 
			{
				Return
			}
		}
	}
}