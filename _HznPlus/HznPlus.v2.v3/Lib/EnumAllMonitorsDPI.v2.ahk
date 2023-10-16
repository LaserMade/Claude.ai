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
#Requires AutoHotkey v2+
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
/**
 * @author Descolada (main v2 author)
 * @author OvercastBTC (mod)
 * @author justme (original v1 author)
 * @author iPhilip (v1 mod)
 * @param EnumMonitors 
 */
#HotIf WinExist(A_ScriptName)
#^e::
{
hwnd := WinExist("A"), List := ""
for Each, hMonitor in EnumMonitors() {
	dpi := GetDpiForMonitor(hMonitor)
	List .= 'Index: [' Each ']`n' 'mhWnd: ' hMonitor '`n' 'dpi.x: ' dpi.x  '`n' 'dpi.y: ' dpi.y '`n' 'dpi.Window: ' GetDpiForWindow(hwnd) "`n"
}

MsgBox(List)
return
}

^#i::
{
	hwnd := WinExist('A')
	dpi := GetDpiForWindow(hwnd)
	OutputDebug(hwnd '`n' dpi)
	reload()
	return
}

#HotIf

EnumMonitors() {
	static EnumProc := CallbackCreate(MonitorEnumProc)
	Monitors := []
	return DllCall("User32\EnumDisplayMonitors", "Ptr", 0, "Ptr", 0, "Ptr", EnumProc, "Ptr", ObjPtr(Monitors), "Int") ? Monitors : false
}

MonitorEnumProc(hMonitor, hDC, pRECT, ObjectAddr) {
	Monitors := ObjFromPtrAddRef(ObjectAddr)
	Monitors.Push(hMonitor)
	return true
}

GetDpiForMonitor(hMonitor, Monitor_Dpi_Type := 0) {  ; MDT_EFFECTIVE_DPI = 0 (shellscalingapi.h)
	if !DllCall("Shcore\GetDpiForMonitor", "Ptr", hMonitor, "UInt", Monitor_Dpi_Type, "UInt*", &dpiX:=0, "UInt*", &dpiY:=0, "UInt")
		return {x:dpiX, y:dpiY}
}

GetDpiForWindow(hwnd) {
	return DllCall("User32\GetDpiForWindow", "Ptr", hwnd, "UInt")
}
