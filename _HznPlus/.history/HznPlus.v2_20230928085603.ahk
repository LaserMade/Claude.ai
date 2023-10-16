/************************************************************************
 * function ......: Horizon Button ==> A Horizon function library
 * @description ..: This library is a collection of functions and buttons that deal with missing interfaces with Horizon.
 * @file HznPlus.v2.ahk
 * @author OvercastBTC
 * @date 2023.09.15
 * @version 3.0.0
 * @ahkversion v2+
 * @Section .....: Auto-Execution
 ***********************************************************************/
; --------------------------------------------------------------------------------
/************************************************************************
 * function ...........: Resource includes for .exe standalone
 * @author OvercastBTC
 * @date 2023.08.15
 * @version 3.0.0
 ***********************************************************************/
;@Ahk2Exe-SetVersion 3.0.2
;@Ahk2Exe-Obey U_V, = "%A_PriorLine~U)^(.+")(.*)".*$~$2%" ? "SetVersion" : "Nop"
;@Ahk2Exe-%U_V%        %A_AhkVersion%%A_PriorLine~U)^(.+")(.*)".*$~$2%
; @Ahk2Exe-AddResource HznPlus256.ico
; @Ahk2Exe-SetMainIcon HznPlus256.ico
; @Ahk2Exe-AddResource HznPlus256.ico, 160  ; Replaces 'H on blue'
; @Ahk2Exe-AddResource HznPlus256.ico, 206  ; Replaces 'S on green'
; @Ahk2Exe-AddResource HznPlus256.ico, 207  ; Replaces 'H on red'
; @Ahk2Exe-AddResource HznPlus256.ico, 208  ; Replaces 'S on red'
;@include-winapi
; --------------------------------------------------------------------------------
/**	@function #Includes															*/
; --------------------------------------------------------------------------------
/**	@function Auto-Execution													*/
#Include <Directives\__AE.v2>
; ! in test phase to use a class for Auto Execution Section
; AE.__Init() ;- Does not appear to be required
; --------------------------------------------------------------------------------
/**	@function Class_#Includes													*/
#Include <Directives\__HznToolbar>
; #Include <gdi_plus_plus>
#Include <Gdip_All>
; #Include <Tools\Hider>
; #Include <Lib.v2\UIA>
; #Include <EnumAllMonitorsDPI.v2>
; #Include <DPI>
; #Include <GetNearestMonitorInfo().v2>
; #Include <Abstractions\Script>
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/************************************************************************
* ;Description ...: Create Tray Icon
* @description ...: Create the tray icon using the embedded B64 via Create_HznHorizon_ico()
* @author OvercastBTC
* @date 2023.08.15
* @version 2.0.1
 ***********************************************************************/
TraySetIcon('HICON:' Create_HznHorizon_ico())
; --------------------------------------------------------------------------------
; Check_Startup_Status()
; --------------------------------------------------------------------------------

#HotIf WinActive(A_ScriptName " - Visual Studio Code")
~^s::Run(A_ScriptName)
#HotIf
; -------------------------------------------------------------------------------------------------
/************************************************************************
* @Title .........: Create Tray Menu
* @Description ...: Create options (//TODO add functions here) for use with the script (e.g., run at startup, open horizon, etc.)
* @file HznPlus.v2.ahk
* @author OvercastBTC
* @date 2023.08.09
* @version 0.0.1
* @TODO ;[ ] TODO	.: Convert from v1 to v2
 ***********************************************************************/
; -------------------------------------------------------------------------------------------------

; HznTray := A_TrayMenu
; see at the bottom for the functions
return
; --------------------------------------------------------------------------------------------------
/************************************************************************
; function ...: Horizon Hotkeys
@description: Hotkeys (shortcuts) for normal Windows hotkeys that should exist
@author OvercastBTC
@notes
@function Italics - (CTRL+I)
@function Bold - (CTRL+B)
@function Underline - (CTRL+U) (where applicable)
@function SelectAll - (CTRL+A)
@function Save - (CTRL+S) (still a work in progress)
 ***********************************************************************/

#HotIf WinActive('ahk_exe hznhorizon.exe')

^b::button(100)			; bold
^i::button(101)			; italics
^u::button(102)			; underline
; idCommand 103 thru 108 are disabled (btnstate = 8)
; button(103) = Separator
; button(104) = Align Left
; button(105) = Align Right
; button(106) = Align Center
; button(107) = Justitfied
; button(108) = Separator
; ^x::button(109) 		; cut
; ^c::button(110) 		; copy
; ^v::button(111) 		; paste
; ^z::button(113) 		; undo
; ^y::button(114) 		; redo
; idCommand (115) unknown but does something?
^+b::button(116) 		; Bulleted List
; ^F5::
F7::
^F7::
F5::button(117) 		; spell check
; idCommand (118) unknown (btnstate = 1)
^+s::button(119) 		; super|sub script
^f::button(120)			; find (focused tab) and find/replace
^r::
^+f::HznFindReplace()	; find/replace (focused tab) and find
^a::HznSelectAll()
^+v::HznPaste()
^+c::HznGetText()
~^s::HznSave()
^F4::HznClose() 		; fix [] => need to only be on certain screen(s).
^+9::HznEnableButtons() ; works!!!
^+8::HznTbCustomize() 	; works!!! enables and shows all buttons on the toolbar
^+7:: 					; ! test hotkey
{
	Hzn := HznToolbar().__HznNew()
	; ControlSetEnabled(1,nCtl)
	n:=SendMessage(WM_ENABLE := 0x000A, true,,Hzn.hTb,Hzn.hTb)
	n1:=DllCall('EnableWindow', 'Ptr', Hzn.hTb, 'Int', true)
	; DllCall ("CreateWindowEx"
	; 				, "Uint", 0
	; 				, "str",  'Toolbar32'         		; ClassName
	; 				, "str",  "msvb_lib_toolbar"  		; WindowName
	; 				, "Uint", 0x40000000 | 0x10000000 	; WS_CHILD, WS_VISIBLE
	; 				, "int",  0                       	; Left
	; 				, "int",  0                       	; Top
	; 				, "int",  200                     	; Width
	; 				, "int",  200                     	; Height
	; 				, "Uint", hCtl	            			; hWndParent
	; 				, "Uint", 0                       	; hMenu
	; 				, "Uint", fCtl_I                    ; hInstance
	; 				, "Uint", 0)
	transp := WinGetTransparent(hzn.hTb)
	; Dllcall ("SetLayeredWindowAttributes", "ptr", hTb, "ptr", 0, "char", 255, "uint", 2)
	SendMessage(0x421,,,,Hzn.hTb)
	SendMessage(0x421,,,,Hzn.hTb)
	n2:=DllCall('ShowWindow', 'Ptr', Hzn.hTb, 'Int', 1)
	; n3:=DllCall('WinMain', 'UInt', hTb,'UInt',0, 'Int', 1, 'Str','ahk_exe hznhorizon.exe')
	n3:=DllCall('IsWindowVisible', 'Ptr', Hzn.hTb)
	MsgBox(Hzn.hCtl '`n'
			. Hzn.fCtl '`n'
			. transp '`n'
			. Hzn.fCtlI '`n'
			. Hzn.nCtl '`n'
			. Hzn.hTb '`n'
			. n '`n'
			. n1 '`n'
			. n2 '`n'
			. n3 '`n'
			)
	return		
}
#HotIf
; _hCtl() => this.hCtl := ControlGetFocus('A') ; *works
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/************************************************************************
* Function ...: HznFindReplace() (Ctrl+Shift+f || Ctrl+r)
* @author OvercastBTC 
***********************************************************************/

HznFindReplace()
{
	button(120)
	Sleep(100)
	state := GetKeyState('Alt')
	If (!state = 0)
		{
			return
		}
	Send('{LAlt down}')
	SendEvent('p')
	Sleep(100)
	Send('{LAlt Up}')
	return
}
; --------------------------------------------------------------------------------
/************************************************************************
* Function ...: HznSave() (Ctrl-s)
* @author OvercastBTC 
***********************************************************************/

HznSave()
{
	idWin := WinGetID('A')
	Sleep(100)
	WinActivate(idWin)
	; --------------------------------------------------------------------------------
	state_Alt := GetKeyState('Alt')
	state_Lalt := GetKeyState('LAlt')
	state_Ralt := GetKeyState('RAlt')
	If (!state_Alt = 0) || (!state_Lalt = 0) || (!state_Ralt = 0)
		{
			SendEvent('f') ; SendEvent required
			Sleep(100)
			Send('s')
			return
		}
	Send('{LAlt down}')
	SendEvent('f') ; SendEvent required
	Sleep(100)
	Send('{LAlt Up}')
	Send('s')
	return
}
; --------------------------------------------------------------------------------
/************************************************************************
 * @function HznClose() (Ctrl-F4)
 * @author OvercastBTC 
 * @author Descolada and his UIA library and functions
 * @description Horizon Close Button (Ctrl-F4) ==> ≠ Alt-F4
***********************************************************************/
; --------------------------------------------------------------------------------

HznClose(*)
{
	; prevents the user from doing anything to screw it up by blocking all input
	BlockInput(1)
	; --------------------------------------------------------------------------------
	/**
	 * @function Alt + - (Hzn Hotkey for hidden menuitems )
	 */
	; idWin := WinGetID(,'Vital Equipment for Site')
	; SendMessage(WM_MENUSELECT := 0x011F,0,0,,idWin)
	; wParam := 0x02C41637
	; SendMessage(WM_INITMENU := 0x0116,wParam,0,,idWin)
	; return
	; SendEvent('{Alt D}-{Alt U}')
	state := GetKeyState('Alt')
	; MsgBox(state)
	; return
	If (!state = 0)
		{
			return
		}
	Send('{LAlt down}')
	SendEvent('-')
	Sleep(100)
	Send('{LAlt Up}')
	Sleep(300) ; <==== Need to change this to a WinWaitActive scenario, but still having trouble getting any data
	Send('c')
	; --------------------------------------------------------------------------------
	BlockInput(0)
	return
	/**@isthisneeded ;Note ???
	*/
	; hWnd := WinGetID('A')
	; hMenu := DllCall("GetTitleBarInfo", "Ptr", hwnd, "Int")
	; OutputDebug(hMenu)
	; --------------------------------------------------------------------------------
}

; -------------------------------------------------------------------------------------------------
/************************************************************************
 * Desc ......: Horizon Hotkey - Select-All (Ctrl-A)
 * @author ...: Descolada, OvercastBTC
 * Function ..: Select-All() (Ctrl-A)
 * @param Msg - EM_SETSEL := 177 - the Windows API message for "Set Selection"
 * @param wParam - := 0
 * @param lParam := -1
***********************************************************************/
; -------------------------------------------------------------------------------------------------
HznSelectAll(*)
{
	; --------------------------------------------------------------------------------
	hCtl := HznToolbar._hCtl()
	; --------------------------------------------------------------------------------
	Static Msg := EM_SETSEL := 177, wParam := 0, lParam := -1
	; --------------------------------------------------------------------------------
	DllCall('SendMessage', 'UInt', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; --------------------------------------------------------------------------------
	return
}
; --------------------------------------------------------------------------------

/************************************************************************
 * Function ..: HznGetText() (Ctrl+Shift+c)
 * @author ...: OvercastBTC
 * @param hCtl ........: Gets the handle (hwnd) to the control in focus
 * @param A_Clipboard .: The AHK builtin clipboard
 * @returns {text in the control (RT6TextBox or TX11)}
***********************************************************************/
HznGetText(*)
{
	hCtl := HznToolbar._hCtl()
	text := A_Clipboard := ControlGetText(hCtl)
	; --------------------------------------------------------------------------------
	OutputDebug(text)
	; --------------------------------------------------------------------------------
	MsgBox(text '`n`n' '[This text has been copied to the clipboard. Use Ctrl+v to paste, or right-click and select Paste in your window of choice.]','Copy of Horizon Text')
	; --------------------------------------------------------------------------------
	return text
}
; --------------------------------------------------------------------------------
/************************************************************************
 * Function ..: HznPaste() (Ctrl+Shift+v)
 * @author ...: OvercastBTC
 * @source ...: https://learn.microsoft.com/en-us/windows/win32/dataxchg/wm-paste
 * @sourceparam .......: #define WM_PASTE                        0x0302
 * @param hCtl ........: Gets the control in focus hwnd, then the class name
 * @param Msg .........: Windows API message => WM_PASTE
 * @param WM_PASTE ....: Decimal number (versus hex = 0x0302) for WM_PASTE
 * @param wParam ......: This parameter is not used and must be zero.
 * @param lParam ......: This parameter is not used and must be zero.
 * @returns {null} ....: This message does not return a value.
***********************************************************************/
HznPaste(*)
{
	; --------------------------------------------------------------------------------
	hCtl := HznToolbar._hCtl()
	; --------------------------------------------------------------------------------
	Static Msg := WM_PASTE := 770, wParam := 0, lParam := 0
	; --------------------------------------------------------------------------------
	DllCall('SendMessage', 'Ptr', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; --------------------------------------------------------------------------------
	return
}
; -------------------------------------------------------------------------------------------------
HznEnableButtons(hTb?)
{
	SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
	BlockInput(1) ; 1 = On, 0 = Off
	hTb := HznToolbar().__HznNew().hTb
	; --------------------------------------------------------------------------------
	Static   WM_COMMAND := 273, TB_GETBUTTON:= 1047, TB_BUTTONCOUNT:= 1048,TB_COMMANDTOINDEX := 1049
			,TB_GETITEMRECT := 1053,MEM_PHYSICAL := 4,MEM_RELEASE := 32768,TB_GETSTATE := 1042
			,TB_GETBUTTONSIZE := 1082, TB_ENABLEBUTTON := 0x0401, TB_SETSTATE := 0x0411,TBSTATE_ENABLED := 0x04 
	; --------------------------------------------------------------------------------
	; Step: count and load all the msvb_lib_toolbar buttons into memory
	; --------------------------------------------------------------------------------
	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0,, hTb)
	; --------------------------------------------------------------------------------
	; Step: Use the @params to press the button
	; --------------------------------------------------------------------------------
	Loop buttonCount
		{
			idCommand := A_Index +99
			SendMessage(TB_SETSTATE, idCommand, 0|TBSTATE_ENABLED,,hTb)
		}	
	return
}
/**
 * function: HznTbCustomize()
 * @description : enables and shows all buttons on the toolbar
 * @hotkey 		: ^+8::
 * @param 		hTb 
 * @returns 	{void} 
 */
HznTbCustomize(hTb?)
{
	SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
	BlockInput(1) ; 1 = On, 0 = Off
	hTb := HznToolbar._hTb()
	Static TB_CUSTOMIZE := 1051, TB_CUSTOMIZE := 0x41B,wParam := 0, lParam := 0, control := hTb
	try SendMessage(TB_CUSTOMIZE, wParam, lParam,control, hTb) ;wow, this works!!!
	BlockInput(0)
	SendLevel(0)
	return
}
; -------------------------------------------------------------------------------------------------
/************************************************************************
 * @function button()
 * @author ....: Descolada, OvercastBTC
 * @Desc ......:  Call the Horizon msvb_lib_toolbar buttons using the button() function
 * @param A_ThisHotkey - AHK's built in variable.
 * @param idCommand .: optional => idCommand := 0 (preset value, else => idCommand?)
***********************************************************************/
button(idCommand:=0)
{
	SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
	BlockInput(1) ; 1 = On, 0 = Off
	; try
	; 	fCtl := ControlGetClassNN(ControlGetFocus('A')), fCtlInstance := SubStr(fCtl, -1, 1), nCtl := "msvb_lib_toolbar" fCtlInstance, hTb := ControlGethWnd(nCtl, "A")
	; 	, hTx := ControlGethWnd(fCtl, "A"), pID := WinGetPID(hTb)
	hTb := HznToolbar._hTb()
	nCtl := HznToolbar._nCtl()
	
	
	; --------------------------------------------------------------------------------
	HznEnableButtons(hTb)
	; --------------------------------------------------------------------------------
	; try	(idCommand = 102) ? SendMessage(TB_SETSTATE := 0x0411, 102, 0|TBSTATE_ENABLED := 0x04, ,hTb) : idCommand
	; try	(idCommand = 102) ? SendMessage(TB_ENABLEBUTTON := 0x0401, 102, true, ,hTb) : idCommand
	; --------------------------------------------------------------------------------
	try	(idCommand >= 100) ? idBtn := idButton(idCommand) : idBtn := idButton(A_ThisHotkey)
	catch
		(idCommand < 100) ?	idCommand := (((idBtn := idButton(A_ThisHotkey)) + 100)-1) : idCommand
	; --------------------------------------------------------------------------------
	init_bState := GETBUTTONSTATE(idCommand,hTb)
	try {
		if (init_bState = 4) || (init_bState = 6) || (init_bState = 1)
			HznButton(hTb,nCtl, idCommand, idBtn)
	} catch Error as e {
		OutputDebug('return`nbtnstate: ' init_bState)
		return
	}
	; --------------------------------------------------------------------------------
	try {
		aft_bState := GETBUTTONSTATE(idCommand,hTb)
		chk_bState := (init_bState != aft_bState)
	} catch Error as e {
		if chk_bState = true
		OutputDebug('return`nbtnstate: ' init_bState)
		; throw e
		return
	}
	; --------------------------------------------------------------------------------
	SendLevel(0) ; restore normal SendLevel
	BlockInput(0) ; 1 = On, 0 = Off
	return
}
; --------------------------------------------------------------------------------
/************************************************************************
 * @function idButton()
 * @author ....: Descolada, OvercastBTC
 * @Desc ......:  Call the Horizon msvb_lib_toolbar buttons using the button() function
 * @param A_ThisHotkey - AHK's built in variable.
 * @param idBtn .: optional => idCommand := 0 (preset value, else => idCommand?)
***********************************************************************/
idButton(buttonhotkey?)
{
	try 
		(buttonhotkey >= 100) ? idBtn := (buttonhotkey - 99) : buttonhotkey
	catch
		idBtn:= (A_ThisHotkey = "^b") ? 1 	: 	;.........: bold
				(A_ThisHotkey = "^i") ? 2 	: 	;.........: italic
				(A_ThisHotkey = "^u") ? 3 	: 	; ........: underline
				(A_ThisHotkey = "^x") ? 8 	:	; ........: cut
				(A_ThisHotkey = "^c") ? 9 	:	; ........: copy
				; (A_ThisHotkey = "^v") ? 10	:	; ........: paste
				(A_ThisHotkey = "^z") ? 12	:	; ........: undo
				(A_ThisHotkey = "^y") ? 13	:	; ........: redo
				(A_ThisHotkey = '^+b') ? 15	:	; ........: Bulleted List
				(A_ThisHotkey = 'F5') ? 16	:	; ........: Find/Replace
				(A_ThisHotkey = '^F5') ? 16	:	; ........: Find/Replace
				(A_ThisHotkey = '^+s') ? 18	:	; ........: super|sub script
	OutputDebug('idBtn: ' idBtn '`n')
	return idBtn
}
; -------------------------------------------------------------------------------------------------
/************************************************************************
 * Function .....: HznButton()
 * @Desc Clicks the nth item in a Win32 application toolbar.
 * @author ......: Descolada, OvercastBTC
 * @param hTb - The handle of the toolbar control.
 * @param hTb - same as hTb
 * @param fCtl* - [OPTIONAL] The ClassNN of the "focused" control.
 * @param fCtlInstance - The ClassNN [instance] of the "focused" control.
 * @param nCtl - The [ClassNN and instance] of the toolbar control.
 * @function param:=0 => in AHK v2 => optional
 * @example
 * 	fCtl := ControlGetClassNN(ControlGetFocus("A"))
 * 	fCtlInstance := SubStr(fCtl, -1, 1)
 * 	nCtl := "msvb_lib_toolbar" fCtlInstance
 * 	hTb := ControlGethWnd(nCtl, "A")
 * 	hTx := ControlGethWnd(fCtl, "A")
 * HznButton(hTb, 3) ; Clicks the third item
 ***********************************************************************/
; --------------------------------------------------------------------------------

HznButton(hTb, nCtl, idCommand, n?, pID?, fCtl?, hTx?, fCtlInstance?) {
	; --------------------------------------------------------------------------------
	; Step: [OPTIONAL] Block all input while the function running
	; --------------------------------------------------------------------------------
	SendLevel(5)
	BlockInput(1) ; 1 = On, 0 = Off
	hTb := HznToolbar._hTb()
	; --------------------------------------------------------------------------------
	Static   WM_COMMAND := 273, TB_GETBUTTON:= 1047, TB_BUTTONCOUNT:= 1048,TB_COMMANDTOINDEX := 1049
			,TB_GETITEMRECT := 1053,MEM_PHYSICAL := 4,MEM_RELEASE := 32768,TB_GETSTATE := 1042
			,TB_GETBUTTONSIZE := 1082, TB_ENABLEBUTTON := 0x0401
	; --------------------------------------------------------------------------------
	; Step: count and load all the msvb_lib_toolbar buttons into memory
	; --------------------------------------------------------------------------------
	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, , Integer(hTb))
	; --------------------------------------------------------------------------------
	; Step: Use the @params to press the button
	; --------------------------------------------------------------------------------
	try if (n >= 1 && n <= buttonCount)
	{
		; * Get the toolbar "thread" process ID (PID) 
		DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &tpID:=0) 
		; --------------------------------------------------------------------------------
		; * Open the process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
		hProcess := DllCall( 'OpenProcess', 'UInt', 8 | 16 | 32, "Int", 0, "UInt", tpID, "Ptr")
		; --------------------------------------------------------------------------------
		; * Identify if the process is 32 or 64 bit (efficiency step)
		Is32bit := Win32_64_Bit(hProcess) 
		; --------------------------------------------------------------------------------
		; * Allocate memory for the TBBUTTON structure in the target process's address space
		remoteMemory := remoteTbMemory(hProcess, Is32bit, &TBBUTTON_SIZE) 
		; --------------------------------------------------------------------------------
        DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", remoteMemory, "UPtr", 0, "UInt", MEM_RELEASE)
        DllCall("CloseHandle", "Ptr", hProcess)
		; --------------------------------------------------------------------------------
		; Step: Store previous and set min delay
		; --------------------------------------------------------------------------------
		prevCDelay := A_ControlDelay, prevMDelay := A_MouseDelay, prevWDelay := A_WinDelay,	SetControlDelay(-1), SetMouseDelay(-1), SetWinDelay(-1)
		; --------------------------------------------------------------------------------
		try (idCommand < 100) ?	idCommand := ((n-1) + 100) : idCommand
		btnstate := GETBUTTONSTATE(idCommand,hTb)
		If (!btnstate = 4) || (!btnstate = 6) ;! note: (AJB - 09/2023) verified
			return
		; --------------------------------------------------------------------------------
		; function: !!! ===> Programatically "Click" the button!!! <=== !!!
		Msg := WM_COMMAND, wParam_hi := !btnstate, wParam_lo := idCommand, lParam := control := hTb
		SendMessage(Msg, wParam_hi | wParam_lo,lParam,, hTb)
		; --------------------------------------------------------------------------------
		; Step: Restore previous and set delay
		; --------------------------------------------------------------------------------
        SetControlDelay(prevCDelay), SetMouseDelay(prevMDelay),	SetWinDelay(prevWDelay)
		; --------------------------------------------------------------------------------

		; --------------------------------------------------------------------------------
		BlockInput(0) ; 1 = On, 0 = Off
		; --------------------------------------------------------------------------------
    } catch
        throw ValueError("The specified toolbar " nCtl " was not found. Please ensure the edit field has been selected and try again.", -1)
		try OutputDebug (  'ButtonCount: ' buttonCount '`n'
		. 'pID: ' tpID '`n'
		. 'remoteMemory: ' remoteMemory '`n'
		. 'hProcess: ' hProcess '`n'
		. 'btnstate: ' btnstate '`n'
		)
    Return 0
}
; --------------------------------------------------------------------------------
/**
 * @function ControlClick()
 * @note All of these are equivalent as of 09.11.23
 */
HznControlClick(X, Y)
{
; ControlClick("x" ((X+(W/2))*DPIsc) " y" ((Y+(H/2))*DPIsc), hTb,,,, "NA")
; ControlClick("x" (X2*DPIsc) " y" (Y2*DPIsc), hTb,,,, "NA")
; ControlClick("x" X " y" Y, hTb,,,, "NA") ; <===== this one is the best usable
}
; --------------------------------------------------------------------------------
loadSDK() ;fix => does not work => MAP() or Object?
{
	Static WM_COMMAND			:= 273 		; 0x111
	Static WM_USER				:= 1024 	; 0x400
	Static TB_GETBUTTON    		:= 1047 	; 0x417, WM_USER+23
	Static TB_BUTTONCOUNT  		:= 1048 	; 0x0418, WM_USER+24
	Static TB_COMMANDTOINDEX	:= 1049
	Static TB_GETITEMRECT  		:= 1053 	; 0x41D,
	Static MEM_COMMIT      		:= 4096 	; 0x1000, ; 0x00001000, ; via MSDN Win32 
	Static MEM_RESERVE     		:= 8192 	; 0x2000, ; 0x00002000, ; via MSDN Win32
	Static MEM_PHYSICAL    		:= 4 		; 0x04    ; 0x00400000, ; via MSDN Win32
	Static MEM_PROTECT     		:= 64 		; 0x40 ;  
	Static MEM_RELEASE     		:= 32768 	; 0x8000 ; 
	Static TB_GETSTATE			:= 1042 	; WM_USER+18 ; (1042)
	Static TB_GETBITMAP			:= 1068 	; WM_USER+44 ; (1068)
	Static TB_GETBUTTONSIZE		:= 1082 	; WM_USER+58 ; 1082
	Static TB_GETBUTTONTEXTA	:= 1069 	; WM_USER+45
	Static TB_GETBUTTONTEXTW	:= 1099 	; WM_USER+75 ; (1099)
	Static TB_GETITEMRECT		:= 1053 	; WM_USER+29 ; (1053)
	Static TB_PRESSBUTTON 		:= 1027 	; 0x403
	Static TB_SETSTATE 			:= 1041 	; 0x0411
	Static TBSTATE_PRESSED		:= 2 		; 0x02 
	Static WM_LBUTTONDOWN 		:= 513 		; 0x201
	Static WM_LBUTTONUP 		:= 515 		; 0x202
	Static BM_CLICK				:= 245 		; 0x000000F5
	Static TB_ISBUTTONPRESSED 	:= 1035 	; 0x040B
	Static WM_GETDLGCODE := 135, WM_NEXTDLGCTL := 40, TB_GETBUTTONINFOW	:= 1087 ;, hTb := hTb
}
; --------------------------------------------------------------------------------
setDelay(&prevCDelay, &prevMDelay, &prevWDelay)
{
	prevCDelay := A_ControlDelay, prevMDelay := A_MouseDelay, prevWDelay := A_WinDelay
	SetControlDelay(-1), SetMouseDelay(-1), SetWinDelay(-1)
}
; --------------------------------------------------------------------------------
remoteTbMemory(hProcess, Is32bit, &TBBUTTON_SIZE)
{
	Static MEM_PHYSICAL := 4 ; 0x04 ; 0x00400000, ; via MSDN Win32
	RPtrSize := Is32bit ? 4 : 8
	TBBUTTON_SIZE := 8 + (RPtrSize * 3) 
	remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", TBBUTTON_SIZE, "UInt", 0x1000, "UInt", MEM_PHYSICAL, "Ptr")
	return remoteMemory
}
; --------------------------------------------------------------------------------
/**
 * function: Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
 * @param tpID
 * @param PROCESS_VM_READ
 * 		@param Int32
 * 		@Dec_Value 8
 * 		@Hex_Value 0x00000008 ??? or 0x0018 ???
 * @param PROCESS_VM_READ
 * 		@param Int32
 * 		@Dec_Value 16
 * 		@Hex_Value 0x00000010 ??? or 0x0010
 * @param PROCESS_VM_WRITE
 * 		@param Int32
 * 		@Dec_Value 32
 * 		@Hex_Value 0x00000020 ??? or 0x0020
 * @example hProcess := DllCall('OpenProcess', 'UInt', 0x0018 | 0x0010 | 0x0020, 'Int', 0, 'UInt', tpID, 'Ptr')
 * @returns {hProcess}
 */
hTbProcess(tpID)
{
	Static PROCESS_VM_OPERATION := 8, PROCESS_VM_READ := 16, PROCESS_VM_WRITE := 32
	hProcess := DllCall( 'OpenProcess', 'UInt'
						, PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE
						, "Int", 0
						, "UInt", tpID
						, "Ptr")
	return hProcess 					
}
; --------------------------------------------------------------------------------
; fix
; ^+7::GETBUTTON(101)
GETBUTTON(n:=1, hTb?, pID?, hProcess?)
{
	Static 	TB_GETBUTTON := 1047 ; hex = 0x417
	OutputDebug('n: ' n '`n')
	; pID := WinGetPID(hTb)
	tpID := HznToolbar().__HznNew().tpID
	hTb := HznToolbar().__HznNew().hTb
	hProcess := hTbProcess(tpID)
	; hProcess = 0 ? hProcess := hp_Remote(pID) : hpRemote := hpRemote
	remote_buffer := remoteTbMemory(hProcess,0,&TBBUTTON_SIZE)
	GETBUTTON := SendMessage(TB_GETBUTTON, n-1, remote_buffer, hTb, hTb)
	; MsgBox(GETBUTTON) ; ===> displays a zero (0)
	return GETBUTTON
}
GETBUTTONSTATE(idButton,hTb)
{
	Static TB_GETSTATE := 0x0412
	; GETSTATE := SendMessage(TB_GETSTATE, idButton, 0, hTb, hTb)
	GETSTATE := SendMessage(TB_GETSTATE, idButton, 0, hTb, hTb)
	btnstate := SubStr(GETSTATE,1,1)
	btnname := idButton = 100 ? 'Bold' : idButton = 101 ? 'Italic' : idButton = 102 ? 'Underline' : ''
	If (btnstate = 4) || (btnstate = 6) || (btnstate = 1)
		{
		return btnstate
		}
	MsgBox(   'The ' btnname
			. ' button is not available.' '`n'
			. 'idButton: ' idButton '`n'
			. 'btnstate: ' btnstate)
	OutputDebug("btnstate: " . btnstate . "`n")
	return btnstate
}
; --------------------------------------------------------------------------------
/**
 * @function COMMANDBUTTON()
 * @param Msg := WM_COMMAND
 * @param wParam_hi := control defined notification code => := 0 or !btnstate (opposite of current position => 4 || 6)
 * @param wParam_lo := control identifier => idCommand from above
 * @param lParam 	:= handle to the control => hTb
 */
COMMANDBUTTON(idCommand, hTb, btnstate:=0)
{
	Static WM_COMMAND := 273 ; hex = 0x111
	Static Msg := WM_COMMAND, wParam_hi := !btnstate , wParam_lo := idCommand, lParam := control := hTb := hTb
	; --------------------------------------------------------------------------------
	SendMessage(Msg, wParam_hi | wParam_lo,lParam,, hTb)
	; --------------------------------------------------------------------------------
	; if(btnstate = 4) ? SendMessage(TB_SETSTATE, idCommand, 6 | 0, hTb, hTb) : SendMessage(TB_SETSTATE, idCommand, 4 | 0, hTb, hTb)
	; WM_NCLBUTTONDOWN := 0x00A1
	; WM_NCLBUTTONUP := 0x00A2
	; SendMessage(WM_LBUTTONDOWN,,X1|Y1,hTb,hTb)
	; Sleep(100)
	; SendMessage(WM_LBUTTONUP,,X1|Y1,hTb,hTb)
}
; --------------------------------------------------------------------------------
Win32_64_Bit(hpRemote)
; Win32_64_Bit(hpRemote, &Is32:='False')
{
	A_Is64bitOS ? DllCall("IsWow64Process", "Ptr", hpRemote, "Int*", Is32bit := 0) : DllCall("IsWow64Process", "Ptr", hpRemote, "Int*", Is32bit := 1)
	; If (A_Is64bitOS)
	; 	{
	; 		Static Is32bit := 0
	; 	Try
	; 		DllCall("IsWow64Process", "Ptr", hpRemote, "Int*", Is32bit)
	; 	catch
	; 		Is32bit := 1
		Is32bit = 0 ? Is32:='False' : is32:='True'
	OutputDebug("Is32bit: " Is32 "`n")
	return Is32bit
}
; --------------------------------------------------------------------------------
/*
HznDPI()
{
	arHznDPI := Array()
	try {
		nmHwnd 	:= GetNearestMonitorInfo('A').Handle
		nmName 	:= GetNearestMonitorInfo('A').Name
		nmNum 	:= GetNearestMonitorInfo('A').Number
		nmPri 	:= GetNearestMonitorInfo('A').Primary
		mDPIx 	:= GetNearestMonitorInfo('A').x
		mDPIy 	:= GetNearestMonitorInfo('A').y
		mDPIw 	:= GetNearestMonitorInfo('A').WinDPI
		DPImw 	:= DPI.GetForWindow('A')
		DPIsc 	:= DPI.GetScaleFactor(DPImw) ; <====== this one
		; DPIsc1 	:= DPI.GetScaleFactor(mDPIx)
	} catch Error as e {
		OutputDebug('nmHwnd: '	nmHwnd '`n'
				.	'nmName: '	nmName '`n'
				.	'nmNum: '	nmNum '`n'
				.	'nmPri: '	nmPri '`n'
				.	'mDPIx: '	mDPIx '`n'
				.	'mDPIy: '	mDPIy '`n'
				.	'mDPIw: '	mDPIw '`n'
				.	'DPImw: '	DPImw '`n'
				.	'DPIsc: '	DPIsc '`n'
				; .	'DPIsc1: '	DPIsc1 '`n'
				.	'PriDPI: '	A_ScreenDPI '`n'
				)		
		throw e		
	}
	arHznDPI.Push(
		{  	  Number: '(' nmNum ')'
			, 1_Handle:nmHwnd
			, 2_Name:nmName
			, 3_x:mDPIx
			, 4_y:mDPIy
			, 5_WinDPI:mDPIw
			, 6_MainWinDPI:DPImw
			, 7_ScreenDPI:DPIsc
		})
	; --------------------------------------------------------------------------------
	return DPIsc
}
*/
; --------------------------------------------------------------------------------
; TODO need to validate that this works, but not high priority
/**
 * function .: for use in a button call that requires ControlCLick() and DPI adjustments
 * @description Get the bounds of each button (Get Item Rectangle)
 * @param GETITEMRECT( hProcess,n,remoteMemory,hTb,TBBUTTON_SIZE,Is32bit,&RECT,&BtnStructSize,&BtnStruct,&bytesRead,&Left,&Top,&Right,&Bottom, &X, &Y)
*/	
/*	
GETITEMRECT(hProcess, n,remoteMemory,hTb, TBBUTTON_SIZE, Is32bit, &RECT, &BtnStructSize, &BtnStruct, &bytesRead, &Left, &Top, &Right, &Bottom, &X, &Y)
{
	Static Msg := TB_GETITEMRECT := 1053, wParam := n, lParam := remoteMemory, control := ''
	SendMessage(Msg, wParam, lParam,, hTb)
	RECT := Buffer(TBBUTTON_SIZE, 0)
	; Note : Winapi TBBUTTON struct(32 bytes on x64, 20 bytes on x86)
	BtnStructSize := Is32bit ? 20 : 32
	BtnStruct := Buffer(BtnStructSize, 0)
	; --------------------------------------------------------------------------------
	; * Read the button information stored in the RECT (remoteMemory)
	DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory, "Ptr", RECT, "UPtr", BtnStructSize, "UInt*", &bytesRead:=32, "Int")
	; --------------------------------------------------------------------------------
	Left 	:= NumGet(RECT, 0, 	"Int")
	Top 	:= NumGet(RECT, 4, 	"Int")
	Right 	:= NumGet(RECT, 8, 	"Int")
	Bottom 	:= NumGet(RECT, 12, "Int")
	; --------------------------------------------------------------------------------
	; Note: Updated 09.11.23
	DPIsc := HznDPI()
	X1 		:= Left
	Y1 		:= Top
	W1 		:= Right-Left
	H1 		:= Bottom-Top
	W 		:= W1/2
	H 		:= H1/2
	X2 		:= X1+W
	Y2 		:= Y1+H
	X 		:= X2*=DPIsc
	Y 		:= Y2*=DPIsc
	; --------------------------------------------------------------------------------
	OutputDebug('X1:' X1 . ' ' . 'Y1:' . Y1 .  ' ' . 'W1:' . W1 . ' ' . 'H1:' . H1 . '`n'
		. 'W:' . W . " " . 'H:' . H . '`n'
		. 'X2:' X2 . ' ' . 'Y2:' . Y2 . '`n'
		. 'X:' . X . ' ' . 'Y:' . Y . '`n'
		)
}
*/
; --------------------------------------------------------------------------------
/**
 * Installs the script to the user startup folder
 * @function Check_Startup_Status()
 * @param hWndToolbar - The handle of the toolbar control.
 * @param n - The index of the toolbar item to click (1-based). Note: Separators are considered items as well.
 * @returns {void} 
 */
; --------------------------------------------------------------------------------
Check_Startup_Status(){
arrStartup := Array(
	startup := A_Startup '\',
	script := StrSplit(A_Startup, '.'),
	scriptnoext := script[1],
	scriptlnk := script[1] . '.lnk',
	scriptSC := script[1] . script[2] . ' - Shortcut',
	)

Startup_Shortcut := arrStartup() 
; Startup_Shortcut := A_Startup "\" A_ScriptName
If (!FileExist(Startup_Shortcut))
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
		; MsgBox("Shortcut Exists") ; Test message for debugging. Leave commented out for normal operation.
        Return
    }
}
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/************************************************************************
 * @function Create_HznHorizon_ico()
 * function: Create the .ico file for use in as the Tray Icon
 * @author 2.0.00.00 - 2023-07-31 - iPhilip - converted script to AutoHotkey v2
 * @param B64 - A picture converted to a string and encoded via b64
 * @source ;-> https://www.autohotkey.com/boards/viewtopic.php?f=83&t=119966
***********************************************************************/
; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_HznHorizon_ico(NewHandle := False) {
	Static hBitmap := 0
	If (NewHandle)
		hBitmap := 0
	If (hBitmap)
		Return hBitmap
	B64 := "AAABAAEAICAAAAEAIACoEAAAFgAAACgAAAAgAAAAQAAAAAEAIAAAAAAAgBAAAGAbAABgGwAAAAAAAAAAAAD7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////////////////////////////////////f/////RERE//tcQv/7XEL////////////////////////////////////////////////3/////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL///////////////////////////f/////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC////////////////////////////////90RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC////////////////////////////////////////////////////////////////////////////////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL///////////////////////////////////////////f////3////9/////f///////////////////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC/////////////////0RERP/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/////////////////////////////////RERE//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//////////////////////////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC////////////////////////////////////////////RERE//tcQv/7XEL/+1xC//tcQv////////////////////////////////////////////////9ERET/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/+1xC//tcQv/7XEL/AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA="
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", StrPtr(B64), "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", &DecLen := 0, "Ptr", 0, "Ptr", 0)
		Return False
	Dec := Buffer(DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", StrPtr(B64), "UInt", 0, "UInt", 0x01, "Ptr", Dec, "UIntP", &DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream := ComValue(13, 0))
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	SI := Buffer(8 + 2 * A_PtrSize, 0), NumPut("UInt", 1, SI, 0)
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", &pToken := 0, "Ptr", SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", &pBitmap := 0)
	DllCall("Gdiplus.dll\GdipCreateHICONFromBitmap", "Ptr", pBitmap, "PtrP", &hBitmap := 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	Return hBitmap
	}
; --------------------------------------------------------------------------------
/*
@resource ...: https://www.autohotkey.com/boards/viewtopic.php?t=73851
@ahkversion .: v1
*/
; CreateTrayMenu()
; addTrayMenuOption(label := "", command := "")
; {
;   Static Tray
;   Tray:= A_TrayMenu
; 	if (label = "" && command = "") {
; 		Tray.Add()
; 	} else {
; 		Tray.Add(label, command)
; 	}
; }
; shortcut(){
;     FileExist(Startup_Shortcut) ? ShortcutExist() : NoShortcut()
; }
; ShortcutExist(){
;     Tray.Check("Run at startup")
; }

; NoShortcut(){
;     Tray.Uncheck(Run at startup)
; }
; CreateTrayMenu()
; {
;     ;Menu, Tray, Icon, % hICON ; this changes the icon into a little Horizon thing.
;     ;Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
;     addTrayMenuOption("Made with nerd by Adam Bacon and Terry Keatts", "madeBy")
;     addTrayMenuOption()
;     addTrayMenuOption("Run at startup", "runAtStartup")
;     shortcut()
;     ; update the tray menu status on startup
;     addTrayMenuOption()
;     Tray.AddStandard()
; }
; runAtStartup() 
; {
;     FileExist(startup_shortcut) ? rmstartup() : addstartup()
; }

; addstartup(){
;     FileCreateShortcut(A_ScriptName, A_Startup . "\" . A_ScriptName . ".lnk", icostr)
;     Tray.Check(Run at startup) ; update the tray menu status on change
;     trayNotify("Startup shortcut added", "This script will now automatically run when your turn on your computer.")
; }

; rmstartup(){
;     FileDelete(startup_shortcut)
;     Tray.Uncheck(Run at startup) ; update the tray menu status on change
;     trayNotify("Startup shortcut removed", "This script will not run when you turn on your computer.")
; }

; madeBy()
; {
; 	MsgBox("This was made by nerds, for nerds. Regular people are ok too, lol.`nModified by OvercastBTC")
; }
; HideTrayTip()
; {
;     (SubStr(A_OSVersion, 1, 3) = "10.")   ? IconTrayTip()
;                                         : TrayTip
; }

; IconTrayTip()
; {
;     Tray.NoIcon()
;     Sleep(200)
;     Tray.Icon()
; }

; trayNotify(title, message, options := 0)
; {
;     TrayTip(title, message, options)
; }