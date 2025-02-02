﻿; AHK v1
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

#INCLUDE TheArkive_MsgBox2.ahk

Global MainHwnd, bigMsg, bigMsg2

MsgBox2ExGui()

MsgBox2ExGui() {
	Gui, New, +HwndMainHwnd +LabelMsgBox2Ex
	Gui, Add, Button, gExample1, Ex #1
	Gui, Show, w300
}

Example1() {
	sTitle := "File Delete Action" ; title ... can be anything
	
	; ===========================================================================
	; Here are a variety of different test messages for experimenting.
	; ===========================================================================
	
	; sMsg := bigMsg ; large columns of text, see below
	
	; sMsg := bigMsg2 ; long text that simulates log output, see below
	
	; sMsg := "This is an interesting test message.`r`n`r`nDelete file?"
	
	sMsg := "BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah"
	
	; sMsg := "BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah blah BLAH blah blah blah blah blah blah blah blah blah blah blah blah blah blah"
	
	; ===========================================================================
	; === Use this to modify font, font size, text color...
	; ===========================================================================
	; msgboxStyle := "txtColor:Red,fontFace:Verdana,fontSize:10," ; always end with a comma, it's just easier
	; sOptions := msgboxStyle
	
	; ===========================================================================
	; define parent window with one of these options.  Do NOT use modal: and parent: together
	; ===========================================================================
	sOptions .= "modal:" MainHwnd "," ; prevents taskbar icon, and disables parent window
	; sOptions .= "parent:" MainHwnd "," ; prevents taskbar icon, does NOT disable parent window
	
	; ===========================================================================
	; === some common options
	; ===========================================================================
	sOptions .= "noCloseBtn," ; removes close button on dialog
	sOptions .= "btnAlign:center," ; button alignment: left, center right / default = right
	sOptions .= "maxWidth:0," ; maxWidth:0 will allow sMsg to be its natural width, limited by screen width
	sOptions .= "selectable," ; best used with larger dialog sizes
	
	; ===========================================================================
	; check library comments for more icon options
	; you can use HICON / HBITMAP, icon:file.jpg, or icon:file.dll/[index]
	; ===========================================================================
	sOptions .= "icon:warning," ; generic icons: warning, info, question, error
	
	; ===========================================================================
	; === add controls for additional user input
	; === modify / comment out as desired
	; === check library comments for detailed options list and instructions
	; ===========================================================================
	sOptions .= "list:Option 1|Option 2|Option 3|Option 4|Option 5|Option 6|Option 7|Option 8|Option 9|Option 10|Option 11:3:5,"
	sOptions .= "check:Don't show again.:1,"	; add global style + checkBox
	sOptions .= "dropList:Long Long Long Long Long Long Long Option1|Option2|Option 3:2,"
	sOptions .= "combo:Option 4|Option 5|Option 6:3,"
	sOptions .= "edit:New_file_name.txt,"
	
	; ===========================================================================
	; button list, can be a number 0-6 like original MsgBox command, or
	; "|" delimited string of your own custom button text
	; ===========================================================================
	sOptions .= "btnList:OK|Cancel|Try Again," ; selectable
	
	mb2 := new msgbox2(sMsg,sTitle,sOptions) ; bigMsg
	
	msgbox % "edit: " mb2.edit 
	     . "`r`nlist: " mb2.list
		 . "`r`nlistText: " mb2.listText
	     . "`r`ndropList: " mb2.dropList 
		 . "`r`ndropListText: " mb2.dropListText
		 . "`r`ncombo: " mb2.combo 
		 . "`r`ncomboText: " mb2.comboText
		 . "`r`ncheck: " mb2.check 
		 . "`r`nbutton: " mb2.button 
		 . "`r`nclassNN: " mb2.classNN
	mb2 := ""
}

MsgBox2ExClose(hwnd) {
	if (hwnd = MainHwnd)
		ExitApp
}

bigMsg =
(
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
data data data data data data data data data data data data data data
)

bigMsg2 = 
(
data data data data data data data 
data data data data data data data data data data data data data data
data data data data data data data data 
data data data data data data data data data data 
data data data
data data data data data data data dat
data data ddata data
data data data data data data data data data data data data data data
data data dadata data data
data data data data data data data 
data data data data data data data data d
data data data data data data data data dat
data data data data data data data data data data
data data d
data data dat
data data data data data dat
data data data data data data data data data data data data data data
data data data data data data data data data data 
data data data dat
data data data data data data data 
data data data data data data data data data data data data data data
data data data data data data data data 
data data data data data data data data data data 
data data data
data data data data data data data dat
data data ddata data
data data data data data data data data data data data data data data
data data dadata data data
data data data data data data data 
data data data data data data data data d
data data data data data data data data dat
data data data data data data data data data data
data data d
data data dat
data data data data data dat
data data data data data data data data data data data data data data
data data data data data data data data data data 
data data data dat
)