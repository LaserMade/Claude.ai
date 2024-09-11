#Requires AutoHotkey v2.0.17+
#Include <Directives\__AE.v2>
#SingleInstance Force
SetWorkingDir(A_ScriptDir)


; #Include <UIA> ; Ensure this path is correct

class ChromeRiverNavigator {
    ; Properties
    controlName := "help"
    controls := []
    currentIndex := 0
    gui := {}
    menuStructure := {}
    hotkeys := Map()
    vendorCategories := Map()
    settings := {thirdSectionStyle: "dynamic", autoOpenChromeRiver: true}
    ; settings := {thirdSectionStyle: 'Static', autoOpenChromeRiver: true}
    logGui := {}

    ; static DEFAULT_MENU_STRUCTURE := {
    DEFAULT_MENU_STRUCTURE := {
        menuCategories: ["Travel", "Meals / Entertainment", "Telecom", "Office Expenses", "Company Car", "Professional Memberships / Development", "Fees / Advances", "Misc", "Engineer / Equipment"],
        travel: ["Airfare", "Airline Fee", "Business Mileage - Personal Car", "Car Rental", "Car Rental - Fuel", "Car Service", "Gift in Lieu of Hotel", "Ground Travel", "Hotel", "Parking and Tolls", "Passport / Visa / Immigration Fees", "Rail", "Tips / Gratuities", "Travel Agency Transaction Fees - TMC"],
        meals: ["Client Gifts", "Client Meals", "Employee Meals", "Entertainment", "Events", "Mkt Client Event", "Other Client Related Expenses"],
        telecom: ["Mobile Cellular / Data Charges", "Cellular Broadband / MiFi", "Home Internet", "Hot Spot / Wifi Charges", "Phone / Business Calls"],
        office: ["Office Supplies", "Outside Printing / Photocopying Charges", "Postage / Mail / Couriers", "Software"],
        companyCar: ["Fuel / Company Car", "Mileage / Company Car", "Wash / Company Car", "Other / Company Car", "Home Charger Installation", "Home Charging Electricity Costs", "EV Public Charging Station"],
        professional: ["Annual Membership Fees", "Certification / Re-Certification", "Conference / Seminar Fees", "Professional Association Dues", "Subscriptions"],
        fees: ["Bank / ATM Fees", "Cash Advance", "Foreign Transaction Fees"],
        misc: ["Employee Medical", "Meeting Room", "Personal / Amex Expense", "SWE - Soc of Women Eng", "Trade Show Expense", "Other / Misc", "Memorial / Expressions of Sympathy", "Employee Gifts"],
        engineer: ["Engineering Supply / Tools", "Maps", "Safety Expenses", "Sundry Service / Water Test"]
    }
    ; static DEFAULT_HOTKEY_SETTINGS := {
    DEFAULT_HOTKEY_SETTINGS := {
        NavigateNext: {key: "n", modifiers: {alt: true}},
        NavigatePrevious: {key: "p", modifiers: {alt: true}},
        FindFirstUnclassifiedExpense: {key: "Down", modifiers: {alt: true}},
        FindLastUnclassifiedExpense: {key: "Up", modifiers: {alt: true}},
        OpenSettings: {key: "s", modifiers: {alt: true}}
    }

    ; static DEFAULT_VENDOR_CATEGORIES := {
    DEFAULT_VENDOR_CATEGORIES := {
        McDonalds: {category: "Meals / Entertainment", subcategory: "Employee Meals"}
    }

    __New() {
        this.hotkeys := Map(
            "NavigateNext", Map("key", "n", "modifiers", Map("alt", true)),
            "NavigatePrevious", Map("key", "p", "modifiers", Map("alt", true)),
            "FindFirstUnclassifiedExpense", Map("key", "Down", "modifiers", Map("alt", true)),
            "FindLastUnclassifiedExpense", Map("key", "Up", "modifiers", Map("alt", true)),
            "OpenSettings", Map("key", "s", "modifiers", Map("alt", true))
        )
        
        this.LoadMenuStructure()
        this.LoadHotkeySettings()
        this.LoadVendorCategories()
        this.SetupHotkeys()
        this.CreateGui()
        this.CreateTrayMenu()
    }
    
    IsChromeRiverAccessible() {
        try {
            title := 'Chrome River - Google Chrome'
            expRpt := UIA.ElementFromChromium(title)
            return (expRpt != 0)
        } catch as err {
            this.Log("Error checking Chrome River accessibility: " . err.Message, true)
            return false
        }
    }

    RefreshControls() {
        this.Log("Refreshing controls list")
        oldCount := this.controls.Length
        newCount := this.FindControls()
        this.Log("Controls refreshed. Old count: " . oldCount . ", New count: " . newCount)
    }

    SaveState() {
        return {currentIndex: this.currentIndex}
    }
    
    RestoreState(state) {
        this.currentIndex := state.currentIndex
        this.FocusCurrentControl()
    }

    StrJoin(array, delimiter := "") {
        result := ""
        for index, item in array {
            if (index > 1) {
                result .= delimiter
            }
            result .= item
        }
        return result
    }

    LoadMenuStructure() {
        jsonFile := A_ScriptDir "\menu_structure.json"
        
        if !FileExist(jsonFile) {
            this.CreateJsonFile(jsonFile, this.DEFAULT_MENU_STRUCTURE)
        }
    
        try {
            fileContent := FileRead(jsonFile)
            this.menuStructure := JSON.Parse(fileContent)
            this.Log("Menu structure loaded from file.")
        } catch as err {
            ErrorLogger.Log("Error loading menu structure: " . err.Message)
            this.menuStructure := this.DEFAULT_MENU_STRUCTURE
            this.SaveMenuStructure()
        }
    }
    
    LoadHotkeySettings() {
        jsonFile := A_ScriptDir "\hotkey_settings.json"
        
        if !FileExist(jsonFile) {
            this.CreateJsonFile(jsonFile, this.DEFAULT_HOTKEY_SETTINGS)
        }
    
        try {
            fileContent := FileRead(jsonFile)
            this.hotkeys := JSON.Parse(fileContent)
            this.Log("Hotkey settings loaded from file.")
        } catch as err {
            ErrorLogger.Log("Error loading hotkey settings: " . err.Message)
            this.hotkeys := this.DEFAULT_HOTKEY_SETTINGS
            this.SaveHotkeySettings()
        }
    }
    
    LoadVendorCategories() {
        jsonFile := A_ScriptDir "\vendor_categories.json"
        
        if !FileExist(jsonFile) {
            this.CreateJsonFile(jsonFile, this.DEFAULT_VENDOR_CATEGORIES)
        }
    
        try {
            fileContent := FileRead(jsonFile)
            this.vendorCategories := JSON.Parse(fileContent)
            this.Log("Vendor categories loaded from file.")
        } catch as err {
            ErrorLogger.Log("Error loading vendor categories: " . err.Message)
            this.vendorCategories := this.DEFAULT_VENDOR_CATEGORIES
            this.SaveVendorCategories()
        }
    }
    
    CreateJsonFile(filePath, defaultContent) {
        try {
            FileAppend(JSON.Stringify(defaultContent, 4), filePath)
            this.Log("Created new file: " . filePath)
        } catch as err {
            ErrorLogger.Log("Error creating file " . filePath . ": " . err.Message)
        }
    }
    
    LoadDefaultMenuStructure(defaultJsonFile) {
        try {
            fileContent := FileRead(defaultJsonFile)
            this.menuStructure := JSON.Parse(fileContent)
            this.Log("Default menu structure loaded.")
            this.SaveMenuStructure()
        } catch as err {
            ErrorLogger.Log("Error loading default menu structure: " . err.Message)
            this.CreateDefaultMenuStructure()
        }
    }
    
    LoadDefaultHotkeySettings(defaultJsonFile) {
        try {
            fileContent := FileRead(defaultJsonFile)
            this.hotkeys := JSON.Parse(fileContent)
            this.Log("Default hotkey settings loaded.")
            this.SaveHotkeySettings()
        } catch as err {
            ErrorLogger.Log("Error loading default hotkey settings: " . err.Message)
            this.CreateDefaultHotkeySettings()
        }
    }
    
        
    LoadDefaultVendorCategories(defaultJsonFile) {
        try {
            fileContent := FileRead(defaultJsonFile)
            this.vendorCategories := JSON.Parse(fileContent)
            this.Log("Default vendor categories loaded.")
            this.SaveVendorCategories()
        } catch as err {
            ErrorLogger.Log("Error loading default vendor categories: " . err.Message)
            this.CreateDefaultVendorCategories()
        }
    }

    CreateDefaultMenuStructure() {
        this.menuStructure := {
            categories: ["Travel", "Meals / Entertainment", "Telecom", "Office Expenses", "Company Car", "Professional Memberships / Development", "Fees / Advances", "Misc", "Engineer / Equipment"],
            subcategories: {
                Travel: ["Airfare", "Airline Fee", "Business Mileage - Personal Car", "Car Rental", "Car Rental - Fuel", "Car Service", "Gift in Lieu of Hotel", "Ground Travel", "Hotel", "Parking and Tolls", "Passport / Visa / Immigration Fees", "Rail", "Tips / Gratuities", "Travel Agency Transaction Fees - TMC"],
                Meals_Entertainment: ["Client Gifts", "Client Meals", "Employee Meals", "Entertainment", "Events", "Mkt Client Event", "Other Client Related Expenses"],
                ; ... other subcategories ...
            }
        }
        this.SaveMenuStructure()
    }

    SaveMenuStructure() {
        try {
            FileDelete(A_ScriptDir "\menu_structure.json")
            FileAppend(JSON.Stringify(this.menuStructure, 4), A_ScriptDir "\menu_structure.json")
            this.Log("Menu structure saved to file.")
        } catch as err {
            ErrorLogger.Log("Error saving menu structure: " . err.Message)
        }
    }
    
    SaveHotkeySettings() {
        try {
            FileDelete(A_ScriptDir "\hotkey_settings.json")
            FileAppend(JSON.Stringify(this.hotkeys, 4), A_ScriptDir "\hotkey_settings.json")
            this.Log("Hotkey settings saved to file.")
        } catch as err {
            ErrorLogger.Log("Error saving hotkey settings: " . err.Message)
        }
    }
    
    SaveVendorCategories() {
        try {
            FileDelete(A_ScriptDir "\vendor_categories.json")
            FileAppend(JSON.Stringify(this.vendorCategories, 4), A_ScriptDir "\vendor_categories.json")
            this.Log("Vendor categories saved to file.")
        } catch as err {
            ErrorLogger.Log("Error saving vendor categories: " . err.Message)
        }
    }
    
    ; Apply similar try-catch blocks to other methods that might throw errors

    CreateDefaultHotkeySettings() {
        this.hotkeys := Map()
        this.hotkeys.Set("NavigateNext", {key: "n", modifiers: {alt: true}})
        this.hotkeys.Set("NavigatePrevious", {key: "p", modifiers: {alt: true}})
        this.hotkeys.Set("FindFirstUnclassifiedExpense", {key: "Down", modifiers: {alt: true}})
        this.hotkeys.Set("FindLastUnclassifiedExpense", {key: "Up", modifiers: {alt: true}})
        this.hotkeys.Set("OpenSettings", {key: "s", modifiers: {alt: true}})
        this.SaveHotkeySettings()
    }
    
    CreateDefaultVendorCategories() {
        this.vendorCategories := Map()
        this.vendorCategories.Set("McDonalds", {category: "Meals / Entertainment", subcategory: "Employee Meals"})
        ; ... other vendor categories ...
        this.SaveVendorCategories()
    }
    
    SetupHotkeys() {
        for methodName, hotkeyInfo in this.hotkeys {
            modifierString := ""
            if (hotkeyInfo.HasOwnProp("modifiers")) {
                for modKey, isEnabled in hotkeyInfo.modifiers {
                    if (isEnabled) {
                        modifierString .= modKey . " & "
                    }
                }
            }
            
            if (hotkeyInfo.HasOwnProp("key")) {
                hotkeyString := modifierString . hotkeyInfo.key
                
                ; Use a switch statement to handle different methods
                switch methodName {
                    case "NavigateNext":
                        HotKey(hotkeyString, (*) => this.NavigateNext(true))
                    case "NavigatePrevious":
                        HotKey(hotkeyString, (*) => this.NavigatePrevious(true))
                    case "FindFirstUnclassifiedExpense":
                        HotKey(hotkeyString, (*) => this.FindUnclassifiedExpense(1, true))
                    case "FindLastUnclassifiedExpense":
                        HotKey(hotkeyString, (*) => this.FindUnclassifiedExpense(-1, true))
                    case "OpenSettings":
                        HotKey(hotkeyString, (*) => this.OpenSettings())
                    default:
                        ; For any other methods, bind them directly
                        if (methodName = "NavigateNext") {
                            HotKey(hotkeyString, ObjBindMethod(this, methodName))
                        } else {
                            HotIf(() => WinActive(this.gui.Hwnd))
                            HotKey(hotkeyString, ObjBindMethod(this, methodName))
                            HotIf()
                        }
                }
                
                this.Log("Hotkey set: " . hotkeyString . " for method: " . methodName)
            }
        }
    }

    CreateGui() {
        this.gui := Gui("+Resize", "Chrome River Navigator")
        
        ; Main section
        this.gui.Add("Text", "w400 h60 vExpenseDetails", "Expense Details")
        this.gui.Add("Button", "w200", "Open Draft").OnEvent("Click", (*) => this.OpenDraft())
        this.gui.Add("Button", "w200 y+5", "Create New").OnEvent("Click", (*) => this.CreateNew())
        this.gui.Add("Button", "w200 y+5", "Open Selected").OnEvent("Click", (*) => this.OpenSelected())
        this.gui.Add("Button", "w200 y+5", "Add New Expense").OnEvent("Click", (*) => this.AddNewExpense())
        this.gui.Add("Button", "w200", "First Unclassified Expense").OnEvent("Click", (*) => this.FindFirstUnclassifiedExpense())
        this.gui.Add("Button", "w200 y+5", "Previous Unclassified Expense").OnEvent("Click", (*) => this.FindPreviousUnclassifiedExpense())
        this.gui.Add("Button", "w200 y+5", "Next Unclassified Expense").OnEvent("Click", (*) => this.FindNextUnclassifiedExpense())
        this.gui.Add("Button", "w200 y+5", "Previous Expense").OnEvent("Click", (*) => this.NavigatePrevious())
        this.gui.Add("Button", "w200 y+5", "Next Expense").OnEvent("Click", (*) => this.NavigateNext())
        this.gui.Add("Button", "w200 y+5", "Select Current Expense").OnEvent("Click", (*) => this.SelectCurrentExpense())
        this.gui.Add("Button", "w200 y+5", "Settings").OnEvent("Click", (*) => this.OpenSettings())
        
        ; Categories section
        if this.menuStructure.Has("menuCategories") {
            this.categoryListBox := this.gui.Add("ListBox", "w200 y+10 h200", this.menuStructure.Get("menuCategories"))
        } else {
            this.categoryListBox := this.gui.Add("ListBox", "w200 y+10 h200", ["No categories found"])
        }
        this.categoryListBox.OnEvent("Change", (*) => this.HandleCategorySelection())
    
        ; Subcategories section
        if (this.settings.thirdSectionStyle = "dynamic") {
            this.subcategoryListBox := this.gui.Add("ListBox", "w200 y+10 h200")
        } else {
            this.CreateStaticSubcategoryButtons()
        }
        
        this.gui.Show()
    }

    OpenDraft() {
        draftElement := this.FindElement({Type: "50026", Name: "1 Draft", LocalizedType: "group"})
        if (draftElement) {
            this.FocusElement(draftElement)
            draftElement.Click()
            this.UpdateExpenseInfo()
        } else {
            this.Log("Draft element not found", true)
        }
    }

    CreateNew() {
        newButton := this.FindElement({Type: "50000", Name: "Create New Expense Report Create", LocalizedType: "button"})
        if (newButton) {
            newButton.Click()
        }
    }

    OpenSelected() {
        openButton := this.FindElement({Type: "50000", Name: "Open", LocalizedType: "button", AutomationId: "open-btn"})
        if (openButton) {
            openButton.Click()
            this.UpdateExpenseInfo()
        }
    }

    AddNewExpense() {
        addButton := this.FindElement({Type: "50000", Name: "Add New Expense", LocalizedType: "button"})
        if (addButton) {
            addButton.Click()
            this.Log("Clicked 'Add New Expense' button")
            
            ; Wait for a moment to allow the new expense to be added
            Sleep(1000)
            
            ; Refresh the controls list
            this.RefreshControls()
            
            ; Set the current index to the last (newest) expense
            if (this.controls.Length > 0) {
                this.currentIndex := this.controls.Length
                this.FocusCurrentControl()
            } else {
                this.Log("No expenses found after adding new expense", true)
            }
        } else {
            this.Log("'Add New Expense' button not found", true)
        }
    }

    FocusElement(element) {
        if (element) {
            try {
                this.Log("Focusing on element: " . element.Name)
                element.SetFocus()
                element.ScrollIntoView()
                Sleep(100)  ; Allow time for UI to update
                this.Log("Element focused and scrolled into view")
            } catch as e {
                this.Log("Error focusing element: " . e.Message, true)
            }
        } else {
            this.Log("Cannot focus on null element", true)
        }
    }

    FindControls() {
        this.controls := []
        
        title := 'Chrome River - Google Chrome'
        try {
            cacheRequest := UIA.CreateCacheRequest()
            cacheRequest.TreeScope := 5
            expRpt := UIA.ElementFromChromium(title, cacheRequest)
    
            if (expRpt) {
                foundControls := expRpt.FindAll({Type: '50026 (Group)', Name: this.controlName, LocalizedType: 'group'})
                for control in foundControls {
                    this.controls.Push(control)
                    this.Log("Found control: Type: " . control.Type . ", Name: " . control.Name . ", LocalizedType: " . control.LocalizedType)
                    
                    ; Log child elements
                    childElements := control.FindAll({Scope: 2})  ; Scope: 2 means children only
                    for child in childElements {
                        this.Log("  Child element: Type: " . child.Type . ", Name: " . child.Name . ", LocalizedType: " . child.LocalizedType)
                    }
                }
                this.Log("Found " . this.controls.Length . " controls")
            } else {
                this.Log("Chrome River window not found", true)
            }
        } catch as err {
            this.Log("Error in FindControls: " . err.Message, true)
        }
        
        return this.controls.Length
    }

    NavigateNext(focus_control := true) {
        this.Log("Navigating to next expense")
        if (this.controls.Length == 0) {
            count := this.FindControls()
            if (count == 0) {
                this.Log("No expenses found in Chrome River.")
                return
            }
        }
        
        this.currentIndex++
        if (this.currentIndex > this.controls.Length) {
            this.currentIndex := 1  ; Wrap around to the first control
        }
        
        this.FocusCurrentControl(focus_control)
        this.UpdateUIATree()
    }
    
    NavigatePrevious(focus_control := true) {
        this.Log("Navigating to previous expense")
    
        if (this.controls.Length == 0) {
            this.FindControls()
        }
        
        if (this.controls.Length > 0) {
            this.currentIndex--
            if (this.currentIndex < 1) {
                this.currentIndex := this.controls.Length
            }
            this.FocusCurrentControl()
        } else {
            this.Log("No expenses found")
        }
        this.FocusCurrentControl(focus_control)
        this.UpdateUIATree()
    }

    FindFirstUnclassifiedExpense() {
        this.Log("Finding first unclassified expense")
        this.FindUnclassifiedExpense(1)
        this.UpdateUIATree()
    }
    
    FindPreviousUnclassifiedExpense() {
        this.Log("Finding previous unclassified expense")
        this.FindUnclassifiedExpense(-1)
        this.UpdateUIATree()
    }
    
    FindNextUnclassifiedExpense() {
        this.Log("Finding next unclassified expense")
        this.FindUnclassifiedExpense(1)
    }
    
    FindUnclassifiedExpense(direction, selectExpense := false) {
        this.Log("Searching for unclassified expense")
        if (this.controls.Length == 0) {
            this.FindControls()
        }
    
        this.Log("Searching through " . this.controls.Length . " controls")
    
        startIndex := this.currentIndex
        loop this.controls.Length {
            this.currentIndex += direction
            if (this.currentIndex > this.controls.Length) {
                this.currentIndex := 1
            } else if (this.currentIndex < 1) {
                this.currentIndex := this.controls.Length
            }
    
            this.Log("Checking control at index " . this.currentIndex)
            
            try {
                if (this.IsUnclassified(this.controls[this.currentIndex])) {
                    this.Log("Found unclassified expense at index " . this.currentIndex)
                    this.FocusCurrentControl(selectExpense)
                    return true
                }
            } catch as err {
                this.Log("Error checking if expense is unclassified: " . err.Message, true)
            }
    
            if (this.currentIndex == startIndex) {
                break
            }
        }
    
        this.Log("No unclassified expenses found")
    }

    IsUnclassified(control) {
        try {
            this.Log("Checking if expense is unclassified")
            this.Log("Control type: " . control.Type . ", Name: " . control.Name)
            
            helpGroup := control.FindFirst({Type: "50026 (Group)", Name: "help", LocalizedType: "group"})
            
            if (helpGroup) {
                this.Log("Found 'help' group, expense is unclassified")
                return true
            } else {
                this.Log("No 'help' group found, expense is classified")
                return false
            }
        } catch as err {
            this.Log("Error in IsUnclassified: " . err.Message . " for control: " . control.Name, true)
            return false
        }
    }

    FocusCurrentControl(selectExpense := false) {
        try {
            if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
                throw Error("Invalid index: " . this.currentIndex)
            }
            
            control := this.controls[this.currentIndex]
            if (!control) {
                throw Error("Control at index " . this.currentIndex . " is null")
            }
            
            this.Log("Focusing control at index " . this.currentIndex)
            
            ; Scroll the control into view
            control.ScrollIntoView()
            this.Log("Control scrolled into view")
    
            ; Set focus to the control only if it's not already focused
            if (!this.IsControlFocused(control)) {
                control.SetFocus()
                this.Log("Focus set to control")
                
                ; Wait a moment for the UI to update
                Sleep(100)
            } else {
                this.Log("Control already has focus")
            }
            
            this.UpdateExpenseInfo()
            this.Log("Expense info updated")
    
            if (selectExpense) {
                this.SelectCurrentExpense()
            }
        } catch as e {
            this.Log("Error focusing control: " . e.Message . "`nCurrent Index: " . this.currentIndex . "`nTotal Controls: " . this.controls.Length, true)
        }
    }
    
    IsControlFocused(control) {
        try {
            return control.GetPropertyValue(UIA.Property.HasKeyboardFocus)
        } catch {
            return false
        }
    }

    SelectCurrentExpense() {
        if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
            this.Log("Invalid current index: " . this.currentIndex . ". Cannot select expense.")
            return false
        }
    
        control := this.controls[this.currentIndex]
        if (!control) {
            this.Log("Control at index " . this.currentIndex . " is null. Cannot select expense.")
            return false
        }
    
        try {
            this.Log("Attempting to select expense at index " . this.currentIndex)
            this.Log("Control Type: " . control.Type . ", Name: " . control.Name . ", LocalizedType: " . control.LocalizedType)
    
            ; Only scroll into view and focus if necessary
            if (!this.IsControlVisible(control)) {
                control.ScrollIntoView()
                this.Log("Control scrolled into view")
            }
            
            if (!this.IsControlFocused(control)) {
                control.SetFocus()
                this.Log("Control focused")
            }
    
            ; Check if this is an unclassified expense (with "help" group)
            helpGroup := control.FindFirst({Type: "50026 (Group)", Name: "help", LocalizedType: "group"})
            if (helpGroup) {
                this.Log("Found 'help' group. Attempting to click.")
                helpGroup.Click()
                this.Log("Clicked 'help' group for unclassified expense")
            } else {
                this.Log("No 'help' group found. Searching for expense category button.")
                ; This is a classified expense, find the expense category button
                categoryButton := control.FindFirst({Type: "50000 (Button)", LocalizedType: "button"})
                if (categoryButton) {
                    this.Log("Found category button. Name: " . categoryButton.Name)
                    ; Use the Invoke pattern if available
                    try {
                        categoryButton.InvokePattern.Invoke()
                        this.Log("Invoked expense category button")
                    } catch as invokeErr {
                        this.Log("Invoke failed: " . invokeErr.Message . ". Attempting Click.")
                        ; If Invoke fails, fall back to Click
                        categoryButton.Click()
                        this.Log("Clicked expense category button")
                    }
                } else {
                    this.Log("No clickable element found for expense. Attempting to click the control itself.")
                    control.Click()
                    this.Log("Clicked the expense control")
                }
            }
    
            ; Wait a moment for the UI to update
            Sleep(500)
    
            return true
        } catch as err {
            this.Log("Error selecting expense: " . err.Message . "`nStack: " . err.Stack, true)
            return false
        }
    }
    
    IsControlVisible(control) {
        try {
            return !control.GetPropertyValue(UIA.Property.IsOffscreen)
        } catch {
            return false
        }
    }

    UpdateExpenseInfo() {
        if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
            this.Log("Invalid current index: " . this.currentIndex . ". Total controls: " . this.controls.Length)
            this.gui["ExpenseDetails"].Value := "No expense selected"
            return
        }
    
        control := this.controls[this.currentIndex]
        if (!control) {
            this.Log("Control at index " . this.currentIndex . " is null")
            this.gui["ExpenseDetails"].Value := "Error: Selected expense not found"
            return
        }
    
        infoText := "Expense " . this.currentIndex . " of " . this.controls.Length . "`n"
    
        textElements := control.FindAll({Type: "50020", LocalizedType: "text"})
        for element in textElements {
            infoText .= element.Name . "`n"
        }
    
        this.gui["ExpenseDetails"].Value := infoText
        this.Log("Expense info updated for index " . this.currentIndex)
    }

    FindElement(condition) {
        title := 'Chrome River - Google Chrome'
        element := UIA.ElementFromChromium(title)
        if (element) {
            return element.FindFirst(condition)
        }
        return 0
    }

    CreateStaticSubcategoryButtons() {
        this.subcategoryButtons := {}
        for category in this.menuStructure.menuCategories {
            categoryKey := StrLower(StrReplace(category, " / ", ""))
            this.subcategoryButtons[categoryKey] := []
            for subcategory in this.menuStructure[categoryKey] {
                btn := this.gui.Add("Button", "w200 y+5 Hidden", subcategory)
                btn.OnEvent("Click", (*) => this.HandleSubcategorySelection(category, subcategory))
                this.subcategoryButtons[categoryKey].Push(btn)
            }
        }
    }

    HandleCategorySelection() {
        selectedCategory := this.categoryListBox.Text
        categoryKey := StrLower(StrReplace(selectedCategory, " / ", ""))
        
        if (this.settings.thirdSectionStyle = "dynamic") {
            this.subcategoryListBox.Delete()
            if this.menuStructure.Has(categoryKey) {
                this.subcategoryListBox.Add(this.menuStructure.Get(categoryKey))
            }
        } else {
            for category in this.menuStructure.Get("menuCategories") {
                catKey := StrLower(StrReplace(category, " / ", ""))
                if this.subcategoryButtons.Has(catKey) {
                    for btn in this.subcategoryButtons.Get(catKey) {
                        if (category = selectedCategory) {
                            btn.Visible := true
                        } else {
                            btn.Visible := false
                        }
                    }
                }
            }
        }
        this.UpdateUIATree()
    }

    HandleSubcategorySelection(category, subcategory) {
        this.Log("Selected: " . category . " - " . subcategory)
        this.PerformUIAInteraction(category, subcategory)
        this.UpdateUIATree()
    }

    FindLastUnclassifiedExpense() {
        this.Log("Finding last unclassified expense")
        ; TODO: Implement UIA interaction for last unclassified expense
        this.UpdateUIATree()
    }

    OpenSettings() {
        settingsGui := Gui("+Owner" . this.gui.Hwnd, "Settings")
        
        settingsGui.Add("Text", "w200", "Third Section Style:")
        styleDropdown := settingsGui.Add("DropDownList", "w200", ["Dynamic", "Static"])
        styleDropdown.Value := this.settings.thirdSectionStyle = "dynamic" ? 1 : 2
        
        settingsGui.Add("Text", "w200 y+10", "Hotkeys:")
        for method, hotkeyInfo in this.hotkeys {
            settingsGui.Add("Text", "w200 y+5", method . ":")
            hkEdit := settingsGui.Add("Edit", "w50 x+5", hotkeyInfo.Get("key", ""))
            altCb := settingsGui.Add("CheckBox", "x+5", "Alt")
            ctrlCb := settingsGui.Add("CheckBox", "x+5", "Ctrl")
            shiftCb := settingsGui.Add("CheckBox", "x+5", "Shift")
            winCb := settingsGui.Add("CheckBox", "x+5", "Win")
            
            modifiers := hotkeyInfo.Get("modifiers", Map())
            altCb.Value := modifiers.Get("alt", false)
            ctrlCb.Value := modifiers.Get("ctrl", false)
            shiftCb.Value := modifiers.Get("shift", false)
            winCb.Value := modifiers.Get("win", false)
        }
        
        settingsGui.Add("Button", "w200 y+10", "Edit Menu Structure").OnEvent("Click", (*) => this.EditMenuStructure())
        settingsGui.Add("Button", "w200 y+5", "Edit Vendor Categories").OnEvent("Click", (*) => this.EditVendorCategories())
        
        saveBtn := settingsGui.Add("Button", "w100 y+10", "Save")
        saveBtn.OnEvent("Click", (*) => this.SaveSettings(settingsGui, styleDropdown))
        
        settingsGui.Show()
    }

    SaveSettings(settingsGui, styleDropdown) {
        this.settings.thirdSectionStyle := styleDropdown.Text = "Dynamic" ? "dynamic" : "static"
        
        ; Save hotkey settings
        for method, hotkeyInfo in this.hotkeys {
            hkEdit := settingsGui.Submit()[method . "Edit"]
            altCb := settingsGui.Submit()[method . "AltCb"]
            ctrlCb := settingsGui.Submit()[method . "CtrlCb"]
            shiftCb := settingsGui.Submit()[method . "ShiftCb"]
            winCb := settingsGui.Submit()[method . "WinCb"]
            
            this.hotkeys[method] := {
                key: hkEdit,
                modifiers: {alt: altCb, ctrl: ctrlCb, shift: shiftCb, win: winCb}
            }
        }
        
        this.SaveHotkeySettings()
        this.ReloadHotkeys()
        
        if (this.settings.thirdSectionStyle = "static") {
            this.CreateStaticSubcategoryButtons()
        } else {
            this.subcategoryListBox := this.gui.Add("ListBox", "w200 y+10 h200")
        }
        
        settingsGui.Destroy()
        this.gui.Destroy()
        this.CreateGui()
    }

    ReloadHotkeys() {
        ; Remove existing hotkeys
        for method, hotkeyInfo in this.hotkeys {
            modifiers := ""
            for mod, enabled in hotkeyInfo.modifiers {
                if (enabled) {
                    modifiers .= mod . " & "
                }
            }
            hotkey := modifiers . hotkeyInfo.key
            HotKey(hotkey, "Off")
        }
        
        ; Set up new hotkeys
        this.SetupHotkeys()
    }

    EditMenuStructure() {
        editGui := Gui("+Owner" . this.gui.Hwnd, "Edit Menu Structure")
        
        editGui.Add("Text", "w200", "Categories:")
        categoriesEdit := editGui.Add("Edit", "w200 h100 vCategories", this.StrJoin(this.menuStructure.menuCategories, "`n"))
        
        editGui.Add("Text", "w200 y+10", "Subcategories:")
        subcategoriesEdit := editGui.Add("Edit", "w400 h300 vSubcategories")
        for category in this.menuStructure.menuCategories {
            categoryKey := StrLower(StrReplace(category, " / ", ""))
            subcategoriesEdit.Value .= category . ":`n" . this.StrJoin(this.menuStructure[categoryKey], "`n") . "`n`n"
        }
        
        saveBtn := editGui.Add("Button", "w100 y+10", "Save")
        saveBtn.OnEvent("Click", (*) => this._SaveMenuStructure(editGui))
        
        editGui.Show()
    }

    _SaveMenuStructure(editGui) {
        newMenuCategories := StrSplit(editGui.Submit()["Categories"], "`n", "`r")
        newSubcategories := {}
        
        subcategoriesText := editGui.Submit()["Subcategories"]
        currentCategory := ""
        for line in StrSplit(subcategoriesText, "`n", "`r") {
            if (SubStr(line, -1) = ":") {
                currentCategory := SubStr(line, 1, -1)
                categoryKey := StrLower(StrReplace(currentCategory, " / ", ""))
                newSubcategories[categoryKey] := []
            } else if (line != "" && currentCategory != "") {
                categoryKey := StrLower(StrReplace(currentCategory, " / ", ""))
                newSubcategories[categoryKey].Push(line)
            }
        }
        
        this.menuStructure.menuCategories := newMenuCategories
        for key, value in newSubcategories {
            this.menuStructure[key] := value
        }
        
        this.SaveMenuStructure()
        editGui.Destroy()
        this.gui.Destroy()
        this.CreateGui()
    }

    EditVendorCategories() {
        editGui := Gui("+Owner" . this.gui.Hwnd, "Edit Vendor Categories")
        
        editGui.Add("Text", "w200", "Vendor Categories:")
        vendorCategoriesEdit := editGui.Add("Edit", "w300 h300 vVendorCategories")
        for vendor, categoryInfo in this.vendorCategories {
            vendorCategoriesEdit.Value .= vendor . ": " . categoryInfo.category . " - " . categoryInfo.subcategory . "`n"
        }
        
        saveBtn := editGui.Add("Button", "w100 y+10", "Save")
        saveBtn.OnEvent("Click", (*) => this._SaveVendorCategories(editGui))
        
        editGui.Show()
    }

    _SaveVendorCategories(editGui) {
        newVendorCategories := {}
        vendorCategoriesText := editGui.Submit()["VendorCategories"]
        
        for line in StrSplit(vendorCategoriesText, "`n", "`r") {
            if (line != "") {
                parts := StrSplit(line, ":")
                if (parts.Length >= 2) {
                    vendor := Trim(parts[1])
                    categoryParts := StrSplit(Trim(parts[2]), "-")
                    if (categoryParts.Length >= 2) {
                        category := Trim(categoryParts[1])
                        subcategory := Trim(categoryParts[2])
                        newVendorCategories[vendor] := {category: category, subcategory: subcategory}
                    }
                }
            }
        }
        
        this.vendorCategories := newVendorCategories
        this.SaveVendorCategories()
        editGui.Destroy()
    }

    UpdateUIATree() {
        try {
            chromeRiver := UIA.ElementFromChromium("Chrome River - Google Chrome")
            if (!chromeRiver) {
                this.Log("Chrome River window not found")
                return
            }
            
            expenseElement := this.FindCurrentExpenseElement(chromeRiver)
            if (!expenseElement) {
                this.Log("Current expense element not found")
                return
            }
            
            this.UpdateExpenseDetails(expenseElement)
            this.SuggestCategoryBasedOnVendor(expenseElement)
        } catch as err {
            this.Log("Error updating UIA tree: " . err.Message)
        }
    }

    FindCurrentExpenseElement(chromeRiver) {
        ; TODO: Implement logic to find the current expense element
        ; This is a placeholder implementation
        return chromeRiver.FindFirst({Type: "Group", Name: "help"})
    }

    UpdateExpenseDetails(expenseElement) {
        details := this.ExtractExpenseDetails(expenseElement)
        this.gui["ExpenseDetails"].Value := details
    }

    ExtractExpenseDetails(expenseElement) {
        ; TODO: Implement logic to extract expense details from the UIA element
        ; This is a placeholder implementation
        return "Date: " . expenseElement.CurrentName . "`nAmount: $XX.XX`nVendor: Unknown"
    }

    SuggestCategoryBasedOnVendor(expenseElement) {
        vendor := this.ExtractVendorName(expenseElement)
        if (this.vendorCategories.HasProp(vendor)) {
            suggestedCategory := this.vendorCategories[vendor].category
            suggestedSubcategory := this.vendorCategories[vendor].subcategory
            this.Log("Suggested category for " . vendor . ": " . suggestedCategory . " - " . suggestedSubcategory)
            ; TODO: Highlight or pre-select the suggested category and subcategory in the GUI
        }
    }

    ExtractVendorName(expenseElement) {
        ; TODO: Implement logic to extract vendor name from the UIA element
        ; This is a placeholder implementation
        return "Unknown Vendor"
    }

    PerformUIAInteraction(category, subcategory) {
        ; TODO: Implement UIA interactions to select the category and subcategory in Chrome River
        this.Log("Performing UIA interaction for " . category . " - " . subcategory)
    }

    CreateLogGui() {
        this.logGui := Gui("+Resize", "Chrome River Navigator Log")
        this.logEdit := this.logGui.Add("Edit", "ReadOnly w400 h300 vLogContent")
        this.logGui.Show()
    }

    Log(message, showGui := true) {
        ErrorLogger.Log(message, showGui)
    }

    CreateTrayMenu() {
        A_TrayMenu.Add("Open Chrome River", (*) => this.OpenChromeRiver())
        A_TrayMenu.Add("Toggle Auto-Open Chrome River", (*) => this.ToggleAutoOpenChromeRiver())
        A_TrayMenu.Add("Open Log", (*) => this.logGui.Show())
        A_TrayMenu.Add("Exit", (*) => ExitApp())
    }

    OpenChromeRiver() {
        if (!WinExist("Chrome River - Google Chrome")) {
            Run("chrome.exe https://www.chromeriver.com/login")
            this.Log("Opening Chrome River")
            if (this.settings.autoOpenChromeRiver) {
                SetTimer(() => this.CheckChromeRiverOpen(), -10000)
            }
        } else {
            WinActivate("Chrome River - Google Chrome")
            this.Log("Chrome River window activated")
        }
    }

    CheckChromeRiverOpen() {
        if (!WinExist("Chrome River - Google Chrome")) {
            this.Log("Chrome River not opened after 10 seconds")
            result := MsgBox("Chrome River did not open. Do you want to try again?", "Open Chrome River", 4)
            if (result == "Yes") {
                this.OpenChromeRiver()
            }
        }
    }

    ToggleAutoOpenChromeRiver() {
        this.settings.autoOpenChromeRiver := !this.settings.autoOpenChromeRiver
        this.Log("Auto-open Chrome River " . (this.settings.autoOpenChromeRiver ? "enabled" : "disabled"))
    }
}

; Create an instance of the ChromeRiverNavigator class
navigator := ChromeRiverNavigator()

; class ErrorLogger {
;     static logGui := {}
;     static logEdit := {}
    
;     static Init() {
;         this.logGui := Gui("+AlwaysOnTop -SysMenu +ToolWindow", "Error Log")  ; Added ToolWindow style
;         this.logEdit := this.logGui.Add("Edit", "ReadOnly w400 h300 vLogContent")
;         this.logGui.OnEvent("Close", (*) => this.logGui.Hide())
;         this.logGui.Show("NoActivate")  ; Show without activating
;     }
    
;     static Log(message, showGui := true) {
;         timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
;         logMessage := timestamp . ": " . message . "`n"
        
;         if (!this.logEdit.HasProp("Value")) {
;             this.Init()
;         }
        
;         this.logEdit.Value .= logMessage
;         this.logEdit.Opt("+Redraw")
;         OutputDebug(logMessage)
        
;         if (showGui) {
;             this.logGui.Show("NoActivate")  ; Show without activating
;         }
;     }
; }
