/************************************************************************
 * @description 
 * @file AHK Script.v2.ahk
 * @author 
 * @date 2023/12/28
 * @version 0.0.0
 ***********************************************************************/

#Requires AutoHotkey v2+
#Include <Directives\__AE.v2>
; ---------------------------------------------------------------------------
; @i...: Create ahk_group ExplorerDesktopGroup
; ---------------------------------------------------------------------------
GroupAdd("ExplorerDesktopGroup", "ahk_class ExploreWClass")
GroupAdd("ExplorerDesktopGroup", "ahk_class CabinetWClass")
GroupAdd("ExplorerDesktopGroup", "ahk_class Progman")
GroupAdd("ExplorerDesktopGroup", "ahk_class WorkerW")
GroupAdd("ExplorerDesktopGroup", "ahk_class #32770")
; --------------------------------------------------------------------------------
; --------------------------------------------------------------------------------
TraySetIcon("shell32.dll","16", true) ; this changes the icon into a little laptop thing.
pMakeTrayMenu()
; --------------------------------------------------------------------------------
#Include <Includes\Includes_Standard>
; --------------------------------------------------------------------------------
#Include <Common\Common_Include>
#Include <Tools\explorerGetPath.v2>
; --------------------------------------------------------------------------------
; #Include <Includes\Includes_App> ;! Brackets
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
SetNumLockState("AlwaysOn")
SetCapsLockState("AlwaysOff")
SetScrollLockState("AlwaysOff")
; --------------------------------------------------------------------------------
#HotIf WinActive("Chrome River - Google Chrome",)
*^s::SaveCR()
; ---------------------------------------------------------------------------
SaveCR(){
	expRpt := UIA.ElementFromChromium('Chrome River - Google Chrome')
	; Sleep(100)
	expRpt.WaitElement({Type: '50000 (Button)',	Name: "Save", LocalizedType: "button", AutomationId: "save-btn"}, 10000).Highlight(100).Invoke()
}

#HotIf

#HotIf WinActive('ahk_exe Excel.exe')

^#c::CenterAcrossSelection()
CenterAcrossSelection(){
	AE.SM(&sm)
	AE.DH(1)
	Send('^1a')
	Send('!hcc{Enter 2}')
	AE.rSM(sm)
}
^#m::MoveOrCopy()
MoveOrCopy(){
	AE.SM(&sm)
	AE.DH(1)
	Send('{LButton}{RButton}m')
	Send('{End}!c')
	Send('{Enter}')
	Sleep(100)
	Send('{LButton}{RButton}r')
	; Send('!hcc{Enter 2}')
	AE.rSM(sm)
}

#HotIf

^+t::
^+l::
^+u::ChangeCase()

ChangeCase(i := SubStr(A_ThisHotkey, -1, 1)){
	text := t := ''
	AE.SM(&sm)
	AE.cBakClr(&cBak)
	Send('^{sc2E}')
	AE.cSleep(100)
	t := A_Clipboard
	AE.cSleep(100)
	switch {
		case (i = 'u'): text := StrUpper(t)
		case (i = 'l'): text := StrLower(t)
		case (i = 't'): text := StrTitle(t)
	}
	ClipSend(text)
	AE.cRestore(cBak)
}
; ---------------------------------------------------------------------------
~n::ShiftRight()
ShiftRight() => (AE.SM(&sm), A_PriorKey = '``' ? Send('{Right}') : 0, AE.rSM(sm))
; ShiftRight(){
; 	AE.SM(&sm)
; 	A_PriorKey = '``' ? Send('{Right}') : 0
; 	AE.rSM(sm)
; }

; #HotIf WinActive('ahk_exe Chrome.exe')
#HotIf WinActive("Chrome River - Google Chrome",)
Esc::bClose()
bClose(){
	expRpt := UIA.ElementFromChromium(' - Google Chrome')
	; Sleep(100)
	expRpt.WaitElement({Type: '50000 (Button)', Name: "", LocalizedType: "button"}, 10000).Highlight(100).Invoke()
}
!c::bContinue()
bContinue(){
	expRpt := UIA.ElementFromChromium(' - Google Chrome')
	; Sleep(100)
	expRpt.WaitElement({Type: '50000 (Button)', Name: "Continue", LocalizedType: "button"}, 10000).Highlight(100).Invoke()
}
!n::bNext()
bNext(){
	expRpt := UIA.ElementFromChromium(' - Google Chrome')
	; Sleep(100)
	expRpt.WaitElement({Type: '50000 (Button)',
						Name: "Next",
						LocalizedType: "button",
						; AutomationId: "next-btn"
					}, 10000).Highlight(100).Invoke()
}
^!n::bNextTopic()
bNextTopic(){
	expRpt := UIA.ElementFromChromium(' - Google Chrome')
	; Sleep(100)
	expRpt.WaitElement({Type: '50000 (Button)',
						Name: "Next Topic",
						LocalizedType: "button",
						; AutomationId: "next-btn"
					}, 10000).Highlight(100).Invoke()
}
#HotIf

#HotIf WinActive("ahk_exe hznHorizon.exe")

; ^+Down::
; {
; 	bak := ClipboardAll()
; 	d:=0, A_Clipboard := '', d := 15, text := '', aText := []
; 	; if A_Clipboard != '' {
; 	; 	loop {
; 	; 		Sleep(d)
; 	; 	} until A_Clipboard := ''
; 	; }
; 	cutline()
; 	cutline()
; 	cutline() {
; 		Send('{End}{Shift Down}{Home}{Down}{Shift Up}')
; 		Send('^x')
; 		text := A_Clipboard
; 		Sleep(d)
; 		aText.Push(text)
; 		Send('{Home}{Shift Down}{End}{Down}{Shift Up}')
; 		Send('{Del}')
; 		return aText
; 	}
; 	Send(aText[2])
; 	Send(aText[1])
; 	; Infos(atext[1] '`n' aText[2])
; 	return
; 	text := ''
; 	loop text.Length {
; 		Sleep(d)
; 	} until text = ''
; 	text .= (aText[2] '`n' aText[1])
; 	loop text.Length {
; 		Sleep(d)
; 	} until text != ''
; 	; Send('^x')
; 	; Sleep(d)
; 	Send('{Del 2}')
; 	Sleep(d)
; 	send('{End}')
; 	Sleep(d)
; 	Send('{Enter}')
; 	Sleep(d)
; 	send('^v')
; 	Sleep(100)
; 	A_Clipboard := bak
; }
; ^+Up::
; {
; 	bak := ClipboardAll()
; 	d:=0, A_Clipboard := '', d := 15, text := ''
; 	Send('{Home}+{End}')
; 	Sleep(d)
; 	Send('^x')
; 	Sleep(d)
; 	Send('{Del}')
; 	Sleep(d)
; 	send('{Home}{Up}')
; 	Sleep(d)
; 	Send('{Enter}')
; 	Sleep(d)
; 	send('^v')
; 	Sleep(100)
; 	A_Clipboard := bak
; }
#HotIf !WinActive(' - Visual Studio Code')
!d::{
    AE.cBakClr(&cBak)
    AE.SM_BISL(&sm)
    m := []
	text := '', txt := ''
	Send('{Home}+{End}')
	; @step: Copy
	Send(key.copy) ; ^c
	AE.cSleep(50)
	text := A_Clipboard
	AE.cSleep(50)
    RegExMatch(text, 'im)\w\.\s(.*)', &m)
    n := text.length
    (m.Len != 0) ? text := m[] : 0
    ; ClipSend(text '`n' text)
    Send(text '`n' text)
    Send('+{Left ' (n + (n+1)) '}')
    AE.rSM_BISL(sm)
    AE.cRestore(cBak)
}
#HotIf
;! ---------------------------------------------------------------------------
;! ---------------------------------------------------------------------------
;! ---------------------------------------------------------------------------

which_brackets(str, lChar, rChar, MapObj) {
	bkts := []
	for k, v in MapObj {
		If (str ~= '\' k){
			lChar := k, rChar := v
		}
	}
	bkts.SafePush(lChar)
	bkts.SafePush(rChar)
	; Infos([brackets]`n' 'str: ' bkts.str := str '`n' 'lChar: ' bkts.lChar := lChar '`n' 'rChar: ' bkts.rChar := rChar)
	return (bkts, {lChar:lChar, rChar:rChar})
}
; split_text(text) => (stext := [], stext := StrSplit(text))
; ; ---------------------------------------------------------------------------
; do_brackets_exist(text, lChar, rChar) => ((lChar.length > 0) ? (((text ~= ('\' lChar) || (('\' lChar) && ('\' rChar)))) ? true : false) : false)
; ; ---------------------------------------------------------------------------
; brackets_at_ends(text, lChar, rChar){
; 	stext := '', stext := split_text(text), ltext := stext.Length
; 	; ---------------------------------------------------------------------------
; 	(bL := (stext[1] ~= '\' lChar) 		? true : false)
; 	(bR := (stext[ltext] ~= '\' rChar) 	? true : false)
; 	; ---------------------------------------------------------------------------
; 	(bL = 1 ? 'true' : 'false'), (bR = 1 ? 'true' : 'false')
; 	; ---------------------------------------------------------------------------
; 	; Infos('true: ' true '`n' 'false: ' false '`n' 'bL: ' bL ' : ' stext[1] '`n' 'bR: ' bR ' : ' stext[ltext])
; 	return ((bL || bR = true) ? true : false)
; }
; ---------------------------------------------------------------------------
; ---------------------------------------------------------------------------
#HotIf !WinActive(" - Visual Studio Code") && WinActive('ahk_exe hznHorizon.exe')
; ---------------------------------------------------------------------------
; @Section ...: 		Mirror the VS Code hotkeys for the below params
; @i ...: 	By using the * => the key is intercepted and not sent to the window/control
; @i ...: Params:
; @param .:	1. ''
; @param .:	2. ""
; @param .:	3. ()
; @param .:	4. {}
; @param .:	5. []
; ---------------------------------------------------------------------------
:*?:dotf::{U+2219}
:X*?:greqf::chr(242) ;{U+2265}
:X*?:...::chr(133) ;{U+2265}
; :X*?:xf::chr(155) ;{U+2265}
; :*?:of::[O] ;{U+2265}

; *<::
; *'::
; *"::
; *(::
; *{::
; *[::
{
	; CoordMode('Caret','Window')
	AE.SM(&sm)
	AE.cBakClr(&cBak)

	; t1 := '', t2 := '', t3 := '', t4 := '', t5 := '', t6 := '', t7 := '',
	; c1 := '', c2 := '', c3 := '', c4 := '', c5 := '', c6 := '', c7 := ''
	bLeft := '', bRight := '', lChar := '', rChar := '', bL := '', bR := ''
	; s := '', c := '',
	bK := '', bV := '',
	eK := '', eV := '', 
	x  := 0, y  := 0,	xC := 0, yC := 0, w := 0, p := ''
	control  := fCtl := WinA := ClassNN := ''
	Selected := ''
	bChar := '', bChars := '', bV1 := '', bV2 := '', b1 := '', b2 := ''
	eChar := '', eChars := '', eV1 := '', eV2 := '', e1 := '', e2 := ''
	cLen := 0, sLen := 0
	text := '', endChars := '', s := 0, LP := 0, Len := 0, sel := ''
	; toggle := 0
	; ---------------------------------------------------------------------------
	mbH := [], bkts := [], eChr := [], bChr := [], mbChr := [], meChr := []
	; ---------------------------------------------------------------------------
	eMap := Map('"','"', "'", "'", '[', ']', '{', '}', '(', ')')
	; ---------------------------------------------------------------------------
	; @step ...: Try and get the focused control, caret and mouse positions
	; @step ...: Try and get caret position
	; @step ...: Try and get mouse position (includes window handle, and control handle)
	; ---------------------------------------------------------------------------
	try if WinActive('ahk_exe hznHorizon.exe'){
		fCtl := ControlGetFocus('A'), ClassNN := ControlGetClassNN(fCtl), hWnd := tryHwnd()
	}
	; ---------------------------------------------------------------------------
	; @step: get the key pressed, removing the hotkey modifier, and trim whitespaces
	; ---------------------------------------------------------------------------
	; str := A_ThisHotkey
	; str.RegExMatch('[\[\]\(\)\{\}\-\`'\`"\<\>]', &mbH)
	str := RegExReplace(A_ThisHotkey, '\*', '')
	; str := StrSplit(A_ThisHotkey,'*', '*', 1), str := Trim(str[1])
	; ---------------------------------------------------------------------------
	; @info ...: brackets identified => b := Array() 
	; ---------------------------------------------------------------------------
	(str = '[') ? (bLeft := str, bRight := ']') : (str = '{') ? (bLeft := str, bRight := '}') : (str = '(') ? (bLeft := str, bRight := ')') : (str = '<') ? (bLeft := str, bRight := '>') : (str = '"') ? (bLeft := str, bRight := '"') : (str = "'") ? (bLeft := str, bRight := "'") : 0
	
	; bkts := which_brackets(str, lChar,rChar, eMap)
	; static bLeft := mbH[], bRight := eMap.Get(mbh[])
	; ---------------------------------------------------------------------------
	; bLeft := bkts.lChar, bRight := bkts.rChar
	bL := '\' bLeft, bR := '\' bRight
	; ---------------------------------------------------------------------------
	; @step: Copy the selected text into the clipboard for evaluation
	; ---------------------------------------------------------------------------
	getSel := AE_GetSel()
	stats := AE_GetStats(fCtl) ;! why does this give me a -1 for line position, but the below doesn't?
	LP := stats.LinePos
	; Len := stats.selL
	; sel := stats.sel
	; sel := RegExReplace(sel, '(\s)+$', '')
	; Len := sel.Length
	; Infos('sel: "' sel '"`nLen: ' Len ) ;! Add len to replace getSel.E???
	; Infos('LP: ' LP)
	; ToolTip(stats.LinePos)
	((getSel.S - getSel.E) = 0) ? pasteit(text, bLeft, bRight, getSel.S, getSel.E, LP) : copyit(LP)
	copyit(LP:=0){
		AE.BISL(1,,&sl)
		AE.SM(&sm)
		; ---------------------------------------------------------------------------
		; @step: store the clipboard into the variable text, see if text is empty
		; @info: don't technically need to do that to see if the text is empty
		; @info: however, two birds with one stone => set text variable
		; ---------------------------------------------------------------------------
		Send('{sc1D down}{sc2E}{sc1D up}') ; Send('^c')RCtrl := sc11D
		sleep(30)
		; ---------------------------------------------------------------------------
		text := A_Clipboard
		sleep(30)
		getSel := AE_GetSel()
		getCL := AE_GetCaretLine()
		pasteit(text, bLeft, bRight, getSel.S, getSel.E, LP)
		AE.rBISL(sl)
		AE.rSM(sm)
	}
	pasteit(text, bLeft, bRight, sPos?, ePos?, LP:=0, *){
		; Infos(LP)
		AE.BISL(1,,&sl)
		AE.SM(&sm)
		AE.cBakClr(&cBak)
		mS := [], count := 0
		; eRegex := 'm)([\s:,.]+)$'
		eRegex := 'm)((\v)|(\s+$|[:,.]+)$)'
		RegExMatch(text, eRegex, &mS)
		; Infos(mS[])
		try s := mS.Count
		if !IsObject(mS.Count) && (s > 0) {
			; Infos('Not an object, or, there are endchars')
			; endChars := mS[]
			endChars := mS[]
			text := RegExReplace(text, eRegex, '')
		}
		try {
			If (text.length == 0) {
				; ToolTip('If')
				(LP == -1) ? (text := bLeft text bRight endChars '`n') : (text := bLeft text bRight endChars)
				; if (eRtn == -1){
				; 	text := bLeft text bRight endChars '`n'
				; }
				; text := bLeft text bRight endChars
				; sleep(30)
				A_Clipboard := text
				Sleep(50)
				Send('{sc1D down}{sc2F}{sc1D up}')
				sleep(50)
				Send('{sc14B}')
				; _AE_RestoreClip(cBak)
				; _AE_bInpt_sLvl(0)
			}
			else if ((text ~= '\' str )) { ;(text ~= bRegExNdl) {
				text := RegExReplace(text, '\' bLeft, '') ;* works
				text := RegExReplace(text, '\' bRight, '') ;* works
				A_Clipboard := text
				Sleep(50)
				Send('{sc1D down}{sc2F}{sc1D up}')
				Sleep(50)
				; AE_Set_Sel((getSel.S), (getSel.E)-1, fCtl)
				; _AE_RestoreClip(cBak)
				; _AE_bInpt_sLvl(0)
			} 
			else {
				; ToolTip('Else' '`n' 'T: ' true ' False: ' false '`n' (LP == -1))
				(LP == -1) ? (text := bLeft text bRight endChars '`n') : (text := bLeft text bRight endChars)
				A_Clipboard := text
				Sleep(50)
				Send('{sc1D down}{sc2F}{sc1D up}')
				Sleep(50)
				; AE_Set_Sel((getSel.S), ((getSel.E)-2), fCtl)
				; _AE_RestoreClip(cBak)
				; _AE_bInpt_sLvl(0)
			}
			AE.cRestore(cBak)
			AE.rBISL(sl)
			AE.rSM(sm)
		}
		; Infos(A_PriorKey, 5000)
		return
	}
	return
	; ---------------------------------------------------------------------------
	; @step ...: Set cLen (clipboard length, or initial cLen length)
	; @step ...: Set sLen (string length, or initial sLen length)
	; @why  ...: Used to select the whole word or sentance for toggling backets.
	; ---------------------------------------------------------------------------
	cLen := text.length
	; ---------------------------------------------------------------------------
	t2 := text, c3 := t2.length
	;! ---------------------------------------------------------------------------
	; @step ...: get stats from text
	; @why  ...: Can be used to determine the location of the text (line, total lines, etc.)
	;! ---------------------------------------------------------------------------
	; try stats := AE_GetStats()
	; stats := AE_GetStats(fCtl, hWnd)
	; ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	; @step ...: Remove non-word end chars
	; @why  ...: Can be used to determine the location of the text (line, total lines, etc.)
	;! ---------------------------------------------------------------------------
	e1 := eChars
	; ---------------------------------------------------------------------------
	; eChrNeedle := '[,.?:;\s]+$'
	eChrNeedle := '(?:\b)[.\W]+$'
	; eChrReplace := '$1'
	eChrReplace := ''
	; ---------------------------------------------------------------------------
	; todo ---------------------------------------------------------------------------
	; (text ~= eChrNeedle) ? (text.RegExMatch(eChrNeedle, &meChr), SafePushArray(eChr, meChr), eChars := eChr.ToString('')) : 1
	if (text ~= eChrNeedle) {
		; RegExMatch(text, eChrNeedle, &meChr)
		text.RegExMatch(eChrNeedle, &meChr)
		SafePushArray(eChr, meChr)
		eChars := eChr.ToString('')
		; text := RegExReplace(text, eChrNeedle,eChrReplace)
		text.RegExReplace(eChrNeedle, eChrReplace) ; todo => this seems to fail to properly "replace" (remove)
		; text.Replace(eChrNeedle,eChrReplace)
	}
	;* seems faster
	; todo ---------------------------------------------------------------------------
	; ---------------------------------------------------------------------------
	t3 := text, c4 := t3.length
	; ---------------------------------------------------------------------------
	; @step ...: Is there a dash, dash space, or space (or combo of) at the beginning?
	; @step ...: If so, remove it/them and store it in bChars 
	; @step ...: Is there a space, comma, question mark, semi-colon, colon, (?more?) (or combo of) at the end?
	; //@step ...: If so, remove it and store it in s (s := ' ', or s := A_Space)
	; @step ...: If so, remove it/them and store it in eChars 
	; @why  ...: If its a single word on the line, no need to re-add ; fix [identify if it's a single word on the line]
	; @why  ...: If it's part of a sentance, need to add it back at the end
	; ---------------------------------------------------------------------------
	bChrNeedle := '^[\d.)\s:-]+(?:\b)'
	; bChrNeedle := '^[\d\W.\s):-]+\b'
	; bChrReplace := '$1'
	bChrReplace := ''
	; ---------------------------------------------------------------------------
	b1 := bChars
	; todo ---------------------------------------------------------------------------
	(text ~= bChrNeedle) ? (text.RegExMatch(bChrNeedle,&mbChr), SafePushArray(bChr, mbChr), bChars := bChr.ToString('')) : 0
	; if (text ~= bChrNeedle) {
		; text := RegExMatch(text, bChrNeedle,&mbChr)
		; SafePushArray(bChr, mbChr
		; bChars := bChr.ToString(''))
		; text := RegExReplace(text, bChrNeedle,bChrReplace)
		; text.RegExReplace(bChrNeedle,bChrReplace)
	; }
	;* seems faster
	; todo ---------------------------------------------------------------------------
	;! ---------------------------------------------------------------------------
	; testtext := "()
	; (
	; - The visit was made to conduct a Boiler and Machinery Remote Special evaluation.
	; 1. The thing is

	; 1) This is what I was thinking

	; 1 - This is the other thing I was thinking

	; )"

	; cp := [], bcp := [], cpt := ''

	;! ---------------------------------------------------------------------------
	b2 := bChars
	t4 := text, c5 := t4.length
	; ---------------------------------------------------------------------------
	e2 := eChars
	t5 := text, c6 := t5.length
	; ---------------------------------------------------------------------------
	; @step if text.length != 0 => do brackets exist? If so, remove them, if not, add them
	; ---------------------------------------------------------------------------
	bK := bLeft, bV := bRight
	beC := '[\[\]\(\)\{\}\-\`'\`"\<\>]+'
	; bktPattern := "\Q" bK "\E([^" bV "]+)\Q" bV "\E"
	bktPattern := beC
	bktRplc := '$1'
	; ---------------------------------------------------------------------------
	; Infos(text.RegExReplace(bktPattern, bktRplc)) ; todo ...: finish this up 
	if (text ~= bktPattern) {
		text.RegExReplace(bktPattern,bktRplc)
	}
	; ---------------------------------------------------------------------------
	else {
		(text := bK text bV )
	}
	; ---------------------------------------------------------------------------
	Infos(
		't3: ' t3
		'`n'
		't4: ' t4
		'`n'
		't5: ' t5
		'`n'
		'bChars: ' bChars
		'`n'
		'eChars: ' eChars
		'`n'
		text
	)
	; ---------------------------------------------------------------------------
	; @step Add the bChars and eChars back to the text
	; ---------------------------------------------------------------------------
	text := bChars text eChars ; todo ...: finish this up using String2 class
	; ---------------------------------------------------------------------------
	A_Clipboard := text
	t6 := A_Clipboard, c7 := t6.length
	WinActive('ahk_exe hznHorizon.exe') ? SndMsgPaste() : SendEvent('^v')

	if (text.length = 2) {
		Send('{Left}')
	}
	; Infos(
		; text
	; 	'c1[' c1 ']' 
	; 	'`n'
	; 	'c2[' c2 ']' ' t1: ' t1
	; 	'`n'
	; 	'c3[' c3 ']' ' t2: ' t2
	; 	'`n'
	; 	'c4[' c4 ']' ' t3: ' t3
	; 	'`n'
	; 	'b1[' b1 ']'
	; 	'`n'
	; 	'b2[' b2 ']'
	; 	'`n'
	; 	'e1[' e1 ']'
	; 	'`n'
	; 	'e2[' e2 ']'
	; 	'`n'
	; 	'c5[' c5 ']' ' t4: ' t4
	; 	'`n'
	; 	'c6[' c6 ']' ' t5: ' t5
	; 	'`n'
	; 	'c7[' c7 ']' ' t6: ' t6
	; 	'`n'
	; 	't7: ' t7
	; 	; 'RegEx:'
	; 	; '`n'
	; 	; cpt
	; 	; '`n'
	; 	; 'Control: ' ClassNN := ControlGetClassNN(control) '(' control ')'
	; )
	; Sleep(100)
	; try Send('^v')
	; A_Clipboard := text
	; Send('^v')
	; stats1 := AE_GetStats()
	; getSel1 := AE_GetSel(fCtl, hWnd := tryHwnd())
	; Infos('Start: ' getsel.S '`nEnd: ' getSel1.E)
	; AE_Set_Sel(getsel.S, getsel1.E)
	; ---------------------------------------------------------------------------
	; AE_HideSelection(true)
	AE.BISL(1,,&sl)
	; Run(A_ScriptName)
}
; :*:`  ::{bs 1}{right}{Space} ;? testing purposes only
#HotIf
#HotIf !WinActive('ahk_exe hznHorizon.exe')
GroupAdd('NotHznPaste', 'ahk_exe Code.exe')
GroupAdd('NotHznPaste', 'ahk_exe WINWORD.exe')
GroupAdd('NotHznPaste', 'ahk_exe Teams.exe')
^!v::AE.smPaste

#HotIf
; --------------------------------------------------------------------------------
; :B0*:;---:: {
; 	; cBak := _AE_BU_Clr_Clip()
; 	_AE_bInpt_sLvl(1)
; 	Send('+{Left 4}')
; 	t := '; ---------------------------------------------------------------------------'
; 	ClipSend(t)
; 	; A_Clipboard := t
; 	; Sleep(30)
; 	; Send('^{sc2F}')
; 	; Sleep(30)
; 	; Send('{enter}')
; 	_AE_bInpt_sLvl(0)
; 	; _AE_RestoreClip(cBak)
; }
:B0*:;---:: {
	Sleep(100)
	Send('+{Home}')
	Sleep(100)
	t := '; ---------------------------------------------------------------------------'
	ClipSend(t)
}
#HotIf WinActive(" - Visual Studio Code")

; --------------------------------------------------------------------------------
:?C1B0*:{Ins::
{
	AE.cBakClr(&cBak)
	AE.BISL(1)
	t := 'ert'
	A_Clipboard := t
	Sleep(30)
	Send('^{sc2F}')
	Send('{Esc}')
	Sleep(50)
	Send('{Right}')
	AE.BISL(0)
	AE.cRestore(cBak)
}
:?C1B0*:{Ent::
{
	AE.cBakClr(&cBak)
	AE.BISL(1)
	t := 'er'
	A_Clipboard := t
	Sleep(30)
	Send('^{sc2F}')
	Send('{Esc}')
	Sleep(50)
	Send('{Right}')
	AE.BISL(0)
	AE.cRestore(cBak)
}

; :C1B0*:cBak ::
; {
; 	AE.cBakClr(&cBak)
; 	AE.BISL(1)
; 	Send('^+{Left}')
; 	t := 'cBak := _AE_BU_Clr_Clip()`n_AE_bInpt_sLvl(1)`n`n_AE_bInpt_sLvl(0)`n_AE_RestoreClip(cBak)'
; 	t := '
; 	(
; 		cBak := _AE_BU_Clr_Clip()
; 		_AE_bInpt_sLvl(1)
; 		t := 
; 		A_Clipboard := t
; 		Sleep(30)

; 		Send('^{sc2F}')
; 		Send('{Esc}')
; 		Sleep(50)
; 		Send('{Right}')
; 		_AE_bInpt_sLvl(0)
; 		_AE_RestoreClip(cBak)
; 	)'
; 	A_Clipboard := t
; 	Sleep(50)
; 	Send('^{sc2F}')
; 	Sleep(50)
; 	Send('{Home}')
; 	KeyWait('LControl', 'T3')
; 	AE.BISL(0)
; 	AE.cRestore(cBak)
; }


; :*:sleep::
; {
; 	cBak := ClipboardAll()
; 	_AE_bInpt_sLvl(1)
; 	A_Clipboard := ''
; 	Send('^+{Left}')
; 	Sleep(100)
; 	A_Clipboard := 'Sleep(100)'
; 	sleep(100)
; 	Send('^v')
; 	Sleep(30)
; 	Send('{Left}')
; 	Send('+{Left 3}')
; 	Sleep(1000)
; 	A_Clipboard := cBak
; 	_AE_bInpt_sLvl(0)
; }

:*B0C1:sleep::{
	AE.SM(&sm)
	; Sleep(50)
	Send('(100')
	; Sleep(50)
	; ClipSend(100)
	; Sleep(50)
	Send('^+{Left}')
	; Sleep(50)
	AE.rSM(sm)
	return
	; KeyWait('Right', 'D T5') ? 0 :
	; Send('{Right}')
}

#HotIf
; --------------------------------------------------------------------------------
; #HotIf WinActive(A_ScriptName)
#c::CenterWindow(WinActive('A'))

CenterWindow(wA := 0) {
    hwnd := WinExist(wA)
    WinGetPos( ,, &W, &H, hwnd)
    mon := GetNearestMonitorInfo(hwnd)
    WinMove(mon.WALeft + mon.WAWidth // 2 - W // 2, mon.WATop + mon.WAHeight // 2 - H // 2,,, hwnd)
}
; --------------------------------------------------------------------------------
; Section .....: Functions
; Function ....: Run scripts selection from the Script Tray Icon
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
; ^+#1::
GUIFE(*){
	Run("GUI_FE.ahk")
}
; list

; ^+#3::
WindowProbe(*){
	Run("WindowProbe.ahk", "C:\Users\bacona\OneDrive - FM Global\3. AHK\")
}
; ^+#4::
GUI_ListofFiles(*){
	Run("GUI_ListofFiles.ahk")
}
; ^+#5::
{
Windows_Data_Types_offline(*){
	Run("Windows_Data_Types_offline.ahk", "C:\Users\bacona\OneDrive - FM Global\3. AHK\AutoHotkey_MSDN_Types-master\src\v1.1_deprecated\")
}
}
; #o::
Detect_Window_Info(*){
	Run("Detect_Window_Info.ahk")
}
; ^+#6::
Detect_Window_Update(*){
	Edit()
}
; ^+#7::
test_script(*){
	Run("test_script.ahk")
}
;---------------------------------------------------------------------------
;      Shift+WIN+m Button to Click on Window Anywhere to Drag
;---------------------------------------------------------------------------
; This script is from the Automator

!LButton::
{
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    WinMove(x, y, , , "A")
    return
}
;---------------------------------------------------------------------------
;                       Time Stamp Code
;---------------------------------------------------------------------------
#HotIf WinActive('ahk_exe hznhorizon.exe') || WinActive('ahk_exe git.exe')
:*:ts::
; format month and year
{
	date := FormatTime(A_Now, "yyyy.MM")
	Send("(AJB - " date ")")
	return
}
#HotIf
:*:tsf::
; format month and year
{
	date := FormatTime(A_Now, "yyyy.MM.dd")
	Send("(AJB - " date ")")
	return
}
;---------------------------------------------------------------------------
;                      Helpful Stuff
;---------------------------------------------------------------------------
:*:attext::	; Timestamp
{
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
{
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
}

insert(A_GuiEvent, GuiCtrlObj, Info, *)
{
	myGui := 
	oSaved := myGui.submit()
	Send(arr[SubStr(A_GuiEvent, 2)])
}

;---------------------------------------------------------------------------
;      Alt+Left Mouse Button to Click on Window Anywhere to Drag
;---------------------------------------------------------------------------
; This script modified from the original: http://www.autohotkey.com/docs/scripts/EasyWindowDrag.htm

Alt & ~LButton::EWD_MoveWindow()
; ~MButton & LButton::
; CapsLock & LButton::
; EWD_MoveWindow(*)
; {
;     CoordMode "Mouse"  ; Switch to screen/absolute coordinates.
;     MouseGetPos &EWD_MouseStartX, &EWD_MouseStartY, &EWD_MouseWin
;     WinGetPos &EWD_OriginalPosX, &EWD_OriginalPosY,,, EWD_MouseWin
;     if !WinGetMinMax(EWD_MouseWin)  ; Only if the window isn't maximized 
;         SetTimer EWD_WatchMouse, 10 ; Track the mouse as the user drags it.

;     EWD_WatchMouse()
;     {
;         if !GetKeyState("LButton", "P")  ; Button has been released, so drag is complete.
;         {
;             SetTimer , 0
;             return
;         }
;         if GetKeyState("Escape", "P")  ; Escape has been pressed, so drag is cancelled.
;         {
;             SetTimer , 0
;             WinMove EWD_OriginalPosX, EWD_OriginalPosY,,, EWD_MouseWin
;             return
;         }
;         ; Otherwise, reposition the window to match the change in mouse coordinates
;         ; caused by the user having dragged the mouse:
;         CoordMode "Mouse"
;         MouseGetPos &EWD_MouseX, &EWD_MouseY
;         WinGetPos &EWD_WinX, &EWD_WinY,,, EWD_MouseWin
;         SetWinDelay -1   ; Makes the below move faster/smoother.
;         WinMove EWD_WinX + EWD_MouseX - EWD_MouseStartX, EWD_WinY + EWD_MouseY - EWD_MouseStartY,,, EWD_MouseWin
;         EWD_MouseStartX := EWD_MouseX  ; Update for the next timer-call to this subroutine.
;         EWD_MouseStartY := EWD_MouseY
;     }
; }

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
; ---------------------------------------------------------------------------
;?			Hotstrings
; ---------------------------------------------------------------------------
:X:/datetime::FormatDateTime("dddd, MMMM dd, yyyy, HH:mm")
:X:/datetimett::FormatDateTime("dddd, MMMM dd, yyyy hh:mm tt")
:X:/cf::FormatDateTime("yyyy.MM.dd HH:mm")
:X:/time::FormatDateTime("HH:mm")
:X:/timett::FormatDateTime("hh:mm tt")
:X:/date::FormatDateTime("MMMM dd, yyyy")
:X:/daten::FormatDateTime("MM/dd/yyyy")
:X:/datet::FormatDateTime("yy.MM.dd")
:X:/week::FormatDateTime("dddd")
:X:/day::FormatDateTime("dd")
:X:/month::FormatDateTime("MMMM")
:X:/monthn::FormatDateTime("MM")
:X:/year::FormatDateTime("yyyy")
::wtf::Wow that's fantastic
:X:/paste::Send(A_Clipboard)
; ::/cud::
;     ; useful for WSLs
; {
;     SendInput("/mnt/c/Users/" A_UserName "/")
; Return
; }
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

pMakeTrayMenu(*){
	myScript := A_TrayMenu
	; TrayMenu := MenuBar()
	myScript.Delete() ; V1toV2: not 100% replacement of NoStandard, Only if NoStandard is used at the beginning
	myScript.Add("Made by OvercastBTC",madeBy)
	myScript.Add()
	; Tray.Add("Run at startup", "runAtStartup")
	; Tray.ToggleCheck(fileExist(startup_shortcut) ? "check" : "unCheck", Run at startup ; update the tray menu status on startup
	; TODO Finish updating Run at Startup
	; Tray.Add("Presentation mode {Win+Shift+P}", togglePresentationMode) ; => does not exist
	; Tray.Add("Keyboard shortcuts {Ctrl+Shift+Alt+\}", "viewKeyboardShortcuts")
	; Tray.Add("Open file location", "openFileLocation")
	; Tray.Add()
	; Tray.Add("Run GUI_FE", "GUIFE")
	myScript.Add('Run WindowsListMenu.ahk', WindowListMenu)
	myScript.Add()
	myScript.Add('Run GUI_ListofFiles.ahk', GUI_ListofFiles)
	myScript.Add("Run WindowProbe.ahk", WindowProbe)
	; Tray.Add("Run Windows_Data_Types_offline.ahk", Windows_Data_Types_offline)
	myScript.Add()
	; Tray.Add("View in GitHub", "viewInGitHub")
	; Tray.Add("See AutoHotKey documentation", "viewAHKDoc") ; => does not exist
	; Tray.Add()
	myScript.AddStandard()
	; Tray.Show
	; --------------------------------------------------------------------------------
	madeBy(madeBy,*){
	}
	WindowListMenu(*){
		Run("WindowListMenu.ahk")
	}
}