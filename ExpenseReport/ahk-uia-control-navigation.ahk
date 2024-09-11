; #Requires AutoHotkey v2.0
; #SingleInstance Force

; ; Include the UIAutomation library
; #Include <Directives\__AE.v2>
; ; #include <System\UIA>

; ; Define the control name we're looking for
; global controlName := "help"

; ; Initialize an array to store the control elements
; global controls := []

; ; Variable to keep track of the current control index
; global currentIndex := 0

; ; Function to find all instances of the specified control within Chrome River
; findControls() {
;     global controls, controlName
;     controls := []
    
;     ; Get the Chrome River element
;     title := 'Chrome River - Google Chrome'
;     cacheRequest := UIA.CreateCacheRequest()
;     cacheRequest.TreeScope := 5
;     cacheRequest := UIA.CreateCacheRequest(["Type", "LocalizedType", "AutomationId", "Name", "Value", "ClassName", "AcceleratorKey", "WindowCanMaximize"], ["Window"], "Subtree")
;     expRpt := UIA.ElementFromChromium(title, cacheRequest)

;     if (expRpt) {
;         ; Find all elements with the specified name within Chrome River
;         ; We're looking for groups with the name "help"
;         foundControls := expRpt.FindAll({Type: '50026 (Group)', Name: 'help', LocalizedType: 'group'})
;         ; Add found controls to the global array
;         for control in foundControls {
;             controls.Push(control)
;             ; Infos(control)
;         }
;         ; MsgBox("Found " . controls.Length . " 'group help' controls.")
;     } else {
;         MsgBox("Chrome River window not found.")
;     }
    
;     return controls.Length
; }

; ; Hotkey to move to the next control (Ctrl+N in this example)
; ^n::
; {
;     global controls, currentIndex
    
;     ; Find controls if not already found
;     if (controls.Length == 0) {
;         count := findControls()
;         if (count == 0) {
;             MsgBox("No 'group help' controls found in Chrome River.")
;             return
;         }
;     }
    
;     ; Move to the next control
;     currentIndex++
;     if (currentIndex > controls.Length) {
;         currentIndex := 1  ; Wrap around to the first control
;     }
    
;     ; Focus and scroll to the control
;     try {
;         if (currentIndex <= 0 || currentIndex > controls.Length) {
;             throw Error("Invalid index: " . currentIndex)
;         }
        
;         control := controls[currentIndex]
;         if (!control) {
;             throw Error("Control at index " . currentIndex . " is null")
;         }
        
;         control.SetFocus()
;         control.ScrollIntoView()
        
;         ; Get the parent element (which should contain the transaction details)
;         parent := control.Parent
;         if (!parent) {
;             throw Error("Parent element not found")
;         }

;         ; Try to find the date and amount within the parent element
;         dateElement := parent.FindFirst({LocalizedControlType: "text"})
;         amountElements := parent.FindAll({LocalizedControlType: "text"})
        
;         date := dateElement ? dateElement.Name : "Date not found"
;         amount := amountElements.Length >= 2 ? amountElements[-2].Name : "Amount not found"
        
;         ToolTip("Moved to 'group help' " . currentIndex . " of " . controls.Length . "`nDate: " . date . "`nAmount: " . amount)
;         SetTimer(() => ToolTip(), -3000)  ; Remove tooltip after 3 seconds
;     } catch as e {
;         MsgBox("Error focusing control: " . e.Message . "`nCurrent Index: " . currentIndex . "`nTotal Controls: " . controls.Length)
;     }
; }

; ; Optional: Hotkey to refresh the control list (Ctrl+R in this example)
; ^r::
; {
;     global currentIndex
;     currentIndex := 0  ; Reset the index when refreshing
;     count := findControls()
;     MsgBox("Found " . count . " 'group help' controls in Chrome River.")
; }
; #Requires AutoHotkey v2.0
; #SingleInstance Force

; ; Include the UIAutomation library
; #Include <Directives\__AE.v2>

; class ChromeRiverNavigator {
;     controlName := "help"
;     controls := []
;     currentIndex := 0

;     __New() {
;         this.SetupHotkeys()
;     }

;     SetupHotkeys() {
;         HotIf() => WinActive("Chrome River - Google Chrome")
;         Hotkey("^n", (*) => this.NavigateNext())
;         Hotkey("^r", (*) => this.RefreshControls())
;         HotIf()
;     }

;     FindControls() {
;         this.controls := []
        
;         title := 'Chrome River - Google Chrome'
;         cacheRequest := UIA.CreateCacheRequest()
;         cacheRequest.TreeScope := 5
;         ; cacheRequest := UIA.CreateCacheRequest(["Type", "LocalizedType", "AutomationId", "Name", "Value", "ClassName", "AcceleratorKey", "WindowCanMaximize"], ["Window"], "Subtree")
;         expRpt := UIA.ElementFromChromium(title, cacheRequest)

;         if (expRpt) {
;             foundControls := expRpt.FindAll({Type: '50026 (Group)', Name: this.controlName, LocalizedType: 'group'})
;             for control in foundControls {
;                 this.controls.Push(control)
;             }
;         } else {
;             MsgBox("Chrome River window not found.")
;         }
        
;         return this.controls.Length
;     }

;     NavigateNext() {
;         if (this.controls.Length == 0) {
;             count := this.FindControls()
;             if (count == 0) {
;                 MsgBox("No 'group help' controls found in Chrome River.")
;                 return
;             }
;         }
        
;         this.currentIndex++
;         if (this.currentIndex > this.controls.Length) {
;             this.currentIndex := 1  ; Wrap around to the first control
;         }
        
;         this.FocusCurrentControl()
;     }

;     FocusCurrentControl() {
;         try {
;             if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;                 throw Error("Invalid index: " . this.currentIndex)
;             }
            
;             control := this.controls[this.currentIndex]
;             if (!control) {
;                 throw Error("Control at index " . this.currentIndex . " is null")
;             }
            
;             control.SetFocus()
;             control.ScrollIntoView()
            
;             parent := control.Parent
;             if (!parent) {
;                 throw Error("Parent element not found")
;             }

;             dateElement := parent.FindFirst({LocalizedControlType: "text"})
;             amountElements := parent.FindAll({LocalizedControlType: "text"})
            
;             date := dateElement ? dateElement.Name : "Date not found"
;             amount := amountElements.Length >= 2 ? amountElements[-2].Name : "Amount not found"
            
;             ToolTip("Moved to 'group help' " . this.currentIndex . " of " . this.controls.Length . "`nDate: " . date . "`nAmount: " . amount)
;             SetTimer(() => ToolTip(), -3000)  ; Remove tooltip after 3 seconds
;         } catch as e {
;             MsgBox("Error focusing control: " . e.Message . "`nCurrent Index: " . this.currentIndex . "`nTotal Controls: " . this.controls.Length)
;         }
;     }

;     RefreshControls() {
;         this.currentIndex := 0  ; Reset the index when refreshing
;         count := this.FindControls()
;         MsgBox("Found " . count . " 'group help' controls in Chrome River.")
;     }
; }

; ; Create an instance of the ChromeRiverNavigator class
; navigator := ChromeRiverNavigator()

; #Requires AutoHotkey v2.0
; #SingleInstance Force

; ; Include the UIAutomation library
; #Include <Directives\__AE.v2>

; class ChromeRiverNavigator {
;     controlName := "help"
;     controls := []
;     currentIndex := 0
;     menuItems := ["Travel", "Meals / Entertainment", "Telecom", "Company Car", "Office Expenses", "Professional Memberships / Development", "Fees / Advances", "Misc", "Engineer / Equipment"]

;     __New() {
;         this.SetupHotkeys()
;     }

;     SetupHotkeys() {
;         HotIf() => WinActive("Chrome River - Google Chrome")
;         Hotkey("^n", (*) => this.NavigateNext())
;         Hotkey("^r", (*) => this.RefreshControls())
;         Hotkey("^c", (*) => this.ClickCurrentControl())
;         HotIf
;     }

;     FindControls() {
;         this.controls := []
        
;         title := 'Chrome River - Google Chrome'
;         cacheRequest := UIA.CreateCacheRequest()
;         cacheRequest.TreeScope := 5
;         expRpt := UIA.ElementFromChromium(title, cacheRequest)

;         if (expRpt) {
;             foundControls := expRpt.FindAll({Type: '50026 (Group)', Name: this.controlName, LocalizedType: 'group'})
;             for control in foundControls {
;                 this.controls.Push(control)
;             }
;         } else {
;             MsgBox("Chrome River window not found.")
;         }
        
;         return this.controls.Length
;     }

;     NavigateNext() {
;         if (this.controls.Length == 0) {
;             count := this.FindControls()
;             if (count == 0) {
;                 MsgBox("No 'group help' controls found in Chrome River.")
;                 return
;             }
;         }
        
;         this.currentIndex++
;         if (this.currentIndex > this.controls.Length) {
;             this.currentIndex := 1  ; Wrap around to the first control
;         }
        
;         this.FocusCurrentControl()
;     }

;     FocusCurrentControl() {
;         try {
;             if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;                 throw Error("Invalid index: " . this.currentIndex)
;             }
            
;             control := this.controls[this.currentIndex]
;             if (!control) {
;                 throw Error("Control at index " . this.currentIndex . " is null")
;             }
            
;             control.SetFocus()
;             control.ScrollIntoView()
            
;             parent := control.Parent
;             if (!parent) {
;                 throw Error("Parent element not found")
;             }

;             dateElement := parent.FindFirst({LocalizedControlType: "text"})
;             amountElements := parent.FindAll({LocalizedControlType: "text"})
            
;             date := dateElement ? dateElement.Name : "Date not found"
;             amount := amountElements.Length >= 2 ? amountElements[-2].Name : "Amount not found"
            
;             ToolTip("Moved to 'group help' " . this.currentIndex . " of " . this.controls.Length . "`nDate: " . date . "`nAmount: " . amount . "`nPress Ctrl+C to click and show menu")
;             SetTimer(() => ToolTip(), -5000)  ; Remove tooltip after 5 seconds
;         } catch as e {
;             MsgBox("Error focusing control: " . e.Message . "`nCurrent Index: " . this.currentIndex . "`nTotal Controls: " . this.controls.Length)
;         }
;     }

;     ClickCurrentControl() {
;         if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;             MsgBox("No control currently selected.")
;             return
;         }

;         control := this.controls[this.currentIndex]
;         control.Click()

;         ; Wait for the popup menu to appear
;         Sleep(500)

;         ; Try to find and interact with the popup menu
;         this.InteractWithPopupMenu()
;     }

;     InteractWithPopupMenu() {
;         try {
;             ; Find all menu items directly
;             chromeRiver := UIA.ElementFromChromium('Chrome River - Google Chrome')
;             menuItems := chromeRiver.FindAll({Type: "MenuItem"})
            
;             if (menuItems.Length == 0) {
;                 throw Error("No menu items found")
;             }

;             ; Display menu items
;             menuText := "Menu Items:`n"
;             for index, item in menuItems {
;                 menuText .= index . ": " . item.Name . "`n"
;             }

;             ; Show menu items and prompt for selection
;             selectedIndex := InputBox("Select Menu Item (or press Cancel to close menu)", "Menu Selection", "w300 h400", menuText)

;             if (selectedIndex.Result == "OK") {
;                 if (Integer(selectedIndex.Value) > 0 && Integer(selectedIndex.Value) <= menuItems.Length) {
;                     selectedItem := menuItems[Integer(selectedIndex.Value)]
;                     selectedItem.Click()
;                     ToolTip("Selected: " . selectedItem.Name)
;                     SetTimer(() => ToolTip(), -3000)
;                 } else {
;                     MsgBox("Invalid selection.")
;                 }
;             } else {
;                 ; User cancelled, so let's try to close the menu
;                 chromeRiver.Click()  ; Click somewhere else to close the menu
;             }
;         } catch as e {
;             MsgBox("Error interacting with popup menu: " . e.Message)
;         }
;     }

;     RefreshControls() {
;         this.currentIndex := 0  ; Reset the index when refreshing
;         count := this.FindControls()
;         MsgBox("Found " . count . " 'group help' controls in Chrome River.")
;     }
; }

; ; Create an instance of the ChromeRiverNavigator class
; navigator := ChromeRiverNavigator()

#Requires AutoHotkey v2.0
#SingleInstance Force

; Include the UIAutomation library
#Include <Directives\__AE.v2>

; class ChromeRiverNavigator {
;     controlName := "help"
;     controls := []
;     currentIndex := 0
;     menuGui := {}

;     menuCategories := ["Travel", "Meals / Entertainment", "Telecom", "Office Expenses", "Company Car", "Professional Memberships / Development", "Fees / Advances", "Misc", "Engineer / Equipment"]
    
;     travelItems := ["Airfare", "Airline Fee", "Business Mileage - Personal Car", "Car Rental", "Car Rental - Fuel", "Car Service", "Gift in Lieu of Hotel", "Ground Travel", "Hotel", "Parking and Tolls", "Passport / Visa / Immigration Fees", "Rail", "Tips / Gratuities", "Travel Agency Transaction Fees - TMC"]
;     mealsItems := ["Client Gifts", "Client Meals", "Employee Meals", "Entertainment", "Events", "Mkt Client Event", "Other Client Related Expenses"]
;     telecomItems := ["Mobile Cellular / Data Charges", "Cellular Broadband / MiFi", "Home Internet", "Hot Spot / Wifi Charges", "Phone / Business Calls"]
;     officeItems := ["Office Supplies", "Outside Printing / Photocopying Charges", "Postage / Mail / Couriers", "Software"]
;     companyCarItems := ["Fuel / Company Car", "Mileage / Company Car", "Wash / Company Car", "Other / Company Car", "Home Charger Installation", "Home Charging Electricity Costs", "EV Public Charging Station"]
;     professionalItems := ["Annual Membership Fees", "Certification / Re-Certification", "Conference / Seminar Fees", "Professional Association Dues", "Subscriptions"]
;     feesItems := ["Bank / ATM Fees", "Cash Advance", "Foreign Transaction Fees"]
;     miscItems := ["Employee Medical", "Meeting Room", "Personal / Amex Expense", "SWE - Soc of Women Eng", "Trade Show Expense", "Other / Misc", "Memorial / Expressions of Sympathy", "Employee Gifts"]
;     engineerItems := ["Engineering Supply / Tools", "Maps", "Safety Expenses", "Sundry Service / Water Test"]
;     menuItems := Map(
;         "Travel", [this.travelItems],
;         "Meals / Entertainment", [this.mealsItems],
;         "Telecom", [this.telecomItems],
;         "Company Car", [this.companyCarItems],
;         "Office Expenses", [this.officeItems],
;         "Professional Memberships / Development", [this.professionalItems],
;         "Fees / Advances", [this.feesItems],
;         "Misc", [this.miscItems],
;         "Engineer / Equipment", [this.engineerItems],
;         'Itemized Expense', 'Itemized Expense'
;     )
;     __New() {
;         this.SetupHotkeys()
;     }

;     SetupHotkeys() {
;         HotIf() => WinActive("Chrome River - Google Chrome")
;         Hotkey("^n", (*) => this.NavigateNext())
;         Hotkey("^p", (*) => this.NavigatePrevious())
;         Hotkey("^r", (*) => this.RefreshControls())
;         Hotkey("!s", (*) => this.ClickCurrentControl())
;         HotIf
;     }

;     FindControls() {
;         this.controls := []
        
;         title := 'Chrome River - Google Chrome'
;         cacheRequest := UIA.CreateCacheRequest()
;         cacheRequest.TreeScope := 5
;         expRpt := UIA.ElementFromChromium(title, cacheRequest)

;         if (expRpt) {
;             foundControls := expRpt.FindAll({Type: '50026 (Group)', Name: this.controlName, LocalizedType: 'group'})
;             for control in foundControls {
;                 this.controls.Push(control)
;             }
;         } else {
;             MsgBox("Chrome River window not found.")
;         }
        
;         return this.controls.Length
;     }

;     NavigateNext() {
;         if (this.controls.Length == 0) {
;             count := this.FindControls()
;             if (count == 0) {
;                 MsgBox("No 'group help' controls found in Chrome River.")
;                 return
;             }
;         }
        
;         this.currentIndex++
;         if (this.currentIndex > this.controls.Length) {
;             this.currentIndex := 1  ; Wrap around to the first control
;         }
        
;         this.FocusCurrentControl()
;     }

;     NavigatePrevious() {
;         if (this.controls.Length == 0) {
;             this.FindControls()
;         }
        
;         if (this.controls.Length > 0) {
;             this.currentIndex--
;             if (this.currentIndex < 1) {
;                 this.currentIndex := this.controls.Length
;             }
;             this.FocusCurrentControl()
;         } else {
;             MsgBox("No 'help' groups found")
;         }
;     }

;     FocusCurrentControl() {
;         try {
;             if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;                 throw Error("Invalid index: " . this.currentIndex)
;             }
            
;             control := this.controls[this.currentIndex]
;             if (!control) {
;                 throw Error("Control at index " . this.currentIndex . " is null")
;             }
            
;             control.SetFocus()
;             control.ScrollIntoView()
            
;             parent := control.Parent
;             if (!parent) {
;                 throw Error("Parent element not found")
;             }

;             dateElement := parent.FindFirst({LocalizedControlType: "text"})
;             amountElements := parent.FindAll({LocalizedControlType: "text"})
            
;             date := dateElement ? dateElement.Name : "Date not found"
;             amount := amountElements.Length >= 2 ? amountElements[-2].Name : "Amount not found"
            
;             ToolTip("Moved to 'group help' " . this.currentIndex . " of " . this.controls.Length . "`nDate: " . date . "`nAmount: " . amount . "`nPress Alt&s to click and show menu")
;             SetTimer(() => ToolTip(), -5000)  ; Remove tooltip after 5 seconds
;         } catch as e {
;             MsgBox("Error focusing control: " . e.Message . "`nCurrent Index: " . this.currentIndex . "`nTotal Controls: " . this.controls.Length)
;         }
;     }

;     ClickCurrentControl() {
;         if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;             MsgBox("No control currently selected.")
;             return
;         }

;         control := this.controls[this.currentIndex]
;         control.Click()

;         ; Wait for the popup menu to appear
;         Sleep(500)

;         ; Try to find and interact with the popup menu
;         this.InteractWithPopupMenu()
;     }

;     InteractWithPopupMenu() {
;         try {
;             ; Find all menu items directly
;             chromeRiver := UIA.ElementFromChromium('Chrome River - Google Chrome')
;             menuItems := chromeRiver.FindAll({Type: "MenuItem"})
;             buttonItems := chromeRiver.FindAll([{Type: "MenuItem"}, {Type: '50000 (Button)'}])

;             if (buttonItems.Length == 0) {
;                 ; throw Error("No menu items found")
;                 this.CreateMenuGui(menuItems)
;             }
;             else {
;                 this.CreateMenuGui(buttonItems)
;             }

;         } catch as e {
;             MsgBox("Error interacting with popup menu: " . e.Message)
;         }
;     }

;     CreateMenuGui(menuItems) {
;         this.menuGui := Gui("+AlwaysOnTop", "Menu Selection")
;         buttonWidth := 200
;         buttonHeight := 30
;         guiWidth := buttonWidth + 20
;         guiHeight := (buttonHeight + 5) * menuItems.Length + 10

;         for index, item in menuItems {
;             hotkeyChar := SubStr(item.Name, 1, 1)
;             buttonText := "&" . hotkeyChar . " - " . item.Name
;             btn := this.menuGui.Add("Button", "w" . buttonWidth . " h" . buttonHeight . " x10 y" . (index - 1) * (buttonHeight + 5) + 5, buttonText)
;             btn.OnEvent("Click", this.CreateHandleMenuSelection(item))
;         }

;         closeBtn := this.menuGui.Add("Button", "w" . buttonWidth . " h" . buttonHeight . " x10 y" . guiHeight - buttonHeight - 5, "&Close")
;         closeBtn.OnEvent("Click", (*) => this.menuGui.Destroy())

;         this.menuGui.OnEvent("Escape", (*) => this.menuGui.Destroy())
;         this.menuGui.Show("w" . guiWidth . " h" . guiHeight)
;     }

;     CreateHandleMenuSelection(item) {
;         return (*) => this.HandleMenuSelection(item)
;     }

;     HandleMenuSelection(item) {
;         this.menuGui.Destroy()
;         item.Click()
;         ToolTip("Selected: " . item.Name)
;         SetTimer(() => ToolTip(), -3000)

;         ; Check for submenus (you may need to adjust this based on the actual structure)
;         Sleep(500)  ; Wait for potential submenu to appear
;         chromeRiver := UIA.ElementFromChromium('Chrome River - Google Chrome')
;         subMenuItems := chromeRiver.FindAll({Type: "MenuItem"})
        
;         if (subMenuItems.Length > 0) {
;             this.CreateMenuGui(subMenuItems)  ; Create a new GUI for the submenu
;         }
;     }

;     RefreshControls() {
;         this.currentIndex := 0  ; Reset the index when refreshing
;         count := this.FindControls()
;         MsgBox("Found " . count . " 'group help' controls in Chrome River.")
;     }
; }

; Create an instance of the ChromeRiverNavigator class
; navigator := ChromeRiverNavigator()

; #Requires AutoHotkey v2.0
; #SingleInstance Force

; ; Include the UIAutomation library
; #Include <Directives\__AE.v2>
; #Include <..\Peep\PeepAHK\script\Peep.v2>
; ^+p::{
;     ; Peep(ChromeRiverNavigator)
;     ; Create an instance of the ChromeRiverNavigator class
;     navigator := ChromeRiverNavigator()
; }
; class ChromeRiverNavigator {
;     controlName := "help"
;     controls := []
;     currentIndex := 0
;     mainGui := {}
;     secondaryGui := {}
;     isSecondaryGuiOpen := false
    
;     menuCategories := ["Travel", "Meals / Entertainment", "Telecom", "Office Expenses", "Company Car", "Professional Memberships / Development", "Fees / Advances", "Misc", "Engineer / Equipment"]
    
;     travelItems := ["Airfare", "Airline Fee", "Business Mileage - Personal Car", "Car Rental", "Car Rental - Fuel", "Car Service", "Gift in Lieu of Hotel", "Ground Travel", "Hotel", "Parking and Tolls", "Passport / Visa / Immigration Fees", "Rail", "Tips / Gratuities", "Travel Agency Transaction Fees - TMC"]
;     mealsItems := ["Client Gifts", "Client Meals", "Employee Meals", "Entertainment", "Events", "Mkt Client Event", "Other Client Related Expenses"]
;     telecomItems := ["Mobile Cellular / Data Charges", "Cellular Broadband / MiFi", "Home Internet", "Hot Spot / Wifi Charges", "Phone / Business Calls"]
;     officeItems := ["Office Supplies", "Outside Printing / Photocopying Charges", "Postage / Mail / Couriers", "Software"]
;     companyCarItems := ["Fuel / Company Car", "Mileage / Company Car", "Wash / Company Car", "Other / Company Car", "Home Charger Installation", "Home Charging Electricity Costs", "EV Public Charging Station"]
;     professionalItems := ["Annual Membership Fees", "Certification / Re-Certification", "Conference / Seminar Fees", "Professional Association Dues", "Subscriptions"]
;     feesItems := ["Bank / ATM Fees", "Cash Advance", "Foreign Transaction Fees"]
;     miscItems := ["Employee Medical", "Meeting Room", "Personal / Amex Expense", "SWE - Soc of Women Eng", "Trade Show Expense", "Other / Misc", "Memorial / Expressions of Sympathy", "Employee Gifts"]
;     engineerItems := ["Engineering Supply / Tools", "Maps", "Safety Expenses", "Sundry Service / Water Test"]

;     mainGuiItems := ["First 'help' Group", "Previous", "Next", "Select Item", "Check for Updates"]

;     __New() {
;         this.CheckForUpdates()
;         this.SetupHotkeys()
;         this.CreateMainGui(this.mainGuiItems)
;     }

;     SetupHotkeys() {
;         HotIf() => WinActive("Chrome River - Google Chrome")
;         Hotkey("^n", (*) => this.NavigateNext())
;         Hotkey("^p", (*) => this.NavigatePrevious())
;         Hotkey("^r", (*) => this.RefreshControls())
;         Hotkey("^c", (*) => this.ToggleSelectItem())
;         HotIf
;     }

;     CreateMainGui(guiobj) {
;         mainGui := Gui("+AlwaysOnTop", "Chrome River Navigator")
;         buttonWidth := 200
;         buttonHeight := 30

;         ; Add main GUI buttons
;         yPos := 10
;         for each, value in this.mainGuiItems {
;             mainGui.AddButton("w" . buttonWidth . " h" . buttonHeight . " x10 y" . yPos, value)
;                 .OnEvent("Click", this.CreateMainButtonHandler(value))
;             yPos += 35
;         }

;         this.mainGui.OnEvent("Close", (*) => ExitApp())
;         this.mainGui.Show()
;     }

;     CreateMainButtonHandler(item) {
;         switch {
;             case (item == "First 'help' Group"):
;                 this.SelectFirstHelpGroup()
;             case (item == "Previous"):
;                 this.NavigatePrevious()
;             case (item == "Next"):
;                 this.NavigateNext()
;             case (item == "Select Item"):
;                 this.ToggleSelectItem()
;             case (item == "Check for Updates"):
;                 this.CheckForUpdates()
;         }
;     }

;     HandleButtonClick(item) {
;         chromeRiver := UIA.ElementFromChromium('Chrome River - Google Chrome')
;         element := chromeRiver.FindFirst({Name: item, Type: "MenuItem"})
;         if (!element) {
;             element := chromeRiver.FindFirst({Name: item, Type: "Button"})
;         }
;         if (element) {
;             element.Click()
;         } else {
;             MsgBox(item . " not found")
;         }
;     }

;     HandleCategoryClick(category) {
;         switch category {
;             case "Travel":
;                 this.CreateCategoryGui(this.travelItems, "Travel Expenses")
;             case "Meals / Entertainment":
;                 this.CreateCategoryGui(this.mealsItems, "Meals / Entertainment Expenses")
;             case "Telecom":
;                 this.CreateCategoryGui(this.telecomItems, "Telecom Expenses")
;             case "Office Expenses":
;                 this.CreateCategoryGui(this.officeItems, "Office Expenses")
;             case "Company Car":
;                 this.CreateCategoryGui(this.companyCarItems, "Company Car Expenses")
;             case "Professional Memberships / Development":
;                 this.CreateCategoryGui(this.professionalItems, "Professional Memberships / Development Expenses")
;             case "Fees / Advances":
;                 this.CreateCategoryGui(this.feesItems, "Fees / Advances Expenses")
;             case "Misc":
;                 this.CreateCategoryGui(this.miscItems, "Miscellaneous Expenses")
;             case "Engineer / Equipment":
;                 this.CreateCategoryGui(this.engineerItems, "Engineer / Equipment Expenses")
;             default:
;                 this.HandleButtonClick(category)
;         }
;     }

;     CreateCategoryGui(items, title) {
;         categoryGui := Gui("+AlwaysOnTop", title)
;         buttonWidth := 300
;         buttonHeight := 30

;         for index, item in items {
;             categoryGui.Add("Button", "w" . buttonWidth . " h" . buttonHeight . " x10 y" . (index - 1) * (buttonHeight + 5) + 5, item)
;                 .OnEvent("Click", (*) => this.HandleItemClick(item))
;         }

;         categoryGui.Show()
;     }

;     HandleItemClick(item) {
;         chromeRiver := UIA.ElementFromChromium('Chrome River - Google Chrome')
;         element := chromeRiver.FindFirst({Name: item, Type: "Button"})
;         if (element) {
;             element.Click()
;         } else {
;             MsgBox(item . " not found")
;         }
;     }

;     SelectFirstHelpGroup() {
;         this.FindControls()
;         if (this.controls.Length > 0) {
;             this.currentIndex := 1
;             this.FocusCurrentControl()
;         } else {
;             MsgBox("No 'help' groups found")
;         }
;     }

;     NavigateNext() {
;         if (this.controls.Length == 0) {
;             this.FindControls()
;         }
        
;         if (this.controls.Length > 0) {
;             this.currentIndex++
;             if (this.currentIndex > this.controls.Length) {
;                 this.currentIndex := 1
;             }
;             this.FocusCurrentControl()
;         } else {
;             MsgBox("No 'help' groups found")
;         }
;     }

;     NavigatePrevious() {
;         if (this.controls.Length == 0) {
;             this.FindControls()
;         }
        
;         if (this.controls.Length > 0) {
;             this.currentIndex--
;             if (this.currentIndex < 1) {
;                 this.currentIndex := this.controls.Length
;             }
;             this.FocusCurrentControl()
;         } else {
;             MsgBox("No 'help' groups found")
;         }
;     }

;     FocusCurrentControl() {
;         try {
;             if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;                 throw Error("Invalid index: " . this.currentIndex)
;             }
            
;             control := this.controls[this.currentIndex]
;             if (!control) {
;                 throw Error("Control at index " . this.currentIndex . " is null")
;             }
            
;             control.SetFocus()
;             control.ScrollIntoView()
            
;             parent := control.Parent
;             if (!parent) {
;                 throw Error("Parent element not found")
;             }

;             dateElement := parent.FindFirst({LocalizedControlType: "text"})
;             amountElements := parent.FindAll({LocalizedControlType: "text"})
            
;             date := dateElement ? dateElement.Name : "Date not found"
;             amount := amountElements.Length >= 2 ? amountElements[-2].Name : "Amount not found"
            
;             ToolTip("Moved to 'group help' " . this.currentIndex . " of " . this.controls.Length . "`nDate: " . date . "`nAmount: " . amount)
;             SetTimer(() => ToolTip(), -5000)  ; Remove tooltip after 5 seconds
;         } catch as e {
;             MsgBox("Error focusing control: " . e.Message . "`nCurrent Index: " . this.currentIndex . "`nTotal Controls: " . this.controls.Length)
;         }
;     }

;     ToggleSelectItem() {
;         if (this.isSecondaryGuiOpen) {
;             this.CloseSecondaryGui()
;         } else {
;             this.ClickCurrentControl()
;         }
;     }

;     ClickCurrentControl() {
;         if (this.currentIndex <= 0 || this.currentIndex > this.controls.Length) {
;             MsgBox("No control currently selected.")
;             return
;         }

;         control := this.controls[this.currentIndex]
;         control.Click()

;         ; Wait for the popup menu to appear
;         Sleep(500)

;         ; Create the secondary GUI with menu items
;         this.CreateSecondaryGui()
;     }

;     CreateSecondaryGui() {
;         this.secondaryGui := Gui("+AlwaysOnTop", "Menu Selection")
;         buttonWidth := 200
;         buttonHeight := 30
;         guiWidth := buttonWidth + 20
;         guiHeight := (buttonHeight + 5) * this.menuCategories.Length + 10

;         for index, item in this.menuCategories {
;             hotkeyChar := SubStr(item, 1, 1)
;             buttonText := "&" . hotkeyChar . " - " . item
;             btn := this.secondaryGui.Add("Button", "w" . buttonWidth . " h" . buttonHeight . " x10 y" . (index - 1) * (buttonHeight + 5) + 5, buttonText)
;             btn.OnEvent("Click", (*) => this.HandleCategoryClick(item))
;         }

;         closeBtn := this.secondaryGui.Add("Button", "w" . buttonWidth . " h" . buttonHeight . " x10 y" . guiHeight - buttonHeight - 5, "&Close")
;         closeBtn.OnEvent("Click", (*) => this.CloseSecondaryGui())

;         this.secondaryGui.OnEvent("Escape", (*) => this.CloseSecondaryGui())
;         this.secondaryGui.Show("w" . guiWidth . " h" . guiHeight)
;         this.isSecondaryGuiOpen := true
;     }

;     CloseSecondaryGui() {
;         if (this.secondaryGui) {
;             this.secondaryGui.Destroy()
;             this.secondaryGui := {}
;         }
;         this.isSecondaryGuiOpen := false
;     }

;     RefreshControls() {
;         this.currentIndex := 0  ; Reset the index when refreshing
;         count := this.FindControls()
;         MsgBox("Found " . count . " 'group help' controls in Chrome River.")
;     }

;     FindControls() {
;         this.controls := []
        
;         title := 'Chrome River - Google Chrome'
;         cacheRequest := UIA.CreateCacheRequest()
;         cacheRequest.TreeScope := 5
;         expRpt := UIA.ElementFromChromium(title, cacheRequest)

;         if (expRpt) {
;             foundControls := expRpt.FindAll({Type: '50026 (Group)', Name: this.controlName, LocalizedType: 'group'})
;             for control in foundControls {
;                 this.controls.Push(control)
;             }
;         } else {
;             MsgBox("Chrome River window not found.")
;         }
        
;         return this.controls.Length
;     }

;     CheckForUpdates() {
;         jsonFile := "menu_structure.json"
        
;         if (!FileExist(jsonFile)) {
;             this.CreateDefaultJsonFile(jsonFile)
;         }

;         try {
;             ; Read the JSON file
;             jsonText := FileRead(jsonFile)
            
;             ; Parse the JSON
;             menuStructure := JSON.Parse(jsonText)
            
;             ; Update the class properties
;             for category, items in menuStructure {
;                 if (this.HasProp(category . "Items")) {
;                     this.%category . "Items"% := items
;                 }
;             }
            
;             ; Update the menuCategories if present in the JSON
;             if (menuStructure.HasOwnProp("menuCategories")) {
;                 this.menuCategories := menuStructure.menuCategories
;             }
            
;             ; Recreate the main GUI to reflect any changes
;             this.RecreateMainGui()
            
;             MsgBox("Menu structure updated successfully.")
;         } catch as err {
;             MsgBox("Error updating menu structure: " . err.Message)
;         }
;     }

;     CreateDefaultJsonFile(jsonFile) {
;         defaultStructure := {
;             menuCategories: this.menuCategories,
;             travel: this.travelItems,
;             meals: this.mealsItems,
;             telecom: this.telecomItems,
;             office: this.officeItems,
;             companyCar: this.companyCarItems,
;             professional: this.professionalItems,
;             fees: this.feesItems,
;             misc: this.miscItems,
;             engineer: this.engineerItems
;         }

;         jsonText := JSON.Stringify(defaultStructure, 4)  ; 4 spaces for indentation
;         FileAppend(jsonText, jsonFile)
;     }

;     RecreateMainGui() {
;         if (this.mainGui) {
;             this.mainGui.Destroy()
;         }
;         this.CreateMainGui(this.mainGuiItems)
;     }
; }


