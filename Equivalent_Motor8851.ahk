#Requires AutoHotkey v2.0
#Include <Directives\__AE.v2>

#HotIf WinExist(A_ScriptName) ; && WinActive('ahk_exe [program].exe')
; add (or update) the .exe that this script is for. this will allow the script to only perform when this script is running (WinExist()) AND when the other .exe program is running and the active windown (WinActive()) => the hotkey is only active with both conditions = true

	*F2::Equivalent_Motor8851()
	/**
	 * @function Equivalent_Motor8851()
	 * @description use the F2 key to press the w key, and toggle between shift and control to do something for a work program.
	 * @source https://www.autohotkey.com/boards/viewtopic.php?style=19&t=88493
	 * @author Original .:	boiler
	 * @author Credit ...:	GroggyOtter - cause he does all kinds of stuff and should get credit for it
	 * @author Credit ...:	OvercastBTC - converted to v2 from v1 and personalized
	 * @returns {void} 
	 */
	Equivalent_Motor8851()
	{
		static KeyNum := 0
		OutputDebug('Initial 1: ' KeyNum '`n')
		KeyNum := (KeyNum = 3) ? 1 : KeyNum + 1
		OutputDebug('Initial 2: ' KeyNum '`n')
		OutputDebug(	'W: ' 		. GetKeyState('w') . '`n'
					. 	'Shift: ' 	.  GetKeyState('shift') . '`n'
					. 	'Control: ' .  GetKeyState('ctrl') . '`n'
					)
		
		Switch KeyNum
		{
			case 1: 
			{
				OutputDebug('C1: ' KeyNum '`n')
				Send('{shift up}')
				Send('{ctrl up}')
				Send('{ w down }')
				OutputDebug('C1: ' KeyNum '`n')
				OutputDebug(	'W: ' 		. GetKeyState('w') . '`n'
							. 	'Shift: ' 	. GetKeyState('shift') . '`n'
							. 	'Control: ' . GetKeyState('ctrl') . '`n'
							)
			}
			case 2:
			{
				OutputDebug('C2: ' KeyNum '`n')
				If (!GetKeyState('w'))
					Send('{w down}')
				Send('{ctrl up}')
				Send('{shift down}')
				OutputDebug('C2: ' KeyNum '`n')
				OutputDebug(	'W: ' 		. GetKeyState('w') . '`n'
							. 	'Shift: ' 	. GetKeyState('shift') . '`n'
							. 	'Control: ' . GetKeyState('ctrl') . '`n'
							)
			}	 
			case 3: 
			{
				OutputDebug('C3: ' KeyNum '`n')
				If (!GetKeyState('w'))
					Send('{w down}')
				If (GetKeyState('shift'))
				{
					Send('{shift up}')
					Send('{ctrl down}')
				}	
				OutputDebug('C3: ' KeyNum '`n')
				OutputDebug(	'W: ' 		. GetKeyState('w') . '`n'
							. 	'Shift: ' 	. GetKeyState('shift') . '`n'
							. 	'Control: ' . GetKeyState('ctrl') . '`n'
							)
			}
		}
		return
	}

	*Esc::ExitApp()

	#HotIf