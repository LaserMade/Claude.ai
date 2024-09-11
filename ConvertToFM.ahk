; #Requires AutoHotkey v2.0
; #Include <Directives\__AE.v2>

; ; Shift+Ctrl+f
; +^f::convertbrand()


#Requires AutoHotkey v2.0
#Include <Directives\__AE.v2>

class TextReplacer {
    mapFM := Map(
        'FM', ['FM\s?Global', 'FMG\s?', 'fmglobal'],
        'FM ', ['FMG\s'],
        'FM Affiliated', ['AFM', 'Affiliated\s?FM'],
        'FM Boiler RE', ['Mutual\s?Boiler\s?Re'],
        'sites', [
            {osite:'fmglobal\.com/liquid', nsite: 'fm.com/liquid'}, 
            {osite: 'fmglobaldatasheets\.com', nsite: 'fm.com/resources/fm-data-sheets'},
            {osite:'fmglobalcatalog\.com', nsite: 'fmcatalog.com'}, 
            {osite:'fmglobal\.com/training-center', nsite: 'fm.com/training-center'}, 
        ]
    )

    Needle := '(?:([\`'\`"]\w+[\`'\`"][,\s])|(\d+,)|([\`'\`"]{2}))'
    kNeedle := '([\`'\`"]\w+[\`'\`"][,\s])'
    vNeedle := '(\d+,)'
    bNeedle := '([\`'\`"]{2})'

    __New() {
        this.CreateGUI()
    }

    ProcessRTFFile(rtfFilePath) {
        try {
            nfile := FileOpen(rtfFilePath, "r")
            fContent := nfile.Read()
            nfile.Close()

            processedContent := this.ProcessRTFContent(fContent)

            nfile := FileOpen(rtfFilePath, "w")
            nfile.Write(processedContent)
            nfile.Close()

            return processedContent
        } catch as err {
            MsgBox("Error processing RTF file: " . err.Message)
            return ""
        }
    }

    ProcessRTFContent(rtfContent) {
        lines := StrSplit(rtfContent, "`n")
        processedLines := []

        for line in lines {
            processedLine := this.ProcessLine(line)
            processedLines.Push(processedLine)
        }

        return processedLines.Join("`n")
    }

    ProcessLine(line) {
        if (line ~= this.Needle) {
            for key, values in this.mapFM {
                if (IsObject(values)) {
                    if (key == "sites") {
                        for site in values {
                            line := RegExReplace(line, site.osite, site.nsite)
                        }
                    } else {
                        for pattern in values {
                            line := RegExReplace(line, pattern, key)
                        }
                    }
                } else {
                    line := RegExReplace(line, values, key)
                }
            }
        }
        return line
    }

    ProcessText(originalText) {
        try {
            this.UpdateGUI("Original Text", originalText)

            textFormat := this.GetTextFormat(originalText)
            this.UpdateGUI("Text Format", textFormat)

            modifiedText := this.ReplaceText(originalText)
            this.UpdateGUI("Modified Text", modifiedText)

            return modifiedText
        } catch as err {
            this.ShowMessage("Error: " . err.Message)
            return ""
        }
    }

    ExtractPlainTextFromRTF(rtfText) {
        plainText := rtfText
        plainText := RegExReplace(plainText, "^\{\\rtf1.*?\\par", "")  ; Remove RTF header
        plainText := RegExReplace(plainText, "\\[a-z]+", "")  ; Remove RTF commands
        plainText := RegExReplace(plainText, "\\'[0-9a-f]{2}", "")  ; Remove escaped characters
        plainText := StrReplace(plainText, "\par", "`n")  ; Replace paragraph breaks with newlines
        plainText := StrReplace(plainText, "}", "")  ; Remove closing brace
        return Trim(plainText)
    }

    GetTextFormat(text) {
        if (RegExMatch(text, "^\{\\rtf"))
            return "Rich Text Format"
        else
            return "Plain Text"
    }

    ReplaceText(text) {
        modifiedText := text
        for key, values in this.mapFM {
            if (IsObject(values)) {
                if (key == "sites") {
                    for site in values {
                        modifiedText := RegExReplace(modifiedText, site.osite, site.nsite)
                    }
                } else {
                    for pattern in values {
                        modifiedText := RegExReplace(modifiedText, pattern, key)
                    }
                }
            } else {
                modifiedText := RegExReplace(modifiedText, values, key)
            }
        }
        return modifiedText
    }

    UpdateRichTextWithReplacements(richText, originalPlainText, modifiedPlainText) {
        if (originalPlainText == modifiedPlainText)
            return richText

        ; Create a map of original to modified substrings
        replaceMap := Map()
        originalParts := StrSplit(originalPlainText, "`n")
        modifiedParts := StrSplit(modifiedPlainText, "`n")
        
        for index, originalPart in originalParts {
            if (originalPart != modifiedParts[index]) {
                replaceMap[originalPart] := modifiedParts[index]
            }
        }

        ; Replace in rich text
        for original, modified in replaceMap {
            richText := StrReplace(richText, original, modified)
        }

        return richText
    }

    CreateGUI() {
        this.gui := Gui("+Resize +MinSize400x300")
        this.gui.Title := "Text Replacer"
        this.gui.OnEvent("Close", (*) => this.gui.Hide())

        this.gui.Add("Text", "w400", "Original Text:")
        this.originalTextEdit := this.gui.Add("Edit", "r4 w400 ReadOnly")
        this.gui.Add("Text", "w400", "Text Format:")
        this.formatEdit := this.gui.Add("Edit", "r1 w400 ReadOnly")
        this.gui.Add("Text", "w400", "Modified Text:")
        this.modifiedTextEdit := this.gui.Add("Edit", "r4 w400 ReadOnly")
        this.gui.Add("Text", "w400", "Window Info:")
        this.windowInfoEdit := this.gui.Add("Edit", "r6 w400 ReadOnly")

        this.gui.Add("Button", "w100", "Close").OnEvent("Click", (*) => this.gui.Hide())
    }

    UpdateGUI(field, value) {
        switch field {
            case "Original Text":
                this.originalTextEdit.Value := value
            case "Text Format":
                this.formatEdit.Value := value
            case "Modified Text":
                this.modifiedTextEdit.Value := value
            case "Window Info":
                this.windowInfoEdit.Value := value
        }
        this.ShowGUI()
    }

    ShowGUI() {
        ; this.gui.Show()
    }

    ShowMessage(msg) {
        MsgBox(msg, "Text Replacer", 0x2000)  ; 0x2000 flag makes the MsgBox always on top
    }

    GetActiveWindowInfo() {
        ; Store the current active window
        originalActiveWindow := WinExist("A")

        ; Wait a bit to ensure the target window is active
        Sleep(50)

        ; Get info about the now-active window (which should be the target application)
        windowId := WinGetID("A")
        windowTitle := WinGetTitle(windowId)
        windowClass := WinGetClass(windowId)
        processName := WinGetProcessName(windowId)

        ; Get focused control information
        focusedControl := ControlGetFocus("A")
        controlClass := ControlGetClassNN(focusedControl)
        
        ; Get control styles and exstyles
        controlStyle := ControlGetStyle(focusedControl)
        controlExStyle := ControlGetExStyle(focusedControl)

        ; Translate styles to Win32 constants
        translatedStyle := this.TranslateStyles(controlStyle)
        translatedExStyle := this.TranslateExStyles(controlExStyle)

        ; Additional info for hznHorizon.exe
        additionalInfo := ""
        if (processName = "hznHorizon.exe") {
            additionalInfo := this.GetHorizonWindowInfo(windowId, focusedControl)
        }

        ; Activate the original window
        if (originalActiveWindow)
            WinActivate("ahk_id " originalActiveWindow)

        return {
            id: windowId, 
            title: windowTitle, 
            class: windowClass, 
            process: processName,
            focusedControl: focusedControl,
            controlClass: controlClass,
            controlStyle: Format("0x{:X}", controlStyle),
            controlExStyle: Format("0x{:X}", controlExStyle),
            translatedStyle: translatedStyle,
            translatedExStyle: translatedExStyle,
            additionalInfo: additionalInfo
        }
    }

    GetHorizonWindowInfo(hWnd, hControl) {
        static GA_ROOT := 2
        static GA_ROOTOWNER := 3
        static GA_PARENT := 1
        static GW_CHILD := 5

        hRoot := DllCall("GetAncestor", "Ptr", hWnd, "UInt", GA_ROOT, "Ptr")
        hRootOwner := DllCall("GetAncestor", "Ptr", hWnd, "UInt", GA_ROOTOWNER, "Ptr")
        hParent := DllCall("GetAncestor", "Ptr", hControl, "UInt", GA_PARENT, "Ptr")
        hChild := DllCall("GetWindow", "Ptr", hControl, "UInt", GW_CHILD, "Ptr")

        info := "Root Window: " . this.GetWindowDetails(hRoot) . "`n"
        info .= "Root Owner: " . this.GetWindowDetails(hRootOwner) . "`n"
        info .= "Parent Window: " . this.GetWindowDetails(hParent) . "`n"
        info .= "Child Window: " . (hChild ? this.GetWindowDetails(hChild) : "None")

        return info
    }

    GetWindowDetails(hWnd) {
        if (!hWnd)
            return "N/A"

        class := WinGetClass("ahk_id " . hWnd)
        title := WinGetTitle("ahk_id " . hWnd)
        return Format("0x{:X} ({:s}) - {:s}", hWnd, class, title)
    }

    TranslateStyles(style) {
        styles := []
        styleMap := Map(
            0x00000000, "WS_OVERLAPPED",
            0x00C00000, "WS_CAPTION",
            0x00080000, "WS_SYSMENU",
            0x00040000, "WS_THICKFRAME",
            0x00020000, "WS_MINIMIZEBOX",
            0x00010000, "WS_MAXIMIZEBOX",
            0x00000001, "WS_TABSTOP",
            0x00000002, "WS_GROUP",
            0x00000004, "WS_SIZEBOX",
            0x00000020, "WS_VSCROLL",
            0x00000010, "WS_HSCROLL",
            0x00800000, "WS_BORDER",
            0x00400000, "WS_DLGFRAME",
            0x00000100, "WS_VISIBLE",
            0x08000000, "WS_DISABLED",
            0x10000000, "WS_CHILD"
        )

        for flag, name in styleMap {
            if (style & flag)
                styles.Push(name)
        }

        return styles.Length ? styles.Join(", ") : "None"
    }

    TranslateExStyles(exStyle) {
        exStyles := []
        exStyleMap := Map(
            0x00000001, "WS_EX_DLGMODALFRAME",
            0x00000004, "WS_EX_NOPARENTNOTIFY",
            0x00000008, "WS_EX_TOPMOST",
            0x00000010, "WS_EX_ACCEPTFILES",
            0x00000020, "WS_EX_TRANSPARENT",
            0x00000040, "WS_EX_MDICHILD",
            0x00000080, "WS_EX_TOOLWINDOW",
            0x00000100, "WS_EX_WINDOWEDGE",
            0x00000200, "WS_EX_CLIENTEDGE",
            0x00000400, "WS_EX_CONTEXTHELP",
            0x00001000, "WS_EX_RIGHT",
            0x00002000, "WS_EX_RTLREADING",
            0x00004000, "WS_EX_LEFTSCROLLBAR",
            0x00010000, "WS_EX_CONTROLPARENT",
            0x00020000, "WS_EX_STATICEDGE",
            0x00040000, "WS_EX_APPWINDOW",
            0x00080000, "WS_EX_LAYERED",
            0x00100000, "WS_EX_NOINHERITLAYOUT",
            0x00200000, "WS_EX_NOREDIRECTIONBITMAP",
            0x00400000, "WS_EX_LAYOUTRTL",
            0x02000000, "WS_EX_COMPOSITED",
            0x08000000, "WS_EX_NOACTIVATE"
        )

        for flag, name in exStyleMap {
            if (exStyle & flag)
                exStyles.Push(name)
        }

        return exStyles.Length ? exStyles.Join(", ") : "None"
    }
}


; ProcessAndPasteText() {
;     replacer := TextReplacer()
;     AE.SM_BISL(&sm)
;     AE.cBakClr(&cBak)

;     ; Store the current active window
;     originalActiveWindow := WinExist("A")

;     ; Use key.SendVK for select all
;     key.SendVK(key.selectall)
;     Sleep(100)

;     ; Use key.SendVK for copy
;     key.SendVK(key.copy)
;     AE.cSleep(150)
    
;     originalText := A_Clipboard
;     AE.cSleep(150)
;     modifiedText := replacer.ProcessText(originalText)

;     if (modifiedText != "") {
;         windowInfo := replacer.GetActiveWindowInfo()
;         infoText := "Process: " . windowInfo.process . "`n"
;                   . "Class: " . windowInfo.class . "`n"
;                   . "Control: " . windowInfo.controlClass . "`n"
;                   . "Control Style: " . windowInfo.controlStyle . "`n"
;                   . "Translated Style: " . windowInfo.translatedStyle . "`n"
;                   . "Control ExStyle: " . windowInfo.controlExStyle . "`n"
;                   . "Translated ExStyle: " . windowInfo.translatedExStyle . "`n"
;                   . "Additional Info:`n" . windowInfo.additionalInfo
;         replacer.UpdateGUI("Window Info", infoText)
        
;         ; Activate the original window before pasting
;         if (originalActiveWindow) {
;             WinActivate("ahk_id " originalActiveWindow)
;             WinWaitActive("ahk_id " originalActiveWindow)
;             Sleep(100)  ; Give a moment for the window to become fully active
;         }

;         ; Set the clipboard to the modified text
;         A_Clipboard := modifiedText
;         AE.cSleep(150)

;         ; Use key.SendVK for paste
;         key.SendVK(key.paste)
;     }
;     sleep(500)
;     AE.cRestore(cBak)
;     AE.rSM_BISL(sm)
; }



; ProcessAndPasteText() {
;     AE.SM_BISL(&sm)
;     AE.cBakClr(&cBak)

;     ; Store the current active window
;     originalActiveWindow := WinExist("A")

;     ; Use key.SendVK for select all
;     key.SendVK(key.selectall)
;     Sleep(100)

;     ; Use key.SendVK for copy
;     key.SendVK(key.copy)
;     AE.cSleep(150)
    
;     ; Get the RTF content from the clipboard
;     rtfContent := AE.GetRichTextFromClipboard()

;     ; Extract the plain text from the RTF content
;     plainText := AE.ExtractPlainTextFromRTF(rtfContent)

;     ; Process the plain text
;     modifiedPlainText := replacer.ProcessText(plainText)

;     if (modifiedPlainText != plainText) {
;         ; Replace the text portion in the RTF content
;         modifiedRtfContent := AE.ReplaceTextInRTF(rtfContent, plainText, modifiedPlainText)

;         windowInfo := replacer.GetActiveWindowInfo()
;         infoText := "Process: " . windowInfo.process . "`n"
;                   . "Class: " . windowInfo.class . "`n"
;                   . "Control: " . windowInfo.controlClass . "`n"
;                   . "Control Style: " . windowInfo.controlStyle . "`n"
;                   . "Translated Style: " . windowInfo.translatedStyle . "`n"
;                   . "Control ExStyle: " . windowInfo.controlExStyle . "`n"
;                   . "Translated ExStyle: " . windowInfo.translatedExStyle . "`n"
;                   . "Additional Info:`n" . windowInfo.additionalInfo
;         replacer.UpdateGUI("Window Info", infoText)
        
;         ; Activate the original window before pasting
;         if (originalActiveWindow) {
;             WinActivate("ahk_id " originalActiveWindow)
;             WinWaitActive("ahk_id " originalActiveWindow)
;             Sleep(100)  ; Give a moment for the window to become fully active
;         }

;         ; Set the clipboard to the modified RTF content
;         AE.SetClipboardRichText(modifiedRtfContent)
;         AE.cSleep(150)

;         ; Use key.SendVK for paste
;         key.SendVK(key.paste)
;     }

;     Sleep(500)
;     AE.cRestore(cBak)
;     AE.rSM_BISL(sm)
; }

; ^+f::ProcessAndPasteText()


ProcessAndPasteText(){
    AE.SM_BISL(&sm)
    AE.cBakClr(&cBak)
    mapFM := Map(
        'FM', ['FM\s?Global', 'FMG\s?', 'fmglobal'],
        'FM ', ['FMG\s'],
        'FM Affiliated', ['AFM', 'Affiliated\s?FM'],
        'FM Boiler RE', ['Mutual\s?Boiler\s?Re'],
        'sites', [
            {osite:'fmglobal\.com/liquid', nsite: 'fm.com/liquid'}, 
            {osite: 'fmglobaldatasheets\.com', nsite: 'fm.com/resources/fm-data-sheets'},
            {osite:'fmglobalcatalog\.com', nsite: 'fmcatalog.com'}, 
            {osite:'fmglobal\.com/training-center', nsite: 'fm.com/training-center'}, 
        ]
    )

    Needle := '(?:([\`'\`"]\w+[\`'\`"][,\s])|(\d+,)|([\`'\`"]{2}))'
    kNeedle := '([\`'\`"]\w+[\`'\`"][,\s])'
    vNeedle := '(\d+,)'
    bNeedle := '([\`'\`"]{2})'

    ; Use key.SendVK for select all
    ; key.SendVK(key.selectall)
    ; Sleep(100)

    ; Use key.SendVK for copy
    ; key.SendVK(key.copy)
    ; AE.cSleep(150)
    
    ; Get the RTF content from the clipboard
    rtfContent := A_Clipboard
    AE.cSleep(150)
    fname := 'temprtffile.rtf'
    FileDelete(fname)
    FileAppend(rtfContent, fname, '`n UTF-8')

    return
    fOpen := FileOpen(fname, 'rw', 'UTF-8')
    arrFile := [], fArrObj := []
    fLine := '', fString := ''

    ProcessLine(line) {
        ; if (line ~= Needle) {
            for key, values in mapFM {
                if (IsObject(values)) {
                    if (key == "sites") {
                        for site in values {
                            line := RegExReplace(line, site.osite, site.nsite)
                        }
                    } else {
                        for pattern in values {
                            line := RegExReplace(line, pattern, key)
                        }
                    }
                } else {
                    line := RegExReplace(line, values, key)
                }
            }
        ; }
        return line
    }
    ; Read file contents
    loop read fName {
        fArrObj.Push(A_LoopReadLine)
        fLine .= A_LoopReadLine '`n'
    }

    ; Process each line
    for aLine in fArrObj {
        newLine := ProcessLine(aLine)
        fString .= newLine '`n'
    }

    ; Write updated content back to file
    fOpen.Write(fString)
    fOpen := ''
    ; return 0
    sleep(100)

    oFile := FileOpen(fname, 'r', 'UTF-8')
    rFile := oFile.Read()

    A_Clipboard := rFile
    AE.cSleep(150)
    ; MsgBox(rFile)

    ; return
    ; Use key.SendVK for paste
    key.SendVK(key.paste)

    Sleep(500)
    AE.cRestore(cBak)
    AE.rSM_BISL(sm)
}

^+f::ProcessAndPasteText()
