﻿#Include <AHK-libs-and-classes-collection-master\libs\a-f\CatchHandler>
ShortcutExists()
{
	; determines if a shortcut for the script exists
	; MsgBox params: %params%


	; declare local, global, static variables
	Global ShortcutName


	Try
	{
		; set default return value
		fnShortcutExists := 0 ; initialise flag to assume shortcut not present


		; validate parameters


		; initialise variables


		; find shortcut
		ShortcutName := ""
		Loop Files, A_Startup "\*.lnk", "F" ; loop through all shortcut files in Startup folder
		{
			FileGetShortcut(A_LoopFileFullPath, &fnTargetFile) ; get the name of the file that the shortcut points to
			fnShortcutExists := fnTargetFile = A_ScriptFullPath ? 1 : fnShortcutExists ; set fnShortcutExists to 1 if any shortcut file points to DAKS
			If fnShortcutExists
			{
				ShortcutName := A_LoopFileFullPath
				Break
			}
		}

	}
	; Catch, ThrownValue
	Catch ValueError
	{
		ReturnValue := !ReturnValue
		CatchHandler(A_ThisFunc,ValueError.Message,ValueError.What,ValueError.Extra,ValueError.File,ValueError.Line,0,0,0)
	}
	; Finally
	; {
	; }

	; return
	Return fnShortcutExists
}


/* ; testing
params := xxx
ReturnValue := ShortcutExists(params)
MsgBox, ShortcutExists`n`nReturnValue: %ReturnValue%
*/