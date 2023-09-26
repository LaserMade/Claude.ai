#SingleInstance force
#Include <Directives\AE.v2>
#Requires AutoHotkey v2+
AE.__Init()
global listOfEntries := Array() 

;dummy values, need to be set somewhere else
listOfEntries.Push("test1")
listOfEntries.Push("test2")
listOfEntries.Push("teOPS")
listOfEntries.Push("test3")
listOfEntries.Push("smthElse")
listOfEntries.Push("notAtest")
listOfEntries.Push("maybe?")


; --------------------------------------------------------------------------------
; type to reduce search results, tab to cycle through possibilities, enter once to lock choice, enter again to confirm choice
; --------------------------------------------------------------------------------
pickFromList()
{
    ; a := classAutoPath.New()
    a := classAutoPath.__New

	while true 
	{
		if(a.ready || a.error)
			break
		sleep(500)
	}

	if(a.error)
		return 0
	if(a.ready)
		return a.choice      
}


Class classAutoPath {
	path := ""
	ready := 0
    choice := ""
	error := 0
	list := []
	listPrev := []
    acceptedSuggestion := false
	
	static __New(guiShowOpt := "w400") {
		
		;Gui stuff
		this.gui := Gui(guiOpt)
		this.editBox := this.gui.Add("Edit", "w400")
		this.editBox.OnEvent("Change", (*)=>this.editChanged())
		this.displayBox := this.gui.Add("Text", "+readonly -wrap r20 w400", "")
        ;adds invisible button that gets triggered by hitting enter by default
        this.btn := this.gui.add("Button", "Default w0", "OK")
		this.btn.OnEvent("Click", (*)=>this.enterKey()) 

		this.gui.OnEvent("Close", (*)=>this.onClose())
		this.gui.Show(guiShowOpt)
		this.editBox.move("x5 w" (this.gui.ClientPos.w-10), true)
		this.displayBox.move("x5 w" (this.gui.ClientPos.w-10), true)		
		
	;	;Setup keybind for "/" (auto-complete)
		HotKey("IfWinActive", "ahk_id " this.gui.hwnd)
		HotKey("Tab", (*)=>this.autoComplete())
		HotKey("If")

		;initial display
		this.findMatchingWords(this.editBox.Value)
		this.listPrev := this.list.Clone()	
	}
	
	;When we complete
	onSubmit() {
		this.choice := this.editBox.Value
		this.ready := 1
		this.cleanUp()
		this.gui.Destroy()
	}
	
	onClose() {
		this.cleanUp()
		this.gui.Destroy()
        this.error := 1
	}
	
	cleanUp() {		
		this.list := ""
		this.listPrev := ""
	}

	;When the content of editBox changes
	editChanged() {		
		this.findMatchingWords(this.editBox.Value)
	}
	
	;User presses ENTER
	enterKey() {
		this.selectedText := ControlGetFocus("Edit1", "ahk_id " this.gui.hwnd)
		;No selection => user is submitting folder/file path
		if this.selectedText == ""
			this.onSubmit()
		;user has accepted autocomplete suggestion
		else {
			this.editChanged()
			ControlSend("{End}", "Edit1", "ahk_id " this.gui.hwnd)
			this.acceptedSuggestion := true
		}
	}

	;code for auto-completion
	autoComplete(direction := 1) {
		static index := 1
		static prevPath := ""

		;revert to defaultPath if editBox is empty
		if !Trim(this.editBox.Value, " `t`n`r") {
			this.findMatchingWords(this.editBox.Value)
			return
		}
		
		;to see if user is still cycling through selections (without hitting enter)
		found := false
		for k, v in this.listPrev {
			if this.editBox.Value == v {
				index := k + 1 * direction
				if index > this.listPrev.Length
					index := 1
				else if index < 1
					index := this.listPrev.Length
				found := true
				break
			}	
		}
		
		;a folder change has occured (either user input or acceptance of autocomplete suggestion)
		;we're looking at a new folder here, start cycling suggestions from index=1
		if this.acceptedSuggestion || !found {
			prevPath := this.editBox.Value
			this.listPrev := []
			this.listPrev := this.list.Clone()
			index := 1	

			this.acceptedSuggestion := false
		}
		
		;if folder appears to be empty (or we have no rights to see its content),
		;don't make any suggestion and leave editBox.Value unchanged
		if this.listPrev.Length > 0 {		
			this.editChanged()
			this.editBox.Value := this.listPrev[index]
			SendMessage(0xb1, StrLen(prevPath), -1, "Edit1", "ahk_id " this.gui.hwnd)
			this.selectedText := ControlGetFocus("Edit1", "ahk_id " this.gui.hwnd)
			this.findMatchingWords(this.editBox.Value)
		}
	}

	;loop through entries, put result in list array
	findMatchingWords(p) {
		this.displayBox.Value := ""
		this.list := []
        local c := 0

        For entry in listOfEntries
        {
            if(p = "")
            {
                c += 1
                this.displayBox.Value := this.displayBox.Value . (A_Index > 1 ? "`n" : "") . entry
                this.list.push(entry)
            }
            else if(InStr(entry,p))
            {
                c += 1
                this.displayBox.Value := this.displayBox.Value . (A_Index > 1 ? "`n" : "") . entry
                this.list.push(entry)
            }

            if(c > 20)
            {
                break
            }
        }
	}
}
