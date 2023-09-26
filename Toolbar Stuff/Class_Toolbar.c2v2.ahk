#Include <.\Lib.v2\Class_IronToolbar>
#Include <.\Lib.v2\Toolbar>
#Include <.\LIb.v2\OpenProcess>

; IronToolbarArray := IronToolbar()
    ; Line 39: "Styles"
    ; Line 57: "bStyles"
    ; Line 66: "exStyles"
    ; Line 73: "states"
    ; Line 82: "flags"
    ; Line 92: "wm_n"
    ; TODO // Line 115: "messages" <======== currently in this.Toolbar on Line 43 => Merge or keep Separate???
    ; Line 155: "hotItemFlags"
    ; Line 163: "metrics"
    ; Line 165: TbList := []
    ; Line 166: padding := 7
    ; Line 176: Start of Methods()



Class Horizon {
    
    __New() {
        SendLevel(5)
        THIS.fCtl := ControlGetClassNN(ControlGetFocus("A"))
        THIS.tbID := SubStr(this.fCtl, -1, 1)
        THIS.tbCtl := Horizon.Terms["hznTb"] this.tbID
    }

    hWndTb() {
        Return THIS.hWnd := ControlGetHwnd(this.tbCtl, "A")
    }

    BtnCount() {
        Msg := Horizon.Msg["TB_BUTTONCOUNT"], wParam := 0, lParam := 0
        Control := ; this CANNOT be Control := "" => "Control not found"
        WinTitle := this.hWndTb()
        btnCount := SendMessage(Msg, wParam, lParam,, Integer(WinTitle))
        return btnCount
    }

; Class GetWindowThreadProcessId extends Horizon {
    GetWindowThreadProcessId(hWnd) {
        hWnd := this.hWndTb()
        ; Local ProcessID
        ; false := 0
        ; , ThreadID  := DllCall('User32.dll\GetWindowThreadProcessId', 'Ptr'  , hWnd           ; hWnd
                                                                    ; , 'UIntP', ProcessID     ;lpdwProcessId
                                                                    ; , 'UInt')                 ;ReturnType    --> dwThreadId
        ; Return (ThreadID ? {ThreadID: ThreadID, ProcessID: ProcessID} : FALSE)
        return this.ProcessID := DllCall('User32.dll\GetWindowThreadProcessId', 'Ptr', hWnd, 'Ptr', 0, 'UInt')
    } ;https://msdn.microsoft.com/en-us/library/windows/desktop/ms633522(v=vs.85).aspx
; }

    
; Class OpenProcess extends Horizon {
    OpenProcess(ProcessId, DesiredAccess, InheritHandle := FALSE){
        DesiredAccess := Horizon.Access["PROCESS_ALL_ACCESS"]
        ProcessID := this.ProcessID
        hProcess := DllCall('Kernel32.dll\OpenProcess', 'UInt', DesiredAccess, 'Int', InheritHandle, 'UInt', ProcessId, 'Ptr')
        Return hProcess
    } ; https://msdn.microsoft.com/en-us/library/windows/desktop/ms684320(v=vs.85).aspx
; }

    Static Access := Map(
        ; https://www.magnumdb.com/search?q=PROCESS_ALL_ACCESS (review and add)
        "PROCESS_ALL_ACCESS"                    , 0x1F0FFF,
        "PROCESS_DUP_HANDLE"                    , 0x0040,
        "PROCESS_QUERY_INFORMATION"             , 0x0400,
        "PROCESS_QUERY_LIMITED_INFORMATION"     , 0x1000,
        "PROCESS_SET_INFORMATION"               , 0x0200,
        "PROCESS_SET_QUOTA"                     , 0x0100,
        "PROCESS_SUSPEND_RESUME"                , 0x0800,
        "PROCESS_TERMINATE"                     , 0x0001,
        ; "PROCESS_VM_OPERATION"                  , 0x0008, is it 8, r 18?
        "PROCESS_VM_OPERATION"                  , 0x0018,
        "PROCESS_VM_READ"                       , 0x0010,
        "PROCESS_VM_WRITE"                      , 0x0020,
        "SYNCHRONIZE"                           , 0x100000,
        "MEM_PHYSICAL"              			, 4,
        "MEM_PROTECT"               			, 64, ; 0x40,                     
        "MEM_RELEASE"               			, 32768, ; 0x8000
        "MEM_COMMIT"                			, 4096,
        "MEM_RESERVE"               			, 8192,
    )
    ;? Windows Messages with values (decimal or hex)
    ;? Toolbar Messages https://docs.microsoft.com/en-us/windows/win32/controls/bumper-toolbar-control-reference-messages
    
    Static Msg := Map(

        "AddButtons"                ,0x414,
        "AddString"                 ,(StrLen(Chr(0xFFFF))?0x044D:0x041C),
        "AutoSize"                  ,0x421,
        "ButtonCount"               ,0x418,
        "ChangeBitmap"              ,0x42B,
        "CheckButton"               ,0x402,
        "CommandToIndex"            ,0x419,
        "Customize"                 ,0x41B,
        "DeleteButton"              ,0x416,
        "EnableButton"              ,0x401,             
        "GetAnchorHighlight"        ,0x44A,
        "GetBitmap"                 ,0x42C, 
        "GetButton"                 ,0x417,
        "GetButtonInfo"             ,(StrLen(Chr(0xFFFF))?0x43F:0x441), 
        "GetButtonSize"             ,0x43A,
        "GetButtonText"             ,(StrLen(Chr(0xFFFF))?0x044B:0x042D),
        "GetExtendedStyle"          ,0x455,
        "GetHotItem"                ,0x447,             
        "GetIdealSize"              ,0x463,
        "GetImageList"              ,0x431,             
        "GetImageListCount"         ,0x462,
        "GetItemDropDownRect"       ,0x467,
        "GetItemRect"               ,0x41D,
        "GetMaxSize"                ,0x453,             
        "GetMetrics"                ,0x465,
        "GetPadding"                ,0x456,
        "GetRect"                   ,0x433,
        "GetRows"                   ,0x428,             
        "GetState"                  ,0x412,
        "GetString"                 ,(StrLen(Chr(0xFFFF))?0x045B:0x045C),
        "GetStyle"                  ,0x439,
        "GetTextRows"               ,0x43D,             
        "HideButton"                ,0x404,
        "HitTest"                   ,0x445,
        "Indeterminate"             ,0x405,
        "InsertButton"              ,(StrLen(Chr(0xFFFF))?0x0443:0x0415),
        "IsButtonChecked"           ,0x40A,
        "IsButtonEnabled"           ,0x40A,             
        "IsButtonHidden"            ,0x40C,
        "IsButtonHighlighted"       ,0x40E,
        "IsButtonIndeterminate"     ,0x40D,
        "IsButtonPressed"           ,0x40B,
        "MakeButton"                ,0x406,
        "MoveButton"                ,0x452,
        "PressButton"               ,0x403,
        "SetAnchorHighlight"        ,0x449,             
        "SetBitmapSize"             ,0x420,
        "SetButtonInfo"             ,(StrLen(Chr(0xFFFF))?0x0440:0x0442),
        "SetButtonSize"             ,0x41F,
        "SetButtonWidth"            ,0x43B,             
        "SetDisabledImageList"      ,0x436,
        "SetExtendedStyle"          ,0x454,
        "SetHotImageList"           ,0x434,
        "SetHotItem"                ,0x448,
        "SetHotItem2"               ,0x45E,
        "SetImageList"              ,0x430,
        "SetIndent"                 ,0x42F,
        "SetListGap"                ,0x460,             
        "SetMaxTextRows"            ,0x43C,
        "SetMetrics"                ,0x466,             
        "SetPadding"                ,0x457,
        "SetPressedImageList"       ,0x468,             
        "SetRows"                   ,0x427,
        "SetState"                  ,0x411,             
        "SetStyle"                  ,0x438,
    )
    static Message := Map(
        "TB_GETBUTTON"              , 1047,
        "TB_BUTTONCOUNT"            , 1048,
        "TB_GETITEMRECT"            , 1053,                     
        "MEM_PHYSICAL"              , 4,
        "MEM_PROTECT"               , 0x40,                     
        "MEM_RELEASE"               , 0x8000,        
        "MEM_COMMIT"                , 4096,
        "MEM_RESERVE"               , 8192,
        ; "WM_NULL",0x0000
        ; "WM_CREATE" := 0x0001
        ; "WM_DESTROY" := 0x0002
        ; "WM_MOVE" := 0x0003
        ; "WM_SIZE" := 0x0005
        ; "WM_ACTIVATE" := 0x0006
        ; "WM_SETFOCUS" := 0x0007
        ; "WM_KILLFOCUS" := 0x0008
        ; "WM_ENABLE" := 0x000A
        ; "WM_SETREDRAW" := 0x000B
        ; "WM_SETTEXT" := 0x000C
        ; "WM_GETTEXT" := 0x000D
        ; "WM_GETTEXTLENGTH" := 0x000E
        ; "WM_PAINT" := 0x000F
        ; "WM_CLOSE" := 0x0010
        ; "WM_QUERYENDSESSION" := 0x0011
        ; "WM_QUIT" := 0x0012
        ; "WM_QUERYOPEN" := 0x0013
        ; "WM_ERASEBKGND" := 0x0014
        ; "WM_SYSCOLORCHANGE" := 0x0015
        ; "WM_ENDSESSION" := 0x0016
        ; "WM_SYSTEMERROR" := 0x0017
        ; "WM_SHOWWINDOW" := 0x0018
        ; "WM_CTLCOLOR" := 0x0019
        ; "WM_WININICHANGE" := 0x001A
        ; "WM_SETTINGCHANGE" := 0x001A
        ; "WM_DEVMODECHANGE" := 0x001B
        ; "WM_ACTIVATEAPP" := 0x001C
        ; "WM_FONTCHANGE" := 0x001D
        ; "WM_TIMECHANGE" := 0x001E
        ; "WM_CANCELMODE" := 0x001F
        ; "WM_SETCURSOR" := 0x0020
        ; "WM_MOUSEACTIVATE" := 0x0021
        ; "WM_CHILDACTIVATE" := 0x0022
        ; "WM_QUEUESYNC" := 0x0023
        ; "WM_GETMINMAXINFO" := 0x0024
        ; "WM_PAINTICON" := 0x0026
        ; "WM_ICONERASEBKGND" := 0x0027
        ; "WM_NEXTDLGCTL" := 0x0028
        ; "WM_SPOOLERSTATUS" := 0x002A
        ; "WM_DRAWITEM" := 0x002B
        ; "WM_MEASUREITEM" := 0x002C
        ; "WM_DELETEITEM" := 0x002D
        ; "WM_VKEYTOITEM" := 0x002E
        ; "WM_CHARTOITEM" := 0x002F

        ; "WM_SETFONT" := 0x0030
        ; "WM_GETFONT" := 0x0031
        ; "WM_SETHOTKEY" := 0x0032
        ; 'WM_GETHOTKEY' := 0x0033
        ; "WM_QUERYDRAGICON" := 0x0037
        ; "WM_COMPAREITEM" := 0x0039
        ; "WM_COMPACTING" := 0x0041
        ; "WM_WINDOWPOSCHANGING" := 0x0046
        ; "WM_WINDOWPOSCHANGED" := 0x0047
        ; "WM_POWER" := 0x0048
        ; "WM_COPYDATA" := 0x004A
        ; "WM_CANCELJOURNAL" := 0x004B
        ; "WM_NOTIFY" := 0x004E
        ; "WM_INPUTLANGCHANGEREQUEST" := 0x0050
        ; "WM_INPUTLANGCHANGE" := 0x0051
        ; "WM_TCARD" := 0x0052
        ; "WM_HELP" := 0x0053
        ; "WM_USERCHANGED" := 0x0054
        ; "WM_NOTIFYFORMAT" := 0x0055
        ; "WM_CONTEXTMENU" := 0x007B
        ; "WM_STYLECHANGING" := 0x007C
        ; "WM_STYLECHANGED" := 0x007D
        ; "WM_DISPLAYCHANGE" := 0x007E
        ; "WM_GETICON" := 0x007F
        ; "WM_SETICON" := 0x0080

        ; "WM_NCCREATE" := 0x0081
        ; "WM_NCDESTROY" := 0x0082
        ; "WM_NCCALCSIZE" := 0x0083
        ; "WM_NCHITTEST" := 0x0084
        ; "WM_NCPAINT" := 0x0085
        ; "WM_NCACTIVATE" := 0x0086
        ; "WM_GETDLGCODE" := 0x0087
        ; "WM_NCMOUSEMOVE" := 0x00A0
        ; "WM_NCLBUTTONDOWN" := 0x00A1
        ; "WM_NCLBUTTONUP" := 0x00A2
        ; "WM_NCLBUTTONDBLCLK" := 0x00A3
        ; "WM_NCRBUTTONDOWN" := 0x00A4
        ; "WM_NCRBUTTONUP" := 0x00A5
        ; "WM_NCRBUTTONDBLCLK" := 0x00A6
        ; "WM_NCMBUTTONDOWN" := 0x00A7
        ; "WM_NCMBUTTONUP" := 0x00A8
        ; "WM_NCMBUTTONDBLCLK" := 0x00A9

        ; "WM_KEYFIRST" := 0x0100
        ; "WM_KEYDOWN" := 0x0100
        ; "WM_KEYUP" := 0x0101
        ; "WM_CHAR" := 0x0102
        ; "WM_DEADCHAR" := 0x0103
        ; "WM_SYSKEYDOWN" := 0x0104
        ; "WM_SYSKEYUP" := 0x0105
        ; "WM_SYSCHAR" := 0x0106
        ; "WM_SYSDEADCHAR" := 0x0107
        ; "WM_KEYLAST" := 0x0108

        ; "WM_IME_STARTCOMPOSITION" := 0x010D
        ; "WM_IME_ENDCOMPOSITION" := 0x010E
        ; "WM_IME_COMPOSITION" := 0x010F
        ; "WM_IME_KEYLAST" := 0x010F

        ; "WM_INITDIALOG" := 0x0110
        ; "WM_COMMAND" := 0x0111
        ; "WM_SYSCOMMAND" := 0x0112
        ; "WM_TIMER" := 0x0113
        ; "WM_HSCROLL" := 0x0114
        ; "WM_VSCROLL" := 0x0115
        ; "WM_INITMENU" := 0x0116
        ; "WM_INITMENUPOPUP" := 0x0117
        ; "WM_MENUSELECT" := 0x011F
        ; "WM_MENUCHAR" := 0x0120
        ; "WM_ENTERIDLE" := 0x0121

        ; "WM_CTLCOLORMSGBOX" := 0x0132
        ; "WM_CTLCOLOREDIT" := 0x0133
        ; "WM_CTLCOLORLISTBOX" := 0x0134
        ; "WM_CTLCOLORBTN" := 0x0135
        ; "WM_CTLCOLORDLG" := 0x0136
        ; "WM_CTLCOLORSCROLLBAR" := 0x0137
        ; "WM_CTLCOLORSTATIC" := 0x0138

        ; "WM_MOUSEFIRST" := 0x0200
        ; "WM_MOUSEMOVE" := 0x0200
        ; "WM_LBUTTONDOWN" := 0x0201
        ; "WM_LBUTTONUP" := 0x0202
        ; "WM_LBUTTONDBLCLK" := 0x0203
        ; "WM_RBUTTONDOWN" := 0x0204
        ; "WM_RBUTTONUP" := 0x0205
        ; "WM_RBUTTONDBLCLK" := 0x0206
        ; "WM_MBUTTONDOWN" := 0x0207
        ; "WM_MBUTTONUP" := 0x0208
        ; "WM_MBUTTONDBLCLK" := 0x0209
        ; "WM_MOUSEWHEEL" := 0x020A
        ; "WM_MOUSEHWHEEL" := 0x020E

        ; WM_PARENTNOTIFY := 0x0210
        ; WM_ENTERMENULOOP := 0x0211
        ; WM_EXITMENULOOP := 0x0212
        ; WM_NEXTMENU := 0x0213
        ; WM_SIZING := 0x0214
        ; WM_CAPTURECHANGED := 0x0215
        ; WM_MOVING := 0x0216
        ; WM_POWERBROADCAST := 0x0218
        ; WM_DEVICECHANGE := 0x0219

        ; WM_MDICREATE := 0x0220
        ; WM_MDIDESTROY := 0x0221
        ; WM_MDIACTIVATE := 0x0222
        ; WM_MDIRESTORE := 0x0223
        ; WM_MDINEXT := 0x0224
        ; WM_MDIMAXIMIZE := 0x0225
        ; WM_MDITILE := 0x0226
        ; WM_MDICASCADE := 0x0227
        ; WM_MDIICONARRANGE := 0x0228
        ; WM_MDIGETACTIVE := 0x0229
        ; WM_MDISETMENU := 0x0230
        ; WM_ENTERSIZEMOVE := 0x0231
        ; WM_EXITSIZEMOVE := 0x0232
        ; WM_DROPFILES := 0x0233
        ; WM_MDIREFRESHMENU := 0x0234

        ; WM_IME_SETCONTEXT := 0x0281
        ; WM_IME_NOTIFY := 0x0282
        ; WM_IME_CONTROL := 0x0283
        ; WM_IME_COMPOSITIONFULL := 0x0284
        ; WM_IME_SELECT := 0x0285
        ; WM_IME_CHAR := 0x0286
        ; WM_IME_KEYDOWN := 0x0290
        ; WM_IME_KEYUP := 0x0291

        ; WM_MOUSEHOVER := 0x02A1
        ; WM_NCMOUSELEAVE := 0x02A2
        ; WM_MOUSELEAVE := 0x02A3

        ; WM_CUT := 0x0300
        ; WM_COPY := 0x0301
        ; WM_PASTE := 0x0302
        ; WM_CLEAR := 0x0303
        ; WM_UNDO := 0x0304

        ; WM_RENDERFORMAT := 0x0305
        ; WM_RENDERALLFORMATS := 0x0306
        ; WM_DESTROYCLIPBOARD := 0x0307
        ; WM_DRAWCLIPBOARD := 0x0308
        ; WM_PAINTCLIPBOARD := 0x0309
        ; WM_VSCROLLCLIPBOARD := 0x030A
        ; WM_SIZECLIPBOARD := 0x030B
        ; WM_ASKCBFORMATNAME := 0x030C
        ; WM_CHANGECBCHAIN := 0x030D
        ; WM_HSCROLLCLIPBOARD := 0x030E
        ; WM_QUERYNEWPALETTE := 0x030F
        ; WM_PALETTEISCHANGING := 0x0310
        ; WM_PALETTECHANGED := 0x0311

        ; WM_HOTKEY := 0x0312
        ; WM_PRINT := 0x0317
        ; WM_PRINTCLIENT := 0x0318

        ; WM_HANDHELDFIRST := 0x0358
        ; WM_HANDHELDLAST := 0x035F
        ; WM_PENWINFIRST := 0x0380
        ; WM_PENWINLAST := 0x038F
        ; WM_COALESCE_FIRST := 0x0390
        ; WM_COALESCE_LAST := 0x039F
        ; WM_DDE_FIRST := 0x03E0
        ; WM_DDE_INITIATE := 0x03E0
        ; WM_DDE_TERMINATE := 0x03E1
        ; WM_DDE_ADVISE := 0x03E2
        ; WM_DDE_UNADVISE := 0x03E3
        ; WM_DDE_ACK := 0x03E4
        ; WM_DDE_DATA := 0x03E5
        ; WM_DDE_REQUEST := 0x03E6
        ; WM_DDE_POKE := 0x03E7
        ; WM_DDE_EXECUTE := 0x03E8
        ; WM_DDE_LAST := 0x03E8

        ; WM_USER := 0x0400
        ; WM_APP := 0x8000
    )
    ;?  Constant Definitions    
    static Con := Map(
        "dwSize"                    ,32,
        "0"                         ,"DISABLED",
        "1"                         ,"CHECKED",
        "2"                         ,"CHECK",
        "6"                         ,"CHECKGROUP",
        "8"                         ,"HIDDEN",
        "PAGE_READWRITE"            , 4,
        "FILE_MAP_WRITE"            , 2,
    )
    ;?  Options ?
    static Options := Map(
        "TOOLTIPS"                  ,0x100, 
        "WRAPABLE"                  ,0x200,
        "FLAT"                      ,0x800,
        "LIST"                      ,0x1000,
        "TABSTOP"                   ,0x10000,
        "BORDER"                    ,0x800000,
        "BOTTOM"                    ,0x3,
        "ADJUSTABLE"                ,0x20,
        "NODIVIDER"                 ,0x40,
        "VERTICAL"                  ,0x80,
        "TEXTONLY"                  ,0,
        "SHOWTEXT"                  ,64,
        "WRAP"                      ,32,
        "AUTOSIZE"                  ,16,
        "NOPREFIX"                  ,32,
        "WHOLEDROPDOWN"             ,128,
        "DROPDOWN"                  ,8,
    )
    ;?  State ?
    static state := Map(    
        "DISABLED"                  ,0,
        "CHECKED"                   ,1,
        "CHECK"                     ,2,
        "CHECKGROUP"                ,6,
        "HIDDEN"                    ,8,
    )
    ;?  Terms and variable names
    Static Terms := Map(
        "hznTb"                     , "msvb_lib_toolbar",
        "hzn"                       , "Horizon",
        "btc"                       , "BUTTONCOUNT",
    )  
}