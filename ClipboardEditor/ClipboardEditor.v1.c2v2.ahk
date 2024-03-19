/************************************************************************
 * @description 
 * @file ClipboardEditor.v1.c2v2.ahk
 * @author 
 * @date 2024/01/15
 * @version 0.0.0
 ***********************************************************************/

#Requires Autohotkey v2.0
; REMOVED: #NoEnv
KeyHistory(0)
A_MaxHotkeysPerInterval := 200
ListLines(false)
DetectHiddenWindows(true)
SendMode("Input")
;REMOVED StringCaseSense, Off
FileEncoding()
Diag(strName, strData, strStartElapsedStop, blnForceForFirstStartup := false)
{
static s_intStartTick
static s_intStartFullTick
static s_intStartShowTick
static s_intStartCollectTick
if !(o_Settings.Launch.blnDiagMode.IniValue or blnForceForFirstStartup)
return
strNow := FormatTime(A_Now, "yyyyMMdd@HH:mm:ss")
strDiag := strNow . "." . A_MSec . "`t" . strName . "`t" . strData
if StrLen(strStartElapsedStop)
{
strDiag .= "`t" . strStartElapsedStop . "`t" . A_TickCount
if (strStartElapsedStop = "START-REFRESH")
s_intStartFullTick := A_TickCount
else if (strStartElapsedStop = "START-SHOW")
s_intStartShowTick := A_TickCount
else if (strStartElapsedStop = "START-COLLECT")
s_intStartCollectTick := A_TickCount
else if (strStartElapsedStop = "START")
s_intStartTick := A_TickCount
else if InStr(strStartElapsedStop, "-REFRESH")
{
intTicksAll := A_TickCount - s_intStartFullTick
strDiag .= "`t" . intTicksAll . "`t" . (intTicksAll > 500 ? "*FLAG1*" : "")
}
else if InStr(strStartElapsedStop, "-SHOW")
{
intTicksShow := A_TickCount - s_intStartShowTick
strDiag .= "`t" . intTicksShow . "`t" . (intTicksShow > 1000 ? "*FLAG2*" : "")
}
else if InStr(strStartElapsedStop, "-COLLECT")
{
intTicksCollect := A_TickCount - s_intStartCollectTick
strDiag .= "`t" . intTicksCollect . "`t" . (intTicksCollect > 2000 ? "*FLAG3*" : "")
}
else
{
intTicks := A_TickCount - s_intStartTick
strDiag .= "`t" . intTicks . "`t" . (intTicks > 2000 and (strStartElapsedStop ~= "ELAPSED") ? "*FLAG4*" : "")
}
}
strDiagFile := (blnForceForFirstStartup ? StrReplace(g_strDiagFile, "DIAG", "1st_STARTUP") : g_strDiagFile)
Loop {
	FileAppend(strDiag "`n", strDiagFile)
	if ErrorLevel
	Sleep(20)
}
until !ErrorLevel or (A_Index > 50)
if (strStartElapsedStop = "STOP")
s_intStartTick := ""
else if (strStartElapsedStop = "STOP-REFRESH")
s_intStartFullTick := ""
else if (strStartElapsedStop = "STOP-SHOW")
s_intStartShowTick := ""
else if (strStartElapsedStop = "STOP-COLLECT")
s_intStartCollectTick := ""
}
Url2Var(strUrl, blnBreakCache := true,  strReturn := "ResponseText", blnAsync := false)
{
if (blnBreakCache)
strUrl .= (InStr(strUrl, "?") ? "&" : "?") . "cache-breaker=" . A_NowUTC
Loop Parse, "MSXML2.XMLHTTP.6.0|WinHttp.WinHttpRequest.5.1", "|"
{
oHttpRequest := ComObject(A_LoopField)
oHttpRequest.Open("GET", strUrl, blnAsync)
oHttpRequest.SetRequestHeader("Pragma", "no-cache")
oHttpRequest.SetRequestHeader("Cache-Control", "no-cache, no-store")
oHttpRequest.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")
oHttpRequest.Send()
blnTimeout := false
While (blnAsync and oHttpRequest.ReadyState and oHttpRequest.ReadyState == 4) {
	if (oHttpRequest.Status() = 404){
		break
	}
	Sleep(100)
	if (A_Index > 100) {
		blnTimeout := true
		break
	}
	}
	if (oHttpRequest.StatusText() = "OK" and StrLen(oHttpRequest.ResponseText())) or (oHttpRequest.Status() = 404){
		break
	}
}
if (strReturn = "ResponseText")
return (blnTimeout ? "timeout" : oHttpRequest.ResponseText())
else if (strReturn = "Status")
return (blnTimeout ? -1 : oHttpRequest.Status())
}
Url2File(strUrl, strFile, &intStatus, blnAsync := false)
{
Loop Parse, "MSXML2.XMLHTTP.6.0|WinHttp.WinHttpRequest.5.1", "|"
{
oHttpRequest := ComObject(A_LoopField)
oHttpRequest.Open("GET", strUrl, blnAsync)
oHttpRequest.OnReadyStateChange := Url2FileSave.Bind(oHttpRequest, strFile)
oHttpRequest.SetRequestHeader("Pragma", "no-cache")
oHttpRequest.SetRequestHeader("Cache-Control", "no-cache, no-store")
oHttpRequest.SetRequestHeader("If-Modified-Since", "Sat, 1 Jan 2000 00:00:00 GMT")
oHttpRequest.Send()
blnTimeout := false
While (blnAsync and oHttpRequest.ReadyState  == 4) {
		if (oHttpRequest.Status() = 404){
			break
		}
		Sleep(100)
		if (A_Index > 100) {
			blnTimeout := true
			break
		}
	}
	if (oHttpRequest.StatusText() = "OK" or oHttpRequest.Status() = 404){
		break
	}
}
intStatus := (blnTimeout ? -1 : oHttpRequest.Status())
return (intStatus = 200)
}
Url2FileSave(oHttpRequest, strFile)
{
if (oHttpRequest.ReadyState  == 4)
return
if (oHttpRequest.Status = 200)
{
saResponseBody := oHttpRequest.ResponseBody
intPData := NumGet(ComObjValue(saResponseBody) + 8 + A_PtrSize, "UPtr")
intLen := saResponseBody.MaxIndex() + 1
FileOpen(strFile, "w").RawWrite(intPData + 0, intLen)
}
}
Edit_ActivateParent(hEdit)
{
hParent:=DllCall("GetParent", "Ptr", hEdit, "Ptr")
if !WinActive("ahk_id " hParent)
{
WinActivate("ahk_id " hParent)
if !WinActive("ahk_id " hParent)
{
ErrorLevel := WinWaitActive("ahk_id " hParent, , 0.25) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
if ErrorLevel
Return False
}
}
Return True
}
Edit_CanUndo(hEdit)
{
Static EM_CANUNDO:=0xC6
ErrorLevel := SendMessage(EM_CANUNDO, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_CharFromPos(hEdit,X,Y,&r_CharPos:="",&r_LineIdx:="")
{
Static Dummy3902,EM_CHARFROMPOS        :=0xD7,EM_GETFIRSTVISIBLELINE:=0xCE,EM_LINEINDEX          :=0xBB
ErrorLevel := SendMessage(EM_CHARFROMPOS, 0, (Y<<16)|X, , "ahk_id " hEdit)
if (ErrorLevel<<32>>32=-1)
{
r_CharPos:=-1
r_LineIdx:=-1
Return -1
}
r_CharPos:=ErrorLevel&0xFFFF
r_LineIdx:=ErrorLevel>>16
ErrorLevel := SendMessage(EM_GETFIRSTVISIBLELINE, 0, 0, , "ahk_id " hEdit)
FirstLine:=ErrorLevel-1
if (FirstLine>r_LineIdx)
r_LineIdx:=r_LineIdx+(65536*Floor((FirstLine+(65535-r_LineIdx))/65536))
ErrorLevel := SendMessage(EM_LINEINDEX, (FirstLine<0) ? 0:FirstLine, 0, , "ahk_id " hEdit)
FirstCharPos:=ErrorLevel
if (FirstCharPos>r_CharPos)
r_CharPos:=r_CharPos+(65536*Floor((FirstCharPos+(65535-r_CharPos))/65536))
Return r_CharPos
}
Edit_Clear(hEdit)
{
Static WM_CLEAR:=0x303
ErrorLevel := SendMessage(WM_CLEAR, 0, 0, , "ahk_id " hEdit)
}
Edit_ContainsSoftLineBreaks(hEdit)
{
if not Edit_IsWordWrap(hEdit)
Return FALSE
Edit_FmtLines(hEdit,True)
l_FormattedText:=Edit_GetText(hEdit)
Edit_FmtLines(hEdit,False)
if (l_FormattedText ~= "i)(`r`r`n)")
Return True
Return False
}
Edit_Convert2DOS(p_Text)
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`r`n", "`n")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`r", "`n")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`n", "`r`n")
Return p_Text
}
Edit_Convert2Mac(p_Text)
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`r`n", "`r")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`n", "`r")
if StrLen(p_Text)
if (SubStr(p_Text, -1) ="`r")
p_Text.="`r"
Return p_Text
}
Edit_Convert2Unix(p_Text)
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`r`n", "`n")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
p_Text := StrReplace(p_Text, "`r", "`n")
if StrLen(p_Text)
if (SubStr(p_Text, -1) ="`n")
p_Text.="`n"
Return p_Text
}
Edit_ConvertCase(hEdit,p_Case)
{
p_Case := StrTitle(p_Case)
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
if (l_StartSelPos=l_EndSelPos)
Return
l_SelectedText:=Edit_GetSelText(hEdit)
if isSpace(l_SelectedText)
Return
if (p_Case ~= "^(?i:U|Upper|Uppercase)$")
l_SelectedText := StrUpper(l_SelectedText)
else
if (p_Case ~= "^(?i:L|Lower|Lowercase)$")
l_SelectedText := StrLower(l_SelectedText)
else
if (p_Case ~= "^(?i:C|Capitalize|Title|Titlecase)$")
l_SelectedText := StrTitle(l_SelectedText)
else
if (p_Case ~= "^(?i:S|Sentence|Sentencecase)$")
{
l_SelectedText := StrLower(l_SelectedText)
l_SelectedText:=RegExReplace(l_SelectedText, "((?:^|[.!?]\s+)[a-z])", "$u1")
}
else
if (p_Case ~= "^(?i:T|Toggle|Togglecase|I|Invert|Invertcase)$")
{
t_SelectedText:=""
Loop Parse, l_SelectedText
{
t_Char:=A_LoopField
if isUpper(t_Char)
t_Char := StrLower(t_Char)
else
if isLower(t_Char)
t_Char := StrUpper(t_Char)
t_SelectedText.=t_Char
}
l_SelectedText:=t_SelectedText
}
Edit_ReplaceSel(hEdit,l_SelectedText)
Edit_SetSel(hEdit,l_StartSelPos,l_EndSelPos)
}
Edit_Copy(hEdit)
{
Static WM_COPY:=0x301
ErrorLevel := SendMessage(WM_COPY, 0, 0, , "ahk_id " hEdit)
}
Edit_Cut(hEdit)
{
Static WM_CUT:=0x300
ErrorLevel := SendMessage(WM_CUT, 0, 0, , "ahk_id " hEdit)
}
Edit_Disable(hEdit){
	; ControlSetEnabled(0,hEdit,"ahk_id " hEdit)
	; Return ErrorLevel ? False:True
	return ControlSetEnabled(0,hEdit,"ahk_id " hEdit)
}
Edit_DisableAllScrollBars(hEdit)
{
Static SB_BOTH:=3,ESB_DISABLE_BOTH:=0x3
Return Edit_EnableScrollBar(hEdit,SB_BOTH,ESB_DISABLE_BOTH)
}
Edit_DisableHScrollBar(hEdit)
{
Static SB_HORZ:=0,ESB_DISABLE_BOTH:=0x3
Return Edit_EnableScrollBar(hEdit,SB_HORZ,ESB_DISABLE_BOTH)
}
Edit_DisableVScrollBar(hEdit)
{
Static SB_VERT:=1,ESB_DISABLE_BOTH:=0x3
Return Edit_EnableScrollBar(hEdit,SB_VERT,ESB_DISABLE_BOTH)
}
Edit_EmptyUndoBuffer(hEdit){
	Static EM_EMPTYUNDOBUFFER:=0xCD
	; ErrorLevel := SendMessage(EM_EMPTYUNDOBUFFER, 0, 0, , "ahk_id " hEdit)
	return SendMessage(EM_EMPTYUNDOBUFFER, 0, 0, , "ahk_id " hEdit)
}
Edit_Enable(hEdit){
; ControlSetEnabled(1,hEdit,"ahk_id " hEdit)
; Return ErrorLevel ? False:True
	return ControlSetEnabled(1,hEdit,"ahk_id " hEdit)
}
Edit_EnableAllScrollBars(hEdit){
	Static SB_BOTH:=3,ESB_ENABLE_BOTH:=0x0
	Return Edit_EnableScrollBar(hEdit,SB_BOTH,ESB_ENABLE_BOTH)
}
Edit_EnableHScrollBar(hEdit){
	Static SB_HORZ:=0,ESB_ENABLE_BOTH:=0x0
	Return Edit_EnableScrollBar(hEdit,SB_HORZ,ESB_ENABLE_BOTH)
}
Edit_EnableVScrollBar(hEdit){
	Static SB_VERT:=1,ESB_ENABLE_BOTH:=0x0
	Return Edit_EnableScrollBar(hEdit,SB_VERT,ESB_ENABLE_BOTH)
}
Edit_EnableScrollBar(hEdit,wSBflags,wArrows) {
	Static Dummy5401,SB_HORZ:=0,SB_VERT:=1,SB_CTL:=2,SB_BOTH:=3,ESB_ENABLE_BOTH:=0x0,ESB_DISABLE_LEFT:=0x1,ESB_DISABLE_BOTH:=0x3,ESB_DISABLE_DOWN:=0x2,ESB_DISABLE_UP:=0x1,ESB_DISABLE_LTUP:=0x1,ESB_DISABLE_RIGHT:=0x2,ESB_DISABLE_RTDN:=0x2
	RC:=DllCall("EnableScrollBar", "Ptr", hEdit, "UInt", wSBflags, "UInt", wArrows)
	Return RC ? True:False
}
Edit_FindText(hEdit,p_SearchText,p_Min:=0,p_Max:=-1,p_Flags:="",&r_RegExOut:=""){
	Static s_Text
	r_RegExOut:=""
	if InStr(p_Flags, "Reset")
	s_Text:=""
	if not StrLen(p_SearchText)
	Return -1
	l_MaxLen:=Edit_GetTextLength(hEdit)
	if (l_MaxLen=0)
		Return -1
	if (p_Min<0 or p_Max>l_MaxLen)
		p_Min:=l_MaxLen
	if (p_Max<0 or p_Max>l_MaxLen)
		p_Max:=l_MaxLen
	if (p_Min=p_Max)
		Return -1
	if InStr(p_Flags, "Static"){
		if not StrLen(s_Text)
			s_Text:=Edit_GetText(hEdit)
			l_Text:=SubStr(s_Text, ((p_Max>p_Min) ? p_Min+1:p_Max+1)<1 ? ((p_Max>p_Min) ? p_Min+1:p_Max+1)-1 : ((p_Max>p_Min) ? p_Min+1:p_Max+1), (p_Max>p_Min) ? p_Max:p_Min)
}
else {
	s_Text:=""
	l_Text:=Edit_GetTextRange(hEdit,(p_Max>p_Min) ? p_Min:p_Max,(p_Max>p_Min) ? p_Max:p_Min)
}
if not InStr(p_Flags, "RegEx"){
	l_FoundPos:=InStr(l_Text, p_SearchText, InStr(p_Flags, "MatchCase"), ((p_Max>p_Min) ? 1:0)<1 ? ((p_Max>p_Min) ? 1:0)-1 : ((p_Max>p_Min) ? 1:0))-1
}
else{
	p_SearchText:=RegExReplace(p_SearchText, "^P\)?", "", &1)
	if (p_Max>p_Min) {
		l_FoundPos:=RegExMatch(l_Text, p_SearchText, &r_RegExOut, 1)-1
if ErrorLevel
{
OutputDebug("
                   (ltrim join`s
                    Function: " A_ThisFunc " - RegExMatch error.
                    ErrorLevel=" ErrorLevel "
)")
l_FoundPos:=-1
}
}
else
{
RE_MinPos     :=1
RE_MaxPos     :=StrLen(l_Text)
RE_StartPos   :=RE_MinPos
Saved_FoundPos:=-1
Saved_RegExOut:=""
Loop
{
l_FoundPos:=RegExMatch(l_Text, p_SearchText, &r_RegExOut, (RE_StartPos)<1 ? (RE_StartPos)-1 : (RE_StartPos))-1
if ErrorLevel
{
OutputDebug("
                       (ltrim join`s
                        Function: " A_ThisFunc " - RegExMatch error.
                        ErrorLevel=" ErrorLevel "
)")
l_FoundPos:=-1
Break
}
if (l_FoundPos>-1)
{
Saved_FoundPos:=l_FoundPos
Saved_RegExOut:=r_RegExOut[0]
RE_MinPos     :=l_FoundPos+2
}
else
RE_MaxPos:=RE_StartPos-1
if (RE_MinPos>RE_MaxPos or RE_MinPos>StrLen(l_Text))
{
l_FoundPos:=Saved_FoundPos
r_RegExOut:=Saved_RegExOut
Break
}
RE_StartPos:=RE_MinPos+Floor((RE_MaxPos-RE_MinPos)/2)
}
}
}
if (l_FoundPos>-1)
l_FoundPos+=(p_Max>p_Min) ? p_Min:p_Max
Return l_FoundPos
}
Edit_FindTextReset()
{
Edit_FindText("","",0,0,"Reset")
}
Edit_FmtLines(hEdit,p_Flag)
{
Static EM_FMTLINES:=0xC8
ErrorLevel := SendMessage(EM_FMTLINES, p_Flag, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetActiveHandles(&hEdit:="",&hWindow:="",p_MsgBox:=False)
{
hWindow := WinGetID("A")
l_Control := ControlGetClassNN(ControlGetFocus("A"))
if (SubStr(l_Control, 1, 4)="Edit")
{
hEdit := ControlGethWnd(l_Control, "A")
Return hEdit
}
if p_MsgBox
MsgBox("This request cannot be performed on this control.  " A_Space, "Error", 262160)
Return False
}
Edit_GetComboBoxEdit(hCombo)
{
cbSize:=(A_PtrSize=8) ? 64:52
COMBOBOXINFO := Buffer(cbSize, 0) ; V1toV2: if 'COMBOBOXINFO' is a UTF-16 string, use 'VarSetStrCapacity(&COMBOBOXINFO, cbSize)'
NumPut("UInt", cbSize, COMBOBOXINFO, 0)
DllCall("GetComboBoxInfo", "Ptr", hCombo, "Ptr", COMBOBOXINFO)
Return NumGet(COMBOBOXINFO, (A_PtrSize=8) ? 48:44, "Ptr")
}
Edit_GetCueBanner(hEdit,p_MaxSize:=1024)
{
Static EM_GETCUEBANNER:=0x1502
wText := Buffer(p_MaxSize*(1 ? 2:1), 0) ; V1toV2: if 'wText' is a UTF-16 string, use 'VarSetStrCapacity(&wText, p_MaxSize*(A_IsUnicode ? 2:1))'
ErrorLevel := SendMessage(EM_GETCUEBANNER, &wText, p_MaxSize, , "ahk_id " hEdit)
if ErrorLevel
Return 1 ? wText:StrGet(&wText,-1,"UTF-16")
}
Edit_GetFirstVisibleLine(hEdit)
{
Static EM_GETFIRSTVISIBLELINE:=0xCE
ErrorLevel := SendMessage(EM_GETFIRSTVISIBLELINE, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetFont(hEdit)
{
Static WM_GETFONT:=0x31
ErrorLevel := SendMessage(WM_GETFONT, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetLastVisibleLine(hEdit)
{
Edit_GetRect(hEdit,Left,Top,Right,Bottom)
Return Edit_LineFromPos(hEdit,0,Bottom-1)
}
Edit_GetLimitText(hEdit)
{
Static EM_GETLIMITTEXT:=0xD5
ErrorLevel := SendMessage(EM_GETLIMITTEXT, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetLine(hEdit,p_LineIdx:=-1,p_Length:=-1)
{
Static EM_GETLINE:=0xC4
if (p_LineIdx<0)
p_LineIdx:=Edit_LineFromChar(hEdit,Edit_LineIndex(hEdit))
l_TCHARs:=(p_Length<0) ? Edit_LineLength(hEdit,p_LineIdx):p_Length
if (l_TCHARs=0)
Return
nSize:=1 ? l_TCHARs*2:(l_TCHARs=1) ? 2:l_TCHARs
l_Text := Buffer(nSize, 0) ; V1toV2: if 'l_Text' is a UTF-16 string, use 'VarSetStrCapacity(&l_Text, nSize)'
NumPut("UShort", (l_TCHARs=1) ? 2:l_TCHARs, l_Text, 0)
if (type(l_Text)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_GETLINE, p_LineIdx, l_Text, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_GETLINE, p_LineIdx, StrPtr(l_Text), , "ahk_id " hEdit)
}
Return SubStr(l_Text, 1, l_TCHARs)
}
Edit_GetLineCount(hEdit)
{
Static EM_GETLINECOUNT:=0xBA
ErrorLevel := SendMessage(EM_GETLINECOUNT, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetMargins(hEdit,&r_LeftMargin:="",&r_RightMargin:="")
{
Static EM_GETMARGINS:=0xD4
ErrorLevel := SendMessage(EM_GETMARGINS, 0, 0, , "ahk_id " hEdit)
r_LeftMargin :=ErrorLevel&0xFFFF
r_RightMargin:=ErrorLevel>>16
Return r_LeftMargin
}
Edit_GetModify(hEdit)
{
Static EM_GETMODIFY:=0xB8
ErrorLevel := SendMessage(EM_GETMODIFY, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetPasswordChar(hEdit)
{
Static EM_GETPASSWORDCHAR:=0xD2
Return DllCall("SendMessageW", "Ptr", hEdit, "UInt", EM_GETPASSWORDCHAR, "UInt", 0, "UInt", 0)
}
Edit_GetPos(hEdit,&X:="",&Y:="",&W:="",&H:="")
{
RECT := Buffer(16, 0) ; V1toV2: if 'RECT' is a UTF-16 string, use 'VarSetStrCapacity(&RECT, 16)'
DllCall("GetWindowRect", "Ptr", hEdit, "Ptr", RECT)
W:=NumGet(RECT, 8, "Int")-NumGet(RECT, 0, "Int")
H:=NumGet(RECT, 12, "Int")-NumGet(RECT, 4, "Int")
DllCall("ScreenToClient", "Ptr", DllCall("GetParent", "Ptr", hEdit, "Ptr"), "Ptr", RECT)
X:=NumGet(RECT, 0, "Int")
Y:=NumGet(RECT, 4, "Int")
}
Edit_GetRect(hEdit,&r_Left:="",&r_Top:="",&r_Right:="",&r_Bottom:="")
{
Static EM_GETRECT:=0xB2,RECT
RECT := Buffer(16, 0) ; V1toV2: if 'RECT' is a UTF-16 string, use 'VarSetStrCapacity(&RECT, 16)'
if (type(RECT)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_GETRECT, 0, RECT, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_GETRECT, 0, StrPtr(RECT), , "ahk_id " hEdit)
}
r_Left  :=NumGet(RECT, 0, "Int")
r_Top   :=NumGet(RECT, 4, "Int")
r_Right :=NumGet(RECT, 8, "Int")
r_Bottom:=NumGet(RECT, 12, "Int")
Return &RECT
}
Edit_GetScrollBarInfo(hEdit,idObject)
{
Static Dummy4820,SCROLLBARINFO,OBJID_HSCROLL:=0xFFFFFFFA,OBJID_VSCROLL:=0xFFFFFFFB,OBJID_CLIENT :=0xFFFFFFFC,STATE_SYSTEM_UNAVAILABLE:=0x1,STATE_SYSTEM_PRESSED    :=0x8,STATE_SYSTEM_INVISIBLE  :=0x8000,STATE_SYSTEM_OFFSCREEN  :=0x10000
SCROLLBARINFO := Buffer(60, 0) ; V1toV2: if 'SCROLLBARINFO' is a UTF-16 string, use 'VarSetStrCapacity(&SCROLLBARINFO, 60)'
NumPut("UInt", 60, SCROLLBARINFO, 0)
DllCall("GetScrollBarInfo", "Ptr", hEdit, "Int", idObject, "Ptr", SCROLLBARINFO)
Return &SCROLLBARINFO
}
Edit_GetScrollBarState(hEdit,idObject)
{
Static Dummy8290,OBJID_HSCROLL:=0xFFFFFFFA,OBJID_VSCROLL:=0xFFFFFFFB,OBJID_CLIENT :=0xFFFFFFFC,STATE_SYSTEM_UNAVAILABLE:=0x1,STATE_SYSTEM_PRESSED    :=0x8,STATE_SYSTEM_INVISIBLE  :=0x8000,STATE_SYSTEM_OFFSCREEN  :=0x10000
SCROLLBARINFO := Buffer(60, 0) ; V1toV2: if 'SCROLLBARINFO' is a UTF-16 string, use 'VarSetStrCapacity(&SCROLLBARINFO, 60)'
NumPut("UInt", 60, SCROLLBARINFO, 0)
DllCall("GetScrollBarInfo", "Ptr", hEdit, "Int", idObject, "Ptr", SCROLLBARINFO)
Return NumGet(SCROLLBARINFO, 36, "UInt")
}
Edit_GetSel(hEdit,&r_StartSelPos:="",&r_EndSelPos:="")
{
Static Dummy3304,s_StartSelPos,s_EndSelPos,Dummy1:=s_StartSelPos := Buffer(4, 0),Dummy2:=s_EndSelPos := Buffer(4, 0),EM_GETSEL:=0xB0 ; V1toV2: if 's_EndSelPos' is a UTF-16 string, use 'VarSetStrCapacity(&s_EndSelPos, 4)'
if (type(s_EndSelPos)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_GETSEL, &s_StartSelPos, s_EndSelPos, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_GETSEL, &s_StartSelPos, StrPtr(s_EndSelPos), , "ahk_id " hEdit)
}
r_StartSelPos:=NumGet(s_StartSelPos, 0, "UInt")
r_EndSelPos  :=NumGet(s_EndSelPos, 0, "UInt")
Return r_StartSelPos
}
Edit_GetSelText(hEdit)
{
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
if (l_StartSelPos=l_EndSelPos)
Return
l_FirstSelectedLine:=Edit_LineFromChar(hEdit,l_StartSelPos)
l_LastSelectedLine :=Edit_LineFromChar(hEdit,l_EndSelPos)
l_FirstPos:=Edit_LineIndex(hEdit,l_FirstSelectedLine)
if (l_FirstSelectedLine=l_LastSelectedLine)
and (l_EndSelPos<=l_FirstPos+Edit_LineLength(hEdit,l_FirstSelectedLine))
Return SubStr(Edit_GetLine(hEdit,l_FirstSelectedLine,l_EndSelPos-l_FirstPos), (l_StartSelPos-l_FirstPos+1)<1 ? (l_StartSelPos-l_FirstPos+1)-1 : (l_StartSelPos-l_FirstPos+1))
else
Return SubStr(Edit_GetText(hEdit,l_EndSelPos), (l_StartSelPos+1)<1 ? (l_StartSelPos+1)-1 : (l_StartSelPos+1))
}
Edit_GetStyle(hEdit)
{
l_Style := ControlGetStyle(, "ahk_id " hEdit)
Return l_Style
}
Edit_GetText(hEdit,p_Length:=-1)
{
Static WM_GETTEXT:=0xD
if (p_Length<0)
p_Length:=Edit_GetTextLength(hEdit)
l_Text := Buffer(p_Length*(1 ? 2:1)+1, 0) ; V1toV2: if 'l_Text' is a UTF-16 string, use 'VarSetStrCapacity(&l_Text, p_Length*(A_IsUnicode ? 2:1)+1)'
if (type(l_Text)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(WM_GETTEXT, p_Length+1, l_Text, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(WM_GETTEXT, p_Length+1, StrPtr(l_Text), , "ahk_id " hEdit)
}
Return l_Text
}
Edit_GetTextLength(hEdit)
{
Static WM_GETTEXTLENGTH:=0xE
ErrorLevel := SendMessage(WM_GETTEXTLENGTH, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_GetTextRange(hEdit,p_Min:=0,p_Max:=-1)
{
Return SubStr(Edit_GetText(hEdit,p_Max), (p_Min+1)<1 ? (p_Min+1)-1 : (p_Min+1))
}
Edit_HasFocus(hEdit)
{
Static Dummy7291,GUITHREADINFO,cbSize:=(A_PtrSize=8) ? 72:48,Dummy1:=VarSetStrCapacity(&GUITHREADINFO, cbSize),Dummy2:=NumPut("UInt", cbSize, GUITHREADINFO, 0) ; V1toV2: if 'GUITHREADINFO' is NOT a UTF-16 string, use 'GUITHREADINFO := Buffer(cbSize)'
if not DllCall("GetGUIThreadInfo", "UInt", 0, "Ptr", GUITHREADINFO)
{
OutputDebug("
           (ltrim join`s
            Function: " A_ThisFunc " -
            DllCall to `"GetGUIThreadInfo`" API failed. A_LastError=" A_LastError "
)")
Return False
}
Return (hEdit=NumGet(GUITHREADINFO, (A_PtrSize=8) ? 16:12, "Ptr"))
}
Edit_Hide(hEdit)
{
ControlHide(,"ahk_id " hEdit)
Return ErrorLevel ? False:True
}
Edit_HideAllScrollBars(hEdit)
{
Static SB_BOTH:=3
Return Edit_ShowScrollBar(hEdit,SB_BOTH,False)
}
Edit_HideBalloonTip(hEdit)
{
Static EM_HIDEBALLOONTIP:=0x1504
ErrorLevel := SendMessage(EM_HIDEBALLOONTIP, 0, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_HideHScrollBar(hEdit)
{
Static SB_HORZ:=0
Return Edit_ShowScrollBar(hEdit,SB_HORZ,False)
}
Edit_HideVScrollBar(hEdit)
{
Static SB_VERT:=1
Return Edit_ShowScrollBar(hEdit,SB_VERT,False)
}
Edit_IsDisabled(hEdit)
{
Static WS_DISABLED:=0x8000000
Return Edit_GetStyle(hEdit) & WS_DISABLED ? True:False
}
Edit_IsHScrollBarEnabled(hEdit)
{
Static OBJID_HSCROLL:=0xFFFFFFFA,STATE_SYSTEM_UNAVAILABLE:=0x1
Return Edit_GetScrollBarState(hEdit,OBJID_HSCROLL) & STATE_SYSTEM_UNAVAILABLE ? False:True
}
Edit_IsHScrollBarVisible(hEdit)
{
Static OBJID_HSCROLL:=0xFFFFFFFA,STATE_SYSTEM_INVISIBLE:=0x8000,STATE_SYSTEM_OFFSCREEN:=0x10000
Return Edit_GetScrollBarState(hEdit,OBJID_HSCROLL) & (STATE_SYSTEM_INVISIBLE|STATE_SYSTEM_OFFSCREEN) ? False:True
}
Edit_IsMultiline(hEdit)
{
Static ES_MULTILINE:=0x4
Return Edit_GetStyle(hEdit) & ES_MULTILINE ? True:False
}
Edit_IsReadOnly(hEdit)
{
Static ES_READONLY:=0x800
Return Edit_GetStyle(hEdit) & ES_READONLY ? True:False
}
Edit_IsStyle(hEdit,p_Style)
{
Return Edit_GetStyle(hEdit) & p_Style ? True:False
}
Edit_IsVScrollBarEnabled(hEdit)
{
Static OBJID_VSCROLL:=0xFFFFFFFB,STATE_SYSTEM_UNAVAILABLE:=0x1
Return Edit_GetScrollBarState(hEdit,OBJID_VSCROLL) & STATE_SYSTEM_UNAVAILABLE ? False:True
}
Edit_IsVScrollBarVisible(hEdit)
{
Static OBJID_VSCROLL:=0xFFFFFFFB,STATE_SYSTEM_INVISIBLE:=0x8000,STATE_SYSTEM_OFFSCREEN:=0x10000
Return Edit_GetScrollBarState(hEdit,OBJID_VSCROLL) & (STATE_SYSTEM_INVISIBLE|STATE_SYSTEM_OFFSCREEN) ? False:True
}
Edit_IsWordWrap(hEdit)
{
Static Dummy8256,ES_LEFT       :=0x0,ES_CENTER     :=0x1,ES_RIGHT      :=0x2,ES_MULTILINE  :=0x4,ES_AUTOHSCROLL:=0x80,WS_HSCROLL    :=0x100000
l_Style:=Edit_GetStyle(hEdit)
if not (l_Style & ES_MULTILINE)
Return False
if l_Style & (ES_CENTER|ES_RIGHT)
Return True
if l_Style & ES_AUTOHSCROLL
Return False
if l_Style & WS_HSCROLL
Return False
Return True
}
Edit_LineFromChar(hEdit,p_CharPos:=-1)
{
Static EM_LINEFROMCHAR:=0xC9
ErrorLevel := SendMessage(EM_LINEFROMCHAR, p_CharPos, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_LineFromPos(hEdit,X,Y,&r_CharPos:="",&r_LineIdx:="")
{
Edit_CharFromPos(hEdit,X,Y,r_CharPos,r_LineIdx)
Return r_LineIdx
}
Edit_LineIndex(hEdit,p_LineIdx:=-1)
{
Static EM_LINEINDEX:=0xBB
ErrorLevel := SendMessage(EM_LINEINDEX, p_LineIdx, 0, , "ahk_id " hEdit)
Return ErrorLevel<<32>>32
}
Edit_LineLength(hEdit,p_LineIdx:=-1)
{
Static EM_LINELENGTH:=0xC1
l_CharPos:=Edit_LineIndex(hEdit,p_LineIdx)
if (l_CharPos<0)
l_CharPos:=Edit_LineIndex(hEdit,Edit_GetTextLength(hEdit)-1)
ErrorLevel := SendMessage(EM_LINELENGTH, l_CharPos, 0, , "ahk_id " hEdit)
Return ErrorLevel
}
Edit_LineScroll(hEdit,xScroll:=0,yScroll:=0)
{
Static Dummy3496,SB_LEFT :=6,SB_RIGHT:=7,SB_TOP   :=6,SB_BOTTOM:=7,EM_LINESCROLL:=0xB6,WM_HSCROLL   :=0x114,WM_VSCROLL   :=0x115
if isInteger(xScroll)
{
if xScroll
ErrorLevel := SendMessage(EM_LINESCROLL, xScroll, 0, , "ahk_id " hEdit)
}
else
Loop Parse, xScroll, A_Space
{
if InStr(A_LoopField, "Left")
ErrorLevel := SendMessage(WM_HSCROLL, SB_LEFT, 0, , "ahk_id " hEdit)
else if InStr(A_LoopField, "Right")
ErrorLevel := SendMessage(WM_HSCROLL, SB_RIGHT, 0, , "ahk_id " hEdit)
else if InStr(A_LoopField, "Top")
ErrorLevel := SendMessage(WM_VSCROLL, SB_TOP, 0, , "ahk_id " hEdit)
else if InStr(A_LoopField, "Bottom")
ErrorLevel := SendMessage(WM_VSCROLL, SB_BOTTOM, 0, , "ahk_id " hEdit)
}
if isInteger(yScroll)
{
if yScroll
ErrorLevel := SendMessage(EM_LINESCROLL, 0, yScroll, , "ahk_id " hEdit)
}
else
Loop Parse, yScroll, A_Space
{
if InStr(A_LoopField, "Left")
ErrorLevel := SendMessage(WM_HSCROLL, SB_LEFT, 0, , "ahk_id " hEdit)
else if InStr(A_LoopField, "Right")
ErrorLevel := SendMessage(WM_HSCROLL, SB_RIGHT, 0, , "ahk_id " hEdit)
else if InStr(A_LoopField, "Top")
ErrorLevel := SendMessage(WM_VSCROLL, SB_TOP, 0, , "ahk_id " hEdit)
else if InStr(A_LoopField, "Bottom")
ErrorLevel := SendMessage(WM_VSCROLL, SB_BOTTOM, 0, , "ahk_id " hEdit)
}
}
Edit_LoadFile(hEdit,p_File,p_Convert2DOS:=False,&r_EOLFormat:="")
{
RC:=Edit_ReadFile(hEdit,p_File,A_FileEncoding,p_Convert2DOS,r_EOLFormat)
Return (RC>-1) ? True:False
}
Edit_MouseInSelection(hEdit)
{
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
if (l_StartSelPos=l_EndSelPos)
Return False
POINT := Buffer(8, 0) ; V1toV2: if 'POINT' is a UTF-16 string, use 'VarSetStrCapacity(&POINT, 8)'
DllCall("GetCursorPos", "Ptr", POINT)
DllCall("ScreenToClient", "Ptr", hEdit, "Ptr", POINT)
l_CharPos:=Edit_CharFromPos(hEdit,NumGet(POINT, 0, "Int"),NumGet(POINT, 4, "Int"))
Return (l_CharPos>=l_StartSelPos and l_CharPos<=l_EndSelPos) ? True:False
}
Edit_Paste(hEdit)
{
Static WM_PASTE:=0x302
ErrorLevel := SendMessage(WM_PASTE, 0, 0, , "ahk_id " hEdit)
}
Edit_PosFromChar(hEdit,p_CharPos,&X:="",&Y:="")
{
Static Dummy5026,POINT,EM_POSFROMCHAR:=0xD6
POINT := Buffer(8, 0) ; V1toV2: if 'POINT' is a UTF-16 string, use 'VarSetStrCapacity(&POINT, 8)'
ErrorLevel := SendMessage(EM_POSFROMCHAR, p_CharPos, 0, , "ahk_id " hEdit)
NumPut("Int", X:=(ErrorLevel&0xFFFF)<<48>>48, POINT, 0)
NumPut("Int", Y:=(ErrorLevel>>16)<<48>>48, POINT, 0)
Return &POINT
}
Edit_ReadFile(hEdit,p_File,p_Encoding:="",p_Convert2DOS:=False,&r_EOLFormat:="")
{
if !FileExist(p_File)
{
OutputDebug("Function: " A_ThiSFunc " - File `"" p_File "`" not found.")
Return -1
}
if not File:=FileOpen(p_File,"r",StrLen(p_Encoding) ? p_Encoding:A_FileEncoding)
{
l_Message:=Edit_SystemMessage(A_LastError)
OutputDebug("
           (ltrim join`s
            Function: " A_ThisFunc " -
            Unexpected return code from FileOpen function.
            A_LastError=" A_LastError " - " l_Message "
)")
Return -2
}
l_Text:=File.Read()
File.Close()
if (l_Text ~= "i)(`r`n)")
r_EOLFormat:="DOS"
else
if (l_Text ~= "i)(`n)")
r_EOLFormat:="UNIX"
else
if (l_Text ~= "i)(`r)")
r_EOLFormat:="MAC"
else
r_EOLFormat:="DOS"
if p_Convert2DOS
l_Text:=Edit_Convert2DOS(l_Text)
if not Edit_SetText(hEdit,l_Text)
{
OutputDebug("
           (ltrim join`s
            Function: " A_ThisFunc " -
            Unable to load text to the Edit control
)")
Return -3
}
Return StrLen(l_Text)
}
Edit_ReplaceSel(hEdit,p_Text:="",p_CanUndo:=True)
{
Static EM_REPLACESEL:=0xC2
if (type(p_Text)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_REPLACESEL, p_CanUndo, p_Text, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_REPLACESEL, p_CanUndo, StrPtr(p_Text), , "ahk_id " hEdit)
}
}
Edit_SaveFile(hEdit,p_File,p_Convert:="")
{
RC:=Edit_WriteFile(hEdit,p_File,A_FileEncoding,p_Convert)
Return (RC>-1) ? True:False
}
Edit_SelectAll(hEdit)
{
Static EM_SETSEL:=0x0B1
ErrorLevel := SendMessage(EM_SETSEL, 0, -1, , "ahk_id " hEdit)
}
Edit_Scroll(hEdit,p_Pages:=0,p_Lines:=0)
{
Static EM_SCROLL  :=0xB5,SB_LINEUP  :=0x0,SB_LINEDOWN:=0x1,SB_PAGEUP  :=0x2,SB_PAGEDOWN:=0x3
l_ScrollLines:=0
Loop Abs(p_Pages)
{
ErrorLevel := SendMessage(EM_SCROLL, (p_Pages>0) ? SB_PAGEDOWN:SB_PAGEUP, 0, , "ahk_id " hEdit)
if not ErrorLevel
Break
l_ScrollLines+=((ErrorLevel&0xFFFF)<<48>>48)
}
Loop Abs(p_Lines)
{
ErrorLevel := SendMessage(EM_SCROLL, (p_Lines>0) ? SB_LINEDOWN:SB_LINEUP, 0, , "ahk_id " hEdit)
if not ErrorLevel
Break
l_ScrollLines+=((ErrorLevel&0xFFFF)<<48>>48)
}
Return l_ScrollLines
}
Edit_ScrollCaret(hEdit)
{
Static EM_SCROLLCARET:=0xB7
ErrorLevel := SendMessage(EM_SCROLLCARET, 0, 0, , "ahk_id " hEdit)
}
Edit_ScrollPage(hEdit,p_HPages:=0,p_VPages:=0)
{
Static Dummy3535,SB_PAGELEFT :=2,SB_PAGERIGHT:=3,SB_PAGEUP  :=2,SB_PAGEDOWN:=3,WM_HSCROLL :=0x114,WM_VSCROLL :=0x115
Loop Abs(p_HPages)
ErrorLevel := SendMessage(WM_HSCROLL, (p_HPages>0) ? SB_PAGERIGHT:SB_PAGELEFT, 0, , "ahk_id " hEdit)
Loop Abs(p_VPages)
ErrorLevel := SendMessage(WM_VSCROLL, (p_VPages>0) ? SB_PAGEDOWN:SB_PAGEUP, 0, , "ahk_id " hEdit)
}
Edit_SetCueBanner(hEdit,p_Text,p_ShowWhenFocused:=False)
{
Static EM_SETCUEBANNER:=0x1501
wText:=p_Text
if !1 and StrLen(p_Text)
{
wText := Buffer(StrLen(p_Text)*2, 0) ; V1toV2: if 'wText' is a UTF-16 string, use 'VarSetStrCapacity(&wText, StrLen(p_Text)*2)'
StrPut(p_Text,&wText,"UTF-16")
}
if (type(wText)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_SETCUEBANNER, p_ShowWhenFocused, wText, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_SETCUEBANNER, p_ShowWhenFocused, StrPtr(wText), , "ahk_id " hEdit)
}
Return ErrorLevel
}
Edit_SetFocus(hEdit,p_ActivateParent:=False)
{
if p_ActivateParent
if not Edit_ActivateParent(hEdit)
Return False
if Edit_HasFocus(hEdit)
Return True
ControlFocus(, "ahk_id " hEdit)
Return ErrorLevel ? False:True
}
Edit_SetFont(hEdit,hFont,p_Redraw:=False)
{
Static WM_SETFONT:=0x30
ErrorLevel := SendMessage(WM_SETFONT, hFont, p_Redraw, , "ahk_id " hEdit)
}
Edit_SetLimitText(hEdit,p_Limit)
{
Static EM_LIMITTEXT:=0xC5
ErrorLevel := SendMessage(EM_LIMITTEXT, p_Limit, 0, , "ahk_id " hEdit)
}
Edit_SetMargins(hEdit,p_LeftMargin:="",p_RightMargin:="")
{
Static EM_SETMARGINS :=0xD3,EC_LEFTMARGIN :=0x1,EC_RIGHTMARGIN:=0x2,EC_USEFONTINFO:=0xFFFF
l_Flags  :=0
l_Margins:=0
if isInteger(p_LeftMargin)
{
l_Flags  |=EC_LEFTMARGIN
l_Margins|=p_LeftMargin
}
if isInteger(p_RightMargin)
{
l_Flags  |=EC_RIGHTMARGIN
l_Margins|=p_RightMargin<<16
}
if l_Flags
ErrorLevel := SendMessage(EM_SETMARGINS, l_Flags, l_Margins, , "ahk_id " hEdit)
}
Edit_SetModify(hEdit,p_Flag)
{
Static EM_SETMODIFY:=0xB9
ErrorLevel := SendMessage(EM_SETMODIFY, p_Flag, 0, , "ahk_id " hEdit)
}
Edit_SetPasswordChar(hEdit,p_CharValue:=9679)
{
Static EM_SETPASSWORDCHAR:=0xCC
RC:=DllCall("SendMessageW", "Ptr", hEdit, "UInt", EM_SETPASSWORDCHAR, "UInt", p_CharValue, "UInt", 0)
WinRedraw("ahk_id " hEdit)
Return RC
}
Edit_SetReadOnly(hEdit,p_Flag)
{
Static EM_SETREADONLY:=0xCF
ErrorLevel := SendMessage(EM_SETREADONLY, p_Flag, 0, , "ahk_id " hEdit)
Return ErrorLevel ? True:False
}
Edit_SetRect(hEdit,p_Left,p_Top,p_Right,p_Bottom)
{
Static EM_SETRECT:=0xB3
RECT := Buffer(16, 0) ; V1toV2: if 'RECT' is a UTF-16 string, use 'VarSetStrCapacity(&RECT, 16)'
NumPut("Int", p_Left, RECT, 0)
NumPut("Int", p_Top, RECT, 4)
NumPut("Int", p_Right, RECT, 8)
NumPut("Int", p_Bottom, RECT, 12)
if (type(RECT)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_SETRECT, 0, RECT, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_SETRECT, 0, StrPtr(RECT), , "ahk_id " hEdit)
}
}
Edit_SetTabStops(hEdit,p_NbrOfTabStops:=0,p_DTU:=32)
{
Static EM_SETTABSTOPS:=0xCB
l_TabStops := Buffer(p_NbrOfTabStops*4, 0) ; V1toV2: if 'l_TabStops' is a UTF-16 string, use 'VarSetStrCapacity(&l_TabStops, p_NbrOfTabStops*4)'
if IsObject(p_DTU)
{
l_NbrOfElements:=0
For l_Key,l_Value in p_DTU
{
l_NbrOfElements++
if (A_Index<=p_NbrOfTabStops)
NumPut("UInt", l_Value+0, l_TabStops, (A_Index-1)*4)
}
if (l_NbrOfElements=1 and p_NbrOfTabStops>1)
Loop p_NbrOfTabStops
NumPut("UInt", l_Value*A_Index, l_TabStops, (A_Index-1)*4)
}
else
if (p_DTU ~= "i)(||)")
{
Loop Parse, p_DTU, ",", A_Space
if (A_Index<=p_NbrOfTabStops)
NumPut("UInt", A_LoopField+0, l_TabStops, (A_Index-1)*4)
}
else
Loop p_NbrOfTabStops
NumPut("UInt", p_DTU*A_Index, l_TabStops, (A_Index-1)*4)
if (type(l_TabStops)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_SETTABSTOPS, p_NbrOfTabStops, l_TabStops, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_SETTABSTOPS, p_NbrOfTabStops, StrPtr(l_TabStops), , "ahk_id " hEdit)
}
Return ErrorLevel
}
Edit_SetText(hEdit,p_Text,p_SetModify:=False)
{
Static WM_SETTEXT:=0xC
if (type(p_Text)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(WM_SETTEXT, 0, p_Text, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(WM_SETTEXT, 0, StrPtr(p_Text), , "ahk_id " hEdit)
}
if RC:=ErrorLevel
if p_SetModify
Edit_SetModify(hEdit,True)
Return RC
}
Edit_SetSel(hEdit,p_StartSelPos:=0,p_EndSelPos:=-1)
{
Static EM_SETSEL:=0x0B1
ErrorLevel := SendMessage(EM_SETSEL, p_StartSelPos, p_EndSelPos, , "ahk_id " hEdit)
}
Edit_SetStyle(hEdit,p_Style,p_Option:="+")
{
ControlStyle(p_Option "" p_Style,,"ahk_id " hEdit)
Return ErrorLevel ? False:True
}
Edit_Show(hEdit)
{
ControlShow(,"ahk_id " hEdit)
Return ErrorLevel ? False:True
}
Edit_ShowAllScrollBars(hEdit)
{
Static SB_BOTH:=3
Return Edit_ShowScrollBar(hEdit,SB_BOTH,True)
}
Edit_ShowBalloonTip(hEdit,p_Title,p_Text,p_Icon:=0)
{
Static Dummy8144,TTI_NONE         :=0,TTI_INFO         :=1,TTI_WARNING      :=2,TTI_ERROR        :=3,TTI_INFO_LARGE   :=4,TTI_WARNING_LARGE:=5,TTI_ERROR_LARGE  :=6,EM_SHOWBALLOONTIP:=0x1503
wTitle:=p_Title
wText :=p_Text
if not 1
{
if StrLen(p_Title)
{
wTitle := Buffer(StrLen(p_Title)*2, 0) ; V1toV2: if 'wTitle' is a UTF-16 string, use 'VarSetStrCapacity(&wTitle, StrLen(p_Title)*2)'
StrPut(p_Title,&wTitle,"UTF-16")
}
if StrLen(p_Text)
{
wText := Buffer(StrLen(p_Text)*2, 0) ; V1toV2: if 'wText' is a UTF-16 string, use 'VarSetStrCapacity(&wText, StrLen(p_Text)*2)'
StrPut(p_Text,&wText,"UTF-16")
}
}
cbSize:=(A_PtrSize=8) ? 32:16
VarSetStrCapacity(&EDITBALLOONTIP, cbSize) ; V1toV2: if 'EDITBALLOONTIP' is NOT a UTF-16 string, use 'EDITBALLOONTIP := Buffer(cbSize)'
NumPut("Int", cbSize, EDITBALLOONTIP, 0)
NumPut("Ptr", &wTitle, EDITBALLOONTIP, (A_PtrSize=8) ? 8:4)
NumPut("Ptr", &wText, EDITBALLOONTIP, (A_PtrSize=8) ? 16:8)
NumPut("Int", p_Icon, EDITBALLOONTIP, (A_PtrSize=8) ? 24:12)
if (type(EDITBALLOONTIP)="Buffer"){ ;V1toV2 If statement may be removed depending on type parameter
   ErrorLevel := SendMessage(EM_SHOWBALLOONTIP, 0, EDITBALLOONTIP, , "ahk_id " hEdit)
} else{
   ErrorLevel := SendMessage(EM_SHOWBALLOONTIP, 0, StrPtr(EDITBALLOONTIP), , "ahk_id " hEdit)
}
Return ErrorLevel
}
Edit_ShowHScrollBar(hEdit)
{
Static SB_HORZ:=0
Return Edit_ShowScrollBar(hEdit,SB_HORZ,True)
}
Edit_ShowScrollBar(hEdit,wBar,p_Show:=True)
{
Static Dummy6622,OBJID_HSCROLL:=0xFFFFFFFA,OBJID_VSCROLL:=0xFFFFFFFB,STATE_SYSTEM_UNAVAILABLE:=0x1,STATE_SYSTEM_PRESSED    :=0x8,STATE_SYSTEM_INVISIBLE  :=0x8000,STATE_SYSTEM_OFFSCREEN  :=0x10000,SB_HORZ:=0,SB_VERT:=1,SB_CTL:=2,SB_BOTH:=3
if p_Show
{
if (wBar ~= "^(?i:" RegExReplace(RegExReplace(SB_HORZ "," SB_BOTH,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")$")
if Edit_GetScrollBarState(hEdit,OBJID_HSCROLL) & STATE_SYSTEM_OFFSCREEN
DllCall("ShowScrollBar", "Ptr", hEdit, "UInt", wBar, "UInt", False)
if (wBar ~= "^(?i:" RegExReplace(RegExReplace(SB_VERT "," SB_BOTH,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")$")
if Edit_GetScrollBarState(hEdit,OBJID_VSCROLL) & STATE_SYSTEM_OFFSCREEN
DllCall("ShowScrollBar", "Ptr", hEdit, "UInt", wBar, "UInt", False)
}
RC:=DllCall("ShowScrollBar", "Ptr", hEdit, "UInt", wBar, "UInt", p_Show)
if not p_Show
{
if (wBar ~= "^(?i:" RegExReplace(RegExReplace(SB_HORZ "," SB_BOTH,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")$")
if Edit_GetScrollBarState(hEdit,OBJID_HSCROLL) & STATE_SYSTEM_OFFSCREEN
DllCall("ShowScrollBar", "Ptr", hEdit, "UInt", wBar, "UInt", False)
if (wBar ~= "^(?i:" RegExReplace(RegExReplace(SB_VERT "," SB_BOTH,"[\\\.\*\?\+\[\{\|\(\)\^\$]","\$0"),"\s*,\s*","|") ")$")
if Edit_GetScrollBarState(hEdit,OBJID_VSCROLL) & STATE_SYSTEM_OFFSCREEN
DllCall("ShowScrollBar", "Ptr", hEdit, "UInt", wBar, "UInt", False)
}
Return RC ? True:False
}
Edit_ShowVScrollBar(hEdit)
{
Static SB_VERT:=1
Return Edit_ShowScrollBar(hEdit,SB_VERT,True)
}
Edit_SystemMessage(p_MessageNbr)
{
Static FORMAT_MESSAGE_FROM_SYSTEM:=0x1000
l_Message := Buffer(1024*(1 ? 2:1), 0) ; V1toV2: if 'l_Message' is a UTF-16 string, use 'VarSetStrCapacity(&l_Message, 1024*(A_IsUnicode ? 2:1))'
DllCall("FormatMessage", "UInt", FORMAT_MESSAGE_FROM_SYSTEM, "Ptr", 0, "UInt", p_MessageNbr, "UInt", 0, "Str", l_Message, "UInt", 1024, "Ptr", 0)
if (SubStr(l_Message, -2)="`r`n")
l_Message := SubStr(l_Message, 1, -1*(2))
Return l_Message
}
Edit_TextIsSelected(hEdit,&r_StartSelPos:="",&r_EndSelPos:="") {
	Edit_GetSel(hEdit,r_StartSelPos,r_EndSelPos)
		Return (r_StartSelPos ^= r_EndSelPos)
	}
	Edit_Undo(hEdit){
		Static EM_UNDO:=0xC7
		ErrorLevel := SendMessage(EM_UNDO, 0, 0, , "ahk_id " hEdit)
		Return ErrorLevel
	}
	Edit_WriteFile(hEdit,p_File,p_Encoding:="",p_Convert:="") {
		if not File:=FileOpen(p_File,"w",StrLen(p_Encoding) ? p_Encoding:A_FileEncoding)
		{
		l_Message:=Edit_SystemMessage(A_LastError)
		OutputDebug("
				(ltrim join`s
					Function: " A_ThisFunc " -
					Unexpected return code from FileOpen function.
					A_LastError=" A_LastError " - " l_Message "
		)")
		Return -1
		}
		l_Text:=Edit_GetText(hEdit)
		if p_Convert
		{
		p_Convert := StrTitle(p_Convert)
		if (p_Convert ~= "^(?i:U|Unix)$")
		l_Text:=Edit_Convert2Unix(l_Text)
		else
		if (p_Convert ~= "^(?i:M|Mac)$")
		l_Text:=Edit_Convert2Mac(l_Text)
		}
		l_NumberOfBytesWritten:=File.Write(l_Text)
		File.Close()
		Return l_NumberOfBytesWritten
	}
Edit_BlockMove(hEdit,p_Command:="")
{
p_Command := StrTitle(p_Command)
l_LastLine:=Edit_GetLineCount(hEdit)-1
Edit_GetSel(hEdit,l_StartSelPos,l_EndSelPos)
l_FirstSelectedLine:=Edit_LineFromChar(hEdit,l_StartSelPos)
l_LastSelectedLine :=Edit_LineFromChar(hEdit,l_EndSelPos)
l_FirstPosOfFirstSelectedLine:=Edit_LineIndex(hEdit,l_FirstSelectedLine)
if (l_FirstSelectedLine<>l_LastSelectedLine)
if (l_EndSelPos=Edit_LineIndex(hEdit,l_LastSelectedLine))
l_LastSelectedLine--
l_FirstPosOfLastSelectedLine:=Edit_LineIndex(hEdit,l_LastSelectedLine)
l_LastSelectedLineLen       :=Edit_LineLength(hEdit,l_LastSelectedLine)
l_LastPosOfLastSelectedLine :=l_FirstPosOfLastSelectedLine+l_LastSelectedLineLen
if (p_Command ~= "^(?i:U|Up)$")
{
if (l_FirstSelectedLine=0)
{
SoundPlay("*-1")
Return False
}
}
else
if (l_LastSelectedLine=l_LastLine)
{
SoundPlay("*-1")
Return False
}
if (l_StartSelPos<>l_FirstPosOfFirstSelectedLine)
or (l_EndSelPos<>l_LastPosOfLastSelectedLine)
Edit_SetSel(hEdit,l_FirstPosOfFirstSelectedLine,l_LastPosOfLastSelectedLine)
l_SelectedText:=Edit_GetSelText(hEdit)
if (p_Command ~= "^(?i:U|Up)$")
{
l_FirstPosOfTargetLine:=Edit_LineIndex(hEdit,l_FirstSelectedLine-1)
l_TargetText          :=Edit_GetLine(hEdit,l_FirstSelectedLine-1)
l_LenOfTargetLineEOL:=l_FirstPosOfFirstSelectedLine
- (l_FirstPosOfTargetLine+StrLen(l_TargetText))
Edit_SetSel(hEdit,l_FirstPosOfTargetLine,l_LastPosOfLastSelectedLine)
Edit_ReplaceSel(hEdit,l_SelectedText . "`r`n" . l_TargetText)
l_NewStartSelPos:=l_StartSelPos-(StrLen(l_TargetText)+l_LenOfTargetLineEOL)
l_NewEndSelPos  :=l_EndSelPos  -(StrLen(l_TargetText)+l_LenOfTargetLineEOL)
if (l_EndSelPos>l_LastPosOfLastSelectedLine)
l_NewEndSelPos:=l_NewEndSelPos
- ((l_EndSelPos-l_LastPosOfLastSelectedLine)-2)
Edit_SetSel(hEdit,l_NewStartSelPos,l_NewEndSelPos)
}
else
{
l_FirstPosOfTargetLine:=Edit_LineIndex(hEdit,l_LastSelectedLine+1)
l_TargetText          :=Edit_GetLine(hEdit,l_LastSelectedLine+1)
l_LenOfLastSelectedLineEOL:=l_FirstPosOfTargetLine
- l_FirstPosOfLastSelectedLine
- l_LastSelectedLineLen
if (l_LastSelectedLine+2>l_LastLine)
l_LenOfTargetLineEOL:=0
else
l_LenOfTargetLineEOL:=Edit_LineIndex(hEdit,l_LastSelectedLine+2)
- l_FirstPosOfTargetLine
- StrLen(l_TargetText)
Edit_SetSel(hEdit,l_FirstPosOfFirstSelectedLine,l_FirstPosOfTargetLine+StrLen(l_TargetText))
Edit_ReplaceSel(hEdit,l_TargetText . "`r`n" . l_SelectedText)
l_NewStartSelPos:=l_StartSelPos+StrLen(l_TargetText)+2
l_NewEndSelPos  :=l_EndSelPos  +StrLen(l_TargetText)+2
if (l_EndSelPos>l_LastPosOfLastSelectedLine)
l_NewEndSelPos:=l_NewEndSelPos
- l_LenOfLastSelectedLineEOL
+ l_LenOfTargetLineEOL
Edit_SetSel(hEdit,l_NewStartSelPos,l_NewEndSelPos)
}
Edit_LineScroll(hEdit,"Left")
Return True
}
Dlg_ChooseColor(hOwner,&r_Color,p_Flags:=0,p_CustomColorsFile:="",p_HelpHandler:="")
{
Static Dummy1243,HELPMSGSTRING:="commdlg_help",CHOOSECOLOR,s_CustomColors,CC_ANYCOLOR:=0x100,CC_FULLOPEN:=0x2,CC_PREVENTFULLOPEN:=0x4,CC_RGBINIT:=0x1,CC_SHOWHELP:=0x8,CC_SOLIDCOLOR:=0x80
PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"
if not VarSetStrCapacity(&s_CustomColors) ; V1toV2: if 's_CustomColors' is NOT a UTF-16 string, use 's_CustomColors := Buffer()'
s_CustomColors := Buffer(64, 0) ; V1toV2: if 's_CustomColors' is a UTF-16 string, use 'VarSetStrCapacity(&s_CustomColors, 64)'
l_Color:=r_Color
if !isInteger(l_Color)
l_Color:=0x0
else
l_Color:=((l_Color&0xFF)<<16)+(l_Color&0xFF00)+((l_Color>>16)&0xFF)
l_Flags:=CC_RGBINIT
if not p_Flags
l_Flags|=CC_FULLOPEN|CC_ANYCOLOR
else
if isInteger(p_Flags)
l_Flags|=p_Flags
else
Loop Parse, p_Flags, A_Tab "" A_Space, A_Tab "" A_Space
if !isSpace(A_LoopField)
if CC_%A_LoopField% is Integer
l_Flags|=CC_%A_LoopField%
if IsFunc(p_HelpHandler)
l_Flags|=CC_SHOWHELP
if StrLen(p_CustomColorsFile)
Loop 16
{
t_Color := IniRead(p_CustomColorsFile, "CustomColors", A_Index, 0)
NumPut("UInt", t_Color, s_CustomColors, (A_Index-1)*4)
}
lStructSize:=CHOOSECOLOR := Buffer((A_PtrSize=8) ? 72:36, 0) ; V1toV2: if 'CHOOSECOLOR' is a UTF-16 string, use 'VarSetStrCapacity(&CHOOSECOLOR, (A_PtrSize=8) ? 72:36)'
NumPut("UInt", lStructSize, CHOOSECOLOR, 0)
NumPut(PtrType, hOwner, CHOOSECOLOR, (A_PtrSize=8) ? 8:4)
NumPut("UInt", l_Color, CHOOSECOLOR, (A_PtrSize=8) ? 24:12)
NumPut(PtrType, &s_CustomColors, CHOOSECOLOR, (A_PtrSize=8) ? 32:16)
NumPut("UInt", l_Flags, CHOOSECOLOR, (A_PtrSize=8) ? 40:20)
if (l_FLags & CC_SHOWHELP) and IsFunc(p_HelpHandler)
{
Dlg_OnHelpMsg("Register",p_HelpHandler,"","")
OnMessage(l_HelpMsg:=DllCall("RegisterWindowMessage", PtrType, HELPMSGSTRING), Dlg_OnHelpMsg)
}
RC:=DllCall("comdlg32\ChooseColor" . (1 ? "W":"A"),PtrType,&CHOOSECOLOR)
if StrLen(p_CustomColorsFile)
Loop 16
IniWrite(NumGet(s_CustomColors, (A_Index-1)*4, "UInt"), p_CustomColorsFile, "CustomColors", A_Index)
if l_HelpMsg
OnMessage(l_HelpMsg)
if (RC=0)
Return False
l_Color:=NumGet(CHOOSECOLOR, (A_PtrSize=8) ? 24:12, "UInt")
l_Color:=((l_Color&0xFF)<<16)+(l_Color&0xFF00)+((l_Color>>16)&0xFF)
r_Color:=Dlg_Convert2Hex(l_Color,6)
Return True
}
Dlg_ChooseFont(hOwner:=0,&r_Name:="",&r_Options:="",p_Effects:=True,p_Flags:=0,p_HelpHandler:="")
{
Static Dummy3155,HELPMSGSTRING:="commdlg_help",CHOOSEFONT,LOGFONT,CF_SCREENFONTS:=0x1,CF_SHOWHELP:=0x4,CF_INITTOLOGFONTSTRUCT:=0x40,CF_EFFECTS:=0x100,CF_SCRIPTSONLY:=0x400,CF_NOOEMFONTS:=0x800,CF_NOSIMULATIONS:=0x1000,CF_LIMITSIZE:=0x2000,CF_FIXEDPITCHONLY:=0x4000,CF_FORCEFONTEXIST:=0x10000,CF_SCALABLEONLY:=0x20000,CF_TTONLY:=0x40000,CF_NOFACESEL:=0x80000,CF_NOSTYLESEL:=0x100000,CF_NOSIZESEL:=0x200000,CF_NOSCRIPTSEL:=0x800000,CF_NOVERTFONTS:=0x1000000,LOGPIXELSY:=90,CFERR_MAXLESSTHANMIN:=0x2002,FW_NORMAL           :=400,FW_BOLD             :=700,LF_FACESIZE         :=32,Color_Aqua   :=0x00FFFF,Color_Black  :=0x000000,Color_Blue   :=0x0000FF,Color_Fuchsia:=0xFF00FF,Color_Gray   :=0x808080,Color_Green  :=0x008000,Color_Lime   :=0x00FF00,Color_Maroon :=0x800000,Color_Navy   :=0x000080,Color_Olive  :=0x808000,Color_Purple :=0x800080,Color_Red    :=0xFF0000,Color_Silver :=0xC0C0C0,Color_Teal   :=0x008080,Color_White  :=0xFFFFFF,Color_Yellow :=0xFFFF00
PtrType  :=(A_PtrSize=8) ? "Ptr":"UInt"
TCharSize:=1 ? 2:1
hDC:=DllCall("CreateDC", "Str", "DISPLAY", PtrType, 0, PtrType, 0, PtrType, 0)
l_LogPixelsY:=DllCall("GetDeviceCaps", PtrType, hDC, "Int", LOGPIXELSY)
DllCall("DeleteDC", PtrType, hDC)
r_Name := r_Name
if !isInteger(p_Flags)
p_Flags:=0x0
p_Flags|=CF_SCREENFONTS|CF_INITTOLOGFONTSTRUCT
if p_Effects
p_Flags|=CF_EFFECTS
if IsFunc(p_HelpHandler)
p_Flags|=CF_SHOWHELP
o_Color    :=0x0
o_Height   :=13
o_Italic   :=False
o_Size     :=""
o_SizeMin  :=""
o_SizeMax  :=""
o_Strikeout:=False
o_Underline:=False
o_Weight   :=""
Loop Parse, r_Options, A_Space
{
if (InStr(A_LoopField, "bold")=1)
o_Weight:=FW_BOLD
else if (InStr(A_LoopField, "italic")=1)
o_Italic:=True
else if (InStr(A_LoopField, "sizemin")=1)
{
o_SizeMin:=SubStr(A_LoopField, 8)
if !isInteger(o_SizeMin)
o_SizeMin:=1
}
else if (InStr(A_LoopField, "sizemax")=1)
{
o_SizeMax:=SubStr(A_LoopField, 8)
if !isInteger(o_SizeMax)
o_SizeMax:=0xBFFF
}
else if (InStr(A_LoopField, "strike")=1)
o_Strikeout:=True
else if (InStr(A_LoopField, "underline")=1)
o_Underline:=True
else if (InStr(A_LoopField, "c")=1 and StrLen(A_Loopfield)>1)
{
o_Color:="0x" . SubStr(A_LoopField, 2)
if isAlpha(A_LoopField)
{
t_ColorName:=SubStr(A_LoopField, 2)
if Color_%t_ColorName% is not Space
o_Color:=Color_%t_ColorName%
}
}
else if (InStr(A_LoopField, "s")=1)
o_Size:=SubStr(A_LoopField, 2)
else if (InStr(A_LoopField, "w")=1)
o_Weight:=SubStr(A_LoopField, 2)
}
if not p_Flags & CF_EFFECTS
{
o_Color    :=0x0
o_Strikeout:=False
o_Underline:=False
}
if isSpace(o_Color)
o_Color:=0x0
else
if !isXdigit(o_Color)
o_Color:=0x0
else
o_Color:=((o_Color&0xFF)<<16)+(o_Color&0xFF00)+((o_Color>>16)&0xFF)
if isInteger(o_SizeMin)
if isSpace(o_SizeMax)
o_SizeMax:=0xBFFF
if isInteger(o_SizeMax)
if isSpace(o_SizeMin)
o_SizeMin:=1
if !isInteger(o_Weight)
o_Weight:=FW_NORMAL
if isInteger(o_Size)
o_Height:=Round(o_Size*l_LogPixelsY/72)*-1
if o_SizeMin or o_SizeMax
p_Flags|=CF_LIMITSIZE
LOGFONT := Buffer(28+(TCharSize*LF_FACESIZE), 0) ; V1toV2: if 'LOGFONT' is a UTF-16 string, use 'VarSetStrCapacity(&LOGFONT, 28+(TCharSize*LF_FACESIZE))'
NumPut("Int", o_Height, LOGFONT, 0)
NumPut("Int", o_Weight, LOGFONT, 16)
NumPut("UChar", o_Italic, LOGFONT, 20)
NumPut("UChar", o_Underline, LOGFONT, 21)
NumPut("UChar", o_Strikeout, LOGFONT, 22)
if StrLen(r_Name)
DllCall("lstrcpyn" . (1 ? "W":"A"),PtrType,&LOGFONT+28,"Str",r_Name,"Int",StrLen(r_Name)+1)
CFSize:=CHOOSEFONT := Buffer((A_PtrSize=8) ? 104:60, 0) ; V1toV2: if 'CHOOSEFONT' is a UTF-16 string, use 'VarSetStrCapacity(&CHOOSEFONT, (A_PtrSize=8) ? 104:60)'
NumPut("UInt", CFSize, CHOOSEFONT, 0)
NumPut(PtrType, hOwner, CHOOSEFONT, (A_PtrSize=8) ? 8:4)
NumPut(PtrType, &LOGFONT, CHOOSEFONT, (A_PtrSize=8) ? 24:12)
NumPut("UInt", p_Flags, CHOOSEFONT, (A_PtrSize=8) ? 36:20)
NumPut("UInt", o_Color, CHOOSEFONT, (A_PtrSize=8) ? 40:24)
if o_SizeMin
NumPut("Int", o_SizeMin, CHOOSEFONT, (A_PtrSize=8) ? 92:52)
if o_SizeMax
NumPut("Int", o_SizeMax, CHOOSEFONT, (A_PtrSize=8) ? 96:56)
if (p_Flags & CF_SHOWHELP) and IsFunc(p_HelpHandler)
{
Dlg_OnHelpMsg("Register",p_HelpHandler,"","")
OnMessage(l_HelpMsg:=DllCall("RegisterWindowMessage", PtrType, HELPMSGSTRING), Dlg_OnHelpMsg)
}
RC:=DllCall("comdlg32\ChooseFont" . (1 ? "W":"A"),PtrType,&CHOOSEFONT)
if l_HelpMsg
OnMessage(l_HelpMsg)
if (RC=0)
{
if CDERR:=DllCall("comdlg32\CommDlgExtendedError")
{
if (CDERR=CFERR_MAXLESSTHANMIN)
OutputDebug("
                   (ltrim join`s
                    Function: " A_ThisFunc " Error -
                    The size specified in the SizeMax option is less than the
                    size specified in the SizeMin option.
)")
else
OutputDebug("
                   (ltrim join`s
                    Function: " A_ThisFunc " Error -
                    Unknown error returned from the `"ChooseFont`" API. Error
                    code: " CDERR ".
)")
}
Return False
}
VarSetStrCapacity(&r_Name, TCharSize*LF_FACESIZE) ; V1toV2: if 'r_Name' is NOT a UTF-16 string, use 'r_Name := Buffer(TCharSize*LF_FACESIZE)'
nSize:=DllCall("lstrlen" . (1 ? "W":"A"),PtrType,&LOGFONT+28)
DllCall("lstrcpyn" . (1 ? "W":"A"),"Str",r_Name,PtrType,&LOGFONT+28,"Int",nSize+1)
VarSetStrCapacity(&r_Name, -1) ; V1toV2: if 'r_Name' is NOT a UTF-16 string, use 'r_Name := Buffer(-1)'
r_Options:=""
r_Options.="s". NumGet(CHOOSEFONT, (A_PtrSize=8) ? 32:16, "Int")//10. A_Space
if p_Flags & CF_EFFECTS
{
l_Color:=NumGet(CHOOSEFONT, (A_PtrSize=8) ? 40:24, "UInt")
l_Color:=((l_Color&0xFF)<<16)+(l_Color&0xFF00)+((l_Color>>16)&0xFF)
r_Options.="c" . SubStr(Dlg_Convert2Hex(l_Color,6), 3) . A_Space
}
l_Weight:=NumGet(LOGFONT, 16, "Int")
if (l_Weight<>FW_NORMAL)
if (l_Weight=FW_BOLD)
r_Options.="bold "
else
r_Options.="w" . l_Weight . A_Space
if NumGet(LOGFONT, 20, "UChar")
r_Options.="italic "
if NumGet(LOGFONT, 21, "UChar")
r_Options.="underline "
if NumGet(LOGFONT, 22, "UChar")
r_Options.="strike "
r_Options:=SubStr(r_Options, 1, -1)
Return True
}
Dlg_ChooseIcon(hOwner,&r_IconPath,&r_IconIndex)
{
Static Dummy9731,CP_ACP  :=0,MAX_PATH:=260
PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"
wIconPath := Buffer(MAX_PATH*2, 0) ; V1toV2: if 'wIconPath' is a UTF-16 string, use 'VarSetStrCapacity(&wIconPath, MAX_PATH*2)'
wIconPath:=r_IconPath
l_IconIndex:=r_IconIndex-1
if not 1
if !isSpace(r_IconPath)
DllCall("MultiByteToWideChar", "UInt", CP_ACP, "UInt", 0, "Str", r_IconPath, "Int", StrLen(r_IconPath), "Str", wIconPath, "Int", MAX_PATH)
if not DllCall("Shell32\PickIconDlg", PtrType, hOwner, "Str", wIconPath, "UInt", MAX_PATH+1, "IntP", &l_IconIndex)
Return False
if 1
r_IconPath:=wIconPath
else
{
nSize:=DllCall("lstrlenW", PtrType, wIconPath)
r_IconPath := Buffer(nSize, 0) ; V1toV2: if 'r_IconPath' is a UTF-16 string, use 'VarSetStrCapacity(&r_IconPath, nSize)'
DllCall("WideCharToMultiByte", "UInt", CP_ACP, "UInt", 0, "Str", wIconPath, "Int", nSize, "Str", r_IconPath, "Int", nSize, "UInt", 0, "UInt", 0)
}
r_IconIndex:=l_IconIndex+1
Return True
}
Dlg_Convert2Hex(p_Integer,p_MinDigits:=0)
{
PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"
if (p_Integer<0)
{
l_NegativeChar:="-"
p_Integer:=-p_Integer
}
l_Size:=(p_Integer=0) ? 1:Floor(Ln(p_Integer)/Ln(16))+1
if (p_MinDigits>l_Size)
l_Size:=p_MinDigits+0
l_Format:="`%0" . l_Size . "I64X"
VarSetStrCapacity(&l_Argument, 8) ; V1toV2: if 'l_Argument' is NOT a UTF-16 string, use 'l_Argument := Buffer(8)'
NumPut("Int64", p_Integer, l_Argument, 0)
l_Buffer := Buffer(1 ? l_Size*2:l_Size, 0) ; V1toV2: if 'l_Buffer' is a UTF-16 string, use 'VarSetStrCapacity(&l_Buffer, A_IsUnicode ? l_Size*2:l_Size)'
DllCall(1 ? "msvcrt\_vsnwprintf":"msvcrt\_vsnprintf","Str",l_Buffer,"UInt",l_Size,"Str",l_Format,PtrType,&l_Argument)
Return l_NegativeChar . "0x" . l_Buffer
}
Dlg_FindReplaceText(p_Type,hOwner,p_Flags,p_FindWhat,p_ReplaceWith,p_Handler,p_HelpHandler:="")
{
Static Dummy3969,HELPMSGSTRING:="commdlg_help",FINDMSGSTRING:="commdlg_FindReplace",FINDREPLACE,s_FindWhat,s_ReplaceWith,s_MaxFRLen:=512,FR_DOWN         :=0x1,FR_WHOLEWORD    :=0x2,FR_MATCHCASE    :=0x4,FR_SHOWHELP     :=0x80,FR_NOUPDOWN     :=0x400,FR_NOMATCHCASE  :=0x800,FR_NOWHOLEWORD  :=0x1000,FR_HIDEUPDOWN   :=0x4000,FR_HIDEMATCHCASE:=0x8000,FR_HIDEWHOLEWORD:=0x10000
if WinExist("ahk_id " . Dlg_OnFindReplaceMsg("GetDialog","","",""))
{
OutputDebug("
           (ltrim join`s
            Function: " A_ThisFunc " -
            Find or Replace dialog is already open. Request aborted.
)")
Return False
}
if not IsFunc(p_Handler)
{
OutputDebug("Function: " A_ThisFunc " - Invalid handler: " p_Hander)
Return False
}
PtrType  :=(A_PtrSize=8) ? "Ptr":"UInt"
MaxTChars:=(1 ? Floor(s_MaxFRLen/2):s_MaxFRLen)-1
p_Type:=SubStr(p_Type, 1, 1)
p_Type := StrUpper(p_Type)
if !(p_Type ~= "^(?i:F|R)$")
p_Type:="F"
l_Flags:=0
if isInteger(p_Flags)
l_Flags|=p_Flags
else
Loop Parse, p_Flags, A_Tab "" A_Space, A_Tab "" A_Space
if !isSpace(A_LoopField)
if FR_%A_LoopField% is Integer
l_Flags|=FR_%A_LoopField%
if IsFunc(p_HelpHandler)
l_Flags|=FR_SHOWHELP
lStructSize:=FINDREPLACE := Buffer((A_PtrSize=8) ? 80:40, 0) ; V1toV2: if 'FINDREPLACE' is a UTF-16 string, use 'VarSetStrCapacity(&FINDREPLACE, (A_PtrSize=8) ? 80:40)'
NumPut("UInt", lStructSize, FINDREPLACE, 0)
NumPut(PtrType, hOwner, FINDREPLACE, (A_PtrSize=8) ? 8:4)
NumPut("UInt", l_Flags, FINDREPLACE, (A_PtrSize=8) ? 24:12)
s_FindWhat := Buffer(s_MaxFRLen, 0) ; V1toV2: if 's_FindWhat' is a UTF-16 string, use 'VarSetStrCapacity(&s_FindWhat, s_MaxFRLen)'
if StrLen(p_FindWhat)
s_FindWhat:=SubStr(p_FindWhat, 1, MaxTChars)
NumPut(PtrType, &s_FindWhat, FINDREPLACE, (A_PtrSize=8) ? 32:16)
if (p_Type="R")
{
s_ReplaceWith := Buffer(s_MaxFRLen, 0) ; V1toV2: if 's_ReplaceWith' is a UTF-16 string, use 'VarSetStrCapacity(&s_ReplaceWith, s_MaxFRLen)'
if StrLen(p_ReplaceWith)
s_ReplaceWith:=SubStr(p_ReplaceWith, 1, MaxTChars)
NumPut(PtrType, &s_ReplaceWith, FINDREPLACE, (A_PtrSize=8) ? 40:20)
}
NumPut("UShort", s_MaxFRLen, FINDREPLACE, (A_PtrSize=8) ? 48:24)
if (p_Type="R")
NumPut("UShort", s_MaxFRLen, FINDREPLACE, (A_PtrSize=8) ? 50:26)
Dlg_OnFindReplaceMsg("RegisterHandler",p_Handler,"","")
OnMessage(DllCall("RegisterWindowMessage", "Str", FINDMSGSTRING), Dlg_OnFindReplaceMsg)
if (l_FLags & FR_SHOWHELP) and IsFunc(p_HelpHandler)
{
Dlg_OnHelpMsg("Register",p_HelpHandler,"","")
OnMessage(l_HelpMsg:=DllCall("RegisterWindowMessage", PtrType, HELPMSGSTRING), Dlg_OnHelpMsg)
}
if (p_Type="F")
hDialog:=DllCall("comdlg32\FindText" . (1 ? "W":"A"),PtrType,&FINDREPLACE)
else
hDialog:=DllCall("comdlg32\ReplaceText" . (1 ? "W":"A"),PtrType,&FINDREPLACE)
Dlg_OnFindReplaceMsg("RegisterDialog",hDialog,"","")
Return hDialog
}
Dlg_FindText(hOwner,p_Flags,p_FindWhat,p_Handler,p_HelpHandler:="")
{
Return Dlg_FindReplaceText("F",hOwner,p_Flags,p_FindWhat,"",p_Handler,p_HelpHandler)
}
Dlg_GetScriptDebugWindow()
{
Static hScriptDebugWindow
if hScriptDebugWindow
Return hScriptDebugWindow
if A_ScriptHwnd
{
hScriptDebugWindow:=A_ScriptHwnd
Return hScriptDebugWindow
}
l_DetectHiddenWindows:=A_DetectHiddenWindows
DetectHiddenWindows(true)
ErrorLevel := ProcessExist()
ol_Instance := WinGetList("ahk_pid " ErrorLevel,,,)
al_Instance := Array()
l_Instance := ol_Instance.Length
For v in ol_Instance
{   al_Instance.Push(v)
}
Loop al_Instance.Length
{
hScriptDebugWindow:=al_Instance[A_Index]
l_WinTitle := WinGetTitle("ahk_id " . hScriptDebugWindow)
if (InStr(l_WinTitle, A_ScriptFullPath)=1)
Break
}
DetectHiddenWindows(l_DetectHiddenWindows)
Return hScriptDebugWindow
}
Dlg_MessageBox(hOwner:=0,p_Type:=0,p_Title:="",p_Text:="",p_Timeout:=-1,p_HelpHandler:="")
{
Static Dummy8158,MB_OK                  :=0x0,MB_OKCANCEL            :=0x1,MB_ABORTRETRYIGNORE    :=0x2,MB_YESNOCANCEL         :=0x3,MB_YESNO               :=0x4,MB_RETRYCANCEL         :=0x5,MB_CANCELTRYCONTINUE   :=0x6,MB_HELP                :=0x4000,MB_ICONHAND            :=0x10,MB_ICONERROR           :=0x10,MB_ICONSTOP            :=0x10,MB_ICONQUESTION        :=0x20,MB_ICONEXCLAMATION     :=0x30,MB_ICONWARNING         :=0x30,MB_ICONASTERISK        :=0x40,MB_ICONINFORMATION     :=0x40,MB_ICONMASK            :=0xF0,MB_DEFBUTTON1          :=0x0,MB_DEFBUTTON2          :=0x100,MB_DEFBUTTON3          :=0x200,MB_DEFBUTTON4          :=0x300,MB_APPLMODAL           :=0x0,MB_SYSTEMMODAL         :=0x1000,MB_TASKMODAL           :=0x2000,MB_SETFOREGROUND       :=0x10000,MB_DEFAULT_DESKTOP_ONLY:=0x20000,MB_TOPMOST             :=0x40000,MB_RIGHT               :=0x80000,MB_RTLREADING          :=0x100000,MB_SERVICE_NOTIFICATION:=0x200000,IDOK      :=1,IDCANCEL  :=2,IDABORT   :=3,IDRETRY   :=4,IDIGNORE  :=5,IDYES     :=6,IDNO      :=7,IDTRYAGAIN:=10,IDCONTINUE:=11,IDTIMEOUT :=32000,WM_HELP:=0x53
if not hOwner
hOWner:=0
else
if not ("IsWindow",(A_PtrSize=8) ? "Ptr":"UInt",hOwner)
{
OutputDebug("
               (ltrim join`s
                Function: " A_ThisFunc " -
                Window for owner handle not found: " hOwner ". Handle set to 0
                (no handle).
)")
hOwner:=0
}
if !isInteger(p_Type)
p_Type:=0
if IsFunc(p_HelpHandler)
p_Type|=MB_HELP
if isSpace(p_Title)
{
p_Title:=A_ScriptName
if isSpace(p_Text)
p_Text:="Press OK to continue."
}
if !isInteger(p_Timeout)
p_Timeout:=-1
if (p_Type & MB_HELP) and IsFunc(p_HelpHandler)
{
l_PreviousHelpMonitor:=OnMessage(WM_HELP)
l_PreviousHelpHandler:=Dlg_OnHelpMsg("Get","","","")
Dlg_OnHelpMsg("Register",p_HelpHandler,"","")
l_Monitor_WM_HELP:=True
OnMessage(WM_HELP, Dlg_OnHelpMsg)
}
RC:=DllCall("MessageBoxTimeout", (A_PtrSize=8) ? "Ptr":"UInt",hOwner,"Str",p_Text,"Str",p_Title,"UInt",p_Type,"UShort",0,"Int",p_Timeout)
if (RC=0 or ErrorLevel)
{
OutputDebug("
           (ltrim join`s
            Function: " A_ThisFunc " -
            Error returned from MessageBoxTimeout API function.
            ErrorLevel=" ErrorLevel ", A_LastError=" A_LastError "
)")
}
if l_Monitor_WM_HELP
{
OnMessage(WM_HELP, %l_PreviousHelpMonitor%)
Dlg_OnHelpMsg("Register",l_PreviousHelpHandler,"","")
}
Return RC
}
Dlg_OFNHookCallback(hDlg,uiMsg,wParam,lParam)
{
Static Dummy0581,s_ReadOnly:=False,CDN_FIRST  :=-601,CDN_FILEOK :=-606,WM_NOTIFY  :=0x4E
PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"
if isSpace(lParam)
{
if (hDlg="GetReadOnly")
Return s_ReadOnly
if (hDlg="SetReadOnly")
{
s_ReadOnly:=uiMsg
Return
}
return
}
if (uiMsg=WM_NOTIFY)
{
if (NumGet(lParam+0, (A_PtrSize=8) ? 16:8, "Int")=CDN_FILEOK)
{
s_ReadOnly := ControlGetChecked("Button1", "ahk_id " . DllCall("GetParent", PtrType, hDlg))
}
}
Return 0
}
Dlg_OnFindReplaceMsg(wParam,lParam,Msg,hWnd)
{
Static Dummy5289,s_Handler,s_hDialog,HELPMSGSTRING:="commdlg_help",FR_DOWN         :=0x1,FR_WHOLEWORD    :=0x2,FR_MATCHCASE    :=0x4,FR_FINDNEXT     :=0x8,FR_REPLACE      :=0x10,FR_REPLACEALL   :=0x20,FR_DIALOGTERM   :=0x40,FR_SHOWHELP     :=0x80,FR_NOUPDOWN     :=0x400,FR_NOMATCHCASE  :=0x800,FR_NOWHOLEWORD  :=0x1000,FR_HIDEUPDOWN   :=0x4000,FR_HIDEMATCHCASE:=0x8000,FR_HIDEWHOLEWORD:=0x10000
if isSpace(hWnd)
{
if (wParam="GetDialog")
Return s_hDialog
if (wParam="GetHandler")
Return s_Handler
if (wParam="RegisterDialog")
{
s_hDialog:=lParam
return
}
if (wParam="RegisterHandler")
{
s_Handler:=lParam
return
}
return
}
PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"
l_Flags:=NumGet(lParam+0, (A_PtrSize=8) ? 24:12, "UInt")
if (l_Flags & FR_DIALOGTERM)
{
if l_Flags & FR_SHOWHELP
OnMessage(l_HelpMsg:=DllCall("RegisterWindowMessage", PtrType, HELPMSGSTRING))
OnMessage(Msg)
Return %s_Handler%(s_hDialog,"C","","","")
}
l_EventFlags:=l_Flags & (FR_DOWN|FR_WHOLEWORD|FR_MATCHCASE)
lpstrFindWhat:=NumGet(lParam+0, (A_PtrSize=8) ? 32:16, PtrType)
wFindWhatLen:=NumGet(lParam+0, (A_PtrSize=8) ? 48:24, "UShort")
l_FindWhat := Buffer(wFindWhatLen, 0) ; V1toV2: if 'l_FindWhat' is a UTF-16 string, use 'VarSetStrCapacity(&l_FindWhat, wFindWhatLen)'
DllCall("RtlMoveMemory", PtrType, l_FindWhat, PtrType, lpstrFindWhat, "UInt", wFindWhatLen)
VarSetStrCapacity(&l_FindWhat, -1) ; V1toV2: if 'l_FindWhat' is NOT a UTF-16 string, use 'l_FindWhat := Buffer(-1)'
if l_Flags & FR_FINDNEXT
Return %s_Handler%(s_hDialog,"F",l_EventFlags,l_FindWhat,"")
l_Event:=(l_Flags & FR_REPLACEALL) ? "A":"R"
lpstrReplaceWith:=NumGet(lParam+0, (A_PtrSize=8) ? 40:20, PtrType)
wReplaceWithLen:=NumGet(lParam+0, (A_PtrSize=8) ? 50:26, "UShort")
l_ReplaceWith := Buffer(wReplaceWithLen, 0) ; V1toV2: if 'l_ReplaceWith' is a UTF-16 string, use 'VarSetStrCapacity(&l_ReplaceWith, wReplaceWithLen)'
DllCall("RtlMoveMemory", PtrType, l_ReplaceWith, PtrType, lpstrReplaceWith, "UInt", wReplaceWithLen)
VarSetStrCapacity(&l_ReplaceWith, -1) ; V1toV2: if 'l_ReplaceWith' is NOT a UTF-16 string, use 'l_ReplaceWith := Buffer(-1)'
Return %s_Handler%(s_hDialog,l_Event,l_EventFlags,l_FindWhat,l_ReplaceWith)
}
Dlg_OnHelpMsg(wParam,lParam,Msg,hWnd)
{
Static Dummy4412,s_Handler,HELPINFO_WINDOW   :=0x1,HELPINFO_MENUITEM :=0x2,WM_HELP:=0x53
if isSpace(hWnd)
{
if (wParam ~= "^(?i:Get|GetHandler)$")
Return s_Handler
if (wParam ~= "^(?i:Register|RegisterHandler)$")
{
s_Handler:=lParam
Return
}
return
}
PtrType:=(A_PtrSize=8) ? "Ptr":"UInt"
if (Msg=WM_HELP)
{
hItemHandle:=NumGet(lParam+0, (A_PtrSize=8) ? 16:12, PtrType)
Return %s_Handler%(hItemHandle,lParam)
}
if wParam
Return %s_Handler%(wParam,lParam)
else
{
hDialog := WinGetID("A")
Return %s_Handler%(hDialog,lParam)
}
}
Dlg_OpenFile(hOwner:=0,p_Title:="",p_Filter:="",p_FilterIndex:="",p_Root:="",p_DfltExt:="",&r_Flags:=0,p_HelpHandler:="")
{
Return Dlg_OpenSaveFile("O",hOwner,p_Title,p_Filter,p_FilterIndex,p_Root,p_DfltExt,r_Flags,p_HelpHandler)
}
Dlg_OpenSaveFile(p_Type,hOwner:=0,p_Title:="",p_Filter:="",p_FilterIndex:="",p_Root:="",p_DfltExt:="",&r_Flags:=0,p_HelpHandler:="")
{
Static Dummy1696,s_strFileMaxSize:=32768,HELPMSGSTRING:="commdlg_help",OPENFILENAME,OFN_ALLOWMULTISELECT    :=0x200,OFN_CREATEPROMPT        :=0x2000,OFN_DONTADDTORECENT     :=0x2000000,OFN_ENABLEHOOK          :=0x20,OFN_EXPLORER            :=0x80000,OFN_EXTENSIONDIFFERENT  :=0x400,OFN_FILEMUSTEXIST       :=0x1000,OFN_FORCESHOWHIDDEN     :=0x10000000,OFN_HIDEREADONLY        :=0x4,OFN_NOCHANGEDIR         :=0x8,OFN_NODEREFERENCELINKS  :=0x100000,OFN_NOREADONLYRETURN    :=0x8000,OFN_NOTESTFILECREATE    :=0x10000,OFN_NOVALIDATE          :=0x100,OFN_OVERWRITEPROMPT     :=0x2,OFN_PATHMUSTEXIST       :=0x800,OFN_READONLY            :=0x1,OFN_SHOWHELP            :=0x10,OFN_EX_NOPLACESBAR      :=0x1
PtrType  :=(A_PtrSize=8) ? "Ptr":"UInt"
TCharSize:=1 ? 2:1
p_Type:=SubStr(p_Type, 1, 1)
p_Type := StrUpper(p_Type)
if !(p_Type ~= "^(?i:O|S)$")
p_Type:="O"
if isSpace(p_Filter)
p_Filter:="All Files (*.*)"
l_Flags  :=OFN_EXPLORER
l_FlagsEx:=0
if not r_Flags
{
if (p_Type="O")
l_Flags|=OFN_FILEMUSTEXIST|OFN_HIDEREADONLY
}
else
if isInteger(r_Flags)
l_Flags|=r_Flags
else
Loop Parse, r_Flags, A_Tab "" A_Space, A_Tab "" A_Space
if !isSpace(A_LoopField)
if OFN_%A_LoopField% is Integer
if InStr(A_LoopField, "ex_")
l_FlagsEx|=OFN_%A_LoopField%
else
l_Flags|=OFN_%A_LoopField%
if IsFunc(p_HelpHandler)
l_Flags|=OFN_SHOWHELP
if (p_Type="O") and (l_Flags & OFN_ALLOWMULTISELECT)
l_Flags|=OFN_ENABLEHOOK
strFile := Buffer(s_strFileMaxSize*TCharSize, 0) ; V1toV2: if 'strFile' is a UTF-16 string, use 'VarSetStrCapacity(&strFile, s_strFileMaxSize*TCharSize)'
SplitPath(p_Root, &l_RootFileName, &l_RootDir)
if !isSpace(l_RootFileName)
DllCall("RtlMoveMemory", "Str", strFile, "Str", l_RootFileName, "UInt", (StrLen(l_RootFileName)+1)*TCharSize)
strFilter := Buffer(StrLen(p_Filter)*(1 ? 5:3), 0) ; V1toV2: if 'strFilter' is a UTF-16 string, use 'VarSetStrCapacity(&strFilter, StrLen(p_Filter)*(A_IsUnicode ? 5:3))'
l_Offset:=&strFilter
Loop Parse, p_Filter, "|"
{
l_LoopField := A_LoopField
l_Part1:=l_LoopField
l_Part2:=SubStr(l_LoopField, (InStr(l_LoopField, "(")+1)<1 ? (InStr(l_LoopField, "(")+1)-1 : (InStr(l_LoopField, "(")+1), -1)
l_lenPart1:=(StrLen(l_LoopField)+1)*TCharSize
l_lenPart2:=(StrLen(l_Part2)+1)*TCharSize
DllCall("RtlMoveMemory", PtrType, l_Offset, "Str", l_Part1, "UInt", l_lenPart1)
DllCall("RtlMoveMemory", PtrType, l_Offset+l_lenPart1, "Str", l_Part2, "UInt", l_lenPart2)
l_Offset+=l_lenPart1+l_lenPart2
}
lStructSize:=OPENFILENAME := Buffer((A_PtrSize=8) ? 152:88, 0) ; V1toV2: if 'OPENFILENAME' is a UTF-16 string, use 'VarSetStrCapacity(&OPENFILENAME, (A_PtrSize=8) ? 152:88)'
NumPut("UInt", lStructSize, OPENFILENAME, 0)
NumPut(PtrType, hOwner, OPENFILENAME, (A_PtrSize=8) ? 8:4)
NumPut(PtrType, &strFilter, OPENFILENAME, (A_PtrSize=8) ? 24:12)
NumPut("UInt", p_FilterIndex, OPENFILENAME, (A_PtrSize=8) ? 44:24)
NumPut(PtrType, &strFile, OPENFILENAME, (A_PtrSize=8) ? 48:28)
NumPut("UInt", s_strFileMaxSize, OPENFILENAME, (A_PtrSize=8) ? 56:32)
NumPut(PtrType, &l_RootDir, OPENFILENAME, (A_PtrSize=8) ? 80:44)
NumPut(PtrType, &p_Title, OPENFILENAME, (A_PtrSize=8) ? 88:48)
NumPut("UInt", l_Flags, OPENFILENAME, (A_PtrSize=8) ? 96:52)
NumPut(PtrType, &p_DfltExt, OPENFILENAME, (A_PtrSize=8) ? 104:60)
NumPut("UInt", l_FlagsEx, OPENFILENAME, (A_PtrSize=8) ? 148:84)
if (p_Type="O") and (l_Flags & OFN_ALLOWMULTISELECT)
{
hookCallbackAddress:=CallbackCreate(Dlg_OFNHookCallback, "Fast")
NumPut(PtrType, hookCallbackAddress, OPENFILENAME, (A_PtrSize=8) ? 120:68)
}
if (l_Flags & OFN_SHOWHELP) and IsFunc(p_HelpHandler)
{
Dlg_OnHelpMsg("Register",p_HelpHandler,"","")
OnMessage(l_HelpMsg:=DllCall("RegisterWindowMessage", PtrType, HELPMSGSTRING), Dlg_OnHelpMsg)
}
if (p_type="O")
RC:=DllCall("comdlg32\GetOpenFileName" . (1 ? "W":"A"),PtrType,&OPENFILENAME)
else
RC:=DllCall("comdlg32\GetSaveFileName" . (1 ? "W":"A"),PtrType,&OPENFILENAME)
if hookCallbackAddress
DllCall("GlobalFree", PtrType, hookCallbackAddress)
if l_HelpMsg
OnMessage(l_HelpMsg)
if (RC=0)
Return
r_Flags  :=0
l_Flags:=NumGet(OPENFILENAME, (A_PtrSize=8) ? 96:52, "UInt")
if !isSpace(p_DfltExt)
if l_Flags & OFN_EXTENSIONDIFFERENT
r_Flags|=OFN_EXTENSIONDIFFERENT
if (p_Type="O")
if l_Flags & OFN_ALLOWMULTISELECT
{
if Dlg_OFNHookCallback("GetReadOnly","","","")
r_Flags|=OFN_READONLY
}
else
if l_Flags & OFN_READONLY
r_Flags|=OFN_READONLY
l_FileList:=""
l_Offset  :=&strFile
Loop
{
if not nSize:=DllCall("lstrlen" . (1 ? "W":"A"),PtrType,l_Offset)
{
if (A_Index=2)
l_FileList:=l_FileName
Break
}
l_FileName := Buffer(nSize*TCharSize, 0) ; V1toV2: if 'l_FileName' is a UTF-16 string, use 'VarSetStrCapacity(&l_FileName, nSize*TCharSize)'
DllCall("lstrcpyn" . (1 ? "W":"A"),"Str",l_FileName,PtrType,l_Offset,"Int",nSize+1)
l_Offset+=(StrLen(l_FileName)+1)*TCharSize
if (A_Index=1)
{
l_Dir:=l_FileName
if (StrLen(l_Dir)<>3)
l_Dir.="\"
Continue
}
l_FileList.=(StrLen(l_FileList) ? "`n":"") . l_Dir . l_FileName
}
Return l_FileList
}
Dlg_ReplaceText(hOwner,p_Flags,p_FindWhat,p_ReplaceWith,p_Handler,p_HelpHandler:="")
{
Return Dlg_FindReplaceText("R",hOwner,p_Flags,p_FindWhat,p_ReplaceWith,p_Handler,p_HelpHandler)
}
Dlg_SaveFile(hOwner:=0,p_Title:="",p_Filter:="",p_FilterIndex:="",p_Root:="",p_DfltExt:="",&r_Flags:=0,p_HelpHandler:="")
{
Return Dlg_OpenSaveFile("S",hOwner,p_Title,p_Filter,p_FilterIndex,p_Root,p_DfltExt,r_Flags,p_HelpHandler)
}
Class SQLiteDB Extends SQLiteDB.BaseClass {
Class BaseClass {
Static Version := ""
Static _SQLiteDLL := A_ScriptDir . "\SQLite3.dll"
Static _RefCount := 0
Static _MinVersion := "3.6"
}
Class _Table {
__New() {
This.ColumnCount := 0
This.RowCount := 0
This.ColumnNames := []
This.Rows := []
This.HasNames := False
This.HasRows := False
This._CurrentRow := 0
}
GetRow(RowIndex, &Row) {
Row := ""
If (RowIndex < 1 || RowIndex > This.RowCount)
Return False
If !This.Rows.Has(RowIndex)
Return False
Row := This.Rows[RowIndex]
This._CurrentRow := RowIndex
Return True
}
Next(&Row) {
Row := ""
If (This._CurrentRow >= This.RowCount)
Return -1
This._CurrentRow += 1
If !This.Rows.Has(This._CurrentRow)
Return False
Row := This.Rows[This._CurrentRow]
Return True
}
Reset() {
This._CurrentRow := 0
Return True
}
}
Class _RecordSet {
__New() {
This.ColumnCount := 0
This.ColumnNames := []
This.HasNames := False
This.HasRows := False
This.CurrentRow := 0
This.ErrorMsg := ""
This.ErrorCode := 0
This._Handle := 0
This._DB := {}
}
Next(&Row) {
Static SQLITE_NULL := 5
Static SQLITE_BLOB := 4
Static EOR := -1
Row := ""
This.ErrorMsg := ""
This.ErrorCode := 0
If !(This._Handle) {
This.ErrorMsg := "Invalid query handle!"
Return False
}
RC := DllCall("SQlite3.dll\sqlite3_step", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_step failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC <> This._DB._ReturnCode("SQLITE_ROW")) {
If (RC = This._DB._ReturnCode("SQLITE_DONE")) {
This.ErrorMsg := "EOR"
This.ErrorCode := RC
Return EOR
}
This.ErrorMsg := This._DB.ErrMsg()
This.ErrorCode := RC
Return False
}
RC := DllCall("SQlite3.dll\sqlite3_data_count", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_data_count failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC < 1) {
This.ErrorMsg := "RecordSet is empty!"
This.ErrorCode := This._DB._ReturnCode("SQLITE_EMPTY")
Return False
}
Row := []
Loop RC {
Column := A_Index - 1
ColumnType := DllCall("SQlite3.dll\sqlite3_column_type", "Ptr", This._Handle, "Int", Column, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_column_type failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (ColumnType = SQLITE_NULL) {
Row[A_Index] := ""
} Else If (ColumnType = SQLITE_BLOB) {
BlobPtr := DllCall("SQlite3.dll\sqlite3_column_blob", "Ptr", This._Handle, "Int", Column, "Cdecl UPtr")
BlobSize := DllCall("SQlite3.dll\sqlite3_column_bytes", "Ptr", This._Handle, "Int", Column, "Cdecl Int")
If (BlobPtr = 0) || (BlobSize = 0) {
Row[A_Index] := ""
} Else {
Row[A_Index] := {}
Row[A_Index].Size := BlobSize
Row[A_Index].Blob := ""
Row[A_Index].SetCapacity("Blob", BlobSize)
Addr := Row[A_Index].GetAddress("Blob")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", Addr, "Ptr", BlobPtr, "Ptr", BlobSize)
}
} Else {
StrPtr := DllCall("SQlite3.dll\sqlite3_column_text", "Ptr", This._Handle, "Int", Column, "Cdecl UPtr")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_column_text failed!"
This.ErrorCode := ErrorLevel
Return False
}
Row[A_Index] := StrGet(StrPtr, "UTF-8")
}
}
This.CurrentRow += 1
Return True
}
Reset() {
This.ErrorMsg := ""
This.ErrorCode := 0
If !(This._Handle) {
This.ErrorMsg := "Invalid query handle!"
Return False
}
RC := DllCall("SQlite3.dll\sqlite3_reset", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_reset failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := This._DB._ErrMsg()
This.ErrorCode := RC
Return False
}
This.CurrentRow := 0
Return True
}
Free() {
This.ErrorMsg := ""
This.ErrorCode := 0
If !(This._Handle)
Return True
RC := DllCall("SQlite3.dll\sqlite3_finalize", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_finalize failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := This._DB._ErrMsg()
This.ErrorCode := RC
Return False
}
This._DB._Queries.Remove(This._Handle)
This._Handle := 0
Return True
}
}
__New() {
This._Path := ""
This._Handle := 0
This._Queries := {}
If (This.Base._RefCount = 0) {
SQLiteDLL := This.Base._SQLiteDLL
If !FileExist(SQLiteDLL)
If FileExist(A_ScriptDir . "\SQLiteDB.ini") {
SQLiteDLL := IniRead(A_ScriptDir "\SQLiteDB.ini", "Main", "DllPath", SQLiteDLL)
This.Base._SQLiteDLL := SQLiteDLL
}
If !(DLL := DllCall("LoadLibrary", "Str", This.Base._SQLiteDLL, "UPtr")) {
MsgBox("DLL " . SQLiteDLL . " does not exist!", "SQLiteDB Error", 16)
ExitApp()
}
This.Base.Version := StrGet(DllCall("SQlite3.dll\sqlite3_libversion", "Cdecl UPtr"), "UTF-8")
SQLVersion := StrSplit(This.Base.Version, ".")
MinVersion := StrSplit(This.Base._MinVersion, ".")
If (SQLVersion[1] < MinVersion[1]) || ((SQLVersion[1] = MinVersion[1]) && (SQLVersion[2] < MinVersion[2])){
DllCall("FreeLibrary", "Ptr", DLL)
MsgBox("Version " . This.Base.Version .  " of SQLite3.dll is not supported!`n`n". "You can download the current version from www.sqlite.org!", "SQLite ERROR", 16)
ExitApp()
}
}
This.Base._RefCount += 1
}
__Delete() {
If (This._Handle)
This.CloseDB()
This.Base._RefCount -= 1
If (This.Base._RefCount = 0) {
If (DLL := DllCall("GetModuleHandle", "Str", This.Base._SQLiteDLL, "UPtr"))
DllCall("FreeLibrary", "Ptr", DLL)
}
}
_StrToUTF8(Str, &UTF8) {
UTF8 := Buffer(StrPut(Str, "UTF-8"), 0) ; V1toV2: if 'UTF8' is a UTF-16 string, use 'VarSetStrCapacity(&UTF8, StrPut(Str, "UTF-8"))'
StrPut(Str, &UTF8, "UTF-8")
Return &UTF8
}
_UTF8ToStr(UTF8) {
Return StrGet(UTF8, "UTF-8")
}
_ErrMsg() {
If (RC := DllCall("SQLite3.dll\sqlite3_errmsg", "Ptr", This._Handle, "Cdecl UPtr"))
Return StrGet(&RC, "UTF-8")
Return ""
}
_ErrCode() {
Return DllCall("SQLite3.dll\sqlite3_errcode", "Ptr", This._Handle, "Cdecl Int")
}
_Changes() {
Return DllCall("SQLite3.dll\sqlite3_changes", "Ptr", This._Handle, "Cdecl Int")
}
_ReturnCode(RC) {
Static RCODE := {SQLITE_OK: 0, SQLITE_ERROR: 1, SQLITE_INTERNAL: 2, SQLITE_PERM: 3, SQLITE_ABORT: 4, SQLITE_BUSY: 5, SQLITE_LOCKED: 6, SQLITE_NOMEM: 7, SQLITE_READONLY: 8, SQLITE_INTERRUPT: 9, SQLITE_IOERR: 10, SQLITE_CORRUPT: 11, SQLITE_NOTFOUND: 12, SQLITE_FULL: 13, SQLITE_CANTOPEN: 14, SQLITE_PROTOCOL: 15, SQLITE_EMPTY: 16, SQLITE_SCHEMA: 17, SQLITE_TOOBIG: 18, SQLITE_CONSTRAINT: 19, SQLITE_MISMATCH: 20, SQLITE_MISUSE: 21, SQLITE_NOLFS: 22, SQLITE_AUTH: 23, SQLITE_FORMAT: 24, SQLITE_RANGE: 25, SQLITE_NOTADB: 26, SQLITE_ROW: 100, SQLITE_DONE: 101}
Return RCODE.Has(RC) ? RCODE[RC] : ""
}
ErrorMsg := ""
ErrorCode := 0
Changes := 0
SQL := ""
OpenDB(DBPath, Access := "W", Create := True) {
Static SQLITE_OPEN_READONLY  := 0x01
Static SQLITE_OPEN_READWRITE := 0x02
Static SQLITE_OPEN_CREATE    := 0x04
Static MEMDB := ":memory:"
This.ErrorMsg := ""
This.ErrorCode := 0
HDB := 0
If (DBPath = "")
DBPath := MEMDB
If (DBPath = This._Path) && (This._Handle)
Return True
If (This._Handle) {
This.ErrorMsg := "You must first close DB " . This._Path . "!"
Return False
}
Flags := 0
Access := SubStr(Access, 1, 1)
If (Access <> "W") && (Access <> "R")
Access := "R"
Flags := SQLITE_OPEN_READONLY
If (Access = "W") {
Flags := SQLITE_OPEN_READWRITE
If (Create)
Flags |= SQLITE_OPEN_CREATE
}
This._Path := DBPath
This._StrToUTF8(DBPath, UTF8)
RC := DllCall("SQlite3.dll\sqlite3_open_v2", "Ptr", UTF8, "PtrP", &HDB, "Int", Flags, "Ptr", 0, "Cdecl Int")
If (ErrorLevel) {
This._Path := ""
This.ErrorMsg := "DLLCall sqlite3_open_v2 failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This._Path := ""
This.ErrorMsg := This._ErrMsg()
This.ErrorCode := RC
Return False
}
This._Handle := HDB
Return True
}
CloseDB() {
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := ""
If !(This._Handle)
Return True
For Each, Query in This._Queries
DllCall("SQlite3.dll\sqlite3_finalize", "Ptr", Query, "Cdecl Int")
RC := DllCall("SQlite3.dll\sqlite3_close", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_close failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := This._ErrMsg()
This.ErrorCode := RC
Return False
}
This._Path := ""
This._Handle := ""
This._Queries := []
Return True
}
AttachDB(DBPath, DBAlias) {
Return This.Exec("ATTACH DATABASE '" . DBPath . "' As " . DBAlias . ";")
}
DetachDB(DBAlias) {
Return This.Exec("DETACH DATABASE " . DBAlias . ";")
}
Exec(SQL, Callback := "") {
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := SQL
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
CBPtr := 0
Err := 0
If (FO := %Callback%) && (FO.MinParams = 4)
CBPtr := CallbackCreate(%Callback%, "F C", 4)
This._StrToUTF8(SQL, UTF8)
RC := DllCall("SQlite3.dll\sqlite3_exec", "Ptr", This._Handle, "Ptr", UTF8, "Int", CBPtr, "Ptr", Object(This), "PtrP", &Err, "Cdecl Int")
CallError := ErrorLevel
If (CBPtr)
DllCall("Kernel32.dll\GlobalFree", "Ptr", CBPtr)
If (CallError) {
This.ErrorMsg := "DLLCall sqlite3_exec failed!"
This.ErrorCode := CallError
Return False
}
If (RC) {
This.ErrorMsg := StrGet(Err, "UTF-8")
This.ErrorCode := RC
DllCall("SQLite3.dll\sqlite3_free", "Ptr", Err, "Cdecl")
Return False
}
This.Changes := This._Changes()
Return True
}
GetTable(SQL, &TB, MaxResult := 0) {
TB := ""
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := SQL
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
If !RegExMatch(SQL, "i)^\s*(SELECT|PRAGMA)\s") {
This.ErrorMsg := "Method " . A_ThisFunc . " requires a query statement!"
Return False
}
Names := ""
Err := 0, RC := 0, GetRows := 0
I := 0, Rows := Cols := 0
Table := 0
if !isInteger(MaxResult)
MaxResult := 0
If (MaxResult < -2)
MaxResult := 0
This._StrToUTF8(SQL, UTF8)
RC := DllCall("SQlite3.dll\sqlite3_get_table", "Ptr", This._Handle, "Ptr", UTF8, "PtrP", &Table, "IntP", &Rows, "IntP", &Cols, "PtrP", &Err, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_get_table failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := StrGet(Err, "UTF-8")
This.ErrorCode := RC
DllCall("SQLite3.dll\sqlite3_free", "Ptr", Err, "Cdecl")
Return False
}
TB := new This._Table
TB.ColumnCount := Cols
TB.RowCount := Rows
If (MaxResult = -1) {
DllCall("SQLite3.dll\sqlite3_free_table", "Ptr", Table, "Cdecl")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_free_table failed!"
This.ErrorCode := ErrorLevel
Return False
}
Return True
}
If (MaxResult = -2)
GetRows := 0
Else If (MaxResult > 0) && (MaxResult <= Rows)
GetRows := MaxResult
Else
GetRows := Rows
Offset := 0
Names := Array()
Loop Cols {
Names[A_Index] := StrGet(NumGet(Table+0, Offset, "UPtr"), "UTF-8")
Offset += A_PtrSize
}
TB.ColumnNames := Names
TB.HasNames := True
Loop GetRows {
I := A_Index
TB.Rows[I] := []
Loop Cols {
TB.Rows[I][A_Index] := StrGet(NumGet(Table+0, Offset, "UPtr"), "UTF-8")
Offset += A_PtrSize
}
}
If (GetRows)
TB.HasRows := True
DllCall("SQLite3.dll\sqlite3_free_table", "Ptr", Table, "Cdecl")
If (ErrorLevel) {
TB := ""
This.ErrorMsg := "DLLCall sqlite3_free_table failed!"
This.ErrorCode := ErrorLevel
Return False
}
Return True
}
Query(SQL, &RS) {
RS := ""
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := SQL
ColumnCount := 0
HasRows := False
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
If !RegExMatch(SQL, "i)^\s*(SELECT|PRAGMA)\s|") {
This.ErrorMsg := "Method " . A_ThisFunc . " requires a query statement!"
Return False
}
Query := 0
This._StrToUTF8(SQL, UTF8)
RC := DllCall("SQlite3.dll\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", UTF8, "Int", -1, "PtrP", &Query, "Ptr", 0, "Cdecl Int")
If (ErrorLeveL) {
This.ErrorMsg := "DLLCall sqlite3_prepare_v2 failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := This._ErrMsg()
This.ErrorCode := RC
Return False
}
RC := DllCall("SQlite3.dll\sqlite3_column_count", "Ptr", Query, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_column_count failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC < 1) {
This.ErrorMsg := "Query result is empty!"
This.ErrorCode := This._ReturnCode("SQLITE_EMPTY")
Return False
}
ColumnCount := RC
Names := []
Loop RC {
StrPtr := DllCall("SQlite3.dll\sqlite3_column_name", "Ptr", Query, "Int", A_Index - 1, "Cdecl UPtr")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_column_name failed!"
This.ErrorCode := ErrorLevel
Return False
}
Names[A_Index] := StrGet(StrPtr, "UTF-8")
}
RC := DllCall("SQlite3.dll\sqlite3_step", "Ptr", Query, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_step failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC = This._ReturnCode("SQLITE_ROW"))
HasRows := True
RC := DllCall("SQlite3.dll\sqlite3_reset", "Ptr", Query, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_reset failed!"
This.ErrorCode := ErrorLevel
Return False
}
RS := new This._RecordSet
RS.ColumnCount := ColumnCount
RS.ColumnNames := Names
RS.HasNames := True
RS.HasRows := HasRows
RS._Handle := Query
RS._DB := This
This._Queries[Query] := Query
Return True
}
LastInsertRowID(&RowID) {
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := ""
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
RowID := 0
RC := DllCall("SQLite3.dll\sqlite3_last_insert_rowid", "Ptr", This._Handle, "Cdecl Int64")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_last_insert_rowid failed!"
This.ErrorCode := ErrorLevel
Return False
}
RowID := RC
Return True
}
TotalChanges(&Rows) {
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := ""
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
Rows := 0
RC := DllCall("SQLite3.dll\sqlite3_total_changes", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_total_changes failed!"
This.ErrorCode := ErrorLevel
Return False
}
Rows := RC
Return True
}
SetTimeout(Timeout := 1000) {
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := ""
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
if !isInteger(Timeout)
Timeout := 1000
RC := DllCall("SQLite3.dll\sqlite3_busy_timeout", "Ptr", This._Handle, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_busy_timeout failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := This._ErrMsg()
This.ErrorCode := RC
Return False
}
Return True
}
EscapeStr(&Str, Quote := True) {
This.ErrorMsg := ""
This.ErrorCode := 0
This.SQL := ""
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
if isNumber(Str)
Return True
OP := Quote ? "%Q" : "%q"
This._StrToUTF8(Str, UTF8)
Ptr := DllCall("SQLite3.dll\sqlite3_mprintf", "Ptr", OP, "Ptr", UTF8, "Cdecl UPtr")
If (ErrorLevel) {
This.ErrorMsg := "DLLCall sqlite3_mprintf failed!"
This.ErrorCode := ErrorLevel
Return False
}
Str := This._UTF8ToStr(Ptr)
DllCall("SQLite3.dll\sqlite3_free", "Ptr", "Ptr", "Cdecl")
Return True
}
StoreBLOB(SQL, BlobArray) {
Static SQLITE_STATIC := 0
Static SQLITE_TRANSIENT := -1
This.ErrorMsg := ""
This.ErrorCode := 0
If !(This._Handle) {
This.ErrorMsg := "Invalid dadabase handle!"
Return False
}
If !RegExMatch(SQL, "i)^\s*(INSERT|UPDATE|REPLACE)\s") {
This.ErrorMsg := A_ThisFunc . " requires an INSERT/UPDATE/REPLACE statement!"
Return False
}
Query := 0
This._StrToUTF8(SQL, UTF8)
RC := DllCall("SQlite3.dll\sqlite3_prepare_v2", "Ptr", This._Handle, "Ptr", UTF8, "Int", -1, "PtrP", &Query, "Ptr", 0, "Cdecl Int")
If (ErrorLeveL) {
This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_prepare_v2 failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
This.ErrorCode := RC
Return False
}
For BlobNum, Blob In BlobArray {
If !(Blob.Addr) || !(Blob.Size) {
This.ErrorMsg := A_ThisFunc . ": Invalid parameter BlobArray!"
This.ErrorCode := ErrorLevel
Return False
}
RC := DllCall("SQlite3.dll\sqlite3_bind_blob", "Ptr", Query, "Int", BlobNum, "Ptr", Blob.Addr, "Int", Blob.Size, "Ptr", SQLITE_STATIC, "Cdecl Int")
If (ErrorLeveL) {
This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_prepare_v2 failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
This.ErrorCode := RC
Return False
}
}
RC := DllCall("SQlite3.dll\sqlite3_step", "Ptr", Query, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_step failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) && (RC <> This._ReturnCode("SQLITE_DONE")) {
This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
This.ErrorCode := RC
Return False
}
RC := DllCall("SQlite3.dll\sqlite3_finalize", "Ptr", Query, "Cdecl Int")
If (ErrorLevel) {
This.ErrorMsg := A_ThisFunc . ": DLLCall sqlite3_finalize failed!"
This.ErrorCode := ErrorLevel
Return False
}
If (RC) {
This.ErrorMsg := A_ThisFunc . ": " . This._ErrMsg()
This.ErrorCode := RC
Return False
}
Return True
}
ExtErrCode() {
If !(This._Handle)
Return 0
Return DllCall("SQLite3.dll\sqlite3_extended_errcode", "Ptr", This._Handle, "Cdecl Int")
}
}
Class CtlColors {
Static Attached := {}
Static HandledMessages := {Edit: 0, ListBox: 0, Static: 0}
Static MessageHandler := "CtlColors_OnMessage"
Static WM_CTLCOLOR := {Edit: 0x0133, ListBox: 0x134, Static: 0x0138}
Static HTML := {AQUA: 0xFFFF00, BLACK: 0x000000, BLUE: 0xFF0000, FUCHSIA: 0xFF00FF, GRAY: 0x808080, GREEN: 0x008000, LIME: 0x00FF00, MAROON: 0x000080, NAVY: 0x800000, OLIVE: 0x008080, PURPLE: 0x800080, RED: 0x0000FF, SILVER: 0xC0C0C0, TEAL: 0x808000, WHITE: 0xFFFFFF, YELLOW: 0x00FFFF}
Static NullBrush := DllCall("GetStockObject", "Int", 5, "UPtr")
Static SYSCOLORS := {Edit: "", ListBox: "", Static: ""}
Static ErrorMsg := ""
Static InitClass := CtlColors.ClassInit()
__New() {
If (This.InitClass == "!DONE!") {
This["!Access_Denied!"] := True
Return False
}
}
__Delete() {
If This["!Access_Denied!"]
Return
This.Free()
}
ClassInit() {
CtlColors := New CtlColors
Return "!DONE!"
}
CheckBkColor(&BkColor, Class) {
This.ErrorMsg := ""
If (BkColor != "") && !This.HTML.Has(BkColor) && !RegExMatch(BkColor, "^[[:xdigit:]]{6}$") {
This.ErrorMsg := "Invalid parameter BkColor: " . BkColor
Return False
}
BkColor := BkColor = "" ? This.SYSCOLORS[Class]
:  This.HTML.Has(BkColor) ? This.HTML[BkColor]
:  "0x" . SubStr(BkColor, 5, 2) . SubStr(BkColor, 3, 2) . SubStr(BkColor, 1, 2)
Return True
}
CheckTxColor(&TxColor) {
This.ErrorMsg := ""
If (TxColor != "") && !This.HTML.Has(TxColor) && !RegExMatch(TxColor, "i)^[[:xdigit:]]{6}$") {
This.ErrorMsg := "Invalid parameter TextColor: " . TxColor
Return False
}
TxColor := TxColor = "" ? ""
:  This.HTML.Has(TxColor) ? This.HTML[TxColor]
:  "0x" . SubStr(TxColor, 5, 2) . SubStr(TxColor, 3, 2) . SubStr(TxColor, 1, 2)
Return True
}
Attach(HWND, BkColor, TxColor := "") {
Static ClassNames := {Button: "", ComboBox: "", Edit: "", ListBox: "", Static: ""}
Static BS_CHECKBOX := 0x2, BS_RADIOBUTTON := 0x8
Static ES_READONLY := 0x800
Static COLOR_3DFACE := 15, COLOR_WINDOW := 5
If (This.SYSCOLORS.Edit = "") {
This.SYSCOLORS.Static := DllCall("User32.dll\GetSysColor", "Int", COLOR_3DFACE, "UInt")
This.SYSCOLORS.Edit := DllCall("User32.dll\GetSysColor", "Int", COLOR_WINDOW, "UInt")
This.SYSCOLORS.ListBox := This.SYSCOLORS.Edit
}
This.ErrorMsg := ""
If (BkColor = "") && (TxColor = "") {
This.ErrorMsg := "Both parameters BkColor and TxColor are empty!"
Return False
}
If !(CtrlHwnd := HWND + 0) || !DllCall("User32.dll\IsWindow", "UPtr", HWND, "UInt") {
This.ErrorMsg := "Invalid parameter HWND: " . HWND
Return False
}
If This.Attached.Has(HWND) {
This.ErrorMsg := "Control " . HWND . " is already registered!"
Return False
}
Hwnds := [CtrlHwnd]
Classes := ""
CtrlClass := WinGetClass("ahk_id " CtrlHwnd)
This.ErrorMsg := "Unsupported control class: " . CtrlClass
If !ClassNames.Has(CtrlClass)
Return False
CtrlStyle := ControlGetStyle(, "ahk_id " CtrlHwnd)
If (CtrlClass = "Edit")
Classes := ["Edit", "Static"]
Else If (CtrlClass = "Button") {
IF (CtrlStyle & BS_RADIOBUTTON) || (CtrlStyle & BS_CHECKBOX)
Classes := ["Static"]
Else
Return False
}
Else If (CtrlClass = "ComboBox") {
CBBI := Buffer(40 + (A_PtrSize * 3), 0) ; V1toV2: if 'CBBI' is a UTF-16 string, use 'VarSetStrCapacity(&CBBI, 40 + (A_PtrSize * 3))'
NumPut("UInt", 40 + (A_PtrSize * 3), CBBI, 0)
DllCall("User32.dll\GetComboBoxInfo", "Ptr", CtrlHwnd, "Ptr", CBBI)
Hwnds.Insert(NumGet(CBBI, 40 + (A_PtrSize * 2, "UPtr"), "UPtr") + 0)
Hwnds.Insert(NumGet(CBBI, 40 + A_PtrSize, "UPtr") + 0)
Classes := ["Edit", "Static", "ListBox"]
}
If !IsObject(Classes)
Classes := [CtrlClass]
If (BkColor <> "Trans")
If !This.CheckBkColor(BkColor, Classes[1])
Return False
If !This.CheckTxColor(TxColor)
Return False
For I, V In Classes {
If (This.HandledMessages[V] = 0)
OnMessage(This.WM_CTLCOLOR[V], %This.MessageHandler%)
This.HandledMessages[V] += 1
}
If (BkColor = "Trans")
Brush := This.NullBrush
Else
Brush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", BkColor, "UPtr")
For I, V In Hwnds
This.Attached[V] := {Brush: Brush, TxColor: TxColor, BkColor: BkColor, Classes: Classes, Hwnds: Hwnds}
DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
This.ErrorMsg := ""
Return True
}
Change(HWND, BkColor, TxColor := "") {
This.ErrorMsg := ""
HWND += 0
If !This.Attached.Has(HWND)
Return This.Attach(HWND, BkColor, TxColor)
CTL := This.Attached[HWND]
If (BkColor <> "Trans")
If !This.CheckBkColor(BkColor, CTL.Classes[1])
Return False
If !This.CheckTxColor(TxColor)
Return False
If (BkColor <> CTL.BkColor) {
If (CTL.Brush) {
If (Ctl.Brush <> This.NullBrush)
DllCall("Gdi32.dll\DeleteObject", "Prt", CTL.Brush)
This.Attached[HWND].Brush := 0
}
If (BkColor = "Trans")
Brush := This.NullBrush
Else
Brush := DllCall("Gdi32.dll\CreateSolidBrush", "UInt", BkColor, "UPtr")
For I, V In CTL.Hwnds {
This.Attached[V].Brush := Brush
This.Attached[V].BkColor := BkColor
}
}
For I, V In Ctl.Hwnds
This.Attached[V].TxColor := TxColor
This.ErrorMsg := ""
DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
Return True
}
Detach(HWND) {
This.ErrorMsg := ""
HWND += 0
If This.Attached.Has(HWND) {
CTL := This.Attached[HWND].Clone()
If (CTL.Brush) && (CTL.Brush <> This.NullBrush)
DllCall("Gdi32.dll\DeleteObject", "Prt", CTL.Brush)
For I, V In CTL.Classes {
If This.HandledMessages[V] > 0 {
This.HandledMessages[V] -= 1
If This.HandledMessages[V] = 0
OnMessage(This.WM_CTLCOLOR[V])
}  }
For I, V In CTL.Hwnds
This.Attached.Remove(V, "")
DllCall("User32.dll\InvalidateRect", "Ptr", HWND, "Ptr", 0, "Int", 1)
CTL := ""
Return True
}
This.ErrorMsg := "Control " . HWND . " is not registered!"
Return False
}
Free() {
For K, V In This.Attached
If (V.Brush) && (V.Brush <> This.NullBrush)
DllCall("Gdi32.dll\DeleteObject", "Ptr", V.Brush)
For K, V In This.HandledMessages
If (V > 0) {
OnMessage(This.WM_CTLCOLOR[K])
This.HandledMessages[K] := 0
}
This.Attached := {}
Return True
}
IsAttached(HWND) {
Return This.Attached.Has(HWND)
}
}
CtlColors_OnMessage(HDC, HWND) {
Critical()
If CtlColors.IsAttached(HWND) {
CTL := CtlColors.Attached[HWND]
If (CTL.TxColor != "")
DllCall("Gdi32.dll\SetTextColor", "Ptr", HDC, "UInt", CTL.TxColor)
If (CTL.BkColor = "Trans")
DllCall("Gdi32.dll\SetBkMode", "Ptr", HDC, "UInt", 1)
Else
DllCall("Gdi32.dll\SetBkColor", "Ptr", HDC, "UInt", CTL.BkColor)
Return CTL.Brush
}
}
class WinClip_base
{
__Call( aTarget, aParams* ) {
if ObjHasKey( WinClip_base, aTarget )
return WinClip_base[ aTarget ].Call( this, aParams* )
throw Exception( "Unknown function '" aTarget "' requested from object '" this.__Class "'", -1 )
}
Err( msg ) {
throw Exception( this.__Class " : " msg ( A_LastError != 0 ? "`n" this.ErrorFormat( A_LastError ) : "" ), -2 )
}
ErrorFormat( error_id ) {
msg := Buffer(1000, 0) ; V1toV2: if 'msg' is a UTF-16 string, use 'VarSetStrCapacity(&msg, 1000)'
if !len := DllCall("FormatMessageW", "UInt", FORMAT_MESSAGE_FROM_SYSTEM := 0x00001000 | FORMAT_MESSAGE_IGNORE_INSERTS := 0x00000200, "Ptr", 0, "UInt", error_id, "UInt", 0, "Ptr", msg, "UInt", 500)
return
return strget(&msg,len)
}
}
class WinClipAPI_base extends WinClip_base
{
__Get( name ) {
if !ObjHasKey( this, initialized )
this.Init()
else
throw Exception( "Unknown field '" name "' requested from object '" this.__Class "'", -1 )
}
}
class WinClipAPI extends WinClip_base
{
memcopy( dest, src, size ) {
return DllCall("msvcrt\memcpy", "ptr", dest, "ptr", src, "uint", size)
}
GlobalSize( hObj ) {
return DllCall("GlobalSize", "Ptr", hObj)
}
GlobalLock( hMem ) {
return DllCall("GlobalLock", "Ptr", hMem)
}
GlobalUnlock( hMem ) {
return DllCall("GlobalUnlock", "Ptr", hMem)
}
GlobalAlloc( flags, size ) {
return DllCall("GlobalAlloc", "Uint", flags, "Uint", size)
}
OpenClipboard() {
return DllCall("OpenClipboard", "Ptr", 0)
}
CloseClipboard() {
return DllCall("CloseClipboard")
}
SetClipboardData( format, hMem ) {
return DllCall("SetClipboardData", "Uint", format, "Ptr", hMem)
}
GetClipboardData( format ) {
return DllCall("GetClipboardData", "Uint", format)
}
EmptyClipboard() {
return DllCall("EmptyClipboard")
}
EnumClipboardFormats( format ) {
return DllCall("EnumClipboardFormats", "UInt", format)
}
CountClipboardFormats() {
return DllCall("CountClipboardFormats")
}
GetClipboardFormatName( iFormat ) {
size := bufName := Buffer(255*( 1 ? 2 : 1 ), 0) ; V1toV2: if 'bufName' is a UTF-16 string, use 'VarSetStrCapacity(&bufName, 255*( A_IsUnicode ? 2 : 1 ))'
DllCall("GetClipboardFormatName", "Uint", iFormat, "str", bufName, "Uint", size)
return bufName
}
GetEnhMetaFileBits( hemf, &buf ) {
if !( bufSize := DllCall("GetEnhMetaFileBits", "Ptr", hemf, "Uint", 0, "Ptr", 0) )
return 0
buf := Buffer(bufSize, 0) ; V1toV2: if 'buf' is a UTF-16 string, use 'VarSetStrCapacity(&buf, bufSize)'
if !( bytesCopied := DllCall("GetEnhMetaFileBits", "Ptr", hemf, "Uint", bufSize, "Ptr", buf) )
return 0
return bytesCopied
}
SetEnhMetaFileBits( pBuf, bufSize ) {
return DllCall("SetEnhMetaFileBits", "Uint", bufSize, "Ptr", pBuf)
}
DeleteEnhMetaFile( hemf ) {
return DllCall("DeleteEnhMetaFile", "Ptr", hemf)
}
ErrorFormat(error_id) {
msg := Buffer(1000, 0) ; V1toV2: if 'msg' is a UTF-16 string, use 'VarSetStrCapacity(&msg, 1000)'
if !len := DllCall("FormatMessageW", "UInt", FORMAT_MESSAGE_FROM_SYSTEM := 0x00001000 | FORMAT_MESSAGE_IGNORE_INSERTS := 0x00000200, "Ptr", 0, "UInt", error_id, "UInt", 0, "Ptr", msg, "UInt", 500)
return
return strget(&msg,len)
}
IsInteger( var ) {
if (var+0 == var) && (Floor(var) == var)
return True
else
return False
}
LoadDllFunction( file, function ) {
if !hModule := DllCall("GetModuleHandleW", "Wstr", file, "UPtr")
hModule := DllCall("LoadLibraryW", "Wstr", file, "UPtr")
ret := DllCall("GetProcAddress", "Ptr", hModule, "AStr", function, "UPtr")
return ret
}
SendMessage( hWnd, Msg, wParam, lParam ) {
static SendMessageW
If not SendMessageW
SendMessageW := this.LoadDllFunction( "user32.dll", "SendMessageW" )
ret := DllCall(SendMessageW, "UPtr", hWnd, "UInt", Msg, "UPtr", wParam, "UPtr", lParam)
return ret
}
GetWindowThreadProcessId( hwnd ) {
return DllCall("GetWindowThreadProcessId", "Ptr", hwnd, "Ptr", 0)
}
WinGetFocus( hwnd ) {
GUITHREADINFO_cbsize := 24 + A_PtrSize*6
GuiThreadInfo := Buffer(GUITHREADINFO_cbsize, 0) ; V1toV2: if 'GuiThreadInfo' is a UTF-16 string, use 'VarSetStrCapacity(&GuiThreadInfo, GUITHREADINFO_cbsize)'
NumPut("UInt", GUITHREADINFO_cbsize, GuiThreadInfo, 0)
threadWnd := this.GetWindowThreadProcessId( hwnd )
if not DllCall("GetGUIThreadInfo", "uint", threadWnd, "UPtr", GuiThreadInfo)
return 0
return NumGet(GuiThreadInfo, 8+A_PtrSize, "UPtr")
}
GetPixelInfo( &DIB ) {
bmi := &DIB
biSize := NumGet(bmi+0, 0, "UInt")
biSizeImage := NumGet(bmi+0, 20, "UInt")
biBitCount := NumGet(bmi+0, 14, "UShort")
if ( biSizeImage == 0 )
{
biWidth := NumGet(bmi+0, 4, "UInt")
biHeight := NumGet(bmi+0, 8, "UInt")
biSizeImage := (((( biWidth * biBitCount + 31 ) & ~31 ) >> 3 ) * biHeight )
NumPut("UInt", biSizeImage, bmi+0, 20)
}
p := NumGet(bmi+0, 32, "UInt")
if ( p == 0 && biBitCount <= 8 )
p := 1 << biBitCount
p := p * 4 + biSize + bmi
return p
}
Gdip_Startup() {
if !DllCall("GetModuleHandleW", "Wstr", "gdiplus", "UPtr")
DllCall("LoadLibraryW", "Wstr", "gdiplus", "UPtr")
GdiplusStartupInput := Buffer(3*A_PtrSize, 0), NumPut("UInt", 1, GdiplusStartupInput, 0) ; V1toV2: if 'GdiplusStartupInput' is a UTF-16 string, use 'VarSetStrCapacity(&GdiplusStartupInput, 3*A_PtrSize)'
DllCall("gdiplus\GdiplusStartup", "Ptr*", &pToken, "Ptr", GdiplusStartupInput, "Ptr", 0)
return pToken
}
Gdip_Shutdown(pToken) {
DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
if hModule := DllCall("GetModuleHandleW", "Wstr", "gdiplus", "UPtr")
DllCall("FreeLibrary", "Ptr", hModule)
return 0
}
StrSplit(str,delim,omit := "") {
if (strlen(delim) > 1)
{
str := StrReplace(str, delim, "ƒ")
delim := "ƒ"
}
ra := Array()
Loop Parse, str, delim, omit
if (A_LoopField != "")
ra.Insert(A_LoopField)
return ra
}
RemoveDubls( objArray ) {
while True
{
nodubls := 1
tempArr := Object()
for i,val in objArray
{
if tempArr.Has(val)
{
nodubls := 0
objArray.Remove( i )
break
}
tempArr[ val ] := 1
}
if nodubls
break
}
return objArray
}
RegisterClipboardFormat( fmtName ) {
return DllCall("RegisterClipboardFormat", "ptr", fmtName)
}
GetOpenClipboardWindow() {
return DllCall("GetOpenClipboardWindow")
}
IsClipboardFormatAvailable( iFmt ) {
return DllCall("IsClipboardFormatAvailable", "UInt", iFmt)
}
GetImageEncodersSize( &numEncoders, &size ) {
return DllCall("gdiplus\GdipGetImageEncodersSize", "Uint*", &numEncoders, "UInt*", &size)
}
GetImageEncoders( numEncoders, size, pImageCodecInfo ) {
return DllCall("gdiplus\GdipGetImageEncoders", "Uint", numEncoders, "UInt", size, "Ptr", pImageCodecInfo)
}
GetEncoderClsid( format, &CLSID ) {
if !format
return 0
format := "image/" format
this.GetImageEncodersSize( num, size )
if ( size = 0 )
return 0
ImageCodecInfo := Buffer(size, 0) ; V1toV2: if 'ImageCodecInfo' is a UTF-16 string, use 'VarSetStrCapacity(&ImageCodecInfo, size)'
this.GetImageEncoders( num, size, &ImageCodecInfo )
Loop num
{
pici := &ImageCodecInfo + ( 48+7*A_PtrSize )*(A_Index-1)
pMime := NumGet(pici+0, 32+4*A_PtrSize, "UPtr")
MimeType := StrGet( pMime, "UTF-16")
if ( MimeType = format )
{
CLSID := Buffer(16, 0) ; V1toV2: if 'CLSID' is a UTF-16 string, use 'VarSetStrCapacity(&CLSID, 16)'
this.memcopy( &CLSID, pici, 16 )
return 1
}
}
return 0
}
}
class WinClip extends WinClip_base
{
__New()
{
this.isinstance := 1
this.allData := ""
}
_toclipboard( &data, size )
{
if !WinClipAPI.OpenClipboard()
return 0
offset := 0
lastPartOffset := 0
WinClipAPI.EmptyClipboard()
while ( offset < size )
{
if !( fmt := NumGet(data, offset, "UInt") )
break
offset += 4
if !( dataSize := NumGet(data, offset, "UInt") )
break
offset += 4
if ( ( offset + dataSize ) > size )
break
if !( pData := WinClipAPI.GlobalLock( WinClipAPI.GlobalAlloc( 0x0042, dataSize ) ) )
{
offset += dataSize
continue
}
WinClipAPI.memcopy( pData, &data + offset, dataSize )
if ( fmt == this.ClipboardFormats.CF_ENHMETAFILE )
pClipData := WinClipAPI.SetEnhMetaFileBits( pData, dataSize )
else
pClipData := pData
if !pClipData
continue
WinClipAPI.SetClipboardData( fmt, pClipData )
if ( fmt == this.ClipboardFormats.CF_ENHMETAFILE )
WinClipAPI.DeleteEnhMetaFile( pClipData )
WinClipAPI.GlobalUnlock( pData )
offset += dataSize
lastPartOffset := offset
}
WinClipAPI.CloseClipboard()
return lastPartOffset
}
_fromclipboard( &clipData )
{
if !WinClipAPI.OpenClipboard()
return 0
nextformat := 0
objFormats := Object()
clipSize := 0
formatsNum := 0
while ( nextformat := WinClipAPI.EnumClipboardFormats( nextformat ) )
{
if this.skipFormats.Has(nextformat)
continue
if ( dataHandle := WinClipAPI.GetClipboardData( nextformat ) )
{
pObjPtr := 0, nObjSize := 0
if ( nextformat == this.ClipboardFormats.CF_ENHMETAFILE )
{
if ( bufSize := WinClipAPI.GetEnhMetaFileBits( dataHandle, hemfBuf ) )
pObjPtr := &hemfBuf, nObjSize := bufSize
}
else if ( nSize := WinClipAPI.GlobalSize( WinClipAPI.GlobalLock( dataHandle ) ) )
pObjPtr := dataHandle, nObjSize := nSize
else
continue
if !( pObjPtr && nObjSize )
continue
objFormats[ nextformat ] := { handle : pObjPtr, size : nObjSize }
clipSize += nObjSize
formatsNum++
}
}
structSize := formatsNum*( 4 + 4 ) + clipSize
if !structSize
{
WinClipAPI.CloseClipboard()
return 0
}
clipData := Buffer(structSize, 0) ; V1toV2: if 'clipData' is a UTF-16 string, use 'VarSetStrCapacity(&clipData, structSize)'
offset := 0
for fmt, params in objFormats
{
NumPut("UInt", fmt, &clipData, offset)
offset += 4
NumPut("UInt", params.size, &clipData, offset)
offset += 4
WinClipAPI.memcopy( &clipData + offset, params.handle, params.size )
offset += params.size
WinClipAPI.GlobalUnlock( params.handle )
}
WinClipAPI.CloseClipboard()
return structSize
}
_IsInstance( funcName )
{
if !this.isinstance
{
throw Exception( "Error in '" funcName "':`nInstantiate the object first to use this method!", -1 )
return 0
}
return 1
}
_loadFile( filePath, &Data )
{
f := FileOpen( filePath, "r","CP0" )
if !IsObject( f )
return 0
f.Pos := 0
dataSize := f.RawRead( Data, f.Length )
f.close()
return dataSize
}
_saveFile( filepath, &data, size )
{
f := FileOpen( filepath, "w","CP0" )
bytes := f.RawWrite( &data, size )
f.close()
return bytes
}
_setClipData( &data, size )
{
if !size
return 0
if !ObjSetCapacity( this, "allData", size )
return 0
if !( pData := ObjGetAddress( this, "allData" ) )
return 0
WinClipAPI.memcopy( pData, &data, size )
return size
}
_getClipData( &data )
{
if !( clipSize := ObjGetCapacity( this, "allData" ) )
return 0
if !( pData := ObjGetAddress( this, "allData" ) )
return 0
data := Buffer(clipSize, 0) ; V1toV2: if 'data' is a UTF-16 string, use 'VarSetStrCapacity(&data, clipSize)'
WinClipAPI.memcopy( &data, pData, clipSize )
return clipSize
}
__Delete()
{
ObjSetCapacity( this, "allData", 0 )
return
}
_parseClipboardData( &data, size )
{
offset := 0
formats := Object()
while ( offset < size )
{
if !( fmt := NumGet(data, offset, "UInt") )
break
offset += 4
if !( dataSize := NumGet(data, offset, "UInt") )
break
offset += 4
if ( ( offset + dataSize ) > size )
break
params := { name : this._getFormatName( fmt ), size : dataSize }
ObjSetCapacity( params, "buffer", dataSize )
pBuf := ObjGetAddress( params, "buffer" )
WinClipAPI.memcopy( pBuf, &data + offset, dataSize )
formats[ fmt ] := params
offset += dataSize
}
return formats
}
_compileClipData( &out_data, objClip )
{
if !IsObject( objClip )
return 0
clipSize := 0
for fmt, params in objClip
clipSize += 8 + params.size
out_data := Buffer(clipSize, 0) ; V1toV2: if 'out_data' is a UTF-16 string, use 'VarSetStrCapacity(&out_data, clipSize)'
offset := 0
for fmt, params in objClip
{
NumPut("UInt", fmt, out_data, offset)
offset += 4
NumPut("UInt", params.size, out_data, offset)
offset += 4
WinClipAPI.memcopy( &out_data + offset, ObjGetAddress( params, "buffer" ), params.size )
offset += params.size
}
return clipSize
}
GetFormats()
{
if !( clipSize := this._fromclipboard( clipData ) )
return 0
return this._parseClipboardData( clipData, clipSize )
}
iGetFormats()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return 0
return this._parseClipboardData( clipData, clipSize )
}
Snap( &data )
{
return this._fromclipboard( data )
}
iSnap()
{
this._IsInstance( A_ThisFunc )
if !( dataSize := this._fromclipboard( clipData ) )
return 0
return this._setClipData( clipData, dataSize )
}
Restore( &clipData )
{
clipSize := VarSetStrCapacity(&clipData) ; V1toV2: if 'clipData' is NOT a UTF-16 string, use 'clipData := Buffer()'
return this._toclipboard( clipData, clipSize )
}
iRestore()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return 0
return this._toclipboard( clipData, clipSize )
}
Save( filePath )
{
if !( size := this._fromclipboard( data ) )
return 0
return this._saveFile( filePath, data, size )
}
iSave( filePath )
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return 0
return this._saveFile( filePath, clipData, clipSize )
}
Load( filePath )
{
if !( dataSize := this._loadFile( filePath, dataBuf ) )
return 0
return this._toclipboard( dataBuf, dataSize )
}
iLoad( filePath )
{
this._IsInstance( A_ThisFunc )
if !( dataSize := this._loadFile( filePath, dataBuf ) )
return 0
return this._setClipData( dataBuf, dataSize )
}
Clear()
{
if !WinClipAPI.OpenClipboard()
return 0
WinClipAPI.EmptyClipboard()
WinClipAPI.CloseClipboard()
return 1
}
iClear()
{
this._IsInstance( A_ThisFunc )
ObjSetCapacity( this, "allData", 0 )
}
Copy( timeout := 1, method := 1 )
{
this.Snap( data )
this.Clear()
if( method = 1 )
SendInput("^{Ins}")
else
SendInput("^{vk43sc02E}")
Errorlevel := !ClipWait(timeout, 1)
if ( ret := this._isClipEmpty() )
this.Restore( data )
return !ret
}
iCopy( timeout := 1, method := 1 )
{
this._IsInstance( A_ThisFunc )
this.Snap( data )
this.Clear()
if( method = 1 )
SendInput("^{Ins}")
else
SendInput("^{vk43sc02E}")
Errorlevel := !ClipWait(timeout, 1)
bytesCopied := 0
if !this._isClipEmpty()
{
this.iClear()
bytesCopied := this.iSnap()
}
this.Restore( data )
return bytesCopied
}
Paste( plainText := "", method := 1 )
{
ret := 0
if ( plainText != "" )
{
this.Snap( data )
this.Clear()
ret := this.SetText( plainText )
}
if( method = 1 )
SendInput("+{Ins}")
else
SendInput("^{vk56sc02F}")
this._waitClipReady( 3000 )
if ( plainText != "" )
{
this.Restore( data )
}
else
ret := !this._isClipEmpty()
return ret
}
iPaste( method := 1 )
{
this._IsInstance( A_ThisFunc )
this.Snap( data )
if !( bytesRestored := this.iRestore() )
return 0
if( method = 1 )
SendInput("+{Ins}")
else
SendInput("^{vk56sc02F}")
this._waitClipReady( 3000 )
this.Restore( data )
return bytesRestored
}
IsEmpty()
{
return this._isClipEmpty()
}
iIsEmpty()
{
return !this.iGetSize()
}
_isClipEmpty()
{
return !WinClipAPI.CountClipboardFormats()
}
_waitClipReady( timeout := 10000 )
{
start_time := A_TickCount
Sleep(100)
while ( WinClipAPI.GetOpenClipboardWindow() && ( A_TickCount - start_time < timeout ) )
Sleep(100)
}
iSetText( textData )
{
if ( textData = "" )
return 0
this._IsInstance( A_ThisFunc )
clipSize := this._getClipData( clipData )
if !( clipSize := this._appendText( clipData, clipSize, textData, 1 ) )
return 0
return this._setClipData( clipData, clipSize )
}
SetText( textData )
{
if ( textData = "" )
return 0
clipSize :=  this._fromclipboard( clipData )
if !( clipSize := this._appendText( clipData, clipSize, textData, 1 ) )
return 0
return this._toclipboard( clipData, clipSize )
}
GetRTF()
{
if !( clipSize := this._fromclipboard( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, "Rich Text Format" ) )
return ""
return strget( &out_data, out_size, "CP0" )
}
iGetRTF()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, "Rich Text Format" ) )
return ""
return strget( &out_data, out_size, "CP0" )
}
SetRTF( textData )
{
if ( textData = "" )
return 0
clipSize :=  this._fromclipboard( clipData )
if !( clipSize := this._setRTF( clipData, clipSize, textData ) )
return 0
return this._toclipboard( clipData, clipSize )
}
iSetRTF( textData )
{
if ( textData = "" )
return 0
this._IsInstance( A_ThisFunc )
clipSize :=  this._getClipData( clipData )
if !( clipSize := this._setRTF( clipData, clipSize, textData ) )
return 0
return this._setClipData( clipData, clipSize )
}
_setRTF( &clipData, clipSize, textData )
{
objFormats := this._parseClipboardData( clipData, clipSize )
uFmt := WinClipAPI.RegisterClipboardFormat( "Rich Text Format" )
objFormats[ uFmt ] := Object()
sLen := StrLen( textData )
ObjSetCapacity( objFormats[ uFmt ], "buffer", sLen )
StrPut( textData, ObjGetAddress( objFormats[ uFmt ], "buffer" ), sLen, "CP0" )
objFormats[ uFmt ].size := sLen
return this._compileClipData( clipData, objFormats )
}
iAppendText( textData )
{
if ( textData = "" )
return 0
this._IsInstance( A_ThisFunc )
clipSize := this._getClipData( clipData )
if !( clipSize := this._appendText( clipData, clipSize, textData ) )
return 0
return this._setClipData( clipData, clipSize )
}
AppendText( textData )
{
if ( textData = "" )
return 0
clipSize :=  this._fromclipboard( clipData )
if !( clipSize := this._appendText( clipData, clipSize, textData ) )
return 0
return this._toclipboard( clipData, clipSize )
}
SetHTML( html, source := "" )
{
if ( html = "" )
return 0
clipSize :=  this._fromclipboard( clipData )
if !( clipSize := this._setHTML( clipData, clipSize, html, source ) )
return 0
return this._toclipboard( clipData, clipSize )
}
iSetHTML( html, source := "" )
{
if ( html = "" )
return 0
this._IsInstance( A_ThisFunc )
clipSize := this._getClipData( clipData )
if !( clipSize := this._setHTML( clipData, clipSize, html, source ) )
return 0
return this._setClipData( clipData, clipSize )
}
_calcHTMLLen( num )
{
while ( StrLen( num ) < 10 )
num := "0" . num
return num
}
_setHTML( &clipData, clipSize, htmlData, source )
{
objFormats := this._parseClipboardData( clipData, clipSize )
uFmt := WinClipAPI.RegisterClipboardFormat( "HTML Format" )
objFormats[ uFmt ] := Object()
encoding := "UTF-8"
htmlLen := StrPut( htmlData, encoding ) - 1
srcLen := 2 + 10 + StrPut( source, encoding ) - 1
StartHTML := this._calcHTMLLen( 105 + srcLen )
EndHTML := this._calcHTMLLen( StartHTML + htmlLen + 76 )
StartFragment := this._calcHTMLLen( StartHTML + 38 )
EndFragment := this._calcHTMLLen( StartFragment + htmlLen )
html := "Version:0.9`r`n"
html .= "StartHTML:" . StartHTML . "`r`n"
html .= "EndHTML:" . EndHTML . "`r`n"
html .= "StartFragment:" . StartFragment . "`r`n"
html .= "EndFragment:" . EndFragment . "`r`n"
html .= "SourceURL:" . source . "`r`n"
html .= "<html>`r`n"
html .= "<body>`r`n"
html .= "<!--StartFragment-->`r`n"
html .= htmlData . "`r`n"
html .= "<!--EndFragment-->`r`n"
html .= "</body>`r`n"
html .= "</html>`r`n"
sLen := StrPut( html, encoding )
ObjSetCapacity( objFormats[ uFmt ], "buffer", sLen )
StrPut( html, ObjGetAddress( objFormats[ uFmt ], "buffer" ), sLen, encoding )
objFormats[ uFmt ].size := sLen
return this._compileClipData( clipData, objFormats )
}
_appendText( &clipData, clipSize, textData){
objFormats := this._parseClipboardData( clipData, clipSize )
uFmt := this.ClipboardFormats.CF_UNICODETEXT
str := ""
if ( objFormats.Has(uFmt))
str := strget( ObjGetAddress( objFormats[ uFmt ],  "buffer" ), "UTF-16" )
else
objFormats[ uFmt ] := Object()
str .= textData
sLen := ( StrLen( str ) + 1 ) * 2
ObjSetCapacity( objFormats[ uFmt ], "buffer", sLen )
StrPut( str, ObjGetAddress( objFormats[ uFmt ], "buffer" ), sLen, "UTF-16" )
objFormats[ uFmt ].size := sLen
return this._compileClipData( clipData, objFormats )
}
_getFiles( pDROPFILES )
{
fWide := NumGet(pDROPFILES + 0, 16, "uchar")
pFiles := NumGet(pDROPFILES + 0, 0, "UInt") + pDROPFILES
list := ""
while NumGet(pFiles + 0, 0, fWide ? "UShort" : "UChar")
{
lastPath := strget( pFiles+0, fWide ? "UTF-16" : "CP0" )
list .= ( list ? "`n" : "" ) lastPath
pFiles += ( StrLen( lastPath ) + 1 ) * ( fWide ? 2 : 1 )
}
return list
}
_setFiles( &clipData, clipSize, files, append := 0, isCut := 0 )
{
objFormats := this._parseClipboardData( clipData, clipSize )
uFmt := this.ClipboardFormats.CF_HDROP
if ( append && objFormats.Has(uFmt) )
prevList := this._getFiles( ObjGetAddress( objFormats[ uFmt ], "buffer" ) ) "`n"
objFiles := WinClipAPI.StrSplit( prevList . files, "`n", A_Space A_Tab )
objFiles := WinClipAPI.RemoveDubls( objFiles )
if !objFiles.MaxIndex()
return 0
objFormats[ uFmt ] := Object()
DROP_size := 20 + 2
for i,str in objFiles
DROP_size += ( StrLen( str ) + 1 ) * 2
DROPFILES := Buffer(DROP_size, 0) ; V1toV2: if 'DROPFILES' is a UTF-16 string, use 'VarSetStrCapacity(&DROPFILES, DROP_size)'
NumPut("UInt", 20, DROPFILES, 0)
NumPut("uchar", 1, DROPFILES, 16)
offset := &DROPFILES + 20
for i,str in objFiles
{
StrPut( str, offset, "UTF-16" )
offset += ( StrLen( str ) + 1 ) * 2
}
ObjSetCapacity( objFormats[ uFmt ], "buffer", DROP_size )
WinClipAPI.memcopy( ObjGetAddress( objFormats[ uFmt ], "buffer" ), &DROPFILES, DROP_size )
objFormats[ uFmt ].size := DROP_size
prefFmt := WinClipAPI.RegisterClipboardFormat( "Preferred DropEffect" )
objFormats[ prefFmt ] := { size : 4 }
ObjSetCapacity( objFormats[ prefFmt ], "buffer", 4 )
NumPut("UInt", isCut ? 2 : 5, ObjGetAddress( objFormats[ prefFmt ], "buffer" ), 0)
return this._compileClipData( clipData, objFormats )
}
SetFiles( files, isCut := 0 )
{
if ( files = "" )
return 0
clipSize := this._fromclipboard( clipData )
if !( clipSize := this._setFiles( clipData, clipSize, files, 0, isCut ) )
return 0
return this._toclipboard( clipData, clipSize )
}
iSetFiles( files, isCut := 0 )
{
this._IsInstance( A_ThisFunc )
if ( files = "" )
return 0
clipSize := this._getClipData( clipData )
if !( clipSize := this._setFiles( clipData, clipSize, files, 0, isCut ) )
return 0
return this._setClipData( clipData, clipSize )
}
AppendFiles( files, isCut := 0 )
{
if ( files = "" )
return 0
clipSize := this._fromclipboard( clipData )
if !( clipSize := this._setFiles( clipData, clipSize, files, 1, isCut ) )
return 0
return this._toclipboard( clipData, clipSize )
}
iAppendFiles( files, isCut := 0 )
{
this._IsInstance( A_ThisFunc )
if ( files = "" )
return 0
clipSize := this._getClipData( clipData )
if !( clipSize := this._setFiles( clipData, clipSize, files, 1, isCut ) )
return 0
return this._setClipData( clipData, clipSize )
}
GetFiles()
{
if !( clipSize := this._fromclipboard( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, this.ClipboardFormats.CF_HDROP ) )
return ""
return this._getFiles( &out_data )
}
iGetFiles()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, this.ClipboardFormats.CF_HDROP ) )
return ""
return this._getFiles( &out_data )
}
_getFormatData( &out_data, &data, size, needleFormat )
{
needleFormat := (WinClipAPI.IsInteger( needleFormat ) ? needleFormat : WinClipAPI.RegisterClipboardFormat( needleFormat ))
if !needleFormat
return 0
offset := 0
while ( offset < size )
{
if !( fmt := NumGet(data, offset, "UInt") )
break
offset += 4
if !( dataSize := NumGet(data, offset, "UInt") )
break
offset += 4
if ( fmt == needleFormat )
{
out_data := Buffer(dataSize, 0) ; V1toV2: if 'out_data' is a UTF-16 string, use 'VarSetStrCapacity(&out_data, dataSize)'
WinClipAPI.memcopy( &out_data, &data + offset, dataSize )
return dataSize
}
offset += dataSize
}
return 0
}
_DIBtoHBITMAP( &dibData )
{
pPix := WinClipAPI.GetPixelInfo( dibData )
gdip_token := WinClipAPI.Gdip_Startup()
DllCall("gdiplus\GdipCreateBitmapFromGdiDib", "Ptr", dibData, "Ptr", pPix, "Ptr*", &pBitmap)
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "Ptr*", &hBitmap, "int", 0xffffffff)
DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
WinClipAPI.Gdip_Shutdown( gdip_token )
return hBitmap
}
GetBitmap()
{
if !( clipSize := this._fromclipboard( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, this.ClipboardFormats.CF_DIB ) )
return ""
return this._DIBtoHBITMAP( out_data )
}
iGetBitmap()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, this.ClipboardFormats.CF_DIB ) )
return ""
return this._DIBtoHBITMAP( out_data )
}
_BITMAPtoDIB( bitmap, &DIB )
{
if !bitmap
return 0
if !WinClipAPI.IsInteger( bitmap )
{
gdip_token := WinClipAPI.Gdip_Startup()
DllCall("gdiplus\GdipCreateBitmapFromFileICM", "wstr", bitmap, "Ptr*", &pBitmap)
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "Ptr*", &hBitmap, "int", 0xffffffff)
DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
WinClipAPI.Gdip_Shutdown( gdip_token )
bmMade := 1
}
else
hBitmap := bitmap, bmMade := 0
if !hBitmap
return 0
if !( hdc := DllCall("GetDC", "Ptr", 0) )
Goto(_BITMAPtoDIB_cleanup)
hPal := DllCall("GetStockObject", "UInt", 15)
hPal := DllCall("SelectPalette", "ptr", hdc, "ptr", hPal, "Uint", 0)
DllCall("RealizePalette", "ptr", hdc)
size := DllCall("GetObject", "Ptr", hBitmap, "Uint", 0, "ptr", 0)
bm := Buffer(size, 0) ; V1toV2: if 'bm' is a UTF-16 string, use 'VarSetStrCapacity(&bm, size)'
DllCall("GetObject", "ptr", hBitmap, "Uint", size, "ptr", bm)
biBitCount := NumGet(bm, 16, "UShort")*NumGet(bm, 18, "UShort")
nColors := (1 << biBitCount)
if ( nColors > 256 )
nColors := 0
bmiLen  := 40 + nColors * 4
bmi := Buffer(bmiLen, 0) ; V1toV2: if 'bmi' is a UTF-16 string, use 'VarSetStrCapacity(&bmi, bmiLen)'
NumPut("Uint", 40, bmi, 0)
NumPut("Uint", NumGet(bm, 4, "Uint"), bmi, 4)
NumPut("Uint", biHeight := NumGet(bm, 8, "Uint"), bmi, 8)
NumPut("UShort", 1, bmi, 12)
NumPut("UShort", biBitCount, bmi, 14)
NumPut("UInt", 0, bmi, 16)
if !DllCall("GetDIBits", "ptr", hdc, "ptr", hBitmap, "uint", 0, "uint", biHeight, "ptr", 0, "ptr", bmi, "uint", 0)
Goto(_BITMAPtoDIB_cleanup)
biSizeImage := NumGet(&bmi, 20, "UInt")
if ( biSizeImage = 0 )
{
biBitCount := NumGet(&bmi, 14, "UShort")
biWidth := NumGet(&bmi, 4, "UInt")
biHeight := NumGet(&bmi, 8, "UInt")
biSizeImage := (((( biWidth * biBitCount + 31 ) & ~31 ) >> 3 ) * biHeight )
NumPut("UInt", biSizeImage, &bmi, 20)
}
DIBLen := bmiLen + biSizeImage
DIB := Buffer(DIBLen, 0) ; V1toV2: if 'DIB' is a UTF-16 string, use 'VarSetStrCapacity(&DIB, DIBLen)'
WinClipAPI.memcopy( &DIB, &bmi, bmiLen )
if !DllCall("GetDIBits", "ptr", hdc, "ptr", hBitmap, "uint", 0, "uint", biHeight, "ptr", DIB + bmiLen, "ptr", DIB, "uint", 0)
Goto(_BITMAPtoDIB_cleanup)
_BITMAPtoDIB_cleanup:
if bmMade
DllCall("DeleteObject", "ptr", hBitmap)
DllCall("SelectPalette", "ptr", hdc, "ptr", hPal, "Uint", 0)
DllCall("RealizePalette", "ptr", hdc)
DllCall("ReleaseDC", "ptr", hdc)
if ( A_ThisLabel = "_BITMAPtoDIB_cleanup" )
return 0
return DIBLen
}
_setBitmap( &DIB, DIBSize, &clipData, clipSize )
{
objFormats := this._parseClipboardData( clipData, clipSize )
uFmt := this.ClipboardFormats.CF_DIB
objFormats[ uFmt ] := { size : DIBSize }
ObjSetCapacity( objFormats[ uFmt ], "buffer", DIBSize )
WinClipAPI.memcopy( ObjGetAddress( objFormats[ uFmt ], "buffer" ), &DIB, DIBSize )
return this._compileClipData( clipData, objFormats )
}
SetBitmap( bitmap )
{
if ( DIBSize := this._BITMAPtoDIB( bitmap, DIB ) )
{
clipSize := this._fromclipboard( clipData )
if ( clipSize := this._setBitmap( DIB, DIBSize, clipData, clipSize ) )
return this._toclipboard( clipData, clipSize )
}
return 0
}
iSetBitmap( bitmap )
{
this._IsInstance( A_ThisFunc )
if ( DIBSize := this._BITMAPtoDIB( bitmap, DIB ) )
{
clipSize := this._getClipData( clipData )
if ( clipSize := this._setBitmap( DIB, DIBSize, clipData, clipSize ) )
return this._setClipData( clipData, clipSize )
}
return 0
}
GetText()
{
if !( clipSize := this._fromclipboard( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, this.ClipboardFormats.CF_UNICODETEXT ) )
return ""
return strget( &out_data, out_size / 2, "UTF-16" )
}
iGetText()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, this.ClipboardFormats.CF_UNICODETEXT ) )
return ""
return strget( &out_data, out_size / 2, "UTF-16" )
}
GetHtml()
{
if !( clipSize := this._fromclipboard( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, "HTML Format" ) )
return ""
return strget( &out_data, out_size, "CP0" )
}
iGetHtml()
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return ""
if !( out_size := this._getFormatData( out_data, clipData, clipSize, "HTML Format" ) )
return ""
return strget( &out_data, out_size, "CP0" )
}
_getFormatName( iformat )
{
if this.formatByValue.Has(iformat)
return this.formatByValue[ iformat ]
else
return WinClipAPI.GetClipboardFormatName( iformat )
}
iGetData( &Data )
{
this._IsInstance( A_ThisFunc )
return this._getClipData( Data )
}
iSetData( &data )
{
this._IsInstance( A_ThisFunc )
return this._setClipData( data, VarSetStrCapacity(&data) ) ; V1toV2: if 'data' is NOT a UTF-16 string, use 'data := Buffer()'
}
iGetSize()
{
this._IsInstance( A_ThisFunc )
return ObjGetCapacity( this, "alldata" )
}
HasFormat( fmt )
{
if !fmt
return 0
return WinClipAPI.IsClipboardFormatAvailable( WinClipAPI.IsInteger( fmt ) ? fmt : WinClipAPI.RegisterClipboardFormat( fmt )  )
}
iHasFormat( fmt )
{
this._IsInstance( A_ThisFunc )
if !( clipSize := this._getClipData( clipData ) )
return 0
return this._hasFormat( clipData, clipSize, fmt )
}
_hasFormat( &data, size, needleFormat )
{
needleFormat := WinClipAPI.IsInteger( needleFormat ) ? needleFormat : WinClipAPI.RegisterClipboardFormat( needleFormat )
if !needleFormat
return 0
offset := 0
while ( offset < size )
{
if !( fmt := NumGet(data, offset, "UInt") )
break
if ( fmt == needleFormat )
return 1
offset += 4
if !( dataSize := NumGet(data, offset, "UInt") )
break
offset += 4 + dataSize
}
return 0
}
iSaveBitmap( filePath, format )
{
this._IsInstance( A_ThisFunc )
if ( filePath = "" || format = "" )
return 0
if !( clipSize := this._getClipData( clipData ) )
return 0
if !( DIBsize := this._getFormatData( DIB, clipData, clipSize, this.ClipboardFormats.CF_DIB ) )
return 0
gdip_token := WinClipAPI.Gdip_Startup()
if !WinClipAPI.GetEncoderClsid( format, CLSID )
return 0
DllCall("gdiplus\GdipCreateBitmapFromGdiDib", "Ptr", DIB, "Ptr", WinClipAPI.GetPixelInfo( DIB ), "Ptr*", &pBitmap)
DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "wstr", filePath, "Ptr", CLSID, "Ptr", 0)
DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
WinClipAPI.Gdip_Shutdown( gdip_token )
return 1
}
SaveBitmap( filePath, format )
{
if ( filePath = "" || format = "" )
return 0
if !( clipSize := this._fromclipboard( clipData ) )
return 0
if !( DIBsize := this._getFormatData( DIB, clipData, clipSize, this.ClipboardFormats.CF_DIB ) )
return 0
gdip_token := WinClipAPI.Gdip_Startup()
if !WinClipAPI.GetEncoderClsid( format, CLSID )
return 0
DllCall("gdiplus\GdipCreateBitmapFromGdiDib", "Ptr", DIB, "Ptr", WinClipAPI.GetPixelInfo( DIB ), "Ptr*", &pBitmap)
DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "wstr", filePath, "Ptr", CLSID, "Ptr", 0)
DllCall("gdiplus\GdipDisposeImage", "Ptr", pBitmap)
WinClipAPI.Gdip_Shutdown( gdip_token )
return 1
}
static ClipboardFormats := { CF_BITMAP : 2,CF_DIB : 8,CF_DIBV5 : 17,CF_DIF : 5,CF_DSPBITMAP : 0x0082,CF_DSPENHMETAFILE : 0x008E,CF_DSPMETAFILEPICT : 0x0083,CF_DSPTEXT : 0x0081,CF_ENHMETAFILE : 14,CF_GDIOBJFIRST : 0x0300,CF_GDIOBJLAST : 0x03FF,CF_HDROP : 15,CF_LOCALE : 16,CF_METAFILEPICT : 3,CF_OEMTEXT : 7,CF_OWNERDISPLAY : 0x0080,CF_PALETTE : 9,CF_PENDATA : 10,CF_PRIVATEFIRST : 0x0200,CF_PRIVATELAST : 0x02FF,CF_RIFF : 11,CF_SYLK : 4,CF_TEXT : 1,CF_TIFF : 6,CF_UNICODETEXT : 13,CF_WAVE : 12 }
static                       WM_COPY := 0x301,WM_CLEAR := 0x0303,WM_CUT := 0x0300,WM_PASTE := 0x0302
static skipFormats := {      2      : 0,17     : 0,0x0082 : 0,0x008E : 0,0x0083 : 0,0x0081 : 0,0x0080 : 0,3      : 0,7      : 0,1      : 0 }
static formatByValue := {    2 : "CF_BITMAP",8 : "CF_DIB",17 : "CF_DIBV5",5 : "CF_DIF",0x0082 : "CF_DSPBITMAP",0x008E : "CF_DSPENHMETAFILE",0x0083 : "CF_DSPMETAFILEPICT",0x0081 : "CF_DSPTEXT",14 : "CF_ENHMETAFILE",0x0300 : "CF_GDIOBJFIRST",0x03FF : "CF_GDIOBJLAST",15 : "CF_HDROP",16 : "CF_LOCALE",3 : "CF_METAFILEPICT",7 : "CF_OEMTEXT",0x0080 : "CF_OWNERDISPLAY",9 : "CF_PALETTE",10 : "CF_PENDATA",0x0200 : "CF_PRIVATEFIRST",0x02FF : "CF_PRIVATELAST",11 : "CF_RIFF",4 : "CF_SYLK",1 : "CF_TEXT",6 : "CF_TIFF",13 : "CF_UNICODETEXT",12 : "CF_WAVE" }
}
UpdateLayeredWindow(hwnd, hdc, x:="", y:="", w:="", h:="", Alpha:=255)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
if ((x != "") && (y != ""))
VarSetStrCapacity(&pt, 8), NumPut("UInt", x, pt, 0), NumPut("UInt", y, pt, 4) ; V1toV2: if 'pt' is NOT a UTF-16 string, use 'pt := Buffer(8)'
if (w = "") ||(h = "")
WinGetPos(, , &w, &h, "ahk_id " hwnd)
return DllCall("UpdateLayeredWindow", "Ptr", hwnd, "Ptr", 0, "Ptr", ((x = "") && (y = "")) ? 0 : &pt, "int64*", &w|h<<32, "Ptr", hdc, "int64*", &0, "uint", 0, "UInt*", &Alpha<<16|1<<24, "uint", 2)
}
BitBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, Raster:="")
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdi32\BitBlt", "Ptr", dDC, "int", dx, "int", dy, "int", dw, "int", dh, "Ptr", sDC, "int", sx, "int", sy, "uint", Raster ? Raster : 0x00CC0020)
}
StretchBlt(ddc, dx, dy, dw, dh, sdc, sx, sy, sw, sh, Raster:="")
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdi32\StretchBlt", "Ptr", ddc, "int", dx, "int", dy, "int", dw, "int", dh, "Ptr", sdc, "int", sx, "int", sy, "int", sw, "int", sh, "uint", Raster ? Raster : 0x00CC0020)
}
SetStretchBltMode(hdc, iStretchMode:=4)
{
return DllCall("gdi32\SetStretchBltMode", A_PtrSize ? "UPtr" : "UInt", hdc, "int", iStretchMode)
}
SetImage(hwnd, hBitmap)
{
ErrorLevel := SendMessage(0x172, 0x0, hBitmap, , "ahk_id " hwnd)
E := ErrorLevel
DeleteObject(E)
return E
}
SetSysColorToControl(hwnd, SysColor:=15)
{
WinGetPos(, , &w, &h, "ahk_id " hwnd)
bc := DllCall("GetSysColor", "Int", SysColor, "UInt")
pBrushClear := Gdip_BrushCreateSolid(0xff000000 | (bc >> 16 | bc & 0xff00 | (bc & 0xff) << 16))
pBitmap := Gdip_CreateBitmap(w, h), G := Gdip_GraphicsFromImage(pBitmap)
Gdip_FillRectangle(G, pBrushClear, 0, 0, w, h)
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
SetImage(hwnd, hBitmap)
Gdip_DeleteBrush(pBrushClear)
Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmap), DeleteObject(hBitmap)
return 0
}
Gdip_BitmapFromScreen(Screen:=0, Raster:="")
{
if (Screen = 0)
{
x := SysGet(76)
y := SysGet(77)
w := SysGet(78)
h := SysGet(79)
}
else if (SubStr(Screen, 1, 5) = "hwnd:")
{
Screen := SubStr(Screen, 6)
if !WinExist( "ahk_id " Screen)
return -2
WinGetPos(, , &w, &h, "ahk_id " Screen)
x := y := 0
hhdc := GetDCEx(Screen, 3)
}
else if (Screen&1 != "")
{
MonitorGet(Screen, &MLeft, &MTop, &MRight, &MBottom)
x := MLeft, y := MTop, w := MRight-MLeft, h := MBottom-MTop
}
else
{
S := StrSplit(Screen,"|")
x := S[1], y := S[2], w := S[3], h := S[4]
}
if (x = "") || (y = "") || (w = "") || (h = "")
return -1
chdc := CreateCompatibleDC(), hbm := CreateDIBSection(w, h, chdc), obm := SelectObject(chdc, hbm), hhdc := hhdc ? hhdc : GetDC()
BitBlt(chdc, 0, 0, w, h, hhdc, x, y, Raster)
ReleaseDC(hhdc)
pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
SelectObject(chdc, obm), DeleteObject(hbm), DeleteDC(hhdc), DeleteDC(chdc)
return pBitmap
}
Gdip_BitmapFromHWND(hwnd)
{
WinGetPos(, , &Width, &Height, "ahk_id " hwnd)
hbm := CreateDIBSection(Width, Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
PrintWindow(hwnd, hdc)
pBitmap := Gdip_CreateBitmapFromHBITMAP(hbm)
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
return pBitmap
}
CreateRectF(&RectF, x, y, w, h)
{
VarSetStrCapacity(&RectF, 16) ; V1toV2: if 'RectF' is NOT a UTF-16 string, use 'RectF := Buffer(16)'
NumPut("float", x, RectF, 0), NumPut("float", y, RectF, 4), NumPut("float", w, RectF, 8), NumPut("float", h, RectF, 12)
}
CreateRect(&Rect, x, y, w, h)
{
VarSetStrCapacity(&Rect, 16) ; V1toV2: if 'Rect' is NOT a UTF-16 string, use 'Rect := Buffer(16)'
NumPut("uint", x, Rect, 0), NumPut("uint", y, Rect, 4), NumPut("uint", w, Rect, 8), NumPut("uint", h, Rect, 12)
}
CreateSizeF(&SizeF, w, h)
{
VarSetStrCapacity(&SizeF, 8) ; V1toV2: if 'SizeF' is NOT a UTF-16 string, use 'SizeF := Buffer(8)'
NumPut("float", w, SizeF, 0), NumPut("float", h, SizeF, 4)
}
CreatePointF(&PointF, x, y)
{
VarSetStrCapacity(&PointF, 8) ; V1toV2: if 'PointF' is NOT a UTF-16 string, use 'PointF := Buffer(8)'
NumPut("float", x, PointF, 0), NumPut("float", y, PointF, 4)
}
CreateDIBSection(w, h, hdc:="", bpp:=32, &ppvBits:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
hdc2 := hdc ? hdc : GetDC()
bi := Buffer(40, 0) ; V1toV2: if 'bi' is a UTF-16 string, use 'VarSetStrCapacity(&bi, 40)'
NumPut("uInt", w, bi, 4), NumPut("uint", h, bi, 8), NumPut("uint", 40, bi, 0), NumPut("ushort", 1, bi, 12), NumPut("uInt", 0, bi, 16), NumPut("ushort", bpp, bi, 14)
hbm := DllCall("CreateDIBSection", "Ptr", hdc2, "Ptr", bi, "uint", 0, A_PtrSize ? "UPtr*" : "uint*", &ppvBits, "Ptr", 0, "uint", 0, "Ptr")
if !hdc
ReleaseDC(hdc2)
return hbm
}
PrintWindow(hwnd, hdc, Flags:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("PrintWindow", "Ptr", hwnd, "Ptr", hdc, "uint", Flags)
}
DestroyIcon(hIcon)
{
return DllCall("DestroyIcon", A_PtrSize ? "UPtr" : "UInt", hIcon)
}
PaintDesktop(hdc)
{
return DllCall("PaintDesktop", A_PtrSize ? "UPtr" : "UInt", hdc)
}
CreateCompatibleBitmap(hdc, w, h)
{
return DllCall("gdi32\CreateCompatibleBitmap", A_PtrSize ? "UPtr" : "UInt", hdc, "int", w, "int", h)
}
CreateCompatibleDC(hdc:=0)
{
return DllCall("CreateCompatibleDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
SelectObject(hdc, hgdiobj)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("SelectObject", "Ptr", hdc, "Ptr", hgdiobj)
}
DeleteObject(hObject)
{
return DllCall("DeleteObject", A_PtrSize ? "UPtr" : "UInt", hObject)
}
GetDC(hwnd:=0)
{
return DllCall("GetDC", A_PtrSize ? "UPtr" : "UInt", hwnd)
}
GetDCEx(hwnd, flags:=0, hrgnClip:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("GetDCEx", "Ptr", hwnd, "Ptr", hrgnClip, "int", flags)
}
ReleaseDC(hdc, hwnd:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("ReleaseDC", "Ptr", hwnd, "Ptr", hdc)
}
DeleteDC(hdc)
{
return DllCall("DeleteDC", A_PtrSize ? "UPtr" : "UInt", hdc)
}
Gdip_LibraryVersion()
{
return 1.45
}
Gdip_LibrarySubVersion()
{
return 1.47
}
Gdip_BitmapFromBRA(&BRAFromMemIn, File, Alternate:=0)
{
Static FName = "ObjRelease"
if !BRAFromMemIn
return -1
Loop Parse, BRAFromMemIn, "`n"
{
if (A_Index = 1)
{
Header := StrSplit(A_LoopField,"|")
if (Header.Length != 4 || Header[2] != "BRA!")
return -2
}
else if (A_Index = 2)
{
Info := StrSplit(A_LoopField,"|")
if (Info.Length != 3)
return -3
}
else
break
}
if !Alternate
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
File := StrReplace(File, "\", "\\")
RegExMatch(BRAFromMemIn, "mi`n)^" (Alternate ? File "\|.+?\|(\d+)\|(\d+)" : "\d+\|" File "\|(\d+)\|(\d+)") "$", &FileInfo)
if !FileInfo[0]
return -4
hData := DllCall("GlobalAlloc", "uint", 2, "Ptr", FileInfo[2], "Ptr")
pData := DllCall("GlobalLock", "Ptr", hData, "Ptr")
DllCall("RtlMoveMemory", "Ptr", pData, "Ptr", BRAFromMemIn+Info[2]+FileInfo[1], "Ptr", FileInfo[2])
DllCall("GlobalUnlock", "Ptr", hData)
DllCall("ole32\CreateStreamOnHGlobal", "Ptr", hData, "int", 1, A_PtrSize ? "UPtr*" : "UInt*", &pStream)
DllCall("gdiplus\GdipCreateBitmapFromStream", "Ptr", pStream, A_PtrSize ? "UPtr*" : "UInt*", &pBitmap)
If (A_PtrSize)
%FName%(pStream)
Else
DllCall(NumGet(NumGet(1*pStream, "UPtr")+8, "UPtr"), "uint", pStream)
return pBitmap
}
Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipDrawRectangle", "Ptr", pGraphics, "Ptr", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawRoundedRectangle(pGraphics, pPen, x, y, w, h, r)
{
Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
E := Gdip_DrawRectangle(pGraphics, pPen, x, y, w, h)
Gdip_ResetClip(pGraphics)
Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
Gdip_DrawEllipse(pGraphics, pPen, x, y, 2*r, 2*r)
Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y, 2*r, 2*r)
Gdip_DrawEllipse(pGraphics, pPen, x, y+h-(2*r), 2*r, 2*r)
Gdip_DrawEllipse(pGraphics, pPen, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
Gdip_ResetClip(pGraphics)
return E
}
Gdip_DrawEllipse(pGraphics, pPen, x, y, w, h)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipDrawEllipse", "Ptr", pGraphics, "Ptr", pPen, "float", x, "float", y, "float", w, "float", h)
}
Gdip_DrawBezier(pGraphics, pPen, x1, y1, x2, y2, x3, y3, x4, y4)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipDrawBezier", "Ptr", pgraphics, "Ptr", pPen, "float", x1, "float", y1, "float", x2, "float", y2, "float", x3, "float", y3, "float", x4, "float", y4)
}
Gdip_DrawArc(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipDrawArc", "Ptr", pGraphics, "Ptr", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawPie(pGraphics, pPen, x, y, w, h, StartAngle, SweepAngle)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipDrawPie", "Ptr", pGraphics, "Ptr", pPen, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_DrawLine(pGraphics, pPen, x1, y1, x2, y2)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipDrawLine", "Ptr", pGraphics, "Ptr", pPen, "float", x1, "float", y1, "float", x2, "float", y2)
}
Gdip_DrawLines(pGraphics, pPen, Points)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
Points := StrSplit(Points.Length,"|")
VarSetStrCapacity(&PointF, 8*Points.Length) ; V1toV2: if 'PointF' is NOT a UTF-16 string, use 'PointF := Buffer(8*Points0)'
Loop Points.Length
{
Coord := StrSplit(Points[A_Index],",")
NumPut("float", Coord[1], PointF, 8*(A_Index-1)), NumPut("float", Coord[2], PointF, (8*(A_Index-1))+4)
}
return DllCall("gdiplus\GdipDrawLines", "Ptr", pGraphics, "Ptr", pPen, "Ptr", PointF, "int", Points.Length)
}
Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipFillRectangle", "Ptr", pGraphics, "Ptr", pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRoundedRectangle(pGraphics, pBrush, x, y, w, h, r)
{
Region := Gdip_GetClipRegion(pGraphics)
Gdip_SetClipRect(pGraphics, x-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x-r, y+h-r, 2*r, 2*r, 4)
Gdip_SetClipRect(pGraphics, x+w-r, y+h-r, 2*r, 2*r, 4)
E := Gdip_FillRectangle(pGraphics, pBrush, x, y, w, h)
Gdip_SetClipRegion(pGraphics, Region, 0)
Gdip_SetClipRect(pGraphics, x-(2*r), y+r, w+(4*r), h-(2*r), 4)
Gdip_SetClipRect(pGraphics, x+r, y-(2*r), w-(2*r), h+(4*r), 4)
Gdip_FillEllipse(pGraphics, pBrush, x, y, 2*r, 2*r)
Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y, 2*r, 2*r)
Gdip_FillEllipse(pGraphics, pBrush, x, y+h-(2*r), 2*r, 2*r)
Gdip_FillEllipse(pGraphics, pBrush, x+w-(2*r), y+h-(2*r), 2*r, 2*r)
Gdip_SetClipRegion(pGraphics, Region, 0)
Gdip_DeleteRegion(Region)
return E
}
Gdip_FillPolygon(pGraphics, pBrush, Points.Length, FillMode:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
Points := StrSplit(Points.Length,"|")
VarSetStrCapacity(&PointF, 8*Points.Length) ; V1toV2: if 'PointF' is NOT a UTF-16 string, use 'PointF := Buffer(8*Points0)'
Loop Points.Length
{
Coord := StrSplit(Points[A_Index],",")
NumPut("float", Coord[1], PointF, 8*(A_Index-1)), NumPut("float", Coord[2], PointF, (8*(A_Index-1))+4)
}
return DllCall("gdiplus\GdipFillPolygon", "Ptr", pGraphics, "Ptr", pBrush, "Ptr", PointF, "int", Points.Length, "int", FillMode)
}
Gdip_FillPie(pGraphics, pBrush, x, y, w, h, StartAngle, SweepAngle)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipFillPie", "Ptr", pGraphics, "Ptr", pBrush, "float", x, "float", y, "float", w, "float", h, "float", StartAngle, "float", SweepAngle)
}
Gdip_FillEllipse(pGraphics, pBrush, x, y, w, h)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipFillEllipse", "Ptr", pGraphics, "Ptr", pBrush, "float", x, "float", y, "float", w, "float", h)
}
Gdip_FillRegion(pGraphics, pBrush, Region)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipFillRegion", "Ptr", pGraphics, "Ptr", pBrush, "Ptr", Region)
}
Gdip_FillPath(pGraphics, pBrush, Path)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipFillPath", "Ptr", pGraphics, "Ptr", pBrush, "Ptr", Path)
}
Gdip_DrawImagePointsRect(pGraphics, pBitmap, Points.Length, sx:="", sy:="", sw:="", sh:="", Matrix:=1)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
Points := StrSplit(Points.Length,"|")
VarSetStrCapacity(&PointF, 8*Points.Length) ; V1toV2: if 'PointF' is NOT a UTF-16 string, use 'PointF := Buffer(8*Points0)'
Loop Points.Length
{
Coord := StrSplit(Points[A_Index],",")
NumPut("float", Coord[1], PointF, 8*(A_Index-1)), NumPut("float", Coord[2], PointF, (8*(A_Index-1))+4)
}
if (Matrix&1 = "")
ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
else if (Matrix != 1)
ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
if (sx = "" && sy = "" && sw = "" && sh = "")
{
sx := 0, sy := 0
sw := Gdip_GetImageWidth(pBitmap)
sh := Gdip_GetImageHeight(pBitmap)
}
E := DllCall("gdiplus\GdipDrawImagePointsRect", "Ptr", pGraphics, "Ptr", pBitmap, "Ptr", PointF, "int", Points.Length, "float", sx, "float", sy, "float", sw, "float", sh, "int", 2, "Ptr", ImageAttr, "Ptr", 0, "Ptr", 0)
if ImageAttr
Gdip_DisposeImageAttributes(ImageAttr)
return E
}
Gdip_DrawImage(pGraphics, pBitmap, dx:="", dy:="", dw:="", dh:="", sx:="", sy:="", sw:="", sh:="", Matrix:=1)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
if (Matrix&1 = "")
ImageAttr := Gdip_SetImageAttributesColorMatrix(Matrix)
else if (Matrix != 1)
ImageAttr := Gdip_SetImageAttributesColorMatrix("1|0|0|0|0|0|1|0|0|0|0|0|1|0|0|0|0|0|" Matrix "|0|0|0|0|0|1")
if (sx = "" && sy = "" && sw = "" && sh = "")
{
if (dx = "" && dy = "" && dw = "" && dh = "")
{
sx := dx := 0, sy := dy := 0
sw := dw := Gdip_GetImageWidth(pBitmap)
sh := dh := Gdip_GetImageHeight(pBitmap)
}
else
{
sx := sy := 0
sw := Gdip_GetImageWidth(pBitmap)
sh := Gdip_GetImageHeight(pBitmap)
}
}
E := DllCall("gdiplus\GdipDrawImageRectRect", "Ptr", pGraphics, "Ptr", pBitmap, "float", dx, "float", dy, "float", dw, "float", dh, "float", sx, "float", sy, "float", sw, "float", sh, "int", 2, "Ptr", ImageAttr, "Ptr", 0, "Ptr", 0)
if ImageAttr
Gdip_DisposeImageAttributes(ImageAttr)
return E
}
Gdip_SetImageAttributesColorMatrix(Matrix)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
ColourMatrix := Buffer(100, 0) ; V1toV2: if 'ColourMatrix' is a UTF-16 string, use 'VarSetStrCapacity(&ColourMatrix, 100)'
Matrix := RegExReplace(RegExReplace(Matrix, "^[^\d-\.]+([\d\.])", "$1", &"", 1), "[^\d-\.]+", "|")
Matrix := StrSplit(Matrix.Length,"|")
Loop 25
{
Matrix := (Matrix[A_Index] != "") ? Matrix[A_Index] : Mod(A_Index-1, 6) ? 0 : 1
NumPut("float", Matrix.Length, ColourMatrix, (A_Index-1)*4)
}
DllCall("gdiplus\GdipCreateImageAttributes", A_PtrSize ? "UPtr*" : "uint*", &ImageAttr)
DllCall("gdiplus\GdipSetImageAttributesColorMatrix", "Ptr", ImageAttr, "int", 1, "int", 1, "Ptr", ColourMatrix, "Ptr", 0, "int", 0)
return ImageAttr
}
Gdip_GraphicsFromImage(pBitmap)
{
DllCall("gdiplus\GdipGetImageGraphicsContext", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", &pGraphics)
return pGraphics
}
Gdip_GraphicsFromHDC(hdc)
{
DllCall("gdiplus\GdipCreateFromHDC", A_PtrSize ? "UPtr" : "UInt", hdc, A_PtrSize ? "UPtr*" : "UInt*", &pGraphics)
return pGraphics
}
Gdip_GetDC(pGraphics)
{
DllCall("gdiplus\GdipGetDC", A_PtrSize ? "UPtr" : "UInt", pGraphics, A_PtrSize ? "UPtr*" : "UInt*", &hdc)
return hdc
}
Gdip_ReleaseDC(pGraphics, hdc)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipReleaseDC", "Ptr", pGraphics, "Ptr", hdc)
}
Gdip_GraphicsClear(pGraphics, ARGB:=0x00ffffff)
{
return DllCall("gdiplus\GdipGraphicsClear", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", ARGB)
}
Gdip_BlurBitmap(pBitmap, Blur)
{
if (Blur > 100) || (Blur < 1)
return -1
sWidth := Gdip_GetImageWidth(pBitmap), sHeight := Gdip_GetImageHeight(pBitmap)
dWidth := sWidth//Blur, dHeight := sHeight//Blur
pBitmap1 := Gdip_CreateBitmap(dWidth, dHeight)
G1 := Gdip_GraphicsFromImage(pBitmap1)
Gdip_SetInterpolationMode(G1, 7)
Gdip_DrawImage(G1, pBitmap, 0, 0, dWidth, dHeight, 0, 0, sWidth, sHeight)
Gdip_DeleteGraphics(G1)
pBitmap2 := Gdip_CreateBitmap(sWidth, sHeight)
G2 := Gdip_GraphicsFromImage(pBitmap2)
Gdip_SetInterpolationMode(G2, 7)
Gdip_DrawImage(G2, pBitmap1, 0, 0, sWidth, sHeight, 0, 0, dWidth, dHeight)
Gdip_DeleteGraphics(G2)
Gdip_DisposeImage(pBitmap1)
return pBitmap2
}
Gdip_SaveBitmapToFile(pBitmap, sOutput, Quality:=75)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
SplitPath(sOutput, , , &Extension)
if !(Extension ~= "^(?i:BMP|DIB|RLE|JPG|JPEG|JPE|JFIF|GIF|TIF TIFF|PNG)$")
return -1
Extension := "." Extension
DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", &nCount, "uint*", &nSize)
VarSetStrCapacity(&ci, nSize) ; V1toV2: if 'ci' is NOT a UTF-16 string, use 'ci := Buffer(nSize)'
DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "Ptr", ci)
if !(nCount && nSize)
return -2
If (1){
StrGet_Name := "StrGet"
Loop nCount
{
sString := %StrGet_Name%(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize, "UPtr"), "UTF-16")
if !InStr(sString, "*" Extension)
continue
pCodec := &ci+idx
break
}
} else {
Loop nCount
{
Location := NumGet(ci, 76*(A_Index-1)+44)
nSize := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "uint", 0, "int", 0, "uint", 0, "uint", 0)
VarSetStrCapacity(&sString, nSize) ; V1toV2: if 'sString' is NOT a UTF-16 string, use 'sString := Buffer(nSize)'
DllCall("WideCharToMultiByte", "uint", 0, "uint", 0, "uint", Location, "int", -1, "str", sString, "int", nSize, "uint", 0, "uint", 0)
if !InStr(sString, "*" Extension)
continue
pCodec := &ci+76*(A_Index-1)
break
}
}
if !pCodec
return -3
if (Quality != 75)
{
Quality := (Quality < 0) ? 0 : (Quality > 100) ? 100 : Quality
if (Extension ~= "^(?i:\.JPG|\.JPEG|\.JPE|\.JFIF)$")
{
DllCall("gdiplus\GdipGetEncoderParameterListSize", "Ptr", pBitmap, "Ptr", pCodec, "uint*", &nSize)
EncoderParameters := Buffer(nSize, 0) ; V1toV2: if 'EncoderParameters' is a UTF-16 string, use 'VarSetStrCapacity(&EncoderParameters, nSize)'
DllCall("gdiplus\GdipGetEncoderParameterList", "Ptr", pBitmap, "Ptr", pCodec, "uint", nSize, "Ptr", EncoderParameters)
Loop NumGet(EncoderParameters, "UInt")
{
elem := (24+(A_PtrSize ? A_PtrSize : 4))*(A_Index-1) + 4 + (pad := A_PtrSize = 8 ? 4 : 0)
if (NumGet(EncoderParameters, elem+16, "UInt") = 1) && (NumGet(EncoderParameters, elem+20, "UInt") = 6)
{
p := elem+&EncoderParameters-pad-4
NumPut(NumGet(NumPut(NumPut("UPtr", 1, p+0)+20), "UPtr"))
break
}
}
}
}
if (!1)
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sOutput, "int", -1, "Ptr", 0, "int", 0)
VarSetStrCapacity(&wOutput, nSize*2) ; V1toV2: if 'wOutput' is NOT a UTF-16 string, use 'wOutput := Buffer(nSize*2)'
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sOutput, "int", -1, "Ptr", wOutput, "int", nSize)
VarSetStrCapacity(&wOutput, -1) ; V1toV2: if 'wOutput' is NOT a UTF-16 string, use 'wOutput := Buffer(-1)'
if !VarSetStrCapacity(&wOutput) ; V1toV2: if 'wOutput' is NOT a UTF-16 string, use 'wOutput := Buffer()'
return -4
E := DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "Ptr", wOutput, "Ptr", pCodec, "uint", p ? p : 0)
}
else
E := DllCall("gdiplus\GdipSaveImageToFile", "Ptr", pBitmap, "Ptr", sOutput, "Ptr", pCodec, "uint", p ? p : 0)
return E ? -5 : 0
}
Gdip_GetPixel(pBitmap, x, y)
{
DllCall("gdiplus\GdipBitmapGetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "uint*", &ARGB)
return ARGB
}
Gdip_SetPixel(pBitmap, x, y, ARGB)
{
return DllCall("gdiplus\GdipBitmapSetPixel", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", x, "int", y, "int", ARGB)
}
Gdip_GetImageWidth(pBitmap)
{
DllCall("gdiplus\GdipGetImageWidth", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", &Width)
return Width
}
Gdip_GetImageHeight(pBitmap)
{
DllCall("gdiplus\GdipGetImageHeight", A_PtrSize ? "UPtr" : "UInt", pBitmap, "uint*", &Height)
return Height
}
Gdip_GetImageDimensions(pBitmap, &Width, &Height)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
DllCall("gdiplus\GdipGetImageWidth", "Ptr", pBitmap, "uint*", &Width)
DllCall("gdiplus\GdipGetImageHeight", "Ptr", pBitmap, "uint*", &Height)
}
Gdip_GetDimensions(pBitmap, &Width, &Height)
{
Gdip_GetImageDimensions(pBitmap, Width, Height)
}
Gdip_GetImagePixelFormat(pBitmap)
{
DllCall("gdiplus\GdipGetImagePixelFormat", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", &Format)
return Format
}
Gdip_GetDpiX(pGraphics)
{
DllCall("gdiplus\GdipGetDpiX", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", &dpix)
return Round(dpix)
}
Gdip_GetDpiY(pGraphics)
{
DllCall("gdiplus\GdipGetDpiY", A_PtrSize ? "UPtr" : "uint", pGraphics, "float*", &dpiy)
return Round(dpiy)
}
Gdip_GetImageHorizontalResolution(pBitmap)
{
DllCall("gdiplus\GdipGetImageHorizontalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", &dpix)
return Round(dpix)
}
Gdip_GetImageVerticalResolution(pBitmap)
{
DllCall("gdiplus\GdipGetImageVerticalResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float*", &dpiy)
return Round(dpiy)
}
Gdip_BitmapSetResolution(pBitmap, dpix, dpiy)
{
return DllCall("gdiplus\GdipBitmapSetResolution", A_PtrSize ? "UPtr" : "uint", pBitmap, "float", dpix, "float", dpiy)
}
Gdip_CreateBitmapFromFile(sFile, IconNumber:=1, IconSize:="")
{
Ptr := A_PtrSize ? "UPtr" : "UInt", PtrA := A_PtrSize ? "UPtr*" : "UInt*"
SplitPath(sFile, , , &ext)
if (ext ~= "^(?i:exe|dll)$")
{
Sizes := IconSize ? IconSize : 256 "|" 128 "|" 64 "|" 48 "|" 32 "|" 16
BufSize := 16 + (2*(A_PtrSize ? A_PtrSize : 4))
buf := Buffer(BufSize, 0) ; V1toV2: if 'buf' is a UTF-16 string, use 'VarSetStrCapacity(&buf, BufSize)'
Loop Parse, Sizes, "|"
{
DllCall("PrivateExtractIcons", "str", sFile, "int", IconNumber-1, "int", A_LoopField, "int", A_LoopField, PtrA, hIcon, PtrA, 0, "uint", 1, "uint", 0)
if !hIcon
continue
if !DllCall("GetIconInfo", "Ptr", hIcon, "Ptr", buf)
{
DestroyIcon(hIcon)
continue
}
hbmMask  := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4), "UPtr")
hbmColor := NumGet(buf, 12 + ((A_PtrSize ? A_PtrSize : 4) - 4) + (A_PtrSize ? A_PtrSize : 4), "UPtr")
if !(hbmColor && DllCall("GetObject", "Ptr", hbmColor, "int", BufSize, "Ptr", buf))
{
DestroyIcon(hIcon)
continue
}
break
}
if !hIcon
return -1
Width := NumGet(buf, 4, "int"), Height := NumGet(buf, 8, "int")
hbm := CreateDIBSection(Width, -Height), hdc := CreateCompatibleDC(), obm := SelectObject(hdc, hbm)
if !DllCall("DrawIconEx", "Ptr", hdc, "int", 0, "int", 0, "Ptr", hIcon, "uint", Width, "uint", Height, "uint", 0, "Ptr", 0, "uint", 3)
{
DestroyIcon(hIcon)
return -2
}
VarSetStrCapacity(&dib, 104) ; V1toV2: if 'dib' is NOT a UTF-16 string, use 'dib := Buffer(104)'
DllCall("GetObject", "Ptr", hbm, "int", A_PtrSize = 8 ? 104 : 84, "Ptr", dib)
Stride := NumGet(dib, 12, "Int"), Bits := NumGet(dib, 20 + (A_PtrSize = 8 ? 4 : 0), "UPtr")
DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", Stride, "int", 0x26200A, "Ptr", Bits, PtrA, pBitmapOld)
pBitmap := Gdip_CreateBitmap(Width, Height)
G := Gdip_GraphicsFromImage(pBitmap), Gdip_DrawImage(G, pBitmapOld, 0, 0, Width, Height, 0, 0, Width, Height)
SelectObject(hdc, obm), DeleteObject(hbm), DeleteDC(hdc)
Gdip_DeleteGraphics(G), Gdip_DisposeImage(pBitmapOld)
DestroyIcon(hIcon)
}
else
{
if (!1)
{
VarSetStrCapacity(&wFile, 1024) ; V1toV2: if 'wFile' is NOT a UTF-16 string, use 'wFile := Buffer(1024)'
DllCall("kernel32\MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sFile, "int", -1, "Ptr", wFile, "int", 512)
DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", wFile, PtrA, pBitmap)
}
else
DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", sFile, PtrA, pBitmap)
}
return pBitmap
}
Gdip_CreateBitmapFromHBITMAP(hBitmap, Palette:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hBitmap, "Ptr", Palette, A_PtrSize ? "UPtr*" : "uint*", &pBitmap)
return pBitmap
}
Gdip_CreateHBITMAPFromBitmap(pBitmap, Background:=0xffffffff)
{
DllCall("gdiplus\GdipCreateHBITMAPFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", &hbm, "int", Background)
return hbm
}
Gdip_CreateBitmapFromHICON(hIcon)
{
DllCall("gdiplus\GdipCreateBitmapFromHICON", A_PtrSize ? "UPtr" : "UInt", hIcon, A_PtrSize ? "UPtr*" : "uint*", &pBitmap)
return pBitmap
}
Gdip_CreateHICONFromBitmap(pBitmap)
{
DllCall("gdiplus\GdipCreateHICONFromBitmap", A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "uint*", &hIcon)
return hIcon
}
Gdip_CreateBitmap(Width, Height, Format:=0x26200A)
{
DllCall("gdiplus\GdipCreateBitmapFromScan0", "int", Width, "int", Height, "int", 0, "int", Format, A_PtrSize ? "UPtr" : "UInt", 0, A_PtrSize ? "UPtr*" : "uint*", &pBitmap)
Return pBitmap
}
Gdip_CreateBitmapFromClipboard()
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
if !DllCall("OpenClipboard", "Ptr", 0)
return -1
if !DllCall("IsClipboardFormatAvailable", "uint", 8)
return -2
if !hBitmap := DllCall("GetClipboardData", "uint", 2, "Ptr")
return -3
if !pBitmap := Gdip_CreateBitmapFromHBITMAP(hBitmap)
return -4
if !DllCall("CloseClipboard")
return -5
DeleteObject(hBitmap)
return pBitmap
}
Gdip_SetBitmapToClipboard(pBitmap)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
off1 := A_PtrSize = 8 ? 52 : 44, off2 := A_PtrSize = 8 ? 32 : 24
hBitmap := Gdip_CreateHBITMAPFromBitmap(pBitmap)
DllCall("GetObject", "Ptr", hBitmap, "int", oi := Buffer(A_PtrSize = 8 ? 104 : 84, 0), "Ptr", oi) ; V1toV2: if 'oi' is a UTF-16 string, use 'VarSetStrCapacity(&oi, A_PtrSize = 8 ? 104 : 84)'
hdib := DllCall("GlobalAlloc", "uint", 2, "Ptr", 40+NumGet(oi, off1, "UInt"), "Ptr")
pdib := DllCall("GlobalLock", "Ptr", hdib, "Ptr")
DllCall("RtlMoveMemory", "Ptr", pdib, "Ptr", oi+off2, "Ptr", 40)
DllCall("RtlMoveMemory", "Ptr", pdib+40, "Ptr", NumGet(oi, off2 - (A_PtrSize ? A_PtrSize : 4), Ptr), "Ptr", NumGet(oi, off1, "UInt"))
DllCall("GlobalUnlock", "Ptr", hdib)
DllCall("DeleteObject", "Ptr", hBitmap)
DllCall("OpenClipboard", "Ptr", 0)
DllCall("EmptyClipboard")
DllCall("SetClipboardData", "uint", 8, "Ptr", hdib)
DllCall("CloseClipboard")
}
Gdip_CloneBitmapArea(pBitmap, x, y, w, h, Format:=0x26200A)
{
DllCall("gdiplus\GdipCloneBitmapArea", "float", x, "float", y, "float", w, "float", h, "int", Format, A_PtrSize ? "UPtr" : "UInt", pBitmap, A_PtrSize ? "UPtr*" : "UInt*", &pBitmapDest)
return pBitmapDest
}
Gdip_CreatePen(ARGB, w)
{
DllCall("gdiplus\GdipCreatePen1", "UInt", ARGB, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", &pPen)
return pPen
}
Gdip_CreatePenFromBrush(pBrush, w)
{
DllCall("gdiplus\GdipCreatePen2", A_PtrSize ? "UPtr" : "UInt", pBrush, "float", w, "int", 2, A_PtrSize ? "UPtr*" : "UInt*", &pPen)
return pPen
}
Gdip_BrushCreateSolid(ARGB:=0xff000000)
{
DllCall("gdiplus\GdipCreateSolidFill", "UInt", ARGB, A_PtrSize ? "UPtr*" : "UInt*", &pBrush)
return pBrush
}
Gdip_BrushCreateHatch(ARGBfront, ARGBback, HatchStyle:=0)
{
DllCall("gdiplus\GdipCreateHatchBrush", "int", HatchStyle, "UInt", ARGBfront, "UInt", ARGBback, A_PtrSize ? "UPtr*" : "UInt*", &pBrush)
return pBrush
}
Gdip_CreateTextureBrush(pBitmap, WrapMode:=1, x:=0, y:=0, w:="", h:="")
{
Ptr := A_PtrSize ? "UPtr" : "UInt", PtrA := A_PtrSize ? "UPtr*" : "UInt*"
if !(w && h)
DllCall("gdiplus\GdipCreateTexture", "Ptr", pBitmap, "int", WrapMode, PtrA, pBrush)
else
DllCall("gdiplus\GdipCreateTexture2", "Ptr", pBitmap, "int", WrapMode, "float", x, "float", y, "float", w, "float", h, PtrA, pBrush)
return pBrush
}
Gdip_CreateLineBrush(x1, y1, x2, y2, ARGB1, ARGB2, WrapMode:=1)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
CreatePointF(PointF1, x1, y1), CreatePointF(PointF2, x2, y2)
DllCall("gdiplus\GdipCreateLineBrush", "Ptr", PointF1, "Ptr", PointF2, "Uint", ARGB1, "Uint", ARGB2, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", &LGpBrush)
return LGpBrush
}
Gdip_CreateLineBrushFromRect(x, y, w, h, ARGB1, ARGB2, LinearGradientMode:=1, WrapMode:=1)
{
CreateRectF(RectF, x, y, w, h)
DllCall("gdiplus\GdipCreateLineBrushFromRect", A_PtrSize ? "UPtr" : "UInt", RectF, "int", ARGB1, "int", ARGB2, "int", LinearGradientMode, "int", WrapMode, A_PtrSize ? "UPtr*" : "UInt*", &LGpBrush)
return LGpBrush
}
Gdip_CloneBrush(pBrush)
{
DllCall("gdiplus\GdipCloneBrush", A_PtrSize ? "UPtr" : "UInt", pBrush, A_PtrSize ? "UPtr*" : "UInt*", &pBrushClone)
return pBrushClone
}
Gdip_DeletePen(pPen)
{
return DllCall("gdiplus\GdipDeletePen", A_PtrSize ? "UPtr" : "UInt", pPen)
}
Gdip_DeleteBrush(pBrush)
{
return DllCall("gdiplus\GdipDeleteBrush", A_PtrSize ? "UPtr" : "UInt", pBrush)
}
Gdip_DisposeImage(pBitmap)
{
return DllCall("gdiplus\GdipDisposeImage", A_PtrSize ? "UPtr" : "UInt", pBitmap)
}
Gdip_DeleteGraphics(pGraphics)
{
return DllCall("gdiplus\GdipDeleteGraphics", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_DisposeImageAttributes(ImageAttr)
{
return DllCall("gdiplus\GdipDisposeImageAttributes", A_PtrSize ? "UPtr" : "UInt", ImageAttr)
}
Gdip_DeleteFont(hFont)
{
return DllCall("gdiplus\GdipDeleteFont", A_PtrSize ? "UPtr" : "UInt", hFont)
}
Gdip_DeleteStringFormat(hFormat)
{
return DllCall("gdiplus\GdipDeleteStringFormat", A_PtrSize ? "UPtr" : "UInt", hFormat)
}
Gdip_DeleteFontFamily(hFamily)
{
return DllCall("gdiplus\GdipDeleteFontFamily", A_PtrSize ? "UPtr" : "UInt", hFamily)
}
Gdip_DeleteMatrix(Matrix.Length)
{
return DllCall("gdiplus\GdipDeleteMatrix", A_PtrSize ? "UPtr" : "UInt", Matrix.Length)
}
Gdip_TextToGraphics(pGraphics, Text, Options, Font:="Arial", Width:="", Height:="", Measure:=0)
{
IWidth := Width, IHeight:= Height
RegExMatch(Options, "i)X([\-\d\.]+)(p*)", &xpos)
RegExMatch(Options, "i)Y([\-\d\.]+)(p*)", &ypos)
RegExMatch(Options, "i)W([\-\d\.]+)(p*)", &Width)
RegExMatch(Options, "i)H([\-\d\.]+)(p*)", &Height)
RegExMatch(Options, "i)C(?!(entre|enter))([a-f\d]+)", &Colour)
RegExMatch(Options, "i)Top|Up|Bottom|Down|vCentre|vCenter", &vPos)
RegExMatch(Options, "i)NoWrap[0]", &NoWrap)
RegExMatch(Options, "i)R(\d)", &Rendering)
RegExMatch(Options, "i)S.Length(\d+)(p*)", &Size)
if !Gdip_DeleteBrush(Gdip_CloneBrush(Colour[2]))
PassBrush := 1, pBrush := Colour[2]
if !(IWidth && IHeight) && (xpos[2] || ypos[2] || Width[2] || Height[2] || Size[2])
return -1
Style := 0, Styles := "Regular|Bold|Italic|BoldItalic|Underline|Strikeout"
Loop Parse, Styles, "|"
{
if RegExMatch(Options, "\b" A_loopField)
Style |= (A_LoopField != "StrikeOut") ? (A_Index-1) : 8
}
Align := 0, Alignments := "Near|Left|Centre|Center|Far|Right"
Loop Parse, Alignments, "|"
{
if RegExMatch(Options, "\b" A_loopField)
Align |= A_Index//2.1
}
xpos := (xpos[1] != "") ? xpos[2] ? IWidth*(xpos[1]/100) : xpos[1] : 0
ypos := (ypos[1] != "") ? ypos[2] ? IHeight*(ypos[1]/100) : ypos[1] : 0
Width := Width[1] ? Width[2] ? IWidth*(Width[1]/100) : Width[1] : IWidth
Height := Height[1] ? Height[2] ? IHeight*(Height[1]/100) : Height[1] : IHeight
if !PassBrush
Colour := "0x" (Colour[2] ? Colour[2] : "ff000000")
Rendering := ((Rendering[1] >= 0) && (Rendering[1] <= 5)) ? Rendering[1] : 4
Size := (Size[1] > 0) ? Size[2] ? IHeight*(Size[1]/100) : Size[1] : 12
hFamily := Gdip_FontFamilyCreate(Font)
hFont := Gdip_FontCreate(hFamily, Size[0], Style)
FormatStyle := NoWrap[0] ? 0x4000 | 0x1000 : 0x4000
hFormat := Gdip_StringFormatCreate(FormatStyle)
pBrush := PassBrush ? pBrush : Gdip_BrushCreateSolid(Colour[0])
if !(hFamily && hFont && hFormat && pBrush && pGraphics)
return !pGraphics ? -2 : !hFamily ? -3 : !hFont ? -4 : !hFormat ? -5 : !pBrush ? -6 : 0
CreateRectF(RC, xpos[0], ypos[0], Width[0], Height[0])
Gdip_SetStringFormatAlign(hFormat, Align)
Gdip_SetTextRenderingHint(pGraphics, Rendering[0])
ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
if vPos[0]
{
ReturnRC := StrSplit(ReturnRC.Length,"|")
if (vPos[0] = "vCentre") || (vPos[0] = "vCenter")
ypos[0] += (Height[0]-ReturnRC[4])//2
else if (vPos[0] = "Top") || (vPos[0] = "Up")
ypos := 0
else if (vPos[0] = "Bottom") || (vPos[0] = "Down")
ypos := Height[0]-ReturnRC[4]
CreateRectF(RC, xpos[0], ypos[0], Width[0], ReturnRC[4])
ReturnRC := Gdip_MeasureString(pGraphics, Text, hFont, hFormat, RC)
}
if !Measure
E := Gdip_DrawString(pGraphics, Text, hFont, hFormat, pBrush, RC)
if !PassBrush
Gdip_DeleteBrush(pBrush)
Gdip_DeleteStringFormat(hFormat)
Gdip_DeleteFont(hFont)
Gdip_DeleteFontFamily(hFamily)
return E ? E : ReturnRC.Length
}
Gdip_DrawString(pGraphics, sString, hFont, hFormat, pBrush, &RectF)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
if (!1)
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sString, "int", -1, "Ptr", 0, "int", 0)
VarSetStrCapacity(&wString, nSize*2) ; V1toV2: if 'wString' is NOT a UTF-16 string, use 'wString := Buffer(nSize*2)'
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sString, "int", -1, "Ptr", wString, "int", nSize)
}
return DllCall("gdiplus\GdipDrawString", "Ptr", pGraphics, "Ptr", 1 ? &sString : &wString, "int", -1, "Ptr", hFont, "Ptr", RectF, "Ptr", hFormat, "Ptr", pBrush)
}
Gdip_MeasureString(pGraphics, sString, hFont, hFormat, &RectF)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
VarSetStrCapacity(&RC, 16) ; V1toV2: if 'RC' is NOT a UTF-16 string, use 'RC := Buffer(16)'
if !1
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sString, "int", -1, "uint", 0, "int", 0)
VarSetStrCapacity(&wString, nSize*2) ; V1toV2: if 'wString' is NOT a UTF-16 string, use 'wString := Buffer(nSize*2)'
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", sString, "int", -1, "Ptr", wString, "int", nSize)
}
DllCall("gdiplus\GdipMeasureString", "Ptr", pGraphics, "Ptr", 1 ? &sString : &wString, "int", -1, "Ptr", hFont, "Ptr", RectF, "Ptr", hFormat, "Ptr", RC, "uint*", &Chars, "uint*", &Lines)
return &RC ? NumGet(RC, 0, "float") "|" NumGet(RC, 4, "float") "|" NumGet(RC, 8, "float") "|" NumGet(RC, 12, "float") "|" Chars "|" Lines : 0
}
Gdip_SetStringFormatAlign(hFormat, Align)
{
return DllCall("gdiplus\GdipSetStringFormatAlign", A_PtrSize ? "UPtr" : "UInt", hFormat, "int", Align)
}
Gdip_StringFormatCreate(Format:=0, Lang:=0)
{
DllCall("gdiplus\GdipCreateStringFormat", "int", Format, "int", Lang, A_PtrSize ? "UPtr*" : "UInt*", &hFormat)
return hFormat
}
Gdip_FontCreate(hFamily, Size[0], Style:=0)
{
DllCall("gdiplus\GdipCreateFont", A_PtrSize ? "UPtr" : "UInt", hFamily, "float", Size[0], "int", Style, "int", 0, A_PtrSize ? "UPtr*" : "UInt*", &hFont)
return hFont
}
Gdip_FontFamilyCreate(Font)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
if (!1)
{
nSize := DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", Font, "int", -1, "uint", 0, "int", 0)
VarSetStrCapacity(&wFont, nSize*2) ; V1toV2: if 'wFont' is NOT a UTF-16 string, use 'wFont := Buffer(nSize*2)'
DllCall("MultiByteToWideChar", "uint", 0, "uint", 0, "Ptr", Font, "int", -1, "Ptr", wFont, "int", nSize)
}
DllCall("gdiplus\GdipCreateFontFamilyFromName", "Ptr", 1 ? &Font : &wFont, "uint", 0, A_PtrSize ? "UPtr*" : "UInt*", &hFamily)
return hFamily
}
Gdip_CreateAffineMatrix(m11, m12, m21, m22, x, y)
{
DllCall("gdiplus\GdipCreateMatrix2", "float", m11, "float", m12, "float", m21, "float", m22, "float", x, "float", y, A_PtrSize ? "UPtr*" : "UInt*", &Matrix)
return Matrix.Length
}
Gdip_CreateMatrix()
{
DllCall("gdiplus\GdipCreateMatrix", A_PtrSize ? "UPtr*" : "UInt*", &Matrix)
return Matrix.Length
}
Gdip_CreatePath(BrushMode:=0)
{
DllCall("gdiplus\GdipCreatePath", "int", BrushMode, A_PtrSize ? "UPtr*" : "UInt*", &Path)
return Path
}
Gdip_AddPathEllipse(Path, x, y, w, h)
{
return DllCall("gdiplus\GdipAddPathEllipse", A_PtrSize ? "UPtr" : "UInt", Path, "float", x, "float", y, "float", w, "float", h)
}
Gdip_AddPathPolygon(Path, Points.Length)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
Points := StrSplit(Points.Length,"|")
VarSetStrCapacity(&PointF, 8*Points.Length) ; V1toV2: if 'PointF' is NOT a UTF-16 string, use 'PointF := Buffer(8*Points0)'
Loop Points.Length
{
Coord := StrSplit(Points[A_Index],",")
NumPut("float", Coord[1], PointF, 8*(A_Index-1)), NumPut("float", Coord[2], PointF, (8*(A_Index-1))+4)
}
return DllCall("gdiplus\GdipAddPathPolygon", "Ptr", Path, "Ptr", PointF, "int", Points.Length)
}
Gdip_DeletePath(Path)
{
return DllCall("gdiplus\GdipDeletePath", A_PtrSize ? "UPtr" : "UInt", Path)
}
Gdip_SetTextRenderingHint(pGraphics, Rendering["Hint"])
{
return DllCall("gdiplus\GdipSetTextRenderingHint", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", Rendering["Hint"])
}
Gdip_SetInterpolationMode(pGraphics, InterpolationMode)
{
return DllCall("gdiplus\GdipSetInterpolationMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", InterpolationMode)
}
Gdip_SetSmoothingMode(pGraphics, SmoothingMode)
{
return DllCall("gdiplus\GdipSetSmoothingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", SmoothingMode)
}
Gdip_SetCompositingMode(pGraphics, CompositingMode:=0)
{
return DllCall("gdiplus\GdipSetCompositingMode", A_PtrSize ? "UPtr" : "UInt", pGraphics, "int", CompositingMode)
}
Gdip_Startup()
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
if !DllCall("GetModuleHandle", "str", "gdiplus", "Ptr")
DllCall("LoadLibrary", "str", "gdiplus")
si := Buffer(A_PtrSize = 8 ? 24 : 16, 0), si := Chr(1) ; V1toV2: if 'si' is a UTF-16 string, use 'VarSetStrCapacity(&si, A_PtrSize = 8 ? 24 : 16)'
DllCall("gdiplus\GdiplusStartup", A_PtrSize ? "UPtr*" : "uint*", &pToken, "Ptr", si, "Ptr", 0)
return pToken
}
Gdip_Shutdown(pToken)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
DllCall("gdiplus\GdiplusShutdown", "Ptr", pToken)
if hModule := DllCall("GetModuleHandle", "str", "gdiplus", "Ptr")
DllCall("FreeLibrary", "Ptr", hModule)
return 0
}
Gdip_RotateWorldTransform(pGraphics, Angle, MatrixOrder:=0)
{
return DllCall("gdiplus\GdipRotateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", Angle, "int", MatrixOrder)
}
Gdip_ScaleWorldTransform(pGraphics, x, y, MatrixOrder:=0)
{
return DllCall("gdiplus\GdipScaleWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_TranslateWorldTransform(pGraphics, x, y, MatrixOrder:=0)
{
return DllCall("gdiplus\GdipTranslateWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "int", MatrixOrder)
}
Gdip_ResetWorldTransform(pGraphics)
{
return DllCall("gdiplus\GdipResetWorldTransform", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_GetRotatedTranslation(Width[0], Height[0], Angle, &xTranslation, &yTranslation)
{
pi := 3.14159, TAngle := Angle*(pi/180)
Bound := (Angle >= 0) ? Mod(Angle, 360) : 360-Mod(-Angle, -360)
if ((Bound >= 0) && (Bound <= 90))
xTranslation := Height[0]*Sin(TAngle), yTranslation := 0
else if ((Bound > 90) && (Bound <= 180))
xTranslation := (Height[0]*Sin(TAngle))-(Width[0]*Cos(TAngle)), yTranslation := -Height[0]*Cos(TAngle)
else if ((Bound > 180) && (Bound <= 270))
xTranslation := -(Width[0]*Cos(TAngle)), yTranslation := -(Height[0]*Cos(TAngle))-(Width[0]*Sin(TAngle))
else if ((Bound > 270) && (Bound <= 360))
xTranslation := 0, yTranslation := -Width[0]*Sin(TAngle)
}
Gdip_GetRotatedDimensions(Width[0], Height[0], Angle, &RWidth, &RHeight)
{
pi := 3.14159, TAngle := Angle*(pi/180)
if !(Width[0] && Height[0])
return -1
RWidth := Ceil(Abs(Width[0]*Cos(TAngle))+Abs(Height[0]*Sin(TAngle)))
RHeight := Ceil(Abs(Width[0]*Sin(TAngle))+Abs(Height[0]*Cos(Tangle)))
}
Gdip_ImageRotateFlip(pBitmap, RotateFlipType:=1)
{
return DllCall("gdiplus\GdipImageRotateFlip", A_PtrSize ? "UPtr" : "UInt", pBitmap, "int", RotateFlipType)
}
Gdip_SetClipRect(pGraphics, x, y, w, h, CombineMode:=0)
{
return DllCall("gdiplus\GdipSetClipRect", A_PtrSize ? "UPtr" : "UInt", pGraphics, "float", x, "float", y, "float", w, "float", h, "int", CombineMode)
}
Gdip_SetClipPath(pGraphics, Path, CombineMode:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipSetClipPath", "Ptr", pGraphics, "Ptr", Path, "int", CombineMode)
}
Gdip_ResetClip(pGraphics)
{
return DllCall("gdiplus\GdipResetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics)
}
Gdip_GetClipRegion(pGraphics)
{
Region := Gdip_CreateRegion()
DllCall("gdiplus\GdipGetClip", A_PtrSize ? "UPtr" : "UInt", pGraphics, "UInt*", &Region)
return Region
}
Gdip_SetClipRegion(pGraphics, Region, CombineMode:=0)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("gdiplus\GdipSetClipRegion", "Ptr", pGraphics, "Ptr", Region, "int", CombineMode)
}
Gdip_CreateRegion()
{
DllCall("gdiplus\GdipCreateRegion", "UInt*", &Region)
return Region
}
Gdip_DeleteRegion(Region)
{
return DllCall("gdiplus\GdipDeleteRegion", A_PtrSize ? "UPtr" : "UInt", Region)
}
Gdip_LockBits(pBitmap, x, y, w, h, &Stride, &Scan0, &BitmapData, LockMode := 3, PixelFormat := 0x26200a)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
CreateRect(Rect, x, y, w, h)
BitmapData := Buffer(16+2*(A_PtrSize ? A_PtrSize : 4), 0) ; V1toV2: if 'BitmapData' is a UTF-16 string, use 'VarSetStrCapacity(&BitmapData, 16+2*(A_PtrSize ? A_PtrSize : 4))'
E := DllCall("Gdiplus\GdipBitmapLockBits", "Ptr", pBitmap, "Ptr", Rect, "uint", LockMode, "int", PixelFormat, "Ptr", BitmapData)
Stride := NumGet(BitmapData, 8, "Int")
Scan0 := NumGet(BitmapData, 16, Ptr)
return E
}
Gdip_UnlockBits(pBitmap, &BitmapData)
{
Ptr := A_PtrSize ? "UPtr" : "UInt"
return DllCall("Gdiplus\GdipBitmapUnlockBits", "Ptr", pBitmap, "Ptr", BitmapData)
}
Gdip_SetLockBitPixel(ARGB, Scan0, x, y, Stride)
{
NumPut("UInt", ARGB, Scan0+0, (x*4)+(y*Stride))
}
Gdip_GetLockBitPixel(Scan0, x, y, Stride)
{
return NumGet(Scan0+0, (x*4)+(y*Stride), "UInt")
}
Gdip_PixelateBitmap(pBitmap, &pBitmapOut, BlockSize)
{
static PixelateBitmap
Ptr := A_PtrSize ? "UPtr" : "UInt"
if (!PixelateBitmap)
{
if (A_PtrSize != 8)
MCode_PixelateBitmap := "
		(LTrim Join
		558BEC83EC3C8B4514538B5D1C99F7FB56578BC88955EC894DD885C90F8E830200008B451099F7FB8365DC008365E000894DC88955F08945E833FF897DD4
		397DE80F8E160100008BCB0FAFCB894DCC33C08945F88945FC89451C8945143BD87E608B45088D50028BC82BCA8BF02BF2418945F48B45E02955F4894DC4
		8D0CB80FAFCB03CA895DD08BD1895DE40FB64416030145140FB60201451C8B45C40FB604100145FC8B45F40FB604020145F883C204FF4DE475D6034D18FF
		4DD075C98B4DCC8B451499F7F98945148B451C99F7F989451C8B45FC99F7F98945FC8B45F899F7F98945F885DB7E648B450C8D50028BC82BCA83C103894D
		C48BC82BCA41894DF48B4DD48945E48B45E02955E48D0C880FAFCB03CA895DD08BD18BF38A45148B7DC48804178A451C8B7DF488028A45FC8804178A45F8
		8B7DE488043A83C2044E75DA034D18FF4DD075CE8B4DCC8B7DD447897DD43B7DE80F8CF2FEFFFF837DF0000F842C01000033C08945F88945FC89451C8945
		148945E43BD87E65837DF0007E578B4DDC034DE48B75E80FAF4D180FAFF38B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945CC0F
		B6440E030145140FB60101451C0FB6440F010145FC8B45F40FB604010145F883C104FF4DCC75D8FF45E4395DE47C9B8B4DF00FAFCB85C9740B8B451499F7
		F9894514EB048365140033F63BCE740B8B451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB
		038975F88975E43BDE7E5A837DF0007E4C8B4DDC034DE48B75E80FAF4D180FAFF38B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955CC8A55
		1488540E038A551C88118A55FC88540F018A55F888140183C104FF4DCC75DFFF45E4395DE47CA68B45180145E0015DDCFF4DC80F8594FDFFFF8B451099F7
		FB8955F08945E885C00F8E450100008B45EC0FAFC38365DC008945D48B45E88945CC33C08945F88945FC89451C8945148945103945EC7E6085DB7E518B4D
		D88B45080FAFCB034D108D50020FAF4D18034DDC8BF08BF88945F403CA2BF22BFA2955F4895DC80FB6440E030145140FB60101451C0FB6440F010145FC8B
		45F40FB604080145F883C104FF4DC875D8FF45108B45103B45EC7CA08B4DD485C9740B8B451499F7F9894514EB048365140033F63BCE740B8B451C99F7F9
		89451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975103975EC7E5585DB7E468B4DD88B450C
		0FAFCB034D108D50020FAF4D18034DDC8BF08BF803CA2BF22BFA2BC2895DC88A551488540E038A551C88118A55FC88540F018A55F888140183C104FF4DC8
		75DFFF45108B45103B45EC7CAB8BC3C1E0020145DCFF4DCC0F85CEFEFFFF8B4DEC33C08945F88945FC89451C8945148945103BC87E6C3945F07E5C8B4DD8
		8B75E80FAFCB034D100FAFF30FAF4D188B45088D500203CA8D0CB18BF08BF88945F48B45F02BF22BFA2955F48945C80FB6440E030145140FB60101451C0F
		B6440F010145FC8B45F40FB604010145F883C104FF4DC875D833C0FF45108B4DEC394D107C940FAF4DF03BC874068B451499F7F933F68945143BCE740B8B
		451C99F7F989451CEB0389751C3BCE740B8B45FC99F7F98945FCEB038975FC3BCE740B8B45F899F7F98945F8EB038975F88975083975EC7E63EB0233F639
		75F07E4F8B4DD88B75E80FAFCB034D080FAFF30FAF4D188B450C8D500203CA8D0CB18BF08BF82BF22BFA2BC28B55F08955108A551488540E038A551C8811
		8A55FC88540F018A55F888140883C104FF4D1075DFFF45088B45083B45EC7C9F5F5E33C05BC9C21800
)"
else
MCode_PixelateBitmap := "
		(LTrim Join
		4489442418488954241048894C24085355565741544155415641574883EC28418BC1448B8C24980000004C8BDA99488BD941F7F9448BD0448BFA8954240C
		448994248800000085C00F8E9D020000418BC04533E4458BF299448924244C8954241041F7F933C9898C24980000008BEA89542404448BE889442408EB05
		4C8B5C24784585ED0F8E1A010000458BF1418BFD48897C2418450FAFF14533D233F633ED4533E44533ED4585C97E5B4C63BC2490000000418D040A410FAF
		C148984C8D441802498BD9498BD04D8BD90FB642010FB64AFF4403E80FB60203E90FB64AFE4883C2044403E003F149FFCB75DE4D03C748FFCB75D0488B7C
		24188B8C24980000004C8B5C2478418BC59941F7FE448BE8418BC49941F7FE448BE08BC59941F7FE8BE88BC69941F7FE8BF04585C97E4048639C24900000
		004103CA4D8BC1410FAFC94863C94A8D541902488BCA498BC144886901448821408869FF408871FE4883C10448FFC875E84803D349FFC875DA8B8C249800
		0000488B5C24704C8B5C24784183C20448FFCF48897C24180F850AFFFFFF8B6C2404448B2424448B6C24084C8B74241085ED0F840A01000033FF33DB4533
		DB4533D24533C04585C97E53488B74247085ED7E42438D0C04418BC50FAF8C2490000000410FAFC18D04814863C8488D5431028BCD0FB642014403D00FB6
		024883C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC17CB28BCD410FAFC985C9740A418BC299F7F98BF0EB0233F685C9740B418BC3
		99F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585C97E4D4C8B74247885ED7E3841
		8D0C14418BC50FAF8C2490000000410FAFC18D04814863C84A8D4431028BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2413BD17CBD
		4C8B7424108B8C2498000000038C2490000000488B5C24704503E149FFCE44892424898C24980000004C897424100F859EFDFFFF448B7C240C448B842480
		000000418BC09941F7F98BE8448BEA89942498000000896C240C85C00F8E3B010000448BAC2488000000418BCF448BF5410FAFC9898C248000000033FF33
		ED33F64533DB4533D24533C04585FF7E524585C97E40418BC5410FAFC14103C00FAF84249000000003C74898488D541802498BD90FB642014403D00FB602
		4883C2044403D80FB642FB03F00FB642FA03E848FFCB75DE488B5C247041FFC0453BC77CAE85C9740B418BC299F7F9448BE0EB034533E485C9740A418BC3
		99F7F98BD8EB0233DB85C9740A8BC699F7F9448BD8EB034533DB85C9740A8BC599F7F9448BD0EB034533D24533C04585FF7E4E488B4C24784585C97E3541
		8BC5410FAFC14103C00FAF84249000000003C74898488D540802498BC144886201881A44885AFF448852FE4883C20448FFC875E941FFC0453BC77CBE8B8C
		2480000000488B5C2470418BC1C1E00203F849FFCE0F85ECFEFFFF448BAC24980000008B6C240C448BA4248800000033FF33DB4533DB4533D24533C04585
		FF7E5A488B7424704585ED7E48418BCC8BC5410FAFC94103C80FAF8C2490000000410FAFC18D04814863C8488D543102418BCD0FB642014403D00FB60248
		83C2044403D80FB642FB03D80FB642FA03F848FFC975DE41FFC0453BC77CAB418BCF410FAFCD85C9740A418BC299F7F98BF0EB0233F685C9740B418BC399
		F7F9448BD8EB034533DB85C9740A8BC399F7F9448BD0EB034533D285C9740A8BC799F7F9448BC0EB034533C033D24585FF7E4E4585ED7E42418BCC8BC541
		0FAFC903CA0FAF8C2490000000410FAFC18D04814863C8488B442478488D440102418BCD40887001448818448850FF448840FE4883C00448FFC975E8FFC2
		413BD77CB233C04883C428415F415E415D415C5F5E5D5BC3
)"
VarSetStrCapacity(&PixelateBitmap, StrLen(MCode_PixelateBitmap)//2) ; V1toV2: if 'PixelateBitmap' is NOT a UTF-16 string, use 'PixelateBitmap := Buffer(StrLen(MCode_PixelateBitmap)//2)'
Loop StrLen(MCode_PixelateBitmap)//2
NumPut("UChar", "0x" SubStr(MCode_PixelateBitmap, ((2*A_Index)-1)<1 ? ((2*A_Index)-1)-1 : ((2*A_Index)-1), 2), PixelateBitmap, A_Index-1)
DllCall("VirtualProtect", "Ptr", PixelateBitmap, "Ptr", VarSetStrCapacity(&PixelateBitmap), "uint", 0x40, A_PtrSize ? "UPtr*" : "UInt*", &0) ; V1toV2: if 'PixelateBitmap' is NOT a UTF-16 string, use 'PixelateBitmap := Buffer()'
}
Gdip_GetImageDimensions(pBitmap, Width[0], Height[0])
if (Width[0] != Gdip_GetImageWidth(pBitmapOut) || Height[0] != Gdip_GetImageHeight(pBitmapOut))
return -1
if (BlockSize > Width[0] || BlockSize > Height[0])
return -2
E1 := Gdip_LockBits(pBitmap, 0, 0, Width[0], Height[0], Stride1, Scan01, BitmapData1)
E2 := Gdip_LockBits(pBitmapOut, 0, 0, Width[0], Height[0], Stride2, Scan02, BitmapData2)
if (E1 || E2)
return -3
E := DllCall(PixelateBitmap, "Ptr", Scan01, "Ptr", Scan02, "int", Width[0], "int", Height[0], "int", Stride1, "int", BlockSize)
Gdip_UnlockBits(pBitmap, BitmapData1), Gdip_UnlockBits(pBitmapOut, BitmapData2)
return 0
}
Gdip_ToARGB(A, R, G, B)
{
return (A << 24) | (R << 16) | (G << 8) | B
}
Gdip_FromARGB(ARGB, &A, &R, &G, &B)
{
A := (0xff000000 & ARGB) >> 24
R := (0x00ff0000 & ARGB) >> 16
G := (0x0000ff00 & ARGB) >> 8
B := 0x000000ff & ARGB
}
Gdip_AFromARGB(ARGB)
{
return (0xff000000 & ARGB) >> 24
}
Gdip_RFromARGB(ARGB)
{
return (0x00ff0000 & ARGB) >> 16
}
Gdip_GFromARGB(ARGB)
{
return (0x0000ff00 & ARGB) >> 8
}
Gdip_BFromARGB(ARGB)
{
return 0x000000ff & ARGB
}
StrGetB(Address, Length:=-1, Encoding:=0)
{
if !isInteger(Length)
Encoding := Length,  Length := -1
if (Address+0 < 1024)
return
if (Encoding = "UTF-16")
Encoding := "1200"
else if (Encoding = "UTF-8")
Encoding := "65001"
else if SubStr(Encoding, 1, 2)="CP"
Encoding := SubStr(Encoding, 3)
if !Encoding
{
if (Length == -1)
Length := DllCall("lstrlen", "uint", Address)
VarSetStrCapacity(&String, Length) ; V1toV2: if 'String' is NOT a UTF-16 string, use 'String := Buffer(Length)'
DllCall("lstrcpyn", "str", String, "uint", Address, "int", Length + 1)
}
else if (Encoding = 1200)
{
char_count := DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "uint", 0, "uint", 0, "uint", 0, "uint", 0)
VarSetStrCapacity(&String, char_count) ; V1toV2: if 'String' is NOT a UTF-16 string, use 'String := Buffer(char_count)'
DllCall("WideCharToMultiByte", "uint", 0, "uint", 0x400, "uint", Address, "int", Length, "str", String, "int", char_count, "uint", 0, "uint", 0)
}
else if isInteger(Encoding)
{
char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", 0, "int", 0)
VarSetStrCapacity(&String, char_count * 2) ; V1toV2: if 'String' is NOT a UTF-16 string, use 'String := Buffer(char_count * 2)'
char_count := DllCall("MultiByteToWideChar", "uint", Encoding, "uint", 0, "uint", Address, "int", Length, "uint", String, "int", char_count * 2)
String := StrGetB(&String, char_count, 1200)
}
return String
}
para(_text, _lineWidth:=0, _align:=0, _paragraphs:=true, _reformPunct:=0, _hardReturn:=true, _newline:="`n", _indentFirstLine:="    ", _indentOtherLines:="", _reformPunc1Space:="", _reformPuncUpper:="", _reformPunc2Spaces:="", _reformPunc1SpaceBefore:="")
{
Static s_indentFirst := ""
Static s_indentOther := ""
; REMOVED: backupAutoTrim:=A_AutoTrim
; REMOVED: AutoTrim, Off
backupStringCaseSense:=A_StringCaseSense
;REMOVED StringCaseSense, Off
If (s_indentFirst = "")
{
s_indentFirst := Chr(02)
}
If (s_indentOther = "")
{
s_indentOther := Chr(03)
}
If (_lineWidth = 0)
{
_lineWidth := 16777216
}
if InStr(_text, "`r")
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
_text := StrReplace(_text, "`r`n", "`n")
If (_hardReturn = false)
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
_text := StrReplace(_text, "`r", A_Space)
}
}
If (_paragraphs)
{
_text := RegExReplace(_text, "S.Length)(?: *\n( )*){2,}", "$1`r`r")
}
_text := RegExReplace(_text, "Sm`a)^ +", "")
_text := RegExReplace(_text, "Sm`n) {2,}", " ")
If (_align = 1 || _align = "indent")
{
WidthIndentFirstLine := StrLen(_indentFirstLine)
wfl := Width["IndentFirstLine"]
}
else
{
_indentFirstLine := ""
wfl := WidthIndentFirstLine := 0
}
_text := RegExReplace(_text, "S.Length)(?:\S.Length*\n)+", " ")
VarSetStrCapacity(&output, StrLen(_text)) ; V1toV2: if 'output' is NOT a UTF-16 string, use 'output := Buffer(StrLen(_text))'
VarSetStrCapacity(&buf, _lineWidth) ; V1toV2: if 'buf' is NOT a UTF-16 string, use 'buf := Buffer(_lineWidth)'
VarSetStrCapacity(&op, _lineWidth) ; V1toV2: if 'op' is NOT a UTF-16 string, use 'op := Buffer(_lineWidth)'
buf := ""
output := ""
op := ""
spaceWidth := 1
Loop Parse, _text, "`r", "`r"
{
p := A_LoopField
op := ""
buf := ""
if (_reformPunct = 3)
{
p := RegExReplace(p, "S.Length)[ \n]?([" . _reformPunc1Space . "])[ \n]*", "$1 ")
p := RegExReplace(p, "S.Length)([" . _reformPuncUpper . "]) (\w?)", "$1 $U2")
p := RegExReplace(p, "S.Length)[ \n]?([" . _reformPunc2Spaces . "])( )*", "$1$2 ")
p := RegExReplace(p, "S.Length)([" . _reformPunc1SpaceBefore . "])", " $1")
p := RegExReplace(p, "S.Length)^(\w?)", "$U1")
}
else If (_reformPunct)
{
p := RegExReplace(p, "S.Length)[ \n]?(,)[ \n]*", "$1 ")
p := RegExReplace(p, "S.Length)([.!?;:]) ?(\w?)", "$1 $U2")
p := RegExReplace(p, "S.Length)^(\w?)", "$U1")
If (_reformPunct = 2)
{
p := RegExReplace(p, "S.Length)([.!?]) ", "$1  ")
}
}
p := s_indentFirst . p
wfl := Width["IndentFirstLine"]
spaceLeft := _lineWidth - wfl
Loop Parse, p, A_Space, A_Space
{
width := StrLen(A_LoopField)
If (buf != "" && (bufwidth := StrLen(buf)) < spaceLeft - 1)
{
op .= buf
buf := ""
}
If (Width[0] > spaceLeft - 1)
{
op .= buf . "`n" . (StrLen(A_LoopField) ? s_indentOther : "") . A_LoopField
buf := ""
spaceLeft := _lineWidth - Width[0] - 1
wfl := 0
}
else
{
buf .= " " . A_LoopField
spaceLeft := spaceLeft - (Width[0] + 1)
}
}
output .= "`n" . RegExReplace(op . buf, "Sm)^ *| *$")
}
output := SubStr(output, (1)+1)
If (_indentFirstLine != "")
{
output := RegExReplace(output, "Sm`n)^" . s_indentFirst, _indentFirstLine)
}
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
output := StrReplace(output, s_indentFirst)
If (_indentOtherLines != "")
{
output := RegExReplace(output, "Sm`n)^" . s_indentOther, _indentOtherLines)
}
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
output := StrReplace(output, s_indentOther)
If (_lineWidth != 16777216 && _paragraphs)
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
output := StrReplace(output, "`r", "`n")
}
output := RegExReplace(output, "Sm`n)^\S.Length+$")
If (_align && _lineWidth != 16777216)
{
If (_align = 2 || _align = "right")
{
_text := ""
Loop Parse, output, "`n"
{
line := A_LoopField
spaces := ""
Loop _lineWidth - 1 - StrLen(line)
{
spaces .= A_Space
}
line := spaces . line
_text .= line . "`n"
}
output := _text
}
Else If (_align = 3 || _align = "center")
{
_text := ""
Loop Parse, output, "`n"
{
line := A_LoopField
spaces := ""
Loop (_lineWidth - StrLen(line)) // 2
{
spaces .= A_Space
}
line := spaces . line . spaces
_text .= line . "`n"
}
output := _text
}
}
If (_newline != "`n")
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
output := StrReplace(output, "`n", _newline)
}
; REMOVED: AutoTrim, %backupAutoTrim%
;REMOVED StringCaseSense, %backupStringCaseSense%
return output
}
SetCursor(false)
global g_strAppNameFile := "QuickClipboardEditor"
global g_strAppNameText := "Quick A_Clipboard Editor"
global o_CommandLineParameters := new CommandLineParameters()
global g_blnPortableMode
SetQCEWorkingDirectory()
OnExit(CleanUpBeforeExit, )
global g_strCurrentVersion := "1.3.2"
global g_strCurrentBranch := "prod"
global g_strAppVersion := "v" . g_strCurrentVersion . (g_strCurrentBranch <> "prod" ? " " . g_strCurrentBranch : "")
global g_strJLiconsVersion := "1.6.6"
global g_strLastVersionUsed := ""
ComObjError(g_strCurrentBranch <> "prod")
if (g_blnPortableMode)
global o_JLicons := new JLIcons(A_ScriptDir . "\JLicons.dll")
else
global o_JLicons := new JLIcons(A_AppDataCommon . "\JeanLalonde\JLicons.dll")
global o_Settings := new Settings
g_blnIniFileCreation := !FileExist(o_Settings.strIniFile)
if StrLen(o_CommandLineParameters.AA["Settings"])
{
o_Settings.strIniFile := PathCombine(A_WorkingDir, EnvVars(o_CommandLineParameters.AA["Settings"]))
SplitPath(o_Settings.strIniFile, &strIniFileNameExtOnly)
o_Settings.strIniFileNameExtOnly := strIniFileNameExtOnly
strIniFileNameExtOnly := ""
}
o_Settings.ReadIniOption("Launch", "strQCETempFolderParent", "QCETempFolder", (g_blnPortableMode ? A_WorkingDir . "\TEMP": "%TEMP%"), "f_strQCETempFolderParentPath|f_lblQCETempFolderParentPath|f_btnQCETempFolderParentPath")
if !StrLen(o_Settings.Launch.strQCETempFolderParent.IniValue)
if StrLen(EnvVars("%TEMP%"))
o_Settings.Launch.strQAPTempFolderParent.IniValue := "%TEMP%"
else
o_Settings.Launch.strQCETempFolderParent.IniValue := A_WorkingDir
global g_strTempDirParent := PathCombine(A_WorkingDir, EnvVars(o_Settings.Launch.strQCETempFolderParent.IniValue))
global g_strTempDir := g_strTempDirParent . "\_QCE_temp_" . RandomBetween()
DirCreate(g_strTempDir)
SetTimer(RemoveOldTemporaryFolders,-10000,-100)
InitFileInstall()
global g_strEscapeReplacement := "!r4nd0mt3xt!"
global o_L := new Language
o_Settings.InitOptionsGroupsLabelNames()
global g_strDiagFile := A_WorkingDir . "\" . g_strAppNameFile . "-DIAG.txt"
global g_intGuiLeftMargin := 8
global g_intGuiTopMargin := 9
global g_intEditorDefaultWidth := 640
global g_intEditorDefaultHeight := 320
global g_saEditorControls := Object()
global g_aaEditorControlsByName := Object()
global g_intEditorHwnd
global g_strEditorControlHwndWrapOn
global g_strEditorControlHwndWrapOff
global g_strEditorControlHwnd
global g_strHistorySearchHwnd
global g_strSaveButtonHwnd
global g_strCancelButtonHwnd
global g_strCloseButtonHwnd
global g_strClosePasteButtonHwnd
global g_intClipboardContentType
global g_strSortOptions
global g_strAccentuatedLower := "üéâäàåçêëèïîìæôöòûùÿøáíóúñãõý"
global g_strAccentuatedUpper := "ÜÉÂÄÀÅÇÊËÈÏÎÌÆÔÖÒÛÙÿØÁÍÓÚÑÃÕÝ"
global g_strClipboardCrLf := Convert2CrLf(WinClipGetTextOrFiles())
global g_strClipboardCrLfPrevious := g_strClipboardCrLf
global g_aaToolTipsMessages := Object()
global g_blnCopyOrCutFromEditor
global g_blnFromCopyToClipboard
global g_aaTrayL
global g_aaFileL
global g_aaEditL
global g_aaConvertBitmapL
global g_aaOptionsL := Object()
global g_blnCommandInProgress := false
global g_strDbHistoryDisabled
global g_aaEditCommand
global g_aaSavedCommand
global g_aaSavedCommandsHotkeys
global g_blnSavedCommandRetrieved
global g_blnClipboardIsBitmap
global g_blnExcelActive
global g_blnAlwaysOnTopCurrent
global g_blnWordWrapCurrent
global g_blnFixedFontCurrent
global g_intFontSizeCurrent
global g_blnKeepOpenAfterPasteCurrent
global g_blnCopyToAppendCurrent
global g_blnSeeInvisible
global g_blnLightMode := False
g_blnLightMode := RegRead("HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Themes\Personalize", "AppsUseLightTheme")
global g_strHistoryPrevButtonHwnd
global g_strHistoryNextButtonHwnd
global g_strDbFile :=  A_WorkingDir . "\QCE-DB2.db"
global g_intHistoryPosition
global g_strLastHistoryClip
global g_intHistorySearchClickedRow
global g_intMaximumValue := 0x7FFFFFFFFFFFFFFF
global g_strEscapePipe := "Ð¡þ€"
global g_strEllipse := "…"
if InStr("WIN_VISTA|WIN_2003|WIN_XP|WIN_2000", A_OSVersion)
{
MsgBox(L(o_L["OopsOSVerrsionError"], g_strAppNameText), g_strAppNameText, 0)
OnExit(, )
ExitApp()
}
if InStr(A_ScriptDir, A_Temp)
{
Oops(0, o_L["OopsZipFileError"], g_strAppNameFile)
OnExit(, )
ExitApp()
}
InitEditorControls()
if (g_blnPortableMode)
o_JLicons.CheckVersion()
global o_MouseButtons := new Triggers.MouseButtons
global o_PopupHotkeys := new Triggers.PopupHotkeys
global o_PopupHotkeyOpenEditorHotkeyMouse := o_PopupHotkeys.SA[1]
global o_PopupHotkeyOpenEditorHotkeyKeyboard := o_PopupHotkeys.SA[2]
global o_PopupHotkeyPasteFromQCE := o_PopupHotkeys.SA[3]
global o_PopupHotkeyCopyOpenQCE := o_PopupHotkeys.SA[4]
global o_PopupHotkeyHisotryMenu := o_PopupHotkeys.SA[5]
global o_Utc2LocalTime := new Utc2LocalTime
intStartups := o_Settings.ReadIniValue("Startups", 0)
IniWrite((intStartups + 1), o_Settings.strIniFile, "Internal", "Startups")
IniWrite((g_blnPortableMode ? "Portable" : "Easy Setup"), o_Settings.strIniFile, "Internal", "Installation")
strLastVersionUsedBeta := IniRead(o_Settings.strIniFile, "Internal", "LastVersionUsedBeta", A_Space)
strLastVersionUsedProd := IniRead(o_Settings.strIniFile, "Internal", "LastVersionUsedProd", A_Space)
IniWrite(g_strCurrentVersion, o_Settings.strIniFile, "Internal", "LastVersionUsed" . (g_strCurrentBranch = "alpha" ? "Alpha" : (g_strCurrentBranch = "beta" ? "Beta" : "Prod")))
g_strLastVersionUsed := (ComparableVersionNumber(strLastVersionUsedBeta) > ComparableVersionNumber(strLastVersionUsedProd) ? strLastVersionUsedBeta : strLastVersionUsedProd)
strLastVersionUsedBeta := ""
strLastVersionUsedProd := ""
InitEditCommandTypes()
LoadIniFile()
InitDb()
InitHistoryMenuFile()
BuildEditorMenuBar()
BuildTrayMenu()
BuildHistorySearchMenu()
BuildManageSavedCommandsMenu()
BuildInspectClipboardMenu()
RefreshSavedCommandsMenuAndHotkeys()
UpdateToggleMenus()
if (o_Settings.Launch.blnDiagMode.IniValue)
{
InitDiagMode()
strLaunchSettingsFolderDiag := ""
}
if (o_Settings.EditorWindow.blnDarkMode.IniValue)
{
uxtheme := DllCall("GetModuleHandle", "str", "uxtheme", "ptr")
SetPreferredAppMode := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 135, "ptr")
FlushMenuThemes := DllCall("GetProcAddress", "ptr", uxtheme, "ptr", 136, "ptr")
DllCall(SetPreferredAppMode, "int", 1)
DllCall(FlushMenuThemes)
}
global o_ControlColor := Object()
global o_UndoPile := new UndoPile()
global g_intUndoRedoOffset := 0
global g_intUndoPileSize
global g_intUndoPileNb
SetTrayMenuIcon()
BuildGuiEditor()
if (o_Settings.Launch.blnCheck4Update.IniValue)
Check4Update()
o_Formats := WinClip.GetFormats()
for intFormat, oItem in o_Formats
if InStr("CF_UNICODETEXT|CF_TEXT|CF_OEMTEXT", oItem.Name)
{
g_intClipboardContentType := 1
break
}
else if InStr("CF_BITMAP|CF_DIB|CF_DIBV5", oItem.Name)
{
g_intClipboardContentType := 2
break
}
o_Formats := ""
EnableClipboardChangesInEditor()
if (o_Settings.Launch.blnDisplayTrayTip.IniValue)
{
TrayTip(L(o_L["TrayTipInstalledTitle"], g_strAppNameText), L(o_L["TrayTipInstalledDetail"], (HasShortcutText(o_PopupHotkeyOpenHotkeyMouse.AA.strPopupHotkeyText))
? o_PopupHotkeyOpenHotkeyMouse.AA.strPopupHotkeyText : ""). (HasShortcutText(o_PopupHotkeyOpenHotkeyMouse.AA.strPopupHotkeyText)
and HasShortcutText(o_PopupHotkeyOpenHotkeyKeyboard.AA.strPopupHotkeyText)
? " " . o_L["DialogOr"] . " " : ""). (HasShortcutText(o_PopupHotkeyOpenHotkeyKeyboard.AA.strPopupHotkeyText)
? o_PopupHotkeyOpenHotkeyKeyboard.AA.strPopupHotkeyText : "")), , 17
Sleep(20)
}
if (g_blnIniFileCreation and !g_blnPortableMode)
SetRegistry("QuickClipboardEditor.exe", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", g_strAppNameText)
OnMessage(0x200, WM_MOUSEMOVE)
OnMessage(0x0100, WM_KEYDOWN)
OnMessage(0x204, WM_RBUTTONDOWN)
OnMessage(0x205, WM_RBUTTONUP)
Hotkey("If WinActiveQCE()")
Hotkey("^S.Length", EditorCtrlS, "On UseErrorLevel")
Hotkey("^z", EditorCtrlZ, "On UseErrorLevel")
Hotkey("^y", EditorCtrlY, "On UseErrorLevel")
Hotkey("^c", EditorCtrlC, "On UseErrorLevel")
Hotkey("^x", EditorCtrlX, "On UseErrorLevel")
Hotkey("^v", EditorCtrlV, "On UseErrorLevel")
Hotkey("^f", EditorCtrlF, "On UseErrorLevel")
Hotkey("^i", EditorCtrlI, "On UseErrorLevel")
Hotkey("^b", EditorCtrlB, "On UseErrorLevel")
Hotkey("^p", EditorCtrlP, "On UseErrorLevel")
Hotkey("^q", EditorCtrlQ, "On UseErrorLevel")
Hotkey("^t", EditorCtrlT, "On UseErrorLevel")
Hotkey("+^t", EditorShiftCtrlT, "On UseErrorLevel")
Hotkey("^h", EditorCtrlH, "On UseErrorLevel")
Hotkey("F3", EditorF3, "On UseErrorLevel")
Hotkey("+F3", EditorShiftF3, "On UseErrorLevel")
Hotkey("Del", EditorDel, "On UseErrorLevel")
Hotkey("+F10", EditorShiftF10, "On UseErrorLevel")
Hotkey("^!l", EditorCtrlAltL, "On UseErrorLevel")
Hotkey("^!u", EditorCtrlAltU, "On UseErrorLevel")
Hotkey("^!t", EditorCtrlAltT, "On UseErrorLevel")
Hotkey("^!S.Length", EditorCtrlAltS, "On UseErrorLevel")
Hotkey("^!g", EditorCtrlAltG, "On UseErrorLevel")
Hotkey("^!a", EditorCtrlAltA, "On UseErrorLevel")
Hotkey("!F4", EditorAltF4, "On UseErrorLevel")
Hotkey("^d", EditorCtrlD, "On UseErrorLevel")
Hotkey("^l", EditorCtrlL, "On UseErrorLevel")
Hotkey("^o", EditorCtrlO, "On UseErrorLevel")
Hotkey("^e", EditorCtrlE, "On UseErrorLevel")
Hotkey("^r", EditorCtrlR, "On UseErrorLevel")
Hotkey("^m", EditorCtrlM, "On UseErrorLevel")
Hotkey("^+Down", GuiEditorMoveLineDown, "On UseErrorLevel")
Hotkey("^+Up", GuiEditorMoveLineUp, "On UseErrorLevel")
Hotkey("^WheelDown", GuiEditorMouseWheelDown, "On UseErrorLevel")
Hotkey("^WheelUp", GuiEditorMouseWheelUp, "On UseErrorLevel")
Hotkey("F1", GuiHotkeysHelp, "On UseErrorLevel")
if FileExist("C:\Dropbox\AutoHotkey\QuickClipboardEditor\QuickClipboardEditor-HOME.ini")
{
Hotkey("^SC056", EditorCtrlX, "On UseErrorLevel")
Hotkey("#SC056", EditorCtrlC, "On UseErrorLevel")
}
HotIf()
Hotkey("If WinActive(o_L[`"GuiHistorySearchTitle`"])")
Hotkey("Down", HistorySearchDown)
Hotkey("Up", HistorySearchUp)
if (o_Settings.EditorWindow.blnDisplayEditorAtStartup.IniValue)
GuiShowEditor()
SetTimer(AddToUndoPileTimer,1000)
return
#HotIf CanPopup(A_ThisHotkey)
#HotIf
#HotIf WinActiveQCE()
#HotIf
#HotIf WinActive(o_L["GuiHistorySearchTitle"])
#HotIf
!_012_GUI_HOTKEYS:
EditorCtrlC(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlF(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlH(ThisHotkey)
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
EditorCtrlS(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlV(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlX(ThisHotkey)
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
EditorCtrlY(ThisHotkey)
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
EditorCtrlZ(ThisHotkey)
{ ; V1toV2: Added bracket
EditorDel(ThisHotkey)
{ ; V1toV2: Added bracket
EditorEsc:
} ; V1toV2: Added bracket before function
EditorF3(ThisHotkey)
{ ; V1toV2: Added bracket
EditorShiftF10(ThisHotkey)
{ ; V1toV2: Added bracket
EditorShiftF3(ThisHotkey)
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
EditorCtrlI(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlB(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlP(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlQ(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlT(ThisHotkey)
{ ; V1toV2: Added bracket
EditorShiftCtrlT(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlAltL(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlAltU(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlAltT(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlAltS(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlAltG(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlAltA(ThisHotkey)
{ ; V1toV2: Added bracket
EditorAltF4(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlL(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlD(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlO(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlE(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlR(ThisHotkey)
{ ; V1toV2: Added bracket
EditorCtrlM(ThisHotkey)
{ ; V1toV2: Added bracket
Editor := Gui()
Editor.OnEvent("Close", EditorGuiClose)
Editor.OnEvent("Escape", !_050_GUI_CLOSE-CANCEL-BK_OBJECTS)
Editor.OnEvent("Size[0]", EditorGuiSize)
Editor.Default()
if (A_ThisLabel = "EditorEsc")
EditorClose()
g_blnCopyOrCutFromEditor := (A_ThisLabel = "EditorCtrlC" or A_ThisLabel = "EditorCtrlX")
if (A_ThisLabel = "EditorCtrlS")
EditorCopyToClipboard()
else if (A_ThisLabel = "EditorCtrlC")
Edit_Copy(g_strEditorControlHwnd)
else if (A_ThisLabel = "EditorCtrlX")
Edit_Cut(g_strEditorControlHwnd)
else if (A_ThisLabel = "EditorCtrlV")
Edit_Paste(g_strEditorControlHwnd)
else if (A_ThisLabel = "EditorDel")
Send("{Del}")
else if (A_ThisLabel = "EditorShiftF10")
ShowEditorEditMenu()
else if (A_ThisLabel = "EditorCtrlF")
GuiEditorFind()
else if (A_ThisLabel = "EditorF3")
GuiEditorFindNext()
else if (A_ThisLabel = "EditorShiftF3")
GuiEditorFindPrevious()
else if (A_ThisLabel = "EditorCtrlH")
GuiEditorFindReplace()
else if (A_ThisLabel = "EditorCtrlY")
GuiEditorRedo()
else if (A_ThisLabel = "EditorCtrlZ")
GuiEditorUndo()
else if (A_ThisLabel = "EditorCtrlI")
GuiEditorInsertString()
else if (A_ThisLabel = "EditorCtrlB")
GuiEditorSubString()
else if (A_ThisLabel = "EditorCtrlP")
BuildGuiHistorySearch()
else if (A_ThisLabel = "EditorCtrlQ")
GuiEditorSortQuick()
else if (A_ThisLabel = "EditorCtrlT")
GuiEditorSortOptions()
else if (A_ThisLabel = "EditorShiftCtrlT")
GuiEditorSortAgain()
else if (A_ThisLabel = "EditorCtrlAltL")
ChangeCaseLower()
else if (A_ThisLabel = "EditorCtrlAltU")
ChangeCaseUpper()
else if (A_ThisLabel = "EditorCtrlAltT")
ChangeCaseTitle()
else if (A_ThisLabel = "EditorCtrlAltS")
ChangeCaseSentence()
else if (A_ThisLabel = "EditorCtrlAltG")
ChangeCaseToggle()
else if (A_ThisLabel = "EditorCtrlAltA")
ChangeCaseSaRcAsM()
else if (A_ThisLabel = "EditorAltF4")
EditorCloseAndExitApp()
else if (A_ThisLabel = "EditorCtrlL")
GuiEditorFilterLines()
else if (A_ThisLabel = "EditorCtrlD")
GuiEditorFilterCharacters()
else if (A_ThisLabel = "EditorCtrlO")
GuiEditorFileOpen()
else if (A_ThisLabel = "EditorCtrlE")
GuiEditorFileSave()
else if (A_ThisLabel = "EditorCtrlR")
GuiEditorReformatPara()
else if (A_ThisLabel = "EditorCtrlM")
GuiManageSavedCommands()
if InStr("CtrlV|CtrlX|Del", StrReplace(A_ThisLabel, "Editor"))
AddToUndoPile()
return
} ; V1toV2: Added Bracket before label
!_015_INITIALIZATION_SUBROUTINES:
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
SetQCEWorkingDirectory()
{ ; V1toV2: Added bracket
if StrLen(o_CommandLineParameters.AA["Working"])
SetWorkingDir(o_CommandLineParameters.AA["Working"])
g_blnPortableMode := !FileExist(A_ScriptDir . "\_do_not_remove_or_rename.txt")
strLaunchSettingsFolderDiag .= "g_blnPortableMode: " . g_blnPortableMode . "`n"
if (g_blnPortableMode or StrLen(o_CommandLineParameters.AA["Working"]))
return
if (A_WorkingDir = A_AppDataCommon . "\" . g_strAppNameText)
{
if !RegistryExist("HKEY_CURRENT_USER\Software\Jean Lalonde\" . g_strAppNameText, "WorkingFolder")
{
SetRegistry("quickclipboardeditor.exe", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", g_strAppNameText)
strWorkingFolder := A_MyDocuments . "\" . g_strAppNameText
if !FileExist(strWorkingFolder)
DirCreate(strWorkingFolder)
SetRegistry(strWorkingFolder, "HKEY_CURRENT_USER\Software\Jean Lalonde\" . g_strAppNameText, "WorkingFolder")
strLaunchSettingsFolderDiag .= "strWorkingFolder (first install key does not exist): " . strWorkingFolder . "`n"
}
else
{
strWorkingFolder := GetRegistry("HKEY_CURRENT_USER\Software\Jean Lalonde\" . g_strAppNameText, "WorkingFolder")
strLaunchSettingsFolderDiag .= "strWorkingFolder (first launch after re-install key exists): " . strWorkingFolder . "`n"
}
}
else
{
strWorkingFolder := GetRegistry("HKEY_CURRENT_USER\Software\Jean Lalonde\" . g_strAppNameText, "WorkingFolder")
strLaunchSettingsFolderDiag .= "strWorkingFolder (not first launch): " . strWorkingFolder . "`n"
}
if StrLen(strWorkingFolder)
{
if !FileExist(strWorkingFolder)
{
DirCreate(strWorkingFolder)
}
if !FileExist(strWorkingFolder . "\quickclipboardeditor-setup.ini")
Try{
   FileCopy(A_AppDataCommon "\Quick A_Clipboard Editor\quickclipboardeditor-setup.ini", strWorkingFolder)
   ErrorLevel := 0
} Catch as Err {
   ErrorLevel := Err.Extra
}
if !FileExist(strWorkingFolder . "\quickclipboardeditor.ini")
Try{
   FileCopy(A_AppDataCommon "\quickclipboardeditor.ini", strWorkingFolder)
   ErrorLevel := 0
} Catch as Err {
   ErrorLevel := Err.Extra
}
SetWorkingDir(strWorkingFolder)
}
else
{
Oops(0, "The Quick A_Clipboard Editor settings folder could not be found.`n`nPlease, re-install Quick A_Clipboard Editor.")
OnExit(, )
ExitApp()
}
strWorkingFolder := ""
strLaunchSettingsFolderDiag .= "A_WorkingDir: " . A_WorkingDir . "`n"
return
} ; V1toV2: Added Bracket before label
InitFileInstall()
{ ; V1toV2: Added bracket
return
} ; V1toV2: Added Bracket before label
InitEditCommandTypes()
{ ; V1toV2: Added bracket
global g_aaEditCommandTypes = Object()
global g_saEditCommandTypesOrder = Object()
saEditCommandTypes := StrSplit("InsertString|SubString|FilterLines|FilterCharacters|ReformatPara|SortOptions". "|Find|FindReplace|FileOpen|FileSave|FileClipboardBackup|FileClipboardRestore", "|")
for intIndex, strType in saEditCommandTypes
{
strLabels .= o_L["Type" . strType] . "|"
if (strType = "SortOptions")
strHelpEditor .= o_L["TypeSortHelpEditor"] . " " . L(o_L["TypeSortHelpLink"], "https://www.autohotkey.com/docs/commands/Sort.htm")
else
strHelpEditor .=  o_L["Type" . strType . "HelpEditor"] . (strType = "SubString" ? o_L["TypeSubStringHelp2"] : ""). (strType = "Find" or strType = "FindReplace" or InStr(strType, "Remove") ? " " . o_L["EditEncodingHelp"] : ""). (strType = "InsertString" ? " " : ""). (strType = "SubString" or strType = "InsertString" ? o_L["EditSubStringHelp3"] : "")
strHelpEditor .= "|"
}
saEditCommandTypesLabels := StrSplit(SubStr(strLabels, 1, -1), "|")
saEditCommandTypesHelpEditor := StrSplit(SubStr(strHelpEditor, 1, -1), "|")
Loop saEditCommandTypes.Length
new EditCommandType(saEditCommandTypes[A_Index], saEditCommandTypesLabels[A_Index], saEditCommandTypesHelpEditor[A_Index])
saEditCommandTypes := ""
saEditCommandTypesLabels := ""
strLabels := ""
strHelp := ""
return
} ; V1toV2: Added Bracket before label
LoadIniFile()
{ ; V1toV2: Added bracket
if FileExist(o_Settings.strIniFile)
Settings.BackupIniFile(o_Settings.strIniFile)
o_Settings.ReadIniOption("Launch", "blnLaunchAtStartup", "LaunchAtStartup", (g_blnPortableMode ? 0 : 1), "f_blnLaunchAtStartup")
o_Settings.ReadIniOption("Launch", "blnDisplayTrayTip", "DisplayTrayTip", 1, "f_blnDisplayTrayTip")
o_Settings.ReadIniOption("Launch", "blnCheck4Update", "Check4Update", (g_blnPortableMode ? 0 : 1), "f_blnCheck4Update|f_lnkCheck4Update")
o_Settings.ReadIniOption("Launch", "strBackupFolder", "BackupFolder", A_WorkingDir, "f_lblBackupFolder|f_strBackupFolder|f_btnBackupFolder")
o_Settings.ReadIniOption("Launch", "blnDiagMode", "DiagMode", 0)
o_Settings.ReadIniOption("Launch", "blnDiagModeUndo", "DiagModeUndo", 0)
o_Settings.ReadIniOption("EditorWindow", "blnDisplayEditorAtStartup", "DisplayEditorAtStartup", 1, "f_blnDisplayEditorAtStartup")
o_Settings.ReadIniOption("EditorWindow", "blnRememberEditorPosition", "RememberEditorPosition", (g_blnPortableMode ? 0 : 1), "f_blnRememberEditorPosition")
o_Settings.ReadIniOption("EditorWindow", "blnDarkMode", "DarkMode", 1, "f_blnDarkMode")
o_Settings.ReadIniOption("EditorWindow", "blnAsciiHexa", "AsciiHexa", 0, "f_blnAsciiHexa")
o_Settings.ReadIniOption("EditorWindow", "blnFixedFontDefault", "FixedFontDefault", 1, "f_blnFixedFontDefault")
g_blnFixedFontCurrent := o_Settings.EditorWindow.blnFixedFontDefault.IniValue
o_Settings.ReadIniOption("EditorWindow", "intFontSizeDefault", "FontSizeDefault", 12, "f_intFontSizeDefault|f_lblFontSizeDefault|f_intFontUpDownDefault")
g_intFontSizeCurrent := o_Settings.EditorWindow.intFontSizeDefault.IniValue
o_Settings.ReadIniOption("EditorWindow", "blnAlwaysOnTopDefault", "DefaultAlwaysOnTop", 0, "f_lblStartupDefault|f_blnAlwaysOnTopDefault")
g_blnAlwaysOnTopCurrent := o_Settings.EditorWindow.blnAlwaysOnTopDefault.IniValue
o_Settings.ReadIniOption("EditorWindow", "blnWordWrapDefault", "WordWrapDefault", 1, "f_blnWordWrapDefault")
g_blnWordWrapCurrent := o_Settings.EditorWindow.blnWordWrapDefault.IniValue
o_Settings.ReadIniOption("EditorWindow", "blnUseTab", "UseTab", 1, "f_blnUseTab")
o_Settings.ReadIniOption("EditorWindow", "blnKeepOpenAfterPasteDefault", "KeepOpenAfterPasteDefault", 0, "f_blnKeepOpenAfterPasteDefault")
g_blnKeepOpenAfterPasteCurrent := o_Settings.EditorWindow.blnKeepOpenAfterPasteDefault.IniValue
o_Settings.ReadIniOption("EditorWindow", "blnCopyToAppendDefault", "CopyToAppendDefault", 0, "f_blnCopyToAppendDefault")
g_blnCopyToAppendCurrent := o_Settings.EditorWindow.blnCopyToAppendDefault.IniValue
o_Settings.ReadIniOption("EditorWindow", "strDarkBgColorEdit", "DarkBgColorEdit", "2B2B2B", "")
o_Settings.ReadIniOption("EditorWindow", "strDarkBgColorReadOnly", "DarkBgColorReadOnly", "606060", "")
o_Settings.ReadIniOption("EditorWindow", "strDarkBgColorGui", "DarkBgColorGui", "B0B0B0", "")
o_Settings.ReadIniOption("EditorWindow", "strDarkTextColorEdit", "DarkTextColorEdit", "FFFFFF", "")
o_Settings.ReadIniOption("EditorWindow", "strDarkTextColorReadOnly", "DarkTextColorReadOnly", "EEEEEE", "")
o_Settings.ReadIniOption("History", "blnHistoryEnabled", "HistoryEnabled", 1, "f_blnHistoryEnabled")
g_blnDbHistoryDisabled :=  !(o_Settings.History.blnHistoryEnabled.IniValue)
o_Settings.ReadIniOption("History", "intHistoryDbMaximumSize", "HistoryDbMaximumSize", 5, "f_lblHistoryDbMaximumSize|f_intHistoryDbMaximumSize|f_btnHistoryDbFlush")
o_Settings.ReadIniOption("History", "intHistorySyncDelay", "HistorySyncDelay", 500, "f_lblHistorySyncDelay|f_intHistorySyncDelay")
o_Settings.ReadIniOption("History", "intHistoryMenuCharsWidth", "HistoryMenuCharsWidth", 100, "f_lblHistoryMenus|f_lblHistorySearch|f_lblHistoryMenuCharsWidth|f_intHistoryMenuCharsWidth")
o_Settings.ReadIniOption("History", "intHistoryMenuRows", "HistoryMenuRows", 25, "f_lblHistoryMenuRows|f_intHistoryMenuRows")
o_Settings.ReadIniOption("History", "intHistoryMenuIconSize", "HistoryMenuIconSize", 16, "f_lblHistoryMenuIconSize|f_intHistoryMenuIconSize")
o_Settings.ReadIniOption("History", "intHistorySearchCharsWidth", "HistorySearchCharsWidth", 50, "f_lblHistorySearchCharsWidth|f_intHistorySearchCharsWidth")
o_Settings.ReadIniOption("History", "intHistorySearchRows", "HistorySearchRows", 12, "f_lblHistorySearchRows|f_intHistorySearchRows")
o_Settings.ReadIniOption("History", "intHistorySearchQueryRows", "HistorySearchQueryRows", 200, "f_lblHistorySearchQueryRows|f_intHistorySearchQueryRows")
o_Settings.ReadIniOption("Various", "intSavedCommandsLinesInList", "SavedCommandsLinesInList", 10, "f_lblSavedCommandsLinesInList|f_intSavedCommandsLinesInList")
o_Settings.ReadIniOption("Various", "intFileEncodingCodePage", "FileEncodingCodePage", 850, "f_lblFileEncodingCodePage|f_intFileEncodingCodePage")
o_Settings.ReadIniOption("Various", "strCopyAppendSeparator", "CopyAppendSeparator", EncodeEolAndTab("`n--`n"), "f_lblCopyAppendSeparator|f_strCopyAppendSeparator|f_lnkCopyAppendSeparator")
strLanguageCode := ""
return
} ; V1toV2: Added Bracket before label
InitDiagMode()
{ ; V1toV2: Added bracket
if FileExist("C:\Dropbox\AutoHotkey\QuickClipboardEditor\QuickClipboardEditor-HOME.ini")
MsgBox(L(o_L["DiagModeCaution"], g_strAppNameText, g_strDiagFile), g_strAppNameText, "4 T3")
else
msgResult := MsgBox(L(o_L["DiagModeCaution"], g_strAppNameText, g_strDiagFile), g_strAppNameText, 52)
if (msgResult = "No")
{
o_Settings.Launch.blnDiagMode.WriteIni(0)
return
}
if !FileExist(g_strDiagFile)
{
FileAppend("DateTime`tType`tData`n", g_strDiagFile)
Diag("DIAGNOSTIC FILE", o_L["DiagModeIntro"], "")
Diag("A_ScriptFullPath", A_ScriptFullPath, "")
Diag("AppVersion", g_strAppVersion, "")
Diag("A_WorkingDir", A_WorkingDir, "")
Diag("A_AhkVersion", A_AhkVersion, "")
Diag("A_OSVersion", A_OSVersion, "")
Diag("A_Is64bitOS", A_Is64bitOS, "")
Diag("1", 1, "")
Diag("A_Language", A_Language, "")
Diag("A_IsAdmin", A_IsAdmin, "")
}
strIniFileContent := Fileread(o_Settings.strIniFile)
strIniFileContent := DoubleDoubleQuotes(strIniFileContent)
Diag("IniFile", "`n""" . strIniFileContent . """`n", "")
FileAppend("`n", g_strDiagFile)
strIniFileContent := ""
return
} ; V1toV2: Added bracket before function
InitDb()
{ ; V1toV2: Added bracket
if (g_blnDbHistoryDisabled)
return
strError := ""
Loop Parse, "dll|def", "|"
{
strExtension := A_LoopField
if (g_blnPortableMode)
{
str64or32 := A_PtrSize * 8
if FileExist(A_ScriptDir . "\sqlite3." . strExtension)
{
intSizeSQLiteCurrent := FileGetSize(A_ScriptDir "\sqlite3." strExtension)
intSizeSQLiteRequired := FileGetSize(A_ScriptDir "\sqlite3-" str64or32 "-bit." strExtension)
}
if !FileExist(A_ScriptDir . "\sqlite3." . strExtension) or (intSizeSQLiteCurrent <> intSizeSQLiteRequired)
if FileExist(A_ScriptDir . "\sqlite3-" . str64or32 . "-bit." . strExtension)
{
Try{
   FileCopy(A_ScriptDir "\sqlite3-" str64or32 "-bit." strExtension, A_ScriptDir "\sqlite3." strExtension, 1)
   ErrorLevel := 0
} Catch as Err {
   ErrorLevel := Err.Extra
}
if (ErrorLevel)
{
Oops(0, "Exit ~1~ properly before restarting it with a different bitsize build (32-bit or 64-bit)", g_strAppNameText)
ExitApp()
}
}
else
strError .= A_ScriptDir . "\sqlite3-" . str64or32 . "-bit." . strExtension . "`n"
}
else
if !FileExist(A_ScriptDir . "\sqlite3." . strExtension)
strError .= A_ScriptDir . "\sqlite3." . strExtension . "`n"
}
if StrLen(strError)
{
Oops(0, o_L["OopsDbSQLiteMissing"], strError)
return
}
else
global o_Db := New SQLiteDb
if !o_Db.OpenDb(g_strDbFile)
and SQLiteError("OPEN_DB", g_strDbFile)
return
if !GetTableColumnExist("History", "CollectTime")
{
strDbSQL := "CREATE TABLE IF NOT EXISTS History (". "CollectTime TEXT,". "RecordSize INTEGER,". "ClipText TEXT UNIQUE ON CONFLICT REPLACE". ");`n". "CREATE INDEX ClipTextIndex ON History (ClipText);`n". "CREATE VIEW Recents AS SELECT * from History ORDER BY rowid DESC;"
If !o_Db.Exec(strDbSQL)
and SQLiteError("CREATE_HISTORY", strDbSQL)
return
}
if !GetTableColumnExist("Commands", "Command")
{
strDbSQL := "CREATE TABLE IF NOT EXISTS Commands (". "Command TEXT,". "Title TEXT UNIQUE ON CONFLICT REPLACE,". "Detail TEXT". ");`n". "CREATE INDEX CommandIndex ON Commands (Command);`n". "CREATE VIEW RecentCommands AS SELECT * from Commands ORDER BY rowid DESC;"
if StrLen(strDbSQL)
if !o_Db.Exec(strDbSQL)
and SQLiteError("CREATE_COMMANDS", strDbSQL)
return
}
strDbSQL := ""
if !GetTableColumnExist("Commands", "InMenu")
strDbSQL .= "ALTER TABLE Commands ADD COLUMN InMenu TEXT;"
if !GetTableColumnExist("Commands", "Hotkey")
strDbSQL .= "ALTER TABLE Commands ADD COLUMN Hotkey TEXT;"
if !GetTableColumnExist("Commands", "EditDateTime")
strDbSQL .= "ALTER TABLE Commands ADD COLUMN EditDateTime TEXT;"
If StrLen(strDbSQL)
!o_Db.Exec(strDbSQL)
and SQLiteError("ADD INMENU & HOTHEY", strDbSQL)
return
intExceedingSizeBytes := GetHistoryTableSize() - (o_Settings.History.intHistoryDbMaximumSize.IniValue * 1048576)
while (intExceedingSizeBytes > 0)
{
intExceedingSizeBytes := intExceedingSizeBytes - HistoryGetRecordSize(A_Index)
intRecordsToDelete := A_Index
}
if (intRecordsToDelete)
{
strDbSQL := "DELETE FROM History WHERE rowid in (SELECT rowid FROM History ORDER BY rowid LIMIT ". intRecordsToDelete . ");"
If !o_Db.Exec(strDbSQL)
Oops(0, "SQLite DELETE Error`n`nMsg:`t" . o_Db.ErrorMsg . "`nCode:`t" . o_Db.ErrorCode . "`n" . strDbSQL)
}
AddToHistory(g_strClipboardCrLf)
strError := ""
strExtension := ""
str64or32 := ""
intSizeSQLiteCurrent := ""
intSizeSQLiteRequired := ""
strDbSQL := ""
oDbTable := ""
intExceedingSizeBytes := ""
intRecordsToDelete := ""
return
} ; V1toV2: Added bracket before function
SQLiteError(strContext, strQuery)
{
strError := "Error Message: " . o_Db.ErrorMsg . "`nError Code: " . o_Db.ErrorCode . "`nExtended Error Code: " . o_Db.ExtErrCode(). "`nQuery: " . strQuery
Oops(0, "SQLite Error: " . strContext . "`n`n" . strError)
g_blnDbHistoryDisabled := true
return true
}
!_017_MENUS:
return
SetTrayMenuIcon()
{ ; V1toV2: Added bracket
Tray:= A_TrayMenu
Tray.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
o_Settings.ReadIniOption("Launch", "strAlternativeTrayIcon", "AlternativeTrayIcon", " ", "f_strAlternativeTrayIcon|f_lblAlternativeTrayIcon|f_btnAlternativeTrayIcon")
Tray.UseErrorLevel()
arrAlternativeTrayIcon := StrSplit(o_Settings.Launch.strAlternativeTrayIcon.IniValue, ",")
strTempAlternativeTrayIconLocation := arrAlternativeTrayIcon[1]
if StrLen(arrAlternativeTrayIcon[1]) and FileExistInPath(strTempAlternativeTrayIconLocation)
Tray.Icon(strTempAlternativeTrayIconLocation, arrAlternativeTrayIcon[2], "1")
else
SetTrayMenuIconForCurrentBranch()
if (g_blnTrayIconError)
Oops(0, o_L["OopsJLiconsError"], g_strJLiconsVersion, (StrLen(strTempAlternativeTrayIconLocation) ? arrAlternativeTrayIcon[1] : o_JLicons.strFileLocation))
arrAlternativeTrayIcon := ""
strTempAlternativeTrayIconLocation := ""
g_blnTrayIconError := ""
return
} ; V1toV2: Added Bracket before label
SetTrayMenuIconForCurrentBranch()
{ ; V1toV2: Added bracket
if (A_IsAdmin and o_Settings.Launch.blnRunAsAdmin.IniValue)
Tray.Icon(o_JLicons.strFileLocation, (g_strCurrentBranch <> "prod" ? 68 : 67), "1")
else
Tray.Icon(o_JLicons.strFileLocation, (g_strCurrentBranch = "beta" ? 70 : 66), "1")
g_blnTrayIconError := ErrorLevel or g_blnTrayIconError
Tray.UseErrorLevel("Off")
return
} ; V1toV2: Added bracket before function
BuildTrayMenu()
{ ; V1toV2: Added bracket
g_aaTrayL := o_L.InsertAmpersand("MenuEditorTray@" . o_PopupHotkeyOpenEditorHotkeyMouse.AA.strPopupHotkeyTextShort . " " . o_L["DialogOr"]. " " . o_PopupHotkeyOpenEditorHotkeyKeyboard.AA.strPopupHotkeyTextShort, "MenuOpenWorkingDirectory", "MenuSuspendHotkeys", "MenuRunAtStartup@" . g_strAppNameText, "MenuDisplayEditorAtStartup@" . g_strAppNameText, "MenuReload@" . g_strAppNameText, "MenuExitApp@" . g_strAppNameText)
Tray.Add(g_aaTrayL["MenuEditorTray@" . o_PopupHotkeyOpenEditorHotkeyMouse.AA.strPopupHotkeyTextShort . " " . o_L["DialogOr"]. " " . o_PopupHotkeyOpenEditorHotkeyKeyboard.AA.strPopupHotkeyTextShort], GuiShowEditor)
Tray.Add()
Tray.Add(g_aaTrayL["MenuOpenWorkingDirectory"], !_070_TRAY_MENU_ACTIONS)
Tray.Add()
Tray.Add(g_aaTrayL["MenuSuspendHotkeys"], ToggleSuspendHotkeys)
Tray.Add()
Tray.Add(g_aaTrayL["MenuReload@" . g_strAppNameText], EditorEscape)
Tray.Add(g_aaTrayL["MenuExitApp@" . g_strAppNameText], EditorEscape)
Tray.Tip(g_strAppNameText . " " . g_strAppVersion . " (" . (A_PtrSize * 8) . "-bit)")
Tray.Default := g_aaTrayL["MenuEditorTray@" . o_PopupHotkeyOpenEditorHotkeyMouse.AA.strPopupHotkeyTextShort . " " . o_L["DialogOr"]. " " . o_PopupHotkeyOpenEditorHotkeyKeyboard.AA.strPopupHotkeyTextShort]
Tray.Click("1")
return
} ; V1toV2: Added Bracket before label
BuildHistorySearchMenu()
{ ; V1toV2: Added bracket
menuHistorySearch := Menu()
menuHistorySearch.Add(o_L["DialogEdit"], HistorySearchEdit)
menuHistorySearch.Icon(o_L["DialogEdit"], o_JLicons.strFileLocation, "16")
menuHistorySearch.Add(o_L["DialogPaste"], HistorySearchEdit)
menuHistorySearch.Icon(o_L["DialogPaste"], o_JLicons.strFileLocation, "74")
return
} ; V1toV2: Added Bracket before label
BuildManageSavedCommandsMenu()
{ ; V1toV2: Added bracket
menuSavedCommands := Menu()
menuSavedCommands.Add(o_L["DialogEdit"], ButtonManageSavedCommandsEdit)
menuSavedCommands.Icon(o_L["DialogEdit"], o_JLicons.strFileLocation, "16")
menuSavedCommands.Add(o_L["DialogExecute"], SavedCommandsExecuteFromManage)
menuSavedCommands.Icon(o_L["DialogExecute"], o_JLicons.strFileLocation, "78")
menuSavedCommands.Add(o_L["DialogDelete"], ButtonManageSavedCommandsDelete)
menuSavedCommands.Icon(o_L["DialogDelete"], o_JLicons.strFileLocation, "8")
return
} ; V1toV2: Added Bracket before label
BuildInspectClipboardMenu()
{ ; V1toV2: Added bracket
menuInspectClipboard := Menu()
menuInspectClipboard.Add(o_L["DialogLoad"], GuiInspectClipboardLoad)
menuInspectClipboard.Icon(o_L["DialogLoad"], o_JLicons.strFileLocation, "16")
return
} ; V1toV2: Added Bracket before label
ShowEditorEditMenu()
{ ; V1toV2: Added bracket
ogc%g_strEditorControlHwnd%.Focus()
menuBarEditorEdit := Menu()
menuBarEditorEdit.Show()
return
} ; V1toV2: Added Bracket before label
EditorEditMenuActions(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
g_blnCopyOrCutFromEditor := (A_ThisMenuItem = g_aaEditL["DialogCut"] . "`t(Ctrl+X)" or A_ThisMenuItem = g_aaEditL["DialogCopy"] . "`t(Ctrl+C)")
if (A_ThisMenuItem = g_aaEditL["DialogCut"] . "`t(Ctrl+X)")
Edit_Cut(g_strEditorControlHwnd)
else if (A_ThisMenuItem = g_aaEditL["DialogCopy"] . "`t(Ctrl+C)")
Edit_Copy(g_strEditorControlHwnd)
else if (A_ThisMenuItem = g_aaEditL["DialogPaste"] . "`t(Ctrl+V)")
Edit_Paste(g_strEditorControlHwnd)
else if (A_ThisMenuItem = g_aaEditL["DialogDelete"] . "`t(Del)")
Edit_Clear(g_strEditorControlHwnd)
else if (A_ThisMenuItem = g_aaEditL["DialogSelectAll"] . "`t(Ctrl+A)")
Edit_SelectAll(g_strEditorControlHwnd)
return
} ; V1toV2: Added bracket before function
BuildEditorMenuBar()
{ ; V1toV2: Added bracket
aaL := o_L.InsertAmpersand("MenuFileCopyAsHTML", "MenuFileCopyAsRTF", "MenuFileCopyAsFiles", "MenuFileCopyAsFilesCut")
menuBarEditorFileCopyAs := Menu()
menuBarEditorFileCopyAs.Add(aaL["MenuFileCopyAsHTML"], EditorCopyToClipboard)
menuBarEditorFileCopyAs.Add(aaL["MenuFileCopyAsRTF"], EditorCopyToClipboard)
menuBarEditorFileCopyAs.Add()
menuBarEditorFileCopyAs.Add(aaL["MenuFileCopyAsFiles"], EditorCopyToClipboard)
menuBarEditorFileCopyAs.Add(aaL["MenuFileCopyAsFilesCut"], EditorCopyToClipboard)
aaL := o_L.InsertAmpersand("MenuFileGetClipboardText", "MenuFileGetClipboardHTML", "MenuFileGetClipboardRTF", "MenuFileGetClipboardFiles")
menuBarEditorFileGetClipboardFor Add := Menu()
menuBarEditorFileGetClipboardFor Add.aaL["MenuFileGetClipboardText"]("EditorGetClipboardText")
menuBarEditorFileGetClipboardFor Add.)
menuBarEditorFileGetClipboardFor Add.aaL["MenuFileGetClipboardHTML"]("EditorGetClipboardHTML")
menuBarEditorFileGetClipboardFor Add.aaL["MenuFileGetClipboardRTF"]("EditorGetClipboardRTF")
menuBarEditorFileGetClipboardFor Add.)
menuBarEditorFileGetClipboardFor Add.aaL["MenuFileGetClipboardFiles"]("EditorGetClipboardFiles")
aaL := o_L.InsertAmpersand("TypeFileOpen", "MenuFileSave", "TypeFileClipboardBackup", "TypeFileClipboardRestore")
menuBarEditorFileOperations := Menu()
menuBarEditorFileOperations.Add(aaL["MenuFileSave"] . "`t(Ctrl+E)", GuiEditorSubString)
menuBarEditorFileOperations.Add(aaL["TypeFileOpen"] . "`t(Ctrl+O)", GuiEditorSubString)
menuBarEditorFileOperations.Add()
menuBarEditorFileOperations.Add(aaL["TypeFileClipboardBackup"], GuiEditorSubString)
menuBarEditorFileOperations.Add(aaL["TypeFileClipboardRestore"], GuiEditorSubString)
g_aaFileL := o_L.InsertAmpersand("GuiClosePasteClipboardMenu", "GuiCopyClipboardMenu", "MenuCancelEditor", "MenuCloseEditor", "MenuFileLoadTextFile", "MenuFileCopyAs", "MenuFileGetClipboardFor", "GuiInspectClipboardTitle", "MenuOpenWorkingDirectory", "MenuShowHistoryMenu", "MenuHistorySearch", "MenuFlushHistoryDb", "MenuFile", "MenuDebugInfo", "MenuReload@" . g_strAppNameText, "MenuExitApp@" . g_strAppNameText)
menuBarEditorClipboard := Menu()
menuBarEditorClipboard.Add(g_aaFileL["GuiCopyClipboardMenu"] . "`t(Ctrl+S.Length)", !_012_GUI_HOTKEYS)
menuBarEditorClipboard.Add(g_aaFileL["GuiClosePasteClipboardMenu"] "`t(". new Triggers.HotkeyParts(o_PopupHotkeys.SA[3]._strAhkHotkey).Hotkey2Text(true) . ")", PasteFromQCEHotkey)
menuBarEditorClipboard.Add(g_aaFileL["MenuCancelEditor"], EditorEscape)
menuBarEditorClipboard.Disable(g_aaFileL["MenuCancelEditor"])
menuBarEditorClipboard.Add(g_aaFileL["MenuCloseEditor"] . "`t(Esc)", EditorEscape)
menuBarEditorClipboard.Add()
menuBarEditorClipboard.Add(g_aaFileL["MenuShowHistoryMenu"]"`t(". new Triggers.HotkeyParts(o_PopupHotkeys.SA[5]._strAhkHotkey).Hotkey2Text(true) . ")", menuHistoryFile)
menuBarEditorClipboard.Add(g_aaFileL["MenuHistorySearch"] . "`t(Ctrl+P)", BuildGuiHistorySearch)
menuBarEditorClipboard.Add(g_aaFileL["MenuFlushHistoryDb"], HistoryFlush)
menuBarEditorClipboard.Add()
menuBarEditorClipboard.Add(g_aaFileL["GuiInspectClipboardTitle"], GuiInspectClipboard)
menuBarEditorClipboard.Add(g_aaFileL["MenuFileCopyAs"], menuBarEditorFileCopyAs)
menuBarEditorClipboard.Add(g_aaFileL["MenuFileGetClipboardFor"], menuBarEditorFileGetClipboardFor)
menuBarEditorClipboard.Add()
menuBarEditorClipboard.Add(g_aaFileL["MenuFile"], menuBarEditorFileOperations)
menuBarEditorClipboard.Add()
menuBarEditorClipboard.Add(g_aaFileL["MenuOpenWorkingDirectory"], !_070_TRAY_MENU_ACTIONS)
if FileExist("C:\Dropbox\AutoHotkey\QuickClipboardEditor\QuickClipboardEditor-HOME.ini")
{
menuBarEditorClipboard.Add()
menuBarEditorClipboard.Add(g_aaFileL["MenuDebugInfo"], DebugInfo)
}
menuBarEditorClipboard.Add()
menuBarEditorClipboard.Add(L(g_aaFileL["MenuReload@" . g_strAppNameText], g_strAppNameText), EditorEscape)
menuBarEditorClipboard.Add(L(g_aaFileL["MenuExitApp@" . g_strAppNameText] . "`t(Alt+F4)", g_strAppNameText), "EditorCloseAndExitApp")
aaL := o_L.InsertAmpersand("EditManageSavedCommands")
menuBarEditorSavedCommands := Menu()
menuBarEditorSavedCommands.Add(aaL["EditManageSavedCommands"] . "`t(Ctrl+M)", GuiManageSavedCommands)
g_aaEditL := o_L.InsertAmpersand("DialogUndo", "DialogRedo", "DialogCut", "DialogCopy", "DialogPaste", "DialogDelete", "DialogSelectAll", "DialogMoveLineUp", "DialogMoveLineDown", "EditInsertString", "EditSubString", "EditFilterLines", "EditFilterCharacters", "TypeReformatPara", "EditManageSavedCommands")
menuBarEditorEdit.Add(g_aaEditL["DialogUndo"] . "`t(Ctrl+Z)", GuiEditorUndo)
menuBarEditorEdit.Add(g_aaEditL["DialogRedo"] . "`t(Ctrl+Y)", GuiEditorUndo)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["DialogCut"] . "`t(Ctrl+X)", EditorEditMenuActions)
menuBarEditorEdit.Add(g_aaEditL["DialogCopy"] . "`t(Ctrl+C)", EditorEditMenuActions)
menuBarEditorEdit.Add(g_aaEditL["DialogPaste"] . "`t(Ctrl+V)", EditorEditMenuActions)
menuBarEditorEdit.Add(g_aaEditL["DialogDelete"] . "`t(Del)", EditorEditMenuActions)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["DialogSelectAll"] . "`t(Ctrl+A)", EditorEditMenuActions)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["DialogMoveLineUp"] . "`t(Shift+Ctrl+Up)", GuiEditorMoveLineUp)
menuBarEditorEdit.Add(g_aaEditL["DialogMoveLineDown"] . "`t(Shift+Ctrl+Down)", GuiEditorMoveLineUp)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["EditInsertString"] . "`t(Ctrl+I)", GuiEditorSubString)
menuBarEditorEdit.Add(g_aaEditL["EditSubString"] . "`t(Ctrl+B)", GuiEditorSubString)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["EditFilterLines"] . "`t(Ctrl+L)", GuiEditorSubString)
menuBarEditorEdit.Add(g_aaEditL["EditFilterCharacters"] . "`t(Ctrl+D)", GuiEditorSubString)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["TypeReformatPara"] . "`t(Ctrl+R)", GuiEditorSubString)
menuBarEditorEdit.Add()
menuBarEditorEdit.Add(g_aaEditL["EditManageSavedCommands"] . "`t(Ctrl+M)", GuiManageSavedCommands)
aaL := o_L.InsertAmpersand("EditFind", "EditFindNext", "EditFindPrevious", "EditFindReplace")
menuBarEditorFindReplace := Menu()
menuBarEditorFindReplace.Add(aaL["EditFind"] . "`t(Ctrl+F)", GuiEditorSubString)
menuBarEditorFindReplace.Add(aaL["EditFindNext"] . "`t(F3)", GuiEditorFindNext)
menuBarEditorFindReplace.Add(aaL["EditFindPrevious"] . "`t(Shift+F3)", GuiEditorFindPrevious)
menuBarEditorFindReplace.Add()
menuBarEditorFindReplace.Add(aaL["EditFindReplace"] . "`t(Ctrl+H)", GuiEditorSubString)
aaL := o_L.InsertAmpersand("MenuSortQuick", "MenuSortOptions", "MenuSortAgain")
menuBarEditorSort := Menu()
menuBarEditorSort.Add(aaL["MenuSortQuick"] . "`t(Ctrl+Q)", GuiEditorSortQuick)
menuBarEditorSort.Add(aaL["MenuSortOptions"] . "`t(Ctrl+T)", GuiEditorSubString)
menuBarEditorSort.Add(aaL["MenuSortAgain"] . "`t(Shift+Ctrl+T)", GuiEditorSortAgain)
aaL := o_L.InsertAmpersand("DialogCaseLower", "DialogCaseUpper", "DialogCaseTitle", "DialogCaseSentence", "DialogCaseToggle", "DialogCaseSaRcAsM")
menuBarEditorCase := Menu()
menuBarEditorCase.Add(aaL["DialogCaseLower"] . "`t(Ctrl+Alt+L)", ChangeCaseLower)
menuBarEditorCase.Add(aaL["DialogCaseUpper"] . "`t(Ctrl+Alt+U)", ChangeCaseLower)
menuBarEditorCase.Add(aaL["DialogCaseTitle"] . "`t(Ctrl+Alt+T)", ChangeCaseLower)
menuBarEditorCase.Add(aaL["DialogCaseSentence"] . "`t(Ctrl+Alt+S.Length)", ChangeCaseLower)
menuBarEditorCase.Add(aaL["DialogCaseToggle"] . "`t(Ctrl+Alt+G)", ChangeCaseLower)
menuBarEditorCase.Add(aaL["DialogCaseSaRcAsM"] . "`t(Ctrl+Alt+A)", ChangeCaseLower)
g_aaConvertBitmapL := o_L.InsertAmpersand("EditClipboardAllBase64Encode", "EditClipboardAllBase64Decode", "EditClipboardImageBase64Encode", "EditClipboardImageBase64Decode")
menuBarEditorConvertBinary := Menu()
menuBarEditorConvertBinary.Add(g_aaConvertBitmapL["EditClipboardAllBase64Encode"], EditURIEncode)
menuBarEditorConvertBinary.Add(g_aaConvertBitmapL["EditClipboardAllBase64Decode"], EditURIEncode)
menuBarEditorConvertBinary.Add()
menuBarEditorConvertBinary.Add(g_aaConvertBitmapL["EditClipboardImageBase64Encode"], EditURIEncode)
menuBarEditorConvertBinary.Add(g_aaConvertBitmapL["EditClipboardImageBase64Decode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditURIEncode", "EditURIDecode")
menuBarEditorConvertUri := Menu()
menuBarEditorConvertUri.Add(aaL["EditURIEncode"], EditURIEncode)
menuBarEditorConvertUri.Add(aaL["EditURIDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditXMLEncode", "EditXMLEncodeNumeric", "EditXMLDecode")
menuBarEditorConvertXml := Menu()
menuBarEditorConvertXml.Add(aaL["EditXMLEncode"], EditURIEncode)
menuBarEditorConvertXml.Add(aaL["EditXMLEncodeNumeric"], EditURIEncode)
menuBarEditorConvertXml.Add()
menuBarEditorConvertXml.Add(aaL["EditXMLDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditHTMLEncode", "EditHTMLDecode")
menuBarEditorConvertHtml := Menu()
menuBarEditorConvertHtml.Add(aaL["EditHTMLEncode"], EditURIEncode)
menuBarEditorConvertHtml.Add(aaL["EditHTMLDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditHexEncode", "EditHexDecode")
menuBarEditorConvertHex := Menu()
menuBarEditorConvertHex.Add(aaL["EditHexEncode"], EditURIEncode)
menuBarEditorConvertHex.Add(aaL["EditHexDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditASCIIEncode", "EditASCIIDecode")
menuBarEditorConvertAscii := Menu()
menuBarEditorConvertAscii.Add(aaL["EditASCIIEncode"], EditURIEncode)
menuBarEditorConvertAscii.Add(aaL["EditASCIIDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditPHPDoubleEncode", "EditPHPDoubleDecode", "EditPHPSingleEncode", "EditPHPSingleDecode")
menuBarEditorConvertPhp := Menu()
menuBarEditorConvertPhp.Add(aaL["EditPHPSingleEncode"], EditURIEncode)
menuBarEditorConvertPhp.Add(aaL["EditPHPSingleDecode"], EditURIEncode)
menuBarEditorConvertPhp.Add()
menuBarEditorConvertPhp.Add(aaL["EditPHPDoubleEncode"], EditURIEncode)
menuBarEditorConvertPhp.Add(aaL["EditPHPDoubleDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("EditAHKEncode", "EditAHKDecode", "EditAHKVarExpression", "EditAHKVarExpressionDecode", "EditAHKVarExpressionEncode")
menuBarEditorConvertAhk := Menu()
menuBarEditorConvertAhk.Add(aaL["EditAHKEncode"], EditURIEncode)
menuBarEditorConvertAhk.Add(aaL["EditAHKDecode"], EditURIEncode)
menuBarEditorConvertAhk.Add()
menuBarEditorConvertAhk.Add(aaL["EditAHKVarExpressionEncode"], EditURIEncode)
menuBarEditorConvertAhk.Add(aaL["EditAHKVarExpressionDecode"], EditURIEncode)
aaL := o_L.InsertAmpersand("MenuBinary", "MenuUrlUri", "MenuXML", "MenuHTML", "MenuHexaDecimal", "MenuASCII", "MenuPHP", "MenuAutoHotkey")
menuBarEditorConvert := Menu()
menuBarEditorConvert.Add(aaL["MenuUrlUri"], menuBarEditorConvertUri)
menuBarEditorConvert.Add(aaL["MenuXML"], menuBarEditorConvertXml)
menuBarEditorConvert.Add(aaL["MenuHTML"], menuBarEditorConvertHtml)
menuBarEditorConvert.Add(aaL["MenuHexaDecimal"], menuBarEditorConvertHex)
menuBarEditorConvert.Add(aaL["MenuASCII"], menuBarEditorConvertAscii)
menuBarEditorConvert.Add(aaL["MenuPHP"], menuBarEditorConvertPhp)
menuBarEditorConvert.Add(aaL["MenuAutoHotkey"], menuBarEditorConvertAhk)
menuBarEditorConvert.Add(aaL["MenuBinary"], menuBarEditorConvertBinary)
g_aaOptionsL := o_L.InsertAmpersand("OptionsLaunch", "OptionsEditorWindow", "OptionsHotkeys", "OptionsClipboardHistory", "OptionsVarious", "MenuSelectEditorHotkeyMouse", "MenuSelectEditorHotkeyKeyboard", "MenuSelectPasteFromQCE", "MenuSelectCopyOpenQCE", "MenuRunAtStartup@" . g_strAppNameText, "MenuDisplayEditorAtStartup@" . g_strAppNameText, "MenuKeepOpenAfterPaste", "MenuCopyToAppend", "MenuEditIniFile@" . o_Settings.strIniFileNameExtOnly)
menuBarEditorOptions := Menu()
menuBarEditorOptions.Add(g_aaOptionsL["OptionsLaunch"], !_022_OPTIONS)
menuBarEditorOptions.Add(g_aaOptionsL["OptionsEditorWindow"], !_022_OPTIONS)
menuBarEditorOptions.Add(g_aaOptionsL["OptionsHotkeys"], !_022_OPTIONS)
menuBarEditorOptions.Add(g_aaOptionsL["OptionsClipboardHistory"], !_022_OPTIONS)
menuBarEditorOptions.Add(g_aaOptionsL["OptionsVarious"], !_022_OPTIONS)
menuBarEditorOptions.Add()
menuBarEditorOptions.Add(g_aaOptionsL["MenuKeepOpenAfterPaste"], ToggleKeepOpenAfterPaste)
menuBarEditorOptions.Add()
menuBarEditorOptions.Add(g_aaOptionsL["MenuCopyToAppend"], ToggleCopyToAppend)
UpdateToggleMenus()
menuBarEditorOptions.Add()
menuBarEditorOptions.Add(g_aaOptionsL["MenuEditIniFile@" . o_Settings.strIniFileNameExtOnly], ShowSettingsIniFile)
aaL := o_L.InsertAmpersand("MenuWebHelp", "MenuWebSite@" . g_strAppNameText, "MenuHotkeysHelp", "MenuDonate", "MenuUpdate", "MenuAbout@" . g_strAppNameText)
menuBarEditorHelp := Menu()
menuBarEditorHelp.Add(aaL["MenuWebHelp"], OpenQCEWebsite)
menuBarEditorHelp.Add(aaL["MenuWebSite@" . g_strAppNameText], OpenQCEWebsite)
menuBarEditorHelp.Add()
menuBarEditorHelp.Add(aaL["MenuHotkeysHelp"] . "`t(F1)", GuiHotkeysHelp)
menuBarEditorHelp.Add()
menuBarEditorHelp.Add(aaL["MenuDonate"], GuiDonate)
menuBarEditorHelp.Add()
menuBarEditorHelp.Add(aaL["MenuUpdate"], Check4Update)
menuBarEditorHelp.Add()
menuBarEditorHelp.Add(aaL["MenuAbout@" . g_strAppNameText], GuiAboutEditor)
aaL := o_L.InsertAmpersand("*C", "DialogSavedCommands", "MenuEditorEdit", "EditFindSlashReplace", "EditSort", "EditChangeCase", "EditConvert", "MenuOptions", "MenuHelp")
menuBarEditorMain := Menu()
menuBarEditorMain.Add("&" . o_L["MenuClipboard"], menuBarEditorClipboard)
menuBarEditorMain.Add(aaL["DialogSavedCommands"], menuBarEditorSavedCommands)
menuBarEditorMain.Add(aaL["MenuEditorEdit"], menuBarEditorEdit)
menuBarEditorMain.Add(aaL["EditFindSlashReplace"], menuBarEditorFindReplace)
menuBarEditorMain.Add(aaL["EditSort"], menuBarEditorSort)
menuBarEditorMain.Add(aaL["EditChangeCase"], menuBarEditorCase)
menuBarEditorMain.Add(aaL["EditConvert"], menuBarEditorConvert)
menuBarEditorMain.Add(aaL["MenuOptions"], menuBarEditorOptions)
menuBarEditorMain.Add(aaL["MenuHelp"], menuBarEditorHelp)
aaL := ""
return
} ; V1toV2: Added Bracket before label
RefreshSavedCommandsMenuAndHotkeys()
{ ; V1toV2: Added bracket
aaL := o_L.InsertAmpersand("EditManageSavedCommands")
menuBarEditorSavedCommands.Add()
menuBarEditorSavedCommands.Delete()
menuBarEditorSavedCommands.Add(aaL["EditManageSavedCommands"] . "`t(Ctrl+M)", GuiManageSavedCommands)
menuBarEditorSavedCommands.Add()
for strCode, oType in g_aaEditCommandTypes
{
menuBarEditorSavedCommands%strCode% := Menu()
menuBarEditorSavedCommands%strCode%.Add()
menuBarEditorSavedCommands%strCode%.Delete()
oCommandsDbTable := GetSavedCommandsTable("Title ASC", strCode, "", true)
blnMenuEmpty := true
while oCommandsDbTable.GetRow(A_Index, saCommandDbRow)
{
menuBarEditorSavedCommands%strCode%.Add(saCommandDbRow[1], SavedCommandsExecuteFromManage)
blnMenuEmpty := false
}
if !(blnMenuEmpty)
menuBarEditorSavedCommands.Add(oType.strTypeLabel, menuBarEditorSavedCommands%strCode%)
}
Hotkey("If WinActiveQCE()")
for strHotkey, strTitle in g_aaSavedCommandsHotkeys
Hotkey(strHotkey, "Off")
g_aaSavedCommandsHotkeys := Object()
oCommandsDbTable := GetSavedCommandsTable("EditDateTime", "", "", false, true)
while oCommandsDbTable.GetRow(A_Index, saCommandDbRow)
{
g_aaSavedCommandsHotkeys[saCommandDbRow[3]] := saCommandDbRow[1]
Hotkey(saCommandDbRow[3], SavedCommandsExecuteFromHotkey, "On UseErrorLevel")
}
HotIf()
aaL := ""
oCommandsDbTable := ""
strCode := ""
oType := ""
strHotkey := ""
strTitle := ""
return
} ; V1toV2: Added Bracket before label
!_020_GUI:
InitEditorControls()
{ ; V1toV2: Added bracket
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_strEditorWordWrapOn",	g_intGuiLeftMargin, 130)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_strEditorWordWrapOff",	g_intGuiLeftMargin, 130)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_btnEditorClosePaste", 0, -62, , true)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_btnEditorCopy", 0, -62, , true)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_btnEditorCancel", 0, -62, , true)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_btnEditorClose", 0, -62, , true)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_btnHistoryPrev", g_intGuiLeftMargin, -62, , true)
InsertGuiControlPos(g_saEditorControls, g_aaEditorControlsByName, "f_btnHistoryNext", -34, -62, , true)
return
} ; V1toV2: Added bracket before function
InsertGuiControlPos(saControls, aaControls, strControlName, intX, intY, blnCenter := false, blnDraw := false)
{
aaGuiControl := Object()
aaGuiControl.Name := strControlName
aaGuiControl.X := intX
aaGuiControl.Y := intY
aaGuiControl.Center := blnCenter
aaGuiControl.Draw := blnDraw
saControls.Push(aaGuiControl)
aaControls[strControlName] := aaGuiControl
}
BuildGuiEditor()
{ ; V1toV2: Added bracket
intEditorMinHeight := 136 + (g_intFontSizeCurrent / 72 * A_ScreenDPI)
SetTrayMenuIcon()
Editor.New("+Hwndg_intEditorHwnd +Resize +MinSize" . g_intEditorDefaultWidth . "x" . intEditorMinHeight, L(o_L["GuiTitleEditor"], g_strAppNameText, ))
.OnEvent("Change", _strAppVersion.Bind("Change"))
Editor.MenuBar := menuBarEditorMain
ogcCheckboxf_blnFixedFontCurrent := Editor.Add("Checkbox", "x" . g_intGuiLeftMargin . " y" . g_intGuiTopMargin . " vf_blnFixedFontCurrent gClipboardEditorFontChanged ". ( = 1 ? "checked" : ""), o_L["DialogFixedFont"])
ogcCheckboxf_blnFixedFontCurrent.OnEvent("Click", _blnFixedFontCurrent.Bind("Normal"))
ogcTextf_lblFontSize := Editor.Add("Text", "x+5 yp vf_lblFontSize", o_L["DialogFontSize"])
ogcEditf_intFontSizeCurrent := Editor.Add("Edit", "x+5 yp-3 w40 vf_intFontSizeCurrent")
ogcEditf_intFontSizeCurrent.OnEvent("Change", ClipboardEditorFontChanged.Bind("Change"))
ogcf_intFontUpDown := Editor.Add("UpDown", "Range6-36 vf_intFontUpDown", g_intFontSizeCurrent)
ogcCheckboxf_blnAlwaysOnTopCurrent := Editor.Add("Checkbox", "x+15 yp+3 vf_blnAlwaysOnTopCurrent gClipboardEditorAlwaysOnTopCurrentChanged " . ( = 1 ? "checked" : ""), o_L["DialogAlwaysOnTop"])
ogcCheckboxf_blnAlwaysOnTopCurrent.OnEvent("Click", _blnAlwaysOnTopCurrent.Bind("Normal"))
ClipboardEditorAlwaysOnTopCurrentChanged()
ogcCheckboxf_blnWordWrapCurrent := Editor.Add("Checkbox", "x+5 yp vf_blnWordWrapCurrent gClipboardEditorWrapChanged " . ( = 1 ? "checked" : ""), o_L["DialogWordWrap"])
ogcCheckboxf_blnWordWrapCurrent.OnEvent("Click", _blnWordWrapCurrent.Bind("Normal"))
ogcCheckboxf_blnSeeInvisible := Editor.Add("Checkbox", "x+5 yp vf_blnSeeInvisible  disabled", o_L["DialogSeeInvisible"])
ogcCheckboxf_blnSeeInvisible.OnEvent("Click", ClipboardEditorSeeInvisibleChanged.Bind("Normal"))
ogcCheckboxf_blnSeeInvisible.GetPos(&arrControlPosX, &arrControlPosY, &arrControlPosW, &arrControlPosH)
g_saEditorControls[1].Y := arrControlPosY + 25
g_saEditorControls[2].Y := arrControlPosY + 25
ogcf_strEditorWordWrapOn := Editor.Add("Edit", "x" . g_intGuiLeftMargin . " y+10 w600 vf_strEditorWordWrapOn  Multi t20 WantReturn +Wrap +0x100")
ogcf_strEditorWordWrapOn.OnEvent("Change", EditorContentChanged.Bind("Change"))
g_strEditorControlHwndWrapOn := ogcf_strEditorWordWrapOn.hwnd

ogcf_strEditorWordWrapOff := Editor.Add("Edit", "x" . g_intGuiLeftMargin . " yp w600 vf_strEditorWordWrapOff  Multi t20 WantReturn -Wrap +0x100000 +0x100")
ogcf_strEditorWordWrapOff.OnEvent("Change", EditorContentChanged.Bind("Change"))
g_strEditorControlHwndWrapOff := ogcf_strEditorWordWrapOff.hwnd

g_strEditorControlHwnd := (g_blnWordWrapCurrent ? g_strEditorControlHwndWrapOn : g_strEditorControlHwndWrapOff)
ClipboardEditorWrapChanged()
aaL := o_L.InsertAmpersand("GuiClosePasteButton", "GuiCopyButton", "GuiCancel", "GuiClose")
Editor.SetFont("S[8] Bold", "Verdana")
ogcButtonf_btnEditorClosePaste := Editor.Add("Button", "vf_btnEditorClosePaste  x1 " . (blnDittoConfigured ? "yp" : "y+10") . " h30", aaL["GuiClosePasteButton"])
ogcButtonf_btnEditorClosePaste.OnEvent("Click", PasteFromQCEHotkey.Bind("Normal"))
g_strClosePasteButtonHwnd := ogcButtonf_btnEditorClosePaste.hwnd
g_aaToolTipsMessages["Button5"] := o_L["ToolTipButtonPaste"]
ogcButtonf_btnEditorCopy := Editor.Add("Button", "vf_btnEditorCopy  x2 yp h30 disabled", aaL["GuiCopyButton"])
ogcButtonf_btnEditorCopy.OnEvent("Click", EditorCopyToClipboard.Bind("Normal"))
g_strSaveButtonHwnd := ogcButtonf_btnEditorCopy.hwnd
g_aaToolTipsMessages["Button6"] := o_L["ToolTipButtonSave"]
ogcButtonf_btnEditorCancel := Editor.Add("Button", "vf_btnEditorCancel  Disabled x3 yp h30", aaL["GuiCancel"])
ogcButtonf_btnEditorCancel.OnEvent("Click", EditorEscape.Bind("Normal"))
g_strCancelButtonHwnd := ogcButtonf_btnEditorCancel.hwnd
g_aaToolTipsMessages["Button7"] := o_L["ToolTipButtonCancel"]
ogcButtonf_btnEditorClose := Editor.Add("Button", "vf_btnEditorClose  x4 yp h30", aaL["GuiClose"])
ogcButtonf_btnEditorClose.OnEvent("Click", EditorEscape.Bind("Normal"))
g_strCloseButtonHwnd := ogcButtonf_btnEditorClose.hwnd
;to be implemented
;to be implemented
;to be implemented
;to be implemented
g_aaToolTipsMessages["Button8"] := o_L["ToolTipButtonClose"]
Editor.SetFont()
if !(g_blnDbHistoryDisabled)
{
Editor.SetFont("S[10]", "Arial")
ogcButtonf_btnHistoryPrev := Editor.Add("Button", "y+10 vf_btnHistoryPrev", chr(0x25C4))
ogcButtonf_btnHistoryPrev.OnEvent("Click", LoadHistoryPrev.Bind("Normal"))
g_strHistoryPrevButtonHwnd := ogcButtonf_btnHistoryPrev.hwnd
g_aaToolTipsMessages["Button9"] := o_L["ToolTipButtonHistoryPrev"]
ogcButtonf_btnHistoryNext := Editor.Add("Button", "yp vf_btnHistoryNext  Disabled", chr(0x25BA))
ogcButtonf_btnHistoryNext.OnEvent("Click", LoadHistoryPrev.Bind("Normal"))
g_strHistoryNextButtonHwnd := ogcButtonf_btnHistoryNext.hwnd
g_aaToolTipsMessages["Button10"] := o_L["ToolTipButtonHistoryNext"]
;to be implemented
;to be implemented
Editor.SetFont()
}
if (o_Settings.EditorWindow.blnDarkMode.IniValue and !g_blnLightMode)
{
Editor.BackColor := o_Settings.EditorWindow.strDarkBgColorGui.IniValue
CtlColors.Attach(g_strEditorControlHwndWrapOn, o_Settings.EditorWindow.strDarkBgColorReadOnly.IniValue, o_Settings.EditorWindow.strDarkTextColorEdit.IniValue)
CtlColors.Attach(g_strEditorControlHwndWrapOff, o_Settings.EditorWindow.strDarkBgColorReadOnly.IniValue, o_Settings.EditorWindow.strDarkTextColorEdit.IniValue)
ClipboardEditorEditControlColors()
SB := Editor.Add("StatusBar", " -Theme Background" . o_Settings.EditorWindow.strDarkBgColorGui.IniValue)
SB.OnEvent("Click", GuiStatusBarClicked.Bind("Normal"))
Loop Parse, "g_strHistoryPrevButtonHwnd|g_strSaveButtonHwnd|g_strCancelButtonHwnd|g_strCloseButtonHwnd|g_strClosePasteButtonHwnd|g_strHistoryNextButtonHwnd", "|"
DllCall("uxtheme\SetWindowTheme", "ptr", %A_LoopField%, "str", "DarkMode_Explorer", "ptr", 0)
if (A_OSVersion >= "10.0.17763" and SubStr(A_OSVersion, 1, 3) = "10.")
{
intAttr := 19
if (A_OSVersion >= "10.0.18985")
{
intAttr := 20
}
DllCall("dwmapi\DwmSetWindowAttribute", "ptr", g_intEditorHwnd, "int", intAttr, "int*", &true, "int", 4)
DllCall("uxtheme\SetWindowTheme", "ptr", g_strEditorControlHwndWrapOn, "str", "DarkMode_Explorer", "ptr", 0)
DllCall("uxtheme\SetWindowTheme", "ptr", g_strEditorControlHwndWrapOff, "str", "DarkMode_Explorer", "ptr", 0)
}
}
else
SB := Editor.Add("StatusBar")
SB.OnEvent("Click", GuiStatusBarClicked.Bind("Normal"))
g_aaToolTipsMessages["msctls_statusbar321"] := o_L["ToolTipStatusBar"]
SB.SetParts(200, 260, 100)
GetSavedGuiWindowPosition(saEditorPosition)
Editor.Show("Hide ". (saEditorPosition[1] = -1 or saEditorPosition[1] = "" or saEditorPosition[2] = "")
? "center w" . g_intEditorDefaultWidth . " h" . g_intEditorDefaultHeight
: "x" . saEditorPosition[1] . " y" . saEditorPosition[2] . "h" . saEditorPosition[3] . " h" . saEditorPosition[4])
Sleep(100)
if (saEditorPosition[1] <> -1)
{
WinMove(ahk_id %g_intEditorHwnd%)
if (saEditorPosition[5] = "M")
{
WinMaximize("ahk_id " g_intEditorHwnd)
WinHide("ahk_id " g_intEditorHwnd)
}
}
saEditorPosition := ""
strTextColor := ""
strHwnd := ""
intAttr := ""
intEditorMinHeight := ""
aaL := ""
return
} ; V1toV2: Added Bracket before label
_000_EDITOR:
return
EditorContentChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Diag(A_ThisLabel, "Start", "")
Sleep(200)
UpdateEditorButtonsStatus()
SetStatusBarText(1, A_ThisLabel)
if (o_Settings.EditorWindow.blnDarkMode.IniValue and !g_blnLightMode and !Edit_GetTextLength(g_strEditorControlHwnd))
{
Send("!{Tab}")
Sleep(100)
Send("!{Tab}")
}
Diag(A_ThisLabel, "Out", "")
return
} ; V1toV2: Added bracket before function
ClipboardEditorAlwaysOnTopCurrentChanged()
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
WinSetAlwaysOnTop((f_blnAlwaysOnTopCurrent ? "On" : "Off"), "ahk_id " g_intEditorHwnd)
g_blnAlwaysOnTopCurrent := f_blnAlwaysOnTopCurrent
return
} ; V1toV2: Added Bracket before label
ClipboardEditorWrapChanged()
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
g_strEditorControlHwnd := (f_blnWordWrapCurrent ? g_strEditorControlHwndWrapOn : g_strEditorControlHwndWrapOff)
g_blnWordWrapCurrent := f_blnWordWrapCurrent
strHwndSource := (g_strEditorControlHwnd = g_strEditorControlHwndWrapOn ? g_strEditorControlHwndWrapOff : g_strEditorControlHwndWrapOn)
strHwndDest := (g_strEditorControlHwnd = g_strEditorControlHwndWrapOn ? g_strEditorControlHwndWrapOn : g_strEditorControlHwndWrapOff)
blnModify := Edit_GetModify(strHwndSource)
Edit_SetModify(strHwndDest, blnModify)
Edit_GetSel(strHwndSource, intStartSelPos, intEndSelPos)
Edit_SetText(strHwndDest, Edit_GetText(strHwndSource))
Edit_SetText(strHwndSource, "")
Edit_SetSel(g_strEditorControlHwnd, intStartSelPos, intStartSelPos)
Edit_ScrollCaret(g_strEditorControlHwnd)
if (intStartSelPos <> intEndSelPos)
{
Edit_SetSel(g_strEditorControlHwnd, intStartSelPos, intEndSelPos)
intFirstVisibleLine := Edit_GetFirstVisibleLine(g_strEditorControlHwnd)
intLastVisibleLine := Edit_GetLastVisibleLine(g_strEditorControlHwnd)
intFirstSelectedLine := Edit_LineFromChar(g_strEditorControlHwnd, intStartSelPos)
intLastSelectedLine := Edit_LineFromChar(g_strEditorControlHwnd, intEndSelPos)
if (intLastSelectedLine > intLastVisibleLine)
if (intLastSelectedLine - intLastVisibleLine < intFirstSelectedLine - intFirstVisibleLine)
Edit_LineScroll(g_strEditorControlHwnd, 0, (intLastVisibleLine - intLastSelectedLine) * -1)
else
Edit_LineScroll(g_strEditorControlHwnd, 0, (intFirstVisibleLine - intFirstSelectedLine) * -1)
}
ogc%strHwndSource%.Visible := false
ogc%strHwndDest%.Visible := true
ClipboardEditorFontChanged()
ogc%strHwndDest%.Focus()
strHwndSource := ""
strHwndDest := ""
return
} ; V1toV2: Added bracket before function
ClipboardEditorSeeInvisibleChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
g_blnSeeInvisible := f_blnSeeInvisible


strText := Edit_GetText(g_strEditorControlHwnd)
Edit_SetText(g_strEditorControlHwnd, (g_blnSeeInvisible ? ConvertInvisible(strText) : Convert2CrLf(A_Clipboard)))
ClipboardEditorEditControlColors()
SetStatusBarText(1, A_ThisLabel)
strText := ""
return
} ; V1toV2: Added bracket before function
ClipboardContentChanged(intClipboardContentType)
{
Sleep(o_Settings.History.intHistorySyncDelay.IniValue)
Critical("On")
g_intClipboardContentType := intClipboardContentType
g_blnClipboardIsBitmap := ClipboardIsBitmap()
g_blnExcelActive := WinActive("ahk_class XLMAIN")
try
{
if (g_blnExcelActive)
FoolGUI(true)
g_strClipboardCrLf := WinClipGetTextOrFiles()
g_strClipboardCrLf := Convert2CrLf(g_strClipboardCrLf)
if (g_blnExcelActive)
FoolGUI(false)
}
catch
{
if (g_blnExcelActive)
FoolGUI(false)
}
AddToHistory(g_strClipboardCrLf)
if (EditorVisible()
and ((g_strClipboardCrLfPrevious == Edit_GetText(g_strEditorControlHwnd)
or (g_blnCopyToAppendCurrent and intClipboardContentType = 1))
or (IsReadOnly() and intClipboardContentType = 1)))
{
if !(g_blnCopyOrCutFromEditor
or g_blnFromCopyToClipboard
or g_blnCommandInProgress)
{
UpdateEditorWithClipboard()
}
}
g_strClipboardCrLfPrevious := g_strClipboardCrLf
UpdateEditorButtonsStatus()
SetStatusBarText(1, A_ThisFunc)
g_blnExcelActive := false
Critical("Off")
}
ClipboardEditorFontChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
g_blnFixedFontCurrent := f_blnFixedFontCurrent
g_intFontSizeCurrent := f_intFontSizeCurrent
Editor.SetFont("S.Length" . g_intFontSizeCurrent, ( ? "Courier New" : "Segoe UI"))
.OnEvent("Change", _blnFixedFontCurrent.Bind("Change"))
;to be implemented
;to be implemented
Editor.SetFont()
intErrorLevel := ""
intTries := 0
return
} ; V1toV2: Added bracket before function
GuiEditorMoveLineUp(ThisHotkey)
{ ; V1toV2: Added bracket
GuiEditorMoveLineDown(ThisHotkey)
{ ; V1toV2: Added bracket
if (g_blnWordWrapCurrent)
{
Oops("Editor", o_L["OopsMoveLineNoWordWrap"])
return
}
Edit_GetSel(g_strEditorControlHwnd, intStartSelPos, intEndSelPos)
ogc%g_strEditorControlHwnd%.Options("-Redraw")
Edit_BlockMove(g_strEditorControlHwnd, (A_ThisLabel = "GuiEditorMoveLineUp" ? "Up" : "Down"))
ogc%g_strEditorControlHwnd%.Options("+Redraw")
if (intStartSelPos = intEndSelPos)
{
intSelLine := Edit_LineFromChar(g_strEditorControlHwnd, Edit_GetSel(g_strEditorControlHwnd))
Edit_SetSel(g_strEditorControlHwnd, Edit_LineIndex(g_strEditorControlHwnd), Edit_LineIndex(g_strEditorControlHwnd, intSelLine + 1) - 2)
}
Edit_ScrollCaret(g_strEditorControlHwnd)
intStartSelPos := ""
intEndSelPos := ""
return
} ; V1toV2: Added Bracket before label
GuiEditorMouseWheelDown(ThisHotkey)
{ ; V1toV2: Added bracket
GuiEditorMouseWheelUp(ThisHotkey)
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
ogcf_intFontUpDown.Value := g_intFontSizeCurrent + (A_ThisLabel = "GuiEditorMouseWheelUp" ? 1 : -1)
return
} ; V1toV2: Added Bracket before label
ClipboardEditorEditControlColors()
{ ; V1toV2: Added bracket
if (o_Settings.EditorWindow.blnDarkMode.IniValue and !g_blnLightMode)
{
strEditBackgroundColor := (IsReadOnly() ? o_Settings.EditorWindow.strDarkBgColorReadOnly.IniValue : o_Settings.EditorWindow.strDarkBgColorEdit.IniValue)
strEditTextColor := (IsReadOnly() ? o_Settings.EditorWindow.strDarkTextColorReadOnly.IniValue : o_Settings.EditorWindow.strDarkTextColorEdit.IniValue)
CtlColors.Change(g_strEditorControlHwndWrapOn, strEditBackgroundColor, strEditTextColor)
CtlColors.Change(g_strEditorControlHwndWrapOff, strEditBackgroundColor, strEditTextColor)
}
strEditBackgroundColor := ""
strEditTextColor := ""
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
EditorCopyToClipboard()
{ ; V1toV2: Added bracket
EditorCopyToClipboardAsHTML:
EditorCopyToClipboardAsRTF:
EditorCopyToClipboardAsFiles:
EditorCopyToClipboardAsFilesCut:
HistoryCopyToClipboard()
{ ; V1toV2: Added bracket
Diag(A_ThisLabel, "Start", "")
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
if !ClipboardIsFree(A_ThisLabel)
{
Oops(2, o_L["OopsClipboardIsBusy"])
return
}
strEditorCopyToClipboard := Edit_GetText(g_strEditorControlHwnd)
if InStr(A_ThisLabel, "EditorCopyToClipboardAsFiles")
Loop Parse, strEditorCopyToClipboard, "`n", "`r"
if StrLen(A_LoopField)
if !FileExist(A_LoopField)
{
Oops(2, o_L["OopsCopyToClipboardAsFiles"], A_LoopField)
strClipboardAsFiles := ""
return
}
else
strClipboardAsFiles  .= A_LoopField . "`n"
if ClipboardIsFree(A_ThisLabel)
{
g_blnFromCopyToClipboard := true
WinClip.Clear()
if InStr(A_ThisLabel, "EditorCopyToClipboard")
{
if (A_ThisLabel = "EditorCopyToClipboardAsHTML")
WinClip.SetHTML(strEditorCopyToClipboard)
else if (A_ThisLabel = "EditorCopyToClipboardAsRTF")
WinClip.SetRTF(strEditorCopyToClipboard)
else if InStr(A_ThisLabel, "EditorCopyToClipboardAsFiles")
WinClip.SetFiles(strClipboardAsFiles , (A_ThisLabel = "EditorCopyToClipboardAsFilesCut"))
if (A_ThisLabel = "EditorCopyToClipboard")
or ClipboardIsFree(A_ThisLabel . 2)
WinClip.SetText(strEditorCopyToClipboard)
}
else
WinClip.SetText(HistoryGetItemFromID(g_intHistorySearchClickedRow))
Sleep(200)
g_blnFromCopyToClipboard := false
}
if (A_ThisLabel <> "HistoryCopyToClipboard")
g_intHistoryPosition := 1
UpdateEditorButtonsStatus()
SetStatusBarText(1, A_ThisLabel)
Diag(A_ThisLabel, "Out", "")
strEditorCopyToClipboard := ""
strClipboardAsFiles := ""
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
EditorGetClipboardText()
{ ; V1toV2: Added bracket
EditorGetClipboardHTML()
{ ; V1toV2: Added bracket
EditorGetClipboardRTF()
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
EditorGetClipboardFiles()
{ ; V1toV2: Added bracket
if EditorUnSaved() and !DialogConfirmCancel()
return
strClipboardData := (A_ThisLabel = "EditorGetClipboardText" ? WinClip.GetText()
: (A_ThisLabel = "EditorGetClipboardHTML" ? WinClip.GetHTML()
: (A_ThisLabel = "EditorGetClipboardRTF" ? WinClip.GetRTF()
: Convert2CrLf(WinClip.GetFiles()))))
if !StrLen(strClipboardData)
{
Oops(1, o_L["GuiGetClipboardEmpty"])
return
}
Edit_SetText(g_strEditorControlHwnd, (g_blnSeeInvisible ? ConvertInvisible(strClipboardData) : strClipboardData))
ogc%g_strEditorControlHwnd%.Focus()
AddToUndoPile()
UpdateEditorButtonsStatus()
SetStatusBarText(1, A_ThisLabel)
strClipboardData := ""
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
EditorGuiSize(thisGui, MinMax, A_GuiWidth, A_GuiHeight)
{ ; V1toV2: Added bracket
if (A_EventInfo = 1)
return
Editor.Default()
intEditorH := A_GuiHeight - (g_saEditorControls[1].Y + 72)
g_intEditorW := A_GuiWidth - 16
intButtonSpacing := (A_GuiWidth - 40 - 40 - (140 + 120 + 120 + 120)) // 5
for intIndex, aaGuiControl in g_saEditorControls
{
intX := aaGuiControl.X
intY := aaGuiControl.Y
if (intX < 0)
intX := A_GuiWidth + intX
if (intY < 0)
intY := A_GuiHeight + intY
if (aaGuiControl.Center)
{
ogc%aaGuiControl%.Name.GetPos(&arrPosX, &arrPosY, &arrPosW, &arrPosH)
intX := intX - (arrPosW // 2)
}

}
GuiCenterButtons(g_intEditorHwnd, true, 5, 0, 15, , , "f_btnEditorClosePaste", "f_btnEditorCopy", "f_btnEditorCancel", "f_btnEditorClose")
ogcf_strEditorWordWrapOn.Move(, , g_intEditorW, intEditorH)
ogcf_strEditorWordWrapOff.Move(, , g_intEditorW, intEditorH)
intListH := ""
intButtonSpacing := ""
intIndex := ""
aaGuiControl := ""
intX := ""
intY := ""
arrPos := ""
return
} ; V1toV2: Added Bracket before label
ShowGui2AndDisableGuiEditor()
{ ; V1toV2: Added bracket
CalculateTopGuiPosition(g_strGui2Hwnd, g_intEditorHwnd, intX, intY)
oGui2 := Gui()
oGui2.OnEvent("Close", _2GuiClose)
oGui2.OnEvent("Escape", _2GuiClose)
oGui2.Show("AutoSize x" . intX . " y" . intY)
if (g_blnAlwaysOnTopCurrent)
WinSetAlwaysOnTop(1, "ahk_id " g_strGui2Hwnd)
Editor.Opt("+Disabled")
intX := ""
intY := ""
return
} ; V1toV2: Added bracket before function
LoadHistoryPrev(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
LoadHistoryNext:
LoadHistoryFromMenu:
LoadHistoryFromButtonMenu:
LoadHistoryFromHotkeyMenu:
LoadHistoryFromSearch()
{ ; V1toV2: Added bracket
Diag(A_ThisLabel, "Start", "")
if !IsLastHistory() and EditorUnSaved() and !DialogConfirmCancel()
return
if InStr(A_ThisLabel, "Menu")
{
g_intHistoryPosition := A_ThisMenuItemPos - (A_ThisLabel = "LoadHistoryFromButtonMenu" or A_ThisLabel = "LoadHistoryFromHotkeyMenu" ? 2 : 0)
g_strLastHistoryClip := HistoryGetItem(g_intHistoryPosition)
}
else if (A_ThisLabel = "LoadHistoryFromSearch")
{
g_strLastHistoryClip := HistoryGetItemFromID(g_intHistorySearchClickedRow)
g_intHistoryPosition := HistoryGetPosition(g_strLastHistoryClip)
}
else
{
g_intHistoryPosition := g_intHistoryPosition + (A_ThisLabel = "LoadHistoryPrev" ? 1 : (g_intHistoryPosition > 1 ? -1 : 0))
g_strLastHistoryClip := HistoryGetItem(g_intHistoryPosition)
}
Edit_SetText(g_strEditorControlHwnd, (g_blnSeeInvisible ? ConvertInvisible(g_strLastHistoryClip) : g_strLastHistoryClip))
AddToUndoPile()
UpdateEditorButtonsStatus()
SetStatusBarText(1, A_ThisLabel)
if WinActiveQCE()
{
ogc%g_strEditorControlHwnd%.Focus()
ToolTip(g_intHistoryPosition, , , 2)
SetTimer(RemoveToolTip2,500)
}
else if (A_ThisLabel = "LoadHistoryFromHotkeyMenu")
PasteFromHistoryHotkey()
strDbSQL := ""
saDbRow := ""
Diag(A_ThisLabel, "Out", "")
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiHotkeysHelp(ThisHotkey)
{ ; V1toV2: Added bracket
Editor.Opt("+OwnDialogs")
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
strGuiTitle := o_L["GuiHotkeysHelp"]
oGui2.New("+Hwndg_strGui2Hwnd", strGuiTitle)
if (g_blnUseColors)
oGui2.BackColor := g_strGuiWindowColor
oGui2.Opt("+OwnerEditor")
ogcf_lvHotkeysList := oGui2.Add("ListView", "vf_lvHotkeysList Count32 LV0x10 w500 h710", [o_L["DialogHotkeysHelpHeader"]])
Loop Parse, "MenuSelectEditorHotkeyMouse`tTrigger1|MenuSelectEditorHotkeyKeyboard`tTrigger2|MenuSelectPasteFromQCE`tTrigger3|MenuSelectCopyOpenQCE`tTrigger4|MenuSelectOpenHistoryMenu`tTrigger5|GuiCopyClipboardMenu`tCtrl+S.Length|GuiClose`tEsc|TypeFileOpen`tCtrl+O|TypeFileSave`tCtrl+E|MenuHistorySearch`tCtrl+P|MenuExitApp@g_strAppNameText`tAlt+F4|EditManageSavedCommands`tCtrl+M|DialogUndo`tCtrl+Z|DialogRedo`tCtrl+Y|DialogCut`tCtrl+X|DialogCopy`tCtrl+C|DialogPaste`tCtrl+V|DialogDelete`tDel|DialogSelectAll`tCtrl+A|DialogMoveLineUp`tCtrl+Shift+Up|DialogMoveLineDown`tCtrl+Shift+Down|EditInsertString`tCtrl+I|EditSubString`tCtrl+B|EditFilterLines`tCtrl+L|EditFilterCharacters`tCtrl+D|EditFind`tCtrl+F|EditFindNext`tF3|EditFindPrevious`tShift+F3|EditFindReplace`tCtrl+H|EditReformatPara`tCtrl+R|MenuSortQuick`tCtrl+Q|MenuSortOptions`tCtrl+T|MenuSortAgain`tShift+Ctrl+T|DialogCaseLower`tCtrl+Alt+L|DialogCaseUpper`tCtrl+Alt+U|DialogCaseTitle`tCtrl+Alt+T|DialogCaseSentence`tCtrl+Alt+S.Length|DialogCaseToggle`tCtrl+Alt+G|DialogCaseSaRcAsM`tCtrl+Alt+A|GuiHotkeysHelp`tF1", "|"
{
saLine := StrSplit(A_LoopField, "`t")
strShortcut := saLine[2]
if InStr(saLine[1], "@")
{
saItem := StrSplit(saLine[1], "@")
strVar := saItem[2]
strCommandText := L(o_L[saItem[1]], %strVar%)
}
else
strCommandText := o_L[saLine[1]]
if InStr(strShortcut, "Trigger")
{
intTriggerIndex := StrReplace(strShortcut, "Trigger")
strCommandText := o_PopupHotkeys.SA[intTriggerIndex].AA.strPopupHotkeyLocalizedName
strShortcut := new Triggers.HotkeyParts(o_PopupHotkeys.SA[intTriggerIndex]._strAhkHotkey).Hotkey2Text(true)
}
ogcf_lvHotkeysList.Add("", strShortcut, strCommandText)
}
ogcf_lvHotkeysList.ModifyCol(1, "100 Right")
ogcf_lvHotkeysList.ModifyCol(2, "Auto")
ogcButtonf_btnHotkeysHelpClose := oGui2.Add("Button", "x10 y+10  vf_btnHotkeysHelpClose", o_L["GuiClose"])
ogcButtonf_btnHotkeysHelpClose.OnEvent("Click", _2GuiClose.Bind("Normal"))
GuiCenterButtons(g_strGui2Hwnd, , , , , , , "f_btnHotkeysHelpClose")
ogcButtonf_btnHotkeysHelpClose.Focus()
ShowGui2AndDisableGuiEditor()
strGuiTitle := ""
intTriggerIndex := ""
return
} ; V1toV2: Added Bracket before label
GuiInspectClipboard(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
oGui2.New("+Hwndg_strGui2Hwnd", o_L["GuiInspectClipboardTitle"])
oGui2.Opt("+OwnerEditor")
oGui2.Opt("+OwnDialogs")
ogcf_lvInspectClipboardList := oGui2.Add("ListView", "x10 y+5 w640 Count100 -LV0x10 -Multi r20 vf_lvInspectClipboardList AltSubmit ", [o_L["GuiInsectClipboardHeader"]])
ogcf_lvInspectClipboardList.OnEvent("DoubleClick", GuiInspectClipboardListEvents.Bind("DoubleClick"))
ogcf_lvInspectClipboardList.ModifyCol(1, "Integer")
ogcf_lvInspectClipboardList.ModifyCol(2, "Integer")
ogcf_lvInspectClipboardList.ModifyCol(4, "Integer")
oGui2.Add("Link", , "<a href=`"https://A_Clipboard.quickaccesspopup.com/A_Clipboard-formats-help/`">" . o_L["GuiInsectClipboardFormatsHelp"] . "</a>")
oGui2.Add("Link", "yp x+10", "<a href=`"https://A_Clipboard.quickaccesspopup.com/A_Clipboard-locale-help/`">" . o_L["GuiInsectClipboardLocaleHelp"] . "</a>")
aaL := o_L.InsertAmpersand("DialogRefresh", "DialogLoad", "GuiClose")
ogcButtonf_btnRefresh := oGui2.Add("Button", "y+20 vf_btnRefresh", aaL["DialogRefresh"])
ogcButtonf_btnRefresh.OnEvent("Click", GuiInspectClipboardRefresh.Bind("Normal"))
ogcButtonf_btnLoad := oGui2.Add("Button", "yp vf_btnLoad disabled", aaL["DialogLoad"])
ogcButtonf_btnLoad.OnEvent("Click", GuiInspectClipboardLoad.Bind("Normal"))
ogcButtonf_btnClose := oGui2.Add("Button", "yp vf_btnClose", aaL["GuiClose"])
ogcButtonf_btnClose.OnEvent("Click", _2GuiClose.Bind("Normal"))
oGui2.Add("Text")
GuiCenterButtons(g_strGui2Hwnd, , , , , , , "f_btnRefresh", "f_btnLoad", "f_btnClose")
o_Formats := WinClip.GetFormats()
for intFormat, oItem in o_Formats
{
strBuffer := GetClipboardBuffer(oItem)
strBuffer := ConvertInvisible(SubStr(strBuffer, 1, 80) . (StrLen(strBuffer) > 80 ? g_strEllipse : ""))
ogcf_lvInspectClipboardList.Add("", intFormat, StrReplace(Format("{1:#X}", intFormat), "0X", "0x"), oItem.Name, oItem.Size[0], strBuffer)
}
Loop 5
ogcf_lvInspectClipboardList.ModifyCol(A_Index, "AutoHdr")
oGui2.Add("Text")
oGui2.Show()
if (g_blnAlwaysOnTopCurrent)
WinSetAlwaysOnTop(1, "ahk_id " g_strGui2Hwnd)
strBuffer := ""
aaL := ""
return
} ; V1toV2: Added bracket before function
GetClipboardBuffer(oFormat)
{
if (oFormat.Name = "CF_UNICODETEXT")
strBuffer := oFormat.Buffer
else if (oFormat.Name = "CF_HDROP")
strBuffer := oFormat.Buffer . g_strEllipse
else if (oFormat.Name = "CF_LOCALE")
strBuffer := Ord(oFormat.Buffer)
else if (oFormat.Name = "HTML Format")
strBuffer := WinClip.GetHTML()
else if (oFormat.Name = "Rich Text Format")
strBuffer := WinClip.GetRTF()
else if (oFormat.Name = "msSourceUrl")
strBuffer := oFormat.Buffer
else
strBuffer := ""
return strBuffer
}
GuiInspectClipboardRefresh(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
2GuiClose()
GuiInspectClipboard()
return
} ; V1toV2: Added bracket before function
GuiInspectClipboardListEvents(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
if InStr("Normal|I|", A_GuiEvent . "|")
{
strFormat := ogcf_lvInspectClipboardList.GetText(A_EventInfo)

}
else if (A_GuiEvent = "RightClick")
menuInspectClipboard.Show()
else if (A_GuiEvent = "DoubleClick")
GuiInspectClipboardLoad()
strFormat := ""
return
} ; V1toV2: Added bracket before function
GuiInspectClipboardLoad(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
strFormatName := ogcf_lvInspectClipboardList.GetText(ogcf_lvInspectClipboardList.GetNext())
if InStr("|CF_UNICODETEXT|msSourceUrl|", "|" . strFormatName . "|")
EditorGetClipboardText()
else if (strFormatName = "CF_HDROP")
EditorGetClipboardFiles()
else if (strFormatName = "HTML Format")
EditorGetClipboardHTML()
else if (strFormatName = "Rich Text Format")
EditorGetClipboardRTF()
else
MsgBox(o_L["GuiInspectClipboardNotLoaded"], g_strAppNameText, 0)
if InStr("|CF_UNICODETEXT|msSourceUrl|CF_HDROP|HTML Format|Rich Text Format|", "|" . strFormatName . "|")
2GuiClose()
strFormatName := ""
return
} ; V1toV2: Added Bracket before label
!_022_OPTIONS:
GuiOptionsGroupLaunch:
GuiOptionsGroupEditorWindow:
GuiOptionsGroupHotkeys:
GuiOptionsGroupHistory:
GuiOptionsGroupVarious:
g_strSettingsGroup := StrReplace(A_ThisLabel, "GuiOptionsGroup")
CheckShowEditor()
aaL := o_L.InsertAmpersand("OptionsLaunch", "OptionsEditorWindow", "OptionsHotkeys", "OptionsClipboardHistory", "OptionsVarious", "DialogSave", "GuiCancel")
GuiOptionsHeader()
ogcCheckBoxf_blnLaunchAtStartup := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnLaunchAtStartup  hidden", L(o_L["OptionsLaunchAtStartup"], g_starAppNameText))
ogcCheckBoxf_blnLaunchAtStartup.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
if (g_blnPortableMode)
ogcCheckBoxf_blnLaunchAtStartup.Value := (FileExist(A_Startup . "\" . g_strAppNameFile . ".lnk") ? 1 : 0)
else
ogcCheckBoxf_blnLaunchAtStartup.Value := (RegistryExist("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", g_strAppNameText) ? 1 : 0)
ogcCheckBoxf_blnDisplayTrayTip := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnDisplayTrayTip  hidden", o_L["OptionsDisplayTrayTip"])
ogcCheckBoxf_blnDisplayTrayTip.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnDisplayTrayTip.Value := (o_Settings.Launch.blnDisplayTrayTip.IniValue = true)
ogcf_blnCheck4Update := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnCheck4Update  hidden", o_L["OptionsCheck4Update"])
ogcf_blnCheck4Update.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcf_blnCheck4Update.Value := (o_Settings.Launch.blnCheck4Update.IniValue = true)
ogcLinkf_lnkCheck4Update := oGui2.Add("Link", "yp x+1  vf_lnkCheck4Update hidden", "(<a>" . o_L["OptionsCheck4UpdateNow"] . "</a>)")
ogcLinkf_lnkCheck4Update.OnEvent("Click", Check4Update.Bind("Normal"))
ogcTextf_lblBackupFolder := oGui2.Add("Text", "y+20 x" .  . " w105 vf_lblBackupFolder hidden", o_L["OptionsBackupFolder"] . ":")
ogcTextf_lblBackupFolder.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_strBackupFolder := oGui2.Add("Edit", "yp x" .  . " w300 h20 vf_strBackupFolder hidden")
ogcEditf_strBackupFolder.OnEvent("Change", _intGroupItemsTab3X.Bind("Change"))
ogcButtonf_btnBackupFolder := oGui2.Add("Button", "x+5 yp w100  vf_btnBackupFolder hidden", o_L["DialogBrowseButton"])
ogcButtonf_btnBackupFolder.OnEvent("Click", ButtonBackupFolder.Bind("Normal"))
ogcEditf_strBackupFolder.Value := o_Settings.Launch.strBackupFolder.IniValue
ogcEditf_strBackupFolder.Options("+gGuiOptionsGroupChanged")
ogcTextf_lblQCETempFolderParentPath := oGui2.Add("Text", "y+20 x" .  . " w105 vf_lblQCETempFolderParentPath hidden", o_L["OptionsQCETempFolder"] . ":")
ogcTextf_lblQCETempFolderParentPath.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_strQCETempFolderParentPath := oGui2.Add("Edit", "yp x" .  . " w300 h20 vf_strQCETempFolderParentPath hidden")
ogcEditf_strQCETempFolderParentPath.OnEvent("Change", _intGroupItemsTab3X.Bind("Change"))
ogcButtonf_btnQCETempFolderParentPath := oGui2.Add("Button", "x+5 yp w100  vf_btnQCETempFolderParentPath hidden", o_L["DialogBrowseButton"])
ogcButtonf_btnQCETempFolderParentPath.OnEvent("Click", ButtonBackupFolder.Bind("Normal"))
ogcEditf_strQCETempFolderParentPath.Value := o_Settings.Launch.strQCETempFolderParent.IniValue
ogcEditf_strQCETempFolderParentPath.Options("+gGuiOptionsGroupChanged")
ogcButtonf_btnQCETempFolderParentPath.GetPos(&arrPosX, &arrPosY, &arrPosW, &arrPosH)
if ((arrPosY + arrPosH) > g_intOptionsFooterY)
g_intOptionsFooterY := arrPosY + arrPosH
ogcCheckBoxf_blnDisplayEditorAtStartup := oGui2.Add("CheckBox", "y" . intGroupItemsY . " x" . g_intGroupItemsX . " vf_blnDisplayEditorAtStartup  hidden", o_L["OptionsEditorAtStartup"])
ogcCheckBoxf_blnDisplayEditorAtStartup.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnDisplayEditorAtStartup.Value := (o_Settings.EditorWindow.blnDisplayEditorAtStartup.IniValue = true)
ogcCheckBoxf_blnRememberEditorPosition := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnRememberEditorPosition  hidden", o_L["OptionsRememberEditorPosition"])
ogcCheckBoxf_blnRememberEditorPosition.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnRememberEditorPosition.Value := (o_Settings.EditorWindow.blnRememberEditorPosition.IniValue = true)
if GetOSVersionInfo().BuildNumber >= 18362
{
ogcCheckBoxf_blnDarkMode := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnDarkMode  hidden", o_L["OptionsDarkMode"])
ogcCheckBoxf_blnDarkMode.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnDarkMode.Value := (o_Settings.EditorWindow.blnDarkMode.IniValue = true)
}
ogcCheckBoxf_blnAsciiHexa := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnAsciiHexa  hidden", o_L["OptionsAsciiHexa"])
ogcCheckBoxf_blnAsciiHexa.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnAsciiHexa.Value := (o_Settings.EditorWindow.blnAsciiHexa.IniValue = true)
oGui2.SetFont("S[8] Bold")
ogcTextf_lblStartupDefault := oGui2.Add("Text", "y+20 x" .  . " w105 vf_lblStartupDefault hidden", o_L["OptionsStartupDefault"])
ogcTextf_lblStartupDefault.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
oGui2.SetFont()
ogcCheckBoxf_blnFixedFontDefault := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnFixedFontDefault  hidden", o_L["DialogFixedFont"])
ogcCheckBoxf_blnFixedFontDefault.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnFixedFontDefault.Value := (o_Settings.EditorWindow.blnFixedFontDefault.IniValue = true)
ogcTextf_lblFontSizeDefault := oGui2.Add("Text", "x" .  . " y+10 vf_lblFontSizeDefault hidden", o_L["DialogFontSize"])
ogcTextf_lblFontSizeDefault.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intFontSizeDefault := oGui2.Add("Edit", "x+5 yp-3 w40 vf_intFontSizeDefault hidden")
ogcf_intFontUpDownDefault := oGui2.Add("UpDown", "Range6-36 vf_intFontUpDownDefault hidden", o_Settings.EditorWindow.intFontSizeDefault.IniValue)
ogcEditf_intFontSizeDefault.Value := (o_Settings.EditorWindow.intFontSizeDefault.IniValue)
ogcEditf_intFontSizeDefault.Options("+gGuiOptionsGroupChanged")
ogcCheckBoxf_blnAlwaysOnTopDefault := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnAlwaysOnTopDefault  hidden", o_L["DialogAlwaysOnTop"])
ogcCheckBoxf_blnAlwaysOnTopDefault.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnAlwaysOnTopDefault.Value := (o_Settings.EditorWindow.blnAlwaysOnTopDefault.IniValue = true)
ogcCheckBoxf_blnWordWrapDefault := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnWordWrapDefault  hidden", o_L["DialogWordWrap"])
ogcCheckBoxf_blnWordWrapDefault.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnWordWrapDefault.Value := (o_Settings.EditorWindow.blnWordWrapDefault.IniValue = true)
ogcCheckBoxf_blnUseTab := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnUseTab  hidden", o_L["DialogUseTab"])
ogcCheckBoxf_blnUseTab.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnUseTab.Value := (o_Settings.EditorWindow.blnUseTab.IniValue = true)
ogcCheckBoxf_blnKeepOpenAfterPasteDefault := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnKeepOpenAfterPasteDefault  hidden", o_L["MenuKeepOpenAfterPaste"])
ogcCheckBoxf_blnKeepOpenAfterPasteDefault.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnKeepOpenAfterPasteDefault.Value := (o_Settings.EditorWindow.blnKeepOpenAfterPasteDefault.IniValue = true)
ogcCheckBoxf_blnCopyToAppendDefault := oGui2.Add("CheckBox", "y+10 x" . g_intGroupItemsX . " vf_blnCopyToAppendDefault  hidden", o_L["MenuCopyToAppend"])
ogcCheckBoxf_blnCopyToAppendDefault.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnCopyToAppendDefault.Value := (o_Settings.EditorWindow.blnCopyToAppendDefault.IniValue = true)
ogcCheckBoxf_blnCopyToAppendDefault.GetPos(&arrPosX, &arrPosY, &arrPosW, &arrPosH)
if ((arrPosY + arrPosH) > g_intOptionsFooterY)
g_intOptionsFooterY := arrPosY + arrPosH
o_PopupHotkeys.BackupPopupHotkeys()
ogcTextf_lblChangeShortcutTitle := oGui2.Add("Text", "y" . intGroupItemsY . " x" .  . " w590 center hidden vf_lblChangeShortcutTitle", L(o_L["OptionsHotkeysIntro"], g_strAppNameText))
ogcTextf_lblChangeShortcutTitle.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
for intThisIndex, objThisPopupHotkey in o_PopupHotkeys.SA
{
oGui2.SetFont("S[8] w700")
ogcTextf_lblChangeShortcut := oGui2.Add("Text", "x" .  . " y+20 w610 hidden vf_lblChangeShortcut" . intThisIndex, objThisPopupHotkey.AA.strPopupHotkeyLocalizedName)
ogcTextf_lblChangeShortcut.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
oGui2.SetFont("S[9] w500", "Courier New")
ogcf_lblHotkeyText := oGui2.Add("Text", "Section x" . g_intGroupItemsX + 260 . " y+5 w280 h23 center 0x1000 vf_lblHotkeyText" . intThisIndex . " " . intThisIndex . " hidden", objThisPopupHotkey.AA.strPopupHotkeyTextShort)
ogcf_lblHotkeyText.OnEvent("Click", ButtonOptionsChangeShortcut.Bind("Normal"))
oGui2.SetFont()
ogcButtonf_btnChangeShortcut := oGui2.Add("Button", "yp x" . g_intGroupItemsTab7X . " vf_btnChangeShortcut" . intThisIndex . " " . intThisIndex . " hidden", o_L["OptionsChangeHotkey"])
ogcButtonf_btnChangeShortcut.OnEvent("Click", ButtonOptionsChangeShortcut.Bind("Normal"))
oGui2.SetFont("S[8] w500")
ogcTextf_lnkChangeShortcut := oGui2.Add("Text", "x" .  . " ys w240 hidden vf_lnkChangeShortcut" . intThisIndex, objThisPopupHotkey.AA.strPopupHotkeyLocalizedDescription)
ogcTextf_lnkChangeShortcut.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
}
intThisIndex := ""
objThisPopupHotkey := ""
ogcf_lblHotkeyText5.GetPos(&arrPosX, &arrPosY, &arrPosW, &arrPosH)
if ((arrPosY + arrPosH) > g_intOptionsFooterY)
g_intOptionsFooterY := arrPosY + arrPosH
ogcCheckBoxf_blnHistoryEnabled := oGui2.Add("CheckBox", "y" . intGroupItemsY . " x" . g_intGroupItemsX . " vf_blnHistoryEnabled  hidden", o_L["OptionsClipboardHistoryEnable"])
ogcCheckBoxf_blnHistoryEnabled.OnEvent("Click", GuiOptionsGroupChanged.Bind("Normal"))
ogcCheckBoxf_blnHistoryEnabled.Value := (o_Settings.History.blnHistoryEnabled.IniValue = true)
ogcTextf_lblHistoryDbMaximumSize := oGui2.Add("Text", "x" .  . " y+15 vf_lblHistoryDbMaximumSize hidden w190", o_L["OptionsHistoryDbMaximumSize"])
ogcTextf_lblHistoryDbMaximumSize.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intHistoryDbMaximumSize := oGui2.Add("Edit", "x+10 yp h20 w40 vf_intHistoryDbMaximumSize  number center hidden", o_Settings.History.intHistoryDbMaximumSize.IniValue)
ogcEditf_intHistoryDbMaximumSize.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcButtonf_btnHistoryDbFlush := oGui2.Add("Button", "x+20 yp-2 vf_btnHistoryDbFlush  hidden", o_L["OptionsHistoryDbFlushDatabase"])
ogcButtonf_btnHistoryDbFlush.OnEvent("Click", HistoryFlush.Bind("Normal"))
ogcTextf_lblHistorySyncDelay := oGui2.Add("Text", "x" .  . " y+4 vf_lblHistorySyncDelay hidden w190", o_L["OptionsHistorySyncDelay"])
ogcTextf_lblHistorySyncDelay.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intHistorySyncDelay := oGui2.Add("Edit", "x+10 yp h20 w40 vf_intHistorySyncDelay  number center hidden", o_Settings.History.intHistorySyncDelay.IniValue)
ogcEditf_intHistorySyncDelay.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
oGui2.SetFont("Bold")
ogcTextf_lblHistoryMenus := oGui2.Add("Text", "x" .  . " y+20 vf_lblHistoryMenus hidden", o_L["OptionsHistoryMenus"])
ogcTextf_lblHistoryMenus.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcTextf_lblHistorySearch := oGui2.Add("Text", "x" .  . " yp vf_lblHistorySearch hidden", o_L["OptionsHistorySearch"])
ogcTextf_lblHistorySearch.OnEvent("Click", _intGroupItemsTab5X.Bind("Normal"))
oGui2.SetFont()
ogcTextf_lblHistoryMenuCharsWidth := oGui2.Add("Text", "x" .  . " y+10 vf_lblHistoryMenuCharsWidth hidden w160", o_L["OptionsHistoryMenuCharsWidth"])
ogcTextf_lblHistoryMenuCharsWidth.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intHistoryMenuCharsWidth := oGui2.Add("Edit", "x+15 yp h20 w40 vf_intHistoryMenuCharsWidth  number center hidden", o_Settings.History.intHistoryMenuCharsWidth.IniValue)
ogcEditf_intHistoryMenuCharsWidth.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblHistorySearchCharsWidth := oGui2.Add("Text", "x" .  . " yp vf_lblHistorySearchCharsWidth hidden w160", o_L["OptionsHistoryMenuCharsWidth"])
ogcTextf_lblHistorySearchCharsWidth.OnEvent("Click", _intGroupItemsTab5X.Bind("Normal"))
ogcEditf_intHistorySearchCharsWidth := oGui2.Add("Edit", "x+15 yp h20 w40 vf_intHistorySearchCharsWidth  number center hidden", o_Settings.History.intHistorySearchCharsWidth.IniValue)
ogcEditf_intHistorySearchCharsWidth.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblHistoryMenuRows := oGui2.Add("Text", "x" .  . " y+5 vf_lblHistoryMenuRows hidden w160", o_L["OptionsHistoryMenuRows"])
ogcTextf_lblHistoryMenuRows.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intHistoryMenuRows := oGui2.Add("Edit", "x+15 yp h20 w40 vf_intHistoryMenuRows  number center hidden", o_Settings.History.intHistoryMenuRows.IniValue)
ogcEditf_intHistoryMenuRows.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblHistorySearchRows := oGui2.Add("Text", "x" .  . " yp vf_lblHistorySearchRows hidden w160", o_L["OptionsHistoryMenuRows"])
ogcTextf_lblHistorySearchRows.OnEvent("Click", _intGroupItemsTab5X.Bind("Normal"))
ogcEditf_intHistorySearchRows := oGui2.Add("Edit", "x+15 yp h20 w40 vf_intHistorySearchRows  number center hidden", o_Settings.History.intHistorySearchRows.IniValue)
ogcEditf_intHistorySearchRows.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblHistoryMenuIconSize := oGui2.Add("Text", "x" .  . " y+5 vf_lblHistoryMenuIconSize hidden w160", o_L["OptionsHistoryMenuIconSize"])
ogcTextf_lblHistoryMenuIconSize.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intHistoryMenuIconSize := oGui2.Add("Edit", "x+15 yp h20 w40 vf_intHistoryMenuIconSize  number center hidden", o_Settings.History.intHistoryMenuIconSize.IniValue)
ogcEditf_intHistoryMenuIconSize.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblHistorySearchQueryRows := oGui2.Add("Text", "x" .  . " yp vf_lblHistorySearchQueryRows hidden w160", o_L["OptionsHistorySearchQueryRows"])
ogcTextf_lblHistorySearchQueryRows.OnEvent("Click", _intGroupItemsTab5X.Bind("Normal"))
ogcEditf_intHistorySearchQueryRows := oGui2.Add("Edit", "x+15 yp h20 w40 vf_intHistorySearchQueryRows  number center hidden", o_Settings.History.intHistorySearchQueryRows.IniValue)
ogcEditf_intHistorySearchQueryRows.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblSavedCommandsLinesInList := oGui2.Add("Text", "y" . intGroupItemsY . " x" .  . " vf_lblSavedCommandsLinesInList hidden w190", o_L["OptionsSavedCommandsLinesInList"])
ogcTextf_lblSavedCommandsLinesInList.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intSavedCommandsLinesInList := oGui2.Add("Edit", "x+10 yp h20 w40 vf_intSavedCommandsLinesInList  number center hidden", o_Settings.Various.intSavedCommandsLinesInList.IniValue)
ogcEditf_intSavedCommandsLinesInList.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblFileEncodingCodePage := oGui2.Add("Text", "y+15 x" .  . " vf_lblFileEncodingCodePage hidden w190", o_L["OptionsFileEncodingCodePage"])
ogcTextf_lblFileEncodingCodePage.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_intFileEncodingCodePage := oGui2.Add("Edit", "x+10 yp h20 w40 vf_intFileEncodingCodePage  number center hidden", o_Settings.Various.intFileEncodingCodePage.IniValue)
ogcEditf_intFileEncodingCodePage.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
ogcTextf_lblCopyAppendSeparator := oGui2.Add("Text", "y+15 x" .  . " vf_lblCopyAppendSeparator hidden w190", o_L["OptionsCopyAppendSeparator"])
ogcTextf_lblCopyAppendSeparator.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcEditf_strCopyAppendSeparator := oGui2.Add("Edit", "x+10 yp h20 w200 vf_strCopyAppendSeparator  hidden", o_Settings.Various.strCopyAppendSeparator.IniValue)
ogcEditf_strCopyAppendSeparator.OnEvent("Change", GuiOptionsGroupChanged.Bind("Change"))
strCopyAppendSeparatorHwnd := ogcEditf_strCopyAppendSeparator.hwnd
ogcText := oGui2.Add("Text", "y+5 x" .  . " hidden w190")
ogcText.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
ogcLinkf_lnkCopyAppendSeparator := oGui2.Add("Link", "x+10 yp vf_lnkCopyAppendSeparator  hidden", o_L["DialogEditCommandsInvisibleKeys"])
ogcLinkf_lnkCopyAppendSeparator.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
GuiOptionsFooter()
return
GuiOptionsHeader()
{ ; V1toV2: Added bracket
g_strOptionsGuiTitle := L(o_L["OptionsGuiTitle"], g_strAppNameText, g_strAppVersion)
oGui2.New("+Hwndg_strGui2Hwnd", )
.OnEvent("Change", _strOptionsGuiTitle.Bind("Change"))
oGui2.Opt("+OwnerEditor")
intOptionsButtonsColWidth := 0
for intKey, strGroup in o_Settings.saOptionsGroups
{
ogcButtonf_btnOptionsGroup := oGui2.Add("Button", "x10 y" . (intKey = 1 ? "+15" : "p+22") . "  vf_btnOptionsGroup" . strGroup, aaL[o_Settings.saOptionsGroupsLabelNames[intKey]])
ogcButtonf_btnOptionsGroup.OnEvent("Click", GuiOptionsGroupButtonClicked.Bind("Normal"))
ogc "f_btnOptionsGroup" . strGroup.GetPos(&arrPosX, &arrPosY, &arrPosW, &arrPosH)
if (arrPosW > intOptionsButtonsColWidth)
intOptionsButtonsColWidth := arrPosW
}
g_intOptionsFooterY := arrPosY + arrPosH
for intKey, strGroup in o_Settings.saOptionsGroups
ogc "f_btnOptionsGroup" . strGroup.Move(, , intOptionsButtonsColWidth)
g_intGroupItemsX := intOptionsButtonsColWidth + 30
g_intGroupItemsTab1X := g_intGroupItemsX + 10
g_intGroupItemsTab2X := g_intGroupItemsX + 20
g_intGroupItemsTab3X := g_intGroupItemsX + 120
g_intGroupItemsTab3aX := g_intGroupItemsX + 137
g_intGroupItemsTab4X := g_intGroupItemsX + 240
g_intGroupItemsTab5X := g_intGroupItemsX + 250
g_intGroupItemsTab6X := g_intGroupItemsX + 300
g_intGroupItemsTab7X := g_intGroupItemsX + 550
intGroupItemsY := 40
oGui2.SetFont("S[10] Bold", "Verdana")
ogcTextf_lblOptionsGuiTitle := oGui2.Add("Text", "x" .  . " y10 w595 center vf_lblOptionsGuiTitle")
ogcTextf_lblOptionsGuiTitle.OnEvent("Click", _intGroupItemsX.Bind("Normal"))
oGui2.SetFont()
strGroup := ""
arrPos := ""
intOptionsButtonsColWidth := ""
return
} ; V1toV2: Added Bracket before label
GuiOptionsFooter()
{ ; V1toV2: Added bracket
g_intOptionsFooterY += 20
ogcButtonf_btnOptionsSave := oGui2.Add("Button", "x10 y" . g_intOptionsFooterY . " vf_btnOptionsSave  disabled Default", aaL["DialogSave"])
ogcButtonf_btnOptionsSave.OnEvent("Click", GuiOptionsGroupSave.Bind("Normal"))
ogcButtonf_btnOptionsCancel := oGui2.Add("Button", "yp vf_btnOptionsCancel", aaL["GuiCancel"])
ogcButtonf_btnOptionsCancel.OnEvent("Click", ButtonOptionsCancel.Bind("Normal"))
GuiCenterButtons(g_strGui2Hwnd, false, , , , , , , "f_btnOptionsSave", "f_btnOptionsCancel")
oGui2.Add("Text")
ogcButtonf_btnOptionsSave.Focus()
strGotoGroup := g_strSettingsGroup
GuiOptionsGroupButtonClicked()
ShowGui2AndDisableGuiEditor()
g_intGroupItemsX := ""
g_intGroupItemsTab1X := ""
g_intGroupItemsTab2X := ""
g_intGroupItemsTab3X := ""
g_intGroupItemsTab4X := ""
intGroupItemsY := ""
return
} ; V1toV2: Added Bracket before label
GuiOptionsGroupButtonClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GuiOptionsGroupLinkClicked:
if StrLen(A_GuiControl) or StrLen(strGotoGroup)
{
if (A_ThisLabel = "GuiOptionsGroupLinkClicked")
strSettingsGroupPrev := g_strSettingsGroup
else
strSettingsGroupPrev := (StrLen(strGotoGroup) ? "" : g_strSettingsGroup)
g_strSettingsGroup := (StrLen(strGotoGroup) ? strGotoGroup : StrReplace(A_GuiControl, "f_btnOptionsGroup"))
}
ogc "f_btnOptionsGroup" . strSettingsGroupPrev.Options("-Default")
ogc "f_btnOptionsGroup" . g_strSettingsGroup.Options("+Default")
if (strSettingsGroupPrev = g_strSettingsGroup)
return
Loop Parse, strSettingsGroupPrev . "|" . g_strSettingsGroup, "|"
if StrLen(A_LoopField)
for intKey, aaIniValue in o_Settings.aaGroupItems[A_LoopField]
for intControlKey, strGuiControl in StrSplit(aaIniValue.strGuiControls, "|")
if StrLen(strGuiControl)

ToolTip()
ogcTextf_lblOptionsGuiTitle.Value := L(o_L["Options" . g_strSettingsGroup] . " - " . o_L["OptionsGuiTitle"], g_strAppNameText)
strSettingsGroupPrev := ""
strGotoGroup := ""
return
} ; V1toV2: Added bracket before function
ButtonBackupFolder(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
ButtonQCETempFolderParentPath:
oGui2.Opt("+OwnDialogs")
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
if (A_ThisLabel = "ButtonBackupFolder")
{
strControlName := "f_strBackupFolder"
strPrompt := o_L["OptionsSelectBackupFolder"]
}
else if (A_ThisLabel = "ButtonQCETempFolderParentPath")
{
strControlName := "f_strQCETempFolderParentPath"
strPrompt := o_L["OptionsSelectQCETempFolder"]
}
strPreviousFolderExpand := PathCombine(A_WorkingDir, EnvVars(%strControlName%))
strNewFolder := ChooseFolder([g_strGui2Hwnd, strPrompt], strPreviousFolderExpand)
if !(strNewFolder)
return
GuiOptionsGroupChanged()
ogc%strControlName%.Value := strNewFolder
strControlName := ""
strPreviousFolderExpand := ""
strPrompt := ""
return
} ; V1toV2: Added bracket before function
GuiOptionsGroupChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
g_blnGroupChanged := true

return
} ; V1toV2: Added Bracket before label
ButtonOptionsChangeShortcut1:
ButtonOptionsChangeShortcut2:
ButtonOptionsChangeShortcut3:
ButtonOptionsChangeShortcut4:
ButtonOptionsChangeShortcut5:
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
intHotkeyIndex := StrReplace(A_ThisLabel, "ButtonOptionsChangeShortcut")
if InStr(o_PopupHotkeys.SA[intHotkeyIndex].AA.strPopupHotkeyInternalName, "Mouse")
intHotkeyType := 1
else if InStr(o_PopupHotkeys.SA[intHotkeyIndex].AA.strPopupHotkeyInternalName, "Keyboard")
intHotkeyType := 2
else
intHotkeyType := 3
strPopupHotkeysLocalBackup := o_PopupHotkeys.SA[intHotkeyIndex].P_strAhkHotkey
strNewHotkey := SelectShortcut(o_PopupHotkeys.SA[intHotkeyIndex].P_strAhkHotkey, o_PopupHotkeys.SA[intHotkeyIndex].AA.strPopupHotkeyLocalizedName, intHotkeyType, o_PopupHotkeys.SA[intHotkeyIndex].AA.strPopupHotkeyDefault, o_PopupHotkeys.SA[intHotkeyIndex].AA.strPopupHotkeyLocalizedDescription)
o_PopupHotkeys.SA[intHotkeyIndex].P_strAhkHotkey := strNewHotkey
if StrLen(o_PopupHotkeys.SA[intHotkeyIndex].P_strAhkHotkey)
{
ogcf_lblHotkeyText%intHotkeyIndex%.Value := o_PopupHotkeys.SA[intHotkeyIndex].AA.strPopupHotkeyTextShort
GuiOptionsGroupChanged()
}
else
o_PopupHotkeys.SA[intHotkeyIndex].P_strAhkHotkey := strPopupHotkeysLocalBackup
strPopupHotkeysLocalBackup := ""
strNewHotkey := ""
return
GuiOptionsGroupSave(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
oGui2.Opt("+OwnDialogs")
blnOptionsPathsOK := true
strTempFolderNew := (StrLen(f_strQAPTempFolderParentPath) ? PathCombine(A_WorkingDir, EnvVars(f_strQAPTempFolderParentPath)) : A_WorkingDir)
strBackupFolderNew := (StrLen(f_strBackupFolder) ? PathCombine(A_WorkingDir, EnvVars(f_strBackupFolder)) : A_WorkingDir)
o_Settings.Launch.blnLaunchAtStartup.WriteIni(f_blnLaunchAtStartup)
if (g_blnPortableMode)
{
strAppShortcut := A_Startup . "\" . g_strAppNameFile . ".lnk"
if FileExist(strAppShortcut)
FileDelete(strAppShortcut)
if (o_Settings.Launch.blnLaunchAtStartup.IniValue)
FileCreateShortcut(A_ScriptFullPath, strAppShortcut, A_WorkingDir, o_CommandLineParameters.strParams)
}
else
if (o_Settings.Launch.blnLaunchAtStartup.IniValue)
SetRegistry("QuickClipboardEditor.exe", "HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", g_strAppNameText)
else
RemoveRegistry("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run", g_strAppNameText)
o_Settings.Launch.blnDisplayTrayTip.WriteIni(f_blnDisplayTrayTip)
o_Settings.Launch.blnCheck4Update.WriteIni(f_blnCheck4Update)
o_Settings.Launch.strBackupFolder.WriteIni(StrLen(f_strBackupFolder) ? f_strBackupFolder : A_WorkingDir)
o_Settings.Launch.strQCETempFolderParent.WriteIni(StrLen(f_strQCETempFolderParentPath) ? f_strQCETempFolderParentPath : A_WorkingDir)
o_Settings.EditorWindow.blnDisplayEditorAtStartup.WriteIni(f_blnDisplayEditorAtStartup)
o_Settings.EditorWindow.blnRememberEditorPosition.WriteIni(f_blnRememberEditorPosition)
o_Settings.EditorWindow.blnDarkMode.WriteIni(f_blnDarkMode)
o_Settings.EditorWindow.blnAsciiHexa.WriteIni(f_blnAsciiHexa)
o_Settings.EditorWindow.blnUseTab.WriteIni(f_blnUseTab)
o_Settings.EditorWindow.blnAlwaysOnTopDefault.WriteIni(f_blnAlwaysOnTopDefault)
o_Settings.EditorWindow.blnFixedFontDefault.WriteIni(f_blnFixedFontDefault)
o_Settings.EditorWindow.blnKeepOpenAfterPasteDefault.WriteIni(f_blnKeepOpenAfterPasteDefault)
o_Settings.EditorWindow.blnCopyToAppendDefault.WriteIni(f_blnCopyToAppendDefault)
o_Settings.EditorWindow.intFontSizeDefault.WriteIni(f_intFontSizeDefault)
o_Settings.EditorWindow.blnWordWrapDefault.WriteIni(f_blnWordWrapDefault)
for intThisIndex, objThisPopupHotkey in o_PopupHotkeys.SA
o_Settings.Hotkeys["str" . objThisPopupHotkey.AA.strPopupHotkeyInternalName].WriteIni(objThisPopupHotkey.P_strAhkHotkey)
o_PopupHotkeys.EnablePopupHotkeys()
intThisIndex := ""
o_Settings.History.blnHistoryEnabled.WriteIni(f_blnHistoryEnabled)
o_Settings.History.intHistoryDbMaximumSize.WriteIni(f_intHistoryDbMaximumSize)
o_Settings.History.intHistorySyncDelay.WriteIni(f_intHistorySyncDelay)
o_Settings.History.intHistoryMenuCharsWidth.WriteIni(f_intHistoryMenuCharsWidth)
o_Settings.History.intHistoryMenuRows.WriteIni(f_intHistoryMenuRows)
o_Settings.History.intHistoryMenuIconSize.WriteIni(f_intHistoryMenuIconSize)
o_Settings.History.intHistorySearchCharsWidth.WriteIni(f_intHistorySearchCharsWidth)
o_Settings.History.intHistorySearchRows.WriteIni(f_intHistorySearchRows)
o_Settings.History.intHistorySearchQueryRows.WriteIni(f_intHistorySearchQueryRows)
o_Settings.Various.intSavedCommandsLinesInList.WriteIni(f_intSavedCommandsLinesInList)
o_Settings.Various.intFileEncodingCodePage.WriteIni(f_intFileEncodingCodePage)
o_Settings.Various.strCopyAppendSeparator.WriteIni(f_strCopyAppendSeparator)
g_blnGroupChanged := false
2GuiClose()
msgResult := MsgBox(4 + (g_blnAlwaysOnTopCurrent ? 4096 : 0), %g_strAppNameText%,  L(o_L["OptionsReloadPrompt"], g_strAppNameText))
if (msgResult = "Yes")
ReloadQCE()
return
} ; V1toV2: Added Bracket before label
ButtonOptionsCancel(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
2GuiClose()
return
} ; V1toV2: Added Bracket before label
!_025_HISTRORY_SEARCH:
GuiHistorySearchRestorePosition:
IniDelete(o_Settings.strIniFile, "Global", "HistorySearchPosition")
BuildGuiHistorySearch()
return
BuildGuiHistorySearch()
{ ; V1toV2: Added bracket
HistorySearch := Gui()
HistorySearch.OnEvent("Close", HistorySearchGuiClose)
HistorySearch.OnEvent("Escape", HistorySearchGuiClose)
HistorySearch.OnEvent("Size[0]", HistorySearchGuiSize)
HistorySearch.New("+Hwndg_strHistorySearchHwnd +Resize +MinSize250x300", o_L["GuiHistorySearchTitle"])
HistorySearch.Default()
HistorySearch.Opt("+LastFound")
WinSetAlwaysOnTop(1)
HistorySearch.SetFont("S.Length" . strGuiHistorySearchFontFace, strGuiHistorySearchFontFace)
Sleep(10)
ogcEditf_strHistorySearch := HistorySearch.Add("Edit", "x3 y0 w100 vf_strHistorySearch")
ogcEditf_strHistorySearch.OnEvent("Change", GuiHistorySearchChanged.Bind("Change"))
g_strHistorySearchControlHwnd := ogcEditf_strHistorySearch.hwnd
ogcListViewf_lvHistorySearch := HistorySearch.Add("ListView", "x3 w100 r" . o_Settings.History.intHistorySearchRows.IniValue. " yp+20 Count32 NoSortHdr LV0x10 -Hdr -Multi vf_lvHistorySearch AltSubmit ", ["Col1", "Index"])
ogcListViewf_lvHistorySearch.OnEvent("DoubleClick", GuiHistorySearchEvents.Bind("DoubleClick"))
HistorySearch.SetFont()
ogcButtonf_btnHistorySearchEdit := HistorySearch.Add("Button", "vf_btnHistorySearchEdit y+10 Default", o_L["DialogEdit"])
ogcButtonf_btnHistorySearchEdit.OnEvent("Click", GuiHistorySearchEvents.Bind("Normal"))
ogcButtonf_btnHistorySearchPaste := HistorySearch.Add("Button", "vf_btnHistorySearchPaste yp", o_L["DialogPaste"])
ogcButtonf_btnHistorySearchPaste.OnEvent("Click", GuiHistorySearchEvents.Bind("Normal"))
ogcButtonf_btnHistorySearchClose := HistorySearch.Add("Button", "vf_btnHistorySearchClose yp", o_L["GuiClose"])
ogcButtonf_btnHistorySearchClose.OnEvent("Click", GuiHistorySearchEvents.Bind("Normal"))
if (o_Settings.EditorWindow.blnDarkMode.IniValue and !g_blnLightMode)
{
HistorySearch.BackColor := o_Settings.EditorWindow.strDarkBgColorGui.IniValue
CtlColors.Attach(g_strHistorySearchControlHwnd, o_Settings.EditorWindow.strDarkBgColorEdit.IniValue, o_Settings.EditorWindow.strDarkTextColorEdit.IniValue)

HistorySearch.SetFont("c" . o_Settings.EditorWindow.strDarkTextColorEdit.IniValue)
HistorySearch.SetFont("S.Length" . strGuiHistorySearchFontSize, strGuiHistorySearchFontFace)
Sleep(10)
;to be implemented
if (A_OSVersion >= "10.0.17763" and SubStr(A_OSVersion, 1, 3) = "10.")
{
intAttr := 19
if (A_OSVersion >= "10.0.18985")
{
intAttr := 20
}
DllCall("dwmapi\DwmSetWindowAttribute", "ptr", g_strHistorySearchControlHwnd, "int", intAttr, "int*", &true, "int", 4)
DllCall("uxtheme\SetWindowTheme", "ptr", g_strHistorySearchControlHwnd, "str", "DarkMode_Explorer", "ptr", 0)
DllCall("uxtheme\SetWindowTheme", "ptr", g_strHistorySearchControlHwnd, "str", "DarkMode_Explorer", "ptr", 0)
}
}
strHistorySearchPosition := o_Settings.ReadIniValue("HistorySearchPosition", -1)
saHistorySearchPosition := StrSplit(strHistorySearchPosition, "|")
HistorySearch.Show((saHistorySearchPosition[1] = -1 or saHistorySearchPosition[1] = "" or saHistorySearchPosition[2] = "" ? "center ")
: "x" . saHistorySearchPosition[1] . " y" . saHistorySearchPosition[2]) . " w" 250
intHistorySearchGuiMinHeight := ""
strHistorySearchPosition := ""
saHistorySearchPosition := ""
intCharWidth := ""
intCharHeight := ""
return
} ; V1toV2: Added Bracket before label
HistorySearchGuiSize(thisGui, MinMax, A_GuiWidth, A_GuiHeight)
{ ; V1toV2: Added bracket
strGuiHistorySearchFontFace := (g_blnFixedFontCurrent ? "Courier New" : "Segoe UI")
strGuiHistorySearchFontSize := g_intFontSizeCurrent
HistorySearch.SetFont("S.Length" . strGuiHistorySearchFontSize, strGuiHistorySearchFontFace)
;to be implemented
;to be implemented
intFontHeight := GetTextExtentPoint("X", strGuiHistorySearchFontFace, strGuiHistorySearchFontSize).H
intSearchHeight := intFontHeight + 4
intSearchWidth := A_GuiWidth - 6
intListViewHeight := A_GuiHeight - intFontHeight - 36
intListViewWidth := intSearchWidth
intListViewY:= intFontHeight + 6
ogcEditf_strHistorySearch.Move(, , intListViewWidth)
ogcEditf_strHistorySearch.Move(, , , intSearchHeight)
ogcListViewf_lvHistorySearch.Move(, , intListViewWidth)
ogcListViewf_lvHistorySearch.Move(, intListViewY)
ogcListViewf_lvHistorySearch.Move(, , , intListViewHeight)
ogcButtonf_btnHistorySearchEdit.Move(, A_GuiHeight - 25)
ogcButtonf_btnHistorySearchPaste.Move(, A_GuiHeight - 25)
ogcButtonf_btnHistorySearchClose.Move(, A_GuiHeight - 25)
GuiCenterButtons(g_strHistorySearchHwnd, true, 5, 0, 15, , , "f_btnHistorySearchEdit", "f_btnHistorySearchPaste", "f_btnHistorySearchClose")
return
} ; V1toV2: Added Bracket before label
GuiHistorySearchChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := HistorySearch.Submit("0")
f_strHistorySearch := oSaved.f_strHistorySearch
f_lvHistorySearch := oSaved.f_lvHistorySearch
ogcListViewf_lvHistorySearch.Delete()
if StrLen(Trim(f_strHistorySearch))
{
Critical("On")
ogcListViewf_lvHistorySearch.Options("-Redraw")
oHistoryDbTableSearch := SearchHistoryFor("Search", Trim(f_strHistorySearch))
oImageListID := IL_Create(1)
ogcListViewf_lvHistorySearch.SetImageList(oImageListID)
IL_Add(oImageListID, o_JLicons.strFileLocation, 75)
while oHistoryDbTableSearch.GetRow(A_Index, saHistoryDbRow)
{
strClip := ConvertInvisible(saHistoryDbRow[2], true)
strClip := SubStr(strClip, 1, 256) . (StrLen(strClip) > 256 ? g_strEllipse : "")
ogcListViewf_lvHistorySearch.Add("Icon1", strClip, saHistoryDbRow[1])
}
ogcListViewf_lvHistorySearch.ModifyCol(1, "Auto")
ogcListViewf_lvHistorySearch.ModifyCol(2, 0)
if (oHistoryDbTableSearch.RowCount)
ogcListViewf_lvHistorySearch.Modify(1, "Select")
ogcListViewf_lvHistorySearch.Options("+Redraw")
Critical("Off")
}
strClip := ""
oImageListID := ""
oHistoryDbTableSearch := ""
saHistoryDbRow := ""
return
} ; V1toV2: Added Bracket before label
GuiHistorySearchEvents(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
HistorySearchButton:
} ; V1toV2: Added bracket before function
HistorySearchDown(ThisHotkey)
{ ; V1toV2: Added bracket
HistorySearchUp(ThisHotkey)
{ ; V1toV2: Added bracket
HistorySearch.Default()
; strActiveControlV := HistorySearch.FocusedCtrl ; Not really the same, this returns the focused gui control object...
if (A_ThisLabel = "GuiHistorySearchEvents" or A_ThisLabel = "HistorySearchButton")
{
if (A_ThisLabel = "HistorySearchButton")
{
strAction := StrReplace(A_GuiControl, "f_btnHistorySearch")
g_intHistorySearchClickedRow := (ogcListViewf_lvHistorySearch.GetNext() = 0 ? 1 : ogcListViewf_lvHistorySearch.GetNext())
g_intHistorySearchClickedRow := ogcListViewf_lvHistorySearch.GetText((ogcListViewf_lvHistorySearch.GetNext() = 0 ? 1 : ogcListViewf_lvHistorySearch.GetNext()))
}
else if (A_GuiEvent = "DoubleClick" or A_GuiEvent = "RightClick")
{
strAction := "Edit"
g_intHistorySearchClickedRow := ogcListViewf_lvHistorySearch.GetText(A_EventInfo)
}
if StrLen(strAction)
{
if (A_GuiEvent = "RightClick")
menuHistorySearch.Show()
else
if (strAction = "Close")
HistorySearchGuiEscape()
else if (strAction = "Paste")
HistorySearchPaste()
else
HistorySearchEdit()
strAction := ""
}
}
else if (A_ThisLabel = "HistorySearchDown")
if (strActiveControlV = "f_strHistorySearch")
{
ogcListViewf_lvHistorySearch.Focus()
ogcListViewf_lvHistorySearch.Modify(1, "Focus Select")
}
else
Send("{Down}")
else if (A_ThisLabel = "HistorySearchUp")
if (strActiveControlV = "f_lvHistorySearch" and ogcListViewf_lvHistorySearch.GetNext() = 1)
ogcEditf_strHistorySearch.Focus()
else
Send("{Up}")
strActiveControlV := ""
strAction := ""
return
} ; V1toV2: Added Bracket before label
HistorySearchEdit(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
HistorySearchPaste()
{ ; V1toV2: Added bracket
HistorySearchGuiEscape()
if (A_ThisLabel = "HistorySearchEdit")
{
LoadHistoryFromSearch()
Editor.Show()
WinActivate("ahk_id " g_intEditorHwnd)
}
else
{
HistoryCopyToClipboard()
Sleep(300)
PasteFromHistory()
}
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
HistorySearchGuiClose(*)
{ ; V1toV2: Added bracket
HistorySearchGuiEscape()
{ ; V1toV2: Added bracket
SaveWindowPosition("HistorySearchPosition", "ahk_id " . g_strHistorySearchHwnd)
HistorySearch.Destroy()
return
} ; V1toV2: Added Bracket before label
!_030_EDIT_COMMANDS:
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiEditorUndo()
{ ; V1toV2: Added bracket
GuiEditorRedo()
{ ; V1toV2: Added bracket
if IsReadOnly()
return
if (A_ThisLabel = "GuiEditorUndo")
o_UndoPile.UndoFromPile()
else
o_UndoPile.RedoFromPile()
EditorContentChanged()
return
} ; V1toV2: Added Bracket before label
GuiEditorSubString()
{ ; V1toV2: Added bracket
GuiEditorInsertString()
{ ; V1toV2: Added bracket
GuiEditorFilterLines()
{ ; V1toV2: Added bracket
GuiEditorFilterCharacters()
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiEditorSortOptions()
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiEditorFind()
{ ; V1toV2: Added bracket
GuiEditorFindReplace()
{ ; V1toV2: Added bracket
GuiEditorFileOpen()
{ ; V1toV2: Added bracket
GuiEditorFileSave()
{ ; V1toV2: Added bracket
GuiEditorFileClipboardBackup()
{ ; V1toV2: Added bracket
GuiEditorFileClipboardRestore()
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiEditorReformatPara()
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
strEditCommandType := StrReplace(A_ThisLabel, "GuiEditor")
if IsReadOnly() and !InStr("Find|FileOpen|FileSave|", strEditCommandType . "|")
return
g_blnCommandInProgress := true
aaLastCommand := (IsObject(g_aaEditCommandTypes[strEditCommandType].aaLastEditCommand) ? g_aaEditCommandTypes[strEditCommandType].aaLastEditCommand
: Object())
strGuiTitle := L(o_L["DialogAddEditCommandTitle"], g_aaEditCommandTypes[strEditCommandType].strTypeLabel, g_strAppNameText, g_strAppVersion)
oGui2.New("+Resize -MaximizeBox -MinimizeBox +Hwndg_strGui2Hwnd", strGuiTitle)
oGui2.Opt("+OwnerEditor")
oGui2.Opt("+OwnDialogs")
oGui2.SetFont("w600")
oGui2.Add("Text", "y+10 w400", g_aaEditCommandTypes[strEditCommandType].strTypeLabel)
oGui2.SetFont()
oGui2.Add("Link", "y+2 w400", g_aaEditCommandTypes[strEditCommandType].strTypeHelpEditor)
if (strEditCommandType = "SubString")
{
ogcf_blnRadioSubStringFromStart := oGui2.Add("Radio", "y+15 vf_blnRadioSubStringFromStart ". ((aaLastCommand.intSubStringFromType = 1 or aaLastCommand.intSubStringFromType = "") ? " Checked" : ""),  o_L["DialogSubStringFromStart"])
ogcf_blnRadioSubStringFromStart.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringFromPosition := oGui2.Add("Radio", "Section vf_blnRadioSubStringFromPosition ". (aaLastCommand.intSubStringFromType = 2 ? " Checked" : ""),  o_L["DialogSubStringFromPosition"])
ogcf_blnRadioSubStringFromPosition.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringFromBeginText := oGui2.Add("Radio", "vf_blnRadioSubStringFromBeginText ". (aaLastCommand.intSubStringFromType = 3 ? " Checked" : ""),  o_L["DialogSubStringFromBeginText"])
ogcf_blnRadioSubStringFromBeginText.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringFromEndText := oGui2.Add("Radio", "vf_blnRadioSubStringFromEndText ". (aaLastCommand.intSubStringFromType = 4 ? " Checked" : ""),  o_L["DialogSubStringFromEndText"])
ogcf_blnRadioSubStringFromEndText.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringFromPosition.GetPos(&arrWidth1X, &arrWidth1Y, &arrWidth1W, &arrWidth1H)
ogcf_blnRadioSubStringFromBeginText.GetPos(&arrWidth2X, &arrWidth2Y, &arrWidth2W, &arrWidth2H)
ogcf_blnRadioSubStringFromEndText.GetPos(&arrWidth3X, &arrWidth3Y, &arrWidth3W, &arrWidth3H)
ogcEditf_intRadioSubStringFromPosition := oGui2.Add("Edit", "x" . arrWidth1w + 15 . " ys-5 w40 Number Center vf_intRadioSubStringFromPosition disabled", aaLastCommand.intFromPosition)
ogcTextf_lblRadioSubStringFromPosition := oGui2.Add("Text", "yp+5 x+5 vf_lblRadioSubStringFromPosition disabled", o_L["DialogCharacters"])
ogcEditf_strRadioSubStringFromText := oGui2.Add("Edit", "x" . (arrWidth2w > arrWidth3w ? arrWidth2w : arrWidth3w) + 15 . " ys+25 w150 vf_strRadioSubStringFromText disabled", EncodeEolAndTab(aaLastCommand.strFromText))
strSubStringFromHwnd := ogcEditf_strRadioSubStringFromText.hwnd
oGui2.Add("Text", "x+10 yp+3", "+/-")
ogcEditf_intSubStringFromPlusMinus := oGui2.Add("Edit", "x+5 yp-3 w40 vf_intSubStringFromPlusMinus disabled")
ogcf_intSubStringFromUpDown := oGui2.Add("UpDown", "vf_intSubStringFromUpDown Range-9999-9999", aaLastCommand.intFromPlusMinus)
ogcLinko_LDialogEditCommandsInvisibleKeys := oGui2.Add("Link", "x" . (arrWidth2w > arrWidth3w ? arrWidth2w : arrWidth3w) + 15 . " y+5 ", o_L["DialogEditCommandsInvisibleKeys"])
ogcLinko_LDialogEditCommandsInvisibleKeys.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
ogcf_blnRadioSubStringToEnd := oGui2.Add("Radio", "x10 y+15 w140 vf_blnRadioSubStringToEnd ". ((aaLastCommand.intSubStringToType = 1 or aaLastCommand.intSubStringToType = "") ? " Checked" : ""),  o_L["DialogSubStringToEnd"])
ogcf_blnRadioSubStringToEnd.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringLength := oGui2.Add("Radio", "Section vf_blnRadioSubStringLength ". (aaLastCommand.intSubStringToType = 2 ? " Checked" : ""),  o_L["DialogSubStringLength"])
ogcf_blnRadioSubStringLength.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringToBeforeEnd := oGui2.Add("Radio", "vf_blnRadioSubStringToBeforeEnd ". (aaLastCommand.intSubStringToType = 3 ? " Checked" : ""),  o_L["DialogSubStringToBeforeEnd"])
ogcf_blnRadioSubStringToBeforeEnd.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringToBeginText := oGui2.Add("Radio", "vf_blnRadioSubStringToBeginText ". (aaLastCommand.intSubStringToType = 4 ? " Checked" : ""),  o_L["DialogSubStringToBeginText"])
ogcf_blnRadioSubStringToBeginText.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringToEndText := oGui2.Add("Radio", "vf_blnRadioSubStringToEndText ". (aaLastCommand.intSubStringToType = 5 ? " Checked" : ""),  o_L["DialogSubStringToEndText"])
ogcf_blnRadioSubStringToEndText.OnEvent("Click", GuiEditCommandSubStringTypeChanged.Bind("Normal"))
ogcf_blnRadioSubStringLength.GetPos(&arrWidth1X, &arrWidth1Y, &arrWidth1W, &arrWidth1H)
ogcf_blnRadioSubStringToBeforeEnd.GetPos(&arrWidth2X, &arrWidth2Y, &arrWidth2W, &arrWidth2H)
ogcf_blnRadioSubStringToBeginText.GetPos(&arrWidth3X, &arrWidth3Y, &arrWidth3W, &arrWidth3H)
ogcf_blnRadioSubStringToEndText.GetPos(&arrWidth4X, &arrWidth4Y, &arrWidth4W, &arrWidth4H)
ogcEditf_intSubStringCharacters := oGui2.Add("Edit", "x" . (arrWidth1w > arrWidth2w ? arrWidth1w : arrWidth2w) + 15 . " ys+5 w40 Number Center vf_intSubStringCharacters disabled", Abs(aaLastCommand.intSubStringToLength))
ogcTextf_lblSubStringCharacters := oGui2.Add("Text", "yp+5 x+5 vf_lblSubStringCharacters disabled", o_L["DialogCharacters"])
ogcEditf_strSubStringToText := oGui2.Add("Edit", "x" . (arrWidth3w > arrWidth4w ? arrWidth3w : arrWidth4w) + 15 . " ys+45 w150 vf_strSubStringToText disabled", EncodeEolAndTab(aaLastCommand.strSubStringToText))
strSubStringToHwnd := ogcEditf_strSubStringToText.hwnd
oGui2.Add("Text", "x+10 yp+3", "+/-")
ogcEditf_intSubStringToPlusMinus := oGui2.Add("Edit", "x+5 yp-3 w40 vf_intSubStringToPlusMinus disabled")
ogcf_intSubStringToUpDown := oGui2.Add("UpDown", "vf_intSubStringToUpDown Range-9999-9999", aaLastCommand.intSubStringToPlusMinus)
ogcLinko_LDialogEditCommandsInvisibleKeys := oGui2.Add("Link", "x" . (arrWidth1w > arrWidth2w ? arrWidth1w : arrWidth2w) . " y+5 w400 ", o_L["DialogEditCommandsInvisibleKeys"])
ogcLinko_LDialogEditCommandsInvisibleKeys.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
GuiEditCommandSubStringTypeChanged()
}
else if (strEditCommandType = "InsertString")
{
oGui2.Add("Text", "y+15 w400", o_L["DialogTextToInsert"])
ogcEditf_strInsertString := oGui2.Add("Edit", "w400 vf_strInsertString", EncodeEolAndTab(aaLastCommand.strInsertString))
strInsertStringHwnd := ogcEditf_strInsertString.hwnd
ogcLinko_LDialogEditCommandsInvisibleKeys := oGui2.Add("Link", "y+5 w400", o_L["DialogEditCommandsInvisibleKeys"])
ogcLinko_LDialogEditCommandsInvisibleKeys.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
ogcf_blnRadioInsertStringFromStart := oGui2.Add("Radio", "y+10 vf_blnRadioInsertStringFromStart ". ((aaLastCommand.intInsertStringFromType = 1 or aaLastCommand.intInsertStringFromType = "") ? " Checked" : ""),  o_L["DialogSubStringFromStart"])
ogcf_blnRadioInsertStringFromStart.OnEvent("Click", GuiEditCommandInsertStringTypeChanged.Bind("Normal"))
ogcf_blnRadioInsertStringAtTheEnd := oGui2.Add("Radio", "vf_blnRadioInsertStringAtTheEnd ". (aaLastCommand.intInsertStringFromType = 5 ? " Checked" : ""),  o_L["DialogAtTheEnd"])
ogcf_blnRadioInsertStringAtTheEnd.OnEvent("Click", GuiEditCommandInsertStringTypeChanged.Bind("Normal"))
ogcf_blnRadioInsertStringFromPosition := oGui2.Add("Radio", "y+15 Section vf_blnRadioInsertStringFromPosition ". (aaLastCommand.intInsertStringFromType = 2 ? " Checked" : ""),  o_L["DialogSubStringFromPosition"])
ogcf_blnRadioInsertStringFromPosition.OnEvent("Click", GuiEditCommandInsertStringTypeChanged.Bind("Normal"))
ogcf_blnRadioInsertStringFromBeginText := oGui2.Add("Radio", "y+15 vf_blnRadioInsertStringFromBeginText ". (aaLastCommand.intInsertStringFromType = 3 ? " Checked" : ""),  o_L["DialogSubStringFromBeginText"])
ogcf_blnRadioInsertStringFromBeginText.OnEvent("Click", GuiEditCommandInsertStringTypeChanged.Bind("Normal"))
ogcf_blnRadioInsertStringFromEndText := oGui2.Add("Radio", "vf_blnRadioInsertStringFromEndText ". (aaLastCommand.intInsertStringFromType = 4 ? " Checked" : ""),  o_L["DialogSubStringFromEndText"])
ogcf_blnRadioInsertStringFromEndText.OnEvent("Click", GuiEditCommandInsertStringTypeChanged.Bind("Normal"))
ogcf_blnRadioInsertStringFromPosition.GetPos(&arrWidth1X, &arrWidth1Y, &arrWidth1W, &arrWidth1H)
ogcf_blnRadioInsertStringFromBeginText.GetPos(&arrWidth2X, &arrWidth2Y, &arrWidth2W, &arrWidth2H)
ogcf_blnRadioInsertStringFromEndText.GetPos(&arrWidth3X, &arrWidth3Y, &arrWidth3W, &arrWidth3H)
ogcEditf_intRadioInsertStringFromPosition := oGui2.Add("Edit", "x" . arrWidth1w + 15 . " ys-5 w40 Number Center vf_intRadioInsertStringFromPosition disabled", aaLastCommand.intFromPosition)
ogcTextf_lblRadioInsertStringFromPosition := oGui2.Add("Text", "yp+5 x+5 vf_lblRadioInsertStringFromPosition disabled", o_L["DialogCharacters"])
ogcEditf_strRadioInsertStringFromText := oGui2.Add("Edit", "x" . (arrWidth2w > arrWidth3w ? arrWidth2w : arrWidth3w) + 15 . " ys+35 w150 vf_strRadioInsertStringFromText disabled", EncodeEolAndTab(aaLastCommand.strFromText))
oGui2.Add("Text", "x+10 yp+3", "+/-")
ogcEditf_intFromPlusMinus := oGui2.Add("Edit", "x+5 yp-3 w40 vf_intFromPlusMinus disabled")
ogcf_intInsertStringFromUpDown := oGui2.Add("UpDown", "vf_intInsertStringFromUpDown Range-9999-9999", aaLastCommand.intFromPlusMinus)
GuiEditCommandInsertStringTypeChanged()
}
else if (strEditCommandType = "FilterLines")
{
ogcRadiof_blnFilterLinesDelete := oGui2.Add("Radio", "x10 y+15 vf_blnFilterLinesDelete ". ((aaLastCommand.intFilterLinesType < 10 or aaLastCommand.intFilterLinesType = "") ? " Checked" : ""),  o_L["DialogDeleteLines"])
ogcRadiof_blnFilterLinesDelete.OnEvent("Click", GuiEditCommandFilterLinesTypeChanged.Bind("Normal"))
ogcRadiof_blnFilterLinesKeep := oGui2.Add("Radio", "yp x+15 vf_blnFilterLinesKeep ". ((aaLastCommand.intFilterLinesType > 10) ? " Checked" : ""),  o_L["DialogKeepLines"])
ogcRadiof_blnFilterLinesKeep.OnEvent("Click", GuiEditCommandFilterLinesTypeChanged.Bind("Normal"))
oGui2.Add("Text", "yp x+1")
ogcRadiof_blnFilterLinesContaining := oGui2.Add("Radio", "x10 y+15 section vf_blnFilterLinesContaining ". (Mod(aaLastCommand.intFilterLinesType, 10) = 1 or aaLastCommand.intFilterLinesType = "" ? " Checked" : ""),  o_L["DialogLinesContaining"] . " (" . o_L["DialogLinesContainingMultiple"] . ")")
ogcRadiof_blnFilterLinesContaining.OnEvent("Click", GuiEditCommandFilterLinesTypeChanged.Bind("Normal"))
ogcRadiof_blnFilterLinesRegEx := oGui2.Add("Radio", "x10 ys+123 vf_blnFilterLinesRegEx ". ((aaLastCommand.intFilterLinesType = 2) ? " Checked" : ""),  o_L["EditFindRegEx"])
ogcRadiof_blnFilterLinesRegEx.OnEvent("Click", GuiEditCommandFilterLinesTypeChanged.Bind("Normal"))
ogcRadiof_blnFilterLines3 := oGui2.Add("Radio", "w400 y+60 vf_blnFilterLines3 ". (aaLastCommand.intFilterLinesType = 3 ? " Checked" : ""))
ogcRadiof_blnFilterLines3.OnEvent("Click", GuiEditCommandFilterLinesTypeChanged.Bind("Normal"))
ogcRadiof_blnFilterLines4 := oGui2.Add("Radio", "w400 vf_blnFilterLines4 ". (aaLastCommand.intFilterLinesType = 4 ? " Checked" : ""))
ogcRadiof_blnFilterLines4.OnEvent("Click", GuiEditCommandFilterLinesTypeChanged.Bind("Normal"))
ogcCheckboxf_blnFilterLinesCase := oGui2.Add("Checkbox", "x10 y+10 w400 vf_blnFilterLinesCase " . (aaLastCommand.blnFilterLinesCase = 1 ? "checked" : ""), o_L["DialogCaseSensitive"])
ogcEditf_strFilterLinesCriteriaList := oGui2.Add("Edit", "x27 ys+40 w383 r4 vf_strFilterLinesCriteriaList -Wrap", aaLastCommand.strFilterLinesCriteriaList)
strFilterLinesHwnd := ogcEditf_strFilterLinesCriteriaList.hwnd
ogcLinko_LDialogEditCommandsInvisibleTab := oGui2.Add("Link", "x27 ys+103 w400", o_L["DialogEditCommandsInvisibleTab"])
ogcLinko_LDialogEditCommandsInvisibleTab.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
ogcRadiof_blnFilterLinesAnd := oGui2.Add("Radio", "ys+20 x27 vf_blnFilterLinesAnd". ((aaLastCommand.intFilterLinesContainingType = 1 or aaLastCommand.intFilterLinesContainingType = "") ? " Checked" : ""),  o_L["DialogLinesAll"])
ogcRadiof_blnFilterLinesOr := oGui2.Add("Radio", "x+15 vf_blnFilterLinesOr". ((aaLastCommand.intFilterLinesContainingType = 2) ? " Checked" : ""),  o_L["DialogLinesAny"])
ogcRadiof_blnFilterLinesNotAll := oGui2.Add("Radio", "x+15 yp vf_blnFilterLinesNotAll". ((aaLastCommand.intFilterLinesContainingType = 3) ? " Checked" : ""),  o_L["DialogLinesNotAll"])
ogcRadiof_blnFilterLinesNotAny := oGui2.Add("Radio", "x+15 yp vf_blnFilterLinesNotAny". ((aaLastCommand.intFilterLinesContainingType = 4) ? " Checked" : ""),  o_L["DialogLinesNotAny"])
ogcRadiof_blnFilterLinesRegEx.GetPos(&arrControlPosX, &arrControlPosY, &arrControlPosW, &arrControlPosH)
ogcEditf_strFilterLinesCriteriaRegex := oGui2.Add("Edit", "x27 y" . arrControlPosY + 20 . " w383 r3 vf_strFilterLinesCriteriaRegex", aaLastCommand.strFilterLinesCriteriaRegex)
GuiEditCommandFilterLinesTypeChanged()
}
else if (strEditCommandType = "FilterCharacters")
{
ogcRadiof_blnFilterCharactersDelete := oGui2.Add("Radio", "x10 y+15 vf_blnFilterCharactersDelete ". ((aaLastCommand.intFilterCharactersType < 10 or aaLastCommand.intFilterCharactersType = "") ? " Checked" : ""),  o_L["DialogDeleteCharacters"])
ogcRadiof_blnFilterCharactersDelete.OnEvent("Click", GuiEditCommandFilterCharactersChanged.Bind("Normal"))
ogcRadiof_blnFilterCharactersKeep := oGui2.Add("Radio", "yp x+15 vf_blnFilterCharactersKeep ". ((aaLastCommand.intFilterCharactersType > 10) ? " Checked" : ""),  o_L["DialogKeepCharacters"])
ogcRadiof_blnFilterCharactersKeep.OnEvent("Click", GuiEditCommandFilterCharactersChanged.Bind("Normal"))
ogcTextf_lblFilterCharactersList := oGui2.Add("Text", "x10 y+10 w400 vf_lblFilterCharactersList")
ogcEditf_strFilterCharactersList := oGui2.Add("Edit", "w400 vf_strFilterCharactersList", EncodeEolAndTab(aaLastCommand.strFilterCharactersList))
strFilterCharactersHwnd := ogcEditf_strFilterCharactersList.hwnd
ogcLinko_LDialogEditCommandsInvisibleKeysMore := oGui2.Add("Link", "y+5 w400", o_L["DialogEditCommandsInvisibleKeysMore"])
ogcLinko_LDialogEditCommandsInvisibleKeysMore.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
ogcRadiof_blnFilterCharactersEverywhere := oGui2.Add("Radio", "y+10 w400 vf_blnFilterCharactersEverywhere". ((Mod(aaLastCommand.intFilterCharactersType, 10) = 1 or aaLastCommand.intFilterCharactersType = "") ? " Checked" : ""))
ogcRadiof_blnDeleteCharactersBeginEnd := oGui2.Add("Radio", "vf_blnDeleteCharactersBeginEnd". ((aaLastCommand.intFilterCharactersType = 2) ? " Checked" : ""),  o_L["DialogDeleteCharactersBeginEnd"])
ogcRadiof_blnDeleteCharactersBegin := oGui2.Add("Radio", "vf_blnDeleteCharactersBegin". ((aaLastCommand.intFilterCharactersType = 3) ? " Checked" : ""),  o_L["DialogDeleteCharactersBegin"])
ogcRadiof_blnDialogDeleteCharactersEnd := oGui2.Add("Radio", "vf_blnDialogDeleteCharactersEnd". ((aaLastCommand.intFilterCharactersType = 4) ? " Checked" : ""),  o_L["DialogDeleteCharactersEnd"])
ogcCheckboxf_blnFilterCharactersCase := oGui2.Add("Checkbox", "y+10 w400 vf_blnFilterCharactersCase " . (aaLastCommand.blnFilterCharactersCase = 1 ? "checked" : ""), o_L["DialogCaseSensitive"])
GuiEditCommandFilterCharactersChanged()
}
else if (strEditCommandType = "ReformatPara")
{
aaLastCommand.intEditReformatParaLineWidth := (StrLen(aaLastCommand.intEditReformatParaLineWidth) ? aaLastCommand.intEditReformatParaLineWidth : 0)
ogcRadiof_blnEditReformatParaSeparated := oGui2.Add("Radio", "x10 y+15 vf_blnEditReformatParaSeparated". ((aaLastCommand.intParaSeparated = 1 or aaLastCommand.intParaSeparated = "") ? " Checked" : ""),  o_L["EditReformatParaSeparated"])
ogcRadiof_blnEditReformatParaMerged := oGui2.Add("Radio", "x10 vf_blnEditReformatParaMerged". ((aaLastCommand.intParaSeparated = 0) ? " Checked" : ""),  o_L["EditReformatParaMerged"])
ogcTextf_lblEditReformatParaLineWidth := oGui2.Add("Text", "x10 y+20 vf_lblEditReformatParaLineWidth", o_L["EditReformatParaLineWidth"] . ":")
ogcf_intEditReformatParaLineWidth := oGui2.Add("Edit", "x+10 yp-5 w40 Number Center vf_intEditReformatParaLineWidth", aaLastCommand.intEditReformatParaLineWidth)
ogcf_intEditReformatParaLineWidth.OnEvent("Change", GuiEditCommandReformatParaLineWidthChanged.Bind("Change"))
ogcTextf_lblEditReformatParaLineWidthZero := oGui2.Add("Text", "x+10 yp+5 vf_lblEditReformatParaLineWidthZero", o_L["EditReformatParaLineWidthZero"])
ogcTextf_lblEditReformatParaAlign := oGui2.Add("Text", "x10 y+10 vf_lblEditReformatParaAlign", o_L["EditReformatParaAlignPrompt"])
ogcRadiof_radReformatParaAlignLeft := oGui2.Add("Radio", "vf_radReformatParaAlignLeft section ". (aaLastCommand.intEditReformatParaAlign = 0 or !StrLen(aaLastCommand.intEditReformatParaAlign) ? " Checked" : ""),  o_L["EditReformatParaAlignLeft"])
ogcRadiof_radReformatParaAlignLeft.OnEvent("Click", GuiEditCommandReformatParaAlignChanged.Bind("Normal"))
ogcRadiof_radReformatParaAlignIndent := oGui2.Add("Radio", "vf_radReformatParaAlignIndent ". ((aaLastCommand.intEditReformatParaAlign = 1) ? " Checked" : ""),  o_L["EditReformatParaAlignIndent"])
ogcRadiof_radReformatParaAlignIndent.OnEvent("Click", GuiEditCommandReformatParaAlignChanged.Bind("Normal"))
ogcRadiof_radReformatParaAlignRight := oGui2.Add("Radio", "vf_radReformatParaAlignRight ". ((aaLastCommand.intEditReformatParaAlign = 2) ? " Checked" : ""),  o_L["EditReformatParaAlignRight"])
ogcRadiof_radReformatParaAlignRight.OnEvent("Click", GuiEditCommandReformatParaAlignChanged.Bind("Normal"))
ogcRadiof_radReformatParaAlignCenter := oGui2.Add("Radio", "vf_radReformatParaAlignCenter ". ((aaLastCommand.intEditReformatParaAlign = 3) ? " Checked" : ""),  o_L["EditReformatParaAlignCenter"])
ogcRadiof_radReformatParaAlignCenter.OnEvent("Click", GuiEditCommandReformatParaAlignChanged.Bind("Normal"))
ogcTextf_lblEditReformatParaIndent := oGui2.Add("Text", "x200 ys vf_lblEditReformatParaIndent", o_L["EditReformatParaIndentCharactersPrompt"])
ogcTextf_lblEditReformatParaIndentFirst := oGui2.Add("Text", "x200 y+10 w60 vf_lblEditReformatParaIndentFirst", o_L["EditReformatParaIndentCharactersFirst"] . ":")
ogcf_strEditReformatParaIndentCharactersFirst := oGui2.Add("Edit", "x+5 yp-5 w50 vf_strEditReformatParaIndentCharactersFirst", EncodeEolAndTab(aaLastCommand.strEditReformatParaIndentCharactersFirst))
strIndentCharactersFirstHwnd := ogcf_strEditReformatParaIndentCharactersFirst.hwnd
ogcLinkf_lnkEditReformatParaIndentCharactersFirst := oGui2.Add("Link", "x+5 yp+5   vf_lnkEditReformatParaIndentCharactersFirst", o_L["DialogEditCommandsInvisibleTab"])
ogcLinkf_lnkEditReformatParaIndentCharactersFirst.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
ogcTextf_lblEditReformatParaIndentOther := oGui2.Add("Text", "x200 y+15 w60 vf_lblEditReformatParaIndentOther", o_L["EditReformatParaIndentCharactersOther"] . ":")
ogcf_strEditReformatParaIndentCharactersOther := oGui2.Add("Edit", "x+5 yp-5 w50 vf_strEditReformatParaIndentCharactersOther", EncodeEolAndTab(aaLastCommand.strEditReformatParaIndentCharactersOther))
strIndentCharactersOtherHwnd := ogcf_strEditReformatParaIndentCharactersOther.hwnd
ogcLinkf_lnkEditReformatParaIndentCharactersOther := oGui2.Add("Link", "x+5 yp+5  vf_lnkEditReformatParaIndentCharactersOther", o_L["DialogEditCommandsInvisibleTab"])
ogcLinkf_lnkEditReformatParaIndentCharactersOther.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
ogcCheckboxf_blnEditReformatParaPunct := oGui2.Add("Checkbox", "x10 y+30 vf_blnEditReformatParaPunct  ". (aaLastCommand.blnEditReformatParaPunct = 1 ? "checked" : ""),  o_L["EditReformatParaPunctYesNo"])
ogcCheckboxf_blnEditReformatParaPunct.OnEvent("Click", GuiEditCommandReformatParaPunctChanged.Bind("Normal"))
ogcLinkf_lnkEditReformatParaPunctDefault := oGui2.Add("Link", "x+5 yp  vf_lnkEditReformatParaPunctDefault", o_L["EditReformatParaPunctDefault"])
ogcLinkf_lnkEditReformatParaPunctDefault.OnEvent("Click", ReformatParaPunctDefaultClicked.Bind("Normal"))
ogcf_strEditReformatParaPunct1Space := oGui2.Add("Edit", "x27 y+10 w40 vf_strEditReformatParaPunct1Space", aaLastCommand.strEditReformatParaPunct1Space)
strPunct1SpaceHwnd := ogcf_strEditReformatParaPunct1Space.hwnd
ogcTextf_lblEditReformatParaPunct1Space := oGui2.Add("Text", "x+5 yp+5 vf_lblEditReformatParaPunct1Space", o_L["EditReformatParaPunct1Space"])
ogcf_strEditReformatParaPunct2Spaces := oGui2.Add("Edit", "x27 y+10 w40 vf_strEditReformatParaPunct2Spaces", aaLastCommand.strEditReformatParaPunct2Spaces)
strPunct2SpacesHwnd := ogcf_strEditReformatParaPunct2Spaces.hwnd
ogcTextf_lblEditReformatParaPunct2Spaces := oGui2.Add("Text", "x+5 yp+5 vf_lblEditReformatParaPunct2Spaces", o_L["EditReformatParaPunct2Spaces"])
ogcf_strEditReformatParaPunct1SpaceBefore := oGui2.Add("Edit", "x27 y+10 w40 vf_strEditReformatParaPunct1SpaceBefore", aaLastCommand.strEditReformatParaPunct1SpaceBefore)
strPunct1SpaceBeforeHwnd := ogcf_strEditReformatParaPunct1SpaceBefore.hwnd
ogcTextf_lblEditReformatParaPunct1SpaceBefore := oGui2.Add("Text", "x+5 yp+5 vf_lblEditReformatParaPunct1SpaceBefore", o_L["EditReformatParaPunct1SpaceBefore"])
ogcf_strEditReformatParaPunctUpperAfter := oGui2.Add("Edit", "x27 y+10 w40 vf_strEditReformatParaPunctUpperAfter", aaLastCommand.strEditReformatParaPunctUpperAfter)
strPunctUpperAfterHwnd := ogcf_strEditReformatParaPunctUpperAfter.hwnd
ogcTextf_lblEditReformatParaPunctUpperAfter := oGui2.Add("Text", "x+5 yp+5 vf_lblEditReformatParaPunctUpperAfter", o_L["EditReformatParaPunctUpperAfter"])
GuiEditCommandReformatParaLineWidthChanged()
GuiEditCommandReformatParaPunctChanged()
}
else if (strEditCommandType = "SortOptions")
{
aaLineSpacing :=  {"C ": "", "P": "", "U ": ""}
Loop Parse, "R |N |C |CL |P|BS |U |Random |Length", "|"
{
ogcCheckboxf_strSortOption := oGui2.Add("Checkbox", (A_Index = 1 ? "x10 y+10 " : (aaLineSpacing.Has(A_LoopField) ? "x10 yp+25 " : "x10 ")) . "  vf_strSortOption" . A_LoopField. (InStr(aaLastCommand.strSortOptions, A_LoopField) ? " Checked" : ""), o_L["DialogSortOption" . Trim(A_LoopField)])
ogcCheckboxf_strSortOption.OnEvent("Click", GuiEditCommandSortTypeChanged.Bind("Normal"))
if (A_LoopField = "P" and InStr(aaLastCommand.strSortOptions, "P"))
intFromPosition := Trim(SubStr(aaLastCommand.strSortOptions, (InStr(aaLastCommand.strSortOptions, "P") + 1)<1 ? (InStr(aaLastCommand.strSortOptions, "P") + 1)-1 : (InStr(aaLastCommand.strSortOptions, "P") + 1)))
if (A_LoopField = "P")
ogcEditf_intSortOptionPosition := oGui2.Add("Edit", "x+5 yp-3 w40 Number Center vf_intSortOptionPosition  disabled", intFromPosition)
ogcEditf_intSortOptionPosition.OnEvent("Change", GuiEditCommandSortTypeChanged.Bind("Change"))
}
GuiEditCommandSortTypeChanged()
}
else if InStr("Find|FindReplace|", strEditCommandType . "|")
{
oGui2.Add("Text", "x10 y+10 w400", o_L["EditFindWhat"])
ogcEditf_strFindOrReplaceWhat := oGui2.Add("Edit", "x10 y+5 w400 vf_strFindOrReplaceWhat", EncodeEolAndTab(aaLastCommand.strFindOrReplaceWhat))
strFindOrReplaceWhatHwnd := ogcEditf_strFindOrReplaceWhat.hwnd
ogcLinko_LDialogEditCommandsInvisibleKeys := oGui2.Add("Link", "y+5 w400", o_L["DialogEditCommandsInvisibleKeys"])
ogcLinko_LDialogEditCommandsInvisibleKeys.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
if InStr(strEditCommandType, "Replace")
{
oGui2.Add("Text", "x10 y+15 w400", o_L["EditReplaceWith"])
ogcEditf_strFindOrReplaceWith := oGui2.Add("Edit", "x10 y+5 w400 vf_strFindOrReplaceWith", EncodeEolAndTab(aaLastCommand.strFindOrReplaceWith))
strFindOrReplaceWithHwnd := ogcEditf_strFindOrReplaceWith.hwnd
ogcLinko_LDialogEditCommandsInvisibleKeys := oGui2.Add("Link", "y+5 w400", o_L["DialogEditCommandsInvisibleKeys"])
ogcLinko_LDialogEditCommandsInvisibleKeys.OnEvent("Click", InsertStringInvisibleKeysClicked.Bind("Normal"))
}
ogcCheckboxf_blnFindOrReplaceMatchCase := oGui2.Add("Checkbox", "x10 y+15 vf_blnFindOrReplaceMatchCase", o_L["EditReplaceMatchCase"])
ogcCheckboxf_blnFindOrReplaceMatchCase.Value := (aaLastCommand.blnFindOrReplaceMatchCase = true)
ogcCheckboxf_blnFindOrReplaceRegEx := oGui2.Add("Checkbox", "x+10 yp vf_blnFindOrReplaceRegEx", o_L["EditFindRegEx"])
ogcCheckboxf_blnFindOrReplaceRegEx.OnEvent("Click", GuiEditCommandFindRegexChanged.Bind("Normal"))
ogcCheckboxf_blnFindOrReplaceRegEx.Value := (aaLastCommand.blnFindOrReplaceRegEx = true)
ogcCheckboxf_blnSavedCommandReplaceAll := oGui2.Add("Checkbox", "x+1 yp vf_blnSavedCommandReplaceAll hidden")
GuiEditCommandFindRegexChanged()
ogcf_ReplaceWhat.Focus()
}
else if InStr("FileOpen|FileSave|FileClipboardBackup|FileClipboardRestore", strEditCommandType)
{
oGui2.Add("Text", "x10 y+10 w400", o_L[(InStr("FileOpen|FileClipboardRestore", strEditCommandType))
? "DialogFileToOpen" : "DialogFileToSave")]
ogcEditf_strFilePath := oGui2.Add("Edit", "x10 y+5 w285 vf_strFilePath", aaLastCommand.strFilePath)
ogcf_ButtonSelectFile := oGui2.Add("Button", "x+10 yp w100  vf_ButtonSelectFile". (InStr("FileOpen|FileClipboardRestore", strEditCommandType) ? "Open" : "Save"),  o_L["DialogBrowseButton"])
ogcf_ButtonSelectFile.OnEvent("Click", ButtonSelectFileClicked.Bind("Normal"))
if (strEditCommandType = "FileOpen")
{
oGui2.Add("Text", "x10 y+15", o_L["DialogFileOpenToPrompt"])
ogcCheckboxf_blnFileOpenToEditor := oGui2.Add("Checkbox", "x10 y+5 vf_blnFileOpenToEditor", o_L["DialogFileOpenToEditor"])
ogcCheckboxf_blnFileOpenToEditor.OnEvent("Click", FileOpenToEditorChanged.Bind("Normal"))
ogcCheckboxf_blnFileOpenToEditor.Value := (Mod(aaLastCommand.intFileOpenTo, 10) or aaLastCommand.intFileOpenTo = "")
saFileOpenToEditorAt := StrSplit(o_L["DialogFileOpenToEditorAt"], "|")
Loop saFileOpenToEditorAt.Length
ogcRadiof_radFileOpenToEditorAt := oGui2.Add("Radio", "x25 vf_radFileOpenToEditorAt" . A_Index. (Mod(aaLastCommand.intFileOpenTo, 10) = A_Index or (A_Index = 1 and aaLastCommand.intFileOpenTo = "") ? " Checked" : ""), saFileOpenToEditorAt[A_Index])
FileOpenToEditorChanged()
ogcCheckboxf_blnFileOpenToClipboard := oGui2.Add("Checkbox", "x10 y+10 vf_blnFileOpenToClipboard", o_L["DialogFileOpenToClipboard"])
ogcCheckboxf_blnFileOpenToClipboard.Value := (aaLastCommand.intFileOpenTo >= 10)
}
if (strEditCommandType = "FileSave")
{
ogcCheckboxf_blnFileSaveSelected := oGui2.Add("Checkbox", "x10 y+15 vf_blnFileSaveSelected", o_L["DialogFileSaveSelected"])
ogcCheckboxf_blnFileSaveSelected.Value := (aaLastCommand.blnFileSaveSelected = true)
oGui2.Add("Text", "x10 y+15", o_L["DialogFileSaveEolPrompt"])
saEolList := StrSplit(o_L["DialogFileSaveEolList"], "|")
Loop saEolList.Length
ogcf_blnRadioFileSaveEol := oGui2.Add("Radio", "x10 vf_blnRadioFileSaveEol" . A_Index. (aaLastCommand.intFileSaveEol = A_Index or (A_Index = 1 and aaLastCommand.intFileSaveEol = "") ? " Checked" : ""), saEolList[A_Index])
}
if InStr("FileOpen|FileSave", strEditCommandType)
{
oGui2.Add("Text", "x10 y+15", o_L["DialogFileEncoding"])
saEncodingList := StrSplit(L(o_L["DialogFileEncodingList"], o_Settings.Various.intFileEncodingCodePage.IniValue), "|")
Loop saEncodingList.Length
ogcf_blnRadioFileEncoding := oGui2.Add("Radio", "x10 vf_blnRadioFileEncoding" . A_Index. (aaLastCommand.intFileEncoding = A_Index or (aaLastCommand.intFileEncoding = "" and A_Index = 1) ? " Checked" : ""), saEncodingList[A_Index])
}
}
if StrLen(g_aaEditCommandTypes[strEditCommandType].strLastSessionCommandDetail)
and (g_aaSavedCommand.strCommandType <> strEditCommandType)
{
GuiEditCommandLastCommandDetail()
g_aaEditCommandTypes[strEditCommandType].strLastSessionCommandDetail := ""
}
oGui2.Add("Text", (strEditCommandType = "FilterLines" ? "ys+265" : "y+20") . " x10 w400", o_L["DialogSavedCommands"])
ogcDropDownListf_drpSavedCommands := oGui2.Add("DropDownList", "x10 y+5 w400 vf_drpSavedCommands", [GetSavedCommandsList(strEditCommandType)])
ogcDropDownListf_drpSavedCommands.OnEvent("Change", GuiEditCommandSavedCommandChanged.Bind("Change"))
ogcCheckboxf_blnSaveCommand := oGui2.Add("Checkbox", "x10 y+20 w400 vf_blnSaveCommand", o_L["DialogSaveThisCommand"])
ogcCheckboxf_blnSaveCommand.OnEvent("Click", GuiSaveCommandClicked.Bind("Normal"))
ogcCheckboxf_blnSaveCommand.Value := IsObject(g_aaSavedCommand)
ogcTextf_lblSaveCommandPrompt := oGui2.Add("Text", "x10 y+10 vf_lblSaveCommandPrompt", o_L["GuiSaveCommandPrompt"])
ogcEditf_strSaveCommandTitle := oGui2.Add("Edit", "x10 y+5 w340 vf_strSaveCommandTitle", g_aaSavedCommand.strTitle)
ogcEditf_strSaveCommandTitle.OnEvent("Change", SaveCommandTitleChanged.Bind("Change"))
ogcButtonf_btnSaveCommandTitleSuggest := oGui2.Add("Button", "yp x+10 w50 vf_btnSaveCommandTitleSuggest", o_L["GuiSaveCommandTitleSuggest"])
ogcButtonf_btnSaveCommandTitleSuggest.OnEvent("Click", EditCommandPrepare.Bind("Normal"))
if (strEditCommandType = "FindReplace")
ogcCheckboxf_blnSaveCommandReplaceAll := oGui2.Add("Checkbox", "x10 y+10 vf_blnSaveCommandReplaceAll", o_L["DialogReplaceAllExternal"])
ogcCheckboxf_blnSaveCommandInMenu := oGui2.Add("Checkbox", "x10 y+10 vf_blnSaveCommandInMenu", o_L["DialogAddToMenu"])
ogcCheckboxf_blnSaveCommandInMenu.Value := g_aaSavedCommand.blnInMenu = 1
ogcTextf_lblSaveCommandHotkeyPrompt := oGui2.Add("Text", "x+10 yp vf_lblSaveCommandHotkeyPrompt", o_L["DialogHotkeyLocal"] . ":")
ogcLinkf_lnkSaveCommandHotkey := oGui2.Add("Link", "vf_lnkSaveCommandHotkey  x+5 yp w200", L("<a>~1~</a>", new Triggers.HotkeyParts(g_aaSavedCommand.strLocalHotkey).Hotkey2Text(false)))
ogcLinkf_lnkSaveCommandHotkey.OnEvent("Click", SavedCommandHotkeyClicked.Bind("Normal"))
ogcEditf_strLocalHotkeyCode := oGui2.Add("Edit", "vf_strLocalHotkeyCode x10 yp hidden", g_aaSavedCommand.strLocalHotkey)
if StrLen(g_aaSavedCommand.strTitle)
{
ogcDropDownListf_drpSavedCommands.Choose(g_aaSavedCommand.strTitle)
GuiEditCommandSavedCommandChanged()
}
aaL := o_L.InsertAmpersand("DialogKeep", "DialogRemove", "DialogGo", "DialogSave", "GuiCancel")
if (strEditCommandType = "SubString")
{
ogcButtonf_btnGo := oGui2.Add("Button", "y+20 vf_btnGo Default", aaL["DialogKeep"])
ogcButtonf_btnGo.OnEvent("Click", EditCommandPrepare.Bind("Normal"))
ogcButtonf_btnRemove := oGui2.Add("Button", "yp vf_btnRemove", aaL["DialogRemove"])
ogcButtonf_btnRemove.OnEvent("Click", EditCommandPrepare.Bind("Normal"))
}
else
ogcButtonf_btnGo := oGui2.Add("Button", "y+20 vf_btnGo Default", aaL["DialogGo"])
ogcButtonf_btnGo.OnEvent("Click", EditCommandPrepare.Bind("Normal"))
ogcButtonf_btnSaveOnly := oGui2.Add("Button", "yp vf_btnSaveOnly", aaL["DialogSave"])
ogcButtonf_btnSaveOnly.OnEvent("Click", EditCommandPrepare.Bind("Normal"))
ogcButtonf_btnCancel := oGui2.Add("Button", "yp vf_btnCancel", aaL["GuiCancel"])
ogcButtonf_btnCancel.OnEvent("Click", _2GuiClose.Bind("Normal"))
if (strEditCommandType = "SubString")
GuiCenterButtons(g_strGui2Hwnd, , , , , , , "f_btnGo", "f_btnRemove", "f_btnSaveOnly", "f_btnCancel")
else
GuiCenterButtons(g_strGui2Hwnd, , , , , , , "f_btnGo", "f_btnSaveOnly", "f_btnCancel")
ogcf_strEditCommandType := oGui2.Add("Edit", "yp+30 vf_strEditCommandType hidden", strEditCommandType)
ShowGui2AndDisableGuiEditor()
GuiSaveCommandClicked()
intPosition := ""
strName := ""
arrWidth1 := ""
arrWidth2 := ""
arrWidth3 := ""
arrWidth4 := ""
strMainGui := ""
aaLineSpacing := ""
strEditCommandType := ""
aaLastCommand := ""
arrControlPos := ""
aaL := ""
return
} ; V1toV2: Added Bracket before label
GuiSaveCommandClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
blnCommand := (f_blnSaveCommand ? "Show" : "Hide")






if (f_strEditCommandType = "FindReplace")


intFooterDiff := 70 + (f_strEditCommandType = "FindReplace" ? 24 : 0)
intFooterButtons := 40
intFooterBottom := 35
ogcCheckboxf_blnSaveCommand.GetPos(&arrPosSaveCheckboxX, &arrPosSaveCheckboxY, &arrPosSaveCheckboxW, &arrPosSaveCheckboxH)
intButtonsY := arrPosSaveCheckboxY + intFooterButtons + (f_blnSaveCommand ? intFooterDiff : 0)
intWindowY := intButtonsY + intFooterBottom
ogcButtonf_btnGo.Move(, intButtonsY)
ogcButtonf_btnSaveOnly.Move(, intButtonsY)
ogcButtonf_btnCancel.Move(, intButtonsY)
if (f_strEditCommandType = "SubString")
ogcButtonf_btnRemove.Move(, intButtonsY)
oGui2.Show("h" . intWindowY)
blnCommand := ""
arrPos := ""
intDistance := ""
intH := ""
return
} ; V1toV2: Added Bracket before label
SaveCommandTitleChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
g_blnSavedCommandRetrieved := false
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
FileOpenToEditorChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
Loop saFileOpenToEditorAt.Length

return
} ; V1toV2: Added Bracket before label
GuiEditCommandSavedCommandChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GuiEditCommandLastCommandDetail()
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
if (A_ThisLabel = "GuiEditCommandSavedCommandChanged" and !StrLen(f_drpSavedCommands))
return
if (A_ThisLabel = "GuiEditCommandSavedCommandChanged")
{
g_aaSavedCommand := GetSavedCommand(f_drpSavedCommands)
strRetrievedCommandDetail := g_aaSavedCommand.strDetail
}
else
{
g_aaSavedCommand := ""
strRetrievedCommandDetail := g_aaEditCommandTypes[strEditCommandType].strLastSessionCommandDetail
}
saRetreivedCommandDetail := StrSplit(strRetrievedCommandDetail, "|")
strRetrievedCommandType := saRetreivedCommandDetail[1]
if (strRetrievedCommandType = "SubString")
{
ogc%(saRetreivedCommandDetail[2] = "Keep" ? "f_btnGo" : "f_btnRemove").Options("+Default")%
ogc%StrSplit("f_blnRadioSubStringFromStart|f_blnRadioSubStringFromPosition|f_blnRadioSubStringFromBeginText|f_blnRadioSubStringFromEndText", "|")[saRetreivedCommandDetail[3]].Value := 1%
ogcEditf_intRadioSubStringFromPosition.Value := saRetreivedCommandDetail[4]
ogcEditf_strRadioSubStringFromText.Add([StrReplace(saRetreivedCommandDetail[5], g_strEscapePipe, '"', '')])
ogcf_intSubStringFromUpDown.Value := saRetreivedCommandDetail[6]
ogc%StrSplit("f_blnRadioSubStringToEnd|f_blnRadioSubStringLength|f_blnRadioSubStringToBeforeEnd|f_blnRadioSubStringToBeginText|f_blnRadioSubStringToEndText", "|")[saRetreivedCommandDetail[7]].Value := 1%
ogcEditf_intSubStringCharacters.Value := Abs(saRetreivedCommandDetail[8])
ogcEditf_strSubStringToText.Add([StrReplace(saRetreivedCommandDetail[9], g_strEscapePipe, ", "`")"])
ogcf_intSubStringToUpDown.Value := saRetreivedCommandDetail[10]
GuiEditCommandSubStringTypeChanged()
}
else if (strRetrievedCommandType = "InsertString")
{
ogcEditf_strInsertString.Add([StrReplace(saRetreivedCommandDetail[2], g_strEscapePipe, ", "`")"])
ogc% StrSplit("f_blnRadioInsertStringFromStart|f_blnRadioInsertStringFromPosition|f_blnRadioInsertStringFromBeginText|f_blnRadioInsertStringFromEndText|f_blnRadioInsertStringAtTheEnd", "|")[saRetreivedCommandDetail[3]].Value := 1
ogcEditf_intRadioInsertStringFromPosition.Value := saRetreivedCommandDetail[4]
ogcEditf_strRadioInsertStringFromText.Add([StrReplace(saRetreivedCommandDetail[5], g_strEscapePipe, ", "`")"])
ogcf_intInsertStringFromUpDown.Value := saRetreivedCommandDetail[6]
GuiEditCommandInsertStringTypeChanged()
}
else if (strRetrievedCommandType = "SortOptions")
{
Loop Parse, "R |N |C |CL |P|BS |U |Random |Length", "|"
{
ogc% "f_strSortOption" . Trim(A_LoopField).Value := InStr(saRetreivedCommandDetail[2], A_LoopField) > 0
if (A_LoopField = "P")
ogcEditf_intSortOptionPosition.Value := GetNumberAfterP(saRetreivedCommandDetail[2])
}
GuiEditCommandSortTypeChanged()
}
else if InStr(strRetrievedCommandType, "Find")
{
ogcEditf_strFindOrReplaceWhat.Add([StrReplace(saRetreivedCommandDetail[2], g_strEscapePipe, ", "`")"])
ogcEditf_strFindOrReplaceWith.Add([StrReplace(saRetreivedCommandDetail[3], g_strEscapePipe, ", "`")"])
ogcCheckboxf_blnFindOrReplaceMatchCase.Value := (saRetreivedCommandDetail[4] = 1)
ogcCheckboxf_blnFindOrReplaceRegEx.Value := (saRetreivedCommandDetail[5] = 1)
ogcCheckboxf_blnSavedCommandReplaceAll.Value := (saRetreivedCommandDetail[6] = 1)
GuiEditCommandFindRegexChanged()
}
else if (strRetrievedCommandType = "FilterLines")
{
ogcRadiof_blnFilterLinesDelete.Text := (saRetreivedCommandDetail[2] < 10 ? 1 : 0)
ogcRadiof_blnFilterLinesKeep.Text := (saRetreivedCommandDetail[2] > 10 ? 1 : 0)
ogc% StrSplit("f_blnFilterLinesContaining|f_blnFilterLinesRegex|f_blnFilterLines3|f_blnFilterLines4", "|")[Mod(saRetreivedCommandDetail[2], 10)].Value := 1
GuiEditCommandFilterLinesTypeChanged()
ogcEditf_strFilterLinesCriteriaList.Add([DecodeEolAndTab(StrReplace(saRetreivedCommandDetail[3], g_strEscapePipe, ", "`"))"])
ogc% StrSplit("f_blnFilterLinesAnd|f_blnFilterLinesOr|f_blnFilterLinesNotAll|f_blnFilterLinesNotAny", "|")[saRetreivedCommandDetail[4]].Value := 1
ogcEditf_strFilterLinesCriteriaRegex.Add([DecodeEolAndTab(StrReplace(saRetreivedCommandDetail[5], g_strEscapePipe, ", "`"))"])
ogcCheckboxf_blnFilterLinesCase.Value := saRetreivedCommandDetail[6] = 1
}
else if (strRetrievedCommandType = "FilterCharacters")
{
ogcRadiof_blnFilterCharactersDelete.Text := saRetreivedCommandDetail[3] < 10
ogcRadiof_blnFilterCharactersKeep.Text := saRetreivedCommandDetail[3] > 10
GuiEditCommandFilterCharactersChanged()
ogcEditf_strFilterCharactersList.Add([StrReplace(saRetreivedCommandDetail[2], g_strEscapePipe, ", "`")"])
ogc% StrSplit("f_blnFilterCharactersEverywhere|f_blnDeleteCharactersBeginEnd|f_blnDeleteCharactersBegin|f_blnDialogDeleteCharactersEnd", "|")[Mod(saRetreivedCommandDetail[3], 10)].Value := 1
ogcCheckboxf_blnFilterCharactersCase.Value := saRetreivedCommandDetail[4] = 1
}
else if (strRetrievedCommandType = "ReformatPara")
{
ogcRadiof_blnEditReformatParaSeparated.Text := saRetreivedCommandDetail[2] = 1
ogcf_intEditReformatParaLineWidth.Value := saRetreivedCommandDetail[3]
Sleep(10)
ogcRadiof_radReformatParaAlignLeft.Text := saRetreivedCommandDetail[4] = 0
ogcRadiof_radReformatParaAlignIndent.Text := saRetreivedCommandDetail[4] = 1
ogcRadiof_radReformatParaAlignRight.Text := saRetreivedCommandDetail[4] = 2
ogcRadiof_radReformatParaAlignCenter.Text := saRetreivedCommandDetail[4] = 3
Sleep(10)
ogcf_strEditReformatParaIndentCharactersFirst.Value := saRetreivedCommandDetail[5]
ogcf_strEditReformatParaIndentCharactersOther.Value := saRetreivedCommandDetail[6]
ogcCheckboxf_blnEditReformatParaPunct.Value := saRetreivedCommandDetail[7] = 1
ogcf_strEditReformatParaPunct1Space.Value := saRetreivedCommandDetail[8]
ogcf_strEditReformatParaPunct2Spaces.Value := saRetreivedCommandDetail[9]
ogcf_strEditReformatParaPunctUpperAfter.Value := saRetreivedCommandDetail[10]
ogcf_strEditReformatParaPunct1SpaceBefore.Value := saRetreivedCommandDetail[11]
GuiEditCommandReformatParaLineWidthChanged()
GuiEditCommandReformatParaPunctChanged()
}
else if (strRetrievedCommandType = "FileOpen")
{
ogcEditf_strFilePath.Value := saRetreivedCommandDetail[2]
ogcCheckboxf_blnFileOpenToEditor.Value := Mod(saRetreivedCommandDetail[3], 10) > 0
FileOpenToEditorChanged()
Loop saFileOpenToEditorAt.Length
ogc% "f_radFileOpenToEditorAt" . A_Index.Value := Mod(saRetreivedCommandDetail[3], 10) = A_Index
ogcCheckboxf_blnFileOpenToClipboard.Value := saRetreivedCommandDetail[3] >= 10
ogc% "f_blnRadioFileEncoding" . saRetreivedCommandDetail[4].Value := true
}
else if (strRetrievedCommandType = "FileSave")
{
ogcEditf_strFilePath.Value := saRetreivedCommandDetail[2]
ogc% "f_blnFileSaveEOL" . saRetreivedCommandDetail[3].Value := true
ogc% "f_blnRadioFileSaveEncoding" . saRetreivedCommandDetail[4].Value := true
ogc% "f_blnFileSaveSelected".Value := saRetreivedCommandDetail[5] = true
}
else if InStr("FileClipboardBackup|FileClipboardRestore", strRetrievedCommandType)
ogcEditf_strFilePath.Value := saRetreivedCommandDetail[2]
if (A_ThisLabel = "GuiEditCommandSavedCommandChanged")
{
ogcCheckboxf_blnSaveCommand.Value := 1
ogcEditf_strSaveCommandTitle.Value := g_aaSavedCommand.strTitle
if (strRetrievedCommandType = "FindReplace")
ogcCheckboxf_blnSaveCommandReplaceAll.Value := saRetreivedCommandDetail[6] = 1
ogcCheckboxf_blnSaveCommandInMenu.Value := g_aaSavedCommand.blnInMenu = 1
ogcLinkf_lnkSaveCommandHotkey.Text := L("<a>~1~</a>", new Triggers.HotkeyParts(g_aaSavedCommand.strLocalHotkey).Hotkey2Text(false))
ogcEditf_strLocalHotkeyCode.Value := g_aaSavedCommand.strLocalHotkey
GuiSaveCommandClicked()
g_aaSavedCommand := ""
}
g_blnSavedCommandRetrieved := (A_ThisLabel = "GuiEditCommandSavedCommandChanged")
saRetreivedCommandDetail := ""
strRetrievedCommandDetail := ""
strRetrievedCommandType := ""
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiEditCommandFindRegexChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType

return
} ; V1toV2: Added bracket before function
GuiEditCommandSubStringTypeChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType









return
} ; V1toV2: Added Bracket before label
GuiEditCommandInsertStringTypeChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType





return
} ; V1toV2: Added Bracket before label
GuiEditCommandFilterLinesTypeChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
ogcRadiof_blnFilterLines3.Text := (f_blnFilterLinesDelete ? o_L["DialogDeleteLinesEmpty"] : o_L["DialogKeepLinesNumbers"])
ogcRadiof_blnFilterLines4.Text := (f_blnFilterLinesDelete ? o_L["DialogDeleteLinesBlank"] : o_L["DialogKeepLinesLetters"])


strCommand := (f_blnFilterLinesContaining ? "Enable" : "Disable")




strCommand := ""
return
} ; V1toV2: Added Bracket before label
GuiEditCommandFilterCharactersChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
ogcTextf_lblFilterCharactersList.Value := o_L["DialogFilterCharactersList" . (f_blnFilterCharactersDelete ? "Delete" : "Keep")]
ogcRadiof_blnFilterCharactersEverywhere.Text := o_L["DialogFilterCharactersEverywhere" . (f_blnFilterCharactersDelete ? "Delete" : "Keep")]
if (f_blnFilterCharactersKeep)
ogcRadiof_blnFilterCharactersEverywhere.Text := 1
strCommand := (f_blnFilterCharactersDelete ? "Enable" : "Disable")



strCommand := ""
return
} ; V1toV2: Added Bracket before label
GuiEditCommandReformatParaLineWidthChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
strCommand := (f_intEditReformatParaLineWidth > 0 ? "Enable" : "Disable")












strCommand := ""
GuiEditCommandReformatParaAlignChanged()
return
} ; V1toV2: Added Bracket before label
GuiEditCommandReformatParaAlignChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
strCommand := (f_radReformatParaAlignIndent ? "Enable" : "Disable")







strCommand := ""
return
} ; V1toV2: Added Bracket before label
GuiEditCommandReformatParaPunctChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
strCommand := (f_blnEditReformatParaPunct ? "Enable" : "Disable")








strCommand := ""
return
} ; V1toV2: Added Bracket before label
ReformatParaPunctDefaultClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Edit_Settext(strPunct1SpaceHwnd, ".!?,;:")
Edit_Settext(strPunct2SpacesHwnd, ".!?")
Edit_Settext(strPunct1SpaceBeforeHwnd, "")
Edit_Settext(strPunctUpperAfterHwnd, ".!?")
Edit_SetFocus(strPunct1SpaceHwnd)
return
} ; V1toV2: Added bracket before function
InsertStringInvisibleKeysClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
SubStringFromInvisibleKeysClicked:
SubStringToInvisibleKeysClicked:
FilterLinesInvisibleKeysClicked:
FilterCharactersInvisibleKeysClicked:
FindOrReplaceWhatInvisibleKeysClicked:
FindOrReplaceWithInvisibleKeysClicked:
CopyAppendSeparatorInvisibleKeysClicked:
IndentCharactersFirstInvisibleKeysClicked:
IndentCharactersOtherInvisibleKeysClicked:
oGui2.Opt("+OwnDialogs")
strControl := StrReplace(A_ThisLabel, "InvisibleKeysClicked")
strHwnd := str%strControl%Hwnd
if (ErrorLevel = "Tab")
Edit_ReplaceSel(strHwnd, "``t")
else if (ErrorLevel = "Enter")
Edit_ReplaceSel(strHwnd, "``n")
else if (ErrorLevel = "Code")
{
IB := InputBox(o_L["DialogInvisibleCodePrompt"], o_L["DialogInvisibleCodeTitle"], "w220 h145"), intCode := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
Edit_ReplaceSel(strHwnd, Chr(StrReplace(intCode, "U+", "0X")))
}
else if (ErrorLevel = "Numbers")
Edit_ReplaceSel(strHwnd, "0123456789")
Edit_SetFocus(strHwnd)
return
} ; V1toV2: Added Bracket before label
GuiEditCommandSortTypeChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
if (f_strSortOptionLength)
{
Loop Parse, "N|C|CL|N|BS|P|U|Random", "|"
ogc% "f_strSortOption" . A_LoopField.Enabled := false
ogcf_strSortOptionR.Enabled := true
g_strSortOptions := "Length" . (f_strSortOptionR ? "R" : "")
return
}
Loop Parse, "R|C|CL|N|BS|P|Length", "|"







g_strSortOptions := ""
Loop Parse, "R |C |CL |N |U |BS |Random |P ", "|"
{
blnSortOptionOn := ogc% "f_strSortOption" . Trim(A_LoopField).Text
blnSortOptionEnabled := ogc% "f_strSortOption" . Trim(A_LoopField).Enabled
if (blnSortOptionOn and blnSortOptionEnabled)
if (A_LoopField = "BS ")
g_strSortOptions .= "\ "
else if (A_LoopField = "P ")
g_strSortOptions .= "P" . f_intSortOptionPosition . " "
else
g_strSortOptions .= A_LoopField
}
blnSortOptionOn := ""
blnSortOptionEnabled := ""
return
} ; V1toV2: Added Bracket before label
ButtonSelectFileClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oGui2.Opt("+OwnDialogs")
strFile := FileSelect((A_GuiControl = "f_ButtonSelectFileOpen" ? 1 : "S.Length"), "", o_L["DialogSelectFile"])
ogcEditf_strFilePath.Value := strFile
strFile := ""
return
} ; V1toV2: Added bracket before function
ChangeCaseLower()
{ ; V1toV2: Added bracket
ChangeCaseUpper()
{ ; V1toV2: Added bracket
ChangeCaseTitle()
{ ; V1toV2: Added bracket
ChangeCaseSentence()
{ ; V1toV2: Added bracket
ChangeCaseToggle()
{ ; V1toV2: Added bracket
ChangeCaseSaRcAsM()
{ ; V1toV2: Added bracket
if IsReadOnly()
return
new EditCommand("ChangeCase").ExecChangeCase(A_ThisLabel)
return
} ; V1toV2: Added Bracket before label
EditURIEncode(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
EditURIDecode:
EditXMLEncode:
EditXMLEncodeNumeric:
EditXMLDecode:
EditHexEncode:
EditHexDecode:
EditASCIIEncode:
EditASCIIDecode:
EditHTMLEncode:
EditHTMLDecode:
EditPHPDoubleEncode:
EditPHPDoubleDecode:
EditPHPSingleEncode:
EditPHPSingleDecode:
EditAHKEncode:
EditAHKDecode:
EditAHKVarExpressionEncode:
EditAHKVarExpressionDecode:
EditClipboardAllBase64Encode:
EditClipboardAllBase64Decode:
EditClipboardImageBase64Encode:
EditClipboardImageBase64Decode:
if IsReadOnly()
return
new EditCommand("Convert").ExecConvert(A_ThisLabel)
return
} ; V1toV2: Added Bracket before label
EditCommandPrepare(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GuiSaveCommandTitleSuggest:
EditComamndSaveOnly:
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
oGui2.Opt("+OwnDialogs")
if (A_ThisLabel = "EditCommandPrepare")
AddToUndoPile()
strPrepareCommandType := f_strEditCommandType
if (strPrepareCommandType = "SubString")
{
strSubStringButton := A_GuiControl
if (f_blnRadioSubStringFromPosition and !StrLen(f_intRadioSubStringFromPosition))
or ((f_blnRadioSubStringLength or f_blnRadioSubStringToBeforeEnd) and !StrLen(f_intSubStringCharacters))
or ((f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText) and !StrLen(f_strRadioSubStringFromText))
or ((f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText) and !StrLen(f_strSubStringToText))
{
if (A_ThisLabel = "EditCommandPrepare")
Oops(2, o_L["OopsValueMissing"])
return
}
if (f_blnRadioSubStringFromStart)
intSubStringFromType := 1
else if (f_blnRadioSubStringFromPosition)
intSubStringFromType := 2
else if (f_blnRadioSubStringFromBeginText)
intSubStringFromType := 3
else if (f_blnRadioSubStringFromEndText)
intSubStringFromType := 4
else
return
intFromPosition := (f_blnRadioSubStringFromPosition ? f_intRadioSubStringFromPosition : "")
strFromText := (f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText ? f_strRadioSubStringFromText : "")
intFromPlusMinus := (f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText ? f_intSubStringFromPlusMinus : "")
saTypes := StrSplit(o_L["DialogSubStringFromTypes"], "|")
strSaveCommandTitle := (strSubStringButton = "f_btnRemove" ? o_L["DialogRemove"] : o_L["DialogKeep"]) . " " . o_L["DialogFromLower"] . " " . saTypes[intSubStringFromType]
strSaveCommandTitle .= (f_blnRadioSubStringFromPosition ? " " . intFromPosition : "")
strSaveCommandTitle .= (f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText ? " '" . f_strRadioSubStringFromText . "'" : "")
strSaveCommandTitle .= ((f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText) and (f_intSubStringFromPlusMinus > 0) ? " +" . f_intSubStringFromPlusMinus : "")
strSaveCommandTitle .= ((f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText) and (f_intSubStringFromPlusMinus < 0) ? " " . f_intSubStringFromPlusMinus : "")
strSaveCommandTitle .= ((f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText) and Abs(f_intSubStringFromPlusMinus) = 1 ? " " . o_L["DialogCharacter"] : "")
strSaveCommandTitle .= ((f_blnRadioSubStringFromBeginText or f_blnRadioSubStringFromEndText) and Abs(f_intSubStringFromPlusMinus) > 1 ? " " . o_L["DialogCharacters"] : "")
if (f_blnRadioSubStringToEnd)
intSubStringToType := 1
else if (f_blnRadioSubStringLength)
intSubStringToType := 2
else if (f_blnRadioSubStringToBeforeEnd)
intSubStringToType := 3
else if (f_blnRadioSubStringToBeginText)
intSubStringToType := 4
else if (f_blnRadioSubStringToEndText)
intSubStringToType := 5
else
return
intSubStringToLength := (f_blnRadioSubStringLength ? f_intSubStringCharacters : (f_blnRadioSubStringToBeforeEnd ? -f_intSubStringCharacters : ""))
strSubStringToText := (f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText ? f_strSubStringToText : "")
intSubStringToPlusMinus := (f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText ? f_intSubStringToPlusMinus : "")
saTypes := StrSplit(o_L["DialogSubStringToTypes"], "|")
strSaveCommandTitle .= (f_blnRadioSubStringLength ? " " . o_L["DialogForLower"] . " " . intSubStringToLength . " " . saTypes[intSubStringToType] : "")
strSaveCommandTitle .= (f_blnRadioSubStringToEnd ? " " . saTypes[intSubStringToType] : "")
strSaveCommandTitle .= (f_blnRadioSubStringToBeforeEnd ? " " . o_L["DialogToLower"] . " " . -intSubStringToLength . " " . saTypes[intSubStringToType] : "")
strSaveCommandTitle .= (f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText ? " " . saTypes[intSubStringToType] : "")
strSaveCommandTitle .= (f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText ? " '" . strSubStringToText . "'" : "")
strSaveCommandTitle .= ((f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText) and (intSubStringToPlusMinus > 0) ? " +" . intSubStringToPlusMinus : "")
strSaveCommandTitle .= ((f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText) and (intSubStringToPlusMinus < 0) ? " " . intSubStringToPlusMinus : "")
strSaveCommandTitle .= ((f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText) and Abs(intSubStringToPlusMinus) = 1 ? " " . o_L["DialogCharacter"] : "")
strSaveCommandTitle .= ((f_blnRadioSubStringToBeginText or f_blnRadioSubStringToEndText) and Abs(intSubStringToPlusMinus) > 1 ? " " . o_L["DialogCharacters"] : "")
strPrepareCommandDetail := strPrepareCommandType . "|" . (strSubStringButton = "f_btnRemove" ? "Remove" : "Keep") . "|" . intSubStringFromType. "|" . intFromPosition . "|" . StrReplace(strFromText, "|", g_strEscapePipe) . "|" . intFromPlusMinus . "|". intSubStringToType . "|" . intSubStringToLength . "|" . StrReplace(strSubStringToText, "|", g_strEscapePipe) . "|" . intSubStringToPlusMinus
}
else if (strPrepareCommandType = "InsertString")
{
if !StrLen(f_strInsertString)
or (f_blnRadioInsertStringFromPosition and !StrLen(f_intRadioInsertStringFromPosition))
or ((f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText) and !StrLen(f_strRadioInsertStringFromText))
or ((f_blnRadioInsertStringToBeginText or f_blnRadioInsertStringToEndText) and !StrLen(f_strRadioInsertStringToText))
{
if (A_ThisLabel = "EditCommandPrepare")
Oops(2, o_L["OopsValueMissing"])
return
}
if (f_blnRadioInsertStringFromStart)
intInsertStringFromType := 1
else if (f_blnRadioInsertStringFromPosition)
intInsertStringFromType := 2
else if (f_blnRadioInsertStringFromBeginText)
intInsertStringFromType := 3
else if (f_blnRadioInsertStringFromEndText)
intInsertStringFromType := 4
else if (f_blnRadioInsertStringAtTheEnd)
intInsertStringFromType := 5
else
return
intFromPosition := (f_blnRadioInsertStringFromPosition ? f_intRadioInsertStringFromPosition : "")
strFromText := (f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText ? f_strRadioInsertStringFromText : "")
intFromPlusMinus := (f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText ? f_intFromPlusMinus : "")
saTypes := StrSplit(o_L["DialogInsertStringTypes"], "|")
strSaveCommandTitle := o_L["DialogInsert"] " '" . f_strInsertString . "' "
strSaveCommandTitle .= saTypes[intInsertStringFromType]
strSaveCommandTitle .= (f_blnRadioInsertStringFromPosition ? " " . f_intRadioInsertStringFromPosition : "")
strSaveCommandTitle .= (f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText ? " '" . f_strRadioInsertStringFromText . "'" : "")
strSaveCommandTitle .= ((f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText) and (f_intFromPlusMinus > 0) ? " +" . f_intFromPlusMinus : "")
strSaveCommandTitle .= ((f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText) and (f_intFromPlusMinus < 0) ? " " . f_intFromPlusMinus : "")
strSaveCommandTitle .= ((f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText) and Abs(f_intFromPlusMinus) = 1 ? " " . o_L["DialogCharacter"] : "")
strSaveCommandTitle .= ((f_blnRadioInsertStringFromBeginText or f_blnRadioInsertStringFromEndText) and Abs(f_intFromPlusMinus) > 1 ? " " . o_L["DialogCharacters"] : "")
strPrepareCommandDetail := strPrepareCommandType . "|" . StrReplace(f_strInsertString, "|", g_strEscapePipe) . "|" . intInsertStringFromType. "|" . intFromPosition . "|" . StrReplace(strFromText, "|", g_strEscapePipe) . "|" . intFromPlusMinus
}
else if (strPrepareCommandType = "FilterLines")
{
if (f_blnFilterLinesContaining and !StrLen(f_strFilterLinesCriteriaList)
or (f_blnFilterLinesRegEx) and !StrLen(f_strFilterLinesCriteriaRegex))
{
if (A_ThisLabel = "EditCommandPrepare")
Oops(2, o_L["OopsValueMissing"])
return
}
if (f_blnFilterLinesContaining)
intFilterLinesType := 1
else if (f_blnFilterLinesRegEx)
intFilterLinesType := 2
else if (f_blnFilterLines3)
intFilterLinesType := 3
else if (f_blnFilterLines4)
intFilterLinesType := 4
else
return
intFilterLinesType += (f_blnFilterLinesKeep ? 10 : 0)
strFilterLinesCriteriaList := f_strFilterLinesCriteriaList
strFilterLinesCriteriaRegex := f_strFilterLinesCriteriaRegex
blnFilterLinesCase := f_blnFilterLinesCase
if (Mod(intFilterLinesType, 10) = 1)
if (f_blnFilterLinesAnd)
intFilterLinesContainingType := 1
else if (f_blnFilterLinesOr)
intFilterLinesContainingType := 2
else if (f_blnFilterLinesNotAll)
intFilterLinesContainingType := 3
else if (f_blnFilterLinesNotAny)
intFilterLinesContainingType := 4
saTypes := StrSplit(o_L["DialogFilterLinesTypes"], "|")
strSaveCommandTitle := o_L["EditFilterLines"] . ": " . (intFilterLinesType > 10 ? o_L["DialogKeep"] : o_L["DialogDelete"] ) . " "
strSaveCommandTitle .= saTypes[intFilterLinesType]
if (Mod(intFilterLinesType, 10) = 1)
{
saTypes := StrSplit(o_L["DialogLinesContainingTypes"], "|")
strSaveCommandTitle .= (Edit_GetLineCount(strFilterLinesHwnd) > 1 ? " " . saTypes[intFilterLinesContainingType] : ""). " '" . StrReplace(strFilterLinesCriteriaList, "`n", Chr(8626)) . "'". (f_blnFilterLinesCase ? ", " . Format("{1:L}", o_L["DialogCaseSensitive"]) : "")
}
else if (Mod(intFilterLinesType, 10) = 2)
strSaveCommandTitle .= " """ . strFilterLinesCriteriaRegex . """"
strPrepareCommandDetail := strPrepareCommandType . "|" . intFilterLinesType . "|" . EncodeEolAndTab(Trim(StrReplace(strFilterLinesCriteriaList, "|", g_strEscapePipe), " `t`n")). "|" . intFilterLinesContainingType . "|" . StrReplace(strFilterLinesCriteriaRegex, "|", g_strEscapePipe) . "|" . blnFilterLinesCase
}
else if (strPrepareCommandType = "FilterCharacters")
{
if !StrLen(f_strFilterCharactersList)
{
if (A_ThisLabel = "EditCommandPrepare")
Oops(2, o_L["OopsValueMissing"])
return
}
if (f_blnFilterCharactersEverywhere)
intFilterCharactersType := 1
else if (f_blnDeleteCharactersBeginEnd)
intFilterCharactersType := 2
else if (f_blnDeleteCharactersBegin)
intFilterCharactersType := 3
else if (f_blnDialogDeleteCharactersEnd)
intFilterCharactersType := 4
else
return
intFilterCharactersType += (f_blnFilterCharactersKeep ? 10 : 0)
strFilterCharactersList := f_strFilterCharactersList
blnFilterCharactersCase := f_blnFilterCharactersCase
saTypes := StrSplit(o_L["DialogFilterCharactersTypes"], "|")
strSaveCommandTitle := o_L["EditFilterCharacters"] . ": " . (intFilterCharactersType > 10 ? o_L["DialogKeepCharacters"] : o_L["DialogDeleteCharacters"] ) . " '" . f_strFilterCharactersList . "' "
strSaveCommandTitle .= saTypes[Mod(intFilterCharactersType, 10)] . (f_blnFilterCharactersCase ? ", " . Format("{1:L}", o_L["DialogCaseSensitive"]) : "")
strPrepareCommandDetail := strPrepareCommandType . "|" . StrReplace(strFilterCharactersList, "|", g_strEscapePipe) . "|" . intFilterCharactersType . "|" . blnFilterCharactersCase
}
else if (strPrepareCommandType = "ReformatPara")
{
blnEditReformatParaSeparated := f_blnEditReformatParaSeparated
intEditReformatParaLineWidth := f_intEditReformatParaLineWidth
if !(intEditReformatParaLineWidth)
intEditReformatParaAlignType := ""
else
if (f_radReformatParaAlignLeft)
intEditReformatParaAlignType := 0
else if (f_radReformatParaAlignIndent)
intEditReformatParaAlignType := 1
else if (f_radReformatParaAlignRight)
intEditReformatParaAlignType := 2
else if (f_radReformatParaAlignCenter)
intEditReformatParaAlignType := 3
strEditReformatParaIndentCharactersFirst := (intEditReformatParaAlignType = 1 ? f_strEditReformatParaIndentCharactersFirst : "")
strEditReformatParaIndentCharactersOther := (intEditReformatParaAlignType = 1 ? f_strEditReformatParaIndentCharactersOther : "")
blnEditReformatParaPunct := f_blnEditReformatParaPunct
strEditReformatParaPunct1Space := (blnEditReformatParaPunct ? f_strEditReformatParaPunct1Space : "")
strEditReformatParaPunct2Spaces := (blnEditReformatParaPunct ? f_strEditReformatParaPunct2Spaces : "")
strEditReformatParaPunct1SpaceBefore := (blnEditReformatParaPunct ? f_strEditReformatParaPunct1SpaceBefore : "")
strEditReformatParaPunctUpperAfter := (blnEditReformatParaPunct ? f_strEditReformatParaPunctUpperAfter : "")
strSaveCommandTitle := o_L["TypeReformatPara"] . ": " . (blnEditReformatParaSeparated ? o_L["EditReformatParaSeparatedTitle"] : o_L["EditReformatParaMergedTitle"]). " " . (intEditReformatParaLineWidth > 0 ? L(o_L["EditReformatParaLineWidthTitle"], intEditReformatParaLineWidth) : o_L["EditReformatParaLineWidthZeroTitle"])
if (intEditReformatParaLineWidth)
{
saAlignTypes := StrSplit("Left|Indent|Right|Center", "|")
strSaveCommandTitle .= ", " . L(o_L["EditReformatParaAlignTitle"], Format("{1:L}", o_L["EditReformatParaAlign" . saAlignTypes[intEditReformatParaAlignType + 1]]))
}
strSaveCommandTitle .= (blnEditReformatParaPunct ? ", " . o_L["EditReformatParaPunctTitle"] : "")
strPrepareCommandDetail := strPrepareCommandType . "|" . blnEditReformatParaSeparated . "|" . intEditReformatParaLineWidth . "|" . intEditReformatParaAlignType. "|" . StrReplace(strEditReformatParaIndentCharactersFirst, "|", g_strEscapePipe) . "|" . StrReplace(strEditReformatParaIndentCharactersOther, "|", g_strEscapePipe). "|" . blnEditReformatParaPunct . "|" . StrReplace(strEditReformatParaPunct1Space, "|", g_strEscapePipe). "|" . StrReplace(strEditReformatParaPunct2Spaces, "|", g_strEscapePipe) . "|" . StrReplace(strEditReformatParaPunctUpperAfter, "|", g_strEscapePipe). "|" . StrReplace(strEditReformatParaPunct1SpaceBefore, "|", g_strEscapePipe)
}
else if (strPrepareCommandType = "SortOptions")
{
strSaveCommandTitle := o_L["TypeSort"] ": "
Loop Parse, "R |N |C |CL |P|BS |U |Random |Length", "|"
{
blnSortOptionOn := ogc% "f_strSortOption" . Trim(A_LoopField).Text
blnSortOptionEnabled := ogc% "f_strSortOption" . Trim(A_LoopField).Enabled
if (blnSortOptionOn and blnSortOptionEnabled)
{
strSortLabel := o_L["DialogSortOption" . Trim(A_LoopField)]
strSaveCommandTitle .= (InStr(strSortLabel, " (") ? SubStr(strSortLabel, 1, InStr(strSortLabel, " (") - 1) : strSortLabel). (A_LoopField = "P" ? " " . f_intSortOptionPosition : "") . "+"
}
}
strSaveCommandTitle := SubStr(strSaveCommandTitle, 1, -1)
strPrepareCommandDetail := strPrepareCommandType . "|" . g_strSortOptions . "|" . f_intSortOptionPosition
}
else if InStr(strPrepareCommandType, "Find")
{
strSaveCommandTitle := o_L["Type" . strPrepareCommandType] ": '" . f_strFindOrReplaceWhat . "'". (strPrepareCommandType = "FindReplace" ? " " . o_L["DialogWith"] . "'" . f_strFindOrReplaceWith . "'" : "")
if (f_blnFindOrReplaceRegEx)
strSaveCommandTitle .= " (" . o_L["EditFindRegEx"] . ")"
else if (f_blnFindOrReplaceMatchCase)
strSaveCommandTitle .= " (" . o_L["EditReplaceMatchCase"] . ")"
strPrepareCommandDetail := strPrepareCommandType . "|" . StrReplace(f_strFindOrReplaceWhat, "|", g_strEscapePipe) . "|". StrReplace(f_strFindOrReplaceWith, "|", g_strEscapePipe) . "|" . f_blnFindOrReplaceMatchCase . "|" . f_blnFindOrReplaceRegEx
}
else if InStr("FileOpen|FileSave|FileClipboardBackup|FileClipboardRestore", strPrepareCommandType)
{
if (!StrLen(f_strFilePath) or (strPrepareCommandType = "FileOpen" and !(f_blnFileOpenToEditor or f_blnFileOpenToClipboard)))
{
if (A_ThisLabel = "EditCommandPrepare")
Oops(2, o_L["OopsValueMissing"])
return
}
strFilePath := f_strFilePath
if (InStr("FileSave|FileClipboardBackup", strPrepareCommandType) and FileExist(strFilePath))
{
msgResult := MsgBox(4, %g_strAppNameText%, % L(o_L["DialogFileSaveOverwrite"], strFilePath))
if (msgResult = "Yes")
blnOverwrite := true
if !(blnOverwrite)
return
}
if (strPrepareCommandType = "FileOpen")
{
intFileOpenToEditorReplaceOrInsert := (f_blnFileOpenToEditor ? (f_radFileOpenToEditorAt1 ? 1 : 2) : 0)
intFileOpenTo := (f_blnFileOpenToEditor ? intFileOpenToEditorReplaceOrInsert : 0) + (f_blnFileOpenToClipboard ? 10 : 0)
}
else if (strPrepareCommandType = "FileSave")
{
Loop saEolList.Length
{
intFileSaveEol:= A_Index
if f_blnRadioFileSaveEol%A_Index%
break
}
blnFileSaveSelected := f_blnFileSaveSelected
}
if InStr("FileOpen|FileSave", strPrepareCommandType)
Loop saEncodingList.Length
{
intFileEncoding := A_Index
if f_blnRadioFileEncoding%A_Index%
break
}
if (strPrepareCommandType = "FileOpen")
strSaveCommandTitle := o_L["TypeFileOpen"] . (Mod(intFileOpenTo, 10) ? " (" . saFileOpenToEditorAt[Mod(intFileOpenTo, 10)] . ") " : "") . "'". strFilePath . "' (" . saEncodingList[intFileEncoding] . ") " . (Mod(intFileOpenTo, 10) ? o_L["DialogFileOpenToEditor"] : ""). (intFileOpenTo > 10 ? " + " : "") . (intFileOpenTo > 1 ? o_L["DialogFileOpenToClipboard"] : "")
else if (strPrepareCommandType = "FileSave")
{
saEolFormatCodes := ["", "Unix", "Mac"]
if (intFileEncoding = 6)
strEncoding := "CP" . o_Settings.Various.intFileEncodingCodePage.IniValue
else
strEncoding := saEncodingList[intFileEncoding]
strSaveCommandTitle := o_L["TypeFileSave"] . " '" . strFilePath . "' (" . (blnFileSaveSelected ? o_L["DialogFileSaveSelected"] . ", " : ""). strEncoding . (intFileSaveEol > 1 ? ", " . saEolFormatCodes[intFileSaveEol] : "") . ")"
}
else if InStr("FileClipboardBackup|FileClipboardRestore", strPrepareCommandType)
strSaveCommandTitle := o_L["Type" . strPrepareCommandType] .  " '" . strFilePath . "'"
strPrepareCommandDetail := strPrepareCommandType . "|" . strFilePath . "|" . (strPrepareCommandType = "FileOpen" ? intFileOpenTo
: (strPrepareCommandType = "FileSave" ? intFileSaveEol : "")) . (InStr("FileOpen|FileSave", strPrepareCommandType) ? "|" . intFileEncoding : ""). (strPrepareCommandType = "FileSave" ? "|" . blnFileSaveSelected : "")
}
if (A_ThisLabel = "GuiSaveCommandTitleSuggest")
{
ogcEditf_strSaveCommandTitle.Value := strSaveCommandTitle
return
}
if (f_blnSaveCommand and !g_blnSavedCommandRetrieved)
{
if !StrLen(f_strSaveCommandTitle)
{
Oops(2, o_L["OopsValueMissing"])
return
}
if InStr(f_strSaveCommandTitle, "|")
{
Oops(2, o_L["OopsNoPipe"])
return
}
if GetSavedCommand(f_strSaveCommandTitle)
{
msgResult := MsgBox(o_L["GuiSaveCommandReplace"], g_strAppNameText, 4)
if (msgResult = "No")
return
}
}
2GuiClose()
g_aaEditCommand := new EditCommand(strPrepareCommandType)
if (A_ThisLabel = "EditCommandPrepare")
{
if (strPrepareCommandType = "Find")
{
while g_aaEditCommand.ExecFind(f_strFindOrReplaceWhat, f_blnFindOrReplaceMatchCase, f_blnFindOrReplaceRegEx, A_Index = 1)
{
ogc%g_strEditorControlHwnd%.Focus()
Edit_ScrollCaret(g_strEditorControlHwnd)
strNext := GuiFindReplaceNext(o_L["EditFindNext"], o_L["DialogContinue"])
if (strNext = "No")
break
}
}
else if (strPrepareCommandType = "FindReplace")
{
if (f_blnSavedCommandReplaceAll)
{
g_aaEditCommand.InitFindReplace(f_strFindOrReplaceWhat, f_strFindOrReplaceWith, f_blnFindOrReplaceMatchCase, f_blnFindOrReplaceRegEx)
g_aaEditCommand.ExecFindReplaceAllToEnd()
}
else
{
blnReplaceYes := false
while g_aaEditCommand.ExecFindReplace(f_strFindOrReplaceWhat, f_strFindOrReplaceWith, f_blnFindOrReplaceMatchCase, f_blnFindOrReplaceRegEx, blnReplaceYes, A_Index = 1)
{
Edit_ScrollCaret(g_strEditorControlHwnd)
strNext := GuiFindReplaceNext(o_L["EditFindReplace"], o_L["EditReplacePrompt"])
if (strNext = "Yes")
blnReplaceYes := true
else if (strNext = "No")
blnReplaceYes := false
else if (strNext = "All")
{
g_aaEditCommand.ExecFindReplace(f_strFindOrReplaceWhat, f_strFindOrReplaceWith, f_blnFindOrReplaceMatchCase, f_blnFindOrReplaceRegEx, true, false, true)
g_aaEditCommand.ExecFindReplaceAllToEnd()
break
}
if (strNext = "Cancel")
{
g_aaEditCommand.ExecFindReplace(f_strFindOrReplaceWhat, f_strFindOrReplaceWith, f_blnFindOrReplaceMatchCase, f_blnFindOrReplaceRegEx, false, false, true)
break
}
}
}
}
else if (strPrepareCommandType = "SubString")
g_aaEditCommand.ExecSubString(strSubStringButton, intSubStringFromType, intFromPosition, strFromText, intFromPlusMinus, intSubStringToType, intSubStringToLength, strSubStringToText, intSubStringToPlusMinus)
else if (strPrepareCommandType = "InsertString")
g_aaEditCommand.ExecInsertString(f_strInsertString, intInsertStringFromType, intFromPosition, strFromText, intFromPlusMinus)
else if (strPrepareCommandType = "FilterLines")
g_aaEditCommand.ExecFilterLines(intFilterLinesType, strFilterLinesCriteriaList, intFilterLinesContainingType, strFilterLinesCriteriaRegex, blnFilterLinesCase)
else if (strPrepareCommandType = "FilterCharacters")
g_aaEditCommand.ExecFilterCharacters(strFilterCharactersList, intFilterCharactersType, blnFilterCharactersCase)
else if (strPrepareCommandType = "ReformatPara")
g_aaEditCommand.ExecReformatPara(blnEditReformatParaSeparated, intEditReformatParaLineWidth, intEditReformatParaAlignType, strEditReformatParaIndentCharactersFirst, strEditReformatParaIndentCharactersOther, blnEditReformatParaPunct, strEditReformatParaPunct1Space, strEditReformatParaPunct2Spaces, strEditReformatParaPunctUpperAfter, strEditReformatParaPunct1SpaceBefore)
else if (strPrepareCommandType = "SortOptions")
g_aaEditCommand.ExecSortOptions(g_strSortOptions)
else if (strPrepareCommandType = "FileOpen")
g_aaEditCommand.ExecFileOpen(strFilePath, intFileOpenTo, intFileEncoding)
else if (strPrepareCommandType = "FileSave")
g_aaEditCommand.ExecFileSave(strFilePath, intFileSaveEol, intFileEncoding, blnFileSaveSelected)
else if (strPrepareCommandType = "FileClipboardBackup")
g_aaEditCommand.ExecFileClipboardBackup(strFilePath)
else if (strPrepareCommandType = "FileClipboardRestore")
g_aaEditCommand.ExecFileClipboardRestore(strFilePath)
if InStr(strPrepareCommandType, "Find") or (strPrepareCommandType = "FileSave") or (strPrepareCommandType = "FileOpen" and intFileOpenTo = 2)
g_aaEditCommandTypes[strPrepareCommandType].aaLastEditCommand := g_aaEditCommand
g_aaEditCommand.strPrepareCommandDetail := strPrepareCommandDetail
Edit_ScrollCaret(g_strEditorControlHwnd)
EditorContentChanged()
}
if (f_blnSaveCommand)
{
g_aaEditCommand.strTitle := f_strSaveCommandTitle
g_aaEditCommand.strDetail := strPrepareCommandDetail
g_aaEditCommand.blnInMenu := f_blnSaveCommandInMenu
g_aaEditCommand.strLocalHotkey := f_strLocalHotkeyCode
if (g_aaEditCommand.strCommandType = "FindReplace" and f_blnSaveCommandReplaceAll)
g_aaEditCommand.strDetail .= "|" . 1
g_aaEditCommand.SaveCommand()
RefreshSavedCommandsMenuAndHotkeys()
}
EditCommandPrepareCleanUp:
strSubStringButton := ""
intSubStringFromType := ""
intFromPosition := ""
strFromText := ""
intFromPlusMinus := ""
intSubStringToType := ""
intSubStringToLength := ""
strSubStringToText := ""
intSubStringToPlusMinus := ""
strInsertString := ""
strNext := ""
strFilePath := ""
intFileOpenTo := ""
intFileEncoding := ""
intFileSaveEol := ""
blnFileSaveSelected := ""
intFileSaveEncoding := ""
strSortLabel := ""
blnSortOptionEnabled := ""
blnSortOptionOn := ""
saTypes := ""
strSaveCommandTitle := ""
strPrepareCommandDetail := ""
blnEditReformatParaSeparated := ""
intFilterCharactersType := ""
intFilterCharactersType := ""
intFilterCharactersType := ""
intFilterCharactersType := ""
strEditReformatParaIndentCharactersFirst := ""
strEditReformatParaIndentCharactersOther := ""
blnEditReformatParaPunct := ""
strEditReformatParaPunct1Space := ""
strEditReformatParaPunct2Spaces := ""
strEditReformatParaPunct1SpaceBefore := ""
strEditReformatParaPunctUpperAfter := ""
return
} ; V1toV2: Added Bracket before label
SavedCommandHotkeyClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
strSavedCommandHotkey := SelectShortcut(f_strLocalHotkeyCode, f_strSaveCommandTitle . " (" . o_L["DialogHotkeyLocal"] . ")", 3)
if StrLen(strSavedCommandHotkey)
{
ogcEditf_strLocalHotkeyCode.Value := strSavedCommandHotkey
ogcLinkf_lnkSaveCommandHotkey.Text := L("<a>~1~</a>", new Triggers.HotkeyParts(strSavedCommandHotkey).Hotkey2Text(false))
}
strSavedCommandHotkey := ""
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiManageSavedCommands()
{ ; V1toV2: Added bracket
intCol1Width := 80
intCol2X := intCol1Width + 15
intCol2Width := 200
intGuiContentWidth := 500
g_strManageSavedCommandsTitle := L(o_L["GuiManageSavedCommandsTitle"] . " - ~1~ ~2~", g_strAppNameText, g_strAppVersion)
oGui2.New("+Hwndg_strGui2Hwnd", )
.OnEvent("Change", _strManageSavedCommandsTitle.Bind("Change"))
oGui2.Opt("+OwnerEditor")
oGui2.Opt("+OwnDialogs")
oGui2.Add("Text", "x10 y+15 w" . intCol1Width . " right", o_L["DialogCommand"])
strManageSavedCommandsList := o_L["DialogAll"]  . "|"
Loop g_saEditCommandTypesOrder.Length
if StrLen(g_saEditCommandTypesOrder[A_Index].strTypeLabel)
strManageSavedCommandsList .= "|" . g_saEditCommandTypesOrder[A_Index].strTypeLabel
ogcDropDownListf_drpManageSavedCommandsCommand := oGui2.Add("DropDownList", "x" . intCol2X . " w" . intCol2Width . " yp  vf_drpManageSavedCommandsCommand ", [strManageSavedCommandsList])
ogcDropDownListf_drpManageSavedCommandsCommand.OnEvent("Change", GuiManageSavedCommandsFilterChanged.Bind("Change"))
oGui2.Add("Text", "x10 y+10 w" . intCol1Width . " right", o_L["DialogManageSavedCommandsFilter"])
ogcEditf_strManageSavedCommandsFilter := oGui2.Add("Edit", "x" . intCol2X . " yp w" . intCol2Width . " vf_strManageSavedCommandsFilter  x+5 yp")
ogcEditf_strManageSavedCommandsFilter.OnEvent("Change", GuiManageSavedCommandsFilterChanged.Bind("Change"))
ogcButtonX := oGui2.Add("Button", "x+5 yp", "X")
ogcButtonX.OnEvent("Click", ButtonManageSavedCommandsClearFilter.Bind("Normal"))
ogcf_blnManageSavedCommandsCheckAllNone := oGui2.Add("Checkbox", "vf_blnManageSavedCommandsCheckAllNone x15 y+10", o_L["DialogCheckAll"])
ogcf_blnManageSavedCommandsCheckAllNone.OnEvent("Click", GuiManageSavedCommandsCheckAllNoneClicked.Bind("Normal"))
ogcf_lvManageSavedCommandsList := oGui2.Add("ListView", "x10 y+5 w" . intGuiContentWidth . " Checked Count100 -LV0x10 -ReadOnly -Multi r20 vf_lvManageSavedCommandsList AltSubmit ", ["#, "`" . StrSplit(o_L[`"GuiSaveCommandPrompt`"], `"`n`")[1] . `"", "`" . o_L[`"DialogInMenu`"] . `"", "`" . o_L[`"DialogHotkeyLocal`"]"])
ogcf_lvManageSavedCommandsList.OnEvent("DoubleClick", GuiManageSavedCommandsListEvents.Bind("DoubleClick"))
ogcf_lvManageSavedCommandsList.ModifyCol(1, "Integer")
ogcf_lvManageSavedCommandsList.ModifyCol(2, 340)
ogcf_lvManageSavedCommandsList.ModifyCol(3, "center")
aaL := o_L.InsertAmpersand("DialogEdit", "DialogExecute", "DialogDelete", "GuiClose")
ogcButtonf_btnManageSavedCommandsLoad := oGui2.Add("Button", "x10 y+15 vf_btnManageSavedCommandsLoad Disabled Default", aaL["DialogEdit"])
ogcButtonf_btnManageSavedCommandsLoad.OnEvent("Click", ButtonManageSavedCommandsEdit.Bind("Normal"))
ogcButtonf_btnManageSavedCommandsExecute := oGui2.Add("Button", "x10 yp vf_btnManageSavedCommandsExecute Disabled Default", aaL["DialogExecute"])
ogcButtonf_btnManageSavedCommandsExecute.OnEvent("Click", SavedCommandsExecuteFromManage.Bind("Normal"))
ogcButtonf_btnManageSavedCommandsDelete := oGui2.Add("Button", "x40 yp vf_btnManageSavedCommandsDelete  disabled", aaL["DialogDelete"])
ogcButtonf_btnManageSavedCommandsDelete.OnEvent("Click", ButtonManageSavedCommandsDelete.Bind("Normal"))
ogcButtonf_btnManageSavedCommandsClose := oGui2.Add("Button", "x80 yp vf_btnManageSavedCommandsClose", aaL["GuiClose"])
ogcButtonf_btnManageSavedCommandsClose.OnEvent("Click", _2GuiClose.Bind("Normal"))
oGui2.Add("Text")
GuiCenterButtons(g_strGui2Hwnd, , , , , , , "f_btnManageSavedCommandsLoad", "f_btnManageSavedCommandsExecute", "f_btnManageSavedCommandsDelete", "f_btnManageSavedCommandsClose")
GuiManageSavedCommandsFilterChanged()
ShowGui2AndDisableGuiEditor()
return
} ; V1toV2: Added Bracket before label
GuiManageSavedCommandsFilterChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
f_drpManageSavedCommandsCommand := oSaved.f_drpManageSavedCommandsCommand
f_strManageSavedCommandsFilter := oSaved.f_strManageSavedCommandsFilter
f_blnManageSavedCommandsCheckAllNone := oSaved.f_blnManageSavedCommandsCheckAllNone
f_lvManageSavedCommandsList := oSaved.f_lvManageSavedCommandsList
if (f_drpManageSavedCommandsCommand = o_L["DialogAll"])
strManageSavedCommandsCommand := ""
else
for strCode, oType in g_aaEditCommandTypes
{
strManageSavedCommandsCommand := strCode
if (f_drpManageSavedCommandsCommand = oType.strTypeLabel)
break
}
oCommandsDbTable := GetSavedCommandsTable("EditDateTime DESC", strManageSavedCommandsCommand, f_strManageSavedCommandsFilter)
ogcf_lvManageSavedCommandsList.Delete()
while oCommandsDbTable.GetRow(A_Index, saCommandDbRow)
ogcf_lvManageSavedCommandsList.Add(, saCommandDbRow[4], saCommandDbRow[1], (saCommandDbRow[2] ? o_L["DialogYes"] : ""), new Triggers.HotkeyParts(saCommandDbRow[3]).Hotkey2Text(true))
if !oCommandsDbTable.GetRow(A_Index, saCommandDbRow)
ogcf_lvManageSavedCommandsList.ModifyCol("AutoHdr")
else
ogcf_lvManageSavedCommandsList.ModifyCol()
ogcf_blnManageSavedCommandsCheckAllNone.Value := 0
strManageSavedCommandsCommand := ""
oCommandsDbTable := ""
return
} ; V1toV2: Added Bracket before label
GuiManageSavedCommandsListEvents(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
if (A_GuiEvent = "RightClick")
menuSavedCommands.Show()
else if (A_GuiEvent = "DoubleClick")
ButtonManageSavedCommandsEdit()
else if (A_GuiEvent <> "I")
return
intFirstChecked := ogcf_lvManageSavedCommandsList.GetNext(,"Checked")
blnOnlyOneChecked := !ogcf_lvManageSavedCommandsList.GetNext(intFirstChecked,"Checked")



intFirstChecked := ""
blnOnlyOneChecked := ""
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
GuiManageSavedCommandsCheckAllNoneClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
f_drpManageSavedCommandsCommand := oSaved.f_drpManageSavedCommandsCommand
f_strManageSavedCommandsFilter := oSaved.f_strManageSavedCommandsFilter
f_blnManageSavedCommandsCheckAllNone := oSaved.f_blnManageSavedCommandsCheckAllNone
f_lvManageSavedCommandsList := oSaved.f_lvManageSavedCommandsList
Loop ogcf_lvManageSavedCommandsList.GetCount()
ogcf_lvManageSavedCommandsList.Modify(A_Index, "Check" . f_blnManageSavedCommandsCheckAllNone)
GuiManageSavedCommandsListEvents()
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
ButtonManageSavedCommandsClearFilter(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
ogcEditf_strManageSavedCommandsFilter.Value := ""
return
} ; V1toV2: Added Bracket before label
ButtonManageSavedCommandsDelete(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
ContextMenuManageSavedCommandsDelete:
msgResult := MsgBox(L(o_L[(A_ThisLabel = "ButtonManageSavedCommandsDelete", g_strAppNameText, 52)
? "DialogManageSavedCommandsDeleteConfirm" : "DialogManageSavedCommandsDeleteConfirmContextMenu")])
if (msgResult = "No")
return
if (A_ThisLabel = "ButtonManageSavedCommandsDelete")
{
intRow := 0
while intRow := ogcf_lvManageSavedCommandsList.GetNext(intRow,"Checked")
{
strTitle := ogcf_lvManageSavedCommandsList.GetText(intRow)
DeleteCommand(strTitle)
}
}
else
{
oGui2.Default()
intRow := ogcf_lvManageSavedCommandsList.GetNext()
strTitle := ogcf_lvManageSavedCommandsList.GetText(intRow)
DeleteCommand(strTitle)
}
RefreshSavedCommandsMenuAndHotkeys()
GuiManageSavedCommandsFilterChanged()
intRow := ""
strTitle := ""
return
} ; V1toV2: Added bracket before function
ButtonManageSavedCommandsEdit(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
oGui2.Default()
intItem := ogcf_lvManageSavedCommandsList.GetNext()
if !(intItem)
intItem := ogcf_lvManageSavedCommandsList.GetNext(,"Checked")
strSavedCommandlToLoadTitle := ogcf_lvManageSavedCommandsList.GetText(intItem)
g_aaSavedCommand := GetSavedCommand(strSavedCommandlToLoadTitle)
if (g_aaSavedCommand.strCommandType = "InsertString")
GuiEditorInsertString()
else if (g_aaSavedCommand.strCommandType = "SubString")
GuiEditorSubString()
else if (g_aaSavedCommand.strCommandType = "FilterLines")
GuiEditorFilterLines()
else if (g_aaSavedCommand.strCommandType = "FilterCharacters")
GuiEditorFilterCharacters()
else if (g_aaSavedCommand.strCommandType = "ReformatPara")
GuiEditorReformatPara()
else if (g_aaSavedCommand.strCommandType = "SortOptions")
GuiEditorSortOptions()
else if (g_aaSavedCommand.strCommandType = "Find")
GuiEditorFind()
else if (g_aaSavedCommand.strCommandType = "FindReplace")
GuiEditorFindReplace()
else if (g_aaSavedCommand.strCommandType = "FileOpen")
GuiEditorFileOpen()
else if (g_aaSavedCommand.strCommandType = "FileSave")
GuiEditorFileSave()
else if (g_aaSavedCommand.strCommandType = "FileClipboardBackup")
GuiEditorFileClipboardBackup()
else if (g_aaSavedCommand.strCommandType = "FileClipboardRestore")
GuiEditorFileClipboardRestore()
strSavedCommandlToLoadTitle := ""
return
} ; V1toV2: Added Bracket before label
SavedCommandsExecuteFromManage(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
SavedCommandsExecuteFromHotkey(ThisHotkey)
{ ; V1toV2: Added bracket
SavedCommandsExecuteFromMenu:
oGui2.Default()
if (A_ThisLabel = "SavedCommandsExecuteFromMenu")
strSavedCommandlToLoadTitle := A_ThisMenuItem
else if (A_ThisLabel = "SavedCommandsExecuteFromHotkey")
strSavedCommandlToLoadTitle := g_aaSavedCommandsHotkeys[A_ThisHotkey]
else
{
intItem := ogcf_lvManageSavedCommandsList.GetNext()
if !(intItem)
intItem := ogcf_lvManageSavedCommandsList.GetNext(,"Checked")
strSavedCommandlToLoadTitle := ogcf_lvManageSavedCommandsList.GetText(intItem)
}
aaSavedCommand := GetSavedCommand(strSavedCommandlToLoadTitle)
saDetail := StrSplit(aaSavedCommand.strDetail, "|")
if (saDetail[1] = "Find")
{
while aaSavedCommand.ExecFind(saDetail[2], saDetail[4], saDetail[5], A_Index = 1)
{
ogc%g_strEditorControlHwnd%.Focus()
Edit_ScrollCaret(g_strEditorControlHwnd)
strNext := GuiFindReplaceNext(o_L["EditFindNext"], o_L["DialogContinue"])
if (strNext = "No")
break
}
}
else if (saDetail[1] = "FindReplace")
{
if (saDetail[6])
{
aaSavedCommand.InitFindReplace(saDetail[2], saDetail[3], saDetail[4], saDetail[5])
aaSavedCommand.ExecFindReplaceAllToEnd()
}
else
{
blnReplaceYes := false
while aaSavedCommand.ExecFindReplace(saDetail[2], saDetail[3], saDetail[4], saDetail[5], blnReplaceYes, A_Index = 1)
{
Edit_ScrollCaret(g_strEditorControlHwnd)
strNext := GuiFindReplaceNext(o_L["EditFindReplace"], o_L["EditReplacePrompt"])
if (strNext = "Yes")
blnReplaceYes := true
else if (strNext = "No")
blnReplaceYes := false
else if (strNext = "All")
{
aaSavedCommand.ExecFindReplace(saDetail[2], saDetail[3], saDetail[4], saDetail[5], true, false, true)
aaSavedCommand.ExecFindReplaceAllToEnd()
break
}
if (strNext = "Cancel")
{
aaSavedCommand.ExecFindReplace(saDetail[2], saDetail[3], saDetail[4], saDetail[5], false, false, true)
break
}
}
}
}
else if (saDetail[1] = "SubString")
aaSavedCommand.ExecSubString(saDetail[2], saDetail[3], saDetail[4], saDetail[5], saDetail[6], saDetail[7], saDetail[8], saDetail[9], saDetail[10])
else if (saDetail[1] = "InsertString")
aaSavedCommand.ExecInsertString(saDetail[2], saDetail[3], saDetail[4], saDetail[5], saDetail[6])
else if (saDetail[1] = "FilterLines")
aaSavedCommand.ExecFilterLines(saDetail[2], saDetail[3], saDetail[4], saDetail[5], saDetail[6])
else if (saDetail[1] = "FilterCharacters")
aaSavedCommand.ExecFilterCharacters(saDetail[2], saDetail[3], saDetail[4])
else if (saDetail[1] = "ReformatPara")
aaSavedCommand.ExecReformatPara(saDetail[2], saDetail[3], saDetail[4], saDetail[5], saDetail[6], saDetail[7], saDetail[8], saDetail[9], saDetail[10])
else if (saDetail[1] = "SortOptions")
aaSavedCommand.ExecSortOptions(saDetail[2])
else if (saDetail[1] = "FileOpen")
aaSavedCommand.ExecFileOpen(saDetail[2], saDetail[3], saDetail[4])
else if (saDetail[1] = "FileSave")
aaSavedCommand.ExecFileSave(saDetail[2], saDetail[3], saDetail[4], saDetail[5])
else if (saDetail[1] = "FileClipboardBackup")
aaSavedCommand.ExecFileClipboardBackup(saDetail[2])
else if (saDetail[1] = "FileClipboardRestore")
aaSavedCommand.ExecFileClipboardRestore(saDetail[2])
intItem := ""
aaSavedCommand := ""
saDetail := ""
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiFindReplaceNext(strTitle, strPrompt)
{
global
WinGetPos(&intGui1X, &intGui1Y, &intGui1W, &intGui1H, "ahk_id " g_intEditorHwnd)
CoordMode("Caret", "Window")
intCaretX := (A_CaretX < 0 ? 20 : A_CaretX)
intCaretY := (A_CaretY < 0 ? 20 : A_CaretY)
intLineHeight := g_intFontSizeCurrent / 72 * A_ScreenDPI
Next := Gui()
Next.OnEvent("Close", NextGuiEscape)
Next.OnEvent("Escape", NextGuiEscape)
Next.New("ToolWindow +Hwndg_strGuiNextHwnd", strTitle)
Next.Default()
Next.Opt("+OwnerEditor")
aaL := o_L.InsertAmpersand("DialogYes", "DialogNo", "DialogAll", "GuiCancel")
Next.Add("Text", "x10 y10 w200", strPrompt)
ogcButtonf_btnFindReplaceNextYes := Next.Add("Button", "x10 vf_btnFindReplaceNextYes  Default", aaL["DialogYes"])
ogcButtonf_btnFindReplaceNextYes.OnEvent("Click", GuiFindReplaceNextYes.Bind("Normal"))
ogcButtonf_btnFindReplaceNextNo := Next.Add("Button", "yp x+20 vf_btnFindReplaceNextNo", aaL["DialogNo"])
ogcButtonf_btnFindReplaceNextNo.OnEvent("Click", GuiFindReplaceNextYes.Bind("Normal"))
GuiCenterButtons(g_strGuiNextHwnd, , , , , , , "f_btnFindReplaceNextYes", "f_btnFindReplaceNextNo")
if (strPrompt = o_L["EditReplacePrompt"])
{
ogcButtonf_btnFindReplaceNextAll := Next.Add("Button", "x10 vf_btnFindReplaceNextAll", aaL["DialogAll"])
ogcButtonf_btnFindReplaceNextAll.OnEvent("Click", GuiFindReplaceNextYes.Bind("Normal"))
ogcButtonf_btnFindReplaceNextCancel := Next.Add("Button", "yp x+20 vf_btnFindReplaceNextCancel", aaL["GuiCancel"])
ogcButtonf_btnFindReplaceNextCancel.OnEvent("Click", GuiFindReplaceNextYes.Bind("Normal"))
GuiCenterButtons(g_strGuiNextHwnd, , , , , , , "f_btnFindReplaceNextAll", "f_btnFindReplaceNextCancel")
}
Next.Add("Text", "x10 w200")
Next.Show("AutoSize Hide")
WinGetPos(, , &intGui2W, &intGui2H, "ahk_id " g_strGuiNextHwnd)
intFindReplaceNextX := intGui1X + (intCaretX + intGui2W > intGui1W ? intGui1W - intGui2W : intCaretX)
intFindReplaceNextY := intGui1Y + (intCaretY + intGui2H + (intLineHeight * 2) > intGui1H ? intCaretY - intGui2H - (intLineHeight * 2) : intCaretY + (intLineHeight * 2))
Next.Show("x" . intFindReplaceNextX . " y" . intFindReplaceNextY)
if (g_AlwaysOnTopCurrent)
WinSetAlwaysOnTop(0, "ahk_id " g_intEditorHwnd)
WinSetAlwaysOnTop(1, "ahk_id " g_strGuiNextHwnd)
if (strPrompt = o_L["EditReplacePrompt"])
Editor.Opt("+Disabled")
g_strFindReplaceNext := (strPrompt = o_L["EditReplacePrompt"] ? "Cancel" : "No")
ErrorLevel := WinWaitClose("ahk_id " g_strGuiNextHwnd) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
if (g_AlwaysOnTopCurrent)
WinSetAlwaysOnTop(1, "ahk_id " g_intEditorHwnd)
intFindReplaceNextX := ""
intFindReplaceNextY := ""
intCaretX := ""
intCaretY := ""
intGui1X := ""
intGui1Y := ""
intGui1W := ""
intGui1H := ""
intGui2W := ""
intGui2H := ""
aaL := ""
return g_strFindReplaceNext
}
GuiFindReplaceNextYes(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
GuiFindReplaceNextNo:
GuiFindReplaceNextAll:
GuiFindReplaceNextCancel:
g_strFindReplaceNext := StrReplace(A_ThisLabel, "GuiFindReplaceNext")
NextGuiClose()
return
} ; V1toV2: Added bracket before function
NextGuiEscape(*)
{ ; V1toV2: Added bracket
NextGuiClose()
{ ; V1toV2: Added bracket
Editor.Opt("-Disabled")
Next.Destroy()
if (WinExist("A") <> g_intEditorHwnd)
WinActivate("ahk_id " g_intEditorHwnd)
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiEditorFindNext()
{ ; V1toV2: Added bracket
aaEditCommand.ExecFindNext()
Edit_ScrollCaret(g_strEditorControlHwnd)
return
} ; V1toV2: Added Bracket before label
GuiEditorFindPrevious()
{ ; V1toV2: Added bracket
aaEditCommand.ExecFindPrevious()
Edit_ScrollCaret(g_strEditorControlHwnd)
return
} ; V1toV2: Added Bracket before label
GuiEditorSortQuick()
{ ; V1toV2: Added bracket
new EditCommand("SortOptions").ExecSortAgain()
return
} ; V1toV2: Added Bracket before label
GuiEditorSortAgain()
{ ; V1toV2: Added bracket
if !IsObject(g_aaEditCommandTypes["SortOptions"].aaLastEditCommand)
new EditCommand(g_strEditorControlHwnd, "SortOptions").ExecSortAgain()
else
g_aaEditCommandTypes["SortOptions"].aaLastEditCommand.ExecSortAgain()
return
} ; V1toV2: Added Bracket before label
GuiStatusBarClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Editor.Opt("+OwnDialogs")
if (A_GuiEvent = "Normal" or A_GuiEvent = "DoubleClick")
if (A_EventInfo = 3 and g_blnClipboardIsBitmap)
{
strTempImageFilename := "QuickClipboardEditorImageStatusBar.png"
strTempImagePathFile := A_Temp . "\" . strTempImageFilename
if SaveImageInClipoardToFile(strTempImagePathFile)
{
if WinExist(strTempImageFilename)
WinClose(strTempImageFilename, , 0.5)
Run(strTempImagePathFile)
}
}
else
MsgBox(L(o_L["GuiStatusBarTip" . (A_EventInfo > 2 ? 3 : A_EventInfo)], (A_EventInfo = 1 ? StrUpper(o_L["DialogClipboardSynced"]) : ""), (A_EventInfo = 1 ? StrUpper(o_L["OptionsClipboardHistory"]) : ""), (A_EventInfo = 1 ? StrUpper(o_L["DialogClipboardEditing"]) : ""), (A_EventInfo = 1 ? StrUpper(o_L["DialogClipboardReadOnly"]) : ""), (A_EventInfo = 1 ? o_L["DialogSeeInvisible"] : ""), (A_EventInfo = 1 ? o_L["GuiBinary"] : ""), (A_EventInfo = 1 ? o_L["GuiBitmap"] : ""), (A_EventInfo = 1 ? o_L["GuiEmpty"] : "")), g_strAppNameText, "")
return
} ; V1toV2: Added bracket before function
InitHistoryMenuFile()
{ ; V1toV2: Added bracket
ShowHistoryMenuButtons:
OpenHistoryMenuHotkey:
if (A_ThisLabel = "InitHistoryMenuFile")
{
menuHistoryFile := Menu()
menuHistoryFile.Add()
menuHistoryFile.Delete()
}
else
{
menuHistoryButtons := Menu()
menuHistoryButtons.Add()
menuHistoryButtons.Delete()
menuHistoryButtons.Add(g_aaFileL["MenuHistorySearch"], BuildGuiHistorySearch)
menuHistoryButtons.Icon(g_aaFileL["MenuHistorySearch"], o_JLicons.strFileLocation, "79")
menuHistoryButtons.Add()
menuHistoryHotkey := Menu()
menuHistoryHotkey.Add()
menuHistoryHotkey.Delete()
menuHistoryHotkey.Add(g_aaFileL["MenuHistorySearch"], BuildGuiHistorySearch)
menuHistoryHotkey.Icon(g_aaFileL["MenuHistorySearch"], o_JLicons.strFileLocation, "79")
menuHistoryHotkey.Add()
}
oHistoryDbTableMenu := SearchHistoryFor("Menu")
saUniqueMenuLabels := Object()
while oHistoryDbTableMenu.GetRow(A_Index, saHistoryDbRow)
{
strMenuLabel := ConvertInvisible(saHistoryDbRow[1], true)
strMenuLabel := SubStr(strMenuLabel, 1, o_Settings.History.intHistoryMenuCharsWidth.IniValue). (StrLen(saHistoryDbRow[1]) > o_Settings.History.intHistoryMenuCharsWidth.IniValue ? g_strEllipse : "")
strMenuLabel := GetUniqueMenuLabel(strMenuLabel, saUniqueMenuLabels)
saUniqueMenuLabels.Push(strMenuLabel)
menuHistoryFile.Add(strMenuLabel, LoadHistoryPrev)
menuHistoryFile.Icon(strMenuLabel, o_JLicons.strFileLocation, "75")
menuHistoryButtons.Add(strMenuLabel, LoadHistoryPrev)
menuHistoryButtons.Icon(strMenuLabel, o_JLicons.strFileLocation, "75")
menuHistoryHotkey.Add(strMenuLabel, LoadHistoryPrev)
menuHistoryHotkey.Icon(strMenuLabel, o_JLicons.strFileLocation, "75")
}
if (A_ThisLabel = "ShowHistoryMenuButtons")
menuHistoryButtons.Show()
else if (A_ThisLabel = "OpenHistoryMenuHotkey")
menuHistoryHotkey.Show()
strMenuLabel := ""
oHistoryDbTableMenu := ""
saHistoryDbRow := ""
saUniqueMenuLabels := ""
return
} ; V1toV2: Added Bracket before label
!_035_CHECK_UPDATE:
GuiCheck4Update()
{ ; V1toV2: Added bracket
strChangeLog := Url2Var("https://A_Clipboard.quickaccesspopup.com/changelog/changelog" . (g_strUpdateProdOrBeta <> "prod" ? "-" . g_strUpdateProdOrBeta : "") . ".txt")
if StrLen(strChangeLog)
{
intPos := InStr(strChangeLog, "Version" . (g_strUpdateProdOrBeta = "beta" ? " BETA" : (g_strUpdateProdOrBeta = "alpha" ? " ALPHA" : "")) . ": " . g_strUpdateLatestVersion . " ")
strChangeLog := SubStr(strChangeLog, (intPos)<1 ? (intPos)-1 : (intPos))
intPos := InStr(strChangeLog, "`n`n")
strChangeLog := SubStr(strChangeLog, 1, intPos - 1)
}
strGuiTitle := L(o_L["UpdateTitle"], g_strAppNameText)
Update := Gui()
Update.OnEvent("Close", ButtonCheck4UpdateDialogChangeLog)
Update.OnEvent("Escape", ButtonCheck4UpdateDialogChangeLog)
Update.New("+Hwndg_strGui3Hwnd", strGuiTitle)
Update.SetFont("S[12] w700", "Arial")
Update.Add("Text", "x10 y10 w640", L(o_L["UpdateTitle"], g_strAppNameText))
Update.SetFont()
Update.Add("Text", "x10 w640", l(o_L["UpdatePrompt"], g_strAppNameText, g_strCurrentVersion, g_strUpdateLatestVersion . (g_strUpdateProdOrBeta <> "prod" ? " " . g_strUpdateProdOrBeta : "")))
Update.Add("Edit", "x8 y+10 w640 h300 ReadOnly", strChangeLog)
Update.SetFont()
ogcButtonf_btnCheck4UpdateDialogChangeLog := Update.Add("Button", "y+20 x10 vf_btnCheck4UpdateDialogChangeLog", o_L["UpdateButtonChangeLog"])
ogcButtonf_btnCheck4UpdateDialogChangeLog.OnEvent("Click", ButtonCheck4UpdateDialogChangeLog.Bind("Normal"))
ogcButtonf_btnCheck4UpdateDialogVisit := Update.Add("Button", "yp x+20 vf_btnCheck4UpdateDialogVisit", o_L["UpdateButtonVisit"])
ogcButtonf_btnCheck4UpdateDialogVisit.OnEvent("Click", ButtonCheck4UpdateDialogChangeLog.Bind("Normal"))
GuiCenterButtons(g_strGui3Hwnd, , 10, 5, 20, , , "f_btnCheck4UpdateDialogChangeLog", "f_btnCheck4UpdateDialogVisit")
if (g_strUpdateProdOrBeta = "prod")
{
if (g_blnPortableMode)
ogcButtonf_btnCheck4UpdateDialogDownload := Update.Add("Button", "y+20 x10 vf_btnCheck4UpdateDialogDownload", o_L["UpdateButtonDownloadPortable"])
ogcButtonf_btnCheck4UpdateDialogDownload.OnEvent("Click", ButtonCheck4UpdateDialogChangeLog.Bind("Normal"))
else
ogcButtonf_btnCheck4UpdateDialogDownload := Update.Add("Button", "y+20 x10 vf_btnCheck4UpdateDialogDownload", o_L["UpdateButtonDownloadSetup"])
ogcButtonf_btnCheck4UpdateDialogDownload.OnEvent("Click", ButtonCheck4UpdateDialogChangeLog.Bind("Normal"))
GuiCenterButtons(g_strGui3Hwnd, , 10, 5, 20, , , "f_btnCheck4UpdateDialogDownload")
}
ogcButtonf_btnCheck4UpdateDialogSkipVersion := Update.Add("Button", "y+20 x10 vf_btnCheck4UpdateDialogSkipVersion", o_L["UpdateButtonSkipVersion"])
ogcButtonf_btnCheck4UpdateDialogSkipVersion.OnEvent("Click", ButtonCheck4UpdateDialogChangeLog.Bind("Normal"))
ogcButtonf_btnCheck4UpdateDialogRemind := Update.Add("Button", "yp x+20 vf_btnCheck4UpdateDialogRemind", o_L["UpdateButtonRemind"])
ogcButtonf_btnCheck4UpdateDialogRemind.OnEvent("Click", ButtonCheck4UpdateDialogChangeLog.Bind("Normal"))
Update.Add("Text")
GuiCenterButtons(g_strGui3Hwnd, , 10, 5, 20, , , "f_btnCheck4UpdateDialogSkipVersion", "f_btnCheck4UpdateDialogRemind")
ogcButtonf_btnCheck4UpdateDialogRemind.Focus()
CalculateTopGuiPosition(g_strGui3Hwnd, g_intEditorHwnd, intX, intY)
Update.Show("AutoSize x" . intX . " y" . intY)
strGuiTitle := ""
return
} ; V1toV2: Added bracket before function
ButtonCheck4UpdateDialogChangeLog(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
ButtonCheck4UpdateDialogVisit:
ButtonCheck4UpdateDialogDownloadSetup:
ButtonCheck4UpdateDialogDownloadPortable:
ButtonCheck4UpdateDialogSkipVersion:
ButtonCheck4UpdateDialogRemind:
UpdateGuiClose:
UpdateGuiEscape:
strUrlChangeLog := AddUtm2Url("https://A_Clipboard.quickaccesspopup.com/change-log" . (g_strUpdateProdOrBeta <> "prod" ? "-" . g_strUpdateProdOrBeta . "-version" : "") . "/", A_ThisLabel, "Check4Update")
strUrlDownloadSetup := AddUtm2Url("https://A_Clipboard.quickaccesspopup.com/latest/check4update-download-setup-redirect.html", A_ThisLabel, "Check4Update")
strUrlDownloadPortable:= AddUtm2Url("https://A_Clipboard.quickaccesspopup.com/latest/check4update-download-portable-redirect.html", A_ThisLabel, "Check4Update")
strUrlAppLandingPageBeta := AddUtm2Url("https://A_Clipboard.quickaccesspopup.com/latest/check4update-beta-redirect.html", A_ThisLabel, "Check4Update")
if InStr(A_ThisLabel, "ButtonCheck4UpdateDialogChangeLog")
Run(strUrlChangeLog)
else if (A_ThisLabel = "ButtonCheck4UpdateDialogVisit")
Run((g_strUpdateProdOrBeta = "prod" ? g_strUrlAppLandingPage : strUrlAppLandingPageBeta))
else if (A_ThisLabel = "ButtonCheck4UpdateDialogDownloadSetup")
Run(strUrlDownloadSetup)
else if (A_ThisLabel = "ButtonCheck4UpdateDialogDownloadPortable")
Run(strUrlDownloadPortable)
else if (A_ThisLabel = "ButtonCheck4UpdateDialogSkipVersion")
{
IniWrite((g_strUpdateProdOrBeta = "alpha" ? strLatestVersionAlpha : (g_strUpdateProdOrBeta = "beta" ? strLatestVersionBeta : strLatestVersionProd)), o_Settings.strIniFile, "Internal", "LatestVersionSkipped" . (g_strUpdateProdOrBeta = "alpha" ? "Alpha" : (g_strUpdateProdOrBeta = "beta" ? "Beta" : "")))
if (g_strUpdateProdOrBeta <> "prod")
{
msgResult := MsgBox((g_strUpdateProdOrBeta = "alpha" ? StrReplace (o_L["UpdatePromptBetaContinue"], "beta" "alpha"), l(o_L["UpdateTitle"], g_strAppNameText . " " . g_strUpdateProdOrBeta), 4)
: o_L["UpdatePromptBetaContinue"])
if (msgResult = "No")
IniWrite(0.0, o_Settings.strIniFile, "Internal", "LastVersionUsedBeta")
}
}
else
IniWrite(0.0, o_Settings.strIniFile, "Internal", "LatestVersionSkipped" . (g_strUpdateProdOrBeta = "alpha" ? "Alpha" : (g_strUpdateProdOrBeta = "beta" ? "Beta" : "")))
Update.Destroy()
Check4UpdateDialogCleanup:
strChangelog := ""
strUrlChangeLog := ""
strUrlDownloadSetup := ""
strUrlDownloadPortable:= ""
strUrlAppLandingPageBeta := ""
return
} ; V1toV2: Added Bracket before label
!_040_EXIT:
CleanUpBeforeExit(A_ExitReason, ExitCode)
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
if (o_Settings.Launch.blnDiagMode.IniValue)
and !FileExist("C:\Dropbox\AutoHotkey\QuickClipboardEditor\QuickClipboardEditor-HOME.ini")
Run(g_strDiagFile)
DllCall("LockWindowUpdate", "Uint", g_intEditorHwnd)
if FileExist(o_Settings.strIniFile)
{
if (o_Settings.EditorWindow.blnRememberEditorPosition.IniValue)
SaveWindowPosition("EditorPosition", "ahk_id " . g_intEditorHwnd)
IniWrite(GetScreenConfiguration(), o_Settings.strIniFile, "Internal", "LastScreenConfiguration")
for strCode, oType in g_aaEditCommandTypes
if StrLen(oType.aaLastEditCommand.strPrepareCommandDetail)
IniWrite(oType.aaLastEditCommand.strPrepareCommandDetail, o_Settings.strIniFile, "LastCommand", strCode)
}
DllCall("LockWindowUpdate", "Uint", 0)
DirDelete(g_strTempDir, 1)
if IsObject(o_Db)
Loop
if o_Db.CloseDb()
{
blnDbClosed := true
break
}
else
{
if (A_Index = 3)
{
blnDbClosed := false
break
}
Sleep(500)
}
ExitApp()
} ; V1toV2: Added Bracket before label
!_050_GUI_CLOSE-CANCEL-BK_OBJECTS:
EditorGuiEscape:
EditorCloseFromGuiEscape()
return
EditorGuiClose(*)
{ ; V1toV2: Added bracket
EditorCloseFromGuiClose()
return
} ; V1toV2: Added Bracket before label
PasteFromQCEHotkey(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
PasteFromHistory()
{ ; V1toV2: Added bracket
PasteFromHistoryHotkey()
{ ; V1toV2: Added bracket
if ((A_ThisLabel = "PasteFromQCEHotkey" or A_ThisLabel = "PasteFromHistoryHotkey")
and EditorUnsaved())
EditorCopyToClipboard()
if WinActiveQCE()
if (g_blnKeepOpenAfterPasteCurrent)
{
Send("!{Tab}")
Sleep(300)
Send("^v")
Sleep(300)
Send("!{Tab}")
}
else
{
Editor.Cancel()
Sleep(300)
Send("^v")
}
else
{
Sleep(500)
Send("^v")
}
return
} ; V1toV2: Added Bracket before label
CopyOpenQCEHotkey:
if !ClipboardIsFree(A_ThisLabel)
return
WinClip.Copy()
GuiShowEditorFromHotkey()
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
EditorEscape(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
EditorClose()
{ ; V1toV2: Added bracket
EditorCloseFromGuiEscape()
{ ; V1toV2: Added bracket
EditorCloseFromGuiClose()
{ ; V1toV2: Added bracket
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
EditorCloseAndExitApp()
{ ; V1toV2: Added bracket
EditorCloseAndReload:
Editor.Default()
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
if EditorUnsaved() and !DialogConfirmCancel()
return
ToolTip(, , , 1)
ToolTip(, , , 2)
if InStr(A_ThisLabel, "ExitApp")
ExitApp()
else if InStr(A_ThisLabel, "Reload")
Reload()
if (A_ThisLabel = "EditorEscape")
UpdateEditorWithClipboardFromEscape()
else
Editor.Cancel()
UpdateEditorButtonsStatus()
SetStatusBarText(1, A_ThisLabel)
return
} ; V1toV2: Added Bracket before label
UpdateEditorButtonsStatus()
{ ; V1toV2: Added bracket
blnSynced := ((g_intHistoryPosition <= 1 and g_strClipboardCrLf == Edit_GetText(g_strEditorControlHwnd))
or IsReadOnly())
if (!blnSynced and g_intHistoryPosition = 1)
g_intHistoryPosition := 0 + (g_blnClipboardIsBitmap ? 1 : 0)
Editor.Default()

menuBarEditorClipboard.% (blnSynced ? "Disable" : "Enable")(g_aaFileL["GuiCopyClipboardMenu"] . "`t(Ctrl+S.Length)")

menuBarEditorClipboard.% (blnSynced ? "Disable": "Enable")(g_aaFileL["MenuCancelEditor"])
menuBarEditorConvertBinary.% (g_blnClipboardIsBitmap ? "Enable": "Disable")(g_aaConvertBitmapL["EditClipboardImageBase64Encode"])



if (g_blnDbHistoryDisabled)
if (blnSynced)
EnableClipboardChangesInEditor()
else
DisableClipboardChangesInEditor()
return
} ; V1toV2: Added Bracket before label
_2GuiClose(*)
{ ; V1toV2: Added bracket
_2GuiEscape:
oSaved := oGui2.Submit("0")
f_lvHotkeysList := oSaved.f_lvHotkeysList
f_lvInspectClipboardList := oSaved.f_lvInspectClipboardList
f_blnLaunchAtStartup := oSaved.f_blnLaunchAtStartup
f_blnDisplayTrayTip := oSaved.f_blnDisplayTrayTip
f_blnCheck4Update := oSaved.f_blnCheck4Update
f_strBackupFolder := oSaved.f_strBackupFolder
f_strQCETempFolderParentPath := oSaved.f_strQCETempFolderParentPath
f_blnDisplayEditorAtStartup := oSaved.f_blnDisplayEditorAtStartup
f_blnRememberEditorPosition := oSaved.f_blnRememberEditorPosition
f_blnDarkMode := oSaved.f_blnDarkMode
f_blnAsciiHexa := oSaved.f_blnAsciiHexa
f_blnFixedFontDefault := oSaved.f_blnFixedFontDefault
f_intFontSizeDefault := oSaved.f_intFontSizeDefault
f_intFontUpDownDefault := oSaved.f_intFontUpDownDefault
f_blnAlwaysOnTopDefault := oSaved.f_blnAlwaysOnTopDefault
f_blnWordWrapDefault := oSaved.f_blnWordWrapDefault
f_blnUseTab := oSaved.f_blnUseTab
f_blnKeepOpenAfterPasteDefault := oSaved.f_blnKeepOpenAfterPasteDefault
f_blnCopyToAppendDefault := oSaved.f_blnCopyToAppendDefault
f_blnHistoryEnabled := oSaved.f_blnHistoryEnabled
f_intHistoryDbMaximumSize := oSaved.f_intHistoryDbMaximumSize
f_intHistorySyncDelay := oSaved.f_intHistorySyncDelay
f_intHistoryMenuCharsWidth := oSaved.f_intHistoryMenuCharsWidth
f_intHistorySearchCharsWidth := oSaved.f_intHistorySearchCharsWidth
f_intHistoryMenuRows := oSaved.f_intHistoryMenuRows
f_intHistorySearchRows := oSaved.f_intHistorySearchRows
f_intHistoryMenuIconSize := oSaved.f_intHistoryMenuIconSize
f_intHistorySearchQueryRows := oSaved.f_intHistorySearchQueryRows
f_intSavedCommandsLinesInList := oSaved.f_intSavedCommandsLinesInList
f_intFileEncodingCodePage := oSaved.f_intFileEncodingCodePage
f_strCopyAppendSeparator := oSaved.f_strCopyAppendSeparator
f_blnRadioSubStringFromStart := oSaved.f_blnRadioSubStringFromStart
f_blnRadioSubStringFromPosition := oSaved.f_blnRadioSubStringFromPosition
f_blnRadioSubStringFromBeginText := oSaved.f_blnRadioSubStringFromBeginText
f_blnRadioSubStringFromEndText := oSaved.f_blnRadioSubStringFromEndText
f_intRadioSubStringFromPosition := oSaved.f_intRadioSubStringFromPosition
f_strRadioSubStringFromText := oSaved.f_strRadioSubStringFromText
f_intSubStringFromPlusMinus := oSaved.f_intSubStringFromPlusMinus
f_intSubStringFromUpDown := oSaved.f_intSubStringFromUpDown
f_blnRadioSubStringToEnd := oSaved.f_blnRadioSubStringToEnd
f_blnRadioSubStringLength := oSaved.f_blnRadioSubStringLength
f_blnRadioSubStringToBeforeEnd := oSaved.f_blnRadioSubStringToBeforeEnd
f_blnRadioSubStringToBeginText := oSaved.f_blnRadioSubStringToBeginText
f_blnRadioSubStringToEndText := oSaved.f_blnRadioSubStringToEndText
f_intSubStringCharacters := oSaved.f_intSubStringCharacters
f_strSubStringToText := oSaved.f_strSubStringToText
f_intSubStringToPlusMinus := oSaved.f_intSubStringToPlusMinus
f_intSubStringToUpDown := oSaved.f_intSubStringToUpDown
f_strInsertString := oSaved.f_strInsertString
f_blnRadioInsertStringFromStart := oSaved.f_blnRadioInsertStringFromStart
f_blnRadioInsertStringAtTheEnd := oSaved.f_blnRadioInsertStringAtTheEnd
f_blnRadioInsertStringFromPosition := oSaved.f_blnRadioInsertStringFromPosition
f_blnRadioInsertStringFromBeginText := oSaved.f_blnRadioInsertStringFromBeginText
f_blnRadioInsertStringFromEndText := oSaved.f_blnRadioInsertStringFromEndText
f_intRadioInsertStringFromPosition := oSaved.f_intRadioInsertStringFromPosition
f_strRadioInsertStringFromText := oSaved.f_strRadioInsertStringFromText
f_intFromPlusMinus := oSaved.f_intFromPlusMinus
f_intInsertStringFromUpDown := oSaved.f_intInsertStringFromUpDown
f_blnFilterLinesDelete := oSaved.f_blnFilterLinesDelete
f_blnFilterLinesKeep := oSaved.f_blnFilterLinesKeep
f_blnFilterLinesContaining := oSaved.f_blnFilterLinesContaining
f_blnFilterLinesRegEx := oSaved.f_blnFilterLinesRegEx
f_blnFilterLines3 := oSaved.f_blnFilterLines3
f_blnFilterLines4 := oSaved.f_blnFilterLines4
f_blnFilterLinesCase := oSaved.f_blnFilterLinesCase
f_strFilterLinesCriteriaList := oSaved.f_strFilterLinesCriteriaList
f_blnFilterLinesAnd := oSaved.f_blnFilterLinesAnd
f_blnFilterLinesOr := oSaved.f_blnFilterLinesOr
f_blnFilterLinesNotAll := oSaved.f_blnFilterLinesNotAll
f_blnFilterLinesNotAny := oSaved.f_blnFilterLinesNotAny
f_strFilterLinesCriteriaRegex := oSaved.f_strFilterLinesCriteriaRegex
f_blnFilterCharactersDelete := oSaved.f_blnFilterCharactersDelete
f_blnFilterCharactersKeep := oSaved.f_blnFilterCharactersKeep
f_strFilterCharactersList := oSaved.f_strFilterCharactersList
f_blnFilterCharactersEverywhere := oSaved.f_blnFilterCharactersEverywhere
f_blnDeleteCharactersBeginEnd := oSaved.f_blnDeleteCharactersBeginEnd
f_blnDeleteCharactersBegin := oSaved.f_blnDeleteCharactersBegin
f_blnDialogDeleteCharactersEnd := oSaved.f_blnDialogDeleteCharactersEnd
f_blnFilterCharactersCase := oSaved.f_blnFilterCharactersCase
f_blnEditReformatParaSeparated := oSaved.f_blnEditReformatParaSeparated
f_blnEditReformatParaMerged := oSaved.f_blnEditReformatParaMerged
f_intEditReformatParaLineWidth := oSaved.f_intEditReformatParaLineWidth
f_radReformatParaAlignLeft := oSaved.f_radReformatParaAlignLeft
f_radReformatParaAlignIndent := oSaved.f_radReformatParaAlignIndent
f_radReformatParaAlignRight := oSaved.f_radReformatParaAlignRight
f_radReformatParaAlignCenter := oSaved.f_radReformatParaAlignCenter
f_strEditReformatParaIndentCharactersFirst := oSaved.f_strEditReformatParaIndentCharactersFirst
f_strEditReformatParaIndentCharactersOther := oSaved.f_strEditReformatParaIndentCharactersOther
f_blnEditReformatParaPunct := oSaved.f_blnEditReformatParaPunct
f_strEditReformatParaPunct1Space := oSaved.f_strEditReformatParaPunct1Space
f_strEditReformatParaPunct2Spaces := oSaved.f_strEditReformatParaPunct2Spaces
f_strEditReformatParaPunct1SpaceBefore := oSaved.f_strEditReformatParaPunct1SpaceBefore
f_strEditReformatParaPunctUpperAfter := oSaved.f_strEditReformatParaPunctUpperAfter
f_strSortOption := oSaved.f_strSortOption
f_intSortOptionPosition := oSaved.f_intSortOptionPosition
f_strFindOrReplaceWhat := oSaved.f_strFindOrReplaceWhat
f_strFindOrReplaceWith := oSaved.f_strFindOrReplaceWith
f_blnFindOrReplaceMatchCase := oSaved.f_blnFindOrReplaceMatchCase
f_blnFindOrReplaceRegEx := oSaved.f_blnFindOrReplaceRegEx
f_blnSavedCommandReplaceAll := oSaved.f_blnSavedCommandReplaceAll
f_strFilePath := oSaved.f_strFilePath
f_blnFileOpenToEditor := oSaved.f_blnFileOpenToEditor
f_radFileOpenToEditorAt := oSaved.f_radFileOpenToEditorAt
f_blnFileOpenToClipboard := oSaved.f_blnFileOpenToClipboard
f_blnFileSaveSelected := oSaved.f_blnFileSaveSelected
f_blnRadioFileSaveEol := oSaved.f_blnRadioFileSaveEol
f_blnRadioFileEncoding := oSaved.f_blnRadioFileEncoding
f_drpSavedCommands := oSaved.f_drpSavedCommands
f_blnSaveCommand := oSaved.f_blnSaveCommand
f_strSaveCommandTitle := oSaved.f_strSaveCommandTitle
f_blnSaveCommandReplaceAll := oSaved.f_blnSaveCommandReplaceAll
f_blnSaveCommandInMenu := oSaved.f_blnSaveCommandInMenu
f_strLocalHotkeyCode := oSaved.f_strLocalHotkeyCode
f_strEditCommandType := oSaved.f_strEditCommandType
f_drpManageSavedCommandsCommand := oSaved.f_drpManageSavedCommandsCommand
f_strManageSavedCommandsFilter := oSaved.f_strManageSavedCommandsFilter
f_blnManageSavedCommandsCheckAllNone := oSaved.f_blnManageSavedCommandsCheckAllNone
f_lvManageSavedCommandsList := oSaved.f_lvManageSavedCommandsList
strThisTitle := WinGetTitle("ahk_id " g_strGui2Hwnd)
if (g_strOptionsGuiTitle = strThisTitle) and StrLen(strThisTitle)
{
if (g_blnGroupChanged)
{
oGui2.Opt("+OwnDialogs")
msgResult := MsgBox(o_L["DialogCancelPrompt"], L(o_L["DialogCancelTitle"], g_strAppNameText, g_strAppVersion), 36)
if (msgResult = "Yes")
{
g_blnGroupChanged := false
o_PopupHotkeys.RestorePopupHotkeys()
}
if (msgResult = "No")
return
}
g_strSettingsGroup := ""
}
Editor.Default()
Editor.Opt("-Disabled")
oGui2.Destroy()
if (WinExist("A") <> g_intEditorHwnd)
WinActivate("ahk_id " g_intEditorHwnd)
g_blnCommandInProgress := false
return
} ; V1toV2: Added Bracket before label
_3GuiClose(*)
{ ; V1toV2: Added bracket
_3GuiEscape()
{ ; V1toV2: Added bracket
oGui3 := Gui()
oGui3.OnEvent("Close", _3GuiClose)
oGui3.OnEvent("Escape", _3GuiClose)
oSaved := oGui3.Submit("0")
oGui2.Default()
oGui2.Opt("-Disabled")
oGui3.Destroy()
return
} ; V1toV2: Added Bracket before label
!_060_POPUP:
return
} ; V1toV2: Added Bracket before label
OpenEditorHotkeyMouse:
OpenEditorHotkeyKeyboard:
GuiShowEditor()
return
} ; V1toV2: Added bracket before function
CanPopup(strMouseOrKeyboard)
{
global
return true
}
CheckShowEditor()
{ ; V1toV2: Added bracket
DetectHiddenWindows(false)
blnExist := WinExist("ahk_id " . g_intEditorHwnd)
DetectHiddenWindows(true)
if !(blnExist)
{
GuiShowFromGuiOutside()
Editor.Default()
}
blnExist := ""
return
} ; V1toV2: Added bracket before function
GuiShowEditor()
{ ; V1toV2: Added bracket
GuiShowEditorFromTray:
GuiShowEditorFromHotkey()
{ ; V1toV2: Added bracket
GuiShowFromGuiOutside()
{ ; V1toV2: Added bracket
if !EditorVisible()
UpdateEditorWithClipboardFromGuiShow()
UpdateEditorButtonsStatus()
intGuiHwnd := g_intEditorHwnd
Editor.Default()
SetStatusBarText(1, A_ThisLabel)
SetTimer(UpdateEditorEditMenuAndStatusBar,500)
if EditorVisible()
{
WinActivate("ahk_id " intGuiHwnd)
intGuiHwnd := ""
return
}
Editor.Show()
intGuiHwnd := ""
strDetectHiddenWindowsBefore := ""
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
UpdateEditorWithClipboard()
{ ; V1toV2: Added bracket
UpdateEditorWithClipboardFromGuiShow()
{ ; V1toV2: Added bracket
UpdateEditorWithClipboardFromEscape()
{ ; V1toV2: Added bracket
Diag(A_ThisLabel, "Start", "")
Editor.Default()
if (A_ThisLabel = "UpdateEditorWithClipboard" and g_blnCopyToAppendCurrent
and !g_blnFromCopyToClipboard and !IsReadOnly())
{
Edit_SetText(g_strEditorControlHwnd, Edit_GetText(g_strEditorControlHwnd) . DecodeEolAndTab(o_Settings.Various.strCopyAppendSeparator.IniValue) . g_strClipboardCrLf)
SetStatusBarText(1, A_ThisLabel)
}
else
{
Edit_SetText(g_strEditorControlHwnd, g_strClipboardCrLf)
if (g_blnSeeInvisible)
ClipboardEditorSeeInvisibleChanged()
else
SetStatusBarText(1, A_ThisLabel)
}
if WinActiveQCE()
ogc%g_strEditorControlHwnd%.Focus()
AddToUndoPile()
g_intHistoryPosition := (g_blnClipboardIsBitmap and !Edit_GetTextLength(g_strEditorControlHwnd) ? 0 : 1)
strContent := ""
Diag(A_ThisLabel, "Out", "")
return
} ; V1toV2: Added Bracket before label
!_065_GUI_CHANGE_HOTKEY:
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
SelectShortcut(P_strActualShortcut, P_strShortcutName, P_intShortcutType, P_strDefaultShortcut := "", P_strDescription := "")
{
global
SS_aaL := o_L.InsertAmpersand("DialogOK", "GuiCancel", "DialogNone", "GuiResetDefault")
g_blnChangeShortcutInProgress := true
SS_strModifiersLabels := "Shift|Ctrl|Alt|Win"
SS_saModifiersLabels := StrSplit(SS_strModifiersLabels, "|")
SS_strModifiersSymbols := "+|^|!|#"
SS_saModifiersSymbols := StrSplit(SS_strModifiersSymbols, "|")
o_HotkeyActual := new Triggers.HotkeyParts(P_strActualShortcut)
SS_strMainHwnd := g_intEditorHwnd
SS_strGuiTitle := L(o_L["DialogChangeHotkeyTitle"], g_strAppNameText, g_strAppVersion)
oGui3.New("+Hwndg_strGui3Hwnd", SS_strGuiTitle)
oGui3.Default()
oGui3.Opt("+Owner2")
oGui3.Opt("+OwnDialogs")
if (g_blnAlwaysOnTopCurrent)
WinSetAlwaysOnTop(1, "ahk_id " g_strGui3Hwnd)
if (g_blnUseColors)
oGui3.BackColor := g_strGuiWindowColor
oGui3.SetFont("S[12] Bold", "Arial")
oGui3.Add("Text", "x10 y10 w400 center", L(o_L["DialogChangeHotkeyTitle"], g_strAppNameText))
oGui3.SetFont()
oGui3.Add("Text", "y+15 x10", o_L["DialogTriggerFor"])
oGui3.SetFont("S[8] Bold")
oGui3.Add("Text", "x+5 yp w300 section", P_strShortcutName . (StrLen(P_strFavoriteType) ? " (" . P_strFavoriteType . ")" : ""))
oGui3.SetFont()
if StrLen(P_strFavoriteLocation)
oGui3.Add("Text", "xs y+5 w300", P_strFavoriteLocation)
if StrLen(P_strDescription)
{
P_strDescription := StrReplace(P_strDescription, "<A>")
P_strDescription := StrReplace(P_strDescription, "</A>")
oGui3.Add("Text", "xs y+5 w300", P_strDescription)
}
Loop 4
{
SS_strModifiersLabel := SS_saModifiersLabels[A_Index]
ogcCheckBoxf_bln := oGui3.Add("CheckBox", "y+" (SS_strModifiersLabel = "Shift" ? 20 : 10) . " x50  vf_bln". SS_saModifiersLabels[A_Index], % o_L["Dialog" . SS_strModifiersLabel . "Short"])
ogcCheckBoxf_bln.OnEvent("Click", ModifierClicked.Bind("Normal"))
if (SS_strModifiersLabel = "Shift")
ogcf_blnShift.GetPos(&SS_arrTopX, &SS_arrTopY, &SS_arrTopW, &SS_arrTopH)
}
if (P_intShortcutType = 1)
ogcDropDownListf_drpShortcutMouse := oGui3.Add("DropDownList", "y" . SS_arrTopY . " x150 w200 vf_drpShortcutMouse ", [o_MouseButtons.GetDropDownList(o_HotkeyActual.strMouseButton)])
ogcDropDownListf_drpShortcutMouse.OnEvent("Change", MouseChanged.Bind("Change"))
if (P_intShortcutType = 3)
{
oGui3.Add("Text", "y" . SS_arrTopY . " x150 w60", o_L["DialogMouse"])
ogcDropDownListf_drpShortcutMouse := oGui3.Add("DropDownList", "yp x+10 w200 vf_drpShortcutMouse", [o_MouseButtons.GetDropDownList(o_HotkeyActual.strMouseButton)])
ogcDropDownListf_drpShortcutMouse.OnEvent("Change", MouseChanged.Bind("Change"))
oGui3.Add("Text", "y" . SS_arrTopY + 20 . " x150", o_L["DialogOr"])
}
if (P_intShortcutType <> 1)
{
oGui3.Add("Text", "y" . SS_arrTopY + (P_intShortcutType = 2 ? 0 : 40) . " x150 w60", o_L["DialogKeyboard"])
ogcHotkeyf_strShortcutKey := oGui3.Add("Hotkey", "yp x+10 w200 vf_strShortcutKey  section")
ogcHotkeyf_strShortcutKey.OnEvent("Change", ShortcutChanged.Bind("Change"))
ogcHotkeyf_strShortcutKey.Value := o_HotkeyActual.strKey
}
if (P_intShortcutType <> 1)
ogcLinkLo_LDialogHotkeyInvisibleKeysSpaceTabEnterEscMenu := oGui3.Add("Link", "y+5 xs w200", L(o_L["DialogHotkeyInvisibleKeys"], "Space", "Tab", "Enter", "Esc", "Menu"))
ogcLinkLo_LDialogHotkeyInvisibleKeysSpaceTabEnterEscMenu.OnEvent("Click", ShortcutInvisibleKeysClicked.Bind("Normal"))
ogcButtonf_btnNoneShortcut := oGui3.Add("Button", "x10 y" . SS_arrTopY + 100 . " vf_btnNoneShortcut ", SS_aaL["DialogNone"])
ogcButtonf_btnNoneShortcut.OnEvent("Click", SelectNoneShortcutClicked.Bind("Normal"))
if StrLen(P_strDefaultShortcut) and (P_strFavoriteType <> "Alternative")
{
ogcButtonf_btnResetShortcut := oGui3.Add("Button", "x10 y" . SS_arrTopY + 100 . " vf_btnResetShortcut ", SS_aaL["GuiResetDefault"])
ogcButtonf_btnResetShortcut.OnEvent("Click", ButtonResetShortcut.Bind("Normal"))
GuiCenterButtons(g_strGui3Hwnd, , 10, 5, 20, , , "f_btnNoneShortcut", "f_btnResetShortcut")
}
else
{
oGui3.Add("Text", "x10 y" . SS_arrTopY + 100)
GuiCenterButtons(g_strGui3Hwnd, , 10, 5, 20, , , "f_btnNoneShortcut")
}
oGui3.Add("Text", "x10 y+25 w400", o_L["DialogChangeHotkeyLeftAnyRight"])
Loop 4
{
SS_strModifiersLabel := SS_saModifiersLabels[A_Index]
oGui3.Add("Text", "y+10 x10 w60 right", o_L["Dialog" . SS_strModifiersLabel . "Short"])
oGui3.SetFont("Bold")
oGui3.Add("Text", "yp x+10 w40 center", chr(0x2192))
oGui3.SetFont()
ogcRadiof_radLeft := oGui3.Add("Radio", "yp x+10 disabled vf_radLeft" . SS_saModifiersLabels[A_Index], o_L["DialogChangeHotkeyLeft"])
ogcRadiof_radAny := oGui3.Add("Radio", "yp x+10 disabled vf_radAny" . SS_saModifiersLabels[A_Index], o_L["DialogChangeHotkeyAny"])
ogcRadiof_radRight := oGui3.Add("Radio", "yp x+10 disabled vf_radRight" . SS_saModifiersLabels[A_Index], o_L["DialogChangeHotkeyRight"])
}
SetModifiersCheckBoxAndRadio()
ogcButtonf_btnChangeShortcutOK := oGui3.Add("Button", "y+25 x10 vf_btnChangeShortcutOK", SS_aaL["DialogOK"])
ogcButtonf_btnChangeShortcutOK.OnEvent("Click", ButtonChangeShortcutOK.Bind("Normal"))
ogcButtonf_btnChangeShortcutCancel := oGui3.Add("Button", "yp x+20 vf_btnChangeShortcutCancel", SS_aaL["GuiCancel"])
ogcButtonf_btnChangeShortcutCancel.OnEvent("Click", ButtonChangeShortcutCancel.Bind("Normal"))
GuiCenterButtons(g_strGui3Hwnd, , 10, 5, 20, , , "f_btnChangeShortcutOK", "f_btnChangeShortcutCancel")
oGui3.Add("Text")
ogcButtonf_btnChangeShortcutOK.Focus()
CalculateTopGuiPosition(g_strGui3Hwnd, SS_strMainHwnd, SS_intX, SS_intY)
oGui3.Show("AutoSize x" . SS_intX . " y" . SS_intY)
oGui2.Opt("+Disabled")
ErrorLevel := WinWaitClose(SS_strGuiTitle) , ErrorLevel := ErrorLevel = 0 ? 1 : 0
SS_saModifiersLabels := ""
SS_saModifiersSymbols := ""
SS_blnAlt := ""
SS_blnCtrl := ""
SS_blnShift := ""
SS_blnThisLeft := ""
SS_blnThisModifierOn := ""
SS_blnThisRight := ""
SS_blnWin := ""
SS_intReverseIndex := ""
SS_strHotkeyControl := ""
SS_strHotkeyControlKey := ""
SS_strHotkeyControlModifiers := ""
SS_strKey := ""
SS_strModifiersLabel := ""
SS_strModifiersLabels := ""
SS_strModifiersSymbols := ""
SS_strMouse := ""
SS_strMouseControl := ""
SS_strMouseValue := ""
SS_strThisLabel := ""
SS_strThisSymbol := ""
SS_intX := ""
SS_intY := ""
SS_strGuiTitle := ""
SS_aaL := ""
SS_strMainHwnd := ""
return SS_strNewShortcut
MouseChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
SS_strMouseControl := A_GuiControl
SS_strMouseValue := ogc%SS_strMouseControl%.Text
if (SS_strMouseValue = o_L["DialogNone"])
{
Loop 4
ogc% "f_bln" . SS_saModifiersLabels[A_Index].Value := 0
ModifierClicked()
}
if (P_intShortcutType = 3)
ogcHotkeyf_strShortcutKey.Value := "None"
return
} ; V1toV2: Added Bracket before label
ShortcutChanged(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
SS_strHotkeyControl := A_GuiControl
SS_strHotkeyControl := %SS_strHotkeyControl%
if !StrLen(SS_strHotkeyControl)
return
o_HotkeyCheckModifiers := new Triggers.HotkeyParts(SS_strHotkeyControl)
if StrLen(o_HotkeyCheckModifiers.strModifiers)
ogc%A_GuiControl%.Value := "None"
else
ogcDropDownListf_drpShortcutMouse.Choose(0)
o_HotkeyCheckModifiers := ""
return
} ; V1toV2: Added Bracket before label
SelectNoneShortcutClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
o_HotkeyActual.SplitParts("None")
ogcHotkeyf_strShortcutKey.Value := o_L["DialogNone"]
ogcDropDownListf_drpShortcutMouse.Choose(% o_L["DialogNone"])
SetModifiersCheckBoxAndRadio()
return
} ; V1toV2: Added bracket before function
ShortcutInvisibleKeysClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
if (ErrorLevel = "Space")
ogcHotkeyf_strShortcutKey.Value := A_Space
else if (ErrorLevel = "Tab")
ogcHotkeyf_strShortcutKey.Value := A_Tab
else if (ErrorLevel = "Enter")
ogcHotkeyf_strShortcutKey.Value := "Enter"
else if (ErrorLevel = "Esc")
ogcHotkeyf_strShortcutKey.Value := "Escape"
else
ogcHotkeyf_strShortcutKey.Value := "AppsKey"
ogcDropDownListf_drpShortcutMouse.Choose(0)
return
} ; V1toV2: Added Bracket before label
ButtonResetShortcut(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
o_HotkeyActual.SplitParts(P_strDefaultShortcut)
ogcHotkeyf_strShortcutKey.Value := o_HotkeyActual.strKey
intChoose := o_MouseButtons.GetMouseButtonLocalized4InternalName(o_HotkeyActual.strMouseButton, false)
ogcDropDownListf_drpShortcutMouse.Choose(% (!StrLen(intChoose) ? 0 : intChoose))
SetModifiersCheckBoxAndRadio()
return
} ; V1toV2: Added Bracket before label
SetModifiersCheckBoxAndRadio()
{ ; V1toV2: Added bracket
Loop 4
{
SS_strThisLabel := SS_saModifiersLabels[A_Index]
SS_strThisSymbol := SS_saModifiersSymbols[A_Index]
ogc% "f_bln" . SS_strThisLabel.Value := InStr(o_HotkeyActual.strModifiers, SS_strThisSymbol) > 0
ogcf_radLeft%SS_strThisLabel%.Value := InStr(o_HotkeyActual.strModifiers, "<" . SS_strThisSymbol) > 0
ogcf_radAny%SS_strThisLabel%.Value := !InStr(o_HotkeyActual.strModifiers, "<" . SS_strThisSymbol) and !InStr(P_strActualShortcut, ">" . SS_strThisSymbol)
ogcf_radRight%SS_strThisLabel%.Value := InStr(o_HotkeyActual.strModifiers, ">" . SS_strThisSymbol) > 0
}
ModifierClicked()
return
} ; V1toV2: Added bracket before function
ModifierClicked(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
Loop 4
{
SS_strThisLabel := SS_saModifiersLabels[A_Index]
SS_strThisSymbol := SS_saModifiersSymbols[A_Index]
SS_blnThisModifierOn := ogc% "f_bln" . SS_saModifiersLabels[A_Index].Text



}
return
} ; V1toV2: Added Bracket before label
ButtonChangeShortcutOK(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
SS_strMouse := ogcDropDownListf_drpShortcutMouse.Text
SS_strKey := ogcHotkeyf_strShortcutKey.Text
SS_blnWin := ogcf_blnWin.Text
SS_blnAlt := ogcf_blnAlt.Text
SS_blnCtrl := ogcf_blnCtrl.Text
SS_blnShift := ogcf_blnShift.Text
if StrLen(SS_strMouse)
SS_strMouse := o_MouseButtons.GetMouseButtonInternal4LocalizedName(SS_strMouse)
SS_strNewShortcut := Trim(SS_strKey . (SS_strMouse = "None" ? "" : SS_strMouse))
if !StrLen(SS_strNewShortcut)
SS_strNewShortcut := "None"
if HasShortcut(SS_strNewShortcut)
Loop 4
{
SS_intReverseIndex := -(A_Index-5)
SS_strThisLabel := SS_saModifiersLabels[SS_intReverseIndex]
SS_strThisSymbol := SS_saModifiersSymbols[SS_intReverseIndex]
if (SS_bln%SS_strThisLabel%)
{
SS_blnThisLeft := ogcf_radLeft%SS_strThisLabel%.Text
SS_blnThisRight := ogcf_radRight%SS_strThisLabel%.Text
SS_strNewShortcut := (SS_blnThisLeft ? "<" : "") . (SS_blnThisRight ? ">" : "") . SS_strThisSymbol . SS_strNewShortcut
}
}
if (SS_strNewShortcut = "LButton")
{
Oops(3, o_L["DialogChangeHotkeyMouseCheckLButton"], o_L["DialogShift"], o_L["DialogCtrl"], o_L["DialogAlt"], o_L["DialogWin"])
SS_strNewShortcut := ""
return
}
else if (SS_blnWin or SS_blnAlt or SS_blnCtrl or SS_blnShift) and (SS_strNewShortcut = "None")
{
Oops(3, o_L["DialogChangeHotkeyModifierAndNone"])
SS_strNewShortcut := ""
return
}
g_blnChangeShortcutInProgress := false
3GuiClose()
return
} ; V1toV2: Added Bracket before label
ButtonChangeShortcutCancel(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
3GuiEscape()
return
} ; V1toV2: Added Bracket before label
}
!_070_TRAY_MENU_ACTIONS:
OpenWorkingDirectory:
Run(A_WorkingDir)
return
DebugInfo(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
pGetOpenClipboardWindow := DllCall("GetOpenClipboardWindow")
strGetOpenClipboardWindow := WinGetTitle("ahk_id " pGetOpenClipboardWindow)
pGetClipboardOwner := DllCall("GetClipboardOwner")
strGetClipboardOwner := WinGetTitle("ahk_id " pGetClipboardOwner)
pGetClipboardViewer := DllCall("GetClipboardViewer")
strGetClipboardViewer := WinGetTitle("ahk_id " pGetClipboardViewer)
MsgBox("". "GetOpenClipboardWindow: " . pGetOpenClipboardWindow . "`n". "GetOpenClipboardWindow Title: " . strGetOpenClipboardWindow . "`n". "GetClipboardOwner: " . pGetClipboardOwner . "`n". "GetClipboardOwner Title: " . strGetClipboardOwner . "`n". "GetClipboardViewer: " . pGetClipboardViewer . "`n". "GetClipboardViewer Title: " . strGetClipboardViewer . "`n", g_strAppNameText " - " A_ThisLabel, "")
return
} ; V1toV2: Added Bracket before label
ShowSettingsIniFile(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
MsgBox(L(o_L["DialogShowSettingsIniFile"], g_strAppNameText), o_L["MenuOptions"], "")
Run(o_Settings.strIniFile)
return
} ; V1toV2: Added Bracket before label
!_080_VARIOUS_COMMANDS:
return
DoNothing:
return
GuiAboutEditor(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
oSaved := Editor.Submit("0")
f_blnFixedFontCurrent := oSaved.f_blnFixedFontCurrent
f_intFontSizeCurrent := oSaved.f_intFontSizeCurrent
f_intFontUpDown := oSaved.f_intFontUpDown
f_blnAlwaysOnTopCurrent := oSaved.f_blnAlwaysOnTopCurrent
f_blnWordWrapCurrent := oSaved.f_blnWordWrapCurrent
f_blnSeeInvisible := oSaved.f_blnSeeInvisible
f_strEditorWordWrapOn := oSaved.f_strEditorWordWrapOn
f_strEditorWordWrapOff := oSaved.f_strEditorWordWrapOff
intWidthTotal := 680
intWidthHalf := 340
intXCol2 := 360
strGuiTitle := L(o_L["AboutTitle"], g_strAppNameText, g_strAppVersion)
oGui2.New("+Hwndg_strGui2Hwnd", strGuiTitle)
if (g_blnUseColors)
oGui2.BackColor := g_strGuiWindowColor
oGui2.Opt("+OwnerEditor")
oGui2.SetFont("S[14] w700", "Arial")
oGui2.Add("Link", "x10 y10 w" . intWidthTotal, L(o_L["AboutText1"], g_strAppNameText, g_strAppVersion, A_PtrSize * 8))
oGui2.SetFont("S[10] w400", "Arial")
oGui2.Add("Link", "x10 w" . intWidthTotal, L(o_L["AboutText2"], g_strAppNameText))
strYear := FormatTime(, "yyyy")
oGui2.Add("Link", "x10 w" . intWidthTotal, L(o_L["AboutText3"], chr(169), strYear, AddUtm2Url("https://A_Clipboard.quickaccesspopup.com/license/", A_ThisLabel, "License"), "www.A_Clipboard.quickaccesspopup.com/license/"))
oGui2.Add("Text", "x10 w" . intWidthHalf . " section", L(o_L["AboutUserComputerName"], A_UserName, A_ComputerName))
oGui2.Add("Link", "x10 w" . intWidthHalf, L(o_L["AboutText4"]))
oGui2.SetFont("S[10] w700", "Arial")
oGui2.Add("Link", "x10 y+10 w" . intWidthTotal, L(o_L["AboutText5"]))
oGui2.SetFont("S[10] w400", "Arial")
oGui2.Add("Link", "x10 w" . intWidthHalf . " section", L(o_L["AboutText6"], "Lexikos (AutoHotkey_L), Joe Glines (the-Automator.com), RaptorX, jballi (Edit library), Blackholyman, just_me". ", Learning One, Maestrith, Pulover (LV_Rows class), Tank, jeeswg", "https://www.autohotkey.com/boards/"))
aaL := o_L.InsertAmpersand("GuiClose")
ogcButtonf_btnAboutClose := oGui2.Add("Button", "y+20 vf_btnAboutClose", o_L["GuiClose"])
ogcButtonf_btnAboutClose.OnEvent("Click", _2GuiClose.Bind("Normal"))
oGui2.Add("Link", "x" . intXCol2 . " ys w" . intWidthHalf, L(o_L["AboutText7"], A_AhkVersion))
GuiCenterButtons(g_strGui2Hwnd, , , , , , , "f_btnAboutClose")
ogcButtonf_btnAboutClose.Focus()
ShowGui2AndDisableGuiEditor()
strYear := ""
strGuiTitle := ""
aaL := ""
intWidth := ""
intWidthHalf := ""
intXCol2 := ""
return
} ; V1toV2: Added bracket before function
OpenQCEWebsite(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
OpenQCEWebsiteHelp:
Run(AddUtm2Url("https://A_Clipboard.quickaccesspopup.com/" . (InStr(A_ThisLabel, "Help") ? "features/" : ""), A_ThisLabel, "Help"))
return
} ; V1toV2: Added bracket before function
Check4Update()
{ ; V1toV2: Added bracket
Check4UpdateNow:
strUrlCheck4Update := "https://A_Clipboard.quickaccesspopup.com/latest/latest-version-1.php"
g_strUrlAppLandingPage := "https://A_Clipboard.quickaccesspopup.com"
strBetaLandingPage := "https://A_Clipboard.quickaccesspopup.com/A_Clipboard/latest/check4update-beta-redirect.html"
strLatestSkippedProd := o_Settings.ReadIniValue("LatestVersionSkipped", 0.0)
strLatestSkippedBeta := o_Settings.ReadIniValue("LatestVersionSkippedBeta", 0.0)
strLatestUsedBeta := o_Settings.ReadIniValue("LastVersionUsedBeta", 0.0)
strLatestSkippedAlpha := o_Settings.ReadIniValue("LatestVersionSkippedAlpha", 0.0)
strLatestUsedAlpha := o_Settings.ReadIniValue("LastVersionUsedAlpha", 0.0)
blnSetup := (FileExist(A_ScriptDir . "\_do_not_remove_or_rename.txt") = "" ? 0 : 1)
strQuery := strUrlCheck4Update. "?v=" . g_strCurrentVersion. "&os=" . GetOSVersion(). "&is64=" . A_Is64bitOS. "&setup=" . (blnSetup ? 1 : 0). "&lsys=" . A_Language. "&lqce=" . o_Settings.Launch.strLanguageCode.IniValue. "&nbi=0"
strLatestVersions := Url2Var(strQuery)
if !StrLen(strLatestVersions)
if (A_ThisLabel = "Check4UpdateNow")
{
Oops(0, o_L["UpdateError"])
Check4UpdateCleanup()
return
}
strLatestVersions := SubStr(strLatestVersions, (InStr(strLatestVersions, "[[") + 2)<1 ? (InStr(strLatestVersions, "[[") + 2)-1 : (InStr(strLatestVersions, "[[") + 2))
strLatestVersions := SubStr(strLatestVersions, 1, InStr(strLatestVersions, "]]") - 1)
strLatestVersions := Trim(strLatestVersions, "`n`l")
Loop Parse, strLatestVersions, "", "0123456789.|"
if (A_ThisMenuItem <> aaHelpL["MenuUpdate"])
{
Check4UpdateCleanup()
return
}
else
{
Oops(0, o_L["UpdateError"])
Check4UpdateCleanup()
return
}
saLatestVersions := StrSplit(strLatestVersions, "|")
strLatestVersionProd := saLatestVersions[1]
strLatestVersionBeta := saLatestVersions[2]
strLatestVersionAlpha := saLatestVersions[3]
if (strLatestUsedAlpha <> "0.0" and ProposeUpdate(strLatestVersionAlpha, g_strCurrentVersion, strLatestSkippedAlpha))
{
g_strUpdateProdOrBeta := "alpha"
g_strUpdateLatestVersion := strLatestVersionAlpha
GuiCheck4Update()
}
else if (strLatestUsedBeta <> "0.0" and ProposeUpdate(strLatestVersionBeta, g_strCurrentVersion, strLatestSkippedBeta))
{
g_strUpdateProdOrBeta := "beta"
g_strUpdateLatestVersion := strLatestVersionBeta
GuiCheck4Update()
}
else if ProposeUpdate(strLatestVersionProd, g_strCurrentVersion, strLatestSkippedProd)
{
g_strUpdateProdOrBeta := "prod"
g_strUpdateLatestVersion := strLatestVersionProd
GuiCheck4Update()
}
else if (A_ThisLabel = "Check4UpdateNow")
{
msgResult := MsgBox(l(o_L["UpdateYouHaveLatest"], g_strAppVersion, g_strAppNameText), l(o_L["UpdateTitle"], g_strAppNameText), 4)
if (msgResult = "Yes")
Run(g_strUrlAppLandingPage)
}
Check4UpdateCleanup()
{ ; V1toV2: Added bracket
strLatestSkippedAlpha := ""
strLatestSkippedBeta := ""
strLatestSkippedProd := ""
strLatestUsedAlpha := ""
strLatestUsedBeta := ""
strQuery := ""
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
ProposeUpdate(strVersionNew, strVersionRunning, strVersionSkipped)
{
return (ComparableVersionNumber(strVersionNew) > ComparableVersionNumber(strVersionRunning)
and ComparableVersionNumber(strVersionNew) >= ComparableVersionNumber(strVersionSkipped))
}
ToggleKeepOpenAfterPaste(strMenuItemName)
{
g_blnKeepOpenAfterPasteCurrent := !g_blnKeepOpenAfterPasteCurrent
UpdateToggleMenus()
}
ToggleCopyToAppend(strMenuItemName)
{
g_blnCopyToAppendCurrent := !g_blnCopyToAppendCurrent
UpdateToggleMenus()
}
UpdateToggleMenus()
{ ; V1toV2: Added bracket
menuBarEditorOptions.% (g_blnKeepOpenAfterPasteCurrent ? "Check" : "Uncheck")(g_aaOptionsL["MenuKeepOpenAfterPaste"])
menuBarEditorOptions.% (g_blnCopyToAppendCurrent ? "Check" : "Uncheck")(g_aaOptionsL["MenuCopyToAppend"])
return
} ; V1toV2: Added Bracket before label
ToggleSuspendHotkeys(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
Suspend((A_IsSuspended ? "false" : "true"))
Tray.% (A_IsSuspended ? "Check" : "Uncheck")(g_aaTrayL["MenuSuspendHotkeys"])
return
} ; V1toV2: Added bracket before function
EnableClipboardChangesInEditor()
{ ; V1toV2: Added bracket
DisableClipboardChangesInEditor()
{ ; V1toV2: Added bracket
OnClipboardChange(ClipboardContentChanged, (A_ThisLabel := "EnableClipboardChangesInEditor"))
SetStatusBarText(1, A_ThisLabel)
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
GuiDonate(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
Run(AddUtm2Url("https://www.paypal.com/donate/?hosted_button_id=F22JAQULFM6C4", A_ThisLabel, "Donation"))
return
} ; V1toV2: Added Bracket before label
ReloadQCE()
{ ; V1toV2: Added bracket
ReloadQCEAsAdmin:
SetCursor(false)
strCurrentCommandLineParameters := o_CommandLineParameters.strParams
try
{
if (A_IsCompiled)
if (A_ThisLabel = "ReloadQCEAsAdmin" or A_IsAdmin)
RunWait("*RunAs " A_ScriptFullPath " /restart " strCurrentCommandLineParameters)
else
RunWait(A_ScriptFullPath " /restart " strCurrentCommandLineParameters)
else
if (A_ThisLabel = "ReloadQCEAsAdmin" or A_IsAdmin)
RunWait("*RunAs " A_AhkPath " /restart " A_ScriptFullPath " " strCurrentCommandLineParameters)
else
RunWait(A_AhkPath " /restart " A_ScriptFullPath " " strCurrentCommandLineParameters)
ExitApp()
}
Oops(0, o_L["OopsNotAdmin"], g_strAppNameText)
strCurrentCommandLineParameters := ""
return
} ; V1toV2: Added Bracket before label
!_085_SETTIMER_COMMANDS:
return
UpdateEditorEditMenuAndStatusBar()
{ ; V1toV2: Added bracket
Editor.Default()
SetStatusBarText(2)
menuBarEditorEdit.% (o_UndoPile.CanUndo() ? "Enable" : "Disable")(g_aaEditL["DialogUndo"] . "`t(Ctrl+Z)")
menuBarEditorEdit.% (o_UndoPile.CanRedo() ? "Enable" : "Disable")(g_aaEditL["DialogRedo"] . "`t(Ctrl+Y)")
menuBarEditorEdit.% (Edit_TextIsSelected(g_strEditorControlHwnd) ? "Enable" : "Disable")(g_aaEditL["DialogCut"] . "`t(Ctrl+X)")
menuBarEditorEdit.% (Edit_TextIsSelected(g_strEditorControlHwnd) ? "Enable" : "Disable")(g_aaEditL["DialogCopy"] . "`t(Ctrl+C)")
menuBarEditorEdit.% (Edit_TextIsSelected(g_strEditorControlHwnd) ? "Enable" : "Disable")(g_aaEditL["DialogDelete"] . "`t(Del)")
menuBarEditorEdit.% (ClipboardIsFree(A_ThisLabel . " w/o CloseClipboard") ? (StrLen(A_Clipboard) ? "Enable" : "Disable") : "Enable")(g_aaEditL["DialogPaste"] . "`t(Ctrl+V)")
menuBarEditorEdit.% (g_blnWordWrapCurrent ? "Disable" : "Enable")(g_aaEditL["DialogMoveLineUp"] . "`t(Shift+Ctrl+Up)")
menuBarEditorEdit.% (g_blnWordWrapCurrent ? "Disable" : "Enable")(g_aaEditL["DialogMoveLineDown"] . "`t(Shift+Ctrl+Down)")
intSbSelStart := ""
intSbSelLine := ""
intSbSelLineStart := ""
intSbSelLength := ""
return
} ; V1toV2: Added bracket before function
AddToUndoPile()
{ ; V1toV2: Added bracket
AddToUndoPileTimer()
{ ; V1toV2: Added bracket
AddToUndoPileFromHotkey()
{ ; V1toV2: Added bracket
o_UndoPile.AddToPile()
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
RemoveToolTip1()
{ ; V1toV2: Added bracket
SetTimer(RemoveToolTip1,0)
ToolTip(, , , 1)
return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function
RemoveToolTip2()
{ ; V1toV2: Added bracket
SetTimer(RemoveToolTip2,0)
ToolTip(, , , 2)
return
} ; V1toV2: Added bracket before function
RemoveOldTemporaryFolders()
{ ; V1toV2: Added bracket
Loop Files, g_strTempDirParent "\_QCE_temp_*", "D"
{
strDate := A_Now
strDate := DateDiff(strDate, A_LoopFileTimeModified, "D")
if (strDate > 5)
{
DirDelete(A_LoopFilePath, 1)
Sleep(10000)
}
}
return
} ; V1toV2: Added Bracket before label
!_087_ENCODING_FUNCTIONS:
return
EncodeDecodeURI(str, blnEncode := true, blnComponent := true)
{
static oDoc, oJS
if !oDoc
{
oDoc := ComObject("htmlfile")
oDoc.write("<meta http-equiv=""X-UA-Compatible"" content=""IE=9"">")
oJS := oDoc.parentWindow
( oDoc.documentMode < 9 && JS.execScript() )
}
strResult := oJS[(blnEncode ? "en" : "de") . "codeURI" . (blnComponent ? "Component" : "") ](str)
return (StrLen(strResult) ? strResult : str)
}
DecodeXML(str)
{
Loop
if RegExMatch(str, "S.Length)(&#(\d+);)", &dec)
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, dec[1], Chr(dec[2]))
else if RegExMatch(str, "Si)(&#x([\da-f]+);)", &hex)
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, hex[1], Chr("0x" . hex[2]))
else
break
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&nbsp;", A_Space)
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&quot;", "`"")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&apos;", "'")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&lt;", "<")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&gt;", ">")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&amp;", "&")
return str
}
EncodeXML(str, chars:="")
{
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "&", "&amp;")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "`"", "&quot;")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "'", "&apos;")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, "<", "&lt;")
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, ">", "&gt;")
Loop Parse, chars
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
str := StrReplace(str, A_LoopField, "&#" . Ord(A_LoopField) . "`;")
return str
}
GetXMLEncodeNumeric()
{
Editor.Opt("+OwnDialogs")
strLastXMLChars := IniRead(o_Settings.strIniFile, "Internal", "LastXMLChars", A_Space)
IB := InputBox(o_L["EditXMLEncodeNumericPrompt"], g_strAppNameFile . " - " . o_L["EditXMLEncodeNumeric"], "w400 h160", strLastXMLChars), strChars := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
if (ErrorLevel = 0
and StrLen(strChars))
{
IniWrite(strChars, o_Settings.strIniFile, "Internal", "LastXMLChars")
return strChars
}
}
dec["odeHex"](strHex)
{
Loop StrLen(strHex)/2
{
intPos := (A_Index - 1) * 2 + 1
strChr := SubStr(strHex, intPos, 2)
strDecode := strDecode . Chr("0x" . strChr)
}
return strDecode
}
EncodeHex(str)
{
; REMOVED: prevFmt := A_FormatInteger
; REMOVED: SetFormat Integer, H
Loop Parse, str
hex[0] .= 0x100+Ord(A_LoopField)
; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
hex := StrReplace(hex[0], 1)
; REMOVED: SetFormat Integer, %prevFmt%
return hex[0]
}
dec["odeASCII"](str)
{
str := StrReplace(str, "`r 13`r`n`n 10", g_strEscapeReplacement)
Loop Parse, str, "`n", "`r"
if (A_LoopField = g_strEscapeReplacement)
strList .= "`r`n"
else
strList .= SubStr(A_LoopField, 1, 1)
return strList
}
EncodeASCII(str)
{
Loop Parse, str
strAscii .= A_LoopField . " " . Ord(A_LoopField) . "`r`n"
strAscii := SubStr(strAscii, 1, -1)
Return strAscii
}
dec["odeHTML"](str)
{
oHTML := ComObject("HTMLFile")
oHTML.write(str)
strResult := oHTML.documentElement.innerText
return (StrLen(strResult) ? strResult : str)
}
EncodeHTML(String, Flags := 1)
{
; REMOVED: SetBatchLines, -1
static TRANS_HTML_NAMED := 1
static TRANS_HTML_NUMBERED := 2
static ansi := ["euro", "#129", "sbquo", "fnof", "bdquo", "hellip", "dagger", "Dagger", "circ", "permil", "Scaron", "lsaquo", "OElig", "#141", "#381", "#143", "#144", "lsquo", "rsquo", "ldquo", "rdquo", "bull", "ndash", "mdash", "tilde", "trade", "scaron", "rsaquo", "oelig", "#157", "#382", "Yuml", "nbsp", "iexcl", "cent", "pound", "curren", "yen", "brvbar", "sect", "uml", "copy", "ordf", "laquo", "not", "shy", "reg", "macr", "deg", "plusmn", "sup2", "sup3", "acute", "micro", "para", "middot", "cedil", "sup1", "ordm", "raquo", "frac14", "frac12", "frac34", "iquest", "Agrave", "Aacute", "Acirc", "Atilde", "Auml", "Aring", "AElig", "Ccedil", "Egrave", "Eacute", "Ecirc", "Euml", "Igrave", "Iacute", "Icirc", "Iuml", "ETH", "Ntilde", "Ograve", "Oacute", "Ocirc", "Otilde", "Ouml", "times", "Oslash", "Ugrave", "Uacute", "Ucirc", "Uuml", "Yacute", "THORN", "szlig", "agrave", "aacute", "acirc", "atilde", "auml", "aring", "aelig", "ccedil", "egrave", "eacute", "ecirc", "euml", "igrave", "iacute", "icirc", "iuml", "eth", "ntilde", "ograve", "oacute", "ocirc", "otilde", "ouml", "divide", "oslash", "ugrave", "uacute", "ucirc", "uuml", "yacute", "thorn", "yuml"]
static unicode := {0x20AC:1, 0x201A:3, 0x0192:4, 0x201E:5, 0x2026:6, 0x2020:7, 0x2021:8, 0x02C6:9, 0x2030:10, 0x0160:11, 0x2039:12, 0x0152:13, 0x2018:18, 0x2019:19, 0x201C:20, 0x201D:21, 0x2022:22, 0x2013:23, 0x2014:24, 0x02DC:25, 0x2122:26, 0x0161:27, 0x203A:28, 0x0153:29, 0x0178:32}
if !1 && !(Flags & TRANS_HTML_NAMED)
throw Exception("Parameter #2 must be omitted or 1 in the ANSI version.", -1)
out  := ""
for i, char in StrSplit(String)
{
code := Ord(char)
if (code = 13)
continue
switch code
{
case 10: out .= "<br \>" . Chr(13) . Chr(10)
case 34: out .= "&quot;"
case 38: out .= "&amp;"
case 60: out .= "&lt;"
case 62: out .= "&gt;"
default:
if (code >= 160 && code <= 255)
{
if (Flags & TRANS_HTML_NAMED)
out .= "&" ansi[code-127] ";"
else if (Flags & TRANS_HTML_NUMBERED)
out .= "&#" code ";"
else
out .= char
}
else if (1 && code > 255)
{
if (Flags & TRANS_HTML_NAMED && unicode[code])
out .= "&" ansi[unicode[code]] ";"
else if (Flags & TRANS_HTML_NUMBERED)
out .= "&#" code ";"
else
out .= char
}
else
{
if (code >= 128 && code <= 159)
out .= "&" ansi[code-127] ";"
else
out .= char
}
}
}
return out
}
dec["odePHPDouble"](str)
{
str := StrReplace(str, "\r\n", "`r`n")
str := StrReplace(str, "\t", "`t")
str := StrReplace(str, "\\", "\")
str := StrReplace(str, "\$", "$")
str := StrReplace(str, "\`"", "`"")
return str
}
EncodePHPDouble(str)
{
str := StrReplace(str, "\", "\\")
str := StrReplace(str, "`r`n", "\r\n")
str := StrReplace(str, "`t", "\t")
str := StrReplace(str, "$", "\$")
str := StrReplace(str, "`"", "\`"")
return str
}
dec["odePHPSingle"](str)
{
str := StrReplace(str, "\\", "\")
str := StrReplace(str, "\'", "'")
return str
}
EncodePHPSingle(str)
{
str := StrReplace(str, "\", "\\")
str := StrReplace(str, "'", "\'")
return str
}
dec["odeAHK"](str)
{
str := StrReplace(str, "````", "!r4nd0mt3xt!")
str := StrReplace(str, "``n", "`r`n")
str := StrReplace(str, "``t", "`t")
str := StrReplace(str, "`"`"", "`"")
str := StrReplace(str, "!r4nd0mt3xt!", "``")
return str
}
EncodeAHK(str)
{
str := StrReplace(str, "``", "````")
str := StrReplace(str, "`r`n", "``n")
str := StrReplace(str, "`t", "``t")
str := StrReplace(str, "`"", "`"`"")
return str
}
dec["odeAHKVarExpression"](str)
{
saStr := StrSplit(str)
intPos := 1
Loop
{
if (saStr[intPos] = "%")
{
if (intPos > 1)
strResult .= """ . "
intPos++
Loop
{
strResult .= saStr[intPos]
intPos++
} Until (saStr[intPos] = "%")
if (intPos <> saStr.MaxIndex())
strResult .= " . """
}
else
{
if (intPos = 1)
strResult := """"
if (saStr[intPos] = "``" and saStr[intPos + 1] = "%")
{
strResult .= "%"
intPos++
}
else
strResult .= saStr[intPos]
}
intPos++
} Until intPos > saStr.MaxIndex()
if (saStr[intPos-1] <> "%")
or (saStr[intPos-2] = "``" and saStr[intPos-1] = "%")
strResult .= """"
return strResult
}
EncodeAHKVarExpression(str)
{
saStr := StrSplit(str)
intPos := 1
Loop
{
if (saStr[intPos] = """")
{
if (intPos > 1)
strResult .= "%"
intPos++
Loop
{
if (saStr[intPos] = "%")
strResult .= "``"
strResult .= saStr[intPos]
intPos++
} Until (saStr[intPos] = """")
if (intPos <> saStr.MaxIndex())
strResult .= "%"
}
else
{
if (intPos = 1)
strResult := "%"
if (saStr[intPos] <> " " and saStr[intPos] <> A_Tab and saStr[intPos] <> "`n" and saStr[intPos] <> ".")
strResult .= saStr[intPos]
}
intPos++
} Until intPos > saStr.MaxIndex()
if (saStr[intPos-1] <> """")
strResult .= "%"
return strResult
}
dec["odeClipboardAllBase64"](str)
{
strDestFilePath := A_Temp . "\ClipboardDec.clip"
intBytes := Base64Dec(str, oBin)
oFile := FileOpen(strDestFilePath, "w")
oFile.RawWrite(oBin, intBytes)
oFile.Close()
WinClip.Load(strDestFilePath)
FileDelete(strDestFilePath)
return ""
}
EncodeClipboardAllBase64()
{
strDestFilePath := A_Temp . "\A_Clipboard.clip"
intBytes := WinClip.Save(strDestFilePath)
oClipboardAllBin := Fileread(strDestFilePath, "c")
FileDelete(strDestFilePath)
strBase64 := Base64Enc(oClipboardAllBin, intBytes)
return strBase64
}
dec["odeClipboardImageBase64"](str)
{
strDestFilePath := A_Temp . "\QuickClipboardEditorImageDec.png"
intBytes := Base64Dec(str, oBin)
oFile := FileOpen(strDestFilePath, "w")
oFile.RawWrite(oBin, intBytes)
oFile.Close()
pToken := Gdip_Startup()
pBitmap := Gdip_CreateBitmapFromFile(strDestFilePath)
Gdip_SetBitmapToClipboard(pBitmap)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
FileDelete(strDestFilePath)
}
EncodeClipboardImageBase64()
{
strTempImagePathFile := A_WorkingDir . "\QuickClipboardEditorImage.png"
if SaveImageInClipoardToFile(strTempImagePathFile)
{
intBytes := FileGetSize(strTempImagePathFile)
oPngBin := Fileread(strTempImagePathFile, "c")
strBase64 := Base64Enc(oPngBin, intBytes, 64, 0)
return strBase64
}
}
Base64Dec( &B64, &Bin )
{
Local Rqd := 0
BLen := StrLen(B64)
DllCall("Crypt32.dll\CryptStringToBinary", "Str", B64, "UInt", BLen, "UInt", 0x1, "UInt", 0, "UIntP", &Rqd, "Int", 0, "Int", 0)
VarSetStrCapacity(&Bin, 128) ; V1toV2: if 'Bin' is NOT a UTF-16 string, use 'Bin := Buffer(128)'
VarSetStrCapacity(&Bin, 0) ; V1toV2: if 'Bin' is NOT a UTF-16 string, use 'Bin := Buffer(0)'
Bin := Buffer(Rqd, 0) ; V1toV2: if 'Bin' is a UTF-16 string, use 'VarSetStrCapacity(&Bin, Rqd)'
DllCall("Crypt32.dll\CryptStringToBinary", "Str", B64, "UInt", BLen, "UInt", 0x1, "Ptr", Bin, "UIntP", &Rqd, "Int", 0, "Int", 0)
return Rqd
}
Base64Enc(&Bin, nBytes, LineLength := 64, LeadingSpaces := 0)
{
Local Rqd := 0, B64, B := "", N := 0 - LineLength + 1
DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", Bin, "UInt", nBytes, "UInt", 0x1, "Ptr", 0, "UIntP", &Rqd)
B64 := Buffer(Rqd * (1 ? 2 : 1), 0) ; V1toV2: if 'B64' is a UTF-16 string, use 'VarSetStrCapacity(&B64, Rqd * (A_Isunicode ? 2 : 1))'
DllCall("Crypt32.dll\CryptBinaryToString", "Ptr", Bin, "UInt", nBytes, "UInt", 0x1, "Str", B64, "UIntP", &Rqd)
If (LineLength = 64 and ! LeadingSpaces)
return B64
B64 := StrReplace(B64, "`r`n")
Loop Ceil(StrLen(B64) / LineLength)
B .= Format("{1:" . LeadingSpaces . "S.Length}", "") . SubStr(B64, (N += LineLength)<1 ? (N += LineLength)-1 : (N += LineLength), LineLength) . "`n"
return RTrim(B , "`n")
}
SaveImageInClipoardToFile(strFilePath)
{
pToken  := Gdip_Startup()
pBitmap := Gdip_CreateBitmapFromClipboard()
if (pBitmap < 0)
{
Gdip_Shutdown(pToken)
Oops(0, L(o_L["OopsErrorCreatingImage"], pBitmap))
return false
}
intGdipResult := Gdip_SaveBitmapToFile(pBitmap, strFilePath)
Gdip_DisposeImage(pBitmap)
Gdip_Shutdown(pToken)
if (intGdipResult < 0)
Oops("Editor", L(o_L["OopsErrorSavingImage"], intGdipResult, strFilePath))
return (intGdipResult = 0)
}
!_090_VARIOUS_FUNCTIONS:
return
Oops(varOwner, strMessage, objVariables*)
{
if (!varOwner)
varOwner := 1
%varOwner% := Gui()
%varOwner%.Opt("+OwnDialogs")
MsgBox(L(strMessage, objVariables*), L(o_L["OopsTitle"], g_strAppNameText, g_strAppVersion), 48)
}
L(strMessage, objVariables*)
{
Loop
{
if InStr(strMessage, "~" . A_Index . "~")
strMessage := StrReplace(strMessage, "~" . A_Index . "~", objVariables[A_Index])
else
break
}
return strMessage
}
SetCursor(blnOnOff, strCursorName := "")
{
static s_blnCursorWaitAlreadyOn
static s_oWaitCursor
if (blnOnOff)
if (s_blnCursorWaitAlreadyOn)
return
else
{
if StrLen(strCursorName)
if (strCursorName = "wait")
strCursorCode := 32514
else if (strCursorName = "hand")
strCursorCode := 32649
else if (strCursorName = "appstarting")
strCursorCode := 32650
else if (strCursorName = "whatsthis")
strCursorCode := 32651
else
return
s_oWaitCursor :=  DllCall("LoadImage", "Uint", 0, "Uint", strCursorCode, "Uint", 2, "Uint", 0, "Uint", 0, "Uint", 0x8000)
strCursors := "32650,32512,32515,32649,32651,32513,32648,32646,32643,32645,32642,32644,32516,32514"
Loop Parse, strCursors, ","
DllCall("SetSystemCursor", "Uint", DllCall("CopyImage", "Uint", s_oWaitCursor, "Uint", 2, "Int", 0, "Int", 0, "Uint", 0), "Uint", A_LoopField)
s_blnCursorWaitAlreadyOn := true
}
else
{
DllCall("SystemParametersInfo", "Uint", 0x0057, "Uint", 0, "Uint", 0, "Uint", 0)
Sleep(50)
s_oWaitCursor := ""
s_blnCursorWaitAlreadyOn := false
}
}
FileExistInPath(&strFile)
{
strFile := EnvVars(strFile)
if (!StrLen(strFile) or InStr(strFile, "://") or SubStr(strFile, 1, 1) = "{")
return false
if !InStr(strFile, "\")
strFile := WhereIs(strFile)
else
strFile := PathCombine(A_WorkingDir, strFile)
if (SubStr(strFile, 1, 2) = "\\")
{
intPos := InStr(strFile, "\", false, 3)
if !(intPos)
or (SubStr(strFile, (intPos)<1 ? (intPos)-1 : (intPos)) = "\")
return true
}
return FileExist(strFile)
}
WhereIs(strThisFile)
{
if !StrLen(GetFileExtension(strThisFile))
{
Loop Parse, g_strExeExtensions, "`;"
{
strFoundFile := WhereIs(strThisFile . A_LoopField)
} until StrLen(strFoundFile)
return strFoundFile
}
strAhkDir := GetFilePath(A_AhkPath)
strDosPath := EnvGet("Path")
strPaths := A_WorkingDir . ";" . A_ScriptDir . ";" . strAhkDir . ";" . strAhkDir . "\Lib;" . A_MyDocuments . "\AutoHotkey\Lib" . ";" . strDosPath
Loop Parse, strPaths, "`;"
If StrLen(A_LoopField)
If FileExist(A_LoopField . "\" . strThisFile)
Return RegExReplace(A_LoopField . "\" . strThisFile, "\\\\", "\")
strAppPath := RegRead("HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\" strThisFile)
If FileExist(strAppPath)
Return strAppPath
}
PathCombine(strAbsolutePath, strRelativePath)
{
strCombined := Buffer((1 ? 2 : 1) * 260, 1) ; V1toV2: if 'strCombined' is a UTF-16 string, use 'VarSetStrCapacity(&strCombined, (A_IsUnicode ? 2 : 1) * 260)'
DllCall("Shlwapi.dll\PathCombine", "UInt", strCombined, "UInt", strAbsolutePath, "UInt", strRelativePath)
Return strCombined
}
EnvVars(str)
{
if sz:=DllCall("ExpandEnvironmentStrings", "uint", str, "uint", 0, "uint", 0)
{
VarSetStrCapacity(&dst, 1 ? sz*2:sz) ; V1toV2: if 'dst' is NOT a UTF-16 string, use 'dst := Buffer(A_IsUnicode ? sz*2:sz)'
if DllCall("ExpandEnvironmentStrings", "uint", str, "str", dst, "uint", sz)
return dst
}
return str
}
RandomBetween(intMin := 0, intMax := 2147483647)
{
intValue := Random(intMin, intMax)
return intValue
}
CalculateTopGuiPosition(g_strTopHwnd, g_strRefHwnd, &intTopGuiX, &intTopGuiY)
{
WinGetPos(&intRefGuiX, &intRefGuiY, &intRefGuiW, &intRefGuiH, "ahk_id " g_strRefHwnd)
intWindowBorderWidth := SysGet(32)
intWindowBorderHeight := SysGet(33)
intRefGuiX += intWindowBorderWidth
intRefGuiY += intWindowBorderHeight
intRefGuiCenterX := intRefGuiX + (intRefGuiW // 2)
intRefGuiCenterY := intRefGuiY + (intRefGuiH // 2)
WinGetPos(, , &intTopGuiW, &intTopGuiH, "ahk_id " g_strTopHwnd)
intTopGuiX := intRefGuiCenterX - (intTopGuiW // 2)
intTopGuiY := intRefGuiCenterY - (intTopGuiH // 2)
MonitorGet(GetActiveMonitorForPosition(intRefGuiX, intRefGuiY, intNbMonitors), &arrCurrentMonitorLeft, &arrCurrentMonitorTop, &arrCurrentMonitorRight, &arrCurrentMonitorBottom)
intTopGuiX := (intTopGuiX < arrCurrentMonitorLeft ? arrCurrentMonitorLeft : intTopGuiX)
intTopGuiY := (intTopGuiY < arrCurrentMonitorTop ? arrCurrentMonitorTop : intTopGuiY)
}
GetSavedGuiWindowPosition(&saGuiPosition)
{
g_strLastScreenConfiguration := o_Settings.ReadIniValue("LastScreenConfiguration", " ")
strCurrentScreenConfiguration := GetScreenConfiguration()
if !StrLen(g_strLastScreenConfiguration) or (strCurrentScreenConfiguration <> g_strLastScreenConfiguration)
{
IniWrite(strCurrentScreenConfiguration, o_Settings.strIniFile, "Internal", "LastScreenConfiguration")
arrEditorPosition1 := -1
}
else
if (o_Settings.EditorWindow.blnRememberEditorPosition.IniValue)
{
strGuiPosition := o_Settings.ReadIniValue("EditorPosition", -1)
saGuiPosition := StrSplit(strGuiPosition, "|")
}
else
{
IniDelete(o_Settings.strIniFile, "Internal", "EditorPosition")
saGuiPosition[1] := -1
}
g_strLastConfiguration := strCurrentScreenConfiguration
}
GetScreenConfiguration()
{
intNbMonitors := MonitorGetCount()
intIdPrimaryDisplay := MonitorGetPrimary()
strMonitorConfiguration := intNbMonitors . "," . intIdPrimaryDisplay . ":"
Loop intNbMonitors
{
MonitorGet(A_Index, &arrMonitorLeft, &arrMonitorTop, &arrMonitorRight, &arrMonitorBottom)
Loop Parse, "Left|Top|Right|Bottom", "|"
strMonitorConfiguration .= arrMonitor%A_LoopField% . (A_Index < 4 ? "," : "")
strMonitorConfiguration .= (A_Index < intNbMonitors ? "|" : "")
}
return strMonitorConfiguration
}
SaveWindowPosition(strThisWindow, strWindowHandle)
{
intMinMax := WinGetMinMax(strWindowHandle)
if (intMinMax = 1)
WinRestore(strWindowHandle)
WinGetPos(&intX, &intY, &intW, &intH, strWindowHandle)
strPosition := intX . "|" . intY . "|" . intW . "|" . intH . (intMinMax = 1 ? "|M" : "")
IniWrite(strPosition, o_Settings.strIniFile, "Internal", strThisWindow)
}
GetWindowPositionOnActiveMonitor(strWindowId, intActivePositionX, intActivePositionY, &intWindowX, &intWindowY)
{
WinGetPos(&intWindowX, &intWindowY, &intWindowWidth, &intWindowHeight, strWindowId)
intActiveMonitorForWindow := GetActiveMonitorForPosition(intWindowX, intWindowY, intNbMonitors)
intActiveMonitorForPosition := GetActiveMonitorForPosition(intActivePositionX, intActivePositionY, intNbMonitors)
if (intNbMonitors > 1) and intActiveMonitorForWindow and (intActiveMonitorForWindow <> intActiveMonitorForPosition)
{
MonitorGet(intActiveMonitorForPosition, &arrThisMonitorLeft, &arrThisMonitorTop, &arrThisMonitorRight, &arrThisMonitorBottom)
intWindowX := arrThisMonitorLeft + (((arrThisMonitorRight - arrThisMonitorLeft) - intWindowWidth) / 2)
intWindowY := arrThisMonitorTop + (((arrThisMonitorBottom - arrThisMonitorTop) - intWindowHeight) / 2)
return true
}
return false
}
GetActiveMonitorForPosition(intX, intY, &intNbMonitors)
{
intNbMonitors := MonitorGetCount()
Loop intNbMonitors
{
MonitorGet(A_Index, &arrThisMonitorLeft, &arrThisMonitorTop, &arrThisMonitorRight, &arrThisMonitorBottom)
if (intX >= arrThisMonitorLeft and intX < arrThisMonitorRight
and intY >= arrThisMonitorTop and intY < arrThisMonitorBottom)
return A_Index
}
}
GetPositionFromMouseOrKeyboard(strThisHotkey, &intPositionX, &intPositionY)
{
if !StrLen(strThisHotkey)
strPositionReference := "Window"
else
strPositionReference := (InStr(strThisHotkey, "Button") or InStr(strThisHotkey, "Wheel") ? "Mouse" : "Window")
if (strPositionReference = "Mouse")
{
CoordMode("Mouse", "Screen")
MouseGetPos(&intPositionX, &intPositionY)
}
else
WinGetPos(&intPositionX, &intPositionY, , , "A")
}
BuildMonitorsList(intDefault)
{
if !(intDefault)
intDefault := 1
intNbMonitors := MonitorGetCount()
Loop intNbMonitors
str .= o_L["DialogWindowMonitor"] . " " . A_Index . "|" . (A_Index = intDefault ? "|" : "")
return str
}
GetFileExtension(strFile)
{
SplitPath(strFile, , , &strExtension)
return strExtension
}
GetFilePath(strFile)
{
SplitPath(strFile, , &strPath)
return strPath
}
ComparableVersionNumber(strVersionNumber)
{
Loop 4 - StrLen(RegExReplace(strVersionNumber, "[^.]"))
strVersionNumber .= ".0"
Loop Parse, strVersionNumber, "."
{
strSubNumber := A_LoopField
while StrLen(strSubNumber) < 3
strSubNumber := "0" . strSubNumber
strResult .= strSubNumber
}
return strResult
}
RegistryExist(strKeyName, strValueName)
{
strValue := RegRead(strKeyName, strValueName)
return StrLen(strValue)
}
GetRegistry(strKeyName, strValueName)
{
strValue := RegRead(strKeyName, strValueName)
return strValue
}
SetRegistry(strValue, strKeyName, strValueName)
{
RegWrite(strValue, "REG_SZ", strKeyName, strValueName)
if (ErrorLevel)
Oops(0, "An error occurred while writing the registry key.`n`nValue: " . strValueName . "`nKey name: " . strKeyName)
}
RemoveRegistry(strKeyName, strValueName)
{
if !RegistryExist(strKeyName, strValueName)
return
RegDelete(strKeyName, strValueName)
if (ErrorLevel)
Oops(0, "An error occurreed while removing the registre key.`n`nValue: " . strValueName . "`nKey name: " . strKeyName)
}
HasShortcut(strCandidateShortcut)
{
return StrLen(strCandidateShortcut) and (strCandidateShortcut <> "None")
}
HasShortcutText(strCandidateShortcutText)
{
return StrLen(strCandidateShortcutText) and (strCandidateShortcutText <> o_L["DialogNone"])
}
StrUpper(str)
{
strUpper := StrUpper(str)
return strUpper
}
GetOSVersion()
{
if (GetOSVersionInfo().MajorVersion = 10)
return "WIN_10"
else
return A_OSVersion
}
GetOSVersionInfo()
{
static s_oVer
If !s_oVer
{
OSVer := Buffer(284, 0) ; V1toV2: if 'OSVer' is a UTF-16 string, use 'VarSetStrCapacity(&OSVer, 284)'
NumPut("UInt", 284, OSVer, 0)
If !DllCall("GetVersionExW", "Ptr", OSVer)
return 0
s_oVer := Object()
s_oVer.MajorVersion      := NumGet(OSVer, 4, "UInt")
s_oVer.MinorVersion      := NumGet(OSVer, 8, "UInt")
s_oVer.BuildNumber       := NumGet(OSVer, 12, "UInt")
s_oVer.PlatformId        := NumGet(OSVer, 16, "UInt")
s_oVer.ServicePackString := StrGet(&OSVer+20, 128, "UTF-16")
s_oVer.ServicePackMajor  := NumGet(OSVer, 276, "UShort")
s_oVer.ServicePackMinor  := NumGet(OSVer, 278, "UShort")
s_oVer.SuiteMask         := NumGet(OSVer, 280, "UShort")
s_oVer.ProductType       := NumGet(OSVer, 282, "UChar")
s_oVer.EasyVersion       := s_oVer.MajorVersion . "." . s_oVer.MinorVersion . "." . s_oVer.BuildNumber
}
return s_oVer
}
GuiCenterButtons(strWindowHandle, blnResizableWindow := false, intInsideHorizontalMargin := 10, intInsideVerticalMargin := 0, intDistanceBetweenButtons := 20, intLeftOffset := 0, intRightOffset := 0, arrControls*)
{
strDetectHiddenWindowsBefore := A_DetectHiddenWindows
DetectHiddenWindows(true)
if !(blnResizableWindow)
%varOwner%.Show("Hide")
WinGetPos(, , &intWidth, , "ahk_id " strWindowHandle)
intWidth := intWidth // (A_ScreenDPI / 96)
intWidth -= (intLeftOffset + intRightOffset)
intMaxControlWidth := 0
intMaxControlHeight := 0
intNbControls := 0
for intIndex, strControl in arrControls
if StrLen(strControl)
{
intNbControls++
ogc%strControl%.GetPos(&arrControlPosX, &arrControlPosY, &arrControlPosW, &arrControlPosH)
if (arrControlPosW > intMaxControlWidth)
intMaxControlWidth := arrControlPosW
if (arrControlPosH > intMaxControlHeight)
intMaxControlHeight := arrControlPosH
}
if !(blnResizableWindow)
intMaxControlWidth := intMaxControlWidth + intInsideHorizontalMargin
intButtonsWidth := (intNbControls * intMaxControlWidth) + ((intNbControls  - 1) * intDistanceBetweenButtons)
intLeftMargin := (intWidth - intButtonsWidth) // 2
intLeftMargin += intLeftOffset
for intIndex, strControl in arrControls
if StrLen(strControl)
ogc%strControl%.Move(intLeftMargin + ((intIndex - 1) * intMaxControlWidth) + ((intIndex - 1) * intDistanceBetweenButtons), , intMaxControlWidth, intMaxControlHeight + intInsideVerticalMargin)
DetectHiddenWindows(strDetectHiddenWindowsBefore)
}
AddUtm2Url(strUrl, strMedium, strCampaign)
{
strUrl .= (InStr(strUrl, "?") ? "&" : "?")
strUrl .= "utm_source=QAP&utm_medium=" . strMedium . "&utm_campaign=" . strCampaign
return strUrl
}
EditorUnsaved()
{
blnEditorEditSaveEnabled := ogcButtonf_btnEditorCopy.Enabled
return blnEditorEditSaveEnabled
}
EditorVisible()
{
strDetectHiddenWindowsBefore := A_DetectHiddenWindows
DetectHiddenWindows(false)
blnExist := WinExist("ahk_id " . g_intEditorHwnd)
DetectHiddenWindows(strDetectHiddenWindowsBefore)
return blnExist
}
WinActiveQCE()
{
return WinActive("ahk_id " . g_intEditorHwnd)
}
ConvertInvisible(str, blnForMenuOrSearch := false)
{
strTabReplacement := "¤¢£"
strCrLfReplacement := "²¬¼"
intUnicodeBase := 0x2400
Loop 32
if InStr(str, Chr(A_Index))
Switch A_Index
{
Case 9:
str := StrReplace(str, A_Tab, Chr(0x21E5) . (!blnForMenuOrSearch ? strTabReplacement : ""))
Case 10:
str := StrReplace(str, "`n", Chr(0x21B2) . strCrLfReplacement)
Case 13:
if !(blnForMenuOrSearch)
str := StrReplace(str, "`r", Chr(A_Index + intUnicodeBase))
Case 32:
if !(blnForMenuOrSearch)
str := StrReplace(str, A_Space, Chr(0x00B7))
Default:
str := StrReplace(str, Chr(A_Index), Chr(A_Index + intUnicodeBase))
}
str := StrReplace(str, strTabReplacement, Chr(9))
str := StrReplace(str, strCrLfReplacement, "`r`n")
return str
}
EscapeRegexString(strRegEx)
{
Loop Parse, "\.*?+[{|()^$"
strRegEx := StrReplace(strRegEx, A_LoopField, "\" . A_LoopField)
return strRegEx
}
DoubleDoubleQuotes(str)
{
return StrReplace(str, "`"", "`"`"")
}
EncodeEolAndTab(strText)
{
strText := StrReplace(strText, "``", "````")
strText := StrReplace(strText, "`r", "")
strText := StrReplace(strText, "`n", "``n")
strText := StrReplace(strText, "`t", "``t")
return strText
}
dec["odeEolAndTab"](strText)
{
strText := StrReplace(strText, "````", "!r4nd0mt3xt!")
strText := StrReplace(strText, "``n", "`r`n")
strText := StrReplace(strText, "``t", "`t")
strText := StrReplace(strText, "!r4nd0mt3xt!", "``")
return strText
}
IsReadOnly()
{
blnReadOnly := ogcCheckboxf_blnSeeInvisible.Text
return blnReadOnly
}
RGB(intLow, intMed, intHigh)
{
return intLow + (intMed * 256) + (intMed * 65536)
}
SetStatusBarText(intSB, strCaller := "")
{
if (intSB = 1)
{
strContent := (EditorUnsaved() ? (IsLastHistory() ? o_L["OptionsClipboardHistory"] : o_L["DialogClipboardEditing"])
: (IsReadOnly() ? o_L["DialogClipboardReadOnly"] : o_L["DialogClipboardSynced"])) . ": "
if !ClipboardIsFree(strCaller . ">" . A_ThisFunc)
strContent .= (WinExist("ahk_class XLMAIN") ? o_L["GuiUnavailableXL"] : o_L["GuiLocked"])
else
{
intClipboardSize := WinClip.Snap(oFoobar)
if (g_intClipboardContentType = 1)
or (g_intClipboardContentType = 0 and Edit_GetTextLength(g_strEditorControlHwnd))
or EditorUnsaved()
{
intLength := (g_blnSeeInvisible ? StrLen(A_Clipboard) : Edit_GetTextLength(g_strEditorControlHwnd))
strContent .= (intLength = 1 ? o_L["GuiOneCharacter"] : L(o_L["GuiCharacters"], intLength)). (g_intClipboardContentType <> 1 ? " (+ " . o_L["DialogClipboardBinary"] . ")" : "")
}
else if (g_intClipboardContentType = 2)
strContent .= (g_blnClipboardIsBitmap ? o_L["GuiBitmap"] : o_L["GuiBinary"]) . " (" . Round(intClipboardSize / 1024 * (1 ? 2 : 1), 0) . " " . o_L["GuiKB"] . ")"
else
if (!intClipboardSize)
strContent .= o_L["GuiEmpty"]
}
if EditorUnsaved() and FileExist("C:\Dropbox\AutoHotkey\QuickClipboardEditor\QuickClipboardEditor-HOME.ini")
strContent .= " (" . g_intUndoRedoOffset . "/" . g_intUndoPileNb . "=" . g_intUndoPileSize//1024 . " k)"
}
else if (intSB = 2)
{
intSelStart := Edit_GetSel(g_strEditorControlHwnd)
intSelLine := Edit_LineFromChar(g_strEditorControlHwnd, intSelStart)
intSelLineStart := Edit_LineIndex(g_strEditorControlHwnd, intSelLine)
intSelLength := StrLen(Edit_GetSelText(g_strEditorControlHwnd))
strContent := o_L["DialogLine"] . ": " . intSelLine + 1. "  |  " . o_L["DialogChar"] . ": " . intSelStart - intSelLineStart + 1. (g_blnSeeInvisible ? "" : "  |  " . o_L["DialogPos"] . ": " . intSelStart + 1). "  |  " . o_L["DialogSel"] . ": " . intSelLength
}
SB.SetText(strContent, intSB)
if (intSB = 2 and !g_blnClipboardIsBitmap)
{
strSelChar := Edit_GetTextRange(g_strEditorControlHwnd, intSelStart, intSelStart + 1)
if StrLen(strSelChar) and (intSelStart < Edit_GetTextLength(g_strEditorControlHwnd))
strSb3 := "Asc " . StrReplace(Format("{1:". (o_Settings.EditorWindow.blnAsciiHexa.IniValue ? "#X" : "u"). "}", Ord(strSelChar)), "0X", "0x")
else
strSb3 := ""
SB.SetText(strSb3, 3)
}
if (intSB = 1)
{
strSb3 := (g_blnClipboardIsBitmap ? o_L["GuiStatusBarSeeImage"] : "")
SB.SetText(strSb3, 3)
}
}
EscapeQuote(str)
{
return StrReplace(str, "'", "''")
}
Convert2CrLf(str)
{
return (InStr(str, "`r`n") ? str : RegExReplace(str, "[\r\n]", "`r`n"))
}
DialogConfirmCancel()
{
%varOwner%.Opt("+OwnDialogs")
msgResult := MsgBox(o_L["DialogCancelPrompt"], L(o_L["DialogCancelTitle"], g_strAppNameText, g_strAppVersion), 36)
if (msgResult = "No")
return false
else
return true
}
GetPixelSizeOfText(str)
{
strFont := "MS Shell Dlg"
strFontSize := 8
oTextExtentPoint := GetTextExtentPoint(str, strFont, strFontSize, 0)
a1 := oTextExtentPoint.W
return oTextExtentPoint.W
}
GetTextExtentPoint(sString, sFaceName, nHeight := 9, bBold := False, bItalic := False, bUnderline := False, bStrikeOut := False, nCharSet := 0)
{
hDC := DllCall("GetDC", "Uint", 0)
nHeight := -DllCall("MulDiv", "int", nHeight, "int", DllCall("GetDeviceCaps", "Uint", hDC, "int", 90), "int", 72)
hFont := DllCall("CreateFont", "int", nHeight, "int", 0, "int", 0, "int", 0, "int", 400 + 300 * bBold, "Uint", bItalic, "Uint", bUnderline, "Uint", bStrikeOut, "Uint", nCharSet, "Uint", 0, "Uint", 0, "Uint", 0, "Uint", 0, "str", sFaceName)
hFold := DllCall("SelectObject", "Uint", hDC, "Uint", hFont)
DllCall("GetTextExtentPoint32", "Uint", hDC, "str", sString, "int", StrLen(sString), "int64P", &nSize)
DllCall("SelectObject", "Uint", hDC, "Uint", hFold)
DllCall("DeleteObject", "Uint", hFont)
DllCall("ReleaseDC", "Uint", 0, "Uint", hDC)
nWidth  := nSize & 0xFFFFFFFF
nHeight := nSize >> 32 & 0xFFFFFFFF
Size := {}
Size.W := nWidth
Size.H := nHeight
return Size[0]
}
ClipboardIsFree(strCaller)
{
if WinExist("ahk_class XLMAIN") and InStr(strCaller, "SetStatusBarText")
{
Diag(A_ThisFunc . " - SKIP", "Caller", strCaller)
return false
}
pGetClipboardOwner := DllCall("GetClipboardOwner")
strGetClipboardOwner := WinGetTitle("ahk_id " pGetClipboardOwner)
while pClipboardOwner := DllCall("GetOpenClipboardWindow")
{
Diag(A_ThisFunc . " - BUSY " . A_Index, "Caller", strCaller)
Diag(A_ThisFunc . " - BUSY " . A_Index, "Owner", strGetClipboardOwner . "(" . pGetClipboardOwner . ")")
if (A_Index > 10)
{
return false
}
else
Sleep(100)
}
if (strCaller <> "UpdateEditorEditMenuAndStatusBar" . " w/o CloseClipboard")
{
Diag(A_ThisFunc . " - FREE", "Caller", strCaller)
Diag(A_ThisFunc . " - FREE", "Owner", strGetClipboardOwner . "(" . pGetClipboardOwner . ")")
}
return true
}
GetNumberAfterP(str)
{
RegExMatch(str, "[0-9]*", &intNumber, (InStr(str, "P", true) + 1)<1 ? (InStr(str, "P", true) + 1)-1 : (InStr(str, "P", true) + 1))
return intNumber[0]
}
InStrMultipleAnd(strHaystack, strNeedle, strSeparator, blnCaseSensitive := false)
{
saNeedle := StrSplit(strNeedle, strSeparator)
Loop saNeedle.MaxIndex()
if StrLen(saNeedle[A_Index])
if !InStr(strHaystack, saNeedle[A_Index], blnCaseSensitive)
return false
return true
}
InStrMultipleOr(strHaystack, strNeedle, strSeparator, blnCaseSensitive := false)
{
saNeedle := StrSplit(strNeedle, strSeparator)
Loop saNeedle.MaxIndex()
if StrLen(saNeedle[A_Index])
if InStr(strHaystack, saNeedle[A_Index], blnCaseSensitive)
return true
return false
}
ChooseFolder(Owner, StartingFolder := "", CustomPlaces := "", Options := 0)
{
local IFileOpenDialog := ComObject("{DC1C5A9C-E88A-4DDE-A5A1-60F82A20AEF7}", "{D57C7288-D4AD-4768-BE02-9D969532D960}"),           Title := IsObject(Owner) ? Owner[2] . "" : "",           Flags := 0x20 | Options,      IShellItem := PIDL := 0,             Obj := {}, foo := bar := ""
Owner := IsObject(Owner) ? Owner[1] : (WinExist("ahk_id" . Owner) ? Owner : 0)
CustomPlaces := IsObject(CustomPlaces) || CustomPlaces == "" ? CustomPlaces : [CustomPlaces]
while (InStr(StartingFolder, "\") && !DirExist(StartingFolder))
StartingFolder := SubStr(StartingFolder, 1, InStr(StartingFolder, "\", , -2) - 1)
if ( DirExist(StartingFolder) )
{
DllCall("Shell32.dll\SHParseDisplayName", "UPtr", StartingFolder, "Ptr", 0, "UPtrP", &PIDL, "UInt", 0, "UInt", 0)
DllCall("Shell32.dll\SHCreateShellItem", "Ptr", 0, "Ptr", 0, "UPtr", PIDL, "UPtrP", &IShellItem)
ObjRawSet(Obj, IShellItem, PIDL)
DllCall(NumGet(NumGet(IFileOpenDialog+0, "UPtr")+12*A_PtrSize, "UPtr"), "Ptr", IFileOpenDialog, "UPtr", IShellItem)
}
if ( IsObject(CustomPlaces) )
{
local Directory := ""
For foo, Directory in CustomPlaces
{
foo := IsObject(Directory) ? Directory[2] : 0
if ( DirExist(Directory := IsObject(Directory) ? Directory[1] : Directory) )
{
DllCall("Shell32.dll\SHParseDisplayName", "UPtr", Directory, "Ptr", 0, "UPtrP", &PIDL, "UInt", 0, "UInt", 0)
DllCall("Shell32.dll\SHCreateShellItem", "Ptr", 0, "Ptr", 0, "UPtr", PIDL, "UPtrP", &IShellItem)
ObjRawSet(Obj, IShellItem, PIDL)
DllCall(NumGet(NumGet(IFileOpenDialog+0, "UPtr")+21*A_PtrSize, "UPtr"), "UPtr", IFileOpenDialog, "UPtr", IShellItem, "UInt", foo)
}
}
}
DllCall(NumGet(NumGet(IFileOpenDialog+0, "UPtr")+17*A_PtrSize, "UPtr"), "UPtr", IFileOpenDialog, "UPtr", Title == "" ? 0 : &Title)
DllCall(NumGet(NumGet(IFileOpenDialog+0, "UPtr")+9*A_PtrSize, "UPtr"), "UPtr", IFileOpenDialog, "UInt", Flags)
local Result := []
if ( !DllCall(NumGet(NumGet(IFileOpenDialog+0, "UPtr")+3*A_PtrSize, "UPtr"), "UPtr", IFileOpenDialog, "Ptr", Owner, "UInt") )
{
local IShellItemArray := 0
DllCall(NumGet(NumGet(IFileOpenDialog+0, "UPtr")+27*A_PtrSize, "UPtr"), "UPtr", IFileOpenDialog, "UPtrP", &IShellItemArray)
local Count := 0
DllCall(NumGet(NumGet(IShellItemArray+0, "UPtr")+7*A_PtrSize, "UPtr"), "UPtr", IShellItemArray, "UIntP", &Count)
local Buffer := ""
VarSetStrCapacity(&Buffer, 32767 * 2) ; V1toV2: if 'Buffer' is NOT a UTF-16 string, use 'Buffer := Buffer(32767 * 2)'
Loop Count
{
DllCall(NumGet(NumGet(IShellItemArray+0, "UPtr")+8*A_PtrSize, "UPtr"), "UPtr", IShellItemArray, "UInt", A_Index-1, "UPtrP", &IShellItem)
DllCall("Shell32.dll\SHGetIDListFromObject", "UPtr", IShellItem, "UPtrP", &PIDL)
DllCall("Shell32.dll\SHGetPathFromIDListEx", "UPtr", PIDL, "Str", Buffer, "UInt", 32767, "UInt", 0)
ObjRawSet(Obj, IShellItem, PIDL), ObjPush(Result, RTrim(Buffer, "\"))
}
ObjRelease(IShellItemArray)
}
for foo, bar in Obj
ObjRelease(foo), DllCall("Ole32.dll\CoTaskMemFree", "UPtr", bar)
ObjRelease(IFileOpenDialog)
return ObjLength(Result) ? ( Options & 0x200 ? Result : Result[1] ) : FALSE
}
DirExist(strDirName)
{
Loop Files, strDirName, "D"
return A_LoopFileAttrib
}
GetUniqueMenuLabel(strNewMenuLabel, saUniqueMenuLabels)
{
Loop
if MenuLabelIsUnique(strNewMenuLabel, saUniqueMenuLabels)
return strNewMenuLabel
else
strNewMenuLabel := strNewMenuLabel . Chr(160)
return strNewMenuLabel
}
MenuLabelIsUnique(strNewMenuLabel, saUniqueMenuLabels)
{
Loop saUniqueMenuLabels.MaxIndex()
if (strNewMenuLabel = saUniqueMenuLabels[A_Index])
return false
return true
}
ClipboardIsBitmap()
{
blnIsBitmap :=  WinClip.HasFormat(2) or WinClip.HasFormat(8) or WinClip.HasFormat(17)
return blnIsBitmap
}
!_096_CLIPJUMP_CODE:
return
MakeClipboardAvailable(blnDoReturn := true, intSleepTime := 10)
{
while !(intTemp)
{
intTemp := DllCall("OpenClipboard", "int", "")
Sleep(intSleepTime)
}
DllCall("CloseClipboard")
return (blnDoReturn ? A_Clipboard : 0)
}
FoolGUI(blnSwitch := true)
{
if !(blnSwitch)
{
FoolGUI := Gui()
FoolGUI.Destroy()
return
}
FoolGUI.Opt("-Caption +E0x80000 +LastFound +OwnDialogs +Owner +AlwaysOnTop")
FoolGUI. Show("NA", "FoolGUI")
WinActivate("FoolGUI")
}
WinClipGetTextOrFiles()
{
strTxt := WinClip.GetText()
return (StrLen(strTxt) ? strTxt : WinClip.GetFiles())
}
!_095_DATABASE_FUNCTIONS:
return
AddToHistory(str)
{
if (g_blnDbHistoryDisabled or !StrLen(str))
return
strDbSQL := "INSERT INTO History (". "CollectTime,RecordSize,ClipText". ") VALUES (". "'" . A_NowUTC .  "'". "," . StrLen(str) + 16 + 8. ",'" . EscapeQuote(str) . "'". ");"
if !o_Db.Exec(strDbSQL)
and SQLiteError("INSERT_HISTORY", strDbSQL)
return
if (g_intHistoryPosition > 1)
g_intHistoryPosition := HistoryGetPosition(g_strLastHistoryClip)
return
}
HistoryGetItem(intPosition)
{
if !(intPosition > 0)
return
strDbSQL := "SELECT ClipText FROM History ORDER BY rowid DESC LIMIT 1 OFFSET " . intPosition - 1 . ";"
if !o_Db.GetTable(strDbSQL, oDbTable)
and SQLiteError("SELECT_CLIP_POSITION", strDbSQL)
return
oDbTable.GetRow(1, saDbRow)
return saDbRow[1]
}
HistoryGetItemFromID(intID)
{
strDbSQL := "SELECT ClipText FROM History WHERE rowid = " . intID . ";"
if !o_Db.GetTable(strDbSQL, oDbTable)
and SQLiteError("SELECT_CLIP_ID", strDbSQL)
return
oDbTable.GetRow(1, saDbRow)
return saDbRow[1]
}
HistoryGetPosition(strClip)
{
strDbSQL := "SELECT RowNum FROM (SELECT row_number() OVER (ORDER BY rowid DESC) AS RowNum, ClipText FROM History) WHERE ClipText = '" . EscapeQuote(strClip) . "';"
if !o_Db.GetTable(strDbSQL, oDbTable)
and SQLiteError("SELECT_ROWNUM", strDbSQL)
return
if oDbTable.GetRow(1, saDbRow)
return saDbRow[1]
else
return 0
}
HistoryDbPrevExist()
{
if (g_blnDbHistoryDisabled)
return false
strDbSQL := "SELECT ClipText FROM History ORDER BY rowid DESC LIMIT 1 OFFSET " . g_intHistoryPosition + 1 . ";"
o_Db.GetTable(strDbSQL, oDbTable)
oDbTable.GetRow(1, saDbRow, strDbSQL)
return StrLen(saDbRow[1])
}
HistoryFlush()
{
if (g_blnDbHistoryDisabled)
return false
Editor.Opt("+OwnDialogs")
msgResult := MsgBox(o_L["DialogHistoryDbFlushDatabaseConfirm"], g_strAppNameText, 36)
if (msgResult = "Yes")
{
strDbSQL := "DELETE FROM History;"
If !o_Db.Exec(strDbSQL)
and SQLiteError("FLUSH_HISTORY", strDbSQL)
return
Oops("Editor", o_L["DialogHistoryDbFlushDatabaseDone"])
}
}
IsLastHistory(blnDebug := 0)
{
if (blnDebug)
###_V(A_ThisFunc, "*g_intHistoryPosition", g_intHistoryPosition, "*g_blnClipboardIsBitmap", g_blnClipboardIsBitmap, "*(g_intHistoryPosition > 1 or (g_blnClipboardIsBitmap and g_intHistoryPosition = 1))", (g_intHistoryPosition > 1 or (g_blnClipboardIsBitmap and g_intHistoryPosition = 1)), "*Edit_GetText(g_strEditorControlHwnd)", Edit_GetText(g_strEditorControlHwnd), "*g_strLastHistoryClip", g_strLastHistoryClip . "`n", "*Edit_GetText(g_strEditorControlHwnd) == g_strLastHistoryClip", (Edit_GetText(g_strEditorControlHwnd) == g_strLastHistoryClip) . "`n", "*((g_intHistoryPosition > 1 or (g_blnClipboardIsBitmap and g_intHistoryPosition = 1)) and Edit_GetText(g_strEditorControlHwnd) == g_strLastHistoryClip)", ((g_intHistoryPosition > 1 or (g_blnClipboardIsBitmap and g_intHistoryPosition = 1))
and Edit_GetText(g_strEditorControlHwnd) == g_strLastHistoryClip) . "`n", "*IsLastHistory() REV", ((g_intHistoryPosition - (g_blnClipboardIsBitmap ? 1 : 0) > (1))
and Edit_GetText(g_strEditorControlHwnd) == g_strLastHistoryClip))
return ((g_intHistoryPosition > 1 or (g_blnClipboardIsBitmap and g_intHistoryPosition = 1))
and Edit_GetText(g_strEditorControlHwnd) == g_strLastHistoryClip)
}
SearchHistoryFor(strWhat, strFilter := "")
{
if (strWhat = "Menu")
strDbSQL := "SELECT ClipText FROM History ORDER BY rowid DESC LIMIT " . o_Settings.History.intHistoryMenuRows.IniValue . ";"
else
{
saNeedle := StrSplit(Trim(strFilter), " ")
strWhere := ""
Loop saNeedle.MaxIndex()
strWhere .= "ClipText LIKE '%" . EscapeQuote(saNeedle[A_Index]) . "%' AND "
strWhere := SubStr(strWhere, 1, -4)
strDbSQL := "SELECT RowId, ClipText FROM History WHERE " . strWhere. " ORDER BY rowid DESC LIMIT " . o_Settings.History.intHistorySearchQueryRows.IniValue . ";"
}
o_Db.GetTable(strDbSQL, oDbTable)
return oDbTable
}
GetHistoryTableSize()
{
if (g_blnDbHistoryDisabled)
return false
strDbSQL := "SELECT SUM(RecordSize) FROM History;"
if !o_Db.GetTable(strDbSQL, oDbTable)
and SQLiteError("SELECT_SIZE_HISTORY", strDbSQL)
return
oDbTable.GetRow(1, saDbRow, strDbSQL)
return saDbRow[1]
}
HistoryGetRecordSize(intPosition)
{
if !(intPosition > 0)
return
strDbSQL := "SELECT RecordSize FROM History ORDER BY rowid " . strOrder . " LIMIT 1 OFFSET " . intPosition - 1 . ";"
if !o_Db.GetTable(strDbSQL, oDbTable)
and SQLiteError("SELECT_SIZE_CLIP", strDbSQL)
return
oDbTable.GetRow(1, saDbRow)
return saDbRow[1]
}
GetTableColumnExist(strTable, strColumnName)
{
o_Db.GetTable("PRAGMA table_info('" . strTable . "');", o_RecordSet)
for intRow, o_Row in o_RecordSet.Rows
if (o_Row[2] = strColumnName)
return true
return false
}
AddToCommands(aaEditCommandToSave)
{
if !StrLen(aaEditCommandToSave.strCommandType)
return
strDbSQL := "INSERT INTO Commands (". "Command,Title,Detail,InMenu,Hotkey,EditDateTime". ") VALUES (". "'" . aaEditCommandToSave.strCommandType .  "'". ",'" . EscapeQuote(aaEditCommandToSave.strTitle) . "'". ",'" . EscapeQuote(aaEditCommandToSave.strDetail) . "'". ",'" . aaEditCommandToSave.blnInMenu . "'". ",'" . EscapeQuote(aaEditCommandToSave.strLocalHotkey) . "'". ",'" . A_NowUTC .  "'". ");"
if !o_Db.Exec(strDbSQL)
and SQLiteError("INSERT_COMMAND", strDbSQL)
return
return
}
GetSavedCommandsList(strCommand)
{
if !StrLen(strCommand)
return
oDbTable := GetSavedCommandsTable("", strCommand)
Loop o_Settings.Various.intSavedCommandsLinesInList.IniValue
{
oDbTable.GetRow(A_Index, saDbRow)
if StrLen(saDbRow[1])
strList .= "|" . saDbRow[1]
}
return strList
}
GetSavedCommandsTable(strOrder, strCommand, strFilter := "", blnInMenu := false, blnHotkey := false)
{
if (StrLen(strCommand . strFilter) or blnInMenu or blnHotkey)
{
strWhere := (StrLen(strCommand) ? "Command = '" . strCommand . "'" : "")
if StrLen(strWhere) and StrLen(strFilter)
strWhere .= " AND "
strWhere .= (StrLen(strFilter) ? "Title LIKE '%" . EscapeQuote(strFilter) . "%'" : "")
if (StrLen(strWhere) and blnInMenu)
strWhere .= " AND "
strWhere .= (blnInMenu ? " InMenu " : "")
if (StrLen(strWhere) and blnHotkey)
strWhere .= " AND "
strWhere .= (blnHotkey ? " Hotkey <> '' " : "")
}
strDbSQL := "SELECT Title, InMenu, Hotkey, EditDateTime FROM Commands". (StrLen(strWhere) ? " WHERE " . strWhere : ""). (StrLen(strOrder) ? " ORDER BY " . strOrder : ""). ";"
o_Db.GetTable(strDbSQL, oDbTable)
return oDbTable
}
GetSavedCommand(strTitle)
{
strDbSQL := "SELECT Command, Detail, InMenu, Hotkey FROM Commands WHERE Title = '" . EscapeQuote(strTitle) . "';"
if !o_Db.GetTable(strDbSQL, oDbTable)
and SQLiteError("GET_COMMAND", strDbSQL)
return
if oDbTable.GetRow(1, saDbRow)
{
aaSavedCommand := new EditCommand(saDbRow[1])
aaSavedCommand.strDetail := saDbRow[2]
aaSavedCommand.blnInMenu := saDbRow[3]
aaSavedCommand.strLocalHotkey := saDbRow[4]
aaSavedCommand.strTitle := strTitle
return aaSavedCommand
}
}
DeleteCommand(strTitle)
{
strDbSQL := "DELETE FROM Commands WHERE Title = '" . EscapeQuote(strTitle) . "';"
if !o_Db.Exec(strDbSQL, oDbTable)
SQLiteError("DELETE_COMMAND", strDbSQL)
return
}
!_098_ONMESSAGE_FUNCTIONS:
return
WM_MOUSEMOVE(wParam, lParam)
{
static s_strControl
static s_strControlPrev
if !WinActiveQCE()
return
s_strControlPrev := s_strControl
MouseGetPos(, , , &s_strControl)
if !(InStr(s_strControl, "Button") or InStr(s_strControl, "msctls_statusbar32"))
{
ToolTip(, , , 1)
return
}
if (s_strControl <> s_strControlPrev)
and StrLen(g_aaToolTipsMessages[s_strControl])
{
ToolTip(g_aaToolTipsMessages[s_strControl], , , 1)
if StrLen(g_aaToolTipsMessages[s_strControl])
SetTimer(RemoveToolTip1,2500)
}
return
}
WM_KEYDOWN(wParam, lParam, msg, hwnd)
{
Static VK_RETURN := 0x0D
Static VK_TAB := 0x09
Static VK_SPACE := 0x20
if !WinActiveQCE()
return
if ((A_GuiControl = "f_strEditorWordWrapOff" or A_GuiControl = "f_strEditorWordWrapOn")
&& (wParam = VK_RETURN or wParam = VK_TAB or wParam = VK_SPACE))
AddToUndoPileFromHotkey()
}
WM_RBUTTONDOWN()
{
if InStr(A_GuiControl, "f_strEditor")
return 0
}
WM_RBUTTONUP()
{
Switch
{
case InStr(A_GuiControl, "f_strEditor"): Gosub, ShowEditorEditMenu
case InStr(A_GuiControl, "f_btnHistory"): Gosub, ShowHistoryMenuButtons
}
}
!_100_CLASSES:
return
class CommandLineParameters
{
AA := Object()
strParams := ""
__New()
{
for intArg, strOneArg in A_Args
{
if !StrLen(strOneArg)
continue
intColon := InStr(strOneArg, ":")
if (intColon)
{
strParamKey := SubStr(strOneArg, 2, intColon - 2)
strParamValue := SubStr(strOneArg, (intColon + 1)<1 ? (intColon + 1)-1 : (intColon + 1))
if (strParamKey = "Settings" and GetFileExtension(strParamValue) <> "ini")
continue
this.AA[strParamKey] := strParamValue
}
else
{
strParamKey := SubStr(strOneArg, 2)
if (strParamKey = "Settings")
continue
this.AA[strParamKey] := ""
}
}
this.strParams := this.ConcatParams()
}
ConcatParams()
{
strConcat := ""
for strParamKey, strParamValue in this.AA
{
strQuotes := (InStr(strParamKey . strParamValue, " ") ? """" : "")
strConcat .= strQuotes . "/" . strParamKey
strConcat .= (StrLen(strParamValue) ? ":" . strParamValue : "")
strConcat .= strQuotes . " "
}
return SubStr(strConcat, 1, -1)
}
SetParam(strKey, strValue)
{
this.AA[strKey] := strValue
this.strParams := this.ConcatParams()
}
}
class JLicons
{
strFileLocation := ""
AA := Object()
saNames := Object()
aaReplacementPrevious := Object()
__New(strJLiconsFile)
{
this.strFileLocation := strJLiconsFile
strNames := "iconQAP|iconAbout|iconAddThisFolder|iconApplication|iconCDROM". "|iconChangeFolder|iconClipboard|iconClose|iconControlPanel|iconCurrentFolders". "|iconDesktop|iconDocuments|iconDonate|iconDownloads|iconDrives". "|iconEditFavorite|iconExit|iconFavorites|iconFolder|iconFonts". "|iconFTP|iconGroup|iconHelp|iconHistory|iconHotkeys". "|iconAddFavorite|iconMyComputer|iconMyMusic|iconMyVideo|iconNetwork". "|iconNetworkNeighborhood|iconNoContent|iconOptions|iconPictures|iconRAMDisk". "|iconRecentFolders|iconRecycleBin|iconReload|iconRemovable|iconSettings". "|iconSpecialFolders|iconSubmenu|iconSwitch|iconTemplates|iconTemporary". "|iconTextDocument|iconUnknown|iconWinver|iconFolderLive|iconIcons". "|iconPaste|iconPasteSpecial|iconNoIcon|iconUAClogo|iconQAPadmin". "|iconQAPadminBeta|iconQAPadminDev|iconQAPbeta|iconQAPdev|iconQAPloading". "|iconFolderLiveOpened|iconSortAlphaAsc|iconSortAlphaDesc|iconSortNumAsc|iconSortNumDesc". "|iconQCE|iconQCEadmin|iconQCEadminBeta|iconQCEadminDev|iconQCEbeta". "|iconQCEdev"
this.saNames := StrSplit(strNames, "|")
Loop Parse, strNames, "|"
this.AddIcon(A_LoopField, strJLiconsFile . "," . A_Index)
}
CheckVersion()
{
strVersion := FileGetVersion(this.strFileLocation)
if ComparableVersionNumber(strVersion) < ComparableVersionNumber(g_strJLiconsVersion)
{
Oops(0, o_L["OopsJLiconsOutdated"], this.strFileLocation, g_strJLiconsVersion, g_strAppNameText)
ExitApp()
}
}
AddIcon(strKey, strFileIndex)
{
this.AA[strKey] := strFileIndex
}
GetName(intKey)
{
return this.saNames[intKey]
}
ProcessReplacements(strReplacements)
{
for strKey, strFileIndex in this.aaReplacementPrevious
this.AA[strKey] := strFileIndex
this.aaReplacementPrevious := Object()
Loop Parse, strReplacements, "|"
if StrLen(A_LoopField)
{
saIconReplacement := StrSplit(A_LoopField, "=")
if This.AA.Has(saIconReplacement[2])
saIconReplacement[2] := This.AA[saIconReplacement[2]]
if this.AA.Has(saIconReplacement[1]) and InStr(saIconReplacement[2], ",")
{
this.aaReplacementPrevious[saIconReplacement[1]] := this.AA[saIconReplacement[1]]
this.AA[saIconReplacement[1]] := saIconReplacement[2]
}
}
}
}
class Settings
{
aaGroupItems := Object()
saOptionsGroups := Object()
saOptionsGroupsLabelNames := Object()
__New()
{
this.strIniFile := A_WorkingDir . "\" . g_strAppNameFile . ".ini"
SplitPath(this.strIniFile, &strIniFileNameExtOnly)
this.strIniFileNameExtOnly := strIniFileNameExtOnly
this.strIniFileDefault := this.strIniFile
this.saOptionsGroups := ["Launch", "EditorWindow", "Hotkeys", "History", "Various"]
this.ReadIniOption("Launch", "strLanguageCode", "LanguageCode", "EN", "", (FileExist(this.strIniFile) ? this.strIniFile : A_WorkingDir . "\" . g_strAppNameFile . "-setup.ini"))
}
ReadIniOption(strOptionGroup, strSettingName, strIniValueName, strDefault := "", strGuiControls := "", strIniFile := "")
{
if !IsObject(this[strOptionGroup])
this[strOptionGroup] := Object()
if !IsObject(this.aaGroupItems[strOptionGroup])
this.aaGroupItems[strOptionGroup] := Object()
if StrLen(strIniValueName)
strOutValue := this.ReadIniValue(strIniValueName, strDefault, (StrLen(strSection) ? strSection : strOptionGroup), strIniFile)
oIniValue := new this.IniValue(strIniValueName, strOutValue, strGuiControls, (StrLen(strSection) ? strSection : strOptionGroup), strIniFile)
this[strOptionGroup][strSettingName] := oIniValue
this.aaGroupItems[strOptionGroup].Push(oIniValue)
return oIniValue.IniValue
}
ReadIniValue(strIniValueName, strDefault := "", strSection := "Internal", strIniFile := "")
{
strOutValue := IniRead((StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection, strIniValueName)
if (strOutValue = "ERROR")
{
IniWrite(strDefault, (StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection, strIniValueName)
return strDefault
}
else
return strOutValue
}
ReadIniSection(strSection, strIniFile := "")
{
strOutValue := IniRead((StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection)
return strOutValue
}
WriteIniValue(strInValue, strSection, strValueName, strIniFile := "")
{
IniWrite(strInValue, (StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection, strValueName)
return !(ErrorLevel)
}
WriteIniSection(strInValue, strSection, strIniFile := "")
{
IniWrite(strInValue, (StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection)
return !(ErrorLevel)
}
DeleteIniValue(strSection, strValueName, strIniFile := "")
{
IniDelete((StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection, strValueName)
return !(ErrorLevel)
}
DeleteIniSection(strSection, strIniFile := "")
{
IniDelete((StrLen(strIniFile) ? strIniFile : this.strIniFile), strSection)
return !(ErrorLevel)
}
BackupIniFile(strIniFile, blnReplaceSpecialFolderLocationBackup := false)
{
SplitPath(strIniFile, &strIniFileFilename, &strIniFileFolder)
strThisBackupFolder := o_Settings.ReadIniValue("BackupFolder", " ", "Launch", strIniFile)
if !StrLen(strThisBackupFolder)
strThisBackupFolder := strIniFileFolder
strThisBackupFolder := PathCombine(A_WorkingDir, EnvVars(strThisBackupFolder))
if (blnReplaceSpecialFolderLocationBackup)
strIniBackupFile := strThisBackupFolder . "\" . StrReplace(strIniFileFilename, ".ini", "-backup-special_folders-??????????????.ini")
else
{
strIniBackupFile := strThisBackupFolder . "\" . StrReplace(strIniFileFilename, ".ini", "-backup-????????.ini")
Loop strIniBackupFile
strFilesList .= A_LoopFilePath . "`n"
strFilesList := Sort(strFilesList, "R")
intNumberOfBackups := (g_strCurrentBranch <> "prod" ? 10 : 5)
Loop Parse, strFilesList, "`n"
if (A_Index > intNumber["OfBackups"])
if StrLen(A_LoopField)
FileDelete(A_LoopField)
}
strIniBackupFile := StrReplace(strIniBackupFile, "????????" . (blnReplaceSpecialFolderLocationBackup ? "??????" : ""), SubStr(A_Now, 1, (blnReplaceSpecialFolderLocationBackup ? 14 : 8)))
Try{
   FileCopy(strIniFile, strIniBackupFile, 1)
   ErrorLevel := 0
} Catch as Err {
   ErrorLevel := Err.Extra
}
}
InitOptionsGroupsLabelNames()
{
this.saOptionsGroupsLabelNames := ["OptionsLaunch", "OptionsEditorWindow", "OptionsHotkeys", "OptionsClipboardHistory", "OptionsVarious"]
}
class IniValue
{
__New(strIniValueName, strIniValue, strGuiControls, strSection, strIniFile)
{
this.IniValue := strIniValue
this.strGuiControls := strGuiControls
this.strIniFile := strIniFile
this.strIniValueName := strIniValueName
this.strSection := strSection
}
WriteIni(varNewValue := "", blnDoNotSave := false)
{
if !(blnDoNotSave)
this.IniValue := varNewValue
IniWrite(this.IniValue, (StrLen(this.strIniFile) ? this.strIniFile : o_Settings.strIniFile), (StrLen(this.strSection) ? this.strSection : "Internal"), this.strIniValueName)
}
}
}
class Triggers
{
class PopupHotkeys
{
aaPopupHotkeysByNames := Object()
__New()
{
SA := Object()
saPopupHotkeyInternalNames := Object()
saPopupHotkeyInternalNames := ["OpenEditorHotkeyMouse", "OpenEditorHotkeyKeyboard", "PasteFromQCEHotkey", "CopyOpenQCEHotkey", "OpenHistoryMenuHotkey"]
saPopupHotkeyDefaults := StrSplit("^MButton|+#v|^#v|^#c|^#h", "|")
saOptionsPopupHotkeyLocalizedNames := StrSplit(L(o_L["OptionsPopupHotkeyTitles"], g_strAppNameText), "|")
saOptionsPopupHotkeyLocalizedDescriptions := StrSplit(L(o_L["OptionsPopupHotkeyTitlesSub"], g_strAppNameText), "|")
for intThisIndex, strThisPopupHotkeyInternalName in saPopupHotkeyInternalNames
{
strThisPopupHotkey := o_Settings.ReadIniOption("Hotkeys", "str" . strThisPopupHotkeyInternalName, strThisPopupHotkeyInternalName, saPopupHotkeyDefaults[A_Index], "f_lblChangeShortcut" . A_Index . "|f_lblHotkeyText" . A_Index . "|f_btnChangeShortcut" . A_Index . "|f_lnkChangeShortcut" . A_Index. (intThisIndex = 1 ? "|f_lblChangeShortcutTitle" : ""))
oPopupHotkey := new this.PopupHotkey(strThisPopupHotkeyInternalName, strThisPopupHotkey, saPopupHotkeyDefaults[A_Index], saOptionsPopupHotkeyLocalizedNames[A_Index], saOptionsPopupHotkeyLocalizedDescriptions[A_Index])
this.SA[A_Index] := oPopupHotkey
this.aaPopupHotkeysByNames[strThisPopupHotkeyInternalName] := oPopupHotkey
}
this.EnablePopupHotkeys()
}
EnablePopupHotkeys()
{
Hotkey("If CanPopup(A_ThisHotkey)")
this.SA[1].EnableHotkey("OpenEditor", "Mouse")
this.SA[2].EnableHotkey("OpenEditor", "Keyboard")
this.SA[3].EnableHotkey("PasteFromQCE", "")
this.SA[4].EnableHotkey("CopyOpenQCE", "")
this.SA[5].EnableHotkey("OpenHistoryMenu", "")
HotIf()
}
BackupPopupHotkeys()
{
for intKey, oOnePopupHotkey in this.SA
oOnePopupHotkey.AA.strPopupHotkeyPrevious := oOnePopupHotkey.P_strAhkHotkey
}
RestorePopupHotkeys()
{
for intKey, oOnePopupHotkey in this.SA
oOnePopupHotkey.P_strAhkHotkey := oOnePopupHotkey.AA.strPopupHotkeyPrevious
}
class PopupHotkey
{
AA := Object()
__New(strThisInternalName, strThisPopupHotkey, strThisPopupHotkeyDefault, strThisLocalizedName, strThisLocalizedDescription)
{
this.AA.strPopupHotkeyInternalName := strThisInternalName
this.P_strAhkHotkey := strThisPopupHotkey
this.AA.strPopupHotkeyDefault := strThisPopupHotkeyDefault
this.AA.strPopupHotkeyPrevious := ""
this.AA.strPopupHotkeyLocalizedName := strThisLocalizedName
this.AA.strPopupHotkeyLocalizedDescription := strThisLocalizedDescription
}
P_strAhkHotkey[]
{
Get
{
return this._strAhkHotkey
}
Set
{
oHotkeyParts := new Triggers.HotkeyParts(value)
this.AA.strPopupHotkeyText := oHotkeyParts.Hotkey2Text()
this.AA.strPopupHotkeyTextShort := oHotkeyParts.Hotkey2Text(true)
return this._strAhkHotkey := value
}
}
EnableHotkey(strActionType, strTriggerType)
{
strLabel := strActionType . "Hotkey" . strTriggerType
if HasShortcut(this.AA.strPopupHotkeyPrevious)
Hotkey(this.AA.strPopupHotkeyPrevious, , "Off UseErrorLevel")
if HasShortcut(this.P_strAhkHotkey)
Hotkey(this.P_strAhkHotkey, strLabel, "On UseErrorLevel")
if (ErrorLevel)
Oops(0, o_L["DialogInvalidHotkey"], this.AA.strPopupHotkeyText, this.AA.strPopupHotkeyLocalizedName)
}
}
}
class HotkeyParts
{
strModifiers := ""
strKey := ""
strMouseButton := ""
__New(strHotkey)
{
this.SplitParts(strHotkey)
}
SplitParts(strHotkey)
{
if (strHotkey = "None")
{
this.strModifiers := ""
this.strKey := ""
this.strMouseButton := "None"
}
else
{
intPosFirstNotModifier := 0
Loop Parse, strHotkey
if InStr("^!+#<>", A_LoopField)
intPosFirstNotModifier++
else
break
str := SubStr(strHotkey, 1, intPosFirstNotModifier)
this.strModifiers := str
str := SubStr(strHotkey, (intPosFirstNotModifier + 1)<1 ? (intPosFirstNotModifier + 1)-1 : (intPosFirstNotModifier + 1))
this.strKey := str
if o_MouseButtons.IsMouseButton(this.strKey)
{
this.strMouseButton := this.strKey
this.strKey := ""
}
else
this.strMouseButton := ""
}
}
Hotkey2Text(blnShort := false)
{
if StrLen(this.strKey)
{
strSystemKeyNames := "sc15D|AppsKey|Space|Enter|Escape"
saLocalizedKeyNames := StrSplit(o_L["DialogMenuKey"] . "|" . o_L["DialogMenuKey"] . "|" . o_L["DialogSpace"]. "|" . o_L["DialogEnter"] . "|" . o_L["DialogEscape"], "|")
Loop Parse, strSystemKeyNames, "|"
if (this.strKey = A_LoopField)
this.strKey := saLocalizedKeyNames[A_Index]
}
if (this.strMouseButton = "None")
or !StrLen(this.strModifiers . this.strMouseButton . this.strKey)
str := o_L["DialogNone"]
else
{
str := ""
Loop Parse, this.strModifiers
{
if (A_LoopField = "!")
str := str . (InStr(this.strModifiers, "<!") ? "<" : InStr(this.strModifiers, ">!") ? ">" : "") . (blnShort ? o_L["DialogAltShort"] : o_L["DialogAlt"]) . "+"
if (A_LoopField = "^")
str := str . (InStr(this.strModifiers, "<^") ? "<" : InStr(this.strModifiers, ">^") ? ">" : "") . (blnShort ? o_L["DialogCtrlShort"] : o_L["DialogCtrl"]) . "+"
if (A_LoopField = "+")
str := str . (InStr(this.strModifiers, "<+") ? "<" : InStr(this.strModifiers, ">+") ? ">" : "") . (blnShort ? o_L["DialogShiftShort"] : o_L["DialogShift"]) . "+"
if (A_LoopField = "#")
str := str . (InStr(this.strModifiers, "<#") ? "<" : InStr(this.strModifiers, ">#") ? ">" : "") . (blnShort ? o_L["DialogWinShort"] : o_L["DialogWin"]) . "+"
}
if StrLen(this.strMouseButton)
str := str . o_MouseButtons.GetMouseButtonLocalized4InternalName(this.strMouseButton, blnShort)
if StrLen(this.strKey)
str := str . StrUpper(this.strKey)
}
return str
}
}
class MouseButtons
{
SA := Object()
aaMouseButtonInternalNames := Object()
aaMouseButtonLocalizedNames := Object()
strMouseButtonsDropDownList := ""
__New()
{
saMouseButtonsInternalNames := StrSplit("None|LButton|MButton|RButton|XButton1|XButton2|WheelUp|WheelDown|WheelLeft|WheelRight", "|")
this.strMouseButtonsDropDownList := o_L["DialogNone"] . "|" . o_L["DialogMouseButtonsText"]
saMouseButtonsLocalizedNames := StrSplit(this.strMouseButtonsDropDownList, "|")
saMouseButtonsLocalizedNamesShort := StrSplit(o_L["DialogNone"] . "|" . o_L["DialogMouseButtonsTextShort"], "|")
Loop saMouseButtonsInternalNames.Length
{
this.aaMouseButtonInternalNames[saMouseButtonsInternalNames[A_Index]] := A_Index
this.aaMouseButtonLocalizedNames[saMouseButtonsLocalizedNames[A_Index]] := A_Index
oMouseButton := new this.MouseButton(saMouseButtonsInternalNames[A_Index], saMouseButtonsLocalizedNames[A_Index], saMouseButtonsLocalizedNamesShort[A_Index])
this.SA[A_Index] := oMouseButton
}
}
GetMouseButtonInternal4LocalizedName(strLocalizedName)
{
return this.SA[this.aaMouseButtonLocalizedNames[strLocalizedName]].strInternalName
}
GetMouseButtonLocalized4InternalName(strInternalName, blnShort)
{
return (blnShort ? this.SA[this.aaMouseButtonInternalNames[strInternalName]].strLocalizedNameShort
: this.SA[this.aaMouseButtonInternalNames[strInternalName]].strLocalizedName)
}
IsMouseButton(strInternalName)
{
return this.aaMouseButtonInternalNames.Has(strInternalName)
}
GetDropDownList(strDefault)
{
if (strDefault = o_L["DialogNone"])
return StrReplace(this.strMouseButtonsDropDownList, o_L["DialogNone"] . "|", o_L["DialogNone"] . "||")
else if StrLen(strDefault)
return StrReplace(this.strMouseButtonsDropDownList, this.GetMouseButtonLocalized4InternalName(strDefault, false) . "|", this.GetMouseButtonLocalized4InternalName(strDefault, false) . "||")
else
return this.strMouseButtonsDropDownList
}
class MouseButton
{
strInternalName := ""
strLocalizedName := ""
strLocalizedNameShort := ""
__New(strThisInternalName, strThisLocalizedName, strThisLocalizedNameShort)
{
this.strInternalName := strThisInternalName
this.strLocalizedName := strThisLocalizedName
this.strLocalizedNameShort := strThisLocalizedNameShort
}
}
}
}
class Utc2LocalTime
{
static intMinutesUtcOffset
__New()
{
intMinutes := A_Now
intMinutes := DateDiff(intMinutes, A_NowUTC, "Minutes")
this.intMinutesUtcOffset := intMinutes
}
ConvertToLocal(strUtcTime)
{
strUtcTime := DateAdd(strUtcTime, this.intMinutesUtcOffset, "Minutes")
return strUtcTime
}
}
class Language
{
__New()
{
this["AboutText1"] := "~1~ ~2~ (~3~ bits)"
this["AboutText2"] := "~1~ is written by Jean Lalonde using the <a href=""http://www.autohotkey.com/"">AutoHotkey</a> programming language."
this["AboutText3"] := "~1~ Jean Lalonde 2021-~2~`n`nQuick A_Clipboard Editor is supplied under License conditions. You may obtain a copy of the License at:`n<a href=""~3~"">~4~</a>`nUnless required by applicable law or agreed to in writing, software distributed under the License is distributed on an ""AS IS"" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either expressed or implied. See the License for the specific language governing permissions and limitations under the License."
this["AboutText4"] := "Support on <a href=""http://A_Clipboard.quickaccesspopup.com"">www.A_Clipboard.quickaccesspopup.com</a>"
this["AboutText5"] := "Credits and contributors"
this["AboutText6"] := "Thanks for their expertise and code snippets to ~1~ and many other <a href=""~2~"">AHK</a> developers."
this["AboutText7"] := "Icons by: <a href=""https://icons8.com/"">Icons8</a>`nInstall program: <a href=""http://www.jrsoftware.org/isinfo.php"">Inno Setup</a> by jrsoftware.org`nAutoHotkey_L v~1~"
this["AboutTitle"] := "About - ~1~ ~2~"
this["AboutUserComputerName"] := "User name: ~1~`nComputer: ~2~"
this["DiagModeCaution"] := "~1~ is running in diagnostic mode.`n`nInformation about the app'S.Length execution will be collected in the file:`n~2~`n`nNothing will be sent without your consent.`n`nDo you want to keep diagnostic mode ON?"
this["DiagModeExit"] := "~1~ collected diagnostic information in the file ~2~."
this["DiagModeIntro"] := "Send this file to support@quickaccesspopup.com with a description of the situation requiring diagnostic"
this["DiagModeSee"] := "Do you want to see the diagnostic file?"
this["DialogAdd"] := "Add"
this["DialogAddEditCommandTitle"] := "Edit: ~1~ - ~2~ ~3~"
this["DialogAddRuleSelectPrompt"] := "Select the type of rule to add"
this["DialogAddRuleSelectTitle"] := "Add Rule - Select type - ~1~"
this["DialogAddToMenu"] := "Add to menu"
this["DialogAll"] := "All"
this["DialogAlt"] := "Alt"
this["DialogAltShort"] := "Alt"
this["DialogAlwaysOnTop"] := "Always on top"
this["DialogAtTheEnd"] := "At the end"
this["DialogBrowseButton"] := "Browse"
this["DialogCancelPrompt"] := "Discard changes?"
this["DialogCancelTitle"] := "Cancel - ~1~ ~2~"
this["DialogCaseLower"] := "Lower case (all letters converted to lower case)"
this["DialogCaseSaRcAsM"] := "SaRcAsM (alternating caps)"
this["DialogCaseSensitive"] := "Case sensitive"
this["DialogCaseSentence"] := "Sentence case (first letter of each sentence or line converted to capital)"
this["DialogCaseTitle"] := "Title case (first letter of each word converted to capital)"
this["DialogCaseToggle"] := "Toggle case (or Reverse case, each letter converted to its opposite case)"
this["DialogCaseUpper"] := "Upper case (all letters converted to capitals)"
this["DialogChangeHotkeyAny"] := "Any"
this["DialogChangeHotkeyLeft"] := "Left"
this["DialogChangeHotkeyLeftAnyRight"] := "Each keyboard modifier can be bound to only ""Left"" key, only ""Right"" key or to both (""Any"") of them."
this["DialogChangeHotkeyModifierAndNone"] := "Modifiers like ""Alt"" or ""Control"" cannot be selected alone. Also select a mouse or keyboard hotkey in the right section."
this["DialogChangeHotkeyMouseCheckLButton"] := "You can't assign the ""Left Mouse Button"" without a modifier`n(like ~1~, ~2~, ~3~ or ~4~ keys)."
this["DialogChangeHotkeyPopup"] := "This is a popup menu hotkey.`n`nDo you want to manage ""~1~"" in ""~2~""?"
this["DialogChangeHotkeyRight"] := "Right"
this["DialogChangeHotkeyTitle"] := "Change shortcut - ~1~ ~2~"
this["DialogChar"] := "Char."
this["DialogCharacter"] := "character"
this["DialogCharacters"] := "characters"
this["DialogCheckAll"] := "Check All"
this["DialogClipboardBinary"] := "binary"
this["DialogClipboardEditing"] := "Editing"
this["DialogClipboardReadOnly"] := "Read-only"
this["DialogClipboardSynced"] := "Synced"
this["DialogCommand"] := "Command"
this["DialogContinue"] := "Continue?"
this["DialogConvertFormatText"] := "Text format"
this["DialogCopy"] := "Copy"
this["DialogCtrl"] := "Control"
this["DialogCtrlLeft"] := "Left Ctrl"
this["DialogCtrlRight"] := "Right Ctrl"
this["DialogCtrlShort"] := "Ctrl"
this["DialogCut"] := "Cut"
this["DialogDelete"] := "Delete"
this["DialogDeleteCharacters"] := "Delete characters"
this["DialogDeleteCharactersBegin"] := "Trim the Beginning of lines"
this["DialogDeleteCharactersBeginEnd"] := "Trim Beginning and End of lines"
this["DialogDeleteCharactersEnd"] := "Trim the End of lines"
this["DialogDeleteLines"] := "Delete lines"
this["DialogDeleteLinesBlank"] := "Blank lines (no visible character)"
this["DialogDeleteLinesEmpty"] := "Empty lines"
this["DialogDeleteLinesTypes"] := "containing|regular expression|empty lines|blank lines"
this["DialogEdit"] := "Edit"
this["DialogEditCommandsInvisibleKeys"] := "Insert: <a id=""Tab"">tab</a>, <a id=""Enter"">new line</a>"
this["DialogEditCommandsInvisibleKeysMore"] := "Insert: <a id=""Tab"">tab</a>, <a id=""Enter"">new line</a>, <a id=""Numbers"">all numbers</a>, <a id=""Code"">ASCII/Unicode</a>"
this["DialogEditCommandsInvisibleTab"] := "Insert: <a id=""Tab"">tab</a>"
this["DialogEnter"] := "Enter"
this["DialogEscape"] := "Escape"
this["DialogExecute"] := "Execute"
this["DialogFileEncoding"] := "File encoding"
this["DialogFileEncodingCodes"] := "ANSI|UTF-8|UTF-8-RAW|UTF-16|UTF-16-RAW"
this["DialogFileEncodingList"] := "ANSI|UTF-8 Unicode 8-bit|UTF-8 No BOM|UTF-16 Unicode 16-bit|UTF-16 No BOM|Custom codepage (~1~)"
this["DialogFileOpenToClipboard"] := "to the A_Clipboard"
this["DialogFileOpenToEditor"] := "in the editor"
this["DialogFileOpenToEditorAt"] := "replace all content|at caret or selection position"
this["DialogFileOpenToPrompt"] := "Load the file"
this["DialogFileSaveEolList"] := "Windows default (CR/LF)|Unix and OS X (LF)|Classic Mac (CR)"
this["DialogFileSaveEolPrompt"] := "End of lines format"
this["DialogFileSaveOverwrite"] := "~1~ already exists.`nDo you want to update it?"
this["DialogFileSaveSelected"] := "Selection only"
this["DialogFileToOpen"] := "File to open"
this["DialogFileToSave"] := "File to save"
this["DialogFilterCharactersEverywhereDelete"] := "Delete characters in All or Selected text"
this["DialogFilterCharactersEverywhereKeep"] := "Keep characters in All or Selected text"
this["DialogFilterCharactersListDelete"] := "List of characters to delete"
this["DialogFilterCharactersListKeep"] := "List of characters to keep"
this["DialogFilterCharactersTypes"] := "in all or selected text|at the beginning and end of lines|only at the beginning of lines|only at the end of lines"
this["DialogFilterLinesTypes"] := "lines containing|lines matching regular expression|empty lines|blank lines|5|6|7|8|9|10|lines containing|lines matching regular expression|containing only numbers|containing only letters"
this["DialogFindWhat"] := "Text to find"
this["DialogFixedFont"] := "Fixed Width[0] font"
this["DialogFontSize"] := "Font Size[0]"
this["DialogForLower"] := "for"
this["DialogFromLower"] := "from"
this["DialogFromUpper"] := "From"
this["DialogGo"] := "Execute"
this["DialogHistoryDbFlushDatabaseConfirm"] := "Delete history database?"
this["DialogHistoryDbFlushDatabaseDone"] := "Database content deleted."
this["DialogHotkeyGlobal"] := "Global Hotkey"
this["DialogHotkeyLocal"] := "Local Hotkey"
this["DialogHotkeyInvisibleKeys"] := "<a id=""~1~"">space bar</a>, <a id=""~2~"">tab</a>, <a id=""~3~"">enter</a>, <a id=""~4~"">escape</a>`nor <a id=""~5~"">menu key (application)</a>"
this["DialogHotkeysHelpHeader"] := "Shortcut|Action"
this["DialogInMenu"] := "In menu"
this["DialogInsert"] := "Insert"
this["DialogInsertStringTypes"] := "from the start|from position|from the beginning of|from the end of|at the end"
this["DialogInvalidHotkey"] := "With your current system keyboard layout, the hotkey ""~1~"" could not be used as a trigger for the popup menu.`n`nPlease open the ""Editor"" window from the Tray menu and click ""Options"". In this dialog box, choose another shortcut for ""~2~""."
this["DialogInvisibleCodePrompt"] := "Enter an ASCII or Unicode number (dec["imal"] or ""U+nnnn"")"
this["DialogInvisibleCodeTitle"] := "ASCII or Unicode"
this["DialogKeep"] := "Keep"
this["DialogKeepCharacters"] := "Keep characters"
this["DialogKeepLines"] := "Keep lines"
this["DialogKeepLinesLetters"] := "Containing only Letters"
this["DialogKeepLinesNumbers"] := "Containing only Numbers"
this["DialogKeyboard"] := "Keyboard"
this["DialogLine"] := "Line"
this["DialogLinesAll"] := "All"
this["DialogLinesAny"] := "Any"
this["DialogLinesContaining"] := "Containing"
this["DialogLinesContainingMultiple"] := "one filter per line"
this["DialogLinesContainingTypes"] := "all of|any of|not all of|not any of"
this["DialogLinesNotAll"] := "Not all"
this["DialogLinesNotAny"] := "Not any"
this["DialogLoad"] := "Load"
this["DialogManageSavedCommandsDeleteConfirm"] := "Delete checked command(S.Length)?"
this["DialogManageSavedCommandsDeleteConfirmContextMenu"] := "Delete this command(S.Length)?"
this["DialogManageSavedCommandsFilter"] := "Filter"
this["DialogMenuKey"] := "Menu key"
this["DialogMouse"] := "Mouse"
this["DialogMouseButtonsText"] := "Left Mouse Button|Middle Mouse Button|Right Mouse Button|Special Mouse Button 1|Special Mouse Button 2|Wheel Up|Wheel Down|Wheel Left|Wheel Right|"
this["DialogMouseButtonsTextShort"] := "Left Mouse|Middle Mouse|Right Mouse|Special Mouse 1|Special Mouse 2|Wheel Up|Wheel Down|Wheel Left|Wheel Right|"
this["DialogMoveLineDown"] := "Move line down"
this["DialogMoveLineUp"] := "Move line up"
this["DialogNo"] := "No"
this["DialogNone"] := "None"
this["DialogOK"] := "OK"
this["DialogOr"] := "or"
this["DialogPaste"] := "Paste"
this["DialogPos"] := "Pos."
this["DialogRedo"] := "Redo"
this["DialogRefresh"] := "Refresh"
this["DialogRegexPrompt"] := "Enter the regular expression here"
this["DialogRemove"] := "Remove"
this["DialogRepeatOnEachLine"] := "Execute rule on each line"
this["DialogReplaceAllExternal"] := "Replace All when executed from a Saved command"
this["DialogReplaceCaseSensitive"] := "Case sensitive"
this["DialogReplaceWholeWord"] := "Match whole word only"
this["DialogReplaceWith"] := "Replace with"
this["DialogRuleCategory"] := "Category"
this["DialogRuleLastModified"] := "Last modified"
this["DialogRuleName"] := "Rule name"
this["DialogRuleNotes"] := "Notes"
this["DialogRuleRemove"] := "Remove rule ""~1~""?"
this["DialogRuleSelectType"] := "Select the type of rule to add.`n`nIn the next window, enter :`n- a name for your rule`n- rules parameters (depending on the type)`n- various settings (category, notes, etc.)`n`nChoose the new rule'S.Length type and click ""~1~""."
this["DialogRuleType"] := "Type"
this["DialogRuleUndo"] := "Undo last change?"
this["DialogSave"] := "Save"
this["DialogSaveAndGo"] := "Save and go"
this["DialogSavedCommands"] := "Saved commands"
this["DialogSaveThisCommand"] := "Save this command"
this["DialogSeeInvisible"] := "Invisible characters"
this["DialogSel"] := "Sel."
this["DialogSelectAll"] := "Select All"
this["DialogSelectFile"] := "Select File"
this["DialogShift"] := "Shift"
this["DialogShiftLeft"] := "Left Shift"
this["DialogShiftRight"] := "Rigth Shift"
this["DialogShiftShort"] := "Shift"
this["DialogShowSettingsIniFile"] := "Restart ~1~ after saving your changes to the settings file."
this["DialogSortOptionBS"] := "From last backslash (sort file paths by filenames)"
this["DialogSortOptionC"] := "Case sensitive (A, a, B, b, etc.)"
this["DialogSortOptionCL"] := "Case sensitive considering regional settings (A, Å, E, É, etc.)"
this["DialogSortOptionLength"] := "Line length"
this["DialogSortOptionN"] := "Numeric values (1, 5, 10, 50, etc.)"
this["DialogSortOptionP"] := "From position"
this["DialogSortOptionR"] := "Reverse order (Z to A)"
this["DialogSortOptionRandom"] := "Randomly"
this["DialogSortOptionU"] := "Unique (remove duplicate lines)"
this["DialogSpace"] := "Space"
this["DialogSubStringFromBeginText"] := "From beginning of this"
this["DialogSubStringFromEndText"] := "From end of this"
this["DialogSubStringFromPosition"] := "From position"
this["DialogSubStringFromStart"] := "From the start"
this["DialogSubStringFromTypes"] := "the start|position|the beginning of|the end of"
this["DialogSubStringLength"] := "Number of characters"
this["DialogSubStringToBeforeEnd"] := "Characters before end"
this["DialogSubStringToBeginText"] := "To beginning of this"
this["DialogSubStringToEnd"] := "To the end"
this["DialogSubStringToEndText"] := "To end of this"
this["DialogSubStringToTypes"] := "to the end|characters|characters before the end|to the beginning of|to end of"
this["DialogTextToInsert"] := "Text to insert"
this["DialogToLower"] := "to"
this["DialogTriggerFor"] := "Trigger for:"
this["DialogUndo"] := "Undo"
this["DialogUseTab"] := "Use tab"
this["DialogWin"] := "Windows"
this["DialogWindowMonitor"] := "Monitor"
this["DialogWinShort"] := "Win"
this["DialogWith"] := "with"
this["DialogWordWrap"] := "Word wrap"
this["DialogYes"] := "Yes"
this["EditAHKDecode"] := "dec["ode"] from AutoHotkey special characters"
this["EditAHKEncode"] := "Encode AutoHotkey special characters"
this["EditAHKVarExpressionDecode"] := "AutoHotkey Expression to %var%"
this["EditAHKVarExpressionEncode"] := "AutoHotkey %var% to Expression"
this["EditASCIIDecode"] := "Unlist ASCII codes"
this["EditASCIIEncode"] := "List ASCII codes"
this["EditChangeCase"] := "Change case"
this["EditChangeCaseConfirmDontShow"] := "OK, got it"
this["EditChangeCaseHelpClipboard"] := "Select the case you want to apply to the A_Clipboard'S.Length content: Lower case, Upper case, Title case (upper case first letter of each word), Toggle case or Sentence case."
this["EditClipboardAllBase64Decode"] := "dec["ode"] Base64 text in editor and load it to A_Clipboard"
this["EditClipboardAllBase64Encode"] := "Encode full A_Clipboard to Base64 text"
this["EditClipboardImageBase64Decode"] := "dec["ode"] Base64 text in editor and load image to A_Clipboard"
this["EditClipboardImageBase64Encode"] := "Encode image in A_Clipboard to Base64 text"
this["EditConvert"] := "Convert"
this["EditEncodingHelp"] := "Use backtick sequences ``t for tab and ``n for end-of-line (use ```` to enter `` alone)."
this["EditFilterCharacters"] := "Filter characters"
this["EditFilterLines"] := "Filter lines"
this["EditFind"] := "Find"
this["EditFindNext"] := "Find next"
this["EditFindPrevious"] := "Find previous"
this["EditFindRegEx"] := "Regular expression"
this["EditFindReplace"] := "Find and replace"
this["EditFindSlashReplace"] := "Find/Replace"
this["EditFindWhat"] := "Find what"
this["EditHexDecode"] := "dec["ode"] from hex["adecimal"]"
this["EditHexEncode"] := "Encode hex["adecimal"]"
this["EditHTMLDecode"] := "dec["ode"] from HTML entities and line breaks"
this["EditHTMLEncode"] := "Encode HTML entities and line breaks"
this["EditInsertString"] := "Insert string"
this["EditKeepLines"] := "Keep lines"
this["EditManageSavedCommands"] := "Manage Saved commands"
this["EditPHPDoubleDecode"] := "dec["ode"] from PHP double-quoted string"
this["EditPHPDoubleEncode"] := "Encode for PHP double-quoted string"
this["EditPHPSingleDecode"] := "dec["ode"] from PHP single-quoted string"
this["EditPHPSingleEncode"] := "Encode for PHP single-quoted string"
this["EditReformatParaAlignCenter"] := "Center"
this["EditReformatParaAlignIndent"] := "Indent"
this["EditReformatParaAlignLeft"] := "Left"
this["EditReformatParaAlignPrompt"] := "Align lines"
this["EditReformatParaAlignRight"] := "Right"
this["EditReformatParaAlignTitle"] := "align ~1~"
this["EditReformatParaIndentCharactersFirst"] := "First line"
this["EditReformatParaIndentCharactersOther"] := "Other lines"
this["EditReformatParaIndentCharactersPrompt"] := "Indentation characters"
this["EditReformatParaLineWidth"] := "Line Width[0]"
this["EditReformatParaLineWidthTitle"] := "~1~ characters wide"
this["EditReformatParaLineWidthZero"] := "(0 to reformat paragraphs on one line)"
this["EditReformatParaLineWidthZeroTitle"] := "on one line"
this["EditReformatParaMerged"] := "Merge all (or selected) text in one paragraph"
this["EditReformatParaMergedTitle"] := "merged"
this["EditReformatParaPunct1Space"] := "Insert one space after these characters"
this["EditReformatParaPunct1SpaceBefore"] := "Insert one space before these characters"
this["EditReformatParaPunct2Spaces"] := "Insert a second space after these characters"
this["EditReformatParaPunctDefault"] := "<a>default settings</a>"
this["EditReformatParaPunctTitle"] := "reformat punctuation"
this["EditReformatParaPunctUpperAfter"] := "Upper case the first character after these characters"
this["EditReformatParaPunctYesNo"] := "Reformat punctuation?"
this["EditReformatParaSeparated"] := "Reformat and separate identified paragraphs"
this["EditReformatParaSeparatedTitle"] := "paragraphs"
this["EditReplaceMatchCase"] := "Match case"
this["EditReplacePrompt"] := "Replace?"
this["EditReplaceWith"] := "Replace with"
this["EditSort"] := "Sort"
this["EditSortHelpClipboard"] := "Without any option, all the lines of the A_Clipboard will be sorted in alphabetical order. Optionaly, you can enable one or more of these special options to change the Sort command result."
this["EditSortHelpEditor"] := "Without any option, the selected lines of the editor (or all lines) will be sorted in  alphabetical order. Optionaly, you can enable one or more of these special options to change the Sort command result."
this["EditSortHelpLink"] := "See <a href=""~1~"">AutoHotkey Sort Help</a>."
this["EditSubString"] := "Substring"
this["EditSubStringHelp2"] := "• Enter the BEGINNING of the selection in the top area: from the start, a specific position or the beginning/end of specified text (w/o offset).`n• Then enter the END of the selection in the bottom area: to the end, a specified length from start position, a specified position before the end or the beginning/end of specified text (w/o offset).`n"
this["EditSubStringHelp3"] := "In text fields, use backtick sequences ``t for tab and ``n for end-of-line."
this["EditURIDecode"] := "dec["ode"] from URL encoding (URI)"
this["EditURIEncode"] := "Encode for URL (URI)"
this["EditXMLDecode"] := "dec["ode"] from XML"
this["EditXMLEncode"] := "Encode for XML"
this["EditXMLEncodeNumeric"] := "Encode for XML with numeric values"
this["EditXMLEncodeNumericPrompt"] := "Enter characters to encode with numeric values"
this["GuiApplyRule"] := "Apply rule"
this["GuiApplyRules"] := "Apply rules"
this["GuiAvailableGroupsTip"] := "Show availabe groups of rules"
this["GuiAvailableRulesTip"] := "Show available rules"
this["GuiBinary"] := "Binary"
this["GuiBitmap"] := "Image"
this["GuiCancel"] := "Cancel"
this["GuiCharacters"] := "~1~ characters"
this["GuiClipboard"] := "A_Clipboard"
this["GuiClose"] := "Close"
this["GuiClosePasteButton"] := "Paste"
this["GuiClosePasteClipboardMenu"] := "Paste the text in the editor to the last active application"
this["GuiCopyButton"] := "Copy"
this["GuiCopyClipboardMenu"] := "Copy the text in the editor to the A_Clipboard"
this["GuiEditClipboard"] := "Edit A_Clipboard"
this["GuiEmpty"] := "Empty"
this["GuiEmptyOrBinary"] := "Empty or binary"
this["GuiEnableEditor"] := "Click the ""Edit A_Clipboard"" button (or press Ctrl+E) before using this command."
this["GuiFirstUpperCase"] := "First upper case"
this["GuiGetClipboardEmpty"] := "A_Clipboard format empty"
this["GuiGroupsLower"] := "groups"
this["GuiGroupsLower"] := "groups"
this["GuiHistorySearchTitle"] := "Search A_Clipboard History"
this["GuiHotkeysHelp"] := "Editor Shortcuts Help"
this["GuiInsectClipboardFormatsHelp"] := "A_Clipboard formats Help"
this["GuiInsectClipboardHeader"] := "Format|Format hex[0]|Format Name|Size[0]|Content"
this["GuiInsectClipboardLocaleHelp"] := "CF_LOCALE Help"
this["GuiInsectClipboardLocaleHelp"] := "CF_LOCALE Help"
this["GuiInspectClipboardNotLoaded"] := "This A_Clipboard property cannot be loaded."
this["GuiInspectClipboardTitle"] := "Inspect A_Clipboard"
this["GuiKB"] := "kb"
this["GuiLocked"] := "A_Clipboard locked"
this["GuiManageSavedCommandsTitle"] := "Manage Saved commands"
this["GuiOneCharacter"] := "1 character"
this["GuiResetDefault"] := "Reset default hotkey"
this["GuiRulesAvailable"] := "Available"
this["GuiRulesLower"] := "rules"
this["GuiSaveCommandPrompt"] := "Saved command title"
this["GuiSaveCommandReplace"] := "This title has already been used. Replace it?"
this["GuiSaveCommandTitle"] := "Saved command title"
this["GuiSaveCommandTitleSuggest"] := "Suggest"
this["GuiSelected"] := "Active"
this["GuiSelectedGroupsTip"] := "Show active groups of rules"
this["GuiSelectedRules"] := "Active rules"
this["GuiSelectedRulesTip"] := "Show active rules"
this["GuiSelectRuleDeselect"] := "Please highlight the rule to deactivate"
this["GuiSelectRuleEdit"] := "Please highlight the rule to edit"
this["GuiSelectRuleRemove"] := "Please highlight the rule to deactivate"
this["GuiSelectRuleSelect"] := "Please highlight the rule to activate"
this["GuiStatusBarSeeImage"] := "See image"
this["GuiStatusBarTip1"] := "The first section of the status bar shows the status of the editor:`n`n~1~: when the text in the editor is identical to the current A_Clipboard text content, any change in the A_Clipboard as you copy or cut text from any application is immediately reflected in the editor.`n`n~2~: when you retreive clips from the A_Clipboard history, the status turns to History and stays in this state as long as you navigate in history clips without editing them.`n`n~3~: as soon as you edit the text in the editor and it differs from the A_Clipboard text or from the last retreived History clip, QCE turns to Editing mode and works as any editor; you can edit the text using the Copy/Cut/Paste commands from the ""Edit"" menu of using usual hotkeys (Ctrl+C, Ctrl+V, etc.).`n`n~4~: when the editor is in Synced state, you can click the ""~5~"" checkbox to reveal the end-of-line and tabs characters. These characters are visible only in read-only mode.`n`nThis section of the status bar also shows one of these additional infos:`n- if the editor contains text: the Size[0] of the text in the A_Clipboard or in the editor;`n- if the A_Clipboard contains binary data: the word ""~6~"" or ""~7~"" if it contains a bitmap, and the Size[0] of this data in kb;`n- if the A_Clipboard is empty: the word ""~8~""."
this["GuiStatusBarTip2"] := "The second section of the status bar indicates the current position of the insertion point in the editor and the length of the selected text."
this["GuiStatusBarTip3"] := "If the editor contains text, this third section of the status bar displays the ASCII code (in dec["imal"] and hex["adecimal"]) of the first selected character.`n`nIf the A_Clipboard is synced and contains an image, this section displays the text ""See image"". Click this text to see the image in a temporary PNG file."
this["GuiTitleEditor"] := "Editor - ~1~ ~2~"
this["GuiTitleRules"] := "Rules - ~1~ ~2~"
this["GuiUnavailableXL"] := "Info.Length unavailable with Excel"
this["GuiUnderscore2Space"] := "Underscode to space"
this["MenuAbout"] := "About ~1~"
this["MenuASCII"] := "ASCII"
this["MenuAutoHotkey"] := "AutoHotkey"
this["MenuBinary"]:= "Binary"
this["MenuCancelEditor"] := "Cancel changes in the editor and revert to the A_Clipboard"
this["MenuClipboard"] := "A_Clipboard"
this["MenuCloseEditor"] := "Close the editor"
this["MenuCopyToAppend"] := "Copy to Append to the editor"
this["MenuDebugInfo"] := "Debug Info.Length"
this["MenuDisplayEditorAtStartup"] := "Display ~1~ editor at startup"
this["MenuDonate"] := "Make a donation"
this["MenuEditIniFile"] := "Edit ~1~"
this["MenuEditor"] := "Editor"
this["MenuEditorEdit"] := "Edit"
this["MenuEditorTray"] := "Editor (~1~)"
this["MenuExitApp"] := "Exit ~1~"
this["MenuFile"] := "File"
this["MenuFileCopyAs"] := "Copy the text in the editor to A_Clipboard As Format"
this["MenuFileCopyAsFiles"] := "Copy to A_Clipboard As Files"
this["MenuFileCopyAsFilesCut"] := "Cut to A_Clipboard As Files"
this["MenuFileCopyAsHTML"] := "Copy to A_Clipboard As HTML"
this["MenuFileCopyAsRTF"] := "Copy to A_Clipboard As RTF"
this["MenuFileGetClipboardFiles"] := "Get A_Clipboard Files"
this["MenuFileGetClipboardFor"] := "Get A_Clipboard Format to the editor as text"
this["MenuFileGetClipboardFor"] := "Get the text or source code for A_Clipboard Format"
this["MenuFileGetClipboardHTML"] := "Get A_Clipboard HTML"
this["MenuFileGetClipboardRTF"] := "Get A_Clipboard RTF"
this["MenuFileGetClipboardText"] := "Get A_Clipboard Text"
this["MenuFileSave"] := "Save text to file"
this["MenuFlushHistoryDb"] := "Delete history database"
this["MenuHelp"] := "Help"
this["MenuHexaDecimal"] := "hex["adecimal"]"
this["MenuHistorySearch"] := "Search A_Clipboard History"
this["MenuHotkeysHelp"] := "Shortcuts Help"
this["MenuHTML"] := "HTML"
this["MenuKeepOpenAfterPaste"] := "Keep the editor open after Paste"
this["MenuNoRule"] := "No rule"
this["MenuOpenWorkingDirectory"] := "Open Settings folder"
this["MenuOptions"] := "Options"
this["MenuPHP"] := "PHP"
this["MenuReload"] := "Restart ~1~"
this["MenuRule"] := "Rule"
this["MenuRuleAdd"] := "Add rule"
this["MenuRuleCopy"] := "Copy rule"
this["MenuRuleDeselect"] := "Deactivate rule"
this["MenuRuleDeselectAll"] := "Deactivate all rules"
this["MenuRuleEdit"] := "Edit rule"
this["MenuRuleGroupAdd"] := "Save active rules as a group"
this["MenuRuleRemove"] := "Remove rule"
this["MenuRules"] := "Rules"
this["MenuRuleSelect"] := "Activate rule"
this["MenuRuleUndo"] := "Undo last rule change"
this["MenuRunAtStartup"] := "Launch ~1~ with Windows"
this["MenuSelectCopyOpenQCE"] := "Change the hotkey to Copy and Open QCE "
this["MenuSelectEditorHotkeyKeyboard"] := "Change the keyboard hotkey to Open the editor "
this["MenuSelectEditorHotkeyMouse"] := "Change the mouse hotkey to Open the editor"
this["MenuSelectOpenHistoryMenu"] := "Change the hotkey to Open History Menu "
this["MenuSelectPasteFromQCE"] := "Change the hotkey to Paste from QCE"
this["MenuSelectRulesHotkeyKeyboard"] := "Select Rules manager keyboard hotkey"
this["MenuSelectRulesHotkeyMouse"] := "Select Rules manager mouse hotkey"
this["MenuShowBoth"] := "Show both"
this["MenuShowHistoryMenu"] := "A_Clipboard History"
this["MenuSortAgain"] := "Sort again (same options)"
this["MenuSortOptions"] := "Sort with options"
this["MenuSortQuick"] := "Quick sort (alphabetically)"
this["MenuSuspendHotkeys"] := "Suspend Hotkeys"
this["MenuUpdate"] := "Check for update"
this["MenuUrlUri"] := "URL (URI)"
this["MenuWebHelp"] := "Help"
this["MenuWebSite"] := "Visit ~1~ website"
this["MenuWindow"] := "Window"
this["MenuXML"] := "XML"
this["OopsClipboardIsBusy"] := "The A_Clipboard is busy. Try again later."
this["OopsCopyToClipboardAsFiles"] := "Files or folders copied or cut to the A_Clipboard must exist.`n`nThis item does not exist:`n~1~"
this["OopsErrorCreatingImage"] := "Error creating image file: error #~1~"
this["OopsErrorReadingFileToClipboard"] := "Error loading text file to A_Clipboard (error #~1~):`n`n~2~"
this["OopsErrorReadingFileToEditor"] := "Error loading text file to editor (error #~1~):`n`n~2~"
this["OopsErrorSavingFile"] := "Error saving editor content to file (error #~1~):`n`n~2~"
this["OopsErrorSavingImage"] := "Error saving A_Clipboard image to file (error #~1~):`n`n~2~"
this["OopsHistoryDbSQLiteMissing"] := "SQLite resource files missing:`n`n~1~`nUnable to navigate in A_Clipboard history."
this["OopsJLiconsError"] := "QCE tray icon not found. Make sure you updated the JLicons.dll file to ~1~:`n`n~2~"
this["OopsJLiconsOutdated"] := "The following file needs to be updated:`n`n~1~`n`nReplace it with JLicons.dll version ~2~ from the latest portable installation ZIP file and restart ~3~."
this["OopsMoveLineNoWordWrap"] := "Turn ""Word wrap"" off to use the move lines commands."
this["OopsNameExists"] := "The rule name ""~1~"" is already used.`n`nPlease select a unique rule name."
this["OopsNoPipe"] := "The pipe character | is not allowed in saved command title. Please, edit the saved command title."
this["OopsNotAdmin"] := "~1~ could not be launched as Administrator.`n`nIt is now running as Normal."
this["OopsNotAllowedInRuleNames"] := "Equal sign (=) and semi-colon (;) are not allowed in rule name."
this["OopsOSVerrsionError"] := "~1~ requires Window 7 or a more recent operating system."
this["OopsTitle"] := "~1~ (~2~)"
this["OopsValueMissing"] := "A value is missing..."
this["OopsWriteProtectedError"] := "It appears that ~1~ is running from a WRITE-PROTECTED folder where the configuration file ""~1~.ini"" could not be created.`n`nMove the ~1~ files to the REGULAR folder of your choice and re-run it from this folder.`n`n~1~ will quit."
this["OopsZipFileError"] := "It appears that ~1~ is running directly from a .ZIP file.`n`nYou must extract the ~1~ .EXE file from the .ZIP file to the folder of your choice before running it.`n`n~1~ will quit."
this["OptionsAsciiHexa"] := "Show selected character ASCII hex["adecimal"] code"
this["OptionsBackupFolder"] := "Settings file backup folder"
this["OptionsChangeHotkey"] := "Change"
this["OptionsCheck4Update"] := "Check for update"
this["OptionsCheck4UpdateNow"] := "Check for update now"
this["OptionsClipboardHistory"] := "A_Clipboard History"
this["OptionsClipboardHistoryEnable"] := "Enable A_Clipboard History"
this["OptionsCopyAppendSeparator"] := "Copy to append separator"
this["OptionsDarkMode"] := "Dark mode support"
this["OptionsDatabase"] := "Database"
this["OptionsDisplayTrayTip"] := "Display Startup Tray Tip"
this["OptionsEditorAtStartup"] := "Open ""Editor"" window at Startup"
this["OptionsEditorWindow"] := "Editor Window"
this["OptionsFileEncodingCodePage"] := "Custome file encoding codepage"
this["OptionsGuiTitle"] := "Options - ~1~ ~2~"
this["OptionsHistory"] := "History"
this["OptionsHistoryDbFlushDatabase"] := "Flush History database"
this["OptionsHistoryDbMaximumSize"] := "History database maximum Size[0] (in MB)"
this["OptionsHistoryMenuCharsWidth"] := "Width[0] (in number of characters)"
this["OptionsHistoryMenuIconSize"] := "Icons Size[0]"
this["OptionsHistoryMenuRows"] := "Number of rows"
this["OptionsHistoryMenus"] := "History Menus"
this["OptionsHistorySearch"] := "History Search"
this["OptionsHistorySearchQueryRows"] := "Search query number of rows"
this["OptionsHistorySyncDelay"] := "A_Clipboard sync delay (ms)"
this["OptionsHotkeys"] := "Hotkeys"
this["OptionsHotkeysIntro"] := "Define the mouse buttons and keyboard hotkeys that will open the ~1~ editor.`nAlso define the hotkeys to copy and paste from other applications."
this["OptionsLaunch"] := "Launch"
this["OptionsLaunchAtStartup"] := "Launch ~1~ at startup"
this["OptionsPopupHotkeyTitles"] := "Open ~1~ Mouse button|Open ~1~ Keyboard shortcut|Paste from ~1~ shortcut|Copy text and open ~1~|Open A_Clipboard History Menu"
this["OptionsPopupHotkeyTitlesSub"] := "This mouse button will open ~1~.|This hotkey will open ~1~.|This hotkey will paste the content of the editor in the active window.|This hotkey will copy the selected text and open ~1~|This hotkey will open the A_Clipboard History Menu at the mouse position"
this["OptionsQCETempFolder"] := "Temporary Folder"
this["OptionsReloadPrompt"] := "~1~ needs to be restarted. Unsaved changes in the editor will be lost. If you dont't restart, the options changes will take effect at the next session.`n`nDo you want to restart ~1~ now? "
this["OptionsRememberEditorPosition"] := "Remember the editor window position"
this["OptionsSavedCommandsLinesInList"] := "Number of Saved commands in lists"
this["OptionsStartupDefault"] := "Startup Default"
this["OptionsVarious"] := "Various"
this["ToolTipButtonCancel"] := "Restore the current content of the A_Clipboard"
this["ToolTipButtonClose"] := "Close the editor (after confirmation if changes were not saved)"
this["ToolTipButtonHistoryNext"] := "Restore the next item from A_Clipboard history"
this["ToolTipButtonHistoryPrev"] := "Restore the previous item from A_Clipboard history"
this["ToolTipButtonPaste"] := "Paste the content of the editor to the last active application"
this["ToolTipButtonSave"] := "Copy the content of the editor to A_Clipboard"
this["ToolTipStatusBar"] := "Click on the status bar for more information"
this["TrayTipInstalledDetail"] := "~1~ to open the A_Clipboard editor"
this["TrayTipInstalledTitle"] := "~1~ ready!"
this["TypeChangeCase"] := "Change case"
this["TypeFileClipboardBackup"] := "Backup A_Clipboard"
this["TypeFileClipboardBackupHelpEditor"] := "Save to a binary file the A_Clipboard content with its various formats"
this["TypeFileClipboardRestore"] := "Restore A_Clipboard"
this["TypeFileClipboardRestoreHelpEditor"] := "Restore from a binary file the A_Clipboard content with its various formats"
this["TypeFileOpen"] := "Open text file"
this["TypeFileOpenHelpEditor"] := "Select the file to open, specify if you want to load it in the editor, the A_Clipboard or both, and, if necessary, set the file encoding of the file to read."
this["TypeFileSave"] := "Save file"
this["TypeFileSaveHelpEditor"] := "Select the path and name of the file to save and, if necessary, specify the type of end-of-lines format and the file encoding."
this["TypeFilterCharacters"] := "Filter characters"
this["TypeFilterCharactersHelpEditor"] := "Specify the characters to delete or keep. If deleting characters, indicate if they must be deleted anywhere or only at the beginning or the end of lines."
this["TypeFilterLines"] := "Filter lines"
this["TypeFilterLinesHelpEditor"] := "Specify the lines to keep or remove using one of these filters."
this["TypeFind"] := "Find"
this["TypeFindHelpEditor"] := "Type the characters to search in the whole editor or only in the selected text. Select if you wish to search with exact case match."
this["TypeFindReplace"] := "Find and replace"
this["TypeFindReplaceHelpEditor"] := "Type the characters to search from the current position and the text to replace. Select if you wish to search and replace with exact case match."
this["TypeInsertString"] := "Insert string"
this["TypeInsertStringHelpEditor"] := "Insert a string at any position inside each line of the editor'S.Length content. Select the position of insertion: from a given position from the start of each line or from the beginning/end of specified text (with or without offset)."
this["TypeKeepLines"] := "Keep lines"
this["TypeKeepLinesHelpEditor"] := "Specify the lines to keep using these filters."
this["TypeReformatPara"] := "Reformat paragraph"
this["TypeReformatParaHelpEditor"] := "Set the line Width[0], type of alignement, punctuation and hard return rules."
this["TypeSort"] := "Sort"
this["TypeSortHelpEditor"] := "Without any option, the selected lines of the editor (or all lines) will be sorted in  alphabetical order. Optionaly, you can enable one or more of these special options to change the Sort command result."
this["TypeSortHelpLink"] := "See <a href=""~1~"">AutoHotkey Sort Help</a>."
this["TypeSubString"] := "Substring"
this["TypeSubStringHelp2"] := "• Enter the BEGINNING of the selection in the top area: from the start, a specific position or the beginning/end of specified text (w/o offset).`n• Then enter the END of the selection in the bottom area: to the end, a specified length from start position, a specified position before the end or the beginning/end of specified text (w/o offset).`n"
this["TypeSubStringHelpEditor"] := "Select the text you want to KEEP or REMOVE on each line in the editor. Pressing KEEP will keep the text between the selected start and end. Pressing REMOVE will do the opposite.`n"
this["UpdateButtonChangeLog"] := "See change log"
this["UpdateButtonDownloadPortable"] := "Download Portable zip file"
this["UpdateButtonDownloadSetup"] := "Download Setup file"
this["UpdateButtonRemind"] := "Remind me"
this["UpdateButtonSkipVersion"] := "Skip this version"
this["UpdateButtonVisit"] := "Visit web site"
this["UpdateError"] := "An error occurred while accessing the latest version number. Checking for update interrupted."
this["UpdatePrompt"] := "Update ~1~ from v~2~ to v~3~?"
this["UpdatePromptBetaContinue"] := "Do you still want to to be informed of future beta versions?"
this["UpdateTitle"] := "Update ~1~?"
this["UpdateYouHaveLatest"] := "You have the latest version: ~1~.`n`nVisit the ~2~ web page anyway?"
this.LanguageCode := o_Settings.Launch.strLanguageCode.IniValue
}
LanguageCode[]
{
Set
{
strDebugLanguageFile := A_WorkingDir . "\" . g_strAppNameFile . "_LANG_ZZ.txt"
if FileExist(strDebugLanguageFile)
{
strLanguageFile := strDebugLanguageFile
this._LanguageCode := "EN"
}
else
{
strLanguageFile := (value = "EN" ? "" : g_strTempDir . "\" . g_strAppNameFile . "_LANG_" . value . ".txt")
this._LanguageCode := (FileExist(strLanguageFile) ? value : "EN")
}
if StrLen(strLanguageFile) and FileExist(strLanguageFile)
{
strReplacementForSemicolon := g_strEscapeReplacement
strLanguageStrings := Fileread(strLanguageFile)
Loop Parse, strLanguageStrings, "`n", "`r"
{
if (SubStr(A_LoopField, 1, 1) <> ";")
{
saLanguageBit := StrSplit(A_LoopField, "`t")
if SubStr(saLanguageBit[1], 1, 1) <> "l"
continue
else
saLanguageBit[1] := SubStr(saLanguageBit[1], 2)
this[saLanguageBit[1]] := saLanguageBit[2]
this[saLanguageBit[1]] := StrReplace(this[saLanguageBit[1]], "``n", "`n")
if InStr(this[saLanguageBit[1]], ";;")
this[saLanguageBit[1]] := StrReplace(this[saLanguageBit[1]], ";;", strReplacementForSemicolon)
if InStr(this[saLanguageBit[1]], ";")
this[saLanguageBit[1]] := Trim(SubStr(this[saLanguageBit[1]], 1, InStr(this[saLanguageBit[1]], ";") - 1))
if InStr(this[saLanguageBit[1]], strReplacementForSemicolon)
this[saLanguageBit[1]] := StrReplace(this[saLanguageBit[1]], strReplacementForSemicolon, ";")
}
}
}
}
Get
{
return this._LanguageCode
}
}
InsertAmpersand(saIn*)
{
saContentCleaned := Object()
aaOut := Object()
if (SubStr(saIn[1], 1, 1) = "*")
aaOut.strUsed := SubStr(saIn.RemoveAt(1), 2)
Loop saIn.MaxIndex()
{
saThisContent := StrSplit(saIn[A_Index], "@")
strThisContentExpanded := L(o_L[saThisContent[1]], saThisContent[2])
saContentCleaned[A_Index] := RegExReplace(strThisContentExpanded, "[^a-zA-Z]", "")
strSort .= StrLen(saContentCleaned[A_Index]) . "|" . saIn[A_Index] . "|" . A_Index . "|" . strThisContentExpanded . "`n"
}
strSort := SubStr(strSort, 1, -1)
strSort := Sort(strSort, "N")
saSorted := StrSplit(strSort, "`n")
for intKey, strThisStr in saSorted
{
saThisStr := StrSplit(strThisStr, "|")
aaOut[saThisStr[2]] := saThisStr[4]
Loop Parse, saContentCleaned[saThisStr[3]]
{
if !InStr(aaOut.strUsed, A_LoopField)
{
aaOut.strUsed .= A_LoopField
aaOut[saThisStr[2]] := StrReplace(saThisStr[4], A_LoopField, "&" . A_LoopField, , , 1)
break
}
}
}
return aaOut
}
InsertAmpersandInString(strIn)
{
saContentCleaned := Object()
saOut := Object()
Loop Parse, strIn, "|"
{
strCleaned := RegExReplace(A_LoopField, "[^a-zA-Z]", "")
strSort .= StrLen(strCleaned) . "|" . strCleaned . "|" . A_Index . "|" . A_LoopField . "`n"
}
strSort := SubStr(strSort, 1, -1)
strSort := Sort(strSort, "N")
saSorted := StrSplit(strSort, "`n")
for intKey, strThisStr in saSorted
{
saThisStr := StrSplit(strThisStr, "|")
saOut[saThisStr[3]] := saThisStr[4]
Loop Parse, saThisStr[2]
{
if !InStr(strUsed, A_LoopField)
{
strUsed .= A_LoopField
saOut[saThisStr[3]] := StrReplace(saThisStr[4], A_LoopField, "&" . A_LoopField, , , 1)
break
}
}
}
for intKey, strValue in saOut
strOut .= strValue . "|"
strOut := SubStr(strOut, 1, -1)
return strOut
}
}
class EditCommandType
{
__New(strTypeCode, strTypeLabel, strTypeHelpEditor)
{
this.strTypeCode := strTypeCode
this.strTypeLabel := strTypeLabel
this.strTypeHelpEditor := strTypeHelpEditor
this.aaLastEditCommand := ""
strLastSessionCommandDetail := IniRead(o_Settings.strIniFile, "LastCommand", strTypeCode, A_Space)
if StrLen(strLastSessionCommandDetail)
this.strLastSessionCommandDetail := strLastSessionCommandDetail
g_aaEditCommandTypes[strTypeCode] := this
this.intID := g_saEditCommandTypesOrder.Push(this)
}
}
class EditCommand
{
__New(strCommandType)
{
this.strEditorControlHwnd := g_strEditorControlHwnd
this.strCommandType := strCommandType
}
ExecConvert(strConvertType)
{
this.GetEditorText(true)
if (strConvertType = "EditXMLEncodeNumeric")
{
strChars := GetXMLEncodeNumeric()
if !StrLen(strChars)
return
strConvertType := "EditXMLEncode"
}
strDirection := SubStr(strConvertType, -6)
strConvertType := SubStr(strConvertType, 5, -6)
if (strConvertType = "URI")
if (strDirection = "Encode")
this.SetEditorText(EncodeDecodeURI(this.strEditTargetText, true))
else
this.SetEditorText(EncodeDecodeURI(this.strEditTargetText, false))
else if (strConvertType = "XML")
if (strDirection = "Encode")
this.SetEditorText(EncodeXML(this.strEditTargetText, strChars))
else
this.SetEditorText(dec["odeXML"](this.strEditTargetText))
else if (strConvertType = "hex[0]")
if (strDirection = "Encode")
this.SetEditorText(EncodeHex(this.strEditTargetText))
else
this.SetEditorText(dec["odeHex"](this.strEditTargetText))
else if (strConvertType = "ASCII")
if (strDirection = "Encode")
this.SetEditorText(EncodeASCII(this.strEditTargetText))
else
this.SetEditorText(dec["odeASCII"](this.strEditTargetText))
else if (strConvertType = "HTML")
if (strDirection = "Encode")
this.SetEditorText(EncodeHTML(this.strEditTargetText, 3))
else
this.SetEditorText(dec["odeHTML"](this.strEditTargetText))
else if (strConvertType = "PHPDouble")
if (strDirection = "Encode")
this.SetEditorText(EncodePHPDouble(this.strEditTargetText))
else
this.SetEditorText(dec["odePHPDouble"](this.strEditTargetText))
else if (strConvertType = "PHPSingle")
if (strDirection = "Encode")
this.SetEditorText(EncodePHPSingle(this.strEditTargetText))
else
this.SetEditorText(dec["odePHPSingle"](this.strEditTargetText))
else if (strConvertType = "AHK")
if (strDirection = "Encode")
this.SetEditorText(EncodeAHK(this.strEditTargetText))
else
this.SetEditorText(dec["odeAHK"](this.strEditTargetText))
else if (strConvertType = "AHKVarExpression")
if (strDirection = "Encode")
this.SetEditorText(dec["odeAHKVarExpression"](this.strEditTargetText))
else
this.SetEditorText(EncodeAHKVarExpression(this.strEditTargetText))
else if (strConvertType = "ClipboardAllBase64")
if (strDirection = "Encode")
this.SetEditorText(EncodeClipboardAllBase64())
else
{
dec["odeClipboardAllBase64"](this.strEditTargetText)
this.SetEditorText(WinClipGetTextOrFiles())
}
else if (strConvertType = "ClipboardImageBase64")
if (strDirection = "Encode")
this.SetEditorText(EncodeClipboardImageBase64())
else
{
this.SetEditorText(dec["odeClipboardImageBase64"](this.strEditTargetText))
ClipboardContentChanged(0)
}
}
ExecChangeCase(strChangeCaseType)
{
this.GetEditorText(true)
strChangeCaseType := StrReplace(strChangeCaseType, "ChangeCase")
if (strChangeCaseType = "Sentence")
this.SetEditorText(this.SentenceCase())
else if (strChangeCaseType = "Toggle")
this.SetEditorText(this.ToggleCase())
else if (strChangeCaseType = "SaRcAsM")
this.SetEditorText(this.SaRcAsMCase())
else
this.SetEditorText(RegExReplace(this.strEditTargetText, ".*", "$"  . SubStr(strChangeCaseType, 1, 1) . "0"))
}
ExecSubString(strButton, intSubStringFromType, intFromPosition, strFromText, intFromPlusMinus, intSubStringToType, intSubStringToLength, strSubStringToText, intSubStringToPlusMinus)
{
this.GetEditorText(true)
this.intSubStringFromType := intSubStringFromType
this.intFromPosition := intFromPosition
this.strFromText := dec["odeEolAndTab"](strFromText)
this.intFromPlusMinus := intFromPlusMinus
this.intSubStringToType := intSubStringToType
this.intSubStringToLength := intSubStringToLength
this.strSubStringToText := dec["odeEolAndTab"](strSubStringToText)
this.intSubStringToPlusMinus := intSubStringToPlusMinus
if (this.intSubStringFromType < 3)
blnFromFound := true
if (this.intSubStringFromType = 1)
this.intStartingPos := 1
else if (this.intSubStringFromType = 2)
this.intStartingPos := this.intFromPosition
if (this.intSubStringToType < 4)
blnToFound := true
if (this.intSubStringToType = 1)
this.intLength := g_intMaximumValue
else if (this.intSubStringToType = 2)
this.intLength := this.intSubStringToLength
else if (this.intSubStringToType = 3)
this.intLength := this.intSubStringToLength
Loop Parse, this.strEditTargetText, "`n", "`r"
{
if (this.intSubStringFromType = 3)
this.intStartingPos := this.GetFromBeginText(A_LoopField, blnFromFound)
else if (this.intSubStringFromType = 4)
this.intStartingPos := this.GetFromEndText(A_LoopField, blnFromFound)
if (this.intSubStringToType = 4)
this.intLength := this.GetToBeginText(A_LoopField, blnToFound)
else if (this.intSubStringToType = 5)
this.intLength := this.GetToEndText(A_LoopField, blnToFound)
strLine := (blnFromFound and blnToFound ? SubStr(A_LoopField, (this.intStartingPos)<1 ? (this.intStartingPos)-1 : (this.intStartingPos), this.intLength) : A_LoopField)
if (strButton = "f_btnRemove")
strLine := StrReplace(A_LoopField, strLine)
strAppendText .= strLine . "`r`n"
}
this.SetEditorText(SubStr(strAppendText, 1, -2))
}
ExecInsertString(strInsertString, intInsertStringFromType, intFromPosition, strFromText, intInsertStringFromPlusMinus)
{
this.GetEditorText(true)
this.strInsertString := dec["odeEolAndTab"](strInsertString)
this.intInsertStringFromType := intInsertStringFromType
this.intFromPosition := intFromPosition
this.strFromText := dec["odeEolAndTab"](strFromText)
this.intFromPlusMinus := intInsertStringFromPlusMinus
if (this.intInsertStringFromType < 3 or this.intInsertStringFromType > 4)
blnFromFound := true
if (this.intInsertStringFromType = 1)
this.intStartingPos := 1
else if (this.intInsertStringFromType = 2)
this.intStartingPos := this.intFromPosition
Loop Parse, this.strEditTargetText, "`n", "`r"
{
if (this.intInsertStringFromType = 3)
this.intStartingPos := this.GetFromBeginText(A_LoopField, blnFromFound)
else if (this.intInsertStringFromType = 4)
this.intStartingPos := this.GetFromEndText(A_LoopField, blnFromFound)
if (this.intInsertStringFromType = 5)
strAppendText .= A_LoopField . this.strInsertString
else if (blnFromFound and StrLen(A_LoopField) >= this.intStartingPos)
strAppendText .= SubStr(A_LoopField, 1, this.intStartingPos - 1) . this.strInsertString . SubStr(A_LoopField, (this.intStartingPos)<1 ? (this.intStartingPos)-1 : (this.intStartingPos))
else
strAppendText .= A_LoopField
strAppendText .= "`r`n"
}
this.SetEditorText(SubStr(strAppendText, 1, -2))
}
ExecFilterLines(intFilterLinesType, strFilterLinesCriteriaList, intFilterLinesContainingType, strFilterLinesCriteriaRegex, blnFilterLinesCase)
{
this.GetEditorText(true)
this.intFilterLinesType := intFilterLinesType
this.strFilterLinesCriteriaList := strFilterLinesCriteriaList
this.intFilterLinesContainingType := intFilterLinesContainingType
this.strFilterLinesCriteriaRegex := strFilterLinesCriteriaRegex
this.blnFilterLinesCase := blnFilterLinesCase
Loop Parse, this.strEditTargetText, "`n", "`r"
{
if (this.intFilterLinesType = 1)
{
if (intFilterLinesContainingType = 1)
{
if !InStrMultipleAnd(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
else if (intFilterLinesContainingType = 2)
{
if !InStrMultipleOr(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
else if (intFilterLinesContainingType = 3)
{
if InStrMultipleAnd(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
else if (intFilterLinesContainingType = 4)
{
if InStrMultipleOr(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
}
else if (this.intFilterLinesType = 2)
{
if !RegExMatch(A_LoopField, this.strFilterLinesCriteriaRegex)
strResult .= A_LoopField . "`r`n"
}
else if (this.intFilterLinesType = 3)
{
if StrLen(A_LoopField)
strResult .= A_LoopField . "`r`n"
}
else if (this.intFilterLinesType = 4)
{
if StrLen(Trim(A_LoopField))
strResult .= A_LoopField . "`r`n"
}
else if (this.intFilterLinesType = 11)
{
if (intFilterLinesContainingType = 1)
{
if InStrMultipleAnd(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
else if (intFilterLinesContainingType = 2)
{
if InStrMultipleOr(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
else if (intFilterLinesContainingType = 3)
{
if !InStrMultipleAnd(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
else if (intFilterLinesContainingType = 4)
{
if !InStrMultipleOr(A_LoopField, strFilterLinesCriteriaList, "`n", blnFilterLinesCase)
strResult .= A_LoopField . "`r`n"
}
}
else if (this.intFilterLinesType = 12)
{
if RegExMatch(A_LoopField, this.strFilterLinesCriteriaRegex)
strResult .= A_LoopField . "`r`n"
}
else if (this.intFilterLinesType = 13)
{
if RegExMatch(A_LoopField, "^\d+$")
strResult .= A_LoopField . "`r`n"
}
else if (this.intFilterLinesType = 14)
{
if RegExMatch(A_LoopField, "^[A-Za-z]+$")
strResult .= A_LoopField . "`r`n"
}
}
if (SubStr(this.strEditTargetText, -1, 2) <> "`r`n")
strResult := SubStr(strResult, 1, -2)
this.SetEditorText(strResult)
}
ExecFilterCharacters(strFilterCharactersList, intFilterCharactersType, blnFilterCharactersCase)
{
this.GetEditorText(true)
this.strFilterCharactersList := dec["odeEolAndTab"](strFilterCharactersList)
this.intFilterCharactersType := intFilterCharactersType
this.blnFilterCharactersCase := blnFilterCharactersCase
;REMOVED StringCaseSense, % (blnFilterCharactersCase ? "On" : "Off")
if (this.intFilterCharactersType = 1)
{
strDeleted := this.strEditTargetText
Loop Parse, this.strFilterCharactersList
strDeleted := StrReplace(strDeleted, A_LoopField, , , &blnFilterCharactersCase)
}
else if (this.intFilterCharactersType = 11)
{
strDeleted := ""
Loop Parse, this.strEditTargetText
if InStr(this.strFilterCharactersList, A_LoopField, blnFilterCharactersCase)
strDeleted .= A_LoopField
}
else
{
Loop Parse, this.strEditTargetText, "`n", "`r"
{
if (this.intFilterCharactersType = 2)
strLine := Trim(A_LoopField, this.strFilterCharactersList)
else if (this.intFilterCharactersType = 3)
strLine := LTrim(A_LoopField, this.strFilterCharactersList)
else if (this.intFilterCharactersType = 4)
strLine := RTrim(A_LoopField, this.strFilterCharactersList)
strDeleted .= strLine . "`r`n"
}
if (SubStr(this.strEditTargetText, -1, 2) <> "`r`n")
strDeleted := SubStr(strDeleted, 1, -2)
}
;REMOVED StringCaseSense, Off
this.SetEditorText(strDeleted)
}
ExecReformatPara(blnEditReformatParaSeparated, intEditReformatParaLineWidth, intEditReformatParaAlignType, strEditReformatParaIndentCharactersFirst, strEditReformatParaIndentCharactersOther, blnEditReformatParaPunct, strEditReformatParaPunct1Space, strEditReformatParaPunct2Spaces, strEditReformatParaPunctUpperAfter, strEditReformatParaPunct1SpaceBefore)
{
this.blnEditReformatParaSeparated := blnEditReformatParaSeparated
this.intEditReformatParaLineWidth := intEditReformatParaLineWidth
this.intEditReformatParaAlignType := intEditReformatParaAlignType
this.strEditReformatParaIndentCharactersFirst := strEditReformatParaIndentCharactersFirst
this.strEditReformatParaIndentCharactersOther := strEditReformatParaIndentCharactersOther
this.blnEditReformatParaPunct := blnEditReformatParaPunct
this.strEditReformatParaPunct1Space := strEditReformatParaPunct1Space
this.strEditReformatParaPunct2Spaces := strEditReformatParaPunct2Spaces
this.strEditReformatParaPunct1SpaceBefore := strEditReformatParaPunct1SpaceBefore
this.strEditReformatParaPunctUpperAfter := strEditReformatParaPunctUpperAfter
this.GetEditorText(true)
strEditReformatPara := para(this.strEditTargetText, this.intEditReformatParaLineWidth, this.intEditReformatParaAlignType, this.blnEditReformatParaSeparated, (this.blnEditReformatParaPunct ? 3 : 0), , "`r`n", this.strEditReformatParaIndentCharactersFirst, this.strEditReformatParaIndentCharactersOther, this.strEditReformatParaPunct1Space, this.strEditReformatParaPunctUpperAfter, this.strEditReformatParaPunct2Spaces, this.strEditReformatParaPunct1SpaceBefore)
this.SetEditorText(strEditReformatPara)
}
ExecFind(strFindOrReplaceWhat, blnFindOrReplaceMatchCase, blnFindOrReplaceRegEx, blnIsFirst)
{
if !(blnIsFirst)
{
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
blnIsFirst := (this.intNextSearchStart <> intSelEnd)
}
if (blnIsFirst)
{
this.blnSearchInSelection := Edit_TextIsSelected(this.strEditorControlHwnd)
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
this.intSearchInSelectionStart := intSelStart
this.intSearchInSelectionEnd := intSelEnd
this.intSearchStart := (this.blnSearchInSelection ? this.intSearchInSelectionStart : this.intSearchInSelectionEnd)
this.intSearchEnd := (this.blnSearchInSelection ? this.intSearchInSelectionEnd : -1)
this.strFindOrReplaceWhat := dec["odeEolAndTab"](strFindOrReplaceWhat)
this.blnFindOrReplaceMatchCase := blnFindOrReplaceMatchCase
this.blnFindOrReplaceRegEx := blnFindOrReplaceRegEx
}
else
{
Edit_SetSel(this.strEditorControlHwnd, -1)
this.intSearchStart := this.intNextSearchStart
}
this.strSearchedText := Edit_GetTextRange(this.strEditorControlHwnd, this.intSearchStart, this.intSearchEnd)
if (this.blnFindOrReplaceRegEx)
intFound := RegExMatch(this.strSearchedText, this.strFindOrReplaceWhat, &strRegExOutput)
else
intFound := InStr(this.strSearchedText, this.strFindOrReplaceWhat, this.blnFindOrReplaceMatchCase)
this.intNextSearchStart := this.intSearchStart + intFound
+ StrLen(this.blnFindOrReplaceRegEx ? strRegExOutput[0] : this.strFindOrReplaceWhat) - 1
Edit_SetSel(this.strEditorControlHwnd, (intFound ? this.intSearchStart + intFound - 1 : this.intSearchStart), (intFound ? this.intNextSearchStart : this.intSearchStart))
return intFound
}
ExecFindNext()
{
this.blnSearchInSelection := false
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
this.intSearchStart := intSelEnd
this.intSearchEnd := -1
this.strSearchedText := Edit_GetTextRange(this.strEditorControlHwnd, this.intSearchStart, this.intSearchEnd)
if (this.blnFindOrReplaceRegEx)
intFound := RegExMatch(this.strSearchedText, this.strFindOrReplaceWhat, &strRegExOutput)
else
intFound := InStr(this.strSearchedText, this.strFindOrReplaceWhat, this.blnFindOrReplaceMatchCase)
this.intNextSearchStart := this.intSearchStart + intFound
+ StrLen(this.blnFindOrReplaceRegEx ? strRegExOutput[0] : this.strFindOrReplaceWhat) - 1
Edit_SetSel(this.strEditorControlHwnd, (intFound ? this.intSearchStart + intFound - 1 : this.intSearchStart), (intFound ? this.intNextSearchStart : this.intSearchStart))
return intFound
}
ExecFindPrevious()
{
this.blnSearchInSelection := false
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
this.intSearchStart := 0
this.intSearchEnd := intSelStart
this.strSearchedText := Edit_GetTextRange(this.strEditorControlHwnd, this.intSearchStart, this.intSearchEnd)
if (this.blnFindOrReplaceRegEx)
intFound := RegExMatch(this.strSearchedText, ".*\K" . this.strFindOrReplaceWhat, &strRegExOutput)
else
intFound := InStr(this.strSearchedText, this.strFindOrReplaceWhat, this.blnFindOrReplaceMatchCase, -1)
this.intNextSearchStart := intFound + StrLen(this.blnFindOrReplaceRegEx ? strRegExOutput[0] : this.strFindOrReplaceWhat) - 1
Edit_SetSel(this.strEditorControlHwnd, (intFound ? intFound - 1 : this.intSearchEnd), (intFound ? this.intNextSearchStart : this.intSearchEnd))
return intFound
}
InitFindReplace(strFindOrReplaceWhat, strFindOrReplaceWith, blnFindOrReplaceMatchCase, blnFindOrReplaceRegEx)
{
this.strFindOrReplaceWhat := dec["odeEolAndTab"](strFindOrReplaceWhat)
this.strFindOrReplaceWith := dec["odeEolAndTab"](strFindOrReplaceWith)
this.blnFindOrReplaceMatchCase := blnFindOrReplaceMatchCase
this.blnFindOrReplaceRegEx := blnFindOrReplaceRegEx
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
this.intSearchStart := intSelStart
this.intFindReplaceEnd := (intSelStart = intSelEnd ? -1 : intSelEnd)
Edit_SetSel(this.strEditorControlHwnd, intSelStart, intSelStart)
}
ExecFindReplace(strFindOrReplaceWhat, strFindOrReplaceWith, blnFindOrReplaceMatchCase, blnFindOrReplaceRegEx, blnReplaceYes, blnIsFirst, blnCancelOrAll := false)
{
if (blnIsFirst)
this.InitFindReplace(strFindOrReplaceWhat, strFindOrReplaceWith, blnFindOrReplaceMatchCase, blnFindOrReplaceRegEx)
if (blnFindOrReplaceRegEx)
{
this.GetEditorText(true)
this.SetEditorText(RegExReplace(this.strEditTargetText, this.strFindOrReplaceWhat, this.strFindOrReplaceWith))
return false
}
if (blnReplaceYes)
{
Edit_ReplaceSel(this.strEditorControlHwnd, this.strFindOrReplaceWith)
this.intSearchStart := this.intSearchStart + this.intFound + StrLen(this.strFindOrReplaceWith) - 1
if (this.intFindReplaceEnd <> -1)
this.intFindReplaceEnd := this.intFindReplaceEnd - StrLen(this.strFindOrReplaceWhat) + StrLen(this.strFindOrReplaceWith)
Edit_SetSel(this.strEditorControlHwnd, this.intSearchStart, this.intSearchStart)
o_UndoPile.AddToPile()
if (blnCancelOrAll)
return
}
else
{
if StrLen(this.strSelectionBeforeInvisible)
Edit_ReplaceSel(this.strEditorControlHwnd, this.strSelectionBeforeInvisible)
if (blnCancelOrAll)
return
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
this.intSearchStart := intSelEnd
}
this.strSearchedText := Edit_GetTextRange(this.strEditorControlHwnd, this.intSearchStart, this.intFindReplaceEnd)
this.intFound := InStr(this.strSearchedText, this.strFindOrReplaceWhat, this.blnFindOrReplaceMatchCase)
this.intFoundEnd := this.intSearchStart + this.intFound + StrLen(this.strFindOrReplaceWhat) - 1
Edit_SetSel(this.strEditorControlHwnd, (this.intFound ? this.intSearchStart + this.intFound - 1 : this.intSearchStart), (this.intFound ? this.intFoundEnd : this.intSearchStart))
strSelText := Edit_GetSelText(this.strEditorControlHwnd)
if InStr(strSelText, "`r`n") or InStr(strSelText, "`t")
{
this.strSelectionBeforeInvisible := strSelText
strSelection := RegExReplace(strSelText, "`r`n", Chr(0x21B2) . "`r`n", &intNbEols)
strSelection := RegExReplace(strSelection, "`t", Chr(0x21E5) . "`t", &intNbTabs)
Edit_ReplaceSel(this.strEditorControlHwnd, strSelection)
this.intFoundEnd := this.intFoundEnd + intNbEols + intNbTabs
Edit_SetSel(this.strEditorControlHwnd, (this.intFound ? this.intSearchStart + this.intFound - 1 : this.intSearchStart), (this.intFound ? this.intFoundEnd : this.intSearchStart))
}
else
this.strSelectionBeforeInvisible := ""
return this.intFound
}
ExecFindReplaceAllToEnd()
{
Edit_SetSel(this.strEditorControlHwnd, this.intSearchStart, this.intFindReplaceEnd)
this.GetEditorText(true)
this.strEditTargetText := RegExReplace(this.strEditTargetText, (this.blnFindOrReplaceMatchCase ? "" : "i)") . "\Q" . this.strFindOrReplaceWhat . "\E", this.strFindOrReplaceWith)
this.SetEditorText(this.strEditTargetText)
Edit_SetSel(this.strEditorControlHwnd, this.intFindReplaceEnd, this.intFindReplaceEnd)
}
ExecSortOptions(strSortOptions)
{
this.strSortOptions := strSortOptions
this.ExecSortAgain()
}
ExecSortAgain()
{
this.GetEditorText(true)
strTempVar := this.strEditTargetText
if InStr(this.strSortOptions, "Length")
this.SortByLength()
else
{
strTempVar := Sort(strTempVar, this.strSortOptions)
this.strEditTargetText := strTempVar
}
this.SetEditorText(this.strEditTargetText)
}
SortByLength()
{
oLines := Object()
Loop Parse, this.strEditTargetText, "`n", "`r`n"
{
varLength := (this.strSortOptions = "LengthR" ? 999999999 - StrLen(A_LoopField) : StrLen(A_LoopField))
while StrLen(varLength) < 9
varLength := "0" . varLength
oLines["A" . varLength . A_LoopField] := A_LoopField
}
for intIndex, strLine in oLines
strResult .= strLine . "`n"
if SubStr(this.strEditTargetText, 1, StrLen(this.strEditTargetText)) <> "`n"
strResult := SubStr(strResult, 1, -1)
this.strEditTargetText := Convert2CrLf(strResult)
}
GetFromBeginText(strText, &blnFound)
{
blnFound := InStr(strText, this.strFromText)
return (blnFound ? InStr(strText, this.strFromText) + this.intFromPlusMinus : 1)
}
GetFromEndText(strText, &blnFound)
{
blnFound := InStr(strText, this.strFromText)
return (blnFound ? InStr(strText, this.strFromText) + StrLen(this.strFromText) + this.intFromPlusMinus : 1)
}
GetToBeginText(strText, &blnFound)
{
blnFound := InStr(strText, this.strSubStringToText)
return (blnFound ? InStr(strText, this.strSubStringToText) + this.intSubStringToPlusMinus - this.intStartingPos : StrLen(strText))
}
GetToEndText(strText, &blnFound)
{
blnFound := InStr(strText, this.strSubStringToText)
return (blnFound ? InStr(strText, this.strSubStringToText) + StrLen(this.strSubStringToText) + this.intSubStringToPlusMinus - this.intStartingPos : StrLen(strText))
}
SentenceCase()
{
Loop Parse, RegExReplace(this.strEditTargetText, "[\.\!\?]\S.Length+|\R+", "$0þ"), "þ"
{
strLower := StrLower(A_LoopField)
strUpper := Chr(Ord(A_LoopField))
strUpper := StrUpper(strUpper)
strSentence .= strUpper .  SubStr(strLower, 2)
}
return strSentence
}
ToggleCase()
{
Loop Parse, this.strEditTargetText
{
intAccentuatedLowerIndex := InStr(g_strAccentuatedLower, A_LoopField, true)
if (intAccentuatedLowerIndex)
strChar := SubStr(g_strAccentuatedUpper, (intAccentuatedLowerIndex)<1 ? (intAccentuatedLowerIndex)-1 : (intAccentuatedLowerIndex), 1)
else
{
intAccentuatedUpperIndex := InStr(g_strAccentuatedUpper, A_LoopField, true)
if (intAccentuatedUpperIndex)
strChar := SubStr(g_strAccentuatedLower, (intAccentuatedUpperIndex)<1 ? (intAccentuatedUpperIndex)-1 : (intAccentuatedUpperIndex), 1)
else
{
strChar := A_LoopField
if isUpper(strChar)
strChar := StrLower(strChar)
else if isLower(strChar)
strChar := StrUpper(strChar)
}
}
strToggledText .= strChar
}
return strToggledText
}
SaRcAsMCase()
{
Loop Parse, this.strEditTargetText
strSaRcAsM .= (Mod(A_Index, 2) ? Format("{1:U}", A_LoopField) : Format("{1:L}", A_LoopField))
return strSaRcAsM
}
ExecFileOpen(strFilePath, intFileOpenTo, intFileEncoding)
{
this.strFilePath := strFilePath
this.intFileOpenTo := intFileOpenTo
this.intFileEncoding := intFileEncoding
strEncodingPrev := A_FileEncoding
FileEncoding(this.GetFileEncodingCode(this.intFileEncoding))
strText := Fileread(this.strFilePath)
FileEncoding(strEncodingPrev)
if (ErrorLevel)
{
Oops("Editor", L(o_L["OopsErrorReadingFileToClipboard"], A_LastError, this.strFilePath))
return
}
if (this.intFileOpenTo >= 10)
{
WinClip.Clear()
WinClip.SetText(strText)
}
if (this.intFileOpenTo = 10)
or (this.intFileOpenTo = 11 and EditorUnsaved() and !DialogConfirmCancel())
{
this.SetEditorText("no update", true)
return
}
intReplaceOrInsert := Mod(this.intFileOpenTo, 10)
if (intReplaceOrInsert = 1)
{
Edit_SetText(g_strEditorControlHwnd, strText)
this.intSelStart := 0
this.intSelEnd := 0
}
else
{
Edit_GetSel(g_strEditorControlHwnd, intStartSelPos, intEndSelPos)
Edit_ReplaceSel(g_strEditorControlHwnd, strText)
this.intSelStart := (intStartSelPos = intEndSelPos ? intStartSelPos + StrLen(strText) : intStartSelPos)
this.intSelEnd := intStartSelPos + StrLen(strText)
}
if (this.intFileOpenTo = 11)
g_intHistoryPosition := 1
this.SetEditorText("no update", true)
}
ExecFileSave(strFilePath, intFileSaveEol, intFileEncoding, blnFileSaveSelected)
{
this.strFilePath := strFilePath
this.intFileSaveEol := intFileSaveEol
this.intFileEncoding := intFileEncoding
this.blnFileSaveSelected := blnFileSaveSelected
saEolFormatCodes := ["", "Unix", "Mac"]
if (this.blnFileSaveSelected)
{
strFullEditBk := Edit_GetText(g_strEditorControlHwnd)
Edit_SetText(g_strEditorControlHwnd, Edit_GetSelText(g_strEditorControlHwnd))
}
intResult := Edit_WriteFile(g_strEditorControlHwnd, this.strFilePath, this.GetFileEncodingCode(this.intFileEncoding), saEolFormatCodes[this.intFileSaveEol])
if (blnFileSaveSelected)
Edit_SetText(g_strEditorControlHwnd, strFullEditBk)
if (intResult < 0)
Oops("Editor", L(o_L["OopsErrorSavingFile"], A_LastError, this.strFilePath))
}
ExecFileClipboardBackup(strFilePath)
{
this.strFilePath := strFilePath
FileAppend(ClipboardAll(), this.strFilePath)
this.SetEditorText("no update", true)
}
ExecFileClipboardRestore(strFilePath)
{
this.strFilePath := strFilePath
A_Clipboard := Fileread("*c " . this.strFilePath, "c " . this.strFilePath)
this.SetEditorText("no update", true)
}
GetFileEncodingCode(intFileEncoding)
{
saEncodings := ["CP0", "UTF-8", "UTF-8-RAW", "UTF-16", "UTF-16-RAW", "CP" . o_Settings.Various.intFileEncodingCodePage.IniValue]
return saEncodings[intFileEncoding]
}
GetEditorText(blnReplaceSelection := false)
{
this.blnTextSelected := Edit_TextIsSelected(this.strEditorControlHwnd)
Edit_GetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
this.intSelStart := intSelStart
this.intSelEnd := intSelEnd
if (this.blnTextSelected and blnReplaceSelection)
{
this.strEditBeforeText := Edit_GetTextRange(this.strEditorControlHwnd, 0, intSelStart)
this.strEditTargetText := Edit_GetSelText(this.strEditorControlHwnd)
this.strEditAfterText := Edit_GetTextRange(this.strEditorControlHwnd, intSelEnd)
}
else
{
this.strEditBeforeText := ""
this.strEditTargetText := Edit_GetText(this.strEditorControlHwnd)
this.strEditAfterText := ""
}
}
SetEditorText(strEditTargetText, blnTextAlreadySet := false)
{
this.strEditTargetText := strEditTargetText
if (!blnTextAlreadySet)
Edit_SetText(this.strEditorControlHwnd, this.strEditBeforeText . this.strEditTargetText . this.strEditAfterText)
o_UndoPile.AddToPile()
EditorContentChanged()
g_aaEditCommandTypes[this.strCommandType].aaLastEditCommand := this
if (this.strCommandType = "ChangeCase")
{
intSelStart := this.intSelStart
intSelEnd := (this.blnTextSelected ? this.intSelEnd : this.intSelStart)
}
else if (this.strCommandType = "FileOpen")
{
intSelStart := this.intSelStart
intSelEnd := this.intSelEnd
}
else if (!InStr("|Find|FindReplace", "|" . this.strCommandType) or (this.strCommandType = "FindReplace" and this.blnFindOrReplaceRegEx))
{
intSelStart := (this.blnTextSelected ? this.intSelStart : 0)
intSelEnd := intSelStart
}
Edit_SetSel(this.strEditorControlHwnd, intSelStart, intSelEnd)
}
SaveCommand()
{
if !StrLen(this.strTitle) or !StrLen(this.strDetail)
return
AddToCommands(this)
}
}
class UndoPile
{
__New()
{
this.saUndoPile := Object()
}
CanUndo()
{
return ((this.saUndoPile.MaxIndex() - g_intUndoRedoOffset - 1) > 0) and !IsReadOnly()
}
CanRedo()
{
return (g_intUndoRedoOffset > 0) and !IsReadOnly()
}
AddToPile()
{
this.ShowPile("Add Begin - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
Critical("On")
strEditorText := Edit_GetText(g_strEditorControlHwnd)
Edit_GetSel(g_strEditorControlHwnd, intStartSelPos, intEndSelPos)
if (!this.saUndoPile.MaxIndex() and !StrLen(strEditorText))
{
this.ShowPile("Add Return - Pile and Editor empty - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
Critical("Off")
return
}
if (g_intUndoRedoOffset > 0)
{
if (this.saUndoPile[this.saUndoPile.MaxIndex() - g_intUndoRedoOffset].strText <> strEditorText)
{
this.saUndoPile.RemoveAt(this.saUndoPile.MaxIndex() - g_intUndoRedoOffset + 1, this.saUndoPile.MaxIndex())
g_intUndoRedoOffset := 0
this.ShowPile("Add Prune - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
}
else
{
this.ShowPile("Add Return - Undoing/Redoing - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
Critical("Off")
return
}
}
if (this.saUndoPile.MaxIndex() and this.saUndoPile[this.saUndoPile.MaxIndex()].strText == strEditorText)
{
this.ShowPile("Add Return - Identical - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
Critical("Off")
return
}
aaPileItem := Map("dteAdded", A_Now, "strText", strEditorText, "intStartSelPos", intStartSelPos, "intEndSelPos", intEndSelPos)
this.saUndoPile.Push(aaPileItem)
Critical("Off")
g_intUndoPileSize := 0
g_intUndoPileNb := 0
for int, oItem in this.saUndoPile
{
g_intUndoPileSize += StrLen(oItem.strText)
g_intUndoPileNb++
}
this.ShowPile("Add End - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
}
UndoFromPile()
{
this.ShowPile("Undo Begin - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
if (this.saUndoPile.MaxIndex() - g_intUndoRedoOffset <= 1)
{
this.ShowPile("Undo <= 1 - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
return
}
Critical("On")
strCurrentText := Edit_GetText(g_strEditorControlHwnd)
g_intUndoRedoOffset++
oRestoreItem := this.saUndoPile[this.saUndoPile.MaxIndex() - g_intUndoRedoOffset]
Edit_SetText(g_strEditorControlHwnd, oRestoreItem.strText)
Edit_SetSel(g_strEditorControlHwnd, oRestoreItem.intEndSelPos, oRestoreItem.intEndSelPos)
Edit_ScrollCaret(g_strEditorControlHwnd)
Critical("Off")
this.ShowPile("Undo End - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
}
RedoFromPile()
{
this.ShowPile("Redo Begin - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
if (g_intUndoRedoOffset < 1)
{
this.ShowPile("Redo Offset < 1 - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
return
}
Critical("On")
g_intUndoRedoOffset--
oRestoreItem := this.saUndoPile[this.saUndoPile.MaxIndex() - g_intUndoRedoOffset]
Edit_SetText(g_strEditorControlHwnd, oRestoreItem.strText)
Edit_SetSel(g_strEditorControlHwnd, oRestoreItem.intEndSelPos, oRestoreItem.intEndSelPos)
Edit_ScrollCaret(g_strEditorControlHwnd)
Critical("Off")
this.ShowPile("Redo End - MaxIndex: " . this.saUndoPile.MaxIndex() . " / Offset: " . g_intUndoRedoOffset)
}
ShowPile(str)
{
if !(o_Settings.Launch.blnDiagModeUndo.IniValue) or !WinActiveQCE()
return
Loop 5
{
intPos := this.saUndoPile.MaxIndex() - A_Index + 1
if (intPos > 0)
strPileText .=  intPos . ": " . SubStr(StrReplace(this.saUndoPile[intPos].strText, "`r`n", "%%"), 1, 100) . "`n"
}
intX := 800
if SubStr(str, 1, 3) = "Add"
{
intY := 800
intToolTip := 11
}
else if SubStr(str, 1, 4) = "Undo"
{
intY := 920
intToolTip := 12
}
else if SubStr(str, 1, 4) = "Redo"
{
intY := 1040
intToolTip := 13
}
CoordMode("ToolTip", "Screen")
ToolTip(str . " (" . g_intUndoPileSize // 1000 . " kb)`n" . strPileText, intX, intY, intToolTip)
}
}
global blnSkip### := false
global blnClipboard### := false
return
###_Log(strFunction, strStep)
{
strText := A_Now . "`t" . strFunction . "`t" . strStep . "`t" . ###_MemAvail() . "`n"
FileAppend(strText, "c:\temp\log.txt")
}
###_MemAvail()
{
MEMORYSTATUSEX := Buffer(64, 0), NumPut("UPtr", 64, MEMORYSTATUSEX) ; V1toV2: if 'MEMORYSTATUSEX' is a UTF-16 string, use 'VarSetStrCapacity(&MEMORYSTATUSEX, 64)'
DllCall("GlobalMemoryStatusEx", "ptr", MEMORYSTATUSEX)
return NumGet(MEMORYSTATUSEX, 16, "Int64")
}
###_T(strTitle, strMessage := "", blnPressAnyKey := false, intDurationSeconds := "2")
{
if (blnPressAnyKey)
{
TrayTip(strTitle, strMessage)
ihSingleKey := InputHook("L1","{LControl}{RControl}{LAlt}{RAlt}{LShift}{RShift}{LWin}{RWin}{AppsKey}{F1}{F2}{F3}{F4}{F5}{F6}{F7}{F8}{F9}{F10}{F11}{F12}{Left}{Right}{Up}{Down}{Home}{End}{PgUp}{PgDn}{Del}{Ins}{BS}{Capslock}{Numlock}{PrintScreen}{Pause}"), ihSingleKey.Start(), ihSingleKey.Wait(), SingleKey := ihSingleKey.Input
TrayTip()
}
else
TrayTip(strTitle, strMessage)
}
###_GUID()
{
; REMOVED: format := A_FormatInteger
; REMOVED: SetFormat Integer, hex[0]
VarSetStrCapacity(&A, 16) ; V1toV2: if 'A' is NOT a UTF-16 string, use 'A := Buffer(16)'
DllCall("rpcrt4\UuidCreate", "Str", A)
Address := &A
Loop 16
{
x := 256 + *Address
x := SubStr(x, (3)+1)
h := x . "" . h
Address++
}
; REMOVED: SetFormat Integer, %format%
Return h
}
###_ASCII()
{
s := "ASCII TABLE`n`n"
i := 33
Loop
{
s := S.Length . Chr(i) . " (" . i . ")"
if Mod(i, 8)
s := S.Length . " "
else
s := S.Length . "`n"
i := i + 1
if (i = 128)
{
i := 161
s := S.Length . "`n`n"
}
if (i > 255)
break
}
return S.Length
}
###_D(str, blnSkipRevert := 0, blnClipboardRevert := 0)
{
if (blnClipboardRevert)
{
blnClipboard### := !blnClipboard###
if (blnClipboard###)
A_Clipboard := ""
}
if (blnSkipRevert)
blnSkip### := !blnSkip###
if ((blnSkipRevert or blnClipboardRevert) and !StrLen(str))
return
if (blnClipboard###)
A_Clipboard .= str . "`n"
if (blnSkip###)
return
intOption := 6 + 512
SetTimer(###_ChangeButtonNames,50)
msgResult := MsgBox(intOption, ###_D(ébug), %str%)
if (msgResult = "TryAgain")
ExitApp()
else if (msgResult = "Cancel")
blnSkip### := true
else
return
}
###_V(str, objVariables*)
{
if IsObject(objVariables[objVariables.MaxIndex() - 2])
{
obj := objVariables[objVariables.MaxIndex() - 2]
prop := objVariables[objVariables.MaxIndex() - 1]
prop2 := objVariables[objVariables.MaxIndex()]
objVariables.RemoveAt(objVariables.MaxIndex() - 2, 3)
}
else if IsObject(objVariables[objVariables.MaxIndex() - 1])
{
obj := objVariables[objVariables.MaxIndex() - 1]
prop := objVariables[objVariables.MaxIndex()]
objVariables.RemoveAt(objVariables.MaxIndex() - 1, 2)
}
else if IsObject(objVariables[objVariables.MaxIndex()])
{
obj := objVariables[objVariables.MaxIndex()]
objVariables.RemoveAt(objVariables.MaxIndex())
}
str .= BuildStringVariables(objVariables*)
if IsObject(obj)
str .= BuildStringObj(obj, prop, prop2)
if (blnClipboard###)
A_Clipboard .= "`n" . str . "`n"
if (blnSkip###)
return
intOption := 6 + 512
SetTimer(###_ChangeButtonNames,50)
msgResult := MsgBox(intOption, ###_V(ariables*), %str%)
if (msgResult = "TryAgain")
ExitApp()
else if (msgResult = "Cancel")
blnSkip### := true
else
return
}
###_Out(objVariables*)
{
for intIndex, strVar in objVariables
str .= strVar . (intIndex = objVariables.MaxIndex() ? "" : "`t")
###_Output(str, False)
}
BuildStringVariables(objVariables*)
{
str := "`n`n"
intIndex := 1
Loop
{
if SubStr(objVariables[intIndex], 1, 1) = "*"
{
str .= SubStr(objVariables[intIndex], 2) . " = " . objVariables[intIndex + 1] . "`n"
intIndex++
}
else
str .= intIndex . " = " . objVariables[intIndex] . "`n"
intIndex++
if (intIndex > objVariables.MaxIndex())
break
}
return str
}
###_O(str, obj, prop := "", prop2 := "")
{
str .= BuildStringObj(obj, prop, prop2)
if (blnClipboard###)
A_Clipboard .= "`n" . str . "`n"
if (blnSkip###)
return
intOption := 6 + 512
SetTimer(###_ChangeButtonNames,50)
msgResult := MsgBox(intOption, ###_O(bject), %str%)
if (msgResult = "TryAgain")
ExitApp()
else if (msgResult = "Cancel")
blnSkip### := true
else
return
}
###_O2(str, obj1, obj2, prop := "", prop2 := "")
{
str .= "`n`n--" . "`n`n" . BuildStringObj(obj1, prop, prop2) . "--" . "`n`n" . BuildStringObj(obj2, prop, prop2)
if (blnClipboard###)
A_Clipboard .= "`n" . str . "`n"
if (blnSkip###)
return
intOption := 6 + 512
SetTimer(###_ChangeButtonNames,50)
msgResult := MsgBox(intOption, ###_O(bject), %str%)
if (msgResult = "TryAgain")
ExitApp()
else if (msgResult = "Cancel")
blnSkip### := true
else
return
}
###_O2Stack(str, stack1, stack2)
{
str .= "`n`n--" . "`n`nPREV" . BuildStringObj(stack1, "AA", "strMenuPath") . "--" . "`n`nNEXT" . BuildStringObj(stack2, "AA", "strMenuPath")
if (blnClipboard###)
A_Clipboard .= "`n" . str . "`n"
if (blnSkip###)
return
intOption := 6 + 512
SetTimer(###_ChangeButtonNames,50)
msgResult := MsgBox(intOption, ###_O(bject), %str%)
if (msgResult = "TryAgain")
ExitApp()
else if (msgResult = "Cancel")
blnSkip### := true
else
return
}
BuildStringObj(obj, prop := "", prop2 := "")
{
str := "`n`n"
for strKey, strValue in obj
{
if (IsObject(strValue) and prop = "")
str .= strKey . " = " . strValue[1] . "|" . strValue[2] . "`n"
else
if StrLen(prop2) and StrLen(strValue[prop][prop2])
str .= strKey . " = " . strValue[prop][prop2] . "`n"
else if StrLen(prop) and StrLen(strValue[prop])
str .= strKey . " = " . strValue[prop] . "`n"
else
str .= strKey . " = " . strValue . "`n"
}
return str
}
###_ChangeButtonNames()
{ ; V1toV2: Added bracket
if !WinExist("###_")
return
SetTimer(###_ChangeButtonNames,0)
WinActivate()
ControlSetText("Continue", "Button1")
ControlSetText("Exit App", "Button2")
ControlSetText("Next", "Button3")
return
###_Output(str, blnClear := True, blnLineBreak := True, blnExit := False)
{
SciObj := ComObjActive("SciTE4AHK.Application")
if (blnClear)
ErrorLevel := SendMessage(SciObj.Message(0x111, 420))
if (blnLineBreak)
str := "`r`n" . str
SciObj.Output(str)
if (blnExit)
{
msgResult := MsgBox("Exit Application?", "Exit App?", 36)
if (msgResult = "Yes")
ExitApp()
}
}
















































































































































































































































































































































































































































} ; Added bracket in the end
