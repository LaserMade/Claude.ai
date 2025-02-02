﻿; Title:
; Link:		https://github.com/acmeism/RosettaCodeData/tree/master/Task/Equilibrium-index/AutoHotkey
; Author:
; Date:
; for:     	AHK_L

/*

list = -7, 1, 5, 2, -4, 3, 0
MsgBox % Equilibrium_index(list)

*/


Equilibrium_index(list, BaseIndex=0){
	StringSplit, A, list, `,
	Loop % A0 {
		i := A_Index	, Pre := Post := 0
		loop, % A0
			if (A_Index < i)
				Pre += A%A_Index%
			else if (A_Index > i)
				Post += A%A_Index%
		if (Pre = Post)
			Res .= (Res?", ":"") i - (BaseIndex?0:1)
	}
	return Res
}