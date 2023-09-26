;@include-winapi
; --------------------------------------------------------------------------------
#MaxThreads 255 ; Allows a maximum of 255 instead of default threads.
#Warn All, OutputDebug
#SingleInstance Force
#WinActivateForce
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
; --------------------------------------------------------------------------------
DetectHiddenText(true)
DetectHiddenWindows(true)
; --------------------------------------------------------------------------------
#Requires AutoHotkey v2
; --------------------------------------------------------------------------------
SetDelays()

SetDelays(*)
{
	SetControlDelay(-1)
	SetMouseDelay(-1)
	SetWinDelay(-1)
}
; --------------------------------------------------------------------------------
_PerMonitor_DPIAwareness()
_PerMonitor_DPIAwareness(*)
{
	MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, ">=10.0.15063") ? -4 : -3
	Global DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext
	try
		DllCall("SetThreadDpiAwarenessContext", "ptr", MaximumPerMonitorDpiAwarenessContext, "ptr")
	catch 
		DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
	else
		DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
	return DefaultDpiAwarenessContext
}	

; ---------------------------------------------------------------------------------
;                              CHANGELOG
; ---------------------------------------------------------------------------------

; Version 1.0, Released 8/24/2023
; Moved my miscellaneous scripts out of the main script and common abbreviations to simplfy updates.


; --------------------------------------------------------------------------------
;                     Shift+Ctrl+WIN+O to Open OS
; --------------------------------------------------------------------------------
^+#o::
{
	myGui := Gui(,"Quick OS/DS Open/Search",)
	myGui.Opt("AlwaysOnTop")
	myGui.SetFont("s12")
	myGui.Add("Radio","vMyRadio Checked1", "Open Operating Standard")
	myGui.Add("Radio",, "Open Data Sheet")
	myGui.Add("Radio",, "Open Operating Requirement")
	myGui.Add("Text",, "Desired OS/DS/OR `(i.e., 8-9`):")
	myGui.Add("Edit","vSTDNumber x+m",,).Focus()
	myGui.Add("Text","x15", "Search for: (optional):")
	myGui.Add("Edit", "vSearchTerm x+m",,)
	myGui.Add("Button","x15 +default", "Open/Search").OnEvent("Click", ClickedSearch)
	myGui.Add("Button","x+m", "Cancel").OnEvent("Click", ClickedCancel)
	myGui.Show("w600")

	ClickedSearch(*)
	{
		Saved := myGui.Submit()  ; Save the contents of named controls into an object.

		If Saved.MyRadio = 1
		{
			outputos1 := "C:\Users\"
			outputos1a := "\FM Global\Operating Standards - Documents\opstds\"
			outputos2 := "fm.pdf"
			Run("AcroRd32.exe " outputos1 "" A_UserName "" outputos1a "" Saved.STDNumber "" outputos2)
			
			If (!Saved.SearchTerm)
			{
				return
			}
			
			Else
			{
				Sleep(1200)
				Send("^+f")
				Send("^a")
				Send("{Delete}")
				Send(Saved.SearchTerm)
				Send("{Enter}")
				return 
			}
			
		}

		If Saved.MyRadio=2 
		{
			outputos1 := "C:\Program Files\FMGlobal\Operating Standards\ds\FMDS"
			outputos2 := ".pdf"
			
			DSArray := StrSplit(Saved.STDNumber,"-")
			
			IF StrLen(DSArray[1])>1
				DSS := DSArray[1]
			else
				DSS := "0" . DSArray[1]
			
			IF StrLen(DSArray[2])>1
				DSN := DSArray[2]
			else
				DSN := "0" . DSArray[2]
			
			Run("AcroRd32.exe " outputos1 "" DSS "" DSN "" outputos2)
			
			If (!Saved.SearchTerm)
			{
				return
			}
			
			Else 
			{
				Sleep(1200)
				Send("^+f")
				Send("^a")
				Send("{Delete}")
				Send(Saved.SearchTerm)
				Send("{Enter}")
				return
			}
		}
		
		If Saved.MyRadio=3
		{
			outputor1 := "C:\Program Files\FMGlobal\Operating Requirements with Guides\OR"
			outputor2 := ".pdf"
			
			Run("AcroRd32.exe " outputor1 "" Saved.STDNumber "" outputor2)
			
			If (!Saved.SearchTerm)
			{
				return
			}
			
			Else 
			{
				Sleep(1200)
				Send("^+f")
				Send("^a")
				Send("{Delete}")
				Send(Saved.SearchTerm)
				Send("{Enter}")
				return
			}
		}
		myGui.Destroy()
		return
	}

	ClickedCancel(*)
	{
		myGui.Destroy()
	}
}

; --------------------------------------------------------------------------------
;                   Win+Delete to Empty Recycle Bin
; --------------------------------------------------------------------------------

#Del::FileRecycleEmpty() ; win + del

; ---------------------------------------------------------------------------------
;          Ctrl+WIN+m Button to Click on Window Anywhere to Drag
; ---------------------------------------------------------------------------------
; This script is from the Automator. Use this to snap the active window
; to your mouse location and follow the mouse until released.

^#m::
{
CoordMode("Mouse", "Screen")
MouseGetPos(&x, &y)
WinMove(x, y, , , "A")
return
}


; ---------------------------------------------------------------------------------
;        Caplock+Left Mouse Button to Click on Window Anywhere to Drag
; ---------------------------------------------------------------------------------
; Easy Window Dragging
; https://www.autohotkey.com
; Normally, a window can only be dragged by clicking on its title bar.
; This script extends that so that any point inside a window can be dragged.
; To activate this mode, hold down CapsLock or the middle mouse button while
; clicking, then drag the window to a new position.

; Note: You can optionally release CapsLock or the middle mouse button after
; pressing down the mouse button rather than holding it down the whole time.

CapsLock & ~LButton::
EWD_MoveWindow(*)
{
    CoordMode( "Mouse")  ; Switch to screen/absolute coordinates.
    MouseGetPos( &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin)
    WinGetPos( &EWD_OriginalPosX, &EWD_OriginalPosY,,, EWD_MouseWin)
    if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized 
        SetTimer( EWD_WatchMouse, 10) ; Track the mouse as the user drags it.

    EWD_WatchMouse()
    {
        if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
        {
            SetTimer( , 0)
            return
        }
        if GetKeyState("Escape", "P")  ; Escape has been pressed, so drag is cancelled.
        {
            SetTimer( , 0)
            WinMove( EWD_OriginalPosX, EWD_OriginalPosY,,, EWD_MouseWin)
            return
        }
        ; Otherwise, reposition the window to match the change in mouse coordinates
        ; caused by the user having dragged the mouse:
        CoordMode( "Mouse")
        MouseGetPos( &EWD_MouseX, &EWD_MouseY)
        WinGetPos( &EWD_WinX, &EWD_WinY,,, EWD_MouseWin)
        SetWinDelay( -1)   ; Makes the below move faster/smoother.
        WinMove( EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY,,, EWD_MouseWin)
        EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
        EWD_MouseStartY := EWD_MouseY
    }
}
; --------------------------------------------------------------------------------

/************************************************************************
; function ...: Google Search for Highlighted Text
@description: 
@hotkey ^#!c or (Ctrl+Win+Alt+c)
@author Aech or me4wsu
@author OvercastBTC (updates|formating)
@param A_Clipboard
@param try => will prevent an error from being thrown (displayed) if the conditions are not met.
************************************************************************/
^#!c::
{
	Send("^c")
	WinExist('Chrome') || WinExist('Edge')
	try WinActivate('Chrome') || WinActivate('Edge')
	Run("http://www.google.com/search?q=" A_Clipboard)
	Return
}
; --------------------------------------------------------------------------------

/************************************************************************
; function ...: Smart Index Number Paste
@description: 
@author OvercastBTC
@param A_Clipboard
@notes
@function PasteIndex()
@function Go_Error() ; fix => this should be a catch Error as e, with a throw 
@function 
@function 
@function 
************************************************************************/
^+v::
{
	A_Clipboard := Trim(A_Clipboard)
	recordsplit := StrSplit(A_Clipboard,"-")		; Split the index number from the record number.
	index_number := recordsplit[1]					; Assign the index number of the split this MAY contain a decimal
	decimalstripped := StrSplit(index_number,".")	; Split index_number on the decimal. If there is a decimal then this array has two values. If no decimal it as a single value.

	If recordsplit.Has(2)
		{
			While StrLen(recordsplit[2])<2			; Adds leadings zeros to record number if they were omitted.
				{
					recordsplit[2] := "0" . recordsplit[2]
				}
		}
		
	If StrLen(A_Clipboard)>12
		{
			throw ("More than 12 characters.")
		}

	If recordsplit.Has(3)
		{
			Go_Error("More than one dash.")
		}

	If decimalstripped.Has(3)
		{
			Go_Error("More than one decimal.")
		}

	Else
		{
			If decimalstripped.Has(2)	; Clipboard contained an index number WITH a decimal.
				{
					index_wo_decimal := decimalstripped[1] . decimalstripped[2] ; Merges the two strings split on the decimal to make the index number WITHOUT a decimal.
					
					While StrLen(index_wo_decimal)<8 	; add proper number of leading zeros.
						{
							index_wo_decimal := "0" . index_wo_decimal
						}
					
					index_w_decimal := index_number
					
					While StrLen(index_w_decimal)<9			; add proper number of leading zeros.
						{
							index_w_decimal := "0" . index_w_decimal
						}
					
					PasteIndex()
				}
			
			If decimalstripped.Has(1) and !decimalstripped.Has(2)	; Clipboard contained an index number WITHOUT a decimal.
				{
					index_wo_decimal := index_number
					
					While StrLen(index_wo_decimal)<8 	; add proper number of leading zeros.
						{
							index_wo_decimal := "0" . index_wo_decimal
						}
					
					index_w_decimal := SubStr(index_number,1,-2) "." SubStr(index_number,-2)

					While StrLen(index_w_decimal)<9			; add proper number of leading zeros.
						{
							index_w_decimal := "0" . index_w_decimal
						}
					
					PasteIndex()
				}
			return	
		}
	
	PasteIndex()
	{
		; ----------------------------------------------------------------------------------------------
		; 		Applications that want the index WITHOUT a decimal and with leading zeros
		; ----------------------------------------------------------------------------------------------
	
		If WinActive("Visit Planner") || WinActive("My Time") || WinActive("EngNET") || WinActive("ahk_exe hznHorizonMgr.exe") ; or WinActive("")
			{
				Sleep(200)					; Sleep added because paste was having issues with not including all zeros without it.
				Send(index_wo_decimal)		; Send index without decimal and with leading zeros.
				
				If WinActive("Visit Planner") or WinActive("ahk_exe hznHorizonMgr.exe") and recordsplit.Has(2)	; If clipboard contained a record number and the application is Visit Planner tab once and paste the record number.
					{
						Sleep(200)			; Sleep added because paste was having issues with not including all zeros without it.
						Send(A_Tab recordsplit[2])
					}

				Else
					{
						return
					}

				return
			}
		
		; ----------------------------------------------------------------------------------------------
		;			Applications that want the index WITH a decimal and leading zeros
		; ----------------------------------------------------------------------------------------------

		If WinActive("BPV Work") ; or WinActive("")
			{
				Sleep(200)					; Sleep added because paste was having issues with not including all zeros without it.
				Send(index_w_decimal)		; paste index with decimal and leading zeros
				
				; If recordsplit.Has(2) and WinActive("") ; Uncomment this and add application for apps that require index with decimal and record number
				;	{
				;		Send(recordsplit[2])	; Send Record Number inline with index. Adjust as needed with tabs or adding dash
				;	}

				Return
			}
		
		; --------------------------------------------------------------------------------------------------------
		; All other applications get index WITH a decimal and leading zeros and record number if available.
		; --------------------------------------------------------------------------------------------------------

		Else
			{
				If recordsplit.Has(2)
					{
						Sleep(200)			; Sleep added because paste was having issues with not including all zeros without it.
						Send(index_w_decimal "-" recordsplit[2])
					}
					
				Else
					{
						Sleep(200)
						Send(index_w_decimal)
					}
				Return
			}
	
		return
	}
	Go_Error(ErrorCode)
	{
		MsgBox("Error: The clipboard does not appear to contain a valid index number.`n`n" ErrorCode "`n`nClipboard Contains:`n" A_Clipboard)
	}
	return
}
/*
; --------------------------------------------------------------------------------
;     			     Smart Index Number Paste
; --------------------------------------------------------------------------------
; 079291.45-02
^+v::
{
	; Split the index number from the record number.
	recordsplit := StrSplit(A_Clipboard,"-")
	; --------------------------------------------------------------------------------
	; Assign the index number of the split this MAY contain a decimal
	index_number := recordsplit[1]
	; --------------------------------------------------------------------------------
	; Split index_number on the decimal. If there is a decimal then this array has two values. If no decimal it as a single value.
	decimalstripped := StrSplit(index_number,".")	
	; --------------------------------------------------------------------------------
	; Clipboard contained an index number WITH a decimal.
	try 
		decimalstripped.Has(2)
		{
			index_wo_decimal := decimalstripped[1] . decimalstripped[2] ; Merges the two strings split on the decimal to make the index number WITH a decimal.
			
			While StrLen(index_wo_decimal)<8 	; add proper number of leading zeros.
				{
					index_wo_decimal := "0" . index_wo_decimal
				}
			
			index_w_decimal := index_number
			
			While StrLen(index_w_decimal)<9			; add proper number of leading zeros.
				{
					index_w_decimal := "0" . index_w_decimal
				}
			
			PasteIndex()
			return
		}
	
	; Clipboard contained an index number WITHOUT a decimal.
	try
	{
		decimalstripped.Has(1)
		{
			index_wo_decimal := index_number
			
			While StrLen(index_wo_decimal)<8 	; add proper number of leading zeros.
				{
					index_wo_decimal := "0" . index_wo_decimal
				}
			
			index_w_decimal := SubStr(index_number,1,-2) "." SubStr(index_number,-2)
	
			While StrLen(index_w_decimal)<9			; add proper number of leading zeros.
				{
					index_w_decimal := "0" . index_w_decimal
				}
			
			PasteIndex()
		}
	} 
	catch Error as e 
	{
		throw e && ("Error: Are you sure the clipboard contains an index number?")
	}

	
	PasteIndex()
	{
		; makeindexgroup()
		; If WinActive('ahk_group index')
		If WinActive("Visit Planner") || WinActive("My Time") || WinActive("EngNET") ; or WinActive("")
			{
				Send(index_wo_decimal)		; Send index without decimal and with leading zeros.

				; If WinActive('Visit Planner') && recordsplit.Has(2)	; If clipboard contained a record number and the application is Visit Planner tab once and paste the record number.
				; If clipboard contained a record number and the application is Visit Planner tab once and paste the record number.
				If !WinActive('Visit Planner') && !recordsplit.Has(2)
					{
						return
					}
				Sleep(100)
				Send(A_Tab recordsplit[2])
				return
			}
		
		If WinActive("BPV Work Planning Search")
			{
				; paste index with decimal and leading zeros into JOL
				Send(index_w_decimal)
				Return
			}
		
		Else
			{
				If recordsplit.Has(2)
					{
						Send(index_w_decimal "-" recordsplit[2])
					}
					
				Else
					{
						Send(index_w_decimal)
					}
				Return
			}
		return	
	}
}
*/
MakeIndexGroup(*)
{
	; --------------------------------------------------------------------------------
	/**
	 * @param index	...: The overall group
	 * @param iWd 	...: The group with the decimal
	 * @param iWOd 	...: The grou without the decimal
	 */
	GroupAdd('index', 'Visit Planner')
	GroupAdd('index', 'My Time')
	GroupAdd('index', 'EngNET')
	GroupAdd('index', 'BPV Work Planning Search')
	; --------------------------------------------------------------------------------
	GroupAdd('iWOd', 'Visit Planner')
	GroupAdd('iWOd', 'My Time')
	GroupAdd('iWOd', 'EngNET')
	GroupAdd('iWOd', 'BPV Work Planning Search')
	; --------------------------------------------------------------------------------
	GroupAdd('iWd', 'BPV Work Planning Search')
	return
}
; --------------------------------------------------------------------------------
;      Universal Search - Shift+Ctrl+g to Pop Input Box for a Search
; --------------------------------------------------------------------------------

^+g::
{
	myGui := Gui(,"Universal Search",)
	myGui.Opt("AlwaysOnTop")
	myGui.SetFont("s12")
	myGui.Add("Checkbox","vGoogle Checked1", "Google")
	myGui.Add("Checkbox","vGlobalPort Checked0", "Globalport")
	myGui.Add("Checkbox","vDuck Checked0", "DuckDuckGo")
	myGui.Add("Checkbox","vYouTube Checked0", "YouTube")
	myGui.Add("Checkbox","vWiki Checked0", "Wikipedia")
	myGui.Add("Checkbox","vWolfram Checked0", "Wolfram Alpha")
	myGui.Add("Checkbox","vredditg Checked0", "Reddit (General)")
	myGui.Add("Checkbox","vreddita Checked0", "Reddit (AHK V2 Specific)")
	myGui.Add("Checkbox","vahkv2doc Checked0", "AHK V2 Documentation")
	myGui.Add("Checkbox","vahkforum Checked0", "AHK Forums V2")
	myGui.Add("Text",, "Search Term")
	myGui.Add("Edit", "vSearchTerm x+m",,).Focus()
	myGui.Add("Button","x15 +default", "Search").OnEvent("Click", ClickedSearch)
	myGui.Add("Button","x+m", "Cancel").OnEvent("Click", ClickedCancel)
	myGui.Show("w350")

	ClickedSearch(*)
	{
		Saved := myGui.Submit()  ; Save the contents of named controls into an object.
		User_Search_Term := StrReplace(Saved.SearchTerm, " ", "`%20") 

		If Saved.Google = 1
			{
            Run("https://www.google.com/search?q=" User_Search_Term)
			}
		If Saved.GlobalPort = 1
			{
			Run("https://searchfmglobal/app/search/#/search?query=%7B%22name%22:%22fmg_query%22,%22text%22:%22" User_Search_Term "%22%7D")
			}
		If Saved.Duck = 1
			{
			Run("https://duckduckgo.com/?q=" User_Search_Term)
			}
		If Saved.YouTube = 1
		{
            Run("https://www.youtube.com/results?search_query=" User_Search_Term)
		}
		If Saved.Wiki = 1
			{
			Run("https://en.wikipedia.org/w/index.php?title=Special:Search&search=" User_Search_Term)
			}
		If Saved.Wolfram = 1
			{
			Run("https://wolframalpha.com/input?i=" User_Search_Term)
			}
		If Saved.redditg = 1
			{
			Run("https://duckduckgo.com/?q=site:reddit.com%20" User_Search_Term)
			}
		If Saved.reddita = 1
			{
			Run("https://duckduckgo.com/?q=site:reddit.com%20AHK%20V2%20" User_Search_Term)
			}
		If Saved.ahkv2doc = 1
			{
				Run("https://duckduckgo.com/?q=site:autohotkey.com/docs/v2/%20" User_Search_Term)
			}
		If Saved.ahkforum = 1
			{
			Run("https://duckduckgo.com/?q=site:autohotkey.com/boards%20" User_Search_Term "%20V2")
			}
		Else 
			{
			myGui.Destroy()
			return
			}
	
		myGui.Destroy()
		return
	}
	
	ClickedCancel(*)
	{
		myGui.Destroy()
	}
}

; --------------------------------------------------------------------------------
;         Shift+Ctrl+m to Pop Input Box for a Google Maps Search
; --------------------------------------------------------------------------------

^+m::
{
	MSearch := InputBox("Search Google Maps for:","Quick Google Map Search:","w500 h100")
	
	If MSearch.Result = "Cancel"
		Return
	Else
		{
			Run("https://www.google.com/maps/place/" MSearch.Value)
            Return
		}
}