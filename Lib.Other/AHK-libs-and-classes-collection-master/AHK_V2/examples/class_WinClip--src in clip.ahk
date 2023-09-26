#SingleInstance force
SendMode "Input" ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir A_ScriptDir ; Ensures a consistent starting directory.
#KeyHistory 0
ListLines 0

#Include "..\lib\WinClipAPI.ah2"
#Include "..\lib\WinClip.ah2"


$f1::
toHtmlFormat(ThisHotkey)
{
  imgSrc:=A_Clipboard
  htmlToSet:='<img src="' imgSrc '">'
  WinClip.Clear()
  WinClip.SetHTML(htmlToSet)
}

$^+v::
{
  toHtmlFormat(A_ThisHotkey)
  send "^v"
}


return

f3::Exitapp
