#Requires AutoHotkey v2+                           ; Always have a version requirement
#SingleInstance Force
#Include <Directives\__AE.v2>
; Hotstring("EndChars",'')
; F1::correct()
F1::autocorrect()

; Use a function instead of auto-replace (x option)
; Pass the correct in word so the function can send it
:*x:mcuh::correct('much')
:x:jsut::correct('just')
:x:tempalte::correct('template')
:x:eay::correct('easy')
:x:mroe::correct('more')
:x:yeha::correct('yeah')
correct(word:=unset) {
	AE.SM(&sm)
	static tracker := Map()                             ; Track number of times a word was corrected
	if !IsSet(word){                                    ; If word is unset
		return show_tracker()                           ;   Show the tracker info and go no further
	}
	if (tracker.Has(word)){                             ; Else if tracker contains word
		tracker[word]++									; Increment times corrected for word
	}                                 
	else{
		tracker[word] := 1                             	; Else first time. Add word to tracker and assign 1.
	}
	Send(word)                                          ; Send the correct word
	return                                              ; End of function
	show_tracker() {                                    ; Displays the tracker info
		str := 'Words corrected and number of times.'   ; Header
			. '`n==================================='
		for word, times in tracker {                    ; Loop through tracker
			str .= '`n' word ' corrected: ' times       ; Put each word and times corrected on a line
        }
		MsgBox(str)                                     ; Show tracker info
	}
}

#Requires AutoHotkey v2+                                   ; Always have a version requirement

; Make one class object as your "main thing" to create
; This class handles your autocorrections and tracks use
class autocorrect {
    
    static word_bank := Map(                                    ; All the words you want autocorrected
        ;typo word  , corrected word,
        'mcuh'      , 'much',
        'jsut'      , 'just',
        'tempalte'  , 'template',
        'eay'       , 'easy',
        'mroe'      , 'more',
        'yeha'      , 'yeah',
        '5-19s'     , '5-19, Switchgear and Circuit Breakers'
    )
    
    static tracker := Map()                                     ; Keeps track correction counting
    static file_dir := A_ScriptDir                              ; Save file's dir
    static file_name := 'autocorrections.ini'                   ; Save file's name
    static file_path => this.file_dir '\' this.file_name        ; Full save file path
    
    static __New(eChars := ' ', hsOptions := '*OX') {           ; Stuff to run at load time
        this.file_check()                                       ; Verify or create save directory and file
        this.build_hotstrings(eChars, hsOptions)                                 ; Create the hotstrings from the word bank
        this.load()                                             ; Load any previous data into memory
        OnExit(ObjBindMethod(this, 'save'))                     ; Save everything when script exits
    }
    
    static build_hotstrings(eChars:='', hsOptions := '') {      ; Creates the hotstrings
        eChars = '' ? Hotstring('EndChars',' ')
					: Hotstring('EndChars',eChars)              ; Set endchar
        for hs, replace in this.word_bank {                     ; Loop through error:correction word bank
            cb := ObjBindMethod(this, 'correct', replace)       ;   FuncObj to call when hotstring is fired
            ; Hotstring(':Ox:' hs, cb)                            ;   Make hotstring and assign callback
            hsOptions = '' ? Hotstring(':*Ox:' hs, cb)          ;   Make hotstring and assign callback
                           : Hotstring(':' hsOptions ':' hs, cb)
        }
    }
    
    static file_check() {
        if !DirExist(this.file_dir){                            ; Ensure the directory exists first
            DirCreate(this.file_dir)                            ;   If not, create it
        }
        if !FileExist(this.file_path) {                         ; Ensure file exists
            FileAppend('', this.file_path)                      ; If not, create it
            for key, value in this.word_bank {                  ; Go through each word
                IniWrite(0, this.file_path, 'Words', value)     ; Add that word to the 
            }
        }
    }
    
    static correct(word, *) {                                   ; Called when hotstring fires
        AE.SM(&sm)
        w := []
        n := 'im)(\d{2}-\d{3})'
        RegExMatch(word, n, &w)
        if w.length >0 {
            Send('^u')
        }
        Send(word)                                              ; Send corrected word
        if this.tracker.Has(word){                              ; If word has been seen
            this.tracker[word]++                                ;   Increment that word's count
        }
        else {
            this.tracker[word] := 1                            ; Else add word to tracker and assign 1
        }
        AE.rSM(sm)
    }
    
    static load() {                                             ; Loops through word bank and loads each word from ini
        for key, value in this.word_bank {
            this.tracker[value] := IniRead(this.file_path, 'Words', value, 0)
        }
    }
    
    static save(*) {                                            ; Loops through tracker and saves each word to ini
        for word, times in this.tracker {
            IniWrite(times, this.file_path, 'Words', word)
        }
    }
}