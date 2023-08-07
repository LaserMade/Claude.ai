#SingleInstance Force
#Warn All, OutputDebug
; -============================== Main Script ==============================
; Section: Scriptlet Library with TreeView to group the code snippets
; Authors: by toralf, original by Rajat
; Comment: requires AHK 1.0.44.09+
; Source: www.autohotkey.com/forum/topic2510.html

Version := "4"
ScriptName := "Scriptlet_Library_" . Version . ".v2"
#Requires AutoHotkey 2.0+
/*
changes to version 3:
- requires "../Anchor/Anchor_v3.3.ahk" => www.autohotkey.com/forum/topic4348.html
- on RollUp, gui minimized animated to a small bar. very nice :)
- menu option to choose between two gui styles (thanks MsgBox)
- menu options to turn on/off RollUpDown and AlwaysOnTop  (thanks MsgBox)
- changed RollUpDown to work on gui not-active instead of OnMessage(RButton) 
- changed AlwaysOnTop to work without OnMessage(MButton)
- menu option to choose the font and size (thanks MsgBox) 
- menu option to backup the ini (thanks MsgBox)
- improved docking behavior 
changes to version 2:
- complete rewritten
- added tray menu and icon
- tray icon allows to exit script
- treeview to show groups of scriptlets
- easy naming/saving handling, similar to IniFileCreator
- scriplets can change groups easily
- command line parameter "/dock hwnd" to dock GUI to upper left corner of hwnd
- remembers the gui size and position between starts
*/

GroupStartString := "<---Group_"
ScriptletStartString := "<---Start_"
ScriptletEndString := "<---End_"
DefaultGroupName := "Misc"
DefaultNewGroupName := "New Group"
DefaultNewScriptletName := "Scriptlet"
ScriptletNameIndex := "0"

;set working dir, in case this script is called from some other script in a different dir 
SetWorkingDir(A_ScriptDir)

;get ini file name and values
SplitPath(A_ScriptName, , , , &OutNameNoExt)
IniFile := OutNameNoExt . ".ini"
Gui1Pos := IniRead(IniFile, "Settings", "Gui1Pos", A_Space)
Gui1W := IniRead(IniFile, "Settings", "Gui1W", A_Space)
Gui1H := IniRead(IniFile, "Settings", "Gui1H", A_Space)
BolResizeTreeH := IniRead(IniFile, "Settings", "BolResizeTreeH", 0)
BolRollUpDown := IniRead(IniFile, "Settings", "BolRollUpDown", 1)
BolAlwaysOnTop := IniRead(IniFile, "Settings", "BolAlwaysOnTop", 0)
IntGuiStyle := IniRead(IniFile, "Settings", "IntGuiStyle", 1)
StrFontName := IniRead(IniFile, "Settings", "StrFontName", "Courier")
IntFontSize := IniRead(IniFile, "Settings", "IntFontSize", A_Space)
If IntFontSize
    FontSize := "S" . IntFontSize

;#SingleInstance force
BuildTrayMenu()
BuildGuiStyle%IntGuiStyle%()
BuildContextMenu()
GroupAdd("GrpGui", "ahk_id " Gui1UniqueID)

Loop 0 {                       ;for each command line parameter
    next := A_Index + 1           ;get next parameters number
    If (%A_Index% = "/dock")      ;check if known command line parameter exists
        param_dock := %next%      ;assign next command line parameter as value
;     Else If (%A_Index% = "/log")
;         param_log := %next%
}

;when docked to an editor ...
If param_dock {
    myGui := Gui()
    myGui.OnEvent("Close", GuiEscape)
myGui.OnEvent("Escape", GuiEscape)
myGui.OnEvent("Size", GuiSize)
myGui.Opt("+ToolWindow")              ;make library a toolwindow
    DockToWindow()              ;dock it to the editor upper left corner
    SetTimer(DockToWindow,On)      ;make sure it stays there
    If !BolAlwaysOnTop              ;enforce AOT
        ToggleAlwaysOnTop()
    ContextMenu := Menu()
    ContextMenu.Disable("Always On Top")
    AOTState := True
    If BolRollUpDown
        RollGuiUp(ScriptName)       ;roll Gui Up when wanted
  }
Return

DockToWindow()
  ;Check if editor window exists 
{ ; V1toV2: Added bracket
  EditorVisibleState := "1"
  If !WinExist("ahk_id " param_dock){
      DetectHiddenWindows(true)
      If !WinExist("ahk_id " param_dock)  ;check if editor window exists minimized
          GuiClose()                 ;if not close this script
      Else 
          EditorVisibleState := "0"     ; WinGet, EditorVisibleState, MinMax  doesn't work on PSPad    
    } 
  ;get editor position
  WinGetPos(&EditorX, &EditorY, , , "ahk_id " param_dock)
  DetectHiddenWindows(false)
  
  ;remove AOT if other window is active
  ID := WinActive("A")
  If (WinActive("A") <> Gui1UniqueID AND WinActive("A") <> param_dock AND AOTState ) {
      oGui2 := Gui()
      oGui2.OnEvent("Close", GuiEscape)
oGui2.Opt("-AlwaysOnTop")
      myGui.Opt("-AlwaysOnTop")
      AOTState := False
      Return
  }Else If ( (WinActive("A") = Gui1UniqueID OR WinActive("A") = param_dock) AND !AOTState)  {
      oGui2.Opt("+AlwaysOnTop")
      myGui.Opt("+AlwaysOnTop")
      AOTState := True
      Return
    }  
 
  ;reposition bar/gui to upper left corner or hide when editor is minimized 
  If (!EditorVisibleState AND Old_EditorVisibleState <> EditorVisibleState) {
      oGui2.Opt("+LastFoundExist")  ;hide small bar when minimized and existing
      if WinExist()
          oGui2.Show("Hide")
      myGui.Show("Hide")     ;hide gui when minimized
  }Else If (EditorVisibleState AND Old_EditorVisibleState <> EditorVisibleState) {
      If GuiRolledUp
          oGui2.Show("AutoSize NoActivate")    ;Show small bar when restored
      Else
          myGui.Show("AutoSize NoActivate")    ;Show gui when restored
  }Else If ( EditorX " " EditorY <> Old_EditorPos ) {
      If GuiRolledUp {
          oGui2.Show("x" . EditorX . " y" . EditorY . " NoActivate")   ;move small bar when rolled up
          myGui.Show("x" . EditorX . " y" . EditorY . " Hide")         ;and move gui hidden
      }Else{
          myGui.Show("AutoSize x" . EditorX . " y" . EditorY . " NoActivate")   ;otherwise move gui
        }
      Old_EditorPos := EditorX " " EditorY
    }
  Old_EditorVisibleState := EditorVisibleState
Return
} ; V1toV2: Added bracket before function

BuildTrayMenu()
  ;location of icon file
{ ; V1toV2: Added bracket
  If ( A_OSType = "WIN32_WINDOWS" )  ; Windows 9x
      IconFile := A_WinDir . "\system\shell32.dll"
  Else
      IconFile := A_WinDir . "\system32\shell32.dll"

  ;tray menu
  TraySetIcon(IconFile,"45")   ;icon for taskbar and for process in task manager
  A_IconTip := ScriptName
  ;Menu, Tray, NoStandard
  Tray:= A_TrayMenu
  Tray.Add("Exit", GuiEscape)
  Tray.Default := "Exit"
  ;Menu, Tray, Click, 1
Return
} ; V1toV2: Added Bracket before label

FileScriptletsIntoGui()
  ;create default group
{ ; V1toV2: Added bracket
  myGui.Default()
  Group_ID := TV.Add(DefaultGroupName, "", "Sort")
  ListOfGroupNames := "`n" . DefaultGroupName . "`n"
  Default_Group_ID := Group_ID
  
  ;read data
  Loop Read, IniFile
    {
      If (InStr(A_LoopReadLine, GroupStartString)=1) {
          ;get group name
          GroupName := SubStr(A_LoopReadLine, (StrLen(GroupStartString))+1)
          Group_ID := TV.Add(GroupName, "", "Sort")
          ListOfGroupNames := ListOfGroupNames . "" . GroupName . "`n"
      }Else If (InStr(A_LoopReadLine, ScriptletStartString)=1) {
          ;get scriptlet name
          ScriptletName := SubStr(A_LoopReadLine, (StrLen(ScriptletStartString))+1)
          
          ;add scriptlet
          ID := TV.Add(ScriptletName, Group_ID, "Sort")
          ScriptletInProcess := True
          Scriptlet := ""
      }Else If (InStr(A_LoopReadLine, ScriptletEndString)=1) {
          ScriptletInProcess := False
          Scriptlet := SubStr(Scriptlet, 1, -1*(1))
          %ID%Scriptlet = %Scriptlet%
      }Else If ScriptletInProcess {
          Scriptlet := Scriptlet . "" . A_LoopReadLine . "`n"
        }
    }
  ;check if default group is used
  If !TV.GetChild(Default_Group_ID){
      TV.Delete(Default_Group_ID)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      ListOfGroupNames := StrReplace(ListOfGroupNames, "`n" DefaultGroupName "`n", "`n",,, 1)
} 

; StrReplace() is not case sensitive
; check for StringCaseSense in v1 source script
; and change the CaseSense param in StrReplace() if necessary
DdbScriptletInGroup := StrReplace(ListOfGroupNames, "`n", "|")
ogcDdbScriptletInGroup.Value := DdbScriptletInGroup
Return

;#Include \AutoGUI\AutoXYWH.ahk
BuildGuiStyle1:

myGui.Opt("+Resize")
ogcButtonBtnAddGroup := myGui.Add("Button", "Section vBtnAddGroup", "+")
ogcButtonBtnAddGroup.OnEvent("Click", BtnAddGroup.Bind("Normal"))
ogcEditEdtGroupName := myGui.Add("Edit", "x+1 ys+1 w200 vEdtGroupName  Disabled")
ogcEditEdtGroupName.OnEvent("Change", EdtGroupName.Bind("Change"))
ogcButtonBtnRemoveGroup := myGui.Add("Button", "x+1 ys vBtnRemoveGroup  Disabled", "-")
ogcButtonBtnRemoveGroup.OnEvent("Click", BtnRemoveGroup.Bind("Normal"))

ogcButtonBtnAddScriptlet := myGui.Add("Button", "x+40 ys vBtnAddScriptlet  Disabled", "+")
ogcButtonBtnAddScriptlet.OnEvent("Click", BtnAddScriptlet.Bind("Normal"))
ogcEditEdtScriptletName := myGui.Add("Edit", "x+1 ys+1 w150 vEdtScriptletName  Disabled")
ogcEditEdtScriptletName.OnEvent("Change", EdtScriptletName.Bind("Change"))
ogcButtonBtnRemoveScriptlet := myGui.Add("Button", "x+1 ys vBtnRemoveScriptlet  Disabled", "-")
ogcButtonBtnRemoveScriptlet.OnEvent("Click", BtnRemoveScriptlet.Bind("Normal"))
ogcDropDownListDdbScriptletInGroup := myGui.Add("DropDownList", "x+40 ys w150 vDdbScriptletInGroup  Sort Disabled")
ogcDropDownListDdbScriptletInGroup.OnEvent("Change", DdbScriptletInGroup.Bind("Change"))

ogcButtonBtnCopyToClipboard := myGui.Add("Button", "ys vBtnCopyToClipboard  Disabled", "Copy to &A_Clipboard")
ogcButtonBtnCopyToClipboard.OnEvent("Click", BtnCopyToClipboard.Bind("Normal"))

ogcTreeViewTrvScriptlets := myGui.Add("TreeView", "xs Section w250 h500 vTrvScriptlets")
ogcTreeViewTrvScriptlets.OnEvent("DoubleClick", TrvScriptlets.Bind("DoubleClick"))
FileScriptletsIntoGui()
myGui.SetFont(FontSize, StrFontName)
ogcEditEdtScriptletData := myGui.Add("Edit", "w500 h500 ys Multi T8 vEdtScriptletData")
ogcEditEdtScriptletData.OnEvent("Change", EdtScriptletData.Bind("Change"))
ogcButtonb1 := myGui.Add("Button", "vb1", "Resize")
ogcButtonb1.OnEvent("Click", Resize.Bind("Normal"))
myGui.Show()
return
} ; V1toV2: Added Bracket before label

Resize(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
ogceEdtScriptletData.Move(, , , 500)
AutoXYWH("reset") ; Needs to reset if you changed the Control size manually.
return
} ; V1toV2: Added Bracket before label

_5GuiSize:
If (A_EventInfo = 1) ; The window has been minimized.
	Return
AutoXYWH("wh", "e1")
AutoXYWH("y", "b1")
return
FinishGUI()
Return
;********************Resizing***********************************
_1GuiSize:
ogc%EditWindow%.Move(, , A_GuiWidth-30, A_GuiHeight-25)
return
FinishGUI()
{ ; V1toV2: Added bracket
myGui.Title := ScriptName
myGui.Show("AutoSize " . Gui1Pos)
myGui.Opt("+LastFound +Resize")
Gui1UniqueID := WinExist()
;restore old size
WinMove(ahk_id %Gui1UniqueID%)
;select first scriptlet
ogcTreeViewTrvScriptlets.Modify(ogcTreeViewTrvScriptlets.GetChild(ogcTreeViewTrvScriptlets.GetNext()), "Select")
Return
} ; V1toV2: Added Bracket before label

BuildGuiStyle2:
myGui.Opt("+Resize")
myGui.MarginX := "3", myGui.MarginY := "3"
ogcButtonBtnAddGroup := myGui.Add("Button", "w15 Section vBtnAddGroup", "+")
ogcButtonBtnAddGroup.OnEvent("Click", BtnAddGroup.Bind("Normal"))
ogcEditEdtGroupName := myGui.Add("Edit", "ys+1 w190 vEdtGroupName  Disabled")
ogcEditEdtGroupName.OnEvent("Change", EdtGroupName.Bind("Change"))
ogcButtonBtnRemoveGroup := myGui.Add("Button", "w15 ys vBtnRemoveGroup  Disabled", "-")
ogcButtonBtnRemoveGroup.OnEvent("Click", BtnRemoveGroup.Bind("Normal"))

ogcButtonBtnAddScriptlet := myGui.Add("Button", "w15 xs Section vBtnAddScriptlet  Disabled", "+")
ogcButtonBtnAddScriptlet.OnEvent("Click", BtnAddScriptlet.Bind("Normal"))
ogcEditEdtScriptletName := myGui.Add("Edit", "ys+1 w190 vEdtScriptletName  Disabled")
ogcEditEdtScriptletName.OnEvent("Change", EdtScriptletName.Bind("Change"))
ogcButtonBtnRemoveScriptlet := myGui.Add("Button", "w15 ys vBtnRemoveScriptlet  Disabled", "-")
ogcButtonBtnRemoveScriptlet.OnEvent("Click", BtnRemoveScriptlet.Bind("Normal"))

ogcDropDownListDdbScriptletInGroup := myGui.Add("DropDownList", "xs Section w127 vDdbScriptletInGroup  Sort Disabled")
ogcDropDownListDdbScriptletInGroup.OnEvent("Change", DdbScriptletInGroup.Bind("Change"))
ogcButtonBtnCopyToClipboard := myGui.Add("Button", "x+3 ys-1 vBtnCopyToClipboard  Disabled", "Copy to &A_Clipboard")
ogcButtonBtnCopyToClipboard.OnEvent("Click", BtnCopyToClipboard.Bind("Normal"))

ogcTreeViewTrvScriptlets := myGui.Add("TreeView", "xs w225 h500 vTrvScriptlets")
ogcTreeViewTrvScriptlets.OnEvent("DoubleClick", TrvScriptlets.Bind("DoubleClick"))
FileScriptletsIntoGui()
myGui.SetFont(FontSize, StrFontName)
ogcEditEdtScriptletData := myGui.Add("Edit", "w" A_GuiWidth-30 " h" A_GuiHeight-25 ym Multi T8 vEdtScriptletData)
ogcEditEdtScriptletData.OnEvent("Change", EdtScriptletData.Bind("Change"))
FinishGUI()
Return

BuildContextMenu()
;context menu for right mouse click
{ ; V1toV2: Added bracket
ContextMenu.Add("BackUp Scriptlets", BackUpScriptlets)
ContextMenu.Add("Change Font", ChangeFont)
ContextMenu.Add("Change Font Size", ChangeFontSize)
ContextMenu.Add("")

ContextMenu.Add("Resize TreeView Width", ToggleResizeTreeview)
If BolResizeTreeH
	ContextMenu.ToggleCheck("Resize TreeView Width")
ContextMenu.Add("Auto-Roll-Up when not active", ToggleRollUpDown)
If BolRollUpDown
	SetRollUpDown()
ContextMenu.Add("Always On Top", ToggleAlwaysOnTop)
If BolAlwaysOnTop
	SetAlwaysOnTop()

IntGuiStyles := Menu()
IntGuiStyles.Add("1 - Open", ChooseIntGuiStyle)
IntGuiStyles.Add("2 - Compact", ChooseIntGuiStyle)
if (IntGuiStyle = 1)
	IntGuiStyles.ToggleCheck("1 - Open")
Else
	IntGuiStyles.ToggleCheck("2 - Compact")

ContextMenu.add("Gui Styles", IntGuiStyles)
Return
} ; V1toV2: Added Bracket before label

GuiContextMenu:
ContextMenu.Show()
return

BackUpScriptlets(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
myGui.Opt("+OwnDialogs")
SelectedFile := FileSelect("S18", A_ScriptDir, "Select file to backup scriptlets", "Ini file (*.ini)")
If SelectedFile {
      NormalINI := IniFile
      IniFile := SelectedFile
      WriteINIFile()
      IniFile := NormalINI
    }
Return
} ; V1toV2: Added Bracket before label
ChangeFont(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
  myGui.Opt("+OwnDialogs")
  IB := InputBox("Specify an existing font name`nfor the scriptlet window (Default: Courier)", "Choose Font", "w270 h130", StrFontName), OutVar := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
  If ErrorLevel 
      Return
  StrFontName := OutVar
  ReRunOrReload()
Return
} ; V1toV2: Added Bracket before label
ChangeFontSize(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
  myGui.Opt("+OwnDialogs")
  IB := InputBox("Specify a font size for`nthe scriptlet window (Default: empty)", "Choose Font Size", "w250 h130", IntFontSize), OutVar := IB.Value, ErrorLevel := IB.Result="OK" ? 0 : IB.Result="CANCEL" ? 1 : IB.Result="Timeout" ? 2 : "ERROR"
  If ErrorLevel 
      Return
  IntFontSize := OutVar
  ReRunOrReload()
Return
} ; V1toV2: Added Bracket before label

ToggleResizeTreeview(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
  BolResizeTreeH := Not BolResizeTreeH
  ReRunOrReload()
Return
} ; V1toV2: Added Bracket before label

ChooseIntGuiStyle(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
  IntGuiStyle := A_ThisMenuItemPos
  ReRunOrReload()
Return
} ; V1toV2: Added Bracket before label

ReRunOrReload()
{ ; V1toV2: Added bracket
  WriteINIFile()
  If param_dock {
      Run(A_AhkPath " `"" A_ScriptName "`" /dock " param_dock)
      ExitApp()
  }Else
      Reload()
Return
} ; V1toV2: Added bracket before function

TrvScriptlets(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  If TreeSelectionInProcess
      Return
  TreeSelectionInProcess := True
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If ParentID {     ;its a scriptlet
      GroupName := ogcTreeViewTrvScriptlets.GetText(ParentID)
      ScriptletName := ogcTreeViewTrvScriptlets.GetText(ID)
      ogcDropDownListDdbScriptletInGroup.Choose(GroupName)
      ogcEditEdtScriptletName.Value := ScriptletName
      ogcEditEdtScriptletData.Value := %ID%Scriptlet
      ogcEditEdtScriptletData.Enabled := true
      ogcEditEdtScriptletName.Enabled := true
      ogcButtonBtnRemoveScriptlet.Enabled := true
      ogcDropDownListDdbScriptletInGroup.Enabled := true
      ogcButtonBtnCopyToClipboard.Enabled := true
  }Else{
      GroupName := ogcTreeViewTrvScriptlets.GetText(ID)
      ogcEditEdtScriptletName.Value := ""
      ogcEditEdtScriptletData.Value := ""
      ogcEditEdtScriptletData.Enabled := false
      ogcEditEdtScriptletName.Enabled := false
      ogcButtonBtnRemoveScriptlet.Enabled := false
      ogcDropDownListDdbScriptletInGroup.Enabled := false
      ogcButtonBtnCopyToClipboard.Enabled := false
    }
  ogcEditEdtGroupName.Value := GroupName
  
  ogcButtonBtnAddScriptlet.Enabled := true
  ogcButtonBtnRemoveGroup.Enabled := true
  ogcEditEdtGroupName.Enabled := true
  ogcBtnSave.Enabled := true
  TreeSelectionInProcess := False
Return
} ; V1toV2: Added bracket before function

BtnAddGroup(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  myGui.Default()
  ;find group name that doesn't exist yet
  Loop
      If !InStr(ListOfGroupNames, "`n" . DefaultNewGroupName . " " . A_Index . "`n"){
          NewGroupNumber := A_Index
          Break
        }
  ;add new group
  GroupName := DefaultNewGroupName " " NewGroupNumber
  ID := ogcTreeViewTrvScriptlets.Add(GroupName, "", "Select Vis")
  ListOfGroupNames := ListOfGroupNames . "" . GroupName . "`n"
  ; StrReplace() is not case sensitive
  ; check for StringCaseSense in v1 source script
  ; and change the CaseSense param in StrReplace() if necessary
  DdbScriptletInGroup := StrReplace(ListOfGroupNames, "`n", "|")
  ogcDropDownListDdbScriptletInGroup.Add([DdbScriptletInGroup])
  ogcEditEdtGroupName.Focus()
  Sleep(20)
  Send("+{End}")
Return
} ; V1toV2: Added Bracket before label

EdtGroupName(A_GuiEvent, GuiCtrlObj, Info, *)
  ;check if new group name already exists
{ ; V1toV2: Added bracket
  EdtGroupName := ogcEditEdtGroupName.Text
  If InStr(ListOfGroupNames, "`n" EdtGroupName "`n")
      Return

  ;get group id
  myGui.Default()
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If ParentID      ;its a scriptlet
      ID := ParentID
  
  ;replace old name with new one in list
  GroupName := ogcTreeViewTrvScriptlets.GetText(ID)  
  ; StrReplace() is not case sensitive
  ; check for StringCaseSense in v1 source script
  ; and change the CaseSense param in StrReplace() if necessary
  ListOfGroupNames := StrReplace(ListOfGroupNames, "`n" GroupName "`n", "`n" EdtGroupName "`n",,, 1)
  ; StrReplace() is not case sensitive
  ; check for StringCaseSense in v1 source script
  ; and change the CaseSense param in StrReplace() if necessary
  DdbScriptletInGroup := StrReplace(ListOfGroupNames, "`n", "|")
  ogcDropDownListDdbScriptletInGroup.Add([DdbScriptletInGroup])

  ;change name in tree
  ogcTreeViewTrvScriptlets.Modify(ID, "", EdtGroupName) 
  ogcTreeViewTrvScriptlets.Modify(0, "Sort") 
Return
} ; V1toV2: Added Bracket before label

BtnRemoveGroup(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  myGui.Default()
  ;get group id
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If ParentID      ;its a scriptlet
      ID := ParentID

  ;get group name
  GroupName := ogcTreeViewTrvScriptlets.GetText(ID)
  
  msgResult := MsgBox("
    (LTrim
      Please confirm deletion of current scriptlet group:
      " GroupName "
      
      This will also remove all scriptlets in that group !!!
    )", "Delete Scriptlet Group?", 4)
  if (msgResult = "Yes")
    {
      ;get first scriptlet in that group and loop over all its siblings
      ScriptletID := ogcTreeViewTrvScriptlets.GetChild(ID)
      Loop{
          If !ScriptletID
              break
          ;remove scriptlet from memory
          %ScriptletID%Scriptlet =
          ;get next sibling in that group
          ScriptletID := ogcTreeViewTrvScriptlets.GetNext(ScriptletID)
        }
      ;remove group
      ogcTreeViewTrvScriptlets.Delete(ID) 
      ;remove group name from list
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      ListOfGroupNames := StrReplace(ListOfGroupNames, "`n" GroupName "`n", "`n",,, 1)
      ; StrReplace() is not case sensitive
      ; check for StringCaseSense in v1 source script
      ; and change the CaseSense param in StrReplace() if necessary
      DdbScriptletInGroup := StrReplace(ListOfGroupNames, "`n", "|")
      ogcDropDownListDdbScriptletInGroup.Add([DdbScriptletInGroup])
    }
Return
} ; V1toV2: Added Bracket before label

BtnAddScriptlet(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  myGui.Default()
  ;get group id
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If ParentID      ;its a scriptlet
      ID := ParentID

  ;add new scriptlet
  ScriptletNameIndex++
  ScriptletName := DefaultNewScriptletName . " " . ScriptletNameIndex
  ID := ogcTreeViewTrvScriptlets.Add(ScriptletName, ID, "Sort Select Vis")
  %ID%Scriptlet =
  ogcEditEdtScriptletName.Focus()
  Sleep(20)
  Send("+{End}")
Return
} ; V1toV2: Added Bracket before label

EdtScriptletName(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  myGui.Default()
  ;get scriptlet id
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If !ParentID      ;its a group
      Return

  EdtScriptletName := ogcEditEdtScriptletName.Text
  ;change name in tree
  ogcTreeViewTrvScriptlets.Modify(ID, "", EdtScriptletName) 
  ogcTreeViewTrvScriptlets.Modify(ID, "Sort") 
Return
} ; V1toV2: Added Bracket before label

BtnRemoveScriptlet(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  myGui.Default()
  ;get scriptlet id
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If !ParentID      ;its a group
      Return

  ;get scriptlet name
  ScriptletName := ogcTreeViewTrvScriptlets.GetText(ID)
  
  msgResult := MsgBox("
    (LTrim
      Please confirm deletion of current scriptlet:
      " ScriptletName "
    )", "Delete Scriptlet?", 4)
  if (msgResult = "Yes")
    {
      ;remove scriptlet from memory
      %ID%Scriptlet =
      ;remove group
      ogcTreeViewTrvScriptlets.Delete(ID) 
    }
Return
} ; V1toV2: Added Bracket before label

DdbScriptletInGroup(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  If TreeSelectionInProcess
      Return
  TreeSelectionInProcess := True
  myGui.Default()
  ;get scriptlet id and name
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If !ParentID      ;its a group
      Return
  ScriptletName := ogcTreeViewTrvScriptlets.GetText(ID)
  
  ;get new group ID
  DdbScriptletInGroup := ogcDropDownListDdbScriptletInGroup.Text
  GroupID := ogcTreeViewTrvScriptlets.GetNext()
  Loop{
      If !GroupID
          Return
      GrouptName := ogcTreeViewTrvScriptlets.GetText(GroupID)
      If (GrouptName = DdbScriptletInGroup)    
          Break
      GroupID := ogcTreeViewTrvScriptlets.GetNext(GroupID)
    }
  ;create new key and delete old one
  NewID := ogcTreeViewTrvScriptlets.Add(ScriptletName, GroupID, "Sort Select Vis")
  %NewID%Scriptlet := %ID%Scriptlet
  ogcTreeViewTrvScriptlets.Delete(ID)
  %ID%Scriptlet =
  TreeSelectionInProcess := False
Return
} ; V1toV2: Added Bracket before label

EdtScriptletData(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  If TreeSelectionInProcess
      Return
  myGui.Default()
  ;get scriptlet id
  ID := ogcTreeViewTrvScriptlets.GetSelection()
  ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
  If !ParentID      ;its a group
      Return

  EdtScriptletData := ogcEditEdtScriptletData.Text
  %ID%Scriptlet = %EdtScriptletData%
Return
} ; V1toV2: Added bracket before function

BtnCopyToClipboard(A_GuiEvent, GuiCtrlObj, Info, *)
{ ; V1toV2: Added bracket
  EdtScriptletData := ogcEditEdtScriptletData.Text
  A_Clipboard := EdtScriptletData
  If BolRollUpDown
      RollGuiUp(ScriptName)
Return
} ; V1toV2: Added bracket before function

GuiEscape(*)
{ ; V1toV2: Added bracket
GuiClose()
{ ; V1toV2: Added bracket
_2GuiClose:
  WriteINIFile()
  ExitApp()
Return
} ; V1toV2: Added Bracket before label

WriteINIFile()
{ ; V1toV2: Added bracket
  If GuiRolledUp
      DllCall("AnimateWindow", "UInt", Gui1UniqueID, "Int", 0, "UInt", "0x20005")
;      RollGuiDown(1, 1, 1, 1)
  FileDelete(IniFile)
  WinGetPos(&PosX, &PosY, &SizeW, &SizeH, "ahk_id " Gui1UniqueID)
  IniWrite("x" PosX " y" PosY, IniFile, "Settings", "Gui1Pos")
  IniWrite(SizeW, IniFile, "Settings", "Gui1W")
  IniWrite(SizeH, IniFile, "Settings", "Gui1H")
  IniWrite(IntGuiStyle, IniFile, "Settings", "IntGuiStyle")
  IniWrite(BolResizeTreeH, IniFile, "Settings", "BolResizeTreeH")
  IniWrite(BolRollUpDown, IniFile, "Settings", "BolRollUpDown")
  IniWrite(BolAlwaysOnTop, IniFile, "Settings", "BolAlwaysOnTop")
  IniWrite(StrFontName, IniFile, "Settings", "StrFontName")
  IniWrite(IntFontSize, IniFile, "Settings", "IntFontSize")
  FileAppend("`n`n", IniFile)
  
  ID := "0"
  myGui.Default()
  ScriptletString := ""
  Loop{
      ID := ogcTreeViewTrvScriptlets.GetNext(ID, "Full")
      If not ID
        break
      Name := ogcTreeViewTrvScriptlets.GetText(ID)
      ParentID := ogcTreeViewTrvScriptlets.GetParent(ID)
      If ParentID { ;it's a scriptlet
          Scriptlet := %ID%Scriptlet
          ScriptletString := ScriptletString . "" . ScriptletStartString . "" . Name . "`n" . Scriptlet . "`n" . ScriptletEndString . "" . Name . "`n`n`n"
      }Else
          ScriptletString := ScriptletString . "" . GroupStartString . "" . Name . "`n"

      ;remove the `n if no extra line break should be in the INI file
      If (Mod(A_index, 100)=0) {
          FileAppend(ScriptletString "`n", IniFile)
          ScriptletString := ""
        }
    }
  If ScriptletString
      FileAppend(ScriptletString "`n", IniFile)
Return
} ; V1toV2: Added Bracket before label
} ; V1toV2: Added bracket before function

ToggleRollUpDown(A_ThisMenuItem, A_ThisMenuItemPos, MyMenu)
{ ; V1toV2: Added bracket
  BolRollUpDown := Not BolRollUpDown
SetRollUpDown()
{ ; V1toV2: Added bracket
  ContextMenu.ToggleCheck("Auto-Roll-Up when not active")
  If BolRollUpDown {
      SetTimer(CheckIfActive,On)
  }Else{
      SetTimer(CheckIfActive,0)
}
Return
} ; V1toV2: Added Bracket before label

CheckIfActive()
{ ; V1toV2: Added bracket
if !WinActive("ahk_id " Gui1UniqueID)
	RollGuiUp(ScriptName)
Return

;********************Resizing***********************************
_12GuiSize:
ogc%EditWindow%.Move(, , A_GuiWidth-30, A_GuiHeight-25)
return
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function

RollGuiUp(BarName, vertical := "") {
  global Gui1UniqueID, GuiRolledUp
  SetTimer(CheckIfActive, 0)
  WM_NCMouseMove := "0xA0"
  OnMessage(WM_NCMouseMove, RollGuiDown)
  WinGetPos(&Gui1X, &Gui1Y, , , "ahk_id " Gui1UniqueID)
  oGui2.Opt("+ToolWindow -SysMenu +AlwaysOnTop +AutoSize")
  If vertical {
    oGui2.Title := BarName
    oGui2.Show("w0 h100 x" . Gui1X . " y" . Gui1Y . " NoActivate")  ;vertical bar
  } Else {
    oGui2.Title := BarName
    oGui2.Show("w150 h0 x" . Gui1X . " y" . Gui1Y . " NoActivate")  ;horizontal bar
    DllCall("AnimateWindow", "UInt", Gui1UniqueID, "Int", 200, "UInt", "0x3000a")
    GuiRolledUp := True
  }
 }

RollGuiDown(wParam, lParam, msg, hwnd) {
    global Gui1UniqueID, GuiRolledUp
    WM_NCMouseMove := "0xA0"
    OnMessage(WM_NCMouseMove)
    DllCall("AnimateWindow", "UInt", Gui1UniqueID, "Int", 200, "UInt", "0x20005")
    WinActivate("ahk_id " Gui1UniqueID)
    SetTimer(CheckIfActive,On)
    oGui2.Destroy()
    GuiRolledUp := False
  }

ToggleAlwaysOnTop()
{ ; V1toV2: Added bracket
  BolAlwaysOnTop := not BolAlwaysOnTop
SetAlwaysOnTop()
{ ; V1toV2: Added bracket
  ContextMenu.ToggleCheck("Always On Top")
  CurrentTitle := WinGetTitle("ahk_id " Gui1UniqueID)
  If BolAlwaysOnTop {
        myGui.Opt("+AlwaysOnTop")
        WinSetTitle(CurrentTitle " - *AOT*", "ahk_id " Gui1UniqueID)
  }Else{
        myGui.Opt("-AlwaysOnTop")
        CurrentTitle := SubStr(CurrentTitle, 1, -1*(8))
        WinSetTitle(CurrentTitle, "ahk_id " Gui1UniqueID)
    }
Return

;#Include f_Anchor.ahk
} ; V1toV2: Added bracket before function
} ; V1toV2: Added bracket before function
GuiSize(thisGui, MinMax, A_GuiWidth, A_GuiHeight)
{ ; V1toV2: Added bracket
  If BolResizeTreeH {
      If (IntGuiStyle = 1) {
          ;       ControlName         , xwyh with factors [, True for MoveDraw]
          Anchor("EdtGroupName"       , "      w0.5   ")
          Anchor("BtnRemoveGroup"     , "x0.5         ")
          Anchor("BtnAddScriptlet"    , "x0.5         ")
          Anchor("EdtScriptletName"   , "x0.5  w0.25  ")
          Anchor("BtnRemoveScriptlet" , "x0.75        ")
          Anchor("DdbScriptletInGroup", "x0.75 w0.25  ")
          Anchor("BtnCopyToClipboard" , "x            ")
    
          Anchor("TrvScriptlets"      , "      w0.5  h")
          Anchor("EdtScriptletData"   , "x0.5  w0.5  h")
      }Else{
          ;       ControlName         , xwyh with factors [, True for MoveDraw]
          Anchor("EdtGroupName"       , "      w0.3   ")
          Anchor("BtnRemoveGroup"     , "x0.3         ")
          Anchor("EdtScriptletName"   , "      w0.3   ")
          Anchor("BtnRemoveScriptlet" , "x0.3         ")
          Anchor("DdbScriptletInGroup", "      w0.3   ")
          Anchor("BtnCopyToClipboard" , "x0.3            ")
    
          Anchor("TrvScriptlets"      , "      w0.3  h")
          Anchor("EdtScriptletData"   , "x0.3  w0.7  h")
        }
  }Else{
      Anchor("TrvScriptlets"      , "h")
      Anchor("EdtScriptletData"   , "wh")
    }
Return
;Here is the f_Anchor code:

/*
	Function: Anchor
		Defines how controls should be automatically positioned relative to the new dimensions of a window when resized.

	Parameters:
		cl - a control HWND, associated variable name or ClassNN to operate on
		a - (optional) one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
			optionally followed by a relative factor, e.g. "x h0.5"
		r - (optional) true to redraw controls, recommended for GroupBox and Button types

	Examples:
> "xy" ; bounds a control to the bottom-left edge of the window
> "w0.5" ; any change in the width of the window will resize the width of the control on a 2:1 ratio
> "h" ; similar to above but directrly proportional to height

	Remarks:
		To assume the current window size for the new bounds of a control (i.e. resetting) simply omit the second and third parameters.
		However if the control had been created with DllCall() and has its own parent window,
			the container AutoHotkey created GUI must be made default with the +LastFound option prior to the call.
		For a complete example see anchor-example.ahk.

	License:
		- Version 4.60a <http://www.autohotkey.net/~polyethene/#anchor>
		- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/
} ; V1toV2: Added bracket before function
Anchor(i, a := "", r := false) {
	static c, cs := 12, cx := 255, cl := 0, g, gs := 8, gl := 0, gpi, gw, gh, z := 0, k := 0xffff
	if (z = 0)
		g := Buffer(gs * 99, 0), c := Buffer(cs * cx, 0), z := true ; V1toV2: if 'c' is a UTF-16 string, use 'VarSetStrCapacity(&c, cs * cx)'
	If (!WinExist("ahk_id" . i)) {
		t := ogc%i%.Hwnd
		if (ErrorLevel = 0)
			i := t
		Else 		i := ControlGetHwnd(i)
	}
	gi := Buffer(68, 0), DllCall("GetWindowInfo", "UInt", gp := DllCall("GetParent", "UInt", i), "UInt", gi)		, giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int"), gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int") ; V1toV2: if 'gi' is a UTF-16 string, use 'VarSetStrCapacity(&gi, 68)'
	If (gp != gpi) {
		gpi := gp
		Loop gl
			If (NumGet(g, cb := gs * (A_Index - 1)) == gp) {
				gw := NumGet(g, cb + 4, "Short"), gh := NumGet(g, cb + 6, "Short"), gf := 1
				Break
			}
		If (!gf)
			NumPut(gl, gp, g), NumPut("Short", gw := giw, g, gl + 4), NumPut("Short", gh := gih, g, gl + 6), gl += gs
	}
	ControlGetPos(&dx, &dy, &dw, &dh, , "ahk_id " i)
	Loop cl
		If (NumGet(c, cb := cs * (A_Index - 1)) == i) {
			if (a = "")
			{
				cf := "1"
				Break
			}
			giw := DateDiff(giw, gw, gih -= gh, as := 1, dx) := NumGet(c, cb + 4, "Short")
        , dy := NumGet(c, cb + 6, "Short")
        , cw := dw, dw := NumGet(c, cb + 8, "Short")
        , ch := dh, dh := NumGet(c, cb + 10, "Short")
			Loop Parse, a, "xywh"
				if (A_Index > 1)
					av := SubStr(a, (as)<1 ? (as)-1 : (as), 1), as += 1 + StrLen(A_LoopField)						, d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall("SetWindowPos", "UInt", i, "Int", 0, "Int", dx, "Int", dy, "Int", InStr(a, "w") ? dw : cw, "Int", InStr(a, "h") ? dh : ch, "Int", 4)
			if (r != 0)
				DllCall("RedrawWindow", "UInt", i, "UInt", 0, "UInt", 0, "UInt", 0x0101) ; RDW_UPDATENOW | RDW_INVALIDATE
			Return
		}
	if (cf != 1)
		cb := cl, cl += cs
	bx := NumGet(gi, 48), by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52)
	if (cf = 1)
		dw := DateDiff(dw, giw - gw, 'dh') -= gih - gh
	NumPut(cb, i, c), NumPut("Short", dx - bx, c, cb + 4), NumPut("Short", dy - by, c, cb + 6)		, NumPut("Short", dw, c, cb + 8), NumPut("Short", dh, c, cb + 10)
	Return true
}
;============================== End Script ==============================

; =================================================================================
; Function: AutoXYWH
;   Move and resize control automatically when GUI resizes.
; Parameters:
;   DimSize - Can be one or more of x/y/w/h  optional followed by a fraction
;             add a '*' to DimSize to 'MoveDraw' the controls rather then just 'Move', this is recommended for Groupboxes
;   cList   - variadic list of ControlIDs
;             ControlID can be a control HWND, associated variable name, ClassNN or displayed text.
;             The later (displayed text) is possible but not recommend since not very reliable 
; Examples:
;   AutoXYWH("xy", "Btn1", "Btn2")
;   AutoXYWH("w0.5 h 0.75", hEdit, "displayed text", "vLabel", "Button1")
;   AutoXYWH("*w0.5 h 0.75", hGroupbox1, "GrbChoices")
; ---------------------------------------------------------------------------------
; Version: 2015-5-29 / Added 'reset' option (by tmplinshi)
;          2014-7-03 / toralf
;          2014-1-2  / tmplinshi
; requires AHK version : 1.1.13.01+
; =================================================================================
AutoXYWH(DimSize, cList*) {       ; http://ahkscript.org/boards/viewtopic.php?t=1079
  Static cInfo := map()

  If (DimSize = "reset") {
      Return cInfo := {}
  }

  For i, ctrl in cList {
      ctrlID := A_Gui ":" ctrl
      If (cInfo[ctrlID].x = "") {
          ogc%ctrl%.GetPos(&iX, &iY, &iW, &iH)
          MMD := InStr(DimSize, "*") ? "MoveDraw" : "Move"
          fx := fy := fw := fh := 0
          For i, dim in (a := StrSplit(RegExReplace(DimSize, "i)[^xywh]"))) {
              If (!RegExMatch(DimSize, "i)" . dim . "\s*\K[\d.-]+", &f%dim%)) {
                  f%dim% := 1
              }
          }
          cInfo[ctrlID] := {x: ix, fx: fx, y: iy, fy: fy, w: iw, fw: fw, h: ih, fh: fh, gw: A_GuiWidth, gh: A_GuiHeight, a: a, m: MMD}
      } Else If (cInfo[ctrlID].a.1) {
          dgx := dgw := A_GuiWidth - cInfo[ctrlID].gw, dgy := dgh := A_GuiHeight - cInfo[ctrlID].gh
          Options := ""
          For i, dim in cInfo[ctrlID]["a"] {
              Options .= dim . (dg%dim% * cInfo[ctrlID]["f" . dim] + cInfo[ctrlID][dim]) . A_Space
          }
          
      }
  }
}
