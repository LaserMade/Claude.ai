#Requires AutoHotkey v2+
#Include <Directives\__AE.v2>
;@include-winapi
; --------------------------------------------------------------------------------
TraySetIcon("shell32.dll","16", true) ; this changes the icon into a little laptop thing.
; --------------------------------------------------------------------------------
myScript := A_TrayMenu
; TrayMenu := MenuBar()
myScript.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
myScript.Add("Made by OvercastBTC",madeBy)
myScript.Add()
; Tray.Add("Run at startup", "runAtStartup")
; Tray.ToggleCheck(fileExist(startup_shortcut) ? "check" : "unCheck", Run at startup ; update the tray menu status on startup
; TODO Finish updating Run at Startup
; Tray.Add("Presentation mode {Win+Shift+P}", togglePresentationMode) ; => does not exist
; Tray.Add("Keyboard shortcuts {Ctrl+Shift+Alt+\}", "viewKeyboardShortcuts")
; Tray.Add("Open file location", "openFileLocation")
; Tray.Add()
; Tray.Add("Run GUI_FE", "GUIFE")
myScript.Add('Run WindowsListMenu.ahk', WindowListMenu)
myScript.Add()
myScript.Add('Run GUI_ListofFiles.ahk', GUI_ListofFiles)
myScript.Add("Run WindowProbe.ahk", WindowProbe)
; Tray.Add("Run Windows_Data_Types_offline.ahk", Windows_Data_Types_offline)
myScript.Add()
; Tray.Add("View in GitHub", "viewInGitHub")
; Tray.Add("See AutoHotKey documentation", "viewAHKDoc") ; => does not exist
; Tray.Add()
myScript.AddStandard()
; Tray.Show
; --------------------------------------------------------------------------------
madeBy(madeBy,*){
}
WindowListMenu(*){
	Run("WindowListMenu.ahk")
}
; --------------------------------------------------------------------------------
; #Include <Abstractions\Script>
; Script.startup.CheckStartupStatus()
#Include <Common\Common_Include>
#Include <WINDOWS.v2>
; #Include <Misc Scripts.V2>
#Include <Common\Misc Scripts.V2>
#Include <Tools\Info>
#Include <System\Web>
#Include <Tools\CleanInputBox>
#Include <App\Git>

; --------------------------------------------------------------------------------
/**
 * function Permanently Set Caplocks Off, NumLock On and Scroll Lock Off
 * @param SetNumLockState
 * @param SetCapsLockState
 * @param SetScrollLockState
  */
;          
; --------------------------------------------------------------------------------
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")
; --------------------------------------------------------------------------------
; :*?B0:`n::^{Right}
#HotIf WinActive("Chrome River - Google Chrome")
; hWA := WinActive("Chrome River - Google Chrome")
; HotIf(hWA)
	*^s::SaveCR()
	; ---------------------------------------------------------------------------
	SaveCR(){
		expRpt := UIA.ElementFromChromium('Chrome River - Google Chrome')
		Sleep(100)
		expRpt.WaitElement({Type: '50000 (Button)', Name: "Save", LocalizedType: "button", AutomationId: "save-btn"}, 10000).Highlight(100).Invoke()
	}
; HotIf()
#HotIf
~n::
{
	If (A_PriorKey = '``'){
		Sleep(10)
		Send('{Right}')
	}
}
#HotIf !WinActive(" - Visual Studio Code")
:*b0:(::){left 1}
:*b0:{::{}}{left 1}
:*b0:[::]{left 1}
:*b0:'::{'}{left 1}
:*b0:"::{"}{left 1}
:*:`  ::{bs 1}{right}{Space}
#HotIf
#HotIf !WinActive('ahk_exe hznHorizon.exe')
^+v::Paste()
Paste(*)
{
	Static Msg := WM_PASTE := 770, wParam := 0, lParam := 0
	; WinActive('ahk_exe WINWORD.exe') ? Send('+{Insert}') : hCtl := ControlGetFocus('A')
	; Run('WINWORD.exe /x /q /a /w')
	WinActive('ahk_exe WINWORD.exe') ? Send('+{Insert}') : hCtl := ControlGetFocus('A')
	try DllCall('SendMessage', 'Ptr', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	return
}
#HotIf
; --------------------------------------------------------------------------------
#HotIf WinActive(" - Visual Studio Code")
; :CB0:function::
:*C1:function::
{
	BlockInput(1)
	Send('^+{Left}')
	; Sleep(10)
	; Send('{Del}')
	; Sleep(100)
	Send('function ...:')
	Sleep(100)
	Send(A_Tab)
	BlockInput(0)

}

; --------------------------------------------------------------------------------
:*:;---::
{
	Send('^+{Left}')
	Send('; {- 75}')
}
:?C1*:{Ins::
{
	BlockInput(1)
	Send('^+{Left}')
	Send('Insert')
	Send('{Esc}')
	BlockInput(0)
}
:?C1*:{Ent::
{
	BlockInput(1)
	Send('^+{Left}')
	SendText('Enter')
	Send('{Esc}')
	BlockInput(0)

}
:*:sleep::
{
	BlockInput(1)
	Send('^+{Left}')
	Send('Sleep(100)')
	Sleep(100)
	Send('{Left}')
	Send('+{Left 3}')
	BlockInput(0)
}
#HotIf
^#g::git_InstallAHKLibrary('https://github.com/Axlefublr/lib-v2/blob/1d1940095902e483a56bbdd8af6ab0642d8a9fe6/Scr/Keys/Trinity.ahk','Scr\Keys\')

; --------------------------------------------------------------------------------
; #HotIf WinActive(A_ScriptName)
#c::try CenterWindow("A")

CenterWindow(winTitle*) {
    hwnd := WinExist(winTitle*)
    WinGetPos( ,, &W, &H, hwnd)
    mon := GetNearestMonitorInfo(hwnd)
    WinMove( mon.WALeft + mon.WAWidth // 2 - W // 2, mon.WATop + mon.WAHeight // 2 - H // 2,,, hwnd)
}
return

; GetNearestMonitorInfo(winTitle*) {
;     static MONITOR_DEFAULTTONEAREST := 0x00000002
;     hwnd := WinExist(winTitle*)
;     hMonitor := DllCall("MonitorFromWindow", "ptr", hwnd, "uint", MONITOR_DEFAULTTONEAREST, "ptr")
;     NumPut("uint", 104, MONITORINFOEX := Buffer(104))
;     if (DllCall("user32\GetMonitorInfo", "ptr", hMonitor, "ptr", MONITORINFOEX)) {
;         Return  { Handle   : hMonitor
;                 , Name     : Name := StrGet(MONITORINFOEX.ptr + 40, 32)
;                 , Number   : RegExReplace(Name, ".*(\d+)$", "$1")
;                 , Left     : L  := NumGet(MONITORINFOEX,  4, "int")
;                 , Top      : T  := NumGet(MONITORINFOEX,  8, "int")
;                 , Right    : R  := NumGet(MONITORINFOEX, 12, "int")
;                 , Bottom   : B  := NumGet(MONITORINFOEX, 16, "int")
;                 , WALeft   : WL := NumGet(MONITORINFOEX, 20, "int")
;                 , WATop    : WT := NumGet(MONITORINFOEX, 24, "int")
;                 , WARight  : WR := NumGet(MONITORINFOEX, 28, "int")
;                 , WABottom : WB := NumGet(MONITORINFOEX, 32, "int")
;                 , Width    : Width  := R - L
;                 , Height   : Height := B - T
;                 , WAWidth  : WR - WL
;                 , WAHeight : WB - WT
;                 , Primary  : NumGet(MONITORINFOEX, 36, "uint")
;             }
;     }
;     throw Error("GetMonitorInfo: " A_LastError, -1)
; }
; return
; --------------------------------------------------------------------------------
; Section .....: Functions
; Function ....: Run scripts selection from the Script Tray Icon
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
return
; ^+#1::
GUIFE(*){
	Run("GUI_FE.ahk")
}
return
; list

; ^+#3::
WindowProbe(*){
	Run("WindowProbe.ahk", "C:\Users\bacona\OneDrive - FM Global\3. AHK\")
}
return
; ^+#4::
GUI_ListofFiles(*){
	Run("GUI_ListofFiles.ahk")
}
return
; ^+#5::
{
Windows_Data_Types_offline(*){
	Run("Windows_Data_Types_offline.ahk", "C:\Users\bacona\OneDrive - FM Global\3. AHK\AutoHotkey_MSDN_Types-master\src\v1.1_deprecated\")
}
}
return
; #o::
Detect_Window_Info(*){
	Run("Detect_Window_Info.ahk")
}
return
; ^+#6::
Detect_Window_Update(*){
	Edit()
}
return
; ^+#7::
test_script(*){
	Run("test_script.ahk")
}
return

; ; --------------------------------------------------------------------------------
; ;                Ctrl+Shift+Alt+r Reload AutoHotKey Script (to load changes)
; ; --------------------------------------------------------------------------------
; ^+!r::ReloadAllAhkScripts()
; ReloadAllAhkScripts()
; {
; 	DetectHiddenWindows(true)
; 	static oList := WinGetList("ahk_class AutoHotkey",,,)
; 	aList := Array()
; 	List := oList.Length
; 	For v in oList
; 	{
; 		aList.Push(v)
; 	}
; 	scripts := ""
; 	Loop aList.Length
; 		{
; 			title := WinGetTitle("ahk_id " aList[A_Index])
; 			;PostMessage(0x111,65414,0,,"ahk_id " aList[A_Index])
; 			dnrList := [A_ScriptName, "Scriptlet_Library"]
; 			rmList := InStr(title, "Scriptlet_Library", false)
			
; 			If (title = A_ScriptName) || (title = "Scriptlet_Library"){
; 				continue
; 			}
; 			PostMessage(0x111,65400,0,,"ahk_id " aList[A_Index])
; 			; Note: I think the 654*** is for v2 => avoid the 653***'s
; 			; [x] Reload:		65400
; 			; [x] Help: 		65411 ; 65401 doesn't really work or do anything that I can tell
; 			; [x] Spy: 			65402
; 			; [x] Pause: 		65403
; 			; [x] Suspend: 		65404
; 			; [x] Exit: 		65405
; 			; [x] Variables:	65406
; 			; [x] Lines Exec:	65407 & 65410
; 			; [x] HotKeys:		65408
; 			; [x] Key History:	65409
; 			; [x] AHK Website:	65412 ; Opens https://www.autohotkey.com/ in default browser; and 65413
; 			; [x] Save?:		65414
; 			; Don't use these => ;//static a := { Open: 65300, Help:    65301, Spy: 65302, XXX (nonononono) Reload: 65303 [bad reload like Reload()], Edit: 65304, Suspend: 65305, Pause: 65306, Exit:   65307 }
; 			; scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
; 			scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
; 		}
; 	OutputDebug(scripts)
; 	OutputDebug(rmList)
; 	return
; }

;---------------------------------------------------------------------------
;      Shift+WIN+m Button to Click on Window Anywhere to Drag
;---------------------------------------------------------------------------
; This script is from the Automator

!LButton::
{
CoordMode("Mouse", "Screen")
MouseGetPos(&x, &y)
WinMove(x, y, , , "A")
return
;---------------------------------------------------------------------------
;                       Time Stamp Code
;---------------------------------------------------------------------------
}
#HotIf WinActive('ahk_exe hznhorizon.exe')
:*:ts::
; format month and year
{
	date := FormatTime(A_Now, "yyyy.MM")
	Send("(AJB - " date ")")
	return
}
#HotIf
:*:tsf::
; format month and year
{
	date := FormatTime(A_Now, "yyyy.MM.dd")
	Send("(AJB - " date ")")
	return
}

;--------------------------------------------------------------------------
;                    Quick Launch Websites (and Log In)
;--------------------------------------------------------------------------

; ^+g::Run("`"https://www.google.com/?safe=active&ssui=on`"") ; use ctrl+Shift+g
; return

;^+e::Run("`"https://engnet/Engnet/engnet/engnet.asp`"") ; use ctrl+Shift+e
;return

/* Commented out due to conflict with "reply to all keyboard shortcut in Outlook"
	^+r::Run "http://riskview/RiskView_1_0/Home/MainPage" ; use ctrl+Shift+r
	return
*/
/* Commented out JOL
	^+j::
{
	Run "https://www.jurisdictiononline.com/" ; use ctrl+Shift+j
	Sleep 3000
	Send, {Tab}PASSWORD ;Note my username is saved in Edge and already populated. If yours is not, you will need to alter this script. Replace text after tab with your own credential
	Sleep 50
	Send, {Tab}
	Sleep 50
	Send, {Enter}
	return
*/

;^+!f::
;Run "https://portal.fcm.travel/Account/Login" ; use ctrl+Shift+f
;Sleep 3000
;Send, {Tab}{Tab}{Tab}{Tab}FIRST.LAST@fmglobal.com{Tab}PASSWORD{Tab} ;Replace text after tab with your own credential
;Sleep 50
;Send, {Enter}
;return

/*
}
	^+a::
{
	Run "https://www.approvalguide.com//" ; use ctrl+Shift+a
	Sleep 3500
	Send, {Tab}{Tab}{Enter}
	Sleep 1500
	Send,FIRST.LAST@fmglobal.com{Tab}{Enter} ;Replace email with your own credential
	Sleep 2000
	Send, PASSWORD{Enter} ;Replace text with your own credentials
	return
*/

;--------------------------------------------------------------------------
; Function:  Shift+Ctrl+C to Google Search for Highlighted Text
; fixed => moved to Misc Scripts.v2.ahk
;--------------------------------------------------------------------------

; ^+c::
; {
; 	Send("^c")
; 	Sleep(50)
; 	Run("http://www.google.com/search?q=" A_Clipboard)
; 	Return
; }

;--------------------------------------------------------------------------
;                Win+Delete to Empty Recycle Bin
; fixed => moved to Misc Scripts.v2.ahk
;--------------------------------------------------------------------------

; #Del::FileRecycleEmpty() ; win + del

;---------------------------------------------------------------------------
;                      Helpful Stuff
;---------------------------------------------------------------------------
:*:attext::	; Timestamp
{
Date := FormatTime(A_Now, "MM/dd/yyyy")	; format month, day and year
IB := InputBox("Nameplate Head Thickness (after 0.)", "Air Tank", "w300 h125"), npht := IB.Value
IB := InputBox("Nameplate Shell Thickness (after 0.)", "Air Tank", "w300 h125"), npst := IB.Value
IB := InputBox("Actual Head Thickness (after 0.)", "Air Tank", "w300 h125"), aht := IB.Value
IB := InputBox("Actual Shell Thickness (after 0.)", "Air Tank", "w300 h125"), ast := IB.Value
Send("Nameplate HD: 0." npht " / SH: 0." npst " // " Date " TJK HD: 0." aht " / SH: 0." ast)
Return
} ; Added bracket before function

Join(sep, params*) {
	for index,param in params
		str .= param . sep
	return SubStr(str, 1, -StrLen(sep))
}
;MsgBox % Join("`n", "one", "two", "three")

;---------------------------------------------------------------------------
;                          General Abbreviations
;---------------------------------------------------------------------------

^!0::
{
	static var := "ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÑÒÓÔŒÕÖØÙÚÛÜßàáâãäåæçèéêëìíîïñòóôœõöøùúûüÿ¿¡«»§¶†‡•-–—™©®¢€¥£₤¤αβγδεζηθικλμνξοπρσςτυφχψωΓΔΘΛΞΠΣΦΨΩ∫∑∏√−±∞≈∝≡≠≤≥×·÷∂′″∇‰°∴ø∈∩∪⊂⊃⊆⊇¬∧∨∃∀⇒⇔→↔↑ℵ∉°₀₁₂₃₄₅₆₇₈₉⁰¹²³⁴⁵⁶⁷⁸⁹"
	Global arr
	arr := strsplit(var)

	static w:=20, cnt := 14,
	myGui := Gui()
	myGui.Opt("-caption")
	myGui.MarginX := "0", myGui.MarginY := "0"
	myGui.SetFont("s10")
	Loop arr
		{
		x := mod((a_index - 1),cnt) * w, y := floor((a_index - 1)/ cnt) * w
		ogctextz := myGui.add("text", "x" . x . " y" . y . " w" . w . " h" . w . " center vz" . a_index, arr[a_index])
		ogctextz.OnEvent("Click", myGui.insert.Bind("Normal"))
		}
	myGui.show()
	return
}

insert(A_GuiEvent, GuiCtrlObj, Info, *)
{
	myGui := 
	oSaved := myGui.submit()
	Send(arr[SubStr(A_GuiEvent, 2)])
}

;---------------------------------------------------------------------------
;      Alt+Left Mouse Button to Click on Window Anywhere to Drag
;---------------------------------------------------------------------------
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm

Alt & ~LButton::EWD_MoveWindow()
; ~MButton & LButton::
; CapsLock & LButton::
; EWD_MoveWindow(*)
; {
;     CoordMode "Mouse"  ; Switch to screen/absolute coordinates.
;     MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin
;     WinGetPos &EWD_OriginalPosX, &EWD_OriginalPosY,,, EWD_MouseWin
;     if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized 
;         SetTimer EWD_WatchMouse, 10 ; Track the mouse as the user drags it.

;     EWD_WatchMouse()
;     {
;         if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
;         {
;             SetTimer , 0
;             return
;         }
;         if GetKeyState("Escape", "P")  ; Escape has been pressed, so drag is cancelled.
;         {
;             SetTimer , 0
;             WinMove EWD_OriginalPosX, EWD_OriginalPosY,,, EWD_MouseWin
;             return
;         }
;         ; Otherwise, reposition the window to match the change in mouse coordinates
;         ; caused by the user having dragged the mouse:
;         CoordMode "Mouse"
;         MouseGetPos &EWD_MouseX, &EWD_MouseY
;         WinGetPos &EWD_WinX, &EWD_WinY,,, EWD_MouseWin
;         SetWinDelay -1   ; Makes the below move faster/smoother.
;         WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY,,, EWD_MouseWin
;         EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
;         EWD_MouseStartY := EWD_MouseY
;     }
; }

#HotIf WinExist(A_ScriptName)
; ; Current date and time
/*
FormatDateTime(format, datetime:="") {
	if (datetime = "") {
		datetime := A_Now
	}
	CurrentDateTime := FormatTime(datetime, format)
	SendInput(CurrentDateTime)
	return
}
*/
; Hotstrings
::/datetime::
{
    FormatDateTime("dddd, MMMM dd, yyyy, HH:mm")
Return
}

::/datetimett::
{
    FormatDateTime("dddd, MMMM dd, yyyy hh:mm tt")
Return
}

:X:/cf::FormatDateTime("yyyy.MM.dd HH:mm")

::/time::
{
    FormatDateTime("HH:mm")
Return
}
::/timett::
{
    FormatDateTime("hh:mm tt")
Return
}
::/date::
{
    FormatDateTime("MMMM dd, yyyy")
Return
}
::/daten::
{
    FormatDateTime("MM/dd/yyyy")
Return
}
::/datet::
{
    FormatDateTime("yy.MM.dd")
Return
}
::/week::
{
    FormatDateTime("dddd")
Return
}
::/day::
{
    FormatDateTime("dd")
Return
}
::/month::
{
    FormatDateTime("MMMM")
Return
}
::/monthn::
{
    FormatDateTime("MM")
Return
}
::/year::
{
    FormatDateTime("yyyy")
Return

; Others
}
::wtf::Wow that's fantastic
::/paste::
{
    Send(A_Clipboard)
Return
}
; ::/cud::
;     ; useful for WSLs
; {
;     SendInput("/mnt/c/Users/" A_UserName "/")
; Return
; }
::/nrd::npm run dev
::/gm::Good morning
::/ge::Good evening
::/gn::Good night
::/ty::Thank you
::/tyvm::Thank you very much
::/wc::Welcome
::/mp::My pleasure
::/lorem::Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
::/plankton::Plankton are the diverse collection of organisms found in water that are unable to propel themselves against a current. The individual organisms constituting plankton are called plankters. In the ocean, they provide a crucial source of food to many small and large aquatic organisms, such as bivalves, fish and whales.

#HotIf

; --------------------------------------------------------------------------------
; ! --------------------------- Disabled Section ------------------------------- !
; --------------------------------------------------------------------------------
; ============================== ReloadAllAhkScripts() ==============================
/*
ReloadAllAhkScripts()
{
	DetectHiddenWindows(true)
	static oList := WinGetList("ahk_class AutoHotkey",,,)
	aList := Array()
	List := oList.Length
	For v in oList
	{
		aList.Push(v)
	}
	scripts := ""
	Loop aList.Length
		{
			title := WinGetTitle("ahk_id " aList[A_Index])
			;PostMessage(0x111,65414,0,,"ahk_id " aList[A_Index])
			dnrList := [A_ScriptName, "Scriptlet_Library"]
			rmList := InStr(title, "Scriptlet_Library", false)
			
			If (title = A_ScriptName)
				Continue
			If (title = "Scriptlet_Library")
				continue
			PostMessage(0x111,65400,0,,"ahk_id " aList[A_Index])
			; Note: I think the 654*** is for v2 => avoid the 653***'s
			; [x] Reload:		65400
			; [x] Help: 		65411 ; 65401 doesn't really work or do anything that I can tell
			; [x] Spy: 			65402
			; [x] Pause: 		65403
			; [x] Suspend: 		65404
			; [x] Exit: 		65405
			; [x] Variables:	65406
			; [x] Lines Exec:	65407 & 65410
			; [x] HotKeys:		65408
			; [x] Key History:	65409
			; [x] AHK Website:	65412 ; Opens https://www.autohotkey.com/ in default browser; and 65413
			; [x] Save?:		65414
			; Don't use these => ;//static a := { Open: 65300, Help:    65301, Spy: 65302, XXX (nonononono) Reload: 65303 [bad reload like Reload()], Edit: 65304, Suspend: 65305, Pause: 65306, Exit:   65307 }
			; scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
			scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
		}
	OutputDebug(scripts)
	OutputDebug(rmList)
	return
}
*/
; --------------------------------------------------------------------------------
; ============================== runAtStartup ==============================
/*
; runAtStartup() {
;     if (FileExist(startup_shortcut)) {
;         FileDelete, % startup_shortcut
;         Menu, Tray, % "unCheck", Run at startup ; update the tray menu status on change
;         trayNotify("Startup shortcut removed", "This script will not run when you turn on your computer.")
;     } else {
;         FileCreateShortcut, % A_ScriptFullPath, % startup_shortcut
;         Menu, Tray, % "check", Run at startup ; update the tray menu status on change
;         trayNotify("Startup shortcut added", "This script will now automatically run when your turn on your computer.")
;     }

; }
*/
; --------------------------------------------------------------------------------
; ============================== Power Off | Suspend | Sleep ==============================
/*
#Numpad0::
; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
; Parameter #3: Pass 1 instead of 0 to disable all wake events.
{
	DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
	Return
}
*/
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; ============================== Test Programs ==============================
/*
; ^!#g::
; {
; MsgBox("Desktop Window: " DllCall("GetDesktopWindow") "`nClassName: "DllCall("GetClassName") "`nWindowA: " DllCall("FindWindowA") "`nClassInfoA: "DllCall("GetClassInfoA") "`nClassLongA: " DllCall("GetClassLongA") "`nClassWord: " DllCall("GetClassWord") "`nNextWindow: " DllCall("GetNextWindow") "`nNextWindow: " DllCall("GetNextWindow") "`nTitleBarInfo: " DllCall("GetTitleBarInfo"))
; ;msgbox % "Desktop Window: " dllCall("GetDesktopWindow")+0 "`nClassName: "dllCall("GetClassName")+0 "`nWindowA: " dllCall("FindWindowA")+0 "`nClassInfoA: "dllCall("GetClassInfoA")+0 "`nClassLongA: " dllCall("GetClassLongA")+0 "`nClassWord: " dllCall("GetClassWord")+0 "`nNextWindow: " dllCall("GetNextWindow")+0 "`nNextWindow: " dllCall("GetNextWindow")+0 "`nTitleBarInfo: " dllCall("GetTitleBarInfo")+0
; ;msgbox % dllCall("GetDesktopWindow")+0
; ;msgbox % dllCall("GetClassName")+0
; ;msgbox % dllCall("FindWindowA")+0
; ;msgbox % dllCall("GetClassInfoA")+0
; ;msgbox % dllCall("GetClassLongA")+0
; ;msgbox % dllCall("GetClassWord")+0
; ;msgbox % dllCall("GetNextWindow")+0
; ;msgbox % dllCall("GetNextWindow")+0
; ;msgbox % dllCall("GetTitleBarInfo")+0
; }
; return
*/
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
;                     Shift+Ctrl+WIN+O to Open OS
; --------------------------------------------------------------------------------
/*
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
*/
