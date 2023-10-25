#Requires AutoHotkey v2
#Include <Directives\__AE.v2>
; --------------------------------------------------------------------------------

; --------------------------------------------------------------------------------
/**
 * @function Common_ExpenseReport
 */
; --------------------------------------------------------------------------------
#HotIf WinActive("Chrome River - Google Chrome")
	~*+s::Send('+{Tab 2}' . '{Enter}')
	; SendMode("Event")
	:*:bt::Business Travel -{Space} 
	:*:air::
	{
		Send('Business Travel - Airfare -' . A_Space)
		Send('{Tab 3}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down}')
		Sleep(100)
		Send('{Down}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		; Sleep(50)
		Send('{Tab 4}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down}')
		Sleep(100)
		Send('{Down}')
		Sleep(100)
		Send('{Down}')
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		Send('+{Tab 7}')
	}
	:*:seatf::
	{
		; Send('Business Travel - Airline Fee - Seat Upgrade - ')
		Send('{Tab}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 5}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		; Sleep(50)
		Send('+{Tab}')
		Send('Business Travel - Airline Fee - Seat Upgrade - ')
		return
	}
	:*:wifiair::
	:*:inter::
	{
		Send('Business Travel - Airline Fee - Internet - ')
		Send('{Tab}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 8}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		; Sleep(50)
		Send('+{Tab}')
	}
	:*:bags::
	{
		Send('Business Travel - Airline Fee - Baggage Fee -' . A_Space)
		Send('{Tab}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 3}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		; Sleep(50)
		Send('+{Tab}')
	}
	:*:hotel::
	{
		Send('Business Travel - Hotel - ')
		Send('{Tab 2}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 3}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		Send('{Tab}' . '{Space}')
		; Sleep(50)
		Send('+{Tab 3}')

	}
	:*X:meal::Send('Business Travel - Meal -' A_Space)
		
	:*:car::
	{
		Send('Business Travel - Car Service - ')
		Send('{Tab}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 3}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		; Sleep(50)
		Send('+{Tab}')
	}
	:*:rent::
	{
		Send('Business Travel - Rental Car - ')
		Send('{Tab}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 4}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		Send('{Tab 4}' . '{Space Down}')
		Sleep(100)
		Send('{Space Up}')
		Sleep(100)
		Send('{Down 3}')
		; Sleep(100)
		Send('{Enter Down}')
		Sleep(100)
		Send('{Enter Up}')
		Send('+{Tab 6}')
	}
	:*:mob::Business Mobile
	:*:bint::Business Internet
	:*:comp::Company Vehicle
	:*:off::Office Supplies - risk file organization folders for site visit efficiency 
return 
#HotIf