﻿#Include '..\XCGUI.ahk'
DllCall('LoadLibrary', 'str', '..\' (A_PtrSize * 8) 'bit\xcgui.dll')
XC.InitXCGUI()
m_hWindow := CXWindow(0, 0, 300, 200, "炫彩界面库窗口")
CXButton(10, 5, 60, 20, "关闭", m_hWindow).SetType(XC.TYPE_EX.button_close)
hEle := CXEle(20, 50, 100, 100, m_hWindow)
; XWnd_RegEventC(m_hWindow, XC.WM_DESTROY, "OnDestroy")
m_hWindow.ShowWindow(SW_SHOW := 5)
XC.RunXCGUI()
XC.ExitXCGUI()
