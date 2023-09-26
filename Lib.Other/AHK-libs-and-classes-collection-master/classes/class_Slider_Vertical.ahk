﻿; Title:
; Link:   	https://www.autohotkey.com/boards/viewtopic.php?f=6&t=86663
; Author:	keylo
; Date:
; for:     	AHK_L

/*
Hi all, I want to share with you some vertical slider controls. Based on tmplinshi Horizontal Slidder- https://www.autohotkey.com/boards/viewtopic.php?t=80476
A few sliders are include in the Class, but you can add your own using ImagetoInclude.ahk or LoadPicture().
They are very smooth and no flickering.(see gif below)

*/

;~ Class_Slider_Vertical.ahk  by Keylo
;~ Based on tmplinshi Horizontal Slidder- https://www.autohotkey.com/boards/viewtopic.php?t=80476
;~ __________________________________________________________________________________________
/*--------------------------------------------------------------------
Availlable 64encoded sliders:
**********************************************
Create_Yellow_Slider_png(NewHandle := False)
Create_White_Slider_2_png(NewHandle := False)
Create_White_Slider_png(NewHandle := False)
Create_Silver_Slider_png(NewHandle := False)
Create_Red_Slider_png(NewHandle := False)
Create_Black_Flat_Slider_png(NewHandle := False)
Create_Black_and_Blue_Slider_jpg(NewHandle := False)
Create_Grey_Slider_jpg(NewHandle := False)
Create_GoldSlider_jpg(NewHandle := False)
Create_sliderthumb_png(NewHandle := False)
************************************************
_______________________________
Optional - you can also load your own picture using:  >>>>  hBitmap := LoadPicture("GoldSlider.JPG")
_______________________________________

To retrieve the slider position use: MsgBox, % slider.pos
To set the slider position use : slider.pos := 50
__________________________________________________________________________

*/--------------------------------------------------------------------


class Slider_Vertical
{
	__New(Options := "", val := "", hBitmap_thumb := "", ShowTooltip := false, SliderWidth := 24, SliderHeight := 54, Label := "", Gui := "",Var := "") {
		if !RegExMatch(Options, "i)\bBackground\w+\b") {
			if RegExMatch(Options, "i)\bc\K\w+", bkColor)
				bkOpt := "Background" bkColor
		}

		If Gui !=
		Gui =  %Gui%:
		Gui,  %Gui%Add, Progress,  %Options% %bkOpt% hwndHPROG Disabled -E0x20000 -Smooth vertical +Hidden, % val
		Gui,  %Gui%Add, Progress,  %Options% %bkOpt%  Disabled -E0x20000 -Smooth vertical , 0

		;~ Gui,  %Gui%Add, Progress,  xp yp  , % val

		;~ Gui, Add, Text, xp yp-10 h24 wp BackgroundTrans HWNDhpgTrigger,
		; Gui, Add, Text, x+15 w30 HWNDhRightText, %val%

		if RegExMatch(Options, "i)\bRange\K([\d-]+)-([\d-]+)", rng)
			this.rng_radio := Abs(rng2 - rng1) /100
		else
			this.rng_radio := 1

		GuiControlGet, pg, Pos, %HPROG%

		RegExMatch(Options, "i)h\d+", SliderPosY)
		RegExMatch(SliderPosY, "\d+", SliderPosY)

		y := pgH * (val/this.rng_radio/-100) + pgy + pgH
		y:= round(y-(SliderPosY*0.12))

Centerx := (pgX - (SliderWidth/2) ) + 4 ; 4 is a constant, the slider was slightly on the left
		Gui,  %Gui%Add, Pic, x%Centerx% y%y% w%SliderWidth% h%SliderHeight% HWNDhBtn , % "HBITMAP:" hBitmap_thumb

		this.hProg := HPROG
		this.hBtn := hBtn
		this.pgVal := val
		this.ShowTooltip := ShowTooltip
		this.Label := Label
		this.Var := Var
		; this.hRightText := hRightText


		fn := this.OnClick.Bind(this)
		GuiControl, +g, %hBtn%, %fn%
		GuiControl, +g, %hpgTrigger%, %fn%
	}

	OnClick() {
		GuiControl, Focus, % this.hBtn

		hSlider := this.hProg

		pre_CoordModeMouse := A_CoordModeMouse
		CoordMode, Mouse, Relative

		MouseGetPos,,,, ClickedhWnd, 2

		GuiControlGet, SliderLine, %A_Gui%:Pos, % hSlider

		GuiControlGet, sliderVal, %A_Gui%:, %hSlider%
		V := sliderVal

		if this.ShowTooltip
			ToolTip, %sliderVal%

		ControlGet, Style, Style,,, ahk_id %hSlider%
		ControlGetPos, X, Y, W, H,, ahk_id %hSlider%

		VarSetCapacity(R, 8)
		SendMessage, 0x0407,, &R,, ahk_id %hSlider%
		R1 := NumGet(R, 0, "Int")
		R2 := NumGet(R, 4, "Int")

		LastV := (ClickedhWnd = this.hBtn) ? "" : sliderVal

		while (GetKeyState("LButton"))
		{
			Sleep, 10
			;~ Clipboard = % H
;~ MsgBox, % H

			MouseGetPos, XM, YM
			V := (V:=(Style&0x4 ? 1-(YM-Y)/H : (XM-X)/W))>=1 ? R2 : V<=0 ? R1 : Round(V*(R2-R1)+R1)
			;~ v := v-20
			if (LastV="") {
				LastV := V
			} else if (V != LastV) {
				LastV := V
				if this.ShowTooltip
					ToolTip %V%

				this.pos(SliderLineH-(H*0.08) , SliderLineY) := V
			}
		}

		if this.ShowTooltip
			ToolTip
		CoordMode, Mouse, %pre_CoordModeMouse%

	}

	pos[pgH := "", pgY := ""] {
		set {

			if (this.Label != "" )
			gosub, % this.Label

			GuiControl,, % this.hProg, % value

			if !pgH
				GuiControlGet, pg, Pos, % this.hProg
				GuiControlGet, pbtn, Pos, % this.hBtn  ; will output pbtnX ,pbtnY , pbtnH pbtnW

			y := pgH * (value/this.rng_radio/-100) + pgY + pgH
			y:= y - (pbtnH /2) ;so the cursor is on the midle of the slider when moving
 ;~ Sleep 10
			; GuiControl, MoveDraw, % this.hBtn, x%x%
			;~ GuiControl, Move, % this.hBtn, y%y%

			GuiControl, Move, % this.hBtn, y%y%
	DllCall("InvalidateRect", "ptr", this.hBtn, "ptr", 0, "int", 0)
	;~ DllCall("InvalidateRect", "ptr", this.hProg, "ptr", 0, "int", 0)
	;~ Control, Hide ,, % this.hProg,A
	;~ DllCall( "SetWindowPos", UInt,hSlider, Int,1, Int,0, Int,0, Int,0, Int,0, UInt,0x4000 )
	;~ GuiControl, Show, % this.hBtn
			;~ WinSet, Top,, "ahk_id" . this.hBtn
			;~ WinSet, Bottom,, "ahk_id" . this.hProg

;~ WinSet, Bottom,, % this.hProg
			this.pgVal := value
			; GuiControl,, % this.hRightText, % value
		}
		get {
			return this.pgVal
		}
	}
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_sliderthumb_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 3864 << !!A_IsUnicode)
B64 := "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"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

;~ ***************************************************


; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_GoldSlider_jpg(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 5992 << !!A_IsUnicode)
B64 := "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"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

;~ **************************************

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Grey_Slider_JPG(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 12428 << !!A_IsUnicode)
B64 := "/9j/4AAQSkZJRgABAQEAYABgAAD/4RDmRXhpZgAATU0AKgAAAAgABAE7AAIAAAAJAAAISodpAAQAAAABAAAIVJydAAEAAAASAAAQzOocAAcAAAgMAAAAPgAAAAAc6gAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFdpbmNoZWxsAAAABZADAAIAAAAUAAAQopAEAAIAAAAUAAAQtpKRAAIAAAADOTkAAJKSAAIAAAADOTkAAOocAAcAAAgMAAAIlgAAAAAc6gAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADIwMjE6MDE6MTUgMjA6Mjk6MDIAMjAyMTowMToxNSAyMDoyOTowMgAAAFcAaQBuAGMAaABlAGwAbAAAAP/hCxtodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvADw/eHBhY2tldCBiZWdpbj0n77u/JyBpZD0nVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkJz8+DQo8eDp4bXBtZXRhIHhtbG5zOng9ImFkb2JlOm5zOm1ldGEvIj48cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPjxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PSJ1dWlkOmZhZjViZGQ1LWJhM2QtMTFkYS1hZDMxLWQzM2Q3NTE4MmYxYiIgeG1sbnM6ZGM9Imh0dHA6Ly9wdXJsLm9yZy9kYy9lbGVtZW50cy8xLjEvIi8+PHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9InV1aWQ6ZmFmNWJkZDUtYmEzZC0xMWRhLWFkMzEtZDMzZDc1MTgyZjFiIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iPjx4bXA6Q3JlYXRlRGF0ZT4yMDIxLTAxLTE1VDIwOjI5OjAyLjk5NDwveG1wOkNyZWF0ZURhdGU+PC9yZGY6RGVzY3JpcHRpb24+PHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9InV1aWQ6ZmFmNWJkZDUtYmEzZC0xMWRhLWFkMzEtZDMzZDc1MTgyZjFiIiB4bWxuczpkYz0iaHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iPjxkYzpjcmVhdG9yPjxyZGY6U2VxIHhtbG5zOnJkZj0iaHR0cDovL3d3dy53My5vcmcvMTk5OS8wMi8yMi1yZGYtc3ludGF4LW5zIyI+PHJkZjpsaT5XaW5jaGVsbDwvcmRmOmxpPjwvcmRmOlNlcT4NCgkJCTwvZGM6Y3JlYXRvcj48L3JkZjpEZXNjcmlwdGlvbj48L3JkZjpSREY+PC94OnhtcG1ldGE+DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIAogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgCiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAKICAgICAgICAgICAgICAgICAgICAgICAgICAgIDw/eHBhY2tldCBlbmQ9J3cnPz7/2wBDAAcFBQYFBAcGBQYIBwcIChELCgkJChUPEAwRGBUaGRgVGBcbHichGx0lHRcYIi4iJSgpKywrGiAvMy8qMicqKyr/2wBDAQcICAoJChQLCxQqHBgcKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKioqKir/wAARCACCAD8DASIAAhEBAxEB/8QAHwAAAQUBAQEBAQEAAAAAAAAAAAECAwQFBgcICQoL/8QAtRAAAgEDAwIEAwUFBAQAAAF9AQIDAAQRBRIhMUEGE1FhByJxFDKBkaEII0KxwRVS0fAkM2JyggkKFhcYGRolJicoKSo0NTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqDhIWGh4iJipKTlJWWl5iZmqKjpKWmp6ipqrKztLW2t7i5usLDxMXGx8jJytLT1NXW19jZ2uHi4+Tl5ufo6erx8vP09fb3+Pn6/8QAHwEAAwEBAQEBAQEBAQAAAAAAAAECAwQFBgcICQoL/8QAtREAAgECBAQDBAcFBAQAAQJ3AAECAxEEBSExBhJBUQdhcRMiMoEIFEKRobHBCSMzUvAVYnLRChYkNOEl8RcYGRomJygpKjU2Nzg5OkNERUZHSElKU1RVVldYWVpjZGVmZ2hpanN0dXZ3eHl6goOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4uPk5ebn6Onq8vP09fb3+Pn6/9oADAMBAAIRAxEAPwBGuYlYguMjrSfaov74rJmkxO/+8aj8ygDQ1OVZ9LuIojud4yFHqa4Wz0W/jgCvbkHHqK6rzKPMoAreE7eXT7u9e8TylkiCqT3O4Guj+1Rf3xWL5lHmUAbX2qL++KEuoZJvKWQF8btvtWL5lU2vvsuuW7k8GNhQBcuIpTcSYjb7x7VH5Uv/ADzb8q4/UfiZrsGpXEUYh2pIVH7sdM1W/wCFpeIPSH/v2P8ACgDufKl/55t+VHlS/wDPNvyrhv8AhaXiD0h/79j/AAo/4Wl4g9If+/Y/woA7nypf+ebflR5Uv/PNvyrhv+FpeIPSH/v2P8KP+FpeIPSH/v2P8KAO58qX/nm35Vz3iF3gvbYsCvB61j/8LS8QekP/AH7H+FVrjxNf+I5o21AJmLIXauO1ACapq2opq1yq3LACVgBtHr9Kqf2xqf8Az9N/3yP8K2tT0KF9UuWOtWiEyMdpRuOfpVX+wIP+g5af98N/hQBn/wBsan/z9N/3yP8ACj+2NT/5+m/75H+FaH9gQf8AQctP++G/wo/sCD/oOWn/AHw3+FAGf/bGp/8AP03/AHyP8KP7Y1P/AJ+m/wC+R/hWh/YEH/QctP8Avhv8KP7Ag/6Dlp/3w3+FAGf/AGxqf/P03/fI/wAKkgurm8nX7TIZCM4yAKuf2BB/0HLT/vhv8KSLT0tLxFjvYrvcDzGCMfnQA/VlT+17r5h/rW7+9U9qf3l/Out1CTShqM+/Q7d28w5YseearebpH/QAtv8Avo0Ac3tT+8v50bU/vL+ddJ5ukf8AQAtv++jR5ukf9AC2/wC+jQBze1P7y/nRtT+8v510nm6R/wBAC2/76NHm6R/0ALb/AL6NAHN7U/vL+dWtNQNfAKQeD0ra83SP+gBbf99Go4hayatH9jsY7QbDkIetAHaX/wAM/E8l/My6W5BckfMKr/8ACsfFP/QLf/voV2N18W9YS7kUWVqQGI71F/wt7Wf+fG1/WgDk/wDhWPin/oFv/wB9Cj/hWPin/oFv/wB9Cus/4W9rP/Pja/rR/wALe1n/AJ8bX9aAOT/4Vj4p/wCgW/8A30KP+FY+Kf8AoFv/AN9Cus/4W9rP/Pja/rR/wt7Wf+fG1/WgDk/+FY+Kf+gW/wD30Kzrrwnq2gatC2q2jQLIpCkkHJrvf+Fvaz/z42v61zfiDxpfeJ9WtYr2CGIRKzAx554oAwr/AFmzS/nVlmyHIOIjVf8Atuy/uz/9+TXYXEsv2h8bcbj/AAio/Nl/2f8AvkUAcn/bdl/dn/78mj+27L+7P/35NdZ5sv8As/8AfIo82X/Z/wC+RQByf9t2X92f/vyaP7bsv7s//fk11nmy/wCz/wB8ijzZf9n/AL5FAHJ/23Zf3Z/+/JqKC+hudcjaEOAIznehX+ddj5sv+z/3yK5zXJWGuWxfH+rPQYoA3riy11rmQxz6eFLHAZWzj86j+w+IP+e+m/8AfLf410LtD5jZljHP94U3dD/z1j/76FAGB9h8Qf8APfTf++W/xo+weIP+e+m/98t/jW/uh/56x/8AfQo3Q/8APWP/AL6FAGB9h8Qf899O/wC+W/xo+weIP+e+m/8AfLf41v7of+esf/fQo3Q/89Y/++hQBgfYPEH/AD303/vlv8a5rxBFfW2rW39oSW7sUO3yQR/M16Juh/56x/8AfQrhvHbINUsyjK3yHoc0AegNoWmOxZrGAknJJQUn9gaV/wA+Fv8A98CvA9T8T62uqXKpqEwUSsAN3Tmqv/CU67/0EZv++qAPob+wNK/58Lf/AL4FH9gaV/z4W/8A3wK+ef8AhKdd/wCgjN/31R/wlOu/9BGb/vqgD6G/sDSv+fC3/wC+BR/YGlf8+Fv/AN8Cvnn/AISnXf8AoIzf99Uf8JTrv/QRm/76oA+hv7A0r/nwt/8AvgV5/wDESxtrC+svskCQhlOdgxmvOf8AhKdd/wCgjN/31U9rqd9qUg+3XDzFc7dxzjigCpqY/wCJpc/9dW/nVXFFFABijFFFABijFFFABitHSf8AXf59KKKAP//Z"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Black_and_Blue_Slider_jpg(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 1860 << !!A_IsUnicode)
B64 := "/9j/4AAQSkZJRgABAQEAYABgAAD/4QEIRXhpZgAATU0AKgAAAAgABwEaAAUAAAABAAAAYgEbAAUAAAABAAAAagEoAAMAAAABAAIAAAExAAIAAAARAAAAcgE7AAIAAAAJAAAAhIdpAAQAAAABAAAAjpydAAEAAAASAAAA7gAAAAAAAABgAAAAAQAAAGAAAAABcGFpbnQubmV0IDQuMC4xNwAAV2luY2hlbGwAAAAEkAMAAgAAABQAAADEkAQAAgAAABQAAADYkpEAAgAAAAM1MAAAkpIAAgAAAAM1MAAAAAAAADIwMjE6MDE6MTcgMTU6MjI6MDMAMjAyMTowMToxNyAxNToyMjowMwAAAFcAaQBuAGMAaABlAGwAbAAAAP/bAEMAAgEBAgEBAgICAgICAgIDBQMDAwMDBgQEAwUHBgcHBwYHBwgJCwkICAoIBwcKDQoKCwwMDAwHCQ4PDQwOCwwMDP/bAEMBAgICAwMDBgMDBgwIBwgMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDAwMDP/AABEIAB0AKAMBIgACEQEDEQH/xAAfAAABBQEBAQEBAQAAAAAAAAAAAQIDBAUGBwgJCgv/xAC1EAACAQMDAgQDBQUEBAAAAX0BAgMABBEFEiExQQYTUWEHInEUMoGRoQgjQrHBFVLR8CQzYnKCCQoWFxgZGiUmJygpKjQ1Njc4OTpDREVGR0hJSlNUVVZXWFlaY2RlZmdoaWpzdHV2d3h5eoOEhYaHiImKkpOUlZaXmJmaoqOkpaanqKmqsrO0tba3uLm6wsPExcbHyMnK0tPU1dbX2Nna4eLj5OXm5+jp6vHy8/T19vf4+fr/xAAfAQADAQEBAQEBAQEBAAAAAAAAAQIDBAUGBwgJCgv/xAC1EQACAQIEBAMEBwUEBAABAncAAQIDEQQFITEGEkFRB2FxEyIygQgUQpGhscEJIzNS8BVictEKFiQ04SXxFxgZGiYnKCkqNTY3ODk6Q0RFRkdISUpTVFVWV1hZWmNkZWZnaGlqc3R1dnd4eXqCg4SFhoeIiYqSk5SVlpeYmZqio6Slpqeoqaqys7S1tre4ubrCw8TFxsfIycrS09TV1tfY2dri4+Tl5ufo6ery8/T19vf4+fr/2gAMAwEAAhEDEQA/APwB+XH8VKAh7tXqPg39jX4pePtPtbjR/A+qXsF3GskLhUXzFYAqfmYdQRXomj/8EhP2lvEu1bH4Q69cbhkFJLb+fm11/U8Tbn9lK3ozjeY4FPldeN+3Mv8AM+bAI8ffb/vgf40n7v8A26+sh/wQs/a1C7v+FH+JtpGcme1/+PVzXij/AIJNftHeClZtS+EuuWu3rl7d8flIazp4WvN2hBv5Mp5hglrOtFfNHz5pX2c6nbeYITH5q7t27GMjOaK9M/4Yw+KunanHFP4E1OKQSqmJUVRuJGM/NRTlgcXfShJ/JlU8wy1r38VBf9vI0vD3xZvNO0Ozhj+JF9a+VAiCNUkHl4UDHXt0rQh+NWtQf6v4v6tHnsrTL/WotM/Yn/tLTbe4/wCEm2faIlk2/wBnZ25AOM+b71P/AMMN/wDU0f8AlN/+210f2tjkuVVp2/xP/M5JZLl0nzSoQv8A4I/5Dj8dPEA/5q5rX/gZN/8AFVG3xp1pzlvi/qpPuZj/AFps37EflSxr/wAJN984z/Z3T/yLUh/Yawf+Ro/8pv8A9tojm2Nj8Naa/wC3n/mKWSZdL4sPD/wCP+RFD8W9QN5HJL8Vr6ba4Yqyyndg+5op8n7EAgRnbxNuCDcR/Z2M4/7a0VLzTGPerL/wJ/5lRyXL1oqEP/AY/wCR/9k="
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Black_Flat_Slider_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 2204 << !!A_IsUnicode)
B64 := "iVBORw0KGgoAAAANSUhEUgAAAEkAAACUCAYAAADf0wQtAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAPdEVYdEF1dGhvcgBXaW5jaGVsbFqlMRYAAAAgdEVYdENyZWF0aW9uVGltZQAyMDIxOjAxOjE3IDE1OjA3OjQ03XjTcwAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAWdSURBVHhe7Z1ZTuwwEEXjMDWIbSAxixmBmFfAElgsO+EfgRBipl/f6pRxmnLiX17dI1kZunlSjqo8pv3C8vLycG5urvr+/pYyMzNTvb+/V7Ozs9Xn52flmY+Pj6qu66qempqqXl9fRQhuvL29VcPhsPmaX6anp6UgaGqcIJJwhDn9AmR5Js2q+uvrK6YVUmxxcVHOEVWegSRkWAihEhMQghTDBy8vL3KOD72DjEJ15DtcCqGkAiipAEoqgJIKoKQCKKkASiqAkgqgpAIoqQBKKiBsbGwMMZidHNB6H+RiYIsBPwiHh4cyw2YJ8T4ToJOP4fz8nJIM0tnZcHFxIekmF80xGnQeSXh+FKm4VQqOqUHvxGA5OzuTMytqPEdSrLQRTfv7+2zdDFQSCGtra6Yk78BHTLf19XVWQj2wx10AJRVASQVQUgGUVEDY2tpi62agXQDpL+osAMkThyWkjY44pFxdXVGSAYYlECRvujX3iAEkyXF3d5eR1ENYWVmhJANt3eR8dXWVkjqQihurJc01ycCpkgLYuhUQNjc3GUkG2k8CMn0rZ6RFbNnQoZQz8gssc8s73KMed9jb22MkGegPAGQMh2Vu6Qs0+UfGQBLqJZF0eXnJdbcMsV46PT1lJBlEQXCDLoAlyXsk4ddbeH6puHMruN4lpZEUuwB6E6TnXpEIaoKEY7cMaaBwFiBDKok97gKYbhla6cYBbj+cKsnQiiQuc9u0JOkAVy6aY/oFr2CaBL1umXzreo/bM0WzAMCzrOL5JEbUGHn1RgXpUeV4liQR1ASPDEv0YhJKaiRhmduS5FlQirjBsEQF6ZGCfipuwB53BmwLhC6AzFDyrRKbtPrhfFIGqYu0LC0tUZKB/lBZWjm+opwnSrq5uaEkA6RZbN1ub2+HsRZvPsCWitgZDyHnFXiAk8FgUIWRjKH2CSAJH2ArRe/7TM7Pz8cdS8Pj4+MQfQK5GEnCB7oJJSLKK9h7EwEjXu7u7iSSUIBK0i95BdmEaggewvX19RAbcALUQZCkX9BtXj2C50fKPT8/j7sAOEEkIYI0kjTUvILqBlvcPjw8jBcCnp6eZKyCmhzhpRGlTaBHUD9D0v39PRcncyCTIAqFy9wZkE3aoFFSBhUk0cRlbhtttKSTzTqpn7C9vU1JBugnAUm3o6MjSjKAJG3d4p5upI0O+KUcHx//Wi0BOPfcmUTFjWgSWTs7O2JiUpB3IAkdSkm7dCGAcn6AixhJXV0A79K0ujElxQ8ZWeKg1eOerKg9S5I0Gz2/DE2YbjYyI6mSusZujKSmn8RI6gayOFWSAc2/ls4XJphuTbodHBxQkkFLEt7jbu7/wrOkdI5b3uNu7v/Cs6TWqzdde7p5lgSipK5JN8+SWlMl/JWSDSRBkEji27c2Kkgk8cVSG8hROsdu6Re9gXQD0gXgupuNDEcgCKUr3fBFr6Qte2fF7T3dYsXNnbhsEEkQJGl3cnKSlZSGnEdiJHWN3bwDQaCONbhRyBju7J4BUyWYCcC7pPIfTjX3SYLURaNsktUSDkv64euAPUhEcVhio+kGuKSUIW3dWSdlgCREk5luuKlHz30lNP9KlKTmgB49S0qDpFUn6U3PchRIisGCOglSUjGMpDYyVTIpifwEiKQdpkpUEkW10ZRr7cRFUW2KVnA901oI6PoBjlbgHmlJ6hq7eZaUwhdLM+DZNUg6I8m7JIWzABm0ZQOskzJAkkzd9lXcZAzTrQBKKoCSCqCkAiipAEoqoMaENwrWvnXvJGwylSJ9BaP8ZaznQUmBC9yrsZkUOk66+R06kLgG1h/+7+gzwwuCBtTYARBbc8Ea9nJDRGH7REsOBKblL9P3LAsLC3E3shpblenruNiAE/Z0T7e+f+h/YvJZUZBdCJgaxvQCH+AakYWo8g6CZzAYVP8AQntokHA/1toAAAAASUVORK5CYII="
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Red_Slider_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 2540 << !!A_IsUnicode)
B64 := "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"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Silver_Slider_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 1824 << !!A_IsUnicode)
B64 := "iVBORw0KGgoAAAANSUhEUgAAABMAAAAjCAYAAAB2KjFhAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAPdEVYdEF1dGhvcgBXaW5jaGVsbFqlMRYAAAAgdEVYdENyZWF0aW9uVGltZQAyMDIxOjAxOjE3IDE1OjE4OjIw6UyJCgAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAASASURBVEhLfVZLT1tXEJ65fmDHPIIhjiVHVEIVFSv+Vh9pdm13/Iak6UPdtF20XbT5BSiq1EZpkVixitggISQQiDomtrHNfZx+35x77AtpOuh47j1n5pv3uej29rYbX0/EOSek/+JxHNuzSsl4FEWiqrOFvc3NTdGnX3/leEjK7BdKuVBQco7is33VknH8Gi+Xy9JoNET/ePGnW15eNg8CGEGKK8sPgreQ8L/5a7PZlL29Pe/Z4uKiCaZTYe9F0TOez5b3NICNx2M5OjoS/eyLzw2MRAd8GDMgUhSVjQew257VajU5OzsTffjoU1ev171iITTzCFvkaepB1HmQQFHuYbVasSLphx9/5La2tnJl7xWJypl4kGq1Co79zLsSwqQ1wmdI6spKU/T7H38ohHnTsicEH6kppGlqOwwbNYRhtEqmZmww6In+9MvP7vLy0oRcXnJS4CSn8NGl5qVvC4C4krisZJWejK+k3W6Jvvz7L/fPxWuvBA9IRSBS6pL8KZuCuSySNPH5vJ6M7Cza39+3puMqJr9IxTzaQmjkgdin1Ndfn/3m0oTuIy/QCYqeW3pZtmnOLFSp4Lycg6ok8URarVXRx18+cUlM96Fcmnnmuc8hc5amcQ6GinOQAIa8mMH4eiwbG++LZjB1cdE1pUw9UHGRmDN6FkILYCwA9+YbdezCocdPnrr19XXbTCFGfnvBIDoOpzQAoCgiCIynKELqGypORqIbH2y6TqdjSgQLuTFPkC7uK8KnkyEFigjEwbMwEZBdXLoj+snDR67f70/Bgje2OKygJPNezaqNMO1u82HOVarSedCWqFTyLlOAgnwvlypSKVets7nKeOY+18w7XxwuRnJ6eiraebDmarU75sG0NQAeiO9IrT1zCqxdEJ7NJ6cAnlXKkbzpvxa912q7brdnm0FpSgEUObtBeUsQzChLpFpD037z7Xeu1WrbHiZjSgQ3BVI+ZiQLDU3LivoWQZ5RgPmFOdE4yVwc+wS/5VkAY0TEzo/JmI1gYzhwqCaMXI0mrtd7Y2AU451WojVy/DGPvHKs1xAO2sqQHQyppSGSpaW6XI8nooPBlbvs9a0ivC3jFN2eoMcIQh9gnrNrxcFPgn7hdY3BAveeo8A2Bfr8+e9uOBjlOQq5okWG4rl5A2IFg1w44xilSSL3798THSHM4XBohxHmLfRRICozZP+S5xAUZMgX5vkNwDOEWQxsYtnxjOgEF/pz9p57SZraxH7CawxXtms0FrwHWJzJItGyMinIoL85COpluYzwoanXq6L4gLpXrw5M0At7AYJwfMgxc7myvwiKoKT6XA237V3Rw8NDhOm9CZxkIGEOMQEGhmoGgzZOOS0v3fX/a+DAClCkYDEQ1KdgN898QUq4kuwbQLDz83PbVPXfgrcIvZag/FRm6CR7R3X5zgquruIbgGbFBPRM4F1gjOj/wJrIV7eLW+Pk5MQdHx/nIPmH5RYRjBNC8mC8rjEDCJvvK/iX6uDgQHR3d3fatO8CY5ihOCwKwewdnvH9vbU12dnZkX8B5xS+NXygpZsAAAAASUVORK5CYII="
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_White_Slider_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 1476 << !!A_IsUnicode)
B64 := "iVBORw0KGgoAAAANSUhEUgAAADIAAAAdCAYAAADoxT9SAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAPdEVYdEF1dGhvcgBXaW5jaGVsbFqlMRYAAAAgdEVYdENyZWF0aW9uVGltZQAyMDIxOjAxOjE3IDE1OjExOjMwjV/3wQAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAAN6SURBVFhH3VhtT9swED47LWUS/P+fMk3aD5gm7SNfkKYxaIHurRIrfUnieM9zjtskJGXQaQ086LBjp/ZzvrPvHPPl84UfDAZCMSaRLMvEWisBBdpMWRfxZdVKIkVRhAeA71C89ypJkshsNtM+1tM0lZOTEzk9PZXVaoV3vfY9BRy3Cs7HsefzuUynUzHrZerJSYnkTo6OjjYki60ONZhiN5Gqkq1I4kI9DxbTc44kMZLnudx8m4qNq1mVfUGL7pJ/gSpP1i21SwQVXWS6RygpFr5UlS1Cf5cYY3dKc9ynCj0TI2EsMIcQNvo1wfJRt/gLxDG7ZH9wwfC/apVskWLssIouLXTTR6A5wNSVM8Vu93iUrN0SeDLIpdyjBnuEh9Pt91tYiEZSk4f9UVHy2diO1S57wdcXkYtGL9JW+pxKY5LY3jdsFgXcortaahMfKI+isSKHQHXBI2+Trpyn27GTe0Q1DUfYFm3kG/vmf8IOQpDlUe59IRdXF2JWi8z7HD6GRm7ihMGq6U+bXR+ghjuoIhaB0GnduVyuridiHPQostISCOUWx7JzDZItG+yQivDU45YgZ1rkenqL43ddqEWia+l7IcZssVGEZalAjxS5nIzFjC9vvDgvo9FIimAthJsui/RDEQP3dy6QzbJUxjfXYt69fe9X90sZDocbRcTHSomeKZKDKK3B7Bfk5PfiXszHD5/8epXK8fGx7hHiQXLaQ9fSI7d0rR+zX2JmP+9YV9dyqVPfGyD019AzRRwIazTnSQuqX8dX4fhN7EB9LsEf0b1HAvQ0PuQe4cEEvtEiVKTO8AWjGcNfLF6PRcqyBu6BRlbSe7xui7xE7HPpPCBwK9QMnSWfEVMSGMXjTB4NE8kdcnyEEp7PFFxMgtBuFdGbI1L+LrGMOw6/h8Q2n2NaiD7z9zsEb2zqej+HbPoxbFZkyLdE1vlaRm+GkoG38SmS3zL75WWFH+hiQtYMhBE6AQMi+1tKawaYm8xBiQc8yvj8ILNugS4i0LyxagDE5B5j8jZInozwkwnuI+tljvdx50W4Z0ftA1rH0RXeUG1aS37MYMQlD6t5EVqZB6Gfz5FoF5oKNEGLQI3yM6+Rs7MzMfO7pSd5ZpLbsN8YqKoQViREURKjSu2l1wy6/hw+qFGZsBRd4CpHRC5R+YKWgHWZG7JvsVjI+fm5/AElRzJuJTDCZgAAAABJRU5ErkJggg=="
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_White_Slider_2_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 1892 << !!A_IsUnicode)
B64 := "iVBORw0KGgoAAAANSUhEUgAAACUAAAAvCAYAAABkBQNlAAAAAXNSR0IArs4c6QAAAARnQU1BAACxjwv8YQUAAAAJcEhZcwAADsQAAA7EAZUrDhsAAAAPdEVYdEF1dGhvcgBXaW5jaGVsbFqlMRYAAAAgdEVYdENyZWF0aW9uVGltZQAyMDIxOjAxOjE3IDE1OjEzOjUxBguoWgAAABl0RVh0U29mdHdhcmUAcGFpbnQubmV0IDQuMC4xNzNun2MAAASzSURBVFhHvZjJSixLEIYjWz3Os6ggCj6BO9/AF/C1fAgXLgVBxIUuXTmgONvOOCC2irO2c976QqMp5HI2h6iApKqrq4mv/z8yMqvCwMBA/Pj4kMfHR2lsbJQYo7y/v8vX15fkcjnxjLKyMqmurpbPz0+BgSgWixKGh4djXV2dXF1dSVtbm7y9vcnT05NwDTjPuL+/l9raWs0ZQtBxfHws4ejoKPb09MjFxYW0t7cr0MPDg3R2dqp6noEr/PmXlxepqqpSqNnZWQm3t7cRRbjhz58/+sXr66vexDXPqKyslLu7O7UQAXBqbW1NwvX1tUJRQ2kofoDXngGMQeFQa2urbGxsSCgUCiWoiooKhcJjALnmGfxxSqWmpkaVamlpkc3NTQmnp6cRZbCK2QAUkABmYR8KmX1NTU2ytbUl4eDgQKGsBRhUeXl5JlDPz886A1GsoaFBtre3JeTz+Uj1p/sSPQPVvKFwA0EMqr6+XnZ3dyWsr69HGhZQqGRKmWqewR8nl0Fx3N/flxwzDCAG5+lh17Ma5MSlMDMzozVFDTHrOKIS1nnbZ9aRByBqjJaQgyytjtH+vuYxyJMedj1MTU1FFLKiQylqyVslgnz0KLOOVURbwsTEhELRLJmFFB+DG72DvECZavSrnZ0dCWNjYwqFn8zCLKEMxOzjnJagNcUwP9PDZoXXsDzGYBw5m2UMuzl97jmI/8tdgkrfYGGfvUY60p/D5ORk7Ovr0x0fNYWvbIuTLY3OxL/Fv26XqV1yYNvl5aX09vZ+r31DQ0ORGZDsQEvLCkdWbRqbZwCUril2u8mmU0JCG/ESEP45X3K08yyCXDBw1D1dci3+bpYmaVaRzo+lyeeQfI4lpUoz4Oc8y7CcIZFLt8MWkOIzAWgWYaIwFCqxSh9GfyuThvMM8hKWm9IJg4ODkQ3W+fm5ErMosuwAxHr4t+D+fwkDQgBydnR06HIXkv1LNABWbSQkGeRQewY5yEv54BY9cnV1VcL4+Lju0e1LqIGyc89AAP44+RGGpp08yEgYGRmJPOYgGyD0CQI5s4AiB080QDU3N8vJyYmE0dFR3Q4jHcSQ4zWA5rlXmFJAkY+nmcPDQ8nxBcn5MuthuXEHp7Sbcw1iK2yTMz0rPAfqkBsYnGJQ27pLYHdAKwAMYm603uUZlAsg5CMXGwN9wTE9PV2afTZFCc75N55BDlRiUiECwugjFsXFiytg7MhMwHPoPQcKAcIWiaMxhIWFBZ19Vk8EyvEP+JFnoBCioBIMlI4+zaysrOiC/BvK7PQM8ti7VQBRK5/Pfy8zkBoUR6hRChs9AxisIx/npULnVRDJsYo6Aszs81aKnIBYR0c1fee5t7en2+E0FFJy7q0UxU5LYJkjF2vf8vKyhOQpJuH5LuisoQigeEhBGF4vLi0tSTg7O4sQEwAx8Bcojp4BCFDs5xCGBXlxcVFCIp0+OPD2H08LhYJ0d3crPYCeQV5qF/uYbNinUEmRRaY/EFzkuQsZse7m5ubn5z5BDvoUiuEMLWFubk5C4mG0t2lsR5ESO1kPu7q6fn7uE+QAhpw20+fn5yX09/dr82TQUZER22gL3oUOEDmZWAiBUsViUf4Dm1qCwgc+4b0AAAAASUVORK5CYII="
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_Yellow_Slider_png(NewHandle := False) {
Static hBitmap := 0
If (NewHandle)
   hBitmap := 0
If (hBitmap)
   Return hBitmap
VarSetCapacity(B64, 2412 << !!A_IsUnicode)
B64 := "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"
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
VarSetCapacity(Dec, DecLen, 0)
If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
   Return False
; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
Return hBitmap
}