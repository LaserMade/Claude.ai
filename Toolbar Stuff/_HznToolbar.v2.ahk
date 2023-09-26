/************************************************************************
 * @description A Class for the Horizon toolbar interfaces using VB6, VBA, ???
 * @file _HznToolbar.v2.ahk
 * @author OvercastBTC
 * @date 2023.09.15
 * @version 1.0.0
 * @ahkversion v2+
 ***********************************************************************/
; --------------------------------------------------------------------------------
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
; #Include <ComObjDll>
; #Include <GetProcessThreads>
VARIANT_LOCALBOOL:=	16
; --------------------------------------------------------------------------------
Class hznToolbar {
	Static hznTb := ComObject('{66833FEA-8583-11D1-B16A-00C0F0283628}')
	Class tx4ole11 extends hznToolbar {
		static tx4ole11 := ComObject("tx4ole11.ocx")
		static tx4ole11.ocx := ComObject("{1B635020-8269-11D8-9E2B-004005A9ABD2}#1.6#0")
		; static tx4ole11.ocx := ComObject("{1B635020-8269-11D8-9E2B-004005A9ABD2}")
		/**
		 * function: either method does not cause an error to be thrown.
		 */
		
	}
	class MSCOMCTL extends hznToolbar {
		static MSCOMCTL := ComObject ('MSCOMCTL.OCX')
		static MSCOMCTL.OCX := ComObject ("{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}#2.1#0")
		; static MSCOMCTL.OCX := ComObject ("{831FDD16-0C5C-11D2-A9FC-0000F8754DA1}")
	}
	
	class wspell extends hznToolbar {
		static wspell := ComObject('wspell.ocx')
		static wspell.ocx := ComObject("{245338C0-BCA3-4A2C-A7B7-53345999A8E8}#1.0#0")
		; static wspell.ocx := ComObject("{245338C0-BCA3-4A2C-A7B7-53345999A8E8}")
	}
	; static ComObjConnect(HznTb,'Hzn_')
	; HznBuf32 := Buffer(32)
	; NumPut('uint', HznBuf32.Size, HznBuf32, 0)
	; fmgRichText := ComValue(VARIANT_LOCALBOOL,hznTb)
	
	; hznTb.fmgRichText.AlwaysItalic.ComValue(0xB, true)
}
HznSaveVB()
{

	try test := ComObjGet('tx4ole11.ocx')
	MsgBox(test)
	; Try Toolbar := ComObjActive('hznToolbar')

	; Catch
	; 	Toolbar := ComObjActive("{66833FEA-8583-11D1-B16A-00C0F0283628}")
	; wMain := WinGetID('A','Main',,'[Main]')
	; prevTMM := A_TitleMatchMode
	; SetTitleMatchMode(3)
	; mCtl := ControlGetClassNN('Main',,'Main',,'[Main]')
	; iDmCtl := WinGetID(,'Main',,'[Main]')
	; fmCtl := WinGetClass(iDmCtl)
	; ; MsgBox('wMain: ' wMain '`n' 'mCtl: ' mCtl '`n' 'fmCtl: ' fmCtl)
	; A_TitleMatchMode := prevTMM

	
	; Tb.AlwaysItalic() 
	return
	hWnd := WinGetID('A')
	hMenu := DllCall("GetTitleBarInfo", "Ptr", hwnd, "Int")
	OutputDebug(hMenu)
	; --------------------------------------------------------------------------------
	/** 
	 * @desc This is crazy that I have to set these variables, but it is Horizon though....
	*/
	global IUIAutomationActivateScreenReader:=0
	global IUIAutomationMaxVersion:=0
	; --------------------------------------------------------------------------------
	return

}