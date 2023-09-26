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
_PerMonitor_DPIAwareness()
_PerMonitor_DPIAwareness(&DefaultDpiAwarenessContext?)
{
	MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, ">=10.0.15063") ? -4 : -3
	DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext
	try
		DllCall("SetThreadDpiAwarenessContext", "ptr", MaximumPerMonitorDpiAwarenessContext, "ptr")
	catch 
		DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
	else
		DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
	return DefaultDpiAwarenessContext
}	
; --------------------------------------------------------------------------------
; #Include <gdi_plus_plus>
; #Include <Gdip_All>
; #Include <Class_Toolbar.c2v2>
; #Include <Tools\Hider>
; #Include <Lib.v2\UIA>
#Include <EnumAllMonitorsDPI.v2>
#Include <DPI>
#Include <GetNearestMonitorInfo().v2>
; #Include <Abstractions\Script>

; --------------------------------------------------------------------------------
#HotIf WinActive(A_ScriptName " - Visual Studio Code")
~^s::Run(A_ScriptName)
#HotIf
; --------------------------------------------------------------------------------
^+7::
{
	HznTb:=__Toolbar_ExistNew(&hTb)
	; toolbar_info := DisplayObj(HznTb)
	GETBUTTON := Toolbar_GetButton(hTb,101)
	; MsgBox(toolbar_info)
	MsgBox(GETBUTTON)

}	
; --------------------------------------------------------------------------------
/* Title:    Toolbar
			Toolbar control.
			(see toolbar.png)
			The module is designed with following goals in mind :
			* To allow programmers to quickly create toolbars in intuitive way.
			* To allow advanced (non-typical) use, such as dynamic toolbar creation in such way that it doesn't complicate typical toolbar usage.
			* To allow users to customize toolbar and programmer to save changed toolbar state.
			* Not to have any side effects on your script.

*/
; --------------------------------------------------------------------------------
/* 
Function:  Add
		Add a Toolbar to the GUI

Parameters:
			hGui		- HWND of the GUI. GUI must have defined size.
			Handler		- User function that handles Toolbar events. See below.
			Style		- Styles to apply to the toolbar control, see list of styles bellow.
			ImageList	- Handle of the image list that contains button images. Otherwise it specifies number and icon size of the one of the 3 system catalogs (see Toolbar_catalogs.png). Each catalog contains number of common icons in large and small size -- S or L (default). Defaults to "1L" (first catalog, large icons)
			Pos			- Position of the toolbar specified - any space separated combination of the x y w h keywords followed by the size.

Control Styles:
			adjustable	- Allows users to change a toolbar button's position by dragging it while holding down the SHIFT key and to open customization dialog by double clicking Toolbar empty area, or separator.
			border		- Creates a Toolbar that has a thin-line border.
			bottom		- Causes the control to position itself at the bottom of the parent window's client area.
			flat		- Creates a flat toolbar. In a flat toolbar, both the toolbar and the buttons are transparent and hot-tracking is enabled. Button text appears under button bitmaps. To prevent repainting problems, this style should be set before the toolbar control becomes visible.
			list		- Creates a flat toolbar with button text to the right of the bitmap. Otherwise, this style is identical to FLAT style. To prevent repainting problems, this style should be set before the toolbar control becomes visible.
			tooltips	- Creates a ToolTip control that an application can use to display descriptive text for the buttons in the toolbar.
			nodivider	- Prevents a two-pixel highlight from being drawn at the top of the control.
			tabstop		- Specifies that a control can receive the keyboard focus when the user presses the TAB key.
			wrapable	- Creates a toolbar that can have multiple lines of buttons. Toolbar buttons can "wrap" to the next line when the toolbar becomes too narrow to include all buttons on the same line. When the toolbar is wrapped, the break will occur on either the rightmost separator or the rightmost button if there are no separators on the bar. This style must be set to display a vertical toolbar control when the toolbar is part of a vertical rebar control.
			vertical	- Creates vertical toolbar.
			menu		- Creates a toolbar that simulates Windows menu.

Handler:

> Handler(hTb, Event, Txt, Pos, Id)

			Ctrl	- Handle of the Toolbar that sends the message.
			Event	- Event name. See bellow.
			Txt		- Button caption.
			Pos		- Button position.
			Id		- Button ID.

Events:
			click	- User has clicked on the button. 
			rclick  - User has clicked the right button.
			menu	- User has clicked on the dropdown icon.
			hot		- User is hovering the button with the mouse.
			change	- User has dragged the button using SHIFT + drag.			
			adjust	- User has finished customizing the toolbar.

Returns: 
			Control's handle or error message.


Remarks:
			To avoid lost messages and/or script lockup, events triggered by the toolbar buttons should complete quickly. 
			If an event takes more than a few milliseconds to complete, consider creating an independent thread to accomplish the task:

(start code)
			if event=click
				if button=BigFatRoutine 
				{ 
					SetTimer MyBigFatRoutine,0 
					return 
				}
(end code)

			If you happen to have unusual control behavior - missing events, redrawing issues etc... try adding _Critical_ command (or better Critical N) at the start of the Toolbar_onNotify function.
			It helps to improve the odds that no messages are dropped. The drawback of using the command is that the function refuses to be interrupted. 
			This is not a problem if the developer is very careful not to call any routines or functions that use anything more than a few milliseconds. 
			However, any little mistake -- an unexpected menu, prompt, MsgBox, etc., and the script will lock up. 
			Without the Critical command, the function is a lot more forgiving. 
			The developer should still be careful but the script won't shut down if something unexpected happens.
 */

__Toolbar_ExistNew(&hCtl?, &fCtl?, &fCtlInstance?, &nCtl?, &hTb?, &hTx?, &pID?, &targetProcessID?)
{
	SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
	BlockInput(1) ; 1 = On, 0 = Off
	arrTb := Array()
	try
		hCtl := ControlGetFocus('A')
		fCtl := ControlGetClassNN(hCtl)
		fCtlInstance := SubStr(fCtl, -1, 1)
		nCtl := "msvb_lib_toolbar" fCtlInstance
		hTb := ControlGethWnd(nCtl, "A")
		hTx := ControlGethWnd(fCtl, "A")
		pID := WinGetPID(hTb)
		DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &targetProcessID:=0)
	BlockInput(0) ; 1 = On, 0 = Off	
	SendLevel(0) ; SendLevel higher than anything else (normally highest is 1)
	arrTb.Push (
		{  	  Control_Handle:hCtl
			, FocusedControlClass:fCtl
			, FocusedControlInstance:fCtlInstance
			, Name_Toolbar:nCtl
			, Toolbar_Handle:hTb
			, Textbox_Handle:hTx
			, WinGetPID:pID
			, GetWinThreadpID:targetProcessID
		}		)
	OutputDebug(hCtl '`n'
			. fCtl '`n'
			. fCtlInstance '`n'
			. nCtl '`n'
			. hTb '`n'
			. hTx '`n'
			. pID '`n'
			. targetProcessID '`n'
			)
	toolbar_info := DisplayObj(arrTb)
	OutputDebug(toolbar_info)

	return arrTb
}
DisplayObj(Obj, Depth:=10, IndentLevel:="")
{
	if Type(Obj) = "Object"
		Obj := Obj.OwnProps()
	for k,v in Obj
	{
		List.= IndentLevel "[" k "]"
		if (IsObject(v) && Depth>1)
			List.="`n" DisplayObj(v, Depth-1, IndentLevel . "    ")
		Else
			List.=" => " v
		List.="`n"
	}
	return RTrim(List)
}					
Toolbar_Add(hGui, Handler, Style:="", ImageList:="", Pos:="")
{
	static    MODULEID
	static 	  WS_CHILD := 0x40000000, WS_VISIBLE := 0x10000000, WS_CLIPSIBLINGS := 0x4000000, WS_CLIPCHILDREN := 0x2000000
			, TBSTYLE_THICKFRAME := 0x40000, TBSTYLE_TABSTOP := 0x10000, TBSTYLE_WRAPABLE := 0x200, TBSTYLE_FLAT := 0x800
			, TBSTYLE_LIST := 0x1000, TBSTYLE_TOOLTIPS := 0x100, TBSTYLE_TRANSPARENT := 0x8000, TBSTYLE_ADJUSTABLE := 0x20
			, TBSTYLE_VERTICAL := 0x80, TBSTYLE_EX_DRAWDDARROWS := 0x1, TBSTYLE_EX_HIDECLIPPEDBUTTONS := 0x10
			, TBSTYLE_EX_MIXEDBUTTONS := 0x8, TB_BUTTONSTRUCTSIZE := 0x41E, TB_SETEXTENDEDSTYLE := 0x454
			, TB_SETUNICODEFORMAT := 0x2005, TBSTYLE_NODIVIDER := 0x40, CCS_NOPARENTALIGN := 0x8, CCS_NORESIZE := 0x4, TBSTYLE_BOTTOM := 0x3
			, TBSTYLE_MENU := 0, TBSTYLE_BORDER := 0x800000, TBSTYLE_EX_DRAWDDARROWS := 0x01, WS_CLIPSIBLINGS := 0x04000000
	
	if !MODULEID
	{ 
		; old := OnMessage(0x4E, Toolbar_onNotify),	MODULEID := 80609
		; if (old != "Toolbar_onNotify")
		; 	Toolbar("oldNotify", CallbackCreate(%old%))
		OnMessage(0x4E, Toolbar_onNotify),	MODULEID := 80609
		if !Toolbar_onNotify
			CallbackCreate('Toolbar_oldNotify')		
	}
	
	Style .= Style:='' ? 'WRAPABLE' : '', ImageList .= ImageList:='' ? '1L' : ''

	hStyle := 0
	hExStyle := TBSTYLE_EX_MIXEDBUTTONS ; TBSTYLE_EX_HIDECLIPPEDBUTTONS
	if bMenu := InStr(Style, "MENU")
		hStyle |= TBSTYLE_FLAT | TBSTYLE_LIST | WS_CLIPSIBLINGS		;set this style only if custom flag MENU is set. It serves only as a mark later
	else hExStyle |= TBSTYLE_EX_DRAWDDARROWS

	Loop Parse, Style, A_Tab "" A_Space, A_Tab "" A_Space
		if (A_LoopField = "")
			continue
		else hStyle |= A_LoopField+0 ? A_LoopField : TBSTYLE_%A_LoopField%

	if (hStyle = "")
		return A_ThisFunc "> Some of the styles are invalid."

	if (Pos != ""){
		x := y := 0, w := h := 100
		Loop Parse, Pos, A_Tab "" A_Space, A_Tab "" A_Space
		{
			if (A_LoopField = "")
				continue
			p := SubStr(A_LoopField, 1, 1)
			if !(p ~= "^(?i:x|y|w|h)$")
				return A_ThisFunc ">  Invalid position specifier"
			%p% := SubStr(A_LoopField, 2)
		}
		hStyle |= CCS_NOPARENTALIGN | TBSTYLE_NODIVIDER | CCS_NORESIZE
	}

    hTb := DllCall("CreateWindowEx", "uint", 0, "str", "ToolbarWindow32", "uint", 0, "uint", WS_CHILD | WS_VISIBLE | WS_CLIPCHILDREN | hStyle, "uint", x, "uint", y, "uint", w, "uint", h, "uint", hGui, "uint", MODULEID, "uint", 0, "uint", 0, "Uint") 
    if (hTb = 0)
		return 0
	
	BUTTONSTRUCTSIZE := SendMessage(TB_BUTTONSTRUCTSIZE, 20, 0, ,  hTb)
	SETEXTENDEDSTYLE := SendMessage(TB_SETEXTENDEDSTYLE, 0, hExStyle, ,  hTb)
	SETUNICODEFORMAT := SendMessage(TB_SETUNICODEFORMAT, 0, 0, ,  hTb)		  ;set to ANSI

	if(ImageList != "")
		Toolbar_SetImageList(hTb, ImageList)
	
	if (Handler)
		Toolbar(hTb "Handler", Handler)
	return hTb 
}

/*
Function:  AutoSize
			Causes a toolbar to be resized.

Parameters:
			Align	 - How toolbar is aligned to its parent. bottom left (bl), bottom right (br), top right (tr), top left (tl) or fit (doesn't reposition control, resizes it so it takes minimum possible space with all buttons visible)	

Remarks:
			An application calls the AutoSize function after causing the size of a toolbar to change either by setting the button or bitmap size or by adding strings for the first time.
*/

; [ ] fix: this needs to be adjusted for DPIScale, and/or is all this stuff needed? => SendMessage(TB_AUTOSIZE....)
Toolbar_AutoSize(hTb, Align:="fit")
{
	Static TB_AUTOSIZE := 0x421, wParam := 0, lParam := 0, control := ''
	if (align != "")
	{
		dhw := A_DetectHiddenWindows
		DetectHiddenWindows(true)
		Toolbar_GetMaxSize(hTb, &w, &h)

		f := SysGet(8)		;SM_CYFIXEDFRAME , Thickness of the frame around the perimeter of a window that has a caption but is not sizable
		c := SysGet(4)		;SM_CYCAPTION: Height of a caption area, in pixels.
		
		hParent := DllCall("GetParent", "uint", hTb)
		WinGetPos(, , &pw, &ph,  hParent)
		if (Align = "fit")
			ControlMove(, , w, h, hTb, hTb)
				else if (Align = "tr")
			ControlMove(pw-w-f, c+f+2, w, h, , hTb)
				else if (Align = "tl")
			ControlMove(f, c+f+2, w, h, , hTb)
				else if (Align = "br")
			ControlMove(pw-w-f, ph-h-f, w, h, ,hTb)
				else if (Align = "bl")
			ControlMove(, ph-h-f, w, h, , hTb)
		DetectHiddenWindows(dhw)
	}
	else
		SendMessage(TB_AUTOSIZE, wParam, lParam, , hTb)
}

/*
Function:  Clear
			Removes all buttons from the toolbar, both current and available
 */
Toolbar_Clear(hTb)
{
	Static TB_AUTOSIZE := 0x421, wParam := 0, lParam := 0, control := '', TB_DELETEBUTTON := 0x416
	Loop Toolbar_Count(hTb)
		SendMessage(TB_DELETEBUTTON, wParam, lParam, , hTb) ; 

	Toolbar_mfree( Toolbar( hTb "aBTN", "" ) )
	SendMessage(TB_AUTOSIZE, wParam, lParam, , hTb)
}

/*
Function:  Count
			Get count of buttons on the toolbar

Parameters:
			pQ			- Query parameter, set to "c" to get the number of current buttons (default)
						- Set to "a" to get the number of available buttons. Set to empty string to return both.

Returns:
			if pQ is empty function returns rational number in the form cntC.cntA otherwise  requested count
 */
Toolbar_Count(hTb, pQ:="c")
{
	static TB_BUTTONCOUNT := 0x418, wParam := 0, lParam := 0, control := ''

	c := SendMessage(TB_BUTTONCOUNT, wParam, lParam, , hTb)
	
	if (pQ = "c")
		return c

	a := NumGet(Toolbar(hTb "aBTN"), "UPtr")
	if (pQ = "a")
		return a

	return c "." a
}

/*
Function:  CommandToIndex
			Retrieves the button position given the ID.
			Initial value is zero based => Make index based >= 1)

Parameters:
			ID	- Button ID, number > 0.

Returns:
			0 if button with that ID doesn't exist, pos > 0 otherwise.
 */

Toolbar_CommandToIndex( hTb, ID )
{
	static TB_COMMANDTOINDEX := 0x419

	COMMANDTOINDEX := SendMessage(TB_COMMANDTOINDEX, ID, , ,  hTb)
	if (COMMANDTOINDEX = 4294967295)
		return 0
	return COMMANDTOINDEX + 1
}

/*
Function:  Customize
			Launches customization dialog
			(see Toolbar_customize.png)
 */
Toolbar_Customize(hTb) {
	static TB_CUSTOMIZE := 0x41B, wParam := 0, lParam := 0, control := ''
	SendMessage(TB_CUSTOMIZE, wParam, lParam,, hTb)
}

/*
Function:  CheckButton
			Get button information

Parameters:
			WhichButtton - One of the ways to identify the button: 1-based button position or button ID.
							If WhichButton is negative, the information about available (*) button on position -WhichButton will be returned.	
			bCheck		 - Set to 1 to check the button (default). 

Returns:
			Returns TRUE if successful, or FALSE otherwise.

Remarks:
			With groupcheck use this function to check button. Using <SetButton> function will not uncheck other buttons in the group.
 */

Toolbar_CheckButton(hTb, WhichButton, bCheck:=1) {
	static TB_CHECKBUTTON := 0x402, TB_GETBUTTON := 0x0417

    if (WhichButton >= 1){
		; VarSetStrCapacity(&TBB, 20) ; V1toV2: if 'TBB' is NOT a UTF-16 string, use 'TBB := Buffer(20)'
		TBB := Buffer(20)
		if (type(TBB)="Buffer")
		{ ;V1toV2 If statement may be removed depending on type parameter
			GETBUTTON := SendMessage(TB_GETBUTTON, --WhichButton, TBB, ,  hTb)
		} else{
			GETBUTTON := SendMessage(TB_GETBUTTON, --WhichButton, StrPtr(TBB), ,  hTb)
		}
		WhichButton := NumGet(&TBB+0, 4)
	} else WhichButton := SubStr(WhichButton, 2)
	SendMessage(TB_CHECKBUTTON, WhichButton, bCheck, ,  hTb)
	; return ; TODO added return. does this need a return?
}

/*
Function:  Define
			Get the toolbar definition list.

Parameters:
			pQ	- Query parameter. Specify "c" to get only current buttons, "a" to get only available buttons.
				- Leave empty to get all buttons.
Returns:
			Button definition list. You can use the list directly with <Insert> function.
 */
Toolbar_Define(hTb, pQ:="") {
	if (pQ != "")
		if !(pQ ~= "^(?i:a|c)$")
			return A_ThisFunc "> Invalid query parameter: " pQ

	if (pQ = "") or (pQ = "c")
		Loop Toolbar_Count(hTb)
			btns .= Toolbar_GetButton(hTb, A_Index) "`n"
	if (pQ = "c")
		return SubStr(btns, 1, -2)

	if (pQ="") or (pQ = "a"){
		if (pQ = "")
			btns := btns "`n"

		cnta := NumGet(Toolbar(hTb "aBTN"), "UPtr")
		Loop cnta
			btns .= Toolbar_GetButton(hTb, -A_Index) "`n"
	
		return SubStr(btns, 1, -2)
	}
}

/*
Function:  DeleteButton
		Delete button from the toolbar.

Parameters:
		Pos		- 1-based position of the button, by default 1.
				- To delete one of the available buttons, specify "*" before the position.

Returns:
		TRUE if successful.
 */
Toolbar_DeleteButton(hTb, Pos:=1)
{
	static TB_DELETEBUTTON := 0x416

	if InStr(Pos, "*") {
		Pos := SubStr(Pos, 2),  aBTN := Toolbar(hTb "aBTN"),  cnta := NumGet(aBTN+0, "UPtr")
		if (Pos > cnta)
			return FALSE
		if (Pos < cnta)
			Toolbar_memmove( aBTN + 20*(Pos-1) +4, aBTN + 20*Pos +4, aBTN + 20*Pos +4)

		NumPut("UPtr", cnta-1, aBTN+0)
		return TRUE
	}
    ; DELETEBUTTON := SendMessage(TB_DELETEBUTTON, Pos-1, , ,  hTb)
	; return DELETEBUTTON
    SendMessage(TB_DELETEBUTTON, Pos-1, , ,  hTb)
	return
}

/*
Function:  GetButton
		Get button information

Parameters:
		WhichButtton 	- One of the ways to identify the button: 1-based button position or button ID.
						- If WhichButton is negative, the information about available (*) button on position -WhichButton will be returned.	
		pQ				- Query parameter, can be C (Caption) I (Icon number), S (State), L (styLe) or ID.
						- If omitted, all information will be returned in the form of button definition.

Returns:
		If pQ is omitted, button definition, otherwise requested button information.

Examples:
(start code)
	s := GetButton(hTb, 3)			;returns button definition for the third button.
	c := GetButton(hTb, 3, "c")	 	;returns only caption of that button.
	d := GetButton(hTb,-2, "id")	;returns only id of the 2nd button from the group of available (*) buttons.
	s := GetButton(hTb, .101, "s")	;returns the state of the button with ID=101.
(end code)
*/
Toolbar_GetButton(hTb, WhichButton, pQ:="") {
	static TB_GETBUTTON := 0x417, TB_GETBUTTONTEXT:=0x42D, TB_GETSTRING:=0x45C, TB_COMMANDTOINDEX:=0x419

	if !isNumber(WhichButton)
		return A_ThisFunc "> Invalid button position or ID: " WhichButton

	if (WhichButton < 0)
		a := Toolbar(hTb "aBTN"), aBtn := a + 4,  cnta := NumGet(a+0, "UPtr"),  WhichButton := -WhichButton,   a := true
	else if (WhichButton < 1){
		if (WhichButton = 0)
			return A_ThisFunc "> 0 is invalid position and ID"
		ErrorLevel := SendMessage(TB_COMMANDTOINDEX, SubStr(WhichButton, 2), , ,  hTb)
		if (ErrorLevel = 4294967295)
			return A_ThisFunc "> No such ID " SubStr(WhichButton, 2)
		WhichButton := ErrorLevel + 1
	} 
	WhichButton--

	if (a AND (cnta < WhichButton)) OR (!a and (Toolbar_Count(hTb) < WhichButton) )
		return A_ThisFunc "> Button position is too large: " WhichButton	

	;get TBB structure
	VarSetStrCapacity(&TBB, 20), aTBB := &TBB ; V1toV2: if 'TBB' is NOT a UTF-16 string, use 'TBB := Buffer(20)'
	; TBB := Buffer(20)
	if a
		aTBB := aBtn + WhichButton*20
	else 
		GETBUTTON := SendMessage(TB_GETBUTTON, WhichButton, aTBB, ,  hTb)

	id := NumGet(aTBB+0, 4)
	if (pQ = "id")
		return id

	;check for separator
	if NumGet(aTBB+0, 9, "Char") = 1  {
		Loop NumGet(TBB, "UPtr")//10 + 1
			buf .= "-"
		return buf
	}

	;get caption
	VarSetStrCapacity(&buf, 128), sIdx := NumGet(aTBB+0, 16) ; V1toV2: if 'buf' is NOT a UTF-16 string, use 'buf := Buffer(128)'
	; buf := Buffer(128)
	if (type(buf)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
		GETSTRING := SendMessage(TB_GETSTRING, (sIdx<<16)|128, buf, ,  hTb)
	} else{
		GETSTRING := SendMessage(TB_GETSTRING, (sIdx<<16)|128, StrPtr(buf), ,  hTb)
	}	
	;SendMessage(TB_GETBUTTONTEXT,id,&buf,, hTb)
	VarSetStrCapacity(&buf, -1) ; V1toV2: if 'buf' is NOT a UTF-16 string, use 'buf := Buffer(-1)'
	if a
		buf := "*" buf
	if (pQ = "c")
		return buf
	
	;get other data
	state := Toolbar_getStateName(NumGet(aTBB+0, 8, "Char"))
	if (pQ = "S")
		return state

	icon := NumGet(aTBB+0, "UPtr")+1
	if (pQ = "I")
		return icon

	style := Toolbar_getStyleName(NumGet(aTBB+0, 9, "Char"))
	if (pQ = "L")
		return style

	;make string
	buf :=  buf ", " icon ", " state ", " style (id < 10000 ? ", " id : "")
	return buf
}

/*
Function:	GetButtonSize
			Gets the size of buttons.

Parameters:
			W, H - Output width & height.

 */
Toolbar_GetButtonSize(hTb, &W, &H) {
	static TB_GETBUTTONSIZE:=1082

	GETBUTTONSIZE := SendMessage(TB_GETBUTTONSIZE, , , ,  hTb)
	W := GETBUTTONSIZE & 0xFFFF, H := GETBUTTONSIZE >> 16
}

/*
Function:  GetMaxSize
			Retrieves the total size of all of the visible buttons and separators in the toolbar.

Parameters:
			Width, Height		- Variables which will receive size.

Returns:
			Returns TRUE if successful.
 */
; Toolbar_GetMaxSize(hTb, &Width, &Height)
; {
; 	static TB_GETMAXSIZE := 0x453
; 	targetProcessID := WinGetPID(hTb)
; 	; VarSetStrCapacity(&SIZE, 8) ; V1toV2: if 'SIZE' is NOT a UTF-16 string, use 'SIZE := Buffer(8)'
; 	; SIZE := Buffer(8)
; 	hProcess := hTbProcess(targetProcessID)
; 	Is32bit := Win32_64_Bit(hProcess) 
; 	BtnStructSize := Is32bit ? 20 : 32
; 	BtnStruct := Buffer(BtnStructSize, 0)
; 	GETMAXSIZE := SendMessage(TB_GETMAXSIZE, 0, BtnStruct, , hTb)
; 	/*
; 	if (type(SIZE)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
; 		GETMAXSIZE := SendMessage(TB_GETMAXSIZE, 0, SIZE, ,  hTb)
; 	} else{
; 		GETMAXSIZE := SendMessage(TB_GETMAXSIZE, 0, (StrPtr(SIZE)), ,  hTb)
; 	}
; 	*/
; 	res := GETMAXSIZE, 	Width := NumGet(BtnStruct, "UPtr"), Height := NumGet(BtnStruct, 4)
; 	return
; }
Toolbar_GetMaxSize(hTb, &W, &H, hProcess?, n:=1,&Left?, &Top?, &Right?, &Bottom?, &X?, &Y?)
{
	targetProcessID := WinGetPID(hTb)
	hProcess := hTbProcess(targetProcessID)
	Is32bit := Win32_64_Bit(hProcess)
	remoteMemory := remoteTbMemory(hProcess, Is32bit,&TBBUTTON_SIZE)
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
	return {W:W, H:H}  
}
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
hTbProcess(targetProcessID)
{
	Static PROCESS_VM_OPERATION := 8, PROCESS_VM_READ := 16, PROCESS_VM_WRITE := 32
	hProcess := DllCall( 'OpenProcess', 'UInt'
						, PROCESS_VM_OPERATION | PROCESS_VM_READ | PROCESS_VM_WRITE
						, "Int", 0
						, "UInt", targetProcessID
						, "Ptr")
	return hProcess 					
}
remoteTbMemory(hProcess, Is32bit, &TBBUTTON_SIZE)
{
	Static MEM_PHYSICAL := 4 ; 0x04 ; 0x00400000, ; via MSDN Win32
	RPtrSize := Is32bit ? 4 : 8
	TBBUTTON_SIZE := 8 + (RPtrSize * 3) 
	remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", TBBUTTON_SIZE, "UInt", 0x1000, "UInt", MEM_PHYSICAL, "Ptr")
	return remoteMemory
}
/*
Function:  GetRect
			Get button rectangle

Parameters:
			pPos		- Button position. Leave blank to get dimensions of the toolbar control itself.
			pQ			- Query parameter: set x,y,w,h to return appropriate value, or leave blank to return all in single line.

Returns:
			String with 4 values separated by space or requested information
 */
Toolbar_GetRect(hTb, Pos:="", pQ:="")
{
	static TB_GETITEMRECT := 0x41D

	if (Pos != '')
		if (Pos < 0)
			throw 'Err: Invalid button position'

	VarSetStrCapacity(&RECT, 16) ; V1toV2: if 'RECT' is NOT a UTF-16 string, use 'RECT := Buffer(16)'
    if (type(RECT)='Buffer'){ ;V1toV2 If statement may be removed depending on type parameter
		GETITEMRECT := SendMessage(TB_GETITEMRECT, Pos-1, RECT, ,  hTb)
    } else{
		GETITEMRECT := SendMessage(TB_GETITEMRECT, Pos-1, StrPtr(RECT), ,  hTb)
    }
	if (GETITEMRECT = 0)
		throw A_ThisFunc "> Can't get rect"

	if (Pos = "")
		DllCall("GetClientRect", "uint", hTb, "uint", RECT)

	x := NumGet(RECT, 0), y := NumGet(RECT, 4), r := NumGet(RECT, 8), b := NumGet(RECT, 12)
	return (pQ = "x") ? x : (pQ = "y") ? y : (pQ = "w") ? r-x : (pQ = "h") ? b-y : x " " y " " r-x " " b-y
}

/*
Function:  Insert
			Insert button(s) on the Toolbar. 

Parameters:
			Btns		- The button definition list. Each button to be added is specified on separate line using button definition string. Empty lines will be skipped.
			Pos			- Optional 1-based index of a button, to insert the new buttons to the left of this button.
						- This doesn't apply to the list of available buttons.

Button Definition:
			Button is defined by set of its characteristics separated by comma:

			caption		- Button caption. All printable letters are valid except comma. 
						- "-" can be used to add separator. Add more "-" to set the separator width. Each "-" adds 10px to the separator.
			iconNumber  - Number of icon in the image list
			states		- Space separated list of button states. See bellow list of possible states.
			styles		- Space separated list of button styles. See bellow list of possible styles.
			ID			- Button ID, unique number you choose to identify button. On customizable toolbars position can't be used to set button information.
							If you need to setup button information using <SetButton> function or obtain information using <GetButton>, you need to use button ID 
							as user can change button position any time.
							It can by any number. Numbers > 10,000 are choosen by module as auto ID feature, that module does on its own when you don't use this option. 
							In most typical scenarios you don't need to use ID or think about them to identify the button. To specify ID in functions that accept it
							put dot infront of it, for instance .427 represents ID=427. This must be done in order to differentiate IDs from button position.

Button Styles:
			AUTOSIZE	- Specifies that the toolbar control should not assign the standard width to the button. Instead, the button's width will be calculated based on the width of the text plus the image of the button. 
			CHECK		- Creates a dual-state push button that toggles between the pressed and nonpressed states each time the user clicks it.
			CHECKGROUP	- Creates a button that stays pressed until another button in the group is pressed, similar to option buttons (also known as radio buttons).
			DROPDOWN	- Creates a drop-down style button that can display a list when the button is clicked.
			NOPREFIX	- Specifies that the button text will not have an accelerator prefix associated with it.
			SHOWTEXT	- Specifies that button text should be displayed. All buttons can have text, but only those buttons with the SHOWTEXT button style will display it. 
							This button style must be used with the LIST style. If you set text for buttons that do not have the SHOWTEXT style, the toolbar control will 
							automatically display it as a ToolTip when the cursor hovers over the button. For this to work you must create the toolbar with TOOLTIPS style.
							You can create multiline tooltips by using `r in the tooltip caption. Each `r will be replaced with new line.

	Button States:
			CHECKED		- The button has the CHECK style and is being clicked.
			DISABLED	- The button does not accept user input.
			HIDDEN		- The button is not visible and cannot receive user input.
			WRAP		- The button is followed by a line break. Toolbar must not have WRAPABLE style.

	Remarks:
		Using this function you can insert one or more buttons on the toolbar. Furthermore, adding group of buttons to the end (omiting pPos) is the 
		fastest way of adding set of buttons to the toolbar and it also allows you to use some automatic features that are not available when you add button by button.
		If you omit some parameter in button definition it will receive default value. Button that has no icon defined will get the icon with index that is equal to 
		the line number of its defintion list. Buttons without ID will get ID automaticaly, starting from 10 000. 
		You can use `r instead `n to create multiline button captions. This make sense only for toolbars that have LIST TOOLTIP toolbar style and no SHOWTEXT button style
		(i.e. their captions are seen as tooltips and are not displayed.
 */

Toolbar_Insert(hTb, Btns, Pos:="")
{
	static TB_INSERTA := 0x414, TB_INSERTBUTTONA := 0x415, TB_AUTOSIZE := 0x0421

	cnt := Toolbar_compileButtons(hTb, Btns, &cBTN)
	if (Pos = "")
		INSERTA := SendMessage(TB_INSERTA, cnt, cBTN, ,  hTb)
	else 
		Loop cnt
			INSERTBUTTONA := SendMessage(TB_INSERTBUTTONA, Pos+A_Index-2, cBTN + 20*(A_Index-1), ,  hTb)

	Toolbar_mfree(cBTN)

	;for some reason, you need to call this 2 times for proper results in some scenarios .... !?
	SendMessage(TB_AUTOSIZE, , , ,  hTb)	;autosize
	SendMessage(TB_AUTOSIZE, , , ,  hTb)	;autosize
}

/*
Function:  MoveButton
		Moves a button from one position to another.

Parameters:
		Pos		- 1-based position of the button to be moved.
		NewPos	- 1-based position where the button will be moved.

Returns:
		Returns nonzero if successful, or zero otherwise.
 */
Toolbar_MoveButton(hTb, Pos, NewPos)
{
	static TB_MOVEBUTTON := 0x452
    MOVEBUTTON := SendMessage(TB_MOVEBUTTON, Pos-1, NewPos-1, ,  hTb)
	return MOVEBUTTON
}


/*
Function:  SetBitmapSize
		Sets the size of the bitmapped images to be added to a toolbar.

Parameters:
		Width, Height - Width & heightin pixels, of the bitmapped images. Defaults to 0,0

Returns:
		TRUE if successful, or FALSE otherwise.

Remarks:
		The size can be set only before adding any bitmaps to the toolbar. 
		If an application does not explicitly set the bitmap size, the size defaults to 16 by 15 pixels. 
*/
Toolbar_SetBitmapSize(hTb, Width:=0, Height:=0)
{
	static TB_SETBITMAPSIZE := 1056
    ; SETBITMAPSIZE := SendMessage(TB_SETBITMAPSIZE, Width, Height, ,  hTb) ; todo : validate change
    SendMessage(TB_SETBITMAPSIZE, Width, Height, ,  hTb)
}

/*
Function:  SetButton
		Set button information

Parameters:
		WhichButton	- One of the 2 ways to identify the button: 1-based button position or button ID
		State		- List of button states to set, separated by white space.
		Width		- Button width (can't be used with LIST style)

Returns:
		Nonzero if successful, or zero otherwise.

*/
Toolbar_SetButton(hTb, WhichButton, State:="", Width:=""){
	static TBIF_TEXT := 2, TBIF_STATE := 4, TBIF_SIZE := 0x40 
	static TB_SETBUTTONINFO := 0x442, TB_GETSTATE := 0x412, TB_GETBUTTON := 0x417
	static TBSTATE_CHECKED := 1, TBSTATE_ENABLED := 4, TBSTATE_HIDDEN := 8, TBSTATE_ELLIPSES := 0x40, TBSTATE_DISABLED := 0

	if !isNumber(WhichButton)
		throw A_ThisFunc "> Invalid button position or ID: " WhichButton

    if (WhichButton >= 1){
		VarSetStrCapacity(&TBB, 20) ; V1toV2: if 'TBB' is NOT a UTF-16 string, use 'TBB := Buffer(20)'
		if (type(TBB)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
			GETBUTTON := SendMessage(TB_GETBUTTON, --WhichButton, TBB, ,  hTb)
		} else
		{
			GETBUTTON := SendMessage(TB_GETBUTTON, --WhichButton, StrPtr(TBB), ,  hTb)
		}
		WhichButton := NumGet(&TBB+0, 4)
	} else WhichButton := SubStr(WhichButton, 2)

	GETSTATE := SendMessage(TB_GETSTATE, WhichButton, , ,  hTb)
	hState := ErrorLevel

	mask := 0	 ,mask |= State != "" ?  TBIF_STATE : 0	 ,mask |= Width != "" ?  TBIF_SIZE  : 0

	if InStr(State, "-disabled") {
		hState |= TBSTATE_ENABLED 
		; StrReplace() is not case sensitive
		; check for StringCaseSense in v1 source script
		; and change the CaseSense param in StrReplace() if necessary
		State := StrReplace(State, "-disabled",,,, 1)
	}
	else if InStr(State, "disabled")
		hState &= ~TBSTATE_ENABLED

	Loop Parse, State, A_Tab "" A_Space, A_Tab "" A_Space
	{
		if (A_LoopField = "")
			continue
		if SubStr(A_LoopField, 1, 1) != "-"
			hState |= TBSTATE_%A_LOOPFIELD%
		else  k := SubStr(A_LoopField, 2),    k := TBSTATE_%k%, 	hState &= ~k
	}
	if (hState = "")
		throw A_ThisFunc "> Some of the states are invalid: " State

	BI := Buffer(32, 0) ; V1toV2: if 'BI' is a UTF-16 string, use 'VarSetStrCapacity(&BI, 32)'
	NumPut("UPtr", 32, BI, 0)
	NumPut("UPtr", mask, BI, 4)
	NumPut("Char", hState, BI, 16)
	NumPut("Short", Width, BI, 18)

	if (type(BI)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
		SETBUTTONINFO := SendMessage(TB_SETBUTTONINFO, WhichButton, BI, ,  hTb)
	} else
	{
		SETBUTTONINFO := SendMessage(TB_SETBUTTONINFO, WhichButton, StrPtr(BI), ,  hTb)
	}
	res := ErrorLevel
	
	ErrorLevel := SendMessage(0x421, , , ,  hTb)	;autosize
	return res
}
/*
Function:  SetButtonWidth
		Sets button width.

Parameters:
		Min, Max - Minimum and maximum button width. If you omit pMax it defaults to pMin.

Returns:
		TRUE if successful.
*/
Toolbar_SetButtonWidth(hTb, Min, Max:=""){
	static TB_SETBUTTONWIDTH := 0x43B
	if (Max = "")
		Max := Min

	ErrorLevel := SendMessage(TB_SETBUTTONWIDTH, 0, (Max<<16) | Min, ,  hTb)
	return ErrorLevel
}

/*
Function:  SetDrawTextFlags
		Sets the text drawing flags for the toolbar.

Parameters:
		Mask  - One or more of the DT_ flags, specified in DrawText, that indicate which bits in dwDTFlags will be used when drawing the text.
		Flags - One or more of the DT_ flags, specified in DrawText, that indicate how the button text will be drawn. 
				This value will be passed to the DrawText API when the button text is drawn. 
Returns:
		Returns the previous text drawing flags.

Remarks:
		See <http://msdn.microsoft.com/en-us/library/bb787425(VS.85).aspx> for more info.

Example:
		Toolbar_SetDrawTextFlags(hToolbar, 3, 2) ;right align text
*/
Toolbar_SetDrawTextFlags(hTb, Mask, Flags) {
	static TB_SETDRAWTEXTFLAGS := 1094
	SETDRAWTEXTFLAGS := SendMessage(TB_SETDRAWTEXTFLAGS, Mask, Flags, ,  hTb)
	return SETDRAWTEXTFLAGS
}

/*
Function:	SetButtonSize
			Sets the size of buttons.

Parameters:
			W, H	- Width & Height. If you omit height, it defaults to width.

Remarks:
			With LIST style, you can only set the height.
*/
Toolbar_SetButtonSize(hTb, W, H:="") {
	static TB_SETBUTTONSIZE := 0x41F
	if (H = "")
		H := W
	ErrorLevel := SendMessage(TB_SETBUTTONSIZE, , (H<<16)|W, ,  hTb)
;	SendMessage, 0x421,,,,ahk_id %hTb%	;autosize
}

/*
Function:  SetImageList
		Set toolbar image list.

Parameters:
		hIL	- Image list handle.

Returns:
		Handle of the previous image list.
*/
Toolbar_SetImageList(hTb, hIL:='1S'){
	static TB_SETIMAGELIST := 0x430, TB_LOADIMAGES := 0x432, TB_SETBITMAPSIZE := 0x420

	hIL .= 	StrLen(hIL) = 1 ? 'S' : ''
	if isInteger(hIL)
		SETIMAGELIST := SendMessage(TB_SETIMAGELIST, 0, hIL, ,  hTb)
	else {
		size := SubStr(hIL, 2, 1)="L" ? 24:16,  cat := (SubStr(hIL, 1, 1)-1)*4 + (size=16 ? 0:1)
		SETBITMAPSIZE := SendMessage(TB_SETBITMAPSIZE, 0, (size<<16)+size, ,  hTb)
		LOADIMAGES := SendMessage(TB_LOADIMAGES, cat, -1, ,  hTb)
	}

	return ; ErrorLevel ; TODO does this need a specific return???
}

/*
Function:  SetMaxTextRows
		Sets the maximum number of text rows displayed on a toolbar button.

Parameters:
		iMaxRows	- Maximum number of rows of text that can be displayed.

Remarks:
		Returns nonzero if successful, or zero otherwise. To cause text to wrap, you must set the maximum 
		button width by using <SetButtonWidth>. The text wraps at a word break. Text in LIST styled toolbars is always shown on a single line.
*/
Toolbar_SetMaxTextRows(hTb, iMaxRows:=0) {
	static TB_SETMAXTEXTROWS := 0x43C
    res := SendMessage(TB_SETMAXTEXTROWS, iMaxRows, , ,  hTb)
; 	SendMessage,0x421,,,,ahk_id %hTb% ;autosize
	return res
}


/*	Function:	ToggleStyle
				Toggle specific toolbar creation style

	Parameters:
				Style	- Style to toggle, by default "LIST". You can also specify numeric style value.
 */
Toolbar_ToggleStyle(hTb, Style:="LIST"){
    static TBSTYLE_WRAPABLE := 0x200, TBSTYLE_FLAT := 0x800, TBSTYLE_LIST:=0x1000, TBSTYLE_TOOLTIPS:=0x100, TBSTYLE_TRANSPARENT := 0x8000, TBSTYLE_ADJUSTABLE := 0x20,  TBSTYLE_BORDER:=0x800000, TBSTYLE_THICKFRAME:=0x40000, TBSTYLE_TABSTOP := 0x10000
	static TB_SETSTYLE:=1080, TB_GETSTYLE:=1081

	s := Style+0 != "" ? Style : TBSTYLE_%Style%	
	if (s = "")
		throw A_ThisFunc "> Invalid style: " Style

	WinSetStyle("^" s,  hTb)

	; This didn't work...
	;	SendMessage, TB_GETSTYLE, ,,, ahk_id %hTb%
	;	style := (ErrorLevel & style) ? ErrorLevel & !style : ErrorLevel | style
	;	SendMessage, TB_SETSTYLE, 0, style,, ahk_id %hTb%

	if (s = TBSTYLE_LIST) {
		;somehow, text doesn't return without this, when you switch from ON to OFF
		Toolbar_SetMaxTextRows(hTb, 0)
		Toolbar_SetMaxTextRows(hTb, 1)	
	}

; 	SendMessage,0x421,,,,ahk_id %hTb%	;autosize
}

/*
	Parse button definition list and compile it the into binary array. Add strings to pull. Return number of current buttons.
	cBTN	- Pointer to the compiled button array of current buttons
	Btns - Button definition list
	aBTN - Pointer to the compiled button array of available buttons

Button definition:
	[*]caption, icon, state, style, id
 */
Toolbar_compileButtons(hTb, Btns, &cBTN) {
	static BTNS_SEP := 1, BTNS_CHECK :=2, BTNS_CHECKGROUP := 6, BTNS_DROPDOWN := 8, BTNS_A:=16, BTNS_AUTOSIZE := 16, BTNS_NOPREFIX := 32, BTNS_SHOWTEXT := 64
	static TBSTATE_CHECKED := 1, TBSTATE_ENABLED := 4, TBSTATE_HIDDEN := 8, TBSTATE_DISABLED := 0, TBSTATE_WRAP := 0x20
	static TB_ADDSTRING := 0x41C, WS_CLIPSIBLINGS := 0x4000000
	static id:=10000								;automatic IDing starts form 10000,     1 <= userID < 10 000

	bMenu := WinGetStyle( hTb)
	bMenu := bMenu & WS_CLIPSIBLINGS		

	aBTN := Toolbar(hTb " aBTN")
	if (aBTN = "")
		aBTN := Toolbar_malloc( 50 * 20 + 4),  Toolbar(hTb " aBTN", aBTN)	 ;if space for array of * buttons isn't reserved and there are definitions of * buttons reserve it for 50 buttons + some more so i can keep some data there...

	; StrReplace() is not case sensitive
	; check for StringCaseSense in v1 source script
	; and change the CaseSense param in StrReplace() if necessary
	_ := StrReplace(Btns, "`n", ,, &ErrorLevel)
	btnNo := ErrorLevel + 1
	cBTN := Toolbar_malloc( btnNo * 20 )

	a := cnt := 0, 	cnta := NumGet(aBTN+0, "UPtr")		;get number of buttons in the array
	Loop Parse, Btns, "`n", A_Space "" A_Tab
	{
		if (A_LoopField = "")
			continue			;skip emtpy lines

		a1:=a2:=a3:=a4:=a5:=""					;a1-caption;  a2-icon_num;  a3-state;  a4-style;	a5-id;
		a := StrSplit(A_LoopField,",",A_Space "" A_Tab)

		;check icon
		if (bMenu AND a[2]="") or (a[2]=0)
			a[2] := -1		;so to become I_IMAGENONE = -2

		;check for available button
		a := SubStr(a[1], 1, 1) = "*"
		if a.Length
			a[1] := SubStr(a[1], 2), o := aBTN + 4
		else o := cBTN

		;parse states
		hState := InStr(a[3], "disabled") ? 0 : TBSTATE_ENABLED
		Loop Parse, a[3], A_Tab "" A_Space, A_Tab "" A_Space
		{
			if (A_LoopField = "")
				continue
			hState |= TBSTATE_%A_LOOPFIELD%
		}
		if (hState = "")
			return A_ThisFunc "> Some of the states are invalid: " a[3]

		;parse styles

		hStyle := bMenu ? BTNS_SHOWTEXT | BTNS_DROPDOWN : 0
		hstyle |= (A_LoopField >= "-") and (A_LoopField <= "-------------------") ? BTNS_SEP : 0
		sep += (hStyle = BTNS_SEP) ? 1 : 0
		Loop Parse, a[4], A_Tab "" A_Space, A_Tab "" A_Space
		{
			if (A_LoopField = "")
				continue
			hstyle |= BTNS_%A_LOOPFIELD%
		}
		if (hStyle = "")
			return A_ThisFunc "> Some of the styles are invalid: " a[4]

		;calculate icon
		if !isInteger(a[2])					;if user didn't specify icon, use button number as icon index (don't count separators)
			a[2] := cnt+cnta+1-sep
		o += 20 * (a.Length ? cnta : cnt)				;calculate offset o of this structure in array of TBBUTON structures.
												; only A buttons (* marked) are remembered, current buttons will temporary use
		;add caption to the string pool
		if (hStyle != BTNS_SEP) {
			; StrReplace() is not case sensitive
			; check for StringCaseSense in v1 source script
			; and change the CaseSense param in StrReplace() if necessary
			a[1] := StrReplace(a[1], "`r", "`n")		;replace `r with new lines (for multiline tooltips)
			buf := Buffer(StrLen(a[1])+1, 0), buf := a[1]	 ;Buf must be double-NULL-terminated ; V1toV2: if 'buf' is a UTF-16 string, use 'VarSetStrCapacity(&buf, StrLen(a1)+1)'
			sIdx := DllCall("SendMessage", "uint", hTb, "uint", TB_ADDSTRING, "uint", 0, "uint", buf)  ;returns the new index of the string within the string pool
		} else sIdx := -1,  a[2] := (StrLen(A_LoopField)-1)*10 + 1			;if separator, lentgth of the "-" string determines width of the separation. Each - adds 10 pixels.

		;TBBUTTON Structure
		bid := a[5] ? a[5] : ++id 					;user id or auto id makes button id

		NumPut("Int", a[2]-1, o+0, 0)			;Zero-based index of the button image. If the button is a separator, determines the width of the separator, in pixels
		NumPut("Int", bid, o+0, 4)			;Command identifier associated with the button
		NumPut("Char", hstate, o+0, 8)			;Button state flags
		NumPut("Char", hStyle, o+0, 9)			;Button style
		NumPut("UPtr", 0, o+0, 12)				;User data
		NumPut("Int", sIdx, o+0, 16)			;Zero-based index of the button string

		if a.Length
		{
			if (cnta = 50)
				warning := true
			else cnta++
		}
		else cnt++
	}

	NumPut("UPtr", cnta, aBTN + 0)		
	if warning
		MsgBox("You exceeded the limit of available (*) buttons (50)")

	return cnt									;return number of buttons in the array
}

Toolbar_onNotify(wParam,lParam,Msg,hTb)
{ 
	static MODULEID := 80609, oldNotify:="*" 
	static NM_CLICK:=-2, NM_RCLICK:=-5, NM_LDOWN:=-20, TBN_DROPDOWN:=-710, TBN_HOTITEMCHANGE:=-713, TBN_ENDDRAG:=-702, TBN_BEGINADJUST:=-703, TBN_GETBUTTONINFOA:=-700, TBN_QUERYINSERT:=-706, TBN_QUERYDELETE:=-707, TBN_BEGINADJUST:=-703, TBN_ENDADJUST:=-704, TBN_RESET:=-705, TBN_TOOLBARCHANGE:=-708, TB_COMMANDTOINDEX:=0x419
	static cnt, cnta, cBTN:=0, inDialog, tc := 0

	if (_ := (NumGet(lParam+4, "UPtr"))) != MODULEID
		if (_ < 10000)
			return	;if ahk control, return asap (AHK increments control ID starting from 1. Custom controls use IDs > 10000 as its unlikely that u will use more then 10K ahk controls.
	else {
		if (oldNotify = "*")
			oldNotify := Toolbar("oldNotify")
		if (oldNotify != "")
			return DllCall('oldNotify', "uint", wParam, "uint", lParam, "uint", Msg, "uint", hTb)
	}
    
	hw :=  NumGet(Lparam+0, "UPtr"), code := NumGet(Lparam+8, 0, "Int"),  handler := Toolbar(hw "Handler") 
	if (handler = "")
		return 
	iItem  := (code != TBN_HOTITEMCHANGE) ? NumGet(lParam+12, "UPtr") : NumGet(lParam+16, "UPtr") 

	COMMANDTOINDEX := SendMessage(TB_COMMANDTOINDEX, iItem, , , hw)
	pos := COMMANDTOINDEX + 1 , txt := Toolbar_GetButton( hw, pos, "c")

	
	if (code=TBN_ENDDRAG) { 		
		if (pos = 4294967296)
			return 
		tc := A_TickCount
    } 

	if (code=NM_CLICK) { 		
		if (pos = 4294967296)
			return
		if !(A_TickCount - tc)
			%handler%(hw, "click", txt, pos, iItem)
    } 

	if (code=NM_RCLICK)
		if (pos = 4294967296)
			return
        else  %handler%(hw,"rclick", txt, pos, iItem) 


	if (code = TBN_DROPDOWN)
		%handler%(hw, "menu", txt, pos, iItem)

	if (code = TBN_HOTITEMCHANGE)
	{ 
		if (pos = 4294967296)
			return 
		return %handler%(hw, "hot", txt, pos,  iItem) 
	} 

	;=================== CUSTOMIZATION NOTIFICATIONS =========================== 

	if (code = TBN_BEGINADJUST) { 
		cnta := NumGet(Toolbar(hw "aBTN"), "UPtr") , cnt := Toolbar_getButtonArray(hw, &cBTN), inDialog := true 
		if (cnt=0) && (cnta=0) 
			MsgBox("Nothing to customize")
		return 
	} 

	if (code = TBN_GETBUTTONINFOA)
	{ 
		if (iItem = cnt + cnta)					;iItem is position, not identifier. Win keeps sending incresing numbers until we say "no more" (return 0) 
			return 0 
	
		TBB := lparam + 16						;The OS buffer where to put the button structure 
		o := (iItem < cnt) ?  cBTN + 20*iItem : Toolbar( hw "aBTN") + 20*(iItem-cnt) + 4
		Toolbar_memcpy( TBB, o, 20) ;copy the compiled item into notification struct 
		return 1 
	} 

    ;Return at least one TRUE in QueryInsert to show the dialog, if the dialog is openinig. When the dialog is open, QueryInsert affects btn addition. QueryDelete affects deletion. 
	if (code = TBN_QUERYINSERT) || (code = TBN_QUERYDELETE) { 
		if (cnta="" or cnta=0) && (cnt=0) 
			return FALSE 
		return TRUE 
	} 

	if (code=TBN_ENDADJUST) { 
		Toolbar_onEndAdjust(hw, cBTN, cnt), inDialog := false 
		return %handler%(hw, "adjust", "", "", "") 
	} 

	;This will fire when user is dragging buttons around with adjustable style
	if (code = TBN_TOOLBARCHANGE) and !inDialog 
		return %handler%(hw, "change", "", "", "") 
}


;I am not keeping current buttons in memory, so I must obtain them if customization dialog is called, to populate it
Toolbar_getButtonArray(hTb, &cBtn){
	static TB_GETBUTTON := 0x417

	cnt := Toolbar_Count(hTb)	

	cBtn := Toolbar_malloc( cnt * 20 )
	Loop cnt
		GETBUTTON := SendMessage(TB_GETBUTTON, A_Index-1, cbtn + (A_Index-1)*20, ,  hTb)

	return cnt
}

Toolbar_getStateName( hState ) {
	static TBSTATE_HIDDEN:=8, TBSTATE_PRESSED := 0x2, TBSTATE_CHECKED:=1, TBSTATE_ENABLED:=0x4
	static states:=Array('hidden','pressed','checked','enabled')

	if !(hState & TBSTATE_ENABLED)				
		state := "disabled "

	if (hState = TBSTATE_ENABLED)
		return

	Loop Parse, states, ","
		if (hState & TBSTATE_%A_LoopField%)
			state .= A_LoopField " "

	; StrReplace() is not case sensitive
	; check for StringCaseSense in v1 source script
	; and change the CaseSense param in StrReplace() if necessary
	state := StrReplace(state, A_Space 'enabled' A_Space,,,, 1)
	return state
}

Toolbar_getStyleName( hStyle ) {
	static BTNS_CHECK:=2, BTNS_GROUP := 4, BTNS_DROPDOWN := 8, BTNS_AUTOSIZE := 16, BTNS_NOPREFIX := 32, BTNS_SHOWTEXT := 64
	static styles:=Array('check','group','dropdown','autosize','noprefix','showtext')
	
	Loop Parse, styles, ","
		if (hStyle & BTNS_%A_LoopField%)
			style .= A_LoopField " "
	; StrReplace() is not case sensitive
	; check for StringCaseSense in v1 source script
	; and change the CaseSense param in StrReplace() if necessary
	style := StrReplace(style, 'check group', 'checkgroup',,, 1)		;I don't use group flag at all
	return style
}

/*
After the customization dialog finishes, order and placements of buttons of the left and right side is changed.
As I keep available buttons as part of the AHK API, I must rebuild array of available buttons; add to it buttons 
that are removed from the toolbar and remove buttons that are added to the toolbar.
 */
Toolbar_onEndAdjust(hTb, cBTN, cnt) {
	static TB_COMMANDTOINDEX := 0x419, BTNS_SEP:=1
	
	a := Toolbar(hTb "aBTN")
	aBtn := a.Length+4, cnta := NumGet(a.Length+0, "UPtr")
	size := cnt+cnta,  size := size<50 ? 50 : size			;reserve memory for new aBTN array, minimum 50 buttons
	buf := Toolbar_malloc( size * 20 + 4)

	;check current button changes
    cnta2 := 0
	Loop cnt
	{
		o := cBTN + 20*(A_Index-1),	id := NumGet(o+0, 4)
		ErrorLevel := SendMessage(TB_COMMANDTOINDEX, id, , ,  hTb)
		if (Errorlevel != 4294967295)							;if errorlevel = -1 button isn't on toolbar
			continue
		if NumGet(o+0, 9, "Char") = BTNS_SEP				;skip separators
			continue
		Toolbar_memcpy( buf + cnta2++*20 +4, o, 20) ;copy the button struct into new array
	}
	Toolbar_mfree(cBTN)	

	;check available button changes
	Loop cnta
	{
		o := aBTN + 20*(A_Index-1),	id := NumGet(o+0, 4)
		COMMANDTOINDEX := SendMessage(TB_COMMANDTOINDEX, id, , ,  hTb)
		if (COMMANDTOINDEX != 4294967295)							;if errorlevel = -1 button isn't on toolbar
			continue
		Toolbar_memcpy(buf + cnta2++*20 +4, o, 20) ;copy the button struct into new array
	}
	Toolbar_mfree(aBTN)

	NumPut("UPtr", cnta2, buf+0)		;save array
	Toolbar( hTb "aBTN", buf)
}


Toolbar_malloc(pSize){
	static MEM_COMMIT:=0x1000, PAGE_READWRITE:=0x04
	return DllCall("VirtualAlloc", "uint", 0, "uint", pSize, "uint", MEM_COMMIT, "uint", PAGE_READWRITE)
}

Toolbar_mfree(pAdr) {
	static MEM_RELEASE := 0x8000
	return DllCall("VirtualFree", "uint", pAdr, "uint", 0, "uint", MEM_RELEASE)
}

Toolbar_memmove(dst, src, cnt) {
	return DllCall("MSVCRT\memmove", "uint", dst, "uint", src, "uint", cnt)
}

Toolbar_memcpy(dst, src, cnt) {
	return DllCall("MSVCRT\memcpy", "UInt", dst, "UInt", src, "uint", cnt)
}

;Required function by Forms framework.
Toolbar_add2Form(hParent, Txt, Opt) {
	static f := "Form_Parse"
	
	%f%(Opt, "x# y# w# h# style IL* g*", &x,&y,&w,&h,&style,&il,&handler)
	pos := (x!="" ? " x" x : "") (y!="" ? " y" y : "") (w!="" ? " w" w : "") (h!="" ? " h" h : "")
	h := Toolbar_Add(hParent, handler, style, il, pos)
	if (Txt != "")
		Toolbar_Insert(h, Txt)
	return h
}

;Storage
Toolbar(var:="", value:="~`a.Length", &o1:="", &o2:="", &o3:="", &o4:="", &o5:="", &o6:="") { 
	static
	if (var = "" ){
		if ( _ := InStr(value, ")") )
			__ := SubStr(value, 1, _-1), value := SubStr(value, (_+1)<1 ? (_+1)-1 : (_+1))
		Loop Parse, value, A_Space
			_ := %__%%A_LoopField%,  o%A_Index% := _ != "" ? _ : %A_LoopField%
		return
	} else _ := %var%
	if (value != "~`a.Length")
		%var% := value
	return _
}

/*
Group: Examples
(start code)
	Gui, +LastFound
	hGui := WinExist()
	Gui, Show , w500 h100 Hide                              ;set gui width & height prior to adding toolbar (mandatory)
	
	hTb := Toolbar_Add(hGui, "OnToolbar", "FLAT TOOLTIPS", "1L")    ;add the toolbar
	
	btns :=
		(LTrim
			new,  7,            ,dropdown showtext
			open, 8
			save, 9, disabled
			-
			undo, 4,            ,dropdown
			redo, 5,            ,dropdown
			-----
			state, 11, checked  ,check
		)
	
		Toolbar_Insert(hTb, btns)
		Toolbar_SetButtonWidth(hTb, 50)                   ;set button width & height to 50 pixels
	
		Gui, Show
	return

	;toolbar event handler
	OnToolbar(hTb, Event, Txt, Pos){				
		tooltip %Event% %Txt% (%Pos%), 0, 0
	}
	(end code)
 */

/*
Group: About
	o Ver 2.31 by majkinetor. See http://www.autohotkey.com/forum/topic27382.html
	o Parts of code in Toolbar_onNotify by jballi.
	o Toolbar Reference at MSDN: <http://msdn2.microsoft.com/en-us/library/bb760435(VS.85).aspx>
	o Licensed under GNU GPL <http://creativecommons.org/licenses/GPL/2.0/>
 */