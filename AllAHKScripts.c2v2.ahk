DetectHiddenWindows(true)
oList := WinGetList("ahk_class AutoHotkey",,,)
aList := Array()
List := oList.Length
For v in oList
{
   aList.Push(v)
}
scripts := ""
Loop aList.Length {
   title := WinGetTitle("ahk_id" aList[A_Index])
   scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
}
MsgBox(scripts)