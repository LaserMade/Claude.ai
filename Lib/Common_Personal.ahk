; --------------------------------------------------------------------------------
; Section .....: Auto-Execution
; --------------------------------------------------------------------------------
#Warn All, OutputDebug ; Enable warnings to assist with detecting common errors.
#MaxThreads 255 ; Allows a maximum of 255 instead of default threads.
SetTitleMatchMode(2) ; sets title matching to search for "containing" instead of "exact"
; --------------------------------------------------------------------------------
;#Persistent ; Keeps script permanently running
; --------------------------------------------------------------------------------
;#SingleInstance,Force
;SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
; --------------------------------------------------------------------------------
;SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; --------------------------------------------------------------------------------
; SetWinDelay(-1)
; SetControlDelay(-1) ; (AJB - 06/2023) - comment out for testing
; SetWinDelay(-1) ; (AJB - 05/2023) - comment out for testing 
; --------------------------------------------------------------------------------
DetectHiddenText(1)
DetectHiddenWindows(1)
; --------------------------------------------------------------------------------
#Requires AutoHotkey v2
; --------------------------------------------------------------------------------
return
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/**
 * Description ...: Personal Abbreviations
 */
; --------------------------------------------------------------------------------

:*:peml::adam.bacon80@icloud.com												; Personal Email
:*:eml::adam.bacon@fmglobal.com													; Email
:*:emp#::52906																	; Employee Number
:*:officeaddress::FM Global: 601 108th Ave NE, Suite 1400, Bellevue, WA 98004 	; Office Address
:*:paddrf::1378 Fenmore Ave, Sanger, CA 93657									; My Address
; :*:pwnotes::
; =============================== + FM Stuff + =============================
:*:fmusr::bacona				; workstation username
:*:fmpw::		; fm 
{ 
	Send("{!}980ab**HD{!}9KB")
}
return
#HotIf WinActive("EngNET")
	:*:usr::bacona
	:*:pw::{!}980ab**HD{!}9KB
#HotIf
#HotIf WinActive("Xfinity")
	:*:usr::harmony_bacon@comcast.net
	:*:pw::Ah{!}9801988
#HotIf
#HotIf WinActive("AT&T")
	:*:usr::bacon942882
	:*:pw::Ah_19801988
#HotIf
#HotIf WinActive("Marriott")
	:*:usr::063194266
	:*:pw::HDBacon{!}9801988
#HotIf
#HotIf WinActive("GitHub")
	:*:usr::OvercastBTC
	:*:pw::HDBacon{!}980{!}988
#HotIf
#HotIf WinActive("AutoHotKey")
	:*:usr::OvercastBTC
	:*:pw::HDBacon{!}980{!}988
#HotIf
#HotIf WinActive("ticketmaster.com") or WinActive('Seattle Mariners Account Manager')
	:*:usr::adam.bacon80@icloud.com
	:*:pw::HDBacon{!}980{!}988
#HotIf
;============================== Other =============================================
;SendEvent ; Use SendEvent so that the script's own hotkeys can be triggered.
:?*:ppw::HDBacon{!}980{!}988									; other password
:?*:epw::HDBacon{!}9801988									; other password
:?*:gpwf::80**19HDabKB									; g password
:?*:wifionboard::Ah{!}980198812
; wifi onboard title window Sign in - Alaska Airlines - Google Chrome
/*
	#IfWinActive ahk_class CabinetWClass
	#InputLevel 1
	RButton::
{ ; V1toV2: Added bracket
	SendEvent {Shift down}
	SendEvent RButton
	SendEvent {Shift up}
	;SendEvent {Blind}{LButton up}
	;SendEvent {Blind}{LShift up}
	ToolTip You pressed %A_ThisHotkey%.
	Sleep 3000
	ToolTip
	;Send {ShiftDown}
	;PostMessage,0x0204,,,,ahk_exe explorer.exe 
	;PostMessage,0x0205,,,,ahk_exe explorer.exe 
	;send {ShiftUp}
	return
	#InputLevel
	#IfWinActive
*/
; } ; V1toV2: Added Bracket before hotkey or Hotstring
:*:solusr::abacon01
:*:solpw::7jZuhYwi
; :*:solcod::
:*:solvznpw::gill4-frank-dug
; { ; V1toV2: Added bracket
; } ; V1toV2: Added bracket in the end
#HotIf WinActive("Reddit", )
:*:usr::Comfortable_Kick_776
:*:pw:: 80ab**HD!9KB20!9
redditpw:
; fmjobapp ---------------------
#HotIf WinActive("intranet-fmglobal.icims.com", )
:*:joblog::
{ ; V1toV2: Added bracket
SendLevel(1)
site:= "https://intranet-fmglobal.icims.com/jobs/candidate?back=dashboard"
Run(site)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:eml::adam.bacon@fmglobal.com
:*:usr::adambacon160807
:*:pw::80ab**HD{!}9KB{!}9
return
#HotIf
; Marsh ---------------------
#HotIf WinActive("kiteworks", )
:*:marshlog::
{ ; V1toV2: Added bracket
site:= "https://us-mmc-datatransfer.mmc.com/login?#/"
Run(site)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::
{ ; V1toV2: Added bracket
Send("adam.bacon@fmglobal.com")
A_Clipboard := "HDBacon!9801988"
return
} ; V1toV2: Added bracket in the end
#HotIf
; Delta---------------------
#HotIf WinActive("Delta", )
:*:deltalog::
{ ; V1toV2: Added bracket
site:= "https://www.delta.com/mydelta/walletMyReceiptSummary"
Run(site)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::9339385271
:*:pw::HDBacon{!}9801988
return
#HotIf
; Alaska--------------------
#HotIf WinActive("Alaska Airlines", )
:*:aklog::
{ ; V1toV2: Added bracket
site:= "https://www.alaskaair.com"
Run(site)
Return
}
:*:usr::72832631
:*:pw::Ah{!}9801988
#HotIf
; Hilton---------------------------------------
#HotIf WinActive("Hilton", )
:*:hiltonlog::
{ ; V1toV2: Added bracket
site:= "https://www.hilton.com/"
Run(site)
return
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::942499799
:*:pw::HDBacon{!}9801988
#HotIf
; the-automator.com----------------------------
#HotIf WinActive("the-Automator", )
:*:automatorlog::
{ ; V1toV2: Added bracket
SendLevel(1)
site:= "https://https://www.the-automator.com/wp-login.php"
Run(site)
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
return
:*:usr::adam.bacon80@icloud.com
:*:pw::HDBacon{!}9801988
#HotIf
; iCloud ---------------------------------------
#HotIf WinActive("iCloud", )
:*:icloudlog::
{ ; V1toV2: Added bracket
site:= "https://www.icloud.com/"
Run(site)
return
return
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::adamjcdbacon@hotmail.com
:*:pw::80ab**HD{!}9KB20{!}9
#HotIf
; Discord ---------------------------------------
#HotIf WinActive("Discord", )
:*:discordlog::
{ ; V1toV2: Added bracket
site:= "https://discord.com/channels/@me"
Run(site)
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::adam.bacon8073@gmail.com
:*:pw::HDBacon{!}980{!}988
return
#HotIf
; Avis ---------------------------------------
#HotIf WinActive("Avis", )
:*:avislog::
{ ; V1toV2: Added bracket
site:= "https://www.avis.com/"
Run(site)
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::S4K347
:*:pw::HDBacon{!}9801988
return
#HotIf
#HotIf WinActive("United", )
:*:unitedlog::
{ ; V1toV2: Added bracket
site:= "https://www.united.com/"
Run(site)
} ; V1toV2: Added Bracket before hotkey or Hotstring
:*:usr::MP216222
:*:pw::HDBacon{!}9801988
return
#HotIf
/*
MileIQ: 80ab**HD19KB
Marriott: 063194266 , HDBacon!9801988
ATT: Ah_19801988
UID: 1170ON
(VAHealth)idme: Ah!980198819
FCM: 80ab**HD19KB1
Xf: Ah!....
Hilton: 942499799 , HDBacon!9801988
United: MP216222 , HDBacon!9801988
Alaska: 72832631 , Ah!9801988
Delta: 9339385271, HDBacon!9801988
Hertz: 21082776 , HD
Carey: fm email, HD
Expense Report Format:

Business Travel - Airfare - 
Business Travel - Meal - 
Business Travel - Rental Car - 

FM Approvals: 80ab**HD19KB
*/