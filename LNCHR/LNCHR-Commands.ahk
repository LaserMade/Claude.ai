lngui_run_commands(input){


if ((input == "todo") && (UsingAnyWorkcomputer)) { ; Work View Tasks (Outlook)
	close_lngui()
	tryrun('"C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE" /q /select outlook:tasks')
	return
}

if ((input == "cal") && (UsingAnyWorkcomputer)) { ; Work Calendar (Outlook) 
	close_lngui()
	tryrun('"C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE" /q /select outlook:calendar')
	return
}

if ((input == "com") and (UsingAnyWorkcomputer)) ; Work Compose (Outlook) 
{
close_lngui()
	outlookApp := GetOutlookCom()
	MailItem := outlookApp.CreateItem(0)
	MailItem.Display()
	return
}

if ((input == "inb") and (UsingAnyWorkcomputer)) { ; Work Inbox (Outlook) 
	close_lngui()
	tryrun('"C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE" /q /select outlook:inbox')
	return
}

if ((input == "task") and (UsingAnyWorkcomputer)) { ; Work Task (Outlook) 
	close_lngui()
	outlookApp := GetOutlookCom()
	MailItem := outlookApp.CreateItem(3)
	MailItem.Display()
	return
}

if (input == "?") { ; Help 

	tryrun("HELP-Commands.txt")
	Sleep(100)
	close_lngui()
	build_lngui()
	return
}

if (input == "a dir") { ; Launcher Dir 
	close_lngui()
	tryrun('%A_ScriptDir%\..\')
	return
}

if (input == "a edit") { ; Launcher edit in Pycharm 
	close_lngui()
	tryrun('pycharm64 %A_ScriptDir%\..\.')
	return
}

if input == "a kill" ; Kill 
{
	close_lngui()
	tryrun('%A_ScriptDir%\..\..\KillAHK.ahk')
	return
}

if input == "a rel" ; Reload 
{
	close_lngui()
	Reload()
	return
}

if input == "a show" ; AHK show scripts 
{
	close_lngui()
	tryrun('%A_ScriptDir%\..\ShowAHKScripts.ahk')
	return
}

if input == "a sta" ; Start 
{
	close_lngui()
	tryrun('%A_ScriptDir%\..\..\AHKstartup.ahk')
	return
}

if input == "a xk" ; Key Replace Excel Mgt 
{
	close_lngui()
	tryrun('%A_ScriptDir%\..\..\TextReplacementsGenerator.xlsm')
	return
}

if input == "a xl" ; Launcher Excel Mgr 
{
	close_lngui()
	tryrun('%A_ScriptDir%\..\LNCHR-CommandsGenerator.xlsm')
	return
}

if input == "awa" ; Awake 
{
close_lngui()
tryrun('%A_ScriptDir%\..\..\StayAwake.ahk')
return
}

if input == "mik" ; MiKTeX 
{
close_lngui()
tryrun('mpm')
return
}

if input == "not" ; Notepad 
{
close_lngui()
tryrun('Notepad')
return
}

if input == "pai" ; Paint 
{
close_lngui()
tryrun('C:\Windows\system32\mspaint.exe')
return
}

if input == "pho" ; Your Phone 
{
close_lngui()
tryrun('shell:AppsFolder\Microsoft.YourPhone_8wekyb3d8bbwe!App')
return
}

if input == "qt" ; Questrade IQ Edge 
{
close_lngui()
tryrun('https://www.questrade.com/home')
return
}

if input == "zoo" ; ZooMagnifier 
{
close_lngui()
tryrun('%A_ScriptDir%\..\..\ZooMagnifier.ahk')
return
}

if input == " h" ; Hibernate 
{
close_lngui()
DllCall("PowrProf\SetSuspendState", "int", 1, "int", 0, "int", 0)
return
}

if input == " l" ; Log out 
{
close_lngui()
Shutdown(0)
return
}

if input == " p" ; Power 
{
close_lngui()
Shutdown(2)
return
}

if input == " r" ; Restart 
{
close_lngui()
Shutdown(1)
return
}

if input == " s" ; Sleep 
{
close_lngui()
DllCall("PowrProf\SetSuspendState", "int", 0, "int", 0, "int", 0)
return
}

if input == "caps" ; CapsLock Toggle 
{
close_lngui()
toggleCapsLock()
return
}

if input == "doc" ; Documents 
{
close_lngui()
tryrun('"C:\Users\' A_Username '\OneDrive - FM Global\Documents"')
return
}

if input == "down" ; Downloads 
{
close_lngui()
tryrun('"C:\Users\' A_Username '\OneDrive - FM Global\Downloads"')
return
}

if input == "pro" ; Projects 
{
close_lngui()
tryrun('"C:\Users\' A_Username '\OneDrive - FM Global\Projects"')
return
}

if input == "rec" ; Recycling Bin 
{
close_lngui()
tryrun('::{1B635020-8269-11D8-9E2B-004005A9ABD2}#1.6#0"')
return
}

if input == "pc" ; This PC 
{
close_lngui()
tryrun('explorer =')
return
}

if input == "msc" ; MSc Folder 
{
close_lngui()
tryrun('"C:\Users\' A_Username '\MScThesis"')
return
}

if input == "pydir" ; Python 310 Dir 
{
close_lngui()
tryrun('"C:\Users\' A_Username '\AppData\Local\Programs\Python\Python310"')
return
}

if input == "pys" ; Pystuff 
{
close_lngui()
tryrun('C:\pystuff')
return
}

if input == "too" ; Tools 
{
close_lngui()
tryrun('%A_ScriptDir%\..\..\')
return
}

if input == "/r" ; Search Reddit 
{
lngui_enable_query("Search Reddit", make_run_ReplaceTexts_func("https://www.reddit.com/r/REPLACEME"))
return
}

if input == "c " ; Calculator 
{
lngui_enable_calc()
return
}

if input == "e " ; Everything 
{
lngui_enable_query("Everything", make_run_ReplaceTexts_func("C:\Program Files\Everything\Everything.exe -search REPLACEME"))
return
}

if input == "g " ; Google 
{
lngui_enable_query("Google", make_run_ReplaceTexts_func("https://www.google.com/search?num=50&safe=off&site=&source=hp&q=REPLACEME&btnG=Search&oq=&gs_l="))
return
}

if input == "i " ; Google Private 
{
lngui_enable_query("Google Private", make_run_ReplaceTexts_func("C:\Program Files (x86)\Google\Chrome\Application\chrome.exe -incognito https://www.google.com/search?safe=off&q=REPLACEME"))
return
}

if input == "m " ; Multi Search 
{
lngui_enable_query("Multi Search", make_run_ReplaceTexts_func("https://www.google.com/search?&q=REPLACEME","https://duckduckgo.com/?q=REPLACEME"))
return
}

if input == "o " ; Outlook 
{
lngui_enable_query("Outlook", OutlookSearch)
return
}

if input == "r " ; Run 
{
lngui_enable_query("Run", make_run_ReplaceTexts_func("REPLACEME"))
return
}

if input == "s " ; Spotify 
{
lngui_enable_query("Spotify", make_run_ReplaceTexts_func("https://open.spotify.com/search/REPLACEME"))
return
}

if input == "t " ; Torrents 
{
lngui_enable_query("Torrents", make_run_ReplaceTexts_func("https://www.google.com/search?&q=REPLACEME","https://www.google.com/search?&q=REPLACEME"))
return
}

if input == "td " ; TeX Doc 
{
lngui_enable_query("TeX Doc", make_run_ReplaceTexts_func("https://texdoc.org/serve/REPLACEME/0"))
return
}

if input == "w " ; Wolfram Alpha 
{
lngui_enable_query("Wolfram Alpha", make_run_ReplaceTexts_func("https://www.wolframalpha.com/input/?i=REPLACEME"))
return
}

if input == "y " ; YouTube 
{
lngui_enable_query("YouTube", make_run_ReplaceTexts_func("https://www.youtube.com/results?search_query=REPLACEME"))
return
}

if input == "cal" ; Calendar 
{
close_lngui()
tryrun('https://www.google.com/calendar')
return
}

if input == "dri" ; Drive 
{
close_lngui()
tryrun('www.drive.google.com/')
return
}

if input == "git" ; Github 
{
close_lngui()
tryrun('https://github.com/')
return
}

if input == "gma" ; Gmail 
{
close_lngui()
tryrun('https://mail.google.com/')
return
}

if input == "kee" ; Google Keep Notes 
{
close_lngui()
tryrun('https://keep.google.com/')
return
}

if input == "map" ; Maps 
{
close_lngui()
tryrun('https://www.google.com/maps/')
return
}

if input == "ovr" ; Overleaf 
{
close_lngui()
tryrun('https://www.overleaf.com/project')
return
}

if input == "red" ; Reddit 
{
close_lngui()
tryrun('www.reddit.com')
return
}

if input == "reg" ; Regex 
{
close_lngui()
tryrun('https://regex101.com/')
return
}

if input == "wea" ; Weather 
{
close_lngui()
tryrun('https://weawow.com/')
return
}

if input == "wha" ; WhatsApp 
{
close_lngui()
tryrun('https://web.whatsapp.com')
return
}

if input == "sou" ; Sound 
{
close_lngui()
tryrun('"' A_ScriptDir '\..\SoundCardCheck.ahk"')
return
}

if input == "c?" ; Calculator Help 
{
close_lngui()
tryrun('TODO')
return
}

if input == "cli" ; Clipboard 
{
close_lngui()
Send '^``'
return
}

if input == "cmd" ; Command Prompt 
{
close_lngui()
tryrun('"cmd.exe "')
return
}

if input == "col" ; Color Picker 
{
close_lngui()
Send '#+c'
return
}

if input == "cont" ; Control Panel 
{
close_lngui()
tryrun('control')
return
}

if input == "draw" ; draw.io 
{
close_lngui()
tryrun('"C:\Program Files\draw.io\draw.io.exe"')
return
}

if input == "emo" ; Emojis 
{
close_lngui()
Send '#.'
return
}

if input == "env" ; Environment Variables 
{
close_lngui()
tryrun('""C:\Windows\system32\rundll32.exe" sysdm.cpl`,EditEnvironmentVariables "')
return
}

if input == "ext" ; Extract text 
{
close_lngui()
Send '#+e'
return
}

if input == "ip" ; Python Console 
{
close_lngui()
SetWorkingDir("C:\Users\" A_Username "\Desktop") 
tryrun('ipython --no-banner --automagic')
return
}

if input == "k?" ; Keyboard Shortcut Help 
{
close_lngui()
tryrun('TODO')
return
}

if input == "mag" ; Magnifier 
{
close_lngui()
tryrun("C:\Users\" A_Username "\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Accessibility\Magnify.lnk")
return
}

if input == "mou" ; Mouse Highlighter 
{
close_lngui()
SendLevel(0)
Send "^!#m"
SendLevel(1)
return
}

if input == "mut" ; Mute mic and cam 
{
close_lngui()
Send '#+n'
return
}

if input == "resx" ; Resetart explorer 
{
close_lngui()
run 'taskkill /f /im explorer.exe'
run 'explorer.exe'
return
}

if input == "rul" ; Ruler 
{
close_lngui()
Send '#+m'
return
}

if input == "sni" ; Snip n Sketch 
{
close_lngui()
Send '#+s'
return
}

if input == "tm" ; Task Manager 
{
close_lngui()
tryrun('taskmgr')
return
}

if input == "top" ; Set Window on top 
{
close_lngui()
Send '#^t'
return
}

if input == "xmag" ; Exit Magnifier 
{
close_lngui()
tryrun('TODO')
return
}

if input == "zon" ; FancyZones 
{
close_lngui()
Send '#+``'
return
}

if input == "/find" ; View Tasks (Outlook) 
{
close_lngui()
TryCatchOutlook("Tasks",'C:\Program Files (x86)\Microsoft Office\root\Office16\OUTLOOK.EXE /finder')
return
}

if input == "/start" ; Startup Folder 
{
close_lngui()
run(A_Startup)
return
}

if input == "/a" ; Search Reddit AutoHotkey 
{
lngui_enable_query("Search Reddit AutoHotkey", make_run_ReplaceTexts_func("https://www.reddit.com/r/AutoHotkey/search/?q=REPLACEME&sort=new"))
return
}

if input == "/Hzn" ; Open Horizon (Manager) 
{
close_lngui()
Run("C:\Program Files\FMGlobal\Horizon\hznHorizonMgr.exe")
return
}

if input == "/winsp" ; Open WinspectorU.exe 
{
close_lngui()
Run("C:\Users\bacona\OneDrive - FM Global\AHK.Main\Winspector\WinspectorU.exe")
return
}

if input == "/scr4" ; Open Scriptlet_Library_v4 
{
close_lngui()
Run("C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v1\Scriptlet_Library_v4.ahk")
return
}

if input == "/o" ; Office Commands:`n[todo] (View Tasks)`n[com] (Compose New Email) 
{
lngui_enable_query("Office Commands:`n[todo] (View Tasks)`n[com] (Compose New Email)", make_run_ReplaceTexts_func())
return
}

if input == "/bmle" ; Open B&M LE Guide 
{
close_lngui()
tryrun('"C:\Users\bacona\FM Global\Operating Standards - Documents\general\B+M Loss Expectancy Guide - July 2023.xlsx"')
return
}

if input == "/uia2" ; AHK UIAutomation v2 
{
close_lngui()
tryrun('C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v2\UIA.v2\Lib\UIA.ahk')
return
}

if input == ".lnchr" ; Open LNCHR Excel Command Generator 
{
close_lngui()
tryrun('C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v2\LNCHR\LNCHR-CommandsGenerator.xlsm')
return
}

if input == ".rte2" ; Open RTF RTE Project Folder 
{
close_lngui()
tryrun('"C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v2\RTE.v2\Project Files"')
return
}

if input == ".min" ; Open Mining Folder 
{
close_lngui()
tryrun('"C:\Users\bacona\OneDrive - FM Global\1. Sites\1. Mining - DSP"')
return
}

if input == ".lib" ; Open AHK User Lib Folder 
{
close_lngui()
tryrun('"C:\Users\bacona\OneDrive - FM Global\Documents\AutoHotkey\Lib"')
return
}

if input == "/pers" ; Open Common_Personal 
{
close_lngui()
Run('C:\Users\bacona\AppData\Local\Programs\Microsoft VS Code\Code.exe' . ' ' . 'C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v2\Lib\Common_Personal.ahk')
return
}

if input == ".shell" ; Run EventHook_Messages.ahk 
{
close_lngui()
tryrun('"C:\Users\bacona\OneDrive - FM Global\Documents\AutoHotkey\Lib\EventHook_Messages.ahk"')
return
}

if input == ".min" ; Send Mining Folder 
{
close_lngui()
Send('C:\Users\bacona\OneDrive - FM Global\1. Sites\1. Mining - DSP' . '{enter}')
return
}

if input == "/mess" ; Open Message_Post_Send 
{
close_lngui()
tryrun('"C:\Users\bacona\OneDrive - FM Global\AHK.Main\AHK.Projects.v1\Horizon"')
return
}

if input == "music" ; Open Apple Music 
{
close_lngui()
tryrun('https://music.apple.com/us/login')
return
}

if input == "editl" ; Edit LNCHR Folder in VS Code 
{
close_lngui()
VSCodeEdit('C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v2\LNCHR')
return
}

if input == ".hznp" ; Edit HznPlus.v2.ahk in VS Code 
{
close_lngui()
VSCodeEdit('C:\Users\bacona\OneDrive - FM Global\Documents\AutoHotkey\Lib\HznPlus.v2.ahk')
return
}

if input == ".vsc" ; Open VS Code 
{
close_lngui()
Static vscode := 'C:\Users\' A_UserName '\AppData\Local\Programs\Microsoft VS Code\Code.exe '
Run(vscode)
return
}

if input == ".rich" ; Open Rich_Edit.v2 
{
close_lngui()
tryrun('"C:\Users\bacona\AppData\Local\Programs\AutoHotkey\AHK.Projects.v2\RTE.v2\Project Files\RichEdit_Editor_v2.ahk"')
return
}

if input == ".twin" ; Open TwinBasic Folder 
{
close_lngui()
Send('C:\Users\bacona\AppData\Local\Programs\twinbasic' . '{enter}')
return
}

}