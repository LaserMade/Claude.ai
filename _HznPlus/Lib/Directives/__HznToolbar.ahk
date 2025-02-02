﻿#Include <Directives\__AE.v2>
#Requires AutoHotkey v2+
; AE.__Init() ; ! in test phase to use a class for Auto Execution Section
; --------------------------------------------------------------------------------
/**
 * @example disabled due to above #Include <Directives\AE.v2>
 * ! EVERYTHING below here appears active, but is only visible due to @example
 * @example
 * ; --------------------------------------------------------------------------------
 * #Warn All, OutputDebug
 * #SingleInstance Force
 * #WinActivateForce
 * #Requires AutoHotkey v2
 * ; --------------------------------------------------------------------------------
 * #MaxThreads 255 ; Allows a maximum of 255 instead of default threads.
 * A_MaxHotkeysPerInterval := 1000
 * ; --------------------------------------------------------------------------------
 * SendMode("Input")
 * SetWorkingDir(A_ScriptDir)
 * SetTitleMatchMode(2)
 * ; --------------------------------------------------------------------------------
 * _AE_DetectHidden(true)
 * _SetDelays(-1)
 * _PerMonitor_DPIAwareness()
 * ; --------------------------------------------------------------------------------
 * _AE_DetectHidden(bool?) {
        bool := true
        DetectHiddenText(bool)
        DetectHiddenWindows(bool)
    }
 * ; --------------------------------------------------------------------------------
 * _AE_SetDelays(n?) {
        n := -1
        SetControlDelay(n)
        SetMouseDelay(n)
        SetWinDelay(n)
    }
    * ; --------------------------------------------------------------------------------
    * _AE_PerMonitor_DPIAwareness() {
    MaximumPerMonitorDpiAwarenessContext := VerCompare(A_OSVersion, ">=10.0.15063") ? -4 : -3
    Global DefaultDpiAwarenessContext := MaximumPerMonitorDpiAwarenessContext, A_DPI := DefaultDpiAwarenessContext
    try
        DllCall("SetThreadDpiAwarenessContext", "ptr", MaximumPerMonitorDpiAwarenessContext, "ptr")
        catch 
            DllCall("SetThreadDpiAwarenessContext", "ptr", -4, "ptr")
        else
            DllCall("SetThreadDpiAwarenessContext", "ptr", -3, "ptr")
        return A_DPI
    }
 * ! ------------------ End of @example ------------------
    */
; --------------------------------------------------------------------------------
/************************************************************************
* Function ..: __HznNew()
* @author ...: OvercastBTC
* @param hCtl ........: Gets the handle (hwnd) to the control in focus
* @param fCtl ........: Gets the ClassNN(hwnd) of the control in focus
* @param fCtlI .......: Gets the instance of the control in focus
* @param nCtl ........: Converts to ClassNN to the toolbar instance
* @param hTb .........: Gets the handle (hwnd) of the toolbar
* @param hTx .........: Gets the handle (hwnd) of the plain|rich text box
* @param pID .........: Gets the process ID using AHKv2 built-in fn()
* @param tpID .........: Gets the process ID using DllCall()
* @returns {integer|text}
* @issues
*      - the core issue is application iteself
*          - the age (early|pre-VB?) and not following modern standards
*          - parent/child relationships
*          - "pane" vs "toolbar" | "pane" vs "button" |etc
*      - not all are needed, or obtainable every time.
; ***********************************************************************/
Class HznToolbar {
    __HznNew(){
    SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
    BlockInput(1) ; 1 = On, 0 = Off
    try {
        hCtl := ControlGetFocus('A')
        fCtl := ControlGetClassNN(hCtl)
        fCtlI := SubStr(fCtl, -1, 1)
        nCtl := "msvb_lib_toolbar" fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        hTb := ControlGethWnd(nCtl, "A")
        hTx := ControlGethWnd(fCtl, "A")
        pID := WinGetPID(hTb)
        DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &tpID:=0)
    } catch Error as e {
        return e
    }
    
    return {hCtl:hCtl,fCtl:fCtl,fCtlI:fCtlI,nCtl:nCtl,hTb:hTb,hTx:hTx,pID:pID,tpID:tpID}
    }
    static _hCtl(){
        this.hCtl := ControlGetFocus('A')
        return this.hCtl 
    }      
    static _fCtl(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        return this.fCtl
    }
    static _fCtlI(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        this.fCtlI := SubStr(this.fCtl, -1, 1)
        return this.fCtlI
    }
    
    static _nCtl(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        this.fCtlI := SubStr(this.fCtl, -1, 1)
        this.nCtl := "msvb_lib_toolbar" this.fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        return this.nCtl
    }
    static _hTb(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        this.fCtlI := SubStr(this.fCtl, -1, 1)
        this.nCtl := "msvb_lib_toolbar" this.fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        this.hTb := ControlGethWnd(this.nCtl, "A")
        return this.hTb
    }
    static _hTx(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        this.hTx := ControlGethWnd(this.fCtl, "A")
        return this.hTx
    }    
    static _pID(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        this.fCtlI := SubStr(this.fCtl, -1, 1)
        this.nCtl := "msvb_lib_toolbar" this.fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        this.hTb := ControlGethWnd(this.nCtl, "A")
        this.pID := WinGetPID(this.hTb)
        return this.pID
    }
    static _tpID(*){
        this.hCtl := ControlGetFocus('A')
        this.fCtl := ControlGetClassNN(this.hCtl)
        this.fCtlI := SubStr(this.fCtl, -1, 1)
        this.nCtl := "msvb_lib_toolbar" this.fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        this.hTb := ControlGethWnd(this.nCtl, "A")
        this.tpID := DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &targetProcessID:=0)
        return this.tpID
    }
}

/**
* @title basic class example for AHKv2 - methods and properties
* @resource https://www.autohotkey.com/boards/viewtopic.php?t=73588
@example
class MyClassName {
    __New() {
        this.property := "new-init"
    }
    __property[name] {
    set => this.%name% := value
    get => this.%name%
}
method(x,y) {
    return x+y
}
}

myclass := MyClassName.new()
myclass.property := "change" ; comment this out to get init value

msgbox "test: " myclass.property
msgbox myclass.method(3,2)
* ! End of Example
 */
; --------------------------------------------------------------------------------
; @resouce https://www.reddit.com/r/AutoHotkey/comments/13cm9ix/ahk_v2_arrays/
; --------------------------------------------------------------------------------
; if not IsObject(myVar := HznToolbar.__HznNew())     ; if method fails
;     MsgBox(myVar.Message)                           ; display error message

; else                                                ; else display all returned values
;     ToolTip("hCtl: "            myVar.hCtl          "`n"
;             "fCtl: "            myVar.fCtl          "`n"
;             "fCtlInstance: "    myVar.fCtlInstance  "`n"
;             "nCtl: "            myVar.nCtl          "`n"
;             "hTb: "             myVar.hTb           "`n"
;             "hTx: "             myVar.hTx           "`n"
;             "hTx: "             myVar.hTx           "`n"
;             "pID: "             myVar.pID           "`n"
;             "pID: "             myVar.pID           "`n"
;             "tpID: "            myVar.tpID
;             "tpID: "            myVar.tpID
;     )
;     )





; class HznToolbar {
    
;     static __HznNew() {
;         SendLevel(5)    ; SendLevel higher than anything else (normally highest is 1)
;         BlockInput(1)   ; 1 = On, 0 = Off
;         toolbar := 'msvb_lib_toolbar'
;         HznToolbar._hCtl() := hCtl
;         HznToolbar._fCtl() := fCtl
;         HznToolbar._fCtl_I()  := fCtl_I
;         HznToolbar._nCtl()  := toolbar . fCtl
;         HznToolbar._hTb() := hTb   
;         HznToolbar._hTx() := hTx    
;         HznToolbar._tpID() := tpID
;         HznToolbar._pID() := pID
;         return { hCtl:  hCtl
;                 ,fCtl:  fCtl
;                 ,fCtl_I:fCtl_I
;                 ,nCtl:  nCtl
;                 ,hTb:   hTb
;                 ,hTx:   hTx
;                 ,pID:   pID
;                 ,tpID:  tpID
;         }
;         BlockInput(0)
;         SendLevel(0)
;     }
    ; static __HznNew() {
    ;     SendLevel(5)    ; SendLevel higher than anything else (normally highest is 1)
    ;     BlockInput(1)   ; 1 = On, 0 = Off

    ;     try {
    ;         return { hCtl:  this.hCtl
    ;                 ,fCtl:  this.fCtl
    ;                 ,fCtl_I:this.fCtl_I
    ;                 ,nCtl:  this.nCtl
    ;                 ,hTb:   this.hTb
    ;                 ,hTx:   this.hTx
    ;                 ,pID:   this.pID
    ;                 ,tpID:  this.tpID
    ;         }
    ;     } catch Error as e {
    ;         return e
    ;     }
    ;     BlockInput(0)
    ;     SendLevel(0)
    ; }
    ; static _hCtl()   => this.hCtl    := ControlGetFocus('A')
    ; static _fCtl(hCtl?)   => this.fCtl    := ControlGetClassNN(this.hCtl)
    ; static _fCtl_I(fCtl?) => this.fCtl_I  := SubStr(this.fCtl, -1, 1)
    ; static _nCtl(fCtl_I?)   => this.nCtl    := 'msvb_lib_toolbar' . this.fCtl_I
    ; static _hTb(nCtl?)    => this.hTb     := ControlGetHwnd(this.nCtl,'A')   
    ; static _hTx(fCtl?)    => this.hTx     := ControlGetHwnd(this.fCtl, 'A')    
    ; static _tpID(hTb?)   => this.tpID    := DllCall('GetWindowThreadProcessId', "Ptr", this.hTb, "UInt*", &tpID:=0)
    ; static _pID(hTb?)    => this.pID     := WinGetPID(this.hTb)
    ; static _getCtrlHwnd(ctrl) => ControlGetHwnd(ctrl, "A")
    ; static _hTb()    => (
    ;     this.hTb := this._getCtrlHwnd(this.nCtl),
    ;     DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &tpID:=0)
    ;     this.tpID := tpID
    ; )
    ; static _getCtrlHwnd(ctrl) => ControlGetHwnd(ctrl, "A")
; }
    
/**
 * 
 * @param name 
 * @param __Property
 * @example
__Property[name] {
    set => this.%name% := value
    get => this.%name%
}
*/

; Class HznToolbar {

    ; __New() {
    ;     ; hCtl := this._hCtl()
    ; }
;     __HznNew() {
;         SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
;         BlockInput(1) ; 1 = On, 0 = Off
;         try {
;             this.hCtl := ControlGetFocus('A')
;             this.fCtl := ControlGetClassNN(this.hCtl)
;             this.fCtl_I := SubStr(this.fCtl, -1, 1)
;             this.nCtl := "msvb_lib_toolbar" this.fCtl_I
;             this.hTb := ControlGethWnd(this.nCtl, "A")
;             this.hTb := ControlGethWnd(this.nCtl, "A")
;             this.hTx := ControlGethWnd(this.fCtl, "A")
;             this.hTx := ControlGethWnd(this.fCtl, "A")
;             this.hTx := ControlGethWnd(this.fCtl, "A")
;             this.hTx := ControlGethWnd(this.fCtl, "A")
;             this.pID := WinGetPID(this.hTb)
;             this.pID := WinGetPID(this.hTb)
;             this.pID := WinGetPID(this.hTb)
;             this.pID := WinGetPID(this.hTb)
;             DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &targetProcessID:=0)
;             DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &targetProcessID:=0)
;             DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &targetProcessID:=0)
;             DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &targetProcessID:=0)
;         } catch Error as e {
;         } catch Error as e {
;             return e
;             return e
;         }
;         }
;         }
;         }
        
        
;         return {hCtl:this.hCtl,fCtl:this.fCtl,fCtl_I:this.fCtl_I,nCtl:this.nCtl,hTb:this.hTb,hTx:this.hTx,pID:this.pID,tpID:this.targetProcessID}
;         return {hCtl:this.hCtl,fCtl:this.fCtl,fCtl_I:this.fCtl_I,nCtl:this.nCtl,hTb:this.hTb,hTx:this.hTx,pID:this.pID,tpID:this.targetProcessID}
;     }
;     }
;     ; _hCtl[] => this.hCtl := ControlGetFocus('A')
;     ; _hCtl[] => this.hCtl := ControlGetFocus('A')
;     _hCtl() => this.hCtl := ControlGetFocus('A') ; *works
;     _hCtl() => this.hCtl := ControlGetFocus('A') ; *works
;     ; _hCtl[property_hCtl] {
;     ; _hCtl[property_hCtl] {
;     ;     set => this.%property_hCtl% := ControlGetFocus('A')
;     ;     get => this.%property_hCtl%
;     ; }
;     _fCtl(*) => this.fCtl := ControlGetClassNN(this._hCtl())
;     ; _fCtl[property_fCtl] {
;     ;     set => this.%property_fCtl% := ControlGetClassNN(this._hCtl)
;     ;     get => this.%property_fCtl%
;     ; }
;     _fCtl_I(*) => this.fCtl_I := SubStr(this._fCtl(), -1, 1)
;     ; _fCtl_I[property_fCtl_Instance] {
;     ;     set => this.%property_fCtl_Instance% := SubStr(this.fCtl, -1, 1)
;     ;     get => this.%property_fCtl_Instance%
;     ; }
;     _nCtl(*) => this.nCtl := 'msvb_lib_toolbar' this.fCtl_I
;     ; _nCtl[property_nCtl] {
;     ;     set => this.%property_nCtl% := 'msvb_lib_toolbar' this.fCtlInstance
;     ;     get => this.%property_nCtl%
;     ; }
;     _hTb(*) => this.hTb := ControlGethWnd(this.nCtl, 'A')
;     ; _hTb[property_hTb] {
;     ;     set => this.%property_hTb% := ControlGethWnd(this.nCtl, 'A')
;     ;     get => this.%property_hTb%
;     ; }
;     _pID(*) => this.pID := WinGetPID(this.hTb)
;     ; _pID[property_pID] {
;     ;     set := this.%property_pID% := WinGetPID(this.hTb)
;     ;     get := this.%property_pID%
;     ; }
;     _hTx(*) => this.hTb := ControlGethWnd(this.fCtl, 'A')
;     ; _hTx[property_hTx] {
;     ;     set := this.%property_hTx% := ControlGethWnd(this.fCtl, 'A')
;     ;     get := this.%property_hTx%
;     ; }
;     _tpID(*) => this.tpID := DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &tpID:=0)
;     ; _tID[property_target_pID]{
;     ;     ; set => this.%property_target_pID% := DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &targetProcessID:=0)
;     ;     set := this.%property_target_pID% := DllCall("GetWindowThreadProcessId", "Ptr", this.hTb, "UInt*", &_tID:=0)
;     ;     get := this.%property_target_pID%
;     ; }
;     method(x,y) {
; 		return x+y
; 	}
; }

; --------------------------------------------------------------------------------
Toolbar_Exist(&hCtl?, &fCtl?, &fCtlInstance?, &nCtl?, &hTb?, &hTx?, &pID?, &tpID?)
{
	SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
	BlockInput(1) ; 1 = On, 0 = Off
	arrTb := Array()
	try
		hCtl    := ControlGetFocus('A')
        fCtl    := ControlGetClassNN(hCtl)
        fCtlI   := SubStr(fCtl, -1, 1)
        nCtl    := "msvb_lib_toolbar" fCtlInstance
        hTb     := ControlGethWnd(nCtl, "A")
        hTx     := ControlGethWnd(fCtl, "A")
        pID     := WinGetPID(hTb)
        DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &targetProcessID:=0)
        BlockInput(0) ; 1 = On, 0 = Off	
        SendLevel(0) ; SendLevel higher than anything else (normally highest is 1)
	arrTb.Push({
        hCtl:hCtl
        , fCtl:fCtl
        , fCtlI:fCtlI
        , nCtl:nCtl
        , hTb:hTb
        , hTx:hTx
        , pID:pID
        , tpID:tpID
    })
	OutputDebug(hCtl '`n'
    . fCtl '`n'
    . fCtlInstance '`n'
    . nCtl '`n'
			. hTb '`n'
			. hTx '`n'
			. pID '`n'
			. tpID '`n'
			)
            toolbar_info := DisplayObj(arrTb)
            OutputDebug(toolbar_info)
            
    return {hCtl:hCtl,fCtl:fCtl,fCtlI:fCtlI,nCtl:nCtl,hTb:hTb,hTx:hTx,pID:pID,tpID:tpID}
}
; --------------------------------------------------------------------------------
GetTbInfo()
{
    SendLevel(5) ; SendLevel higher than anything else (normally highest is 1)
    BlockInput(1) ; 1 = On, 0 = Off
    TbInfo := Array()
    try {
        hCtl := ControlGetFocus('A')
        fCtl := ControlGetClassNN(hCtl)
        fCtlI := SubStr(fCtl, -1, 1)
        nCtl := "msvb_lib_toolbar" fCtlI ; ! => would love to regex this to anything containing 'bar' || toolbar || ?
        hTb := ControlGethWnd(nCtl, "A")
        hTx := ControlGethWnd(fCtl, "A")
        pID := WinGetPID(hTb)
        DllCall("GetWindowThreadProcessId", "Ptr", hTb, "UInt*", &tpID := 0)
    } catch Error as e {
        return e
    }

    TbInfo.Push(hCtl, fCtl, fCtlI, nCtl, hTb, hTx, pID, tpID)
    return { hCtl: hCtl, fCtl: fCtl, fCtlI: fCtlI, nCtl: nCtl, hTb: hTb, hTx: hTx, pID: pID, tpID: tpID }
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
    ; --------------------------------------------------------------------------------
