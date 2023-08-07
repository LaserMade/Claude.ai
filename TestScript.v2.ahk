#Requires AutoHotkey v2.0
#Warn All, OutputDebug
#SingleInstance Force
#WinActivateForce
#InputLevel 5
A_MaxHotkeysPerInterval := 1000
SetWorkingDir A_ScriptDir
SetControlDelay(-1)
SetWinDelay(-1)
SetDefaultMouseSpeed(0)
#Hotstring EndChars @
#Hotstring t o
CoordMode("Mouse", "Screen")
CoordMode("Pixel", "Client")
DetectHiddenText(1)
DetectHiddenWindows(1)

#Include <Class_Toolbar.c2v2>


~^s::
{
    Reload()
}
return

+#w::
{
    hTB := Horizon
    btnct := hTB().BtnCount()
    MsgBox(hTB.Terms["btc"] " = " btnct, hTB.Terms["btc"])
}
; --------------------------------------------------------------------------------
; Function .....: HznButton()
; Description ..: Find and Control-Click the Horizon msvb_lib_toolbar buttons
; Definition ...: hWndToolbar = the toolbar window's handle
; Definition ...: n = the index for the specified button
; Author .......: Descolada, Overcast (Adam Bacon)
; --------------------------------------------------------------------------------
; SendMessage(hWnd, Msg, wParam, lParam)
; {
; 	return DllCall("SendMessage", "UInt", hWnd, "UInt", Msg, "UInt", wParam, "UInt", lParam)
; }
HznButton(hToolbar, n)
{
;   Step: set the Static variables
    Static TB_BUTTONCOUNT  := 1048 ; 0x0418
    Static TB_GETBUTTON    := 1047 ; 0x417,
    Static TB_GETITEMRECT  := 1053 ; 0x41D,
    Static MEM_COMMIT      := 4096 ; 0x1000, ; 0x00001000, ; via MSDN Win32 
    Static MEM_RESERVE     := 8192 ; 0x2000, ; 0x00002000, ; via MSDN Win32
    Static MEM_PHYSICAL    := 4 ; 0x04    ; 0x00400000, ; via MSDN Win32
    Static MEM_PROTECT     := 0x40 ;  
    Static MEM_RELEASE     := 0x8000 ;  
    Static PROCESS_TERMINATE				:= 0x0001
    Static PROCESS_CREATE_THREAD		:= 0x0002
    Static PROCESS_SET_SESSIONID			:= 0x0004
    Static PROCESS_VM_OPERATION			:= 0x0008
    Static PROCESS_VM_READ					:= 0x0010
    Static PROCESS_VM_WRITE				:= 0x0020
    Static PROCESS_DUP_HANDLE				:= 0x0040
    Static PROCESS_CREATE_PROCESS		:= 0x0080
    Static PROCESS_SET_QUOTA				:= 0x0100
    Static PROCESS_SET_INFORMATION		:= 0x0200
    Static PROCESS_QUERY_INFORMATION	:= 0x0400
    Static PROCESS_SUSPEND_RESUME		:= 0x0800
    ; Static PROCESS_ALL_ACCESS				:= (STANDARD_RIGHTS_REQUIRED | SYNCHRONIZE |  0xFFF)

    Static PAGE_NOACCESS						:= 0x01     
    Static PAGE_READONLY						:= 0x02     
    Static PAGE_READWRITE					:= 0x04     
    Static PAGE_WRITECOPY					:= 0x08     
    Static PAGE_EXECUTE						:= 0x10     
    Static PAGE_EXECUTE_READ				:= 0x20     
    Static PAGE_EXECUTE_READWRITE		:= 0x40     
    Static PAGE_EXECUTE_WRITECOPY		:= 0x80     
    Static PAGE_GUARD							:= 0x100     
    Static PAGE_NOCACHE						:= 0x200     
    Static PAGE_WRITECOMBINE				:= 0x400     
    ; MEM_COMMIT							:= 0x1000     
    ; MEM_RESERVE							:= 0x2000     
    Static MEM_DECOMMIT						:= 0x4000     
    ; MEM_RELEASE							:= 0x8000     
    Static MEM_FREE								:= 0x10000     
    Static MEM_PRIVATE							:= 0x20000     
    Static MEM_MAPPED							:= 0x40000     
    Static MEM_RESET							:= 0x80000     
    Static MEM_TOP_DOWN						:= 0x100000     
    Static MEM_WRITE_WATCH				:= 0x200000     
    Static MEM_PHYSICAL						:= 0x400000     
    Static MEM_LARGE_PAGES					:= 0x20000000     
    Static MEM_4MB_PAGES						:= 0x80000000  

    Static CP_ACP 									:= 0           ; default to ANSI code page
    Static CP_OEMCP 								:= 1           ; default to OEM  code page
    Static CP_MACCP 								:= 2           ; default to MAC  code page
    Static CP_THREAD_ACP 						:= 3           ; current thread's ANSI code page
    Static CP_SYMBOL 							:= 42          ; SYMBOL translations

    Static CP_UTF7								:= 65000       ; UTF-7 translation
    Static CP_UTF8								:= 65001       ; UTF-8 translation
    ;   [in]   SIZE_T dwSize, ; The size of the region of memory to allocate, in bytes.
    Static  dwSize          := 32  
;   Step: count and load all the msvb_lib_toolbar buttons Into memory

	buttonCount := SendMessage(TB_BUTTONCOUNT, 0, 0,,Integer(hToolbar))
	if (n >= 1 && n <= buttonCount) {
		; Step: Get the PIDfromHwnd() using DllCall
		targetProcessID := DllCall('User32.dll\GetWindowThreadProcessId', 'Ptr', hToolbar, 'Ptr', 0, 'UInt')

		; Step Open the target process with PROCESS_VM_OPERATION, PROCESS_VM_READ, and PROCESS_VM_WRITE access
		; hProcess := DllCall("Kernel32.dll\OpenProcess", "UInt", 0x0018 | 0x0010 | 0x0020, "Int", 0, "UInt", targetProcessID, "Ptr")
		; hProcess := DllCall("Kernel32.dll\OpenProcess", "Int", 0x0018 | 0x0010 | 0x0020, "Char", 0, "UInt", targetProcessID, "UInt")
		; hProcess := DllCall("Kernel32.dll\OpenProcess", "UInt", PROCESS_VM_READ | PROCESS_VM_WRITE | PROCESS_VM_OPERATION, "Int", 0, "UInt", targetProcessID) ;, "UInt")
        hProcess := Horizon().GetWindowThreadProcessId(hToolbar)

		; ; Allocate memory for the TBBUTTON structure in the target process's address space
		; remoteMemory := DllCall("VirtualAllocEx", "Ptr", hProcess, "Ptr", 0, "UPtr", 16, "UInt", 0x1000, "UInt", 0x04, "Ptr")
        ; Step: Allocate memory for the TBBUTTON structure in the target process's address space
		; Reference: https://learn.microsoft.com/en-us/windows/win32/api/memoryapi/nf-memoryapi-virtualallocex
		; Description: LPVOID VirtualAllocEx(
        remoteMemory := DllCall("VirtualAllocEx"
        , "Ptr",    hProcess                    ; [in]           HANDLE hProcess,
        , "Ptr",    0                           ; [in, optional] LPVOID lpAddress, 
        ; , "UPtr",      16                     ; [in]           SIZE_T dwSize, ; The size of the region of memory to allocate, in bytes.
        , "UPtr",   dwSize                      ; [in]           SIZE_T dwSize, ; The size of the region of memory to allocate, in bytes.
        , "UInt",   MEM_COMMIT | MEM_RESERVE    ; [in]           DWORD  flAllocationType,
        , "UInt",   MEM_PHYSICAL                ; Note: original had MEM_COMMIT only [; , "UInt", 0x1000 ]
        , "Ptr",    MEM_PROTECT) ; 0x40)                       ; [in]           DWORD  flProtect ; The memory protection for the region of pages to be allocated.
        ; , "Ptr") ; original
        ; If the pages are being committed, you can specify any one of the memory protection constants
        ; reference <https://learn.microsoft.com/en-us/windows/win32/Memory/memory-protection-constants>.
		Msg := TB_GETITEMRECT
        wParam := 1
        lParam := remoteMemory
        SendMessage(Msg, wParam, lParam, Integer(hToolbar))
        ; SendMessage(hToolbar,TB_GETITEMRECT, &(n-1), remoteMemory)
		VarSetStrCapacity(&RECT, dwSize)
		; DllCall("ReadProcessMemory", "Ptr", hProcess, "Ptr", remoteMemory, "Int", &RECT, 'UInt*', dwSize, 'Ptr', &bytesRead, 'Ptr', 0)
        DllCall('ReadProcessMemory', 'UInt', hProcess, 'UInt', remoteMemory, 'UInt*', &uint32 := 0, 'Ptr', 4, 'UInt', 0)
        DllCall(  "VirtualFreeEx" 
                , "UInt", hProcess 
                , "UInt", remoteMemory 
                , "UInt", 0 
                , "UInt", MEM_RELEASE)     ; MEM_RELEASE 
		
        ; get the bounding rectangle for the specified button
        ControlGetPos(&ctrlx, &ctrly,,,hToolbar,"A")
	    RECT := Buffer(32,0), W := 0, H := 0
        TBI := Buffer(bSize:=(A_PtrSize=4)?32:48,0)
        X := NumGet(RECT, 0, "Int"),
        Y := NumGet(RECT, 4, "Int"),
        W := NumGet(RECT, 8, "Int") - X,
        H := NumGet(RECT, 12, "Int") - Y,
        ; prevDelay := A_ControlDelay ;,

		ControlClick("x" (X+W//2) " y" (Y+H//2), Integer(hToolbar))
		;SetControlDelay, %prevDelay%
	; } else {
	; 	MsgBox, 48, Error, % "The specified index " n " is out of range. Please specify a valid index between 1 and " buttonCount "."
	; }
	DllCall("FreeLibrary", "Ptr", hProcess) ; added 06.23.2023
	DllCall("FreeLibrary", "Ptr", remoteMemory) ; added 06.23.2023
	DllCall("CloseHandle", "Ptr", hToolbar) ; added 06.23.2023
    }
}