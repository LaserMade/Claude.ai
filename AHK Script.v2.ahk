; -=================================================================================
; Section .....: Auto-Execution
; ----------------------------------------------------------------------------------
; -=================================================================================
#Warn All, OutputDebug
#SingleInstance Force
SendMode("Input")
SetWorkingDir(A_ScriptDir)
SetTitleMatchMode(2)
; --------------------------------------------------------------------------------
DetectHiddenText(true)
DetectHiddenWindows(true)
; --------------------------------------------------------------------------------
#Requires AutoHotkey v2
; --------------------------------------------------------------------------------
SetControlDelay(-1)
SetMouseDelay(-1)
SetWinDelay(-1)
; --------------------------------------------------------------------------------
DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; This is kinda cool, I like this ; Sub-Section .....: Make Window Groups
; --------------------------------------------------------------------------------
; make_window_groups()
; --------------------------------------------------------------------------------
; TraySetIcon("shell32.dll","16") ; this changes the icon into a little laptop thing.
TraySetIcon("shell32.dll","16", true) ; this changes the icon into a little laptop thing.


; --------------------------------------------------------------------------------
; Section .........: Auto-Execution
; --------------------------------------------------------------------------------
; Section .........: Auto-Execution
; Sub-Section .....: Tray Icon and Menu Options
; --------------------------------------------------------------------------------
; Tray := A_TrayMenu
Tray := A_TrayMenu
; TrayMenu := MenuBar()
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
Tray.Add("Made by OvercastBTC",madeBy)
Tray.Add()
; TraySetIcon("shell32.dll","16") ; this changes the icon into a little laptop thing.
; Tray.Add("Run at startup", "runAtStartup")
; Tray.ToggleCheck(fileExist(startup_shortcut) ? "check" : "unCheck", Run at startup ; update the tray menu status on startup
; TODO Finish updating Run at Startup
; Tray.Add("Presentation mode {Win+Shift+P}", togglePresentationMode) ; => does not exist
; ; Tray.Add("Keyboard shortcuts {Ctrl+Shift+Alt+\}", "viewKeyboardShortcuts")
; Tray.Add("Open file location", "openFileLocation")
; Tray.Add()
; Tray.Add("Run GUI_FE", "GUIFE")
Tray.Add('Run WindowsListMenu.ahk', WindowListMenu)
Tray.Add()
; ^+#2::

; return
Tray.Add('Run GUI_ListofFiles.ahk', GUI_ListofFiles)
Tray.Add("Run WindowProbe.ahk", WindowProbe)
; Tray.Add("Run Windows_Data_Types_offline.ahk", Windows_Data_Types_offline)
Tray.Add()
; Tray.Add("View in GitHub", "viewInGitHub")
; Tray.Add("See AutoHotKey documentation", "viewAHKDoc") ; => does not exist
; Tray.Add()
Tray.AddStandard
; Tray.Show
; --------------------------------------------------------------------------------
madeBy(madeBy,*){
}
WindowListMenu(*){
	Run("WindowListMenu.ahk")
}
; --------------------------------------------------------------------------------
#Include <Common_Abbrevations>
#Include <Common_HumanElement>
#Include <Common_OSTitles>
#Include <Common_Personal>
#Include <Common_Rec_Texts>
; #Include <WINDOWS.v2>
; --------------------------------------------------------------------------------
; <<<<< ... First Return ... <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
Return
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
#HotIf WinActive("ahk_exe Code.exe")
; Comment .....:
:*:;...::; {< 5} {. 3} First Return {. 3} {< 53}`nReturn`n; {< 80}
:*:;---::; {- 80}
:*:;,,,::; {< 80}
:*:;sect::; {- 80} `r; {< 80}`r; {- 80}
:*:{In::
{
Send("{Insert}")
Sleep(100)
SendEvent("{Enter}")
}
return
:*:{T::
{
	Send("{Tab}")
}	
return
:*:{S::Send("{Space}")
:*:{E::Send("{Enter}")
:*:sle::Sleep(100)
:*:Gui, Sh::
{
myGui := Gui()
myGui.Show("AutoSize")
Send("{Enter}")
}
return
:*:Gui, Su::
{ ; V1toV2: Added bracket
Send("Gui, Submit,Nohide")
Send("{Enter}")
} ; V1toV2: Added Bracket before hotkey or Hotstring
return
:*:clipw::Errorlevel := !ClipWait(1)
#HotIf
; -------------------------------------------------------------------------------- 
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
; --------------------------------------------------------------------------------
; Section .....: Save with Hotkey Function
; Function ....: ReloadAllAHKScripts()
; --------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe Code.exe")
#Include <Abstractions\Script>
~^s::
{
	; ReloadAllAhkScripts()
	Script.Reload()
}

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
#HotIf
; --------------------------------------------------------------------------------
#c::CenterWindow("A")

CenterWindow(winTitle*) {
    hwnd := WinExist(winTitle*)
    WinGetPos ,, &W, &H, hwnd
    mon := GetNearestMonitorInfo(hwnd)
    WinMove mon.WALeft + mon.WAWidth // 2 - W // 2, mon.WATop + mon.WAHeight // 2 - H // 2,,, hwnd
}
return

GetNearestMonitorInfo(winTitle*) {
    static MONITOR_DEFAULTTONEAREST := 0x00000002
    hwnd := WinExist(winTitle*)
    hMonitor := DllCall("MonitorFromWindow", "ptr", hwnd, "uint", MONITOR_DEFAULTTONEAREST, "ptr")
    NumPut("uint", 104, MONITORINFOEX := Buffer(104))
    if (DllCall("user32\GetMonitorInfo", "ptr", hMonitor, "ptr", MONITORINFOEX)) {
        Return  { Handle   : hMonitor
                , Name     : Name := StrGet(MONITORINFOEX.ptr + 40, 32)
                , Number   : RegExReplace(Name, ".*(\d+)$", "$1")
                , Left     : L  := NumGet(MONITORINFOEX,  4, "int")
                , Top      : T  := NumGet(MONITORINFOEX,  8, "int")
                , Right    : R  := NumGet(MONITORINFOEX, 12, "int")
                , Bottom   : B  := NumGet(MONITORINFOEX, 16, "int")
                , WALeft   : WL := NumGet(MONITORINFOEX, 20, "int")
                , WATop    : WT := NumGet(MONITORINFOEX, 24, "int")
                , WARight  : WR := NumGet(MONITORINFOEX, 28, "int")
                , WABottom : WB := NumGet(MONITORINFOEX, 32, "int")
                , Width    : Width  := R - L
                , Height   : Height := B - T
                , WAWidth  : WR - WL
                , WAHeight : WB - WT
                , Primary  : NumGet(MONITORINFOEX, 36, "uint")
            }
    }
    throw Error("GetMonitorInfo: " A_LastError, -1)
}
return
; --------------------------------------------------------------------------------
; Section .....: Functions
; Function ....: Run scripts selection from the Script Tray Icon
; --------------------------------------------------------------------------------
^+#1::
GUIFE(*){
	Run("GUI_FE.ahk")
}
return
; list

^+#3::
WindowProbe(*){
	Run("WindowProbe.ahk", "C:\Users\bacona\OneDrive - FM Global\3. AHK\")
}
return
^+#4::
GUI_ListofFiles(*){
	Run("GUI_ListofFiles.ahk")
}
return
^+#5::
{
Windows_Data_Types_offline(*){
	Run("Windows_Data_Types_offline.ahk", "C:\Users\bacona\OneDrive - FM Global\3. AHK\AutoHotkey_MSDN_Types-master\src\v1.1_deprecated\")
}
}
return
#o::
Detect_Window_Info(*){
	Run("Detect_Window_Info.ahk")
}
return
^+#6::
Detect_Window_Update(*){
	Edit()
}
return
^+#7::
test_script(*){
	Run("test_script.ahk")
}
return
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
; --------------------------------------------------------------------------------
;============================== Test Programs ==============================
#Numpad0::
; Parameter #1: Pass 1 instead of 0 to hibernate rather than suspend.
; Parameter #2: Pass 1 instead of 0 to suspend immediately rather than asking each application for permission.
; Parameter #3: Pass 1 instead of 0 to disable all wake events.
{ ; V1toV2: Added bracket
DllCall("PowrProf\SetSuspendState", "Int", 1, "Int", 0, "Int", 0)
return
; --------------------------------------------------------------------------------
; https://www.autohotkey.com/board/topic/53443-found-the-top-level-handle-one-hwnd-to-rule-them-all/
} ; V1toV2: Added Bracket before hotkey or Hotstring
^!#h::
{ ; V1toV2: Added bracket
	ControlHwnd := ""
	ControlSend("{Click}", , "ahk_id " ControlHwnd)
} ; V1toV2: Added Bracket before hotkey or Hotstring
return
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; ^!#g::
; { ; V1toV2: Added bracket
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
; } ; V1toV2: Added Bracket before hotkey or Hotstring
; return
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
;                Ctrl+Shift+Alt+r Reload AutoHotKey Script (to load changes)
; --------------------------------------------------------------------------------
^+!r::ReloadAllAhkScripts()
; - Chrome River----------------------------------
#HotIf WinActive("Chrome River - Google Chrome")
	; SendMode("Event")
	:*:bt::Business Travel -{Space} 
	:*:air::Business Travel - Airfare -
	:*:seat::Business Travel - Airline Fee - Seat Upgrade -
	:*:inter::Business Travel - Airline Fee - Internet - 
	:*:bags::Business Travel - Airline Fee - Baggage Fee - 
	:*:ho::Business Travel - Hotel -{Space}
	:*:me::Business Travel - Meal - 
	:*:car::Business Travel - Car Service -
	:*:rent::Business Travel - Rental Car -
	:*:mob::Business Mobile
	:*:bint::Business Internet
	:*:comp::Company Vehicle
	:*:off::Office Supplies - risk file organization folders for site visit efficiency 
return 
#HotIf

;:*:planeml::Edward Evatt, FM Global, edward.evatt@fmglobal.com{Enter}Terry Keatts, FM Global, terry.keatts@fmglobal.com ;Plan Review email additions
;:*:plansig::Terry Keatts, P.E.{Enter}Sr. Engineering Specialist{Enter}FM Global â€“ Seattle Office{Enter}ENGSanFranciscoPlanReviewSM@fmglobal.com{Enter}(925) 287-4336

; --------------------------------------------------------------------------------
;     DSP Email Subject Endings for Quick Entry ;#[AHK Script - DSPs]
; --------------------------------------------------------------------------------

:*:cinerf::Ciner Enterprises Inc. "Sisecam Wyoming LLC" [Green River WY] / 001131.69-01
:*:ciners::Ciner-Sisecam (001131.69-01)

:*:solvaygf::Solvay S.A. "Solvay Soda Ash Joint Venture / Soda Ash Expansion / Chemicals" / 000968.17-01
:*:solvaygs::Solvay (000968.17-01)

:*:heclagcf::Hecla Mining Company "Greens Creek Mine" [Admiralty Island AK] / 092010.60-03
:*:heclagcs::Hecla-Greens Creek (092010.60-03)
:*:heclags::Hecla-Greens Creek

:*:heclalff::Hecla Mining Company "Lucky Friday Mine" [Mullan ID] / 079127.30-07
:*:heclalfs::Hecla-Lucky Friday (079127.30-07)
:*:heclals::Hecla-Lucky Friday

:*:montanarssf::Montana Resources, LLC "Continental Mine and Operations" / 075346.68-03
:*:genesisf::Genesis Alkali Holdings LLC "Genesis Alkali Holdings LLC - Green River" / 075548.55-01
:*:pogof::Northern Star Resources Limited "Pogo Mine" / 000084.00-01
:*:materionf::Materion Corporation "Materion Natural Resources Inc." [Delta UT] / 075107.62-01
:*:reddogf::Teck Resources Limited " Red Dog Mine & Port Sites" [Kivalina, AK] / 092024.83-04 & 092024.83-05

:*:caesf::Cobham Group Limited "Microelectronic Solutions" [San Jose CA] / Index No. 000258.83-01
:*:cobhamf::Cobham Group Limited "Microelectronic Solutions" [San Jose CA] / Index No. 000258.83-01

:*:trinityf::Trinity Health Corporation "Saint Agnes Medical Center, Saint Agnes Medical Providers. Inc. & Trinity Information Services - Fresno" [Fresno CA] / 076602.13-04
:*:trinitys::Trinity (076602.13-04)

:*:mtcemf::Eagle Materials Inc. "Mountain Cement Company-EM" [Laramie WY] / Index No. 075554.08-02
:*:mtcems::Mountain Cement Co. (075554.08-02)

:*:Varexf::Varex Imaging Corporation [SLC UT] / 075053.23-07

:*:Cytivaf::Danaher Corporation "Cytiva" [Logan UT] / Index No. 001338.79-02
:*:Cytivas::Danaher Corp. - Cytiva (001338.79-02)

;---------------------------------------------------------------------------
;      Shift+WIN+m Button to Click on Window Anywhere to Drag
;---------------------------------------------------------------------------
; This script is from the Automator

!LButton::
{ ; V1toV2: Added bracket
CoordMode("Mouse", "Screen")
MouseGetPos(&x, &y)
WinMove(x, y, , , "A")
return
;---------------------------------------------------------------------------
;                       Time Stamp Code
;---------------------------------------------------------------------------
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:ts::
; format month and year
{ ; V1toV2: Added bracket
date := FormatTime(A_Now, "MM/yyyy")
Send("(AJB - " date ")")
return

;--------------------------------------------------------------------------
;                    Quick Launch Websites (and Log In)
;--------------------------------------------------------------------------
} ; V1toV2: Added Bracket before hotkey or Hotstring

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
{ ; V1toV2: Added bracket
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
} ; V1toV2: Added Bracket before hotkey or Hotstring
	^+a::
{ ; V1toV2: Added bracket
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
;--------------------------------------------------------------------------

^+c::
{
	Send("^c")
	Sleep(50)
	Run("http://www.google.com/search?q=" A_Clipboard)
	Return
}

;--------------------------------------------------------------------------
;          Permanently Set Caplocks Off, NumLock On and Scroll Lock Off
;--------------------------------------------------------------------------

SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")
return

;--------------------------------------------------------------------------
;                Win+Delete to Empty Recycle Bin
;--------------------------------------------------------------------------

#Del::FileRecycleEmpty() ; win + del

;---------------------------------------------------------------------------
;                      Helpful Stuff
;---------------------------------------------------------------------------
GetMouse:
CoordMode("Mouse", "Screen")
MouseGetPos(&mx, &my)
CoordMode("Mouse", "Window")
Return

PutMouse:
CoordMode("Mouse", "Screen")
MouseMove(mx, my, 0)
CoordMode("Mouse", "Window")
Return

:*:attext::	; Timestamp
{ ; V1toV2: Added bracket
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
{ ; V1toV2: Added bracket
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
} ; Added bracket before function

insert(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
	myGui := 
	oSaved := myGui.submit()
	Send(arr[SubStr(A_GuiEvent, 2)])
}
return

; :?*X:nm::Send("{Blind}≠") ; used for testing

:?*:not equal::
:?*:notequ::
:?*:not=::
:?*:!=::
{ ; V1toV2: Added bracket
A_Clipboard := "≠"
Send("^v")
return
} ; V1toV2: Added bracket in the end
#HotIf WinActive("ahk_exe Hznhorizon.exe")
	:?*:>=::
{ ; V1toV2: Added bracket
	A_Clipboard := "≥"
	Send("^v")
	Return
} ; V1toV2: Added bracket in the end
#HotIf
:?*:^i::^{i}

:?*X:microm::Send(chr(181) "m")
:?*X:3/4f::Send(chr(190))
:?*X:1/2f::Send(chr(189))
:?*X:1/4f::Send(chr(188))
:?*X:+-::Send(chr(177))
:?*X:regtmf::Send(chr(174)) ;®
:?*:trademarkf::™
:?*:circlec::©
:?*:copywritef::©
:?*:>=::
:?*:greater than or equal to::
{ ; V1toV2: Added bracket
A_Clipboard := "≥"
Send("^v")
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:?*X:degf::Send(chr(176) "F")
:?*X:degc::Send(chr(176) "C")
:?*X:prisecf::Send("1" chr(176) "/2 " chr(176) A_Space "Inj testing")
:*:hrsgf::heat recovery steam generator (HRSG)
:*:mocf::management of change (MOC)
::agf::Approval Guide
:*:FMDSf::FM Global Property Loss Prevention Data Sheet
::sgsv::seismic gas shutoff valve
::erpf::emergency response plan
::ferpf::flood emergency response plan
::wst::water supply tool
::efcf::eFC
::wdt::water delivery time
::wpivf::wall post-indicator valve
::pivf::post-indicator valve
::ulf::Underwriters Laboratories
::uupf::uncartoned unexpanded plastic
::uepf::uncartoned expanded plastic
::cupf::cartoned unexpanded plastic
::cepf::cartoned expanded plastic
::sopf::standard operating procedure
::eopf::emergency operating procedure
::ooo::out of office
::OSY::OS&Y
::sq.ft.::sq. ft.
::oemf::original equipment manufacturer
::ndef::nondestructive examination (NDE)
::ndtf::nondestructive testing (NDT)
::ndetf::nondestructive examination/testing (NDE/NDT)
::mehpf::minimum end head pressure
::mawpf::maximum allowable working pressure
::mipf::metal insulating panels
:*:lwco::LWCO
::LWCOf::low water cutout (LWCO)
::lfpil::low flash point ignitable liquid
::hfpil::high flash point ignitable liquid
:*:lmgtfy::https://letmegooglethat.com/?q=
::ITMf::inspection, testing, and maintenance (ITM)
::itm::ITM
::iras::in-rack automatic sprinklers
::il::ignitable liquid
::hrl::higher RelativeLikelihood
::htf::heat transfer fluid
::gp::generally protected
:*:FMRTPS::FM Global Red Tag Permit System
:*:FMHWPS::FM Global Hot Work Permit System
::FMDSl::FM Global Data Sheet
:*:FMA::FM Approved
::FRPf::fiber-reinforced plastic panels
::epof::emergency power off
::blrbf::black liquor recovery boiler
::efile::eFile
::icsf::industrial control system
::otf::operational technology network
::itf::information technology network
::mfaf::multi-factor authentication
:?*:exerie::experie


;---------------------------------------------------------------------------
;      Alt+Left Mouse Button to Click on Window Anywhere to Drag
;---------------------------------------------------------------------------
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm

Alt & ~LButton::
; ~MButton & LButton::
; CapsLock & LButton::
EWD_MoveWindow(*)
{
    CoordMode "Mouse"  ; Switch to screen/absolute coordinates.
    MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin
    WinGetPos &EWD_OriginalPosX, &EWD_OriginalPosY,,, EWD_MouseWin
    if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized 
        SetTimer EWD_WatchMouse, 10 ; Track the mouse as the user drags it.

    EWD_WatchMouse()
    {
        if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
        {
            SetTimer , 0
            return
        }
        if GetKeyState("Escape", "P")  ; Escape has been pressed, so drag is cancelled.
        {
            SetTimer , 0
            WinMove EWD_OriginalPosX, EWD_OriginalPosY,,, EWD_MouseWin
            return
        }
        ; Otherwise, reposition the window to match the change in mouse coordinates
        ; caused by the user having dragged the mouse:
        CoordMode "Mouse"
        MouseGetPos &EWD_MouseX, &EWD_MouseY
        WinGetPos &EWD_WinX, &EWD_WinY,,, EWD_MouseWin
        SetWinDelay -1   ; Makes the below move faster/smoother.
        WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY,,, EWD_MouseWin
        EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
        EWD_MouseStartY := EWD_MouseY
    }
}

#HotIf WinExist(A_ScriptName)
; ; Current date and time
FormatDateTime(format, datetime:="") {
    if (datetime = "") {
        datetime := A_Now
    }
    CurrentDateTime := FormatTime(datetime, format)
    SendInput(CurrentDateTime)
    return
}
; Hotstrings
::/datetime::
{ ; V1toV2: Added bracket
    FormatDateTime("dddd, MMMM dd, yyyy, HH:mm")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring

::/datetimett::
{ ; V1toV2: Added bracket
    FormatDateTime("dddd, MMMM dd, yyyy hh:mm tt")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*X:/c::FormatDateTime("yyyy.MM.dd HH:mm") "`r`n Reason goes here"
::/time::
{ ; V1toV2: Added bracket
    FormatDateTime("HH:mm")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/timett::
{ ; V1toV2: Added bracket
    FormatDateTime("hh:mm tt")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/date::
{ ; V1toV2: Added bracket
    FormatDateTime("MMMM dd, yyyy")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/daten::
{ ; V1toV2: Added bracket
    FormatDateTime("MM/dd/yyyy")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/datet::
{ ; V1toV2: Added bracket
    FormatDateTime("yy.MM.dd")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/week::
{ ; V1toV2: Added bracket
    FormatDateTime("dddd")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/day::
{ ; V1toV2: Added bracket
    FormatDateTime("dd")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/month::
{ ; V1toV2: Added bracket
    FormatDateTime("MMMM")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/monthn::
{ ; V1toV2: Added bracket
    FormatDateTime("MM")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/year::
{ ; V1toV2: Added bracket
    FormatDateTime("yyyy")
Return

; Others
} ; V1toV2: Added Bracket before hotkey or Hotstring
::wtf::Wow that's fantastic
::/paste::
{ ; V1toV2: Added bracket
    Send(A_Clipboard)
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
::/cud::
    ; useful for WSLs
{ ; V1toV2: Added bracket
    SendInput("/mnt/c/Users/" A_UserName "/")
Return
} ; V1toV2: Added Bracket before hotkey or Hotstring
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