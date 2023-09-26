/************************************************************************
 * ;Desc ..: Horizon Button ==> A Horizon function library
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
 * ;Description ..: Resource includes for .exe standalone
 * @author OvercastBTC
 * @date 2023.08.15
 * @version 3.0.0
 ***********************************************************************/
;@Ahk2Exe-SetMainIcon HznPlus256.ico
;@Ahk2Exe-AddResource HznPlus256.ico, 160  ; Replaces 'H on blue'
;@Ahk2Exe-AddResource HznPlus256.ico, 206  ; Replaces 'S on green'
;@Ahk2Exe-AddResource HznPlus256.ico, 207  ; Replaces 'H on red'
;@Ahk2Exe-AddResource HznPlus256.ico, 208  ; Replaces 'S on red'
;@include-winapi
; --------------------------------------------------------------------------------
#MaxThreads 255 ; Allows a maximum of 255 instead of default threads.
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
MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, ">=10.0.15063") ? -4 : -3
DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext
try
	DllCall("SetThreadDpiAwarenessContext", "ptr", MaximumPerMonitorDpiAwarenessContext, "ptr")
catch 
	DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
else
	DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
; --------------------------------------------------------------------------------
; #Include <gdi_plus_plus>
; #Include <Gdip_All>
; #Include <Class_Toolbar.c2v2>
; #Include <Tools\Hider>
; #Include <.\Lib.v2\UIA>
#Include <EnumAllMonitorsDPI.v2>
#Include <DPI>
#Include <GetNearestMonitorInfo().v2>
; #Include <Abstractions\Script>


; --------------------------------------------------------------------------------

; //TODO: 2023.07.17 ...: Work on the below but consider if needed due to new FreeLibraryAndExitThread
; //TODO: Library_Load(winuser.dll)
; //TODO: Library_Load(processthreadsapi.dll)
; //TODO: Library_Load(memoryapi.dll)
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
;Description: Horizon Hotkeys
;Description: Hotkeys (shortcuts) for normal Windows hotkeys that should exist
@author OvercastBTC
@notes
@function Italics - (CTRL+I)
@function Bold - (CTRL+B)
@function Underline - (CTRL+U) (where applicable)
@function SelectAll - (CTRL+A)
@function Save - (CTRL+S)
 ***********************************************************************/

#HotIf WinActive("ahk_exe hznhorizon.exe")

^i::button(101)
^b::button(100)
^u::button(102)
^a::HznSelectAll()
^v::HznPaste()
^+c::HznGetText()
^s::HznSave()
^#9::HznClose()

#HotIf

; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/************************************************************************
* ;desc ......: Horizon Save Button (Ctrl-S)
* @Desc ......: Use UIAutomation (UIA) to find the element where the save button exists
* @Author OvercastBTC 
* @Credit Descolada and his UIA library and functions
* Function HznSave() (Ctrl-S)
* @param Msg - EM_SETSEL := 177 - the Windows API message for "Set Selection"
* @param wParam := 0
* @param lParam := -1
***********************************************************************/

HznSave()
{
	idWin := WinGetID('A')
	WinActivate(idWin)
	; --------------------------------------------------------------------------------
	Send('!f') ; <==== This is an alternate method
	Sleep(300) ; <==== Need to change this to a WinWaitActive scenario, but still having trouble getting any data
	Send('s')
	return
}
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/************************************************************************
* ;desc ......: Horizon Close Button (Ctrl-F4) ==> ≠ Alt-F4
* @Desc ......: Use UIAutomation (UIA) to find the element where the close button exists
* @Author OvercastBTC 
* @Credit Descolada and his UIA library and functions
* Function HznClose() (Ctrl-F4)
* @param Msg - EM_SETSEL := 177 - the Windows API message for "Set Selection"
* @param wParam - := 0
* @param lParam := -1
***********************************************************************/
; --------------------------------------------------------------------------------
WM_MENUSELECT := 0x011F
WM_INITMENU := 0x0116
HznClose(*)
{
	/**@param BlockInput() => prevents the user from doing anything to screw it up */
	BlockInput(1)
	; --------------------------------------------------------------------------------
	; --------------------------------------------------------------------------------
	/**
	 * @function Alt + - (Hzn Hotkey for hidden menuitems )
	 */
	; --------------------------------------------------------------------------------
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
	return
}

; -------------------------------------------------------------------------------------------------
/************************************************************************
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
	fCtl := ControlGetClassNN(ControlGetFocus('A'))
	hCtl := ControlGethWnd(fCtl, 'A')
	; --------------------------------------------------------------------------------
	Static Msg := EM_SETSEL := 177, wParam := 0, lParam := -1
	; --------------------------------------------------------------------------------
	DllCall('SendMessage', 'Ptr', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
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
	; --------------------------------------------------------------------------------
	hCtl := ControlGetFocus('A')
	; --------------------------------------------------------------------------------
	text := A_Clipboard := ControlGetText(hCtl)
	; --------------------------------------------------------------------------------
	OutputDebug(text)
	; --------------------------------------------------------------------------------
	MsgBox(text '`n`n' '[This text has been copied to the clipboard. Use Ctrl+v to paste, or right-click and select Paste in your window of choice.]','Copy of Horizon Text')
	; --------------------------------------------------------------------------------
	return text
}

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
	hCtl := ControlGetFocus('A')
	; --------------------------------------------------------------------------------
	Static Msg := WM_PASTE := 770, wParam := 0, lParam := 0
	; --------------------------------------------------------------------------------
	DllCall('SendMessage', 'Ptr', hCtl, 'UInt', Msg, 'UInt', wParam, 'UIntP', lParam)
	; --------------------------------------------------------------------------------
	return
}
; -------------------------------------------------------------------------------------------------

/************************************************************************
 * Desc ......:  Call the Horizon msvb_lib_toolbar buttons using the button() function
 * @author ....: Descolada, OvercastBTC
 * @function button()
 * @param A_ThisHotkey - AHK's built in variable.
***********************************************************************/
; -------------------------------------------------------------------------------------------------
button(idCommand:=0)
{
	SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
	BlockInput(1) ; 1 = On, 0 = Off
	try
		fCtl := ControlGetClassNN(ControlGetFocus('A'))
		bID := SubStr(fCtl, -1, 1)
		nCtl := "msvb_lib_toolbar" bID
	hTb := ControlGethWnd(nCtl, "A")
	idBtn := idButton(A_ThisHotkey)
	try
		pID := WinGetPID(hTb)
	try
		hTx := ControlGethWnd(fCtl, "A")
	hToolbar := hTb
	try (idCommand < 100) ?	idCommand := ((idBtn + 100)-1) : idCommand := idCommand
	btnstate := GETBUTTONSTATE(idCommand,hTb)
	try {
		if (btnstate = 4) || (btnstate = 6)
			HznButton(hTb,idBtn,nCtl, idCommand)
	} catch Error as e {
		OutputDebug('return`nbtnstate: ' btnstate)
		return
	}
	
	SendLevel(0)
	BlockInput(0) ; 1 = On, 0 = Off
	return
}
; --------------------------------------------------------------------------------
/*
button_alt(idCommand:=0)
{
	SendLevel(5)
	BlockInput(1) ; 1 = On, 0 = Off
	try fCtl := ControlGetClassNN(ControlGetFocus('A'))
	bID := SubStr(fCtl, -1, 1)
	nCtl := "msvb_lib_toolbar" bID
	hTb := ControlGethWnd(nCtl, "A")
	; try pID := WinGetPID(hTb)
	try hTx := ControlGethWnd(fCtl, "A")
	idBtn := idButton(A_ThisHotkey)
	; try HznButton(hTb, idBtn, nCtl)
	hToolbar := hTb
	; hpRemote := hp_Remote(pid)
	; hpRemote := hp_Remote(hTb)
	; Is32bit := Win32_64_Bit(&hpRemote)
	; remote_buffer := RemoteBuffer(hpRemote, Is32bit)
	; b := GETBUTTON(idBtn,hTb,pid, hpRemote)
	; b := GETBUTTON(idBtn,hTb,hTb, hpRemote)
	; ; --------------------------------------------------------------------------------
	; ; Step: count and load all the msvb_lib_toolbar buttons into memory
	; ; --------------------------------------------------------------------------------
	; Static Msg := TB_BUTTONCOUNT := 1048, wParam := 0, lParam := 0, control := hTb
	; BUTTONCOUNT := SendMessage(TB_BUTTONCOUNT, wParam, lParam, control, hTb)
	; ; --------------------------------------------------------------------------------
	try (idCommand < 100) ?	idCommand := ((idBtn + 100)-1) : idCommand := idCommand

	btnstate := GETBUTTONSTATE(idCommand,hTb)


	If (!btnstate = 4) || (!btnstate = 6) ; note: (AJB - 09/2023) verified
		{
			OutputDebug('return`nbtnstate: ' btnstate)
			return
		}
	; try 
	; 	CommandButton(idCommand, hTb)
	; try b = 1 ? b:= 'Success!!! You were able to get the button.`nIs your name Dr. Awesome???' : b:= 'Epic failure!!! Try harder next time.'
	; OutputDebug( ''
	; ; MsgBox( '' . ''
	; 		. 'idBtn: ' idBtn '`n'
	; 		; .  b '`n'
	; 		. '1: ' idCommand '`n'
	; 		. '2: ' idCommand '`n'
	; 	)	
	HznButton(hTb,idBtn,nCtl)
	SendLevel(0)
	BlockInput(0) ; 1 = On, 0 = Off
	return
}
*/
; --------------------------------------------------------------------------------
idButton(n)
{
	idBtn:= (n = "^b") ? 1 : 	;.........: bold = 1 (n = 1)(id = 100) (idx = 0)
			(n = "^i") ? 2 : 	;.........: italic = 2 (n = 2)(id = 101)(idx = 1)
			(n = "^u") ? 3 : 0 	; 
; 9 = not ASUS monitor, 10 = ASUS monitor........: (AJB - 08/2023) FE Notepad, Comments, and COPE => u = 10; 3 worked somewhere?
; :  A_ThisHotkey = "^x" ? 11 ; ........: cut = 11 and 12
; :  A_ThisHotkey = "^c" ? 13 ; ........: copy
; :  A_ThisHotkey = "^v" ? 16 ; ........: paste
; :  A_ThisHotkey = "^z" ? 17 ; ........: undo = 17 and 18
; :  A_ThisHotkey = "^y" ? 20 : 21 ; ...: redo
	OutputDebug('idBtn: ' idBtn '`n')
	return idBtn
}
; -------------------------------------------------------------------------------------------------
/************************************************************************
 * Desc:  Clicks the nth item in a Win32 application toolbar.
 * @author ......: Descolada, OvercastBTC
 * Function .....: HznButton()
 * @param hToolbar - The handle of the toolbar control.
 * @param hTb - The handle of the toolbar control.
 * @param fCtl* - [OPTIONAL] The ClassNN of the "focused" control.
 * @param bID - The ClassNN instance of the "focused" control.
 * @param nCtl - The ClassNN and instance of the toolbar control.
 * @param n - The index (hIDx) of the toolbar item to click (1-based). Note: Separators are considered items as well.
 * @param HznButton(hToolbar, n, nCtl, fCtl:=0, hTx:=0, bID:=0)
 * @param param:=0 => in AHK v2 => optional
 * @example
 * fCtl := ControlGetClassNN(ControlGetFocus("A"))
 * bID := SubStr(fCtl, -1, 1)
 * nCtl := "msvb_lib_toolbar" bID
 * hTb := ControlGethWnd(nCtl, "A")
 * hTx := ControlGethWnd(fCtl, "A")
 * HznButton(hToolbar, 3) ; Clicks the third item
 ***********************************************************************/
; --------------------------------------------------------------------------------

HznButton(hToolbar, n, nCtl, idCommand:=0, fCtl:='', hTx:=0, bID:=0) {
	; --------------------------------------------------------------------------------
	; Step: [OPTIONAL] Block all input while the function running
	; --------------------------------------------------------------------------------
	BlockInput(1) ; 1 = On, 0 = Off
	; --------------------------------------------------------------------------------
	Static WM_COMMAND			:= 273 ; 0x111
	Static TB_PRESSBUTTON		:= 1027 ; 0x403
	Static TB_GETBUTTON    		:= 1047 ; 0x417,
	Static TB_GETITEMRECT  		:= 1053 ; 0x41D,
	Static MEM_COMMIT      		:= 4096 ; 0x1000, ; 0x00001000, ; via MSDN Win32 
	Static MEM_RESERVE     		:= 8192 ; 0x2000, ; 0x00002000, ; via MSDN Win32
	Static MEM_PHYSICAL    		:= 4 ; 0x04    ; 0x00400000, ; via MSDN Win32
	Static MEM_PROTECT     		:= 64 ; 0x40 ;  
	Static MEM_RELEASE     		:= 32768 ; 0x8000 ; 
	Static WM_USER				:= 1024 ; 0x400
	Static TB_GETSTATE			:= 1042
	Static TB_GETSTATE			:= WM_USER+18 ; (1042)
	Static TB_GETBITMAP			:= 1068
	Static TB_GETBITMAP			:= WM_USER+44 ; (1068)
	Static TB_GETBUTTONSIZE		:= 1082
	Static TB_GETBUTTONSIZE		:= WM_USER+58 ; 1082
	Static TB_GETBUTTON			:= 1047
	Static TB_GETBUTTON			:= WM_USER+23 ; 1047
	Static TB_GETITEMRECT		:= 1053
	Static TB_GETITEMRECT		:= WM_USER+29 ; (1053)
	Static TB_BUTTONCOUNT  		:= 1048 ; 0x0418
	Static TB_COMMANDTOINDEX	:= 1049
	; --------------------------------------------------------------------------------

	; --------------------------------------------------------------------------------
	; idCommand := ((n + 100)-1)
	try (idCommand < 100) ?	idCommand := ((n + 100)-1) : idCommand := idCommand
	; --------------------------------------------------------------------------------
	btnstate := GETBUTTONSTATE(idCommand,hToolbar)

	If (!btnstate = 4) || (!btnstate = 6) ; note: (AJB - 09/2023) verified
		{
			OutputDebug("Return")
			return
		}
	; --------------------------------------------------------------------------------	

	; --------------------------------------------------------------------------------
	; Step: count and load all the msvb_lib_toolbar buttons into memory
	; --------------------------------------------------------------------------------
	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, , Integer(hToolbar))
	; --------------------------------------------------------------------------------
	; Step: Use the @params to press the button
	; --------------------------------------------------------------------------------
	try if (n >= 1 && n <= buttonCount)
	{
		; --------------------------------------------------------------------------------
		; Step: Get the toolbar "thread" process ID (PID) 
		DllCall("GetWindowThreadProcessId", "Ptr", hToolbar, "UInt*", &targetProcessID:=0)
		; --------------------------------------------------------------------------------
		; Step: Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
        hProcess := DllCall("OpenProcess", "UInt", 0x0018 | 0x0010 | 0x0020, "Int", 0, "UInt", targetProcessID, "Ptr")
		; --------------------------------------------------------------------------------
		; Step: [OPTIONAL] Identify if the process is 32 or 64 bit (efficiency step)
		; --------------------------------------------------------------------------------
		Is32bit := Win32_64_Bit(&hProcess)
		; --------------------------------------------------------------------------------
		; Step: Allocate memory for the TBBUTTON structure in the target process's address space
		; --------------------------------------------------------------------------------
		RPtrSize := Is32bit ? 4 : 8
		TBBUTTON_SIZE := 8 + (RPtrSize * 3) 
		remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", TBBUTTON_SIZE, "UInt", 0x1000, "UInt", MEM_PHYSICAL, "Ptr")
		; --------------------------------------------------------------------------------
		; Step: Get the bounds of each button (Get Item Rectangle)
		; --------------------------------------------------------------------------------
		SendMessage(TB_GETITEMRECT, n-1, remoteMemory,, hToolbar)
		RECT := Buffer(TBBUTTON_SIZE, 0)
		; Note : Winapi TBBUTTON struct(32 bytes on x64, 20 bytes on x86)
		BtnStructSize := Is32bit ? 20 : 32
		BtnStruct := Buffer(BtnStructSize, 0)
		; --------------------------------------------------------------------------------
		; Step: Read the button information stored in the RECT (remoteMemory)
		; --------------------------------------------------------------------------------
        DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory, "Ptr", RECT, "UPtr", BtnStructSize, "UInt*", &bytesRead:=0, "Int")
        DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", remoteMemory, "UPtr", 0, "UInt", 0x8000)
        DllCall("CloseHandle", "Ptr", hProcess)
		; --------------------------------------------------------------------------------
		; Step: Store previous and set min delay
		; --------------------------------------------------------------------------------
		prevDelay := A_ControlDelay
		prevMDelay := A_MouseDelay
		prevWDelay := A_WinDelay
		SetControlDelay(-1)
		SetMouseDelay(-1)
		SetWinDelay(-1)
		; ; --------------------------------------------------------------------------------
		Left 	:= NumGet(RECT, 0, 	"Int")
		Top 	:= NumGet(RECT, 4, 	"Int")
		Right 	:= NumGet(RECT, 8, 	"Int")
		Bottom 	:= NumGet(RECT, 12, "Int")
		; --------------------------------------------------------------------------------
		; Note: Updated 09.11.23
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
		; OutputDebug('X1:' X1 . ' ' . 'Y1:' . Y1 .  ' ' . 'W1:' . W1 . ' ' . 'H1:' . H1 . '`n'
		; 	. 'W:' . W . " " . 'H:' . H . '`n'
		; 	. 'X2:' X2 . ' ' . 'Y2:' . Y2 . '`n'
		; 	. 'X:' . X . ' ' . 'Y:' . Y . '`n'
		; 	)

		/**
		 * @function ControlClick() .: => ahk v2 builtin function
		 * @param X .................: Specific monitor DPI adjusted X value
		 * @param Y .................: Specific monitor DPI adjusted Y value
		 * @param hToolbar ..........: the handle (hwnd) to the toolbar
		 * @param DPI ...............: This function has been per monitor DPI adjusted
		 */
		; ControlClick('x' X ' y' Y, hToolbar,,,, 'NA')
		; --------------------------------------------------------------------------------
		/**
		 * @function SendMessage()
		 * @param Msg := WM_COMMAND
		 * @param wParam_hi := control defined notification code = not needed here => := 0
		 * @param wParam_lo := control identifier => idCommand from above
		 * @param lParam 	:= handle to the control => hToolbar
		 */
		Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hToolbar
		SendMessage(Msg, wParam_hi | wParam_lo,lParam,, hToolbar)
		; --------------------------------------------------------------------------------
		; Step: Restore previous and set delay
		; --------------------------------------------------------------------------------
        ; SetControlDelay(prevDelay)
		; SetMouseDelay(prevMDelay)
		; SetWinDelay(prevWDelay)
		; --------------------------------------------------------------------------------
		OutputDebug(  'ButtonCount: ' buttonCount '`n'
					. 'pID: ' targetProcessID '`n'
					. 'remoteMemory: ' remoteMemory '`n'
					. 'hProcess: ' hProcess '`n'
					. 'bytesRead: ' bytesRead '`n'
					. 'btnstate: ' btnstate '`n'
												)
		; --------------------------------------------------------------------------------
		BlockInput(0) ; 1 = On, 0 = Off
		; --------------------------------------------------------------------------------
    } catch
        throw ValueError("The specified toolbar " nCtl " was not found. Please ensure the edit field has been selected and try again.", -1)
    Return 0
}
; --------------------------------------------------------------------------------
HznButton_DPI(hToolbar, n, nCtl, idCommand:=0, fCtl:='', hTx:=0, bID:=0) {
	; --------------------------------------------------------------------------------
	; Step: [OPTIONAL] Block all input while the function running
	; --------------------------------------------------------------------------------
	BlockInput(1) ; 1 = On, 0 = Off
	; --------------------------------------------------------------------------------
	Static WM_COMMAND			:= 273 ; 0x111
	Static TB_PRESSBUTTON		:= 1027 ; 0x403
	Static TB_GETBUTTON    		:= 1047 ; 0x417,
	Static TB_GETITEMRECT  		:= 1053 ; 0x41D,
	Static MEM_COMMIT      		:= 4096 ; 0x1000, ; 0x00001000, ; via MSDN Win32 
	Static MEM_RESERVE     		:= 8192 ; 0x2000, ; 0x00002000, ; via MSDN Win32
	Static MEM_PHYSICAL    		:= 4 ; 0x04    ; 0x00400000, ; via MSDN Win32
	Static MEM_PROTECT     		:= 64 ; 0x40 ;  
	Static MEM_RELEASE     		:= 32768 ; 0x8000 ; 
	Static WM_USER				:= 1024 ; 0x400
	Static TB_GETSTATE			:= 1042
	Static TB_GETSTATE			:= WM_USER+18 ; (1042)
	Static TB_GETBITMAP			:= 1068
	Static TB_GETBITMAP			:= WM_USER+44 ; (1068)
	Static TB_GETBUTTONSIZE		:= 1082
	Static TB_GETBUTTONSIZE		:= WM_USER+58 ; 1082
	Static TB_GETBUTTON			:= 1047
	Static TB_GETBUTTON			:= WM_USER+23 ; 1047
	Static TB_GETITEMRECT		:= 1053
	Static TB_GETITEMRECT		:= WM_USER+29 ; (1053)
	Static TB_BUTTONCOUNT  		:= 1048 ; 0x0418
	Static TB_COMMANDTOINDEX	:= 1049
	; --------------------------------------------------------------------------------

	; --------------------------------------------------------------------------------
	; idCommand := ((n + 100)-1)
	try (idCommand < 100) ?	idCommand := ((n + 100)-1) : idCommand := idCommand
	; --------------------------------------------------------------------------------
	btnstate := GETBUTTONSTATE(idCommand,hToolbar)

	If (!btnstate = 4) || (!btnstate = 6) ; note: (AJB - 09/2023) verified
		{
			OutputDebug("Return")
			return
		}
	; --------------------------------------------------------------------------------	
	; --------------------------------------------------------------------------------
	; try nmHwnd 	:= GetNearestMonitorInfo('A').Handle
	; try nmName 	:= GetNearestMonitorInfo('A').Name
	; try nmNum 	:= GetNearestMonitorInfo('A').Number
	; try nmPri 	:= GetNearestMonitorInfo('A').Primary
	; try mDPIx 	:= GetNearestMonitorInfo('A').x
	; try mDPIy 	:= GetNearestMonitorInfo('A').y
	; try mDPIw 	:= GetNearestMonitorInfo('A').WinDPI
	try DPImw 	:= DPI.GetForWindow('A')
	try DPIsc 	:= DPI.GetScaleFactor(DPImw)
	; try DPIsc1 	:= DPI.GetScaleFactor(mDPIx)
	; --------------------------------------------------------------------------------
	; OutputDebug('nmHwnd: '	nmHwnd '`n'
	; 		.	'nmName: '	nmName '`n'
	; 		.	'nmNum: '	nmNum '`n'
	; 		.	'nmPri: '	nmPri '`n'
	; 		.	'mDPIx: '	mDPIx '`n'
	; 		.	'mDPIy: '	mDPIy '`n'
	; 		.	'mDPIw: '	mDPIw '`n'
	; 		.	'DPImw: '	DPImw '`n'
	; 		.	'DPIsc: '	DPIsc '`n'
	; 		.	'DPIsc1: '	DPIsc1 '`n'
	; 		; .	'Scale1: '	scale1 '`n'
	; 		; .	'Scale2: '	scale2 '`n'
	; 		; .	'Scale3: '	scale3 '`n'
	; 		.	'PriDPI: '	A_ScreenDPI '`n'
	; 	)
	; --------------------------------------------------------------------------------
	; Step: count and load all the msvb_lib_toolbar buttons into memory
	; --------------------------------------------------------------------------------
	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, , Integer(hToolbar))
	; --------------------------------------------------------------------------------
	; Step: Use the @params to press the button
	; --------------------------------------------------------------------------------
	try if (n >= 1 && n <= buttonCount)
	{
		; --------------------------------------------------------------------------------
		; Step: Get the toolbar "thread" process ID (PID) 
		DllCall("GetWindowThreadProcessId", "Ptr", hToolbar, "UInt*", &targetProcessID:=0)
		; --------------------------------------------------------------------------------
		; Step: Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
        hProcess := DllCall("OpenProcess", "UInt", 0x0018 | 0x0010 | 0x0020, "Int", 0, "UInt", targetProcessID, "Ptr")
		; --------------------------------------------------------------------------------
		; Step: [OPTIONAL] Identify if the process is 32 or 64 bit (efficiency step)
		; --------------------------------------------------------------------------------
		Is32bit := Win32_64_Bit(&hProcess)
		; --------------------------------------------------------------------------------
		; Step: Allocate memory for the TBBUTTON structure in the target process's address space
		; --------------------------------------------------------------------------------
		RPtrSize := Is32bit ? 4 : 8
		TBBUTTON_SIZE := 8 + (RPtrSize * 3) 
		remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", TBBUTTON_SIZE, "UInt", 0x1000, "UInt", MEM_PHYSICAL, "Ptr")
		; --------------------------------------------------------------------------------
		; Step: Get the bounds of each button (Get Item Rectangle)
		; --------------------------------------------------------------------------------
		SendMessage(TB_GETITEMRECT, n-1, remoteMemory,, hToolbar)
		RECT := Buffer(TBBUTTON_SIZE, 0)
		; Note : Winapi TBBUTTON struct(32 bytes on x64, 20 bytes on x86)
		BtnStructSize := Is32bit ? 20 : 32
		BtnStruct := Buffer(BtnStructSize, 0)
		; --------------------------------------------------------------------------------
		; Step: Read the button information stored in the RECT (remoteMemory)
		; --------------------------------------------------------------------------------
        DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory, "Ptr", RECT, "UPtr", BtnStructSize, "UInt*", &bytesRead:=0, "Int")
        DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", remoteMemory, "UPtr", 0, "UInt", 0x8000)
        DllCall("CloseHandle", "Ptr", hProcess)
		; --------------------------------------------------------------------------------
		; Step: Store previous and set min delay
		; --------------------------------------------------------------------------------
		prevDelay := A_ControlDelay
		prevMDelay := A_MouseDelay
		prevWDelay := A_WinDelay
		SetControlDelay(-1)
		SetMouseDelay(-1)
		SetWinDelay(-1)
		; ; --------------------------------------------------------------------------------
		Left 	:= NumGet(RECT, 0, 	"Int")
		Top 	:= NumGet(RECT, 4, 	"Int")
		Right 	:= NumGet(RECT, 8, 	"Int")
		Bottom 	:= NumGet(RECT, 12, "Int")
		; --------------------------------------------------------------------------------
		; Note: Updated 09.11.23
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
		; OutputDebug('X1:' X1 . ' ' . 'Y1:' . Y1 .  ' ' . 'W1:' . W1 . ' ' . 'H1:' . H1 . '`n'
		; 	. 'W:' . W . " " . 'H:' . H . '`n'
		; 	. 'X2:' X2 . ' ' . 'Y2:' . Y2 . '`n'
		; 	. 'X:' . X . ' ' . 'Y:' . Y . '`n'
		; 	)

		/**
		 * @function ControlClick() .: => ahk v2 builtin function
		 * @param X .................: Specific monitor DPI adjusted X value
		 * @param Y .................: Specific monitor DPI adjusted Y value
		 * @param hToolbar ..........: the handle (hwnd) to the toolbar
		 * @param DPI ...............: This function has been per monitor DPI adjusted
		 */
		; ControlClick('x' X ' y' Y, hToolbar,,,, 'NA')
		; --------------------------------------------------------------------------------
		/**
		 * @function SendMessage()
		 * @param Msg := WM_COMMAND
		 * @param wParam_hi := control defined notification code = not needed here => := 0
		 * @param wParam_lo := control identifier => idCommand from above
		 * @param lParam 	:= handle to the control => hToolbar
		 */
		Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hToolbar
		SendMessage(Msg, wParam_hi | wParam_lo,lParam,, hToolbar)
		; --------------------------------------------------------------------------------
		; Step: Restore previous and set delay
		; --------------------------------------------------------------------------------
        ; SetControlDelay(prevDelay)
		; SetMouseDelay(prevMDelay)
		; SetWinDelay(prevWDelay)
		; --------------------------------------------------------------------------------
		OutputDebug(  'ButtonCount: ' buttonCount '`n'
					. 'pID: ' targetProcessID '`n'
					. 'remoteMemory: ' remoteMemory '`n'
					. 'hProcess: ' hProcess '`n'
					. 'bytesRead: ' bytesRead '`n'
					. 'btnstate: ' btnstate '`n'
												)
		; --------------------------------------------------------------------------------
		BlockInput(0) ; 1 = On, 0 = Off
		; --------------------------------------------------------------------------------
    } catch
        throw ValueError("The specified toolbar " nCtl " was not found. Please ensure the edit field has been selected and try again.", -1)
    Return 0
}
HznDPI()
{
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
		DPIsc1 	:= DPI.GetScaleFactor(mDPIx)
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
				.	'DPIsc1: '	DPIsc1 '`n'
				.	'PriDPI: '	A_ScreenDPI '`n'
				)
	}	
	; --------------------------------------------------------------------------------
	return DPIsc
}
; --------------------------------------------------------------------------------
/**
 * @function COMMANDBUTTON()
 * @param idCommand := the TB_COMMANDTOINDEX (100 based) of the called button
 * @param Msg := WM_COMMAND
 * @param wParam_hi := control defined notification code = not needed here => := 0
 * @param wParam_lo := control identifier => idCommand from above
 * @param lParam 	:= handle to the control => hToolbar
 */

COMMANDBUTTON(idCommand, hTb)
{
	Static WM_COMMAND := 273 ; hex = 0x111
	Static hToolbar := hTb
	Static Msg := WM_COMMAND, wParam_hi := 0, wParam_lo := idCommand, lParam := control := hToolbar
	SendMessage(Msg, wParam_hi | wParam_lo,lParam,, hToolbar)
	; --------------------------------------------------------------------------------
}
; --------------------------------------------------------------------------------
GETBUTTON(n, hTb, pID?, hpRemote?)
{
	Static 	TB_GETBUTTON := 1047 ; hex = 0x417
	Static ctrlhwnd := hTb
	OutputDebug('n: ' n '`n')
	pID := WinGetPID(hTb)
	hpRemote = 0 ? hpRemote := hp_Remote(pID) : hpRemote := hpRemote
	remote_buffer := RemoteBuffer(hpRemote)
	GETBUTTON := SendMessage(TB_GETBUTTON, n-1, remote_buffer, ctrlhwnd, ctrlhwnd)
	return GETBUTTON
}
; --------------------------------------------------------------------------------
GETBUTTONSTATE(idButton,hTb)
{
	Static TB_GETSTATE := 0x0412
	GETSTATE := SendMessage(TB_GETSTATE, idButton, 0, hTb, hTb)
	btnstate := SubStr(GETSTATE,1,1)
	If (btnstate = 4) || (btnstate = 6){
		return btnstate
	}
	btnname := idButton = 100 ? 'Bold' : idButton = 101 ? 'Italic' : idButton = 102 ? 'Underline' : ''
	MsgBox(   'The ' btnname
			. ' button is not available.' '`n'
			. 'idButton: ' idButton '`n'
			. 'btnstate: ' btnstate)
	OutputDebug("btnstate: " . btnstate . "`n")
	return btnstate
}
; --------------------------------------------------------------------------------
ReadRemoteBuffer(hpRemote, RemoteBuffer, &LocalVar, bytes) {
	DllCall("ReadProcessMemory", "Ptr", hpRemote, "Ptr", RemoteBuffer, "Ptr", LocalVar, "UInt", bytes, "UInt", 0)

}
; --------------------------------------------------------------------------------
Win32_64_Bit(&hpRemote)
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
RemoteBuffer(hpRemote, Is32bit:=0)
{
	Static 	MEM_PHYSICAL := 4 ; 0x04    ; 0x00400000, ; via MSDN Win32
	if (!Is32bit)
		A_Is64bitOS = 1 ? RPtrSize := 8 : RPtrSize := 4
	TBBUTTON_SIZE := 8 + (RPtrSize * 3)
	remote_buffer := DllCall("VirtualAllocEx", "Ptr", hpRemote, "Ptr", 0, "UPtr", TBBUTTON_SIZE, "UInt", 0x1000, "UInt", MEM_PHYSICAL, "Ptr")
	return remote_buffer
}
; --------------------------------------------------------------------------------
hp_Remote(pid_target)
{
	; Step: Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
	hpRemote := DllCall("OpenProcess", "UInt", 0x0018 | 0x0010 | 0x0020, "Int", 0, "UInt", pid_target, "Ptr")
	; hpRemote: Remote process handle
	if(!hpRemote)
	{
		Throw ("Autohotkey: Cannot OpenProcess(pid=" . pid_target . ")")
		return
	}
	return hpRemote
}
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
Startup_Shortcut := A_Startup "\" A_ScriptName ".lnk"
; Startup_Shortcut := A_Startup "\" A_ScriptName
If !(FileExist(Startup_Shortcut))
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

/**
 * Clicks the nth item in a Win32 application toolbar.
 * @param hWndToolbar - The handle of the toolbar control.
 * @param n - The index of the toolbar item to click (1-based). Note: Separators are considered items as well.
 * @example
 * ControlGet, hToolbar, hWnd,, ToolbarWindow321, Test ; Replace with the actual ClassNN and WinTitle
 * ClickToolbarItem(hToolbar, 3) ; Clicks the third item
 */
#HotIf WinActive('ahk_exe Hznhorizon.exe') && WinActive(A_ScriptName)
^#c::
{
	; fCtl := ControlGetClassNN(ControlGetFocus("A"))
	fCtl := '#32768'
	; bID := SubStr(fCtl, -1, 1)
	; nCtl := "ThunderRT6FormDC" bID
	nCtl := "Main"
	hTb := ControlGethWnd(nCtl, "A")
	hTx := ControlGethWnd(fCtl, "A")
	OutputDebug(  fCtl '`n'
				; . bID '`n'
				. nCtl '`n'
				. hTb '`n'
				. hTx '`n')
	ClickToolbarItem(hTb,1)
	return
}
#hotif
ClickToolbarItem(hWndToolbar, n) {
    static TB_BUTTONCOUNT := 0x418, TB_GETBUTTON := 0x417, WM_COMMAND := 0x111
    buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0, , hWndToolbar)
    if (n >= 1 && n <= buttonCount) {
        DllCall("GetWindowThreadProcessId", "Ptr", hWndToolbar, "UInt*", &targetProcessID:=0)
        ; Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
        hProcess := DllCall("OpenProcess", "UInt", 0x0018 | 0x0010 | 0x0020, "Int", 0, "UInt", targetProcessID, "Ptr")
        ; Allocate memory for the TBBUTTON structure in the target process's address space
        remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", 32, "UInt", 0x1000, "UInt", 0x04, "Ptr")
        SendMessage(TB_GETBUTTON, n-1, remoteMemory, , hWndToolbar)
        DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory+4, "Int*", &idCommand:=0, "UPtr", 4, "UInt*", &bytesRead:=0, "Int")
        DllCall("VirtualFreeEx", "Ptr", hProcess, "Ptr", remoteMemory, "UPtr", 0, "UInt", 0x8000)
        DllCall("CloseHandle", "Ptr", hProcess)
        SendMessage(WM_COMMAND, idCommand,hwndtoolbar,, hwndToolbar)
    } else
        throw ValueError("The specified index " n " is out of range. Please specify a valid index between 1 and " buttonCount ".", -1)
    return
}
; --------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe hznhorizon.exe")
; --------------------------------------------------------------------------------------------------
/**
@SubSection .....: Horizon {Enter} ==> Select Option
@Description ....: Hotkeys (shortcuts) sending {Enter} in leu of "Double Click"
@Author OvercastBTC
; [ ] fix: .........: Still doesn't work. Might have to not use the WinActive() function
*/
; --------------------------------------------------------------------------------------------------
#HotIf WinActive("ahk_exe hznhorizonmgr.exe") or WinActive("ahk_exe hznhorizon.exe")
{
	fCtl := ControlGetClassNN(ControlGetFocus("A"))
	hCtl := ControlGethWnd(fCtl, "A")
	; Shift & Enter::DllCall("PostMessage", "Ptr", &hCtl, "UInt", 0x0203, "Ptr", 0, "Ptr", 0)
	Shift & Enter::DllCall("PostMessage", "Str", &hCtl, "UInt", 0x0203, "Ptr", 0, "Ptr", 0)
}
return
#HotIf
; --------------------------------------------------------------------------------
/************************************************************************
 * Desc ......:  Create the .ico file for use in as the Tray Icon
 * @author 2.0.00.00 - 2023-07-31 - iPhilip - converted script to AutoHotkey v2
 * @function Create_HznHorizon_ico()
 * @param B64 - A picture converted to a string and encoded via b64
 * @forum ;-> https://www.autohotkey.com/boards/viewtopic.php?f=83&t=119966
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