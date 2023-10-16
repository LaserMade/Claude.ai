	;@include-winapi
	; --------------------------------------------------------------------------------
	#Include <Directives\__AE.v2>
	#Requires AutoHotkey v2+
	; --------------------------------------------------------------------------------

	; --------------------------------------------------------------------------------
	;                     Shift+Ctrl+WIN+O to Open OS
	; --------------------------------------------------------------------------------
	^+#o::
	{
		myGui := Gui(, "Quick Something[#] Open/Search",)
		myGui.Opt("AlwaysOnTop")
		myGui.SetFont("s12")
		myGui.Add("Radio", "vMyRadio Checked1", "Open Something[#]")
		myGui.Add("Radio", , "Open Something[#]")
		myGui.Add("Radio", , "Open Something[#]")
		myGui.Add("Text", , "Desired Open Something[#] `(e.g., 8-9`):")
		myGui.Add("Edit", "vSTDNumber x+m", ,).Focus()
		myGui.Add("Text", "x15", "Search for: (optional):")
		myGui.Add("Edit", "vSearchTerm x+m", ,)
		myGui.Add("Button", "x15 +default", "Open/Search").OnEvent("Click", ClickedSearch)
		myGui.Add("Button", "x+m", "Cancel").OnEvent("Click", ClickedCancel)
		myGui.Show("w600")

		ClickedSearch(*)
		{
			Saved := myGui.Submit() ; Save the contents of named controls into an object.

			If Saved.MyRadio = 1
			{
				outputos1 := "C:\Users\"
				outputos1a := "Open Something[#]"
				outputos2 := ".pdf"
				Run("AcroRd32.exe " outputos1 "" A_UserName "" outputos1a "" Saved.STDNumber "" outputos2)

				If (!Saved.SearchTerm)
				{
					return
				}
				Else
				{
					Sleep(1200)
					Send("^+f")
					Send("^a")
					Send("{Delete}")
					Send(Saved.SearchTerm)
					Send("{Enter}")
					return
				}

			}

			If Saved.MyRadio = 2
			{
				outputos1 := "Open Something[#]"
				outputos2 := ".pdf"

				DSArray := StrSplit(Saved.STDNumber, "-")

				IF StrLen(DSArray[1]) > 1
					DSS := DSArray[1]
				else
					DSS := "0" . DSArray[1]

				IF StrLen(DSArray[2]) > 1
					DSN := DSArray[2]
				else
					DSN := "0" . DSArray[2]

				Run("AcroRd32.exe " outputos1 "" DSS "" DSN "" outputos2)

				If (!Saved.SearchTerm)
				{
					return
				}
				Else
				{
					Sleep(1200)
					Send("^+f")
					Send("^a")
					Send("{Delete}")
					Send(Saved.SearchTerm)
					Send("{Enter}")
					return
				}
			}

			If Saved.MyRadio = 3
			{
				outputor1 := "Open Something[#]"
				outputor2 := ".pdf"

				Run("AcroRd32.exe " outputor1 "" Saved.STDNumber "" outputor2)

				If (!Saved.SearchTerm)
				{
					return
				}
				Else
				{
					Sleep(1200)
					Send("^+f")
					Send("^a")
					Send("{Delete}")
					Send(Saved.SearchTerm)
					Send("{Enter}")
					return
				}
			}
			myGui.Destroy()
			return
		}

		ClickedCancel(*)
		{
			myGui.Destroy()
		}
	}