#Requires AutoHotkey v2.0
#Include <Directives\__AE.v2>

class ChromeRiverGUI {
    categories := {}
    mainGui := {}
    unclassifiedExpenses := []
    currentExpenseIndex := 1
    showInfoEnabled := false
    useOutputDebug := false
    infoTimer := 0
    tray := A_TrayMenu
    currentMonthYear := ''
    expRpt := this.GetChromeRiverElement(&expRpt)
    categoryOrder := []

    __New() {
        this.SetupTrayMenu()
        this._categories := Categories()
        this.categoryOrder := this._categories.GetCategories()
        this.CreateGUI()
        this.LoadUnclassifiedExpenses()
        this.ShowGUI()
    }

    GetCurrentMonthYear() {
        monthYearElement := []
        if (this.GetChromeRiverElement(&expRpt)) {
            monthYearElement := expRpt.FindCachedElement({Type: '50020 (Text)', LocalizedType: 'text'})
            if (monthYearElement && monthYearElement.Name) {
                this.currentMonthYear := monthYearElement.Name
            } else {
                this.currentMonthYear := FormatTime(, 'MMMM yyyy')  ; Fallback to current month/year
            }
        } else {
            this.currentMonthYear := FormatTime(, 'MMMM yyyy')  ; Fallback to current month/year
        }
    }

    SetupTrayMenu() {
        this.tray.Add('Toggle Info Display', (*) => this.ToggleInfoDisplay())
        this.tray.Add('Toggle Output Mode', (*) => this.ToggleOutputMode())
        this.tray.Add('Settings', (*) => this.ShowSettingsGUI())
    }

    ToggleInfoDisplay() {
        this.showInfoEnabled := !this.showInfoEnabled
        infoState := this.showInfoEnabled ? 'enabled' : 'disabled'
        this.ShowInfo('Info display is now ' . infoState)
    }

    ToggleOutputMode() {
        this.useOutputDebug := !this.useOutputDebug
        outputMode := this.useOutputDebug ? 'OutputDebug' : 'Infos'
        this.ShowInfo('Output mode changed to: ' . outputMode)
    }

    ShowInfo(message) {
        if (!this.showInfoEnabled) {
            return
        }

        if (this.useOutputDebug) {
            OutputDebug('ChromeRiverGUI: ' . message)
        } else {
            if (this.infoTimer) {
                SetTimer(this.infoTimer, 0)
            }
            this.infoTimer := SetTimer(() => ToolTip(), -300000)  ; Hide after 5 minutes
            Infos(message)
        }
    }

	SetButtonLength(arr) {
		largestLength := 0
		for key, value in arr {
			currentLength := StrLen(value)
			if (currentLength > largestLength) {
				largestLength := currentLength
			}
		}
		return largestLength
	}

    CreateGUI() {
		s1y := s1x := gh := gw := gy := gx := 0
        
		this.hButtons := ' h' 30
        this.mainGui := Gui('+AlwaysOnTop')
        this.mainGui.Title := 'Chrome River Expense Report Helper'
		
		arrBtnNames:= ['Open Expense Report', 'Submit Expense Report', 'Select All Transactions','Add Selected to Report']
		objBtnName:= {addNew: arrBtnNames[1], Submit: arrBtnNames[2], SelectAll: arrBtnNames[3], addSelected: arrBtnNames[4]}
		bNameLength := this.SetButtonLength(arrBtnNames)
		bWidth := ' w' bNameLength * 7.5
		bHeight := ' h' 30
		this.buttons := {}
        ; Main actions
        ; this.mainGui.AddText('x10 y10 w280', 'Chrome River Expense Report: ' . this.currentMonthYear)
        ; this.section1 := this.mainGui.AddText('x10 y10 w280', )
		reportTitle := 'Report Title: ' 
		; this.section2 := this.mainGui.AddText(' w' section1w, reportTitle)
		this.section := this.mainGui.AddText('xm ym', reportTitle)
		this.section.Text := reportTitle
        ; this.section1 := this.mainGui.AddText('xm ym', )
		section1Title := 'Chrome River Expense Report:'
		section1w := Round(StrLen(section1Title) * 7.5)
        this.section1 := this.mainGui.AddText('w' section1w, section1Title)
		this.section1.GetPos(&s1x, &s1y)
		; this.section1 := this.mainGui.AddText('xm ym w' section1w, this.section1.Text)
		


        this.buttons.addNewBtn := this.mainGui.AddButton(bWidth this.hButtons, objBtnName.addNew)
        ; this.buttons.addNewBtn.GetPos(&xaB, &yaB)
		this.buttons.addNewBtn.OnEvent('Click', (*) => this.AddNewExpense())
        this.buttons.SubmitBtn := this.mainGui.AddButton('yp' bWidth this.hButtons, objBtnName.Submit)
		this.buttons.SubmitBtn.OnEvent('Click', (*) => this.SubmitExpenseReport())
		this.mainGui.AddText()
		this.mainGui.AddText('xm', 'Select Expense:')
        this.buttons.SelAllBtn := this.mainGui.AddButton('xm ' bWidth this.hButtons, objBtnName.SelectAll)
		this.buttons.SelAllBtn.OnEvent('Click', (*) => this.SelectAllTransactions())
        this.buttons.addSelBtn := this.mainGui.AddButton('yp' bWidth this.hButtons, objBtnName.addSelected)
		this.buttons.addSelBtn.OnEvent('Click', (*) => this.AddSelectedToReport())
        
        ; Unclassified expense navigation
        ; this.mainGui.AddText('x10 y200 w280', 'Unclassified Expenses')
        ; this.expenseText := this.mainGui.AddEdit('x10 y220 w280 h300 vExpenseText ReadOnly VScroll')
        ; this.mainGui.AddButton('x10 y330 w90 h30', 'Previous').OnEvent('Click', (*) => this.NavigateExpense(-1))
        ; this.mainGui.AddButton('x110 y330 w90 h30', 'Next').OnEvent('Click', (*) => this.NavigateExpense(1))
        ; this.mainGui.AddButton('x210 y330 w80 h30', 'Select').OnEvent('Click', (*) => this.SelectExpense())
		; Replace the Edit control with a ListView for expenses
		; this.mainGui.AddText('x10 y200 w280', 'Unclassified Expenses:')
		this.mainGui.AddText('xm y+10 w280', 'Unclassified Expenses:')
		arrLV := [
			'Description',
			'Amount', 
			'Date', 
			'Category'
		]
		this.expenseListView := this.mainGui.AddListView('xm y+10 w750 r5 vExpenseListView -Multi', arrLV)
		this.expenseListView.GetPos(&gx, &gy, &gw, &gh)
		this.expenseListView.OnEvent('Focus', (*) => this.SelectExpense())
		this.expenseListView.OnEvent('DoubleClick', (*) => this.SelectExpenseLV())

		; Section PNS (Previous, Select, Next)
		arrNavBtns := ['Previous', 'Select', 'Next']
        objNavBtns := {previous: arrNavBtns[1], select: arrNavBtns[2], next: arrNavBtns[3]}
        bNavLength := this.SetButtonLength(arrNavBtns) * 7.5
        wNavBtns := ' w' bNavLength
        hNavBtns := ' h' 30

        ; Calculate positions for the buttons
        this.expenseListView.GetPos(&gx, &gy, &gw, &gh)
        selectX := gx + (gw / 2) - (bNavLength / 2)
        previousX := selectX - bNavLength - 10  ; 10 pixels gap
        nextX := selectX + bNavLength + 10  ; 10 pixels gap

        ; Create the buttons with calculated positions
        this.buttons.select := this.mainGui.AddButton('x' selectX ' y' (gy + gh + 10) wNavBtns hNavBtns, objNavBtns.select)
        this.buttons.select.OnEvent('Click', (*) => this.SelectExpense())

        this.buttons.previous := this.mainGui.AddButton('x' previousX ' y' (gy + gh + 10) wNavBtns hNavBtns, objNavBtns.previous)
        this.buttons.previous.OnEvent('Click', (*) => this.NavigateExpense(-1))

        this.buttons.next := this.mainGui.AddButton('x' nextX ' y' (gy + gh + 10) wNavBtns hNavBtns, objNavBtns.next)
        this.buttons.next.OnEvent('Click', (*) => this.NavigateExpense(1))

                ; Category buttons
				categoryButtonWidth := ' w' this.SetButtonLength(this._categories.GetCategories()) * 7.5
				categoryButtonHeight := ' h30'
				buttonsPerRow := 3
				xMargin := 10
				yMargin := 10
				xSpacing := 10
				ySpacing := 10
		
				; Get the position of the last control
				lastControl := this.buttons.next
				lastControl.GetPos(&lastX, &lastY, &lastW, &lastH)
		
				xStart := xMargin
				yStart := lastY + lastH + yMargin
		
				; Create category buttons
				for index, category in this.categoryOrder {
					col := Mod(A_Index - 1, buttonsPerRow)
					row := (A_Index - 1) // buttonsPerRow
		
					xPos := xStart + (col * (StrReplace(categoryButtonWidth, " w") + xSpacing))
					yPos := yStart + (row * (30 + ySpacing))
		
					this.buttons.%category% := this.mainGui.AddButton('x' xPos ' y' yPos categoryButtonWidth categoryButtonHeight, category)
					this.buttons.%category%.OnEvent('Click', (*) => this.SelectCategory(category))
				}
        
        this.mainGui.OnEvent('Close', (*) => ExitApp())
    }

	ShowSettingsGUI() {
        settingsGui := Gui('+Owner' this.mainGui.Hwnd)
        settingsGui.Title := 'Category Button Order Settings'
        settingsGui.OnEvent('Close', (*) => settingsGui.Hide())

        ; Create a ListView to display and reorder categories
        lv := settingsGui.Add('ListView', 'r' this.categoryOrder.Length ' w300', ['Category'])
        for category in this.categoryOrder {
            lv.Add(, category)
        }

        ; Add buttons for moving categories up and down
        upButton := settingsGui.Add('Button', 'w100', 'Move Up')
        upButton.OnEvent('Click', (*) => this.MoveCategoryInList(lv, -1))

        downButton := settingsGui.Add('Button', 'x+10 yp w100', 'Move Down')
        downButton.OnEvent('Click', (*) => this.MoveCategoryInList(lv, 1))

        ; Add a save button
        saveButton := settingsGui.Add('Button', 'x10 y+10 w100', 'Save')
        saveButton.OnEvent('Click', (*) => this.SaveCategoryOrder(lv, settingsGui))

        settingsGui.Show()
    }

    MoveCategoryInList(lv, direction) {
        selectedRow := lv.GetNext(0, 'Focused')
        if (selectedRow = 0) {
            return
        }

        newPosition := selectedRow + direction
        if (newPosition < 1 || newPosition > lv.GetCount()) {
            return
        }

        categoryText := lv.GetText(selectedRow)
        lv.Delete(selectedRow)
        lv.Insert(newPosition, , categoryText)
        lv.Modify(newPosition, 'Select Focus Vis')
    }

    SaveCategoryOrder(lv, settingsGui) {
        newOrder := []
        Loop lv.GetCount() {
            newOrder.Push(lv.GetText(A_Index))
        }
        this.categoryOrder := newOrder
        this.RecreateCategoryButtons()
        settingsGui.Hide()
    }

    RecreateCategoryButtons() {
        ; Remove existing category buttons
        for category in this._categories.GetCategories() {
            this.buttons.%category%.Destroy()
        }

        ; Recreate category buttons with new order
        categoryButtonWidth := ' w' this.SetButtonLength(this._categories.GetCategories()) * 7.5
        categoryButtonHeight := ' h30'
        buttonsPerRow := 3
        xMargin := 10
        yMargin := 10
        xSpacing := 10
        ySpacing := 10

        ; Get the position of the last non-category control
        lastControl := this.buttons.next
        lastControl.GetPos(&lastX, &lastY, &lastW, &lastH)

        xStart := xMargin
        yStart := lastY + lastH + yMargin

        for index, category in this.categoryOrder {
            col := Mod(A_Index - 1, buttonsPerRow)
            row := (A_Index - 1) // buttonsPerRow

            xPos := xStart + (col * (StrReplace(categoryButtonWidth, " w") + xSpacing))
            yPos := yStart + (row * (30 + ySpacing))

            this.buttons.%category% := this.mainGui.AddButton('x' xPos ' y' yPos categoryButtonWidth categoryButtonHeight, category)
            this.buttons.%category%.OnEvent('Click', (*) => this.SelectCategory(category))
        }

        this.mainGui.Show('AutoSize')
    }

    ShowGUI() {
        this.mainGui.Show('NA')
    }

    LoadUnclassifiedExpenses() {
        this.FindControls()
        this.UpdateExpenseDisplay()
    }

    UpdateExpenseDisplay() {
        this.expenseListView.Delete()  ; Clear existing items
        if (this.unclassifiedExpenses.Length > 0) {
            for index, expense in this.unclassifiedExpenses {
                description := expense.HasProp('description') ? expense.description : 'N/A'
                amount := (expense.HasProp('amount') ? expense.amount : 'N/A') . ' ' . (expense.HasProp('currency') ? expense.currency : '')
                date := expense.HasProp('date') ? expense.date : 'N/A'
                category := expense.HasProp('category') ? expense.category : 'N/A'
                
                this.expenseListView.Add(, description, amount, date, category)
            }
            this.expenseListView.ModifyCol()  ; Auto-size columns
            this.expenseListView.ModifyCol(1, 'AutoHdr')  ; Auto-size header for the first column
        }
    }

	NavigateExpense(direction) {
        if (this.unclassifiedExpenses.Length = 0) {
            this.ShowInfo('No unclassified expenses to navigate.')
            return
        }
        
        this.currentExpenseIndex += direction
        if (this.currentExpenseIndex < 1) {
            this.currentExpenseIndex := this.unclassifiedExpenses.Length
        } else if (this.currentExpenseIndex > this.unclassifiedExpenses.Length) {
            this.currentExpenseIndex := 1
        }
        this.expenseListView.Modify(this.currentExpenseIndex, 'Select Focus Vis')
        this.FocusCurrentExpense()
    }

    FocusCurrentExpense() {
        if (this.unclassifiedExpenses.Length > 0) {
            currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
            this.FocusElement(currentExpense)
        }
    }

	SelectExpense() {
        if (this.unclassifiedExpenses.Length = 0) {
            return
        }

        selectedRow := this.expenseListView.GetNext(0, 'Focused')
        if (selectedRow = 0) {
            selectedRow := 1
        }
        this.currentExpenseIndex := selectedRow

        if (this.FindChromeRiverWindow()) {
            currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
            this.FocusElement(currentExpense)
            
			; Try to select using different methods
			if (currentExpense.HasProp('element')) {
				; Method 1: Use the stored element
				currentExpense.element.Click()
			} else {
				; Method 2: Find and click the checkbox
				checkbox := UIA.ElementFromHandle(WinExist('A')).FindFirst({Type: '50002 (CheckBox)', LocalizedType: 'check box', AutomationId: 'cc-checkbox-'})
				if (checkbox) {
					checkbox.Click()
				} else {
					; Method 3: Click the group itself
					group := UIA.ElementFromHandle(WinExist('A')).FindFirst({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description})
					if (group) {
						group.Click()
					} else {
						; this.ShowInfo('Unable to select expense: ' . currentExpense.description)
						return
					}
				}
			}
			
			; this.ShowInfo('Selected expense: ' . currentExpense.description)
		}
	}
	SelectExpenseLV() {
		Infos('Actuated')
        ; if (this.unclassifiedExpenses.Length = 0) {
        ;     return
        ; }

        selectedRow := this.expenseListView.GetNext(0, 'Focused')
        if (selectedRow = 0) {
            selectedRow := 1
        }
        this.currentExpenseIndex := selectedRow
		
		; expRpt.ElementFromPath({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description}, {Type: '50026 (Group)', LocalizedType: "group", or:{Name: '', Name:'help'}}).Click()

        if (this.GetChromeRiverElement(&expRpt)) {
			theElement := expRpt.FindCachedElement({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description})
			infos(theElement)
			currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
            ; this.FocusElement(currentExpense)
			expRpt.FindCachedElement({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description}, {Type: '50026 (Group)', LocalizedType: "group"}).Click()
			return
            
			; Try to select using different methods
			if (currentExpense.HasProp('element')) {
				; Method 1: Use the stored element
				currentExpense.element.Click()
			} else {
				; Method 2: Find and click the checkbox
				checkbox := UIA.ElementFromHandle(WinExist('A')).FindFirst({Type: '50002 (CheckBox)', LocalizedType: 'check box', AutomationId: 'cc-checkbox-'})
				if (checkbox) {
					checkbox.Click()
				} else {
					; Method 3: Click the group itself
					
					group := UIA.ElementFromHandle(WinExist('A')).FindFirst({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description})
					if (group) {
						group.Click()
					} else {
						; this.ShowInfo('Unable to select expense: ' . currentExpense.description)
						return
					}
				}
			}
			
			; this.ShowInfo('Selected expense: ' . currentExpense.description)
		}
	}

    SelectCategory(category) {
        if (this.GetChromeRiverElement(&expRpt)) {
            categoryElement := expRpt.FindCachedElement({Type: '50026 (Group)', Name: category, LocalizedType: 'group'})
            if (categoryElement) {
                this.FocusElement(categoryElement)
                categoryElement.Invoke()
                this.ShowInfo('Selected category: ' . category)
            } else {
                this.ShowInfo('Category not found: ' . category)
            }
        }
    }

    SelectClassification(category, classification) {
        if (this.GetChromeRiverElement(&expRpt)) {
            ; First, ensure the category is selected
            this.SelectCategory(category)
            
            ; Then, find and select the classification
            classificationElement := expRpt.FindCachedElement({Name: classification})
            if (classificationElement) {
                this.FocusElement(classificationElement)
                classificationElement.Invoke()
                this.ShowInfo('Selected classification: ' . classification)
            } else {
                this.ShowInfo('Classification not found: ' . classification)
            }
        }
    }

    AddNewExpense() {
        if (this.GetChromeRiverElement(&expRpt)) {
            addButton := expRpt.FindCachedElement({Type: '50000 (Button)', Name: 'Add New Expense', LocalizedType: 'button'})
            if (addButton) {
                this.FocusElement(addButton)
                addButton.Invoke()
                this.ShowInfo('Add New Expense button invoked.')
                
                ; Wait for the 'Add Expenses' region to appear
                Sleep(1000)  ; Adjust this delay if needed
                
                ; Refresh the unclassified expenses list
                this.LoadUnclassifiedExpenses()
                
                ; Update the GUI display
                this.UpdateExpenseDisplay()
                
                this.ShowInfo('Unclassified expenses refreshed and GUI updated.')
            } else {
                this.ShowInfo('Add New Expense button not found.')
            }
        }
    }

    SubmitExpenseReport() {
        if (this.GetChromeRiverElement(&expRpt)) {
            submitButton := expRpt.FindCachedElement({Name:'Submit'})
            if (submitButton) {
                this.FocusElement(submitButton)
                submitButton.Click()
                this.ShowInfo('Submit button clicked.')
            } else {
                this.ShowInfo('Submit button not found.')
            }
        }
    }

    SelectAllTransactions() {
        if (this.GetChromeRiverElement(&expRpt)) {
            selectAllCheckbox := expRpt.FindCachedElement({AutomationId:'transaction-checkbox-select-all'})
            if (selectAllCheckbox) {
                this.FocusElement(selectAllCheckbox)
                selectAllCheckbox.Click()
                this.ShowInfo('Select All Transactions checkbox clicked.')
            } else {
                this.ShowInfo('Select All Transactions checkbox not found.')
            }
        }
    }

    AddSelectedToReport() {
        if (this.GetChromeRiverElement(&expRpt)) {
            addSelectedButton := expRpt.FindCachedElement({Name:'Add Selected Transactions to Report'})
            if (addSelectedButton) {
                this.FocusElement(addSelectedButton)
                addSelectedButton.Click()
                this.ShowInfo('Add Selected Transactions to Report button clicked.')
            } else {
                this.ShowInfo('Add Selected Transactions to Report button not found.')
            }
        }
    }

    FindChromeRiverWindow() {
        if (WinExist('Chrome River - Google Chrome')) {
            WinActivate
            return true
        } else {
            this.ShowInfo('Chrome River window not found. Please open Chrome River in Google Chrome.')
            return false
        }
    }

    FocusElement(element) {
        if (element) {
            try {
                this.ShowInfo('Focusing on element: ' . element.Name)
                element.SetFocus()
                Sleep(100)  ; Allow time for focus to take effect
                element.ScrollIntoView()
                Sleep(100)  ; Allow time for scrolling to complete
                this.ShowInfo('Element focused and scrolled into view')
            } catch as e {
                this.ShowInfo('Error focusing element: ' . e.Message)
            }
        } else {
            this.ShowInfo('Cannot focus on null element')
        }
    }

    ; ---------------------------------------------------------------------------
    FindControls() {
        unExpenses := cExpenses := expenses := elementsarray := this.unclassifiedExpenses := this.classifiedExpenses := []
        addExpensesRegion := ''
        if (this.GetChromeRiverElement(&expRpt)) {
            ; addExpensesRegion := expRpt.FindElement({Type: '50026 (Group)', Name: 'Add Expenses', LocalizedType: 'region'})
            ; if (addExpensesRegion) {
            ;     Expenses  := expRpt.FindCachedElements({Type: '50026 (Group)', Name: 'group ', LocalizedType: 'group', not:[{Name: ''}, {Name: 'help'}]})
            ;     elementsarray := expRpt.FindCachedElements({Type: '50026 (Group)', LocalizedType: 'group', not:[{Name: ''}, {Name: 'help'}]})
            ;     unExpenses := expRpt.FindCachedElements({Type: '50026 (Group)', Name: 'help',    LocalizedType: 'group'})
            ; }
            ; for each, value in Expenses {
            ;     infos(value)

            ; }
            ; return
            try {
                try addExpensesRegion := expRpt.FindCachedElement({Type: '50026 (Group)', Name: 'Add Expenses', LocalizedType: 'region'})
                if !(addExpensesRegion){
                    return
                }
                if (addExpensesRegion) {
                    expenseGroups := expRpt.FindCachedElements(
						{
							Type: '50026 (Group)', 
							LocalizedType: 'group', 
							; not:[{Name: ''}, {Name: 'help'}]
						}
					)
                    
                    for group in expenseGroups {
                        if ((group.Name ~= 'Fm Amex') == 1) {
                        ; if (InStr(group.Name, 'Fm Amex') == 1) {
                            expenseInfo := this.ExtractExpenseInfo(group)
                            
                            ; Check if this is an unclassified expense
                            helpGroup := expRpt.FindCachedElements({Type: '50026 (Group)', Name: 'help', LocalizedType: 'group'})
                            if (helpGroup) {
                                this.unclassifiedExpenses.Push(expenseInfo)
                                this.ShowInfo('Found unclassified expense: ' . expenseInfo.description . ' - ' . expenseInfo.amount . ' ' . expenseInfo.currency)
                            } else {
                                ; This is a classified expense
                                classificationText := expRpt.FindCachedElements({Type: '50020 (Text)', LocalizedType: 'text'})
                                if (classificationText) {
                                    expenseInfo.classification := classificationText.Name
                                    this.classifiedExpenses.Push(expenseInfo)
                                    this.ShowInfo('Found classified expense: ' . expenseInfo.description . ' - ' . expenseInfo.amount . ' ' . expenseInfo.currency . ' (Classified as ' . expenseInfo.classification . ')')
                                }
                            }
                        }
                    }
                }
                this.ShowInfo('Found ' . this.unclassifiedExpenses.Length . ' unclassified expenses and ' . this.classifiedExpenses.Length . ' classified expenses')
            } catch as err {
                ; Infos('Error in FindControls: ' . err.Message)
                throw err
            }
        }
        
        return this.unclassifiedExpenses.Length + this.classifiedExpenses.Length
    }
    ; ---------------------------------------------------------------------------

    ExtractExpenseInfo(group) {
        ; Use regex to extract relevant information from the group name
        regexPattern := 'Fm Amex (\w+) (.+?) (\d{2}/\d{2}/\d{4}) (.+?) (\d+\.\d{2}) (\w{3})'
        if (RegExMatch(group.Name, regexPattern, &matches)) {
            return {
                element: group,
                origin: matches[1],
                category: matches[2],
                date: matches[3],
                description: matches[4],
                amount: matches[5],
                currency: matches[6],
                classification: ''
            }
        }
        return {}
    }

    /**
	 * @param scope TreeScope value: Element (1), Children (2), Family (Element+Children) (3), Descendants (4), Subtree (=Element+Descendants) (5). Default is Descendants.
	 */
    GetChromeRiverElement(&expRpt, title := 'Chrome River - Google Chrome') {
        ; title := 'Chrome River - Google Chrome'
        cacheRequest := UIA.CreateCacheRequest()
        scope := 5
        cacheRequest.TreeScope := scope  ; Subtree (=Element+Descendants)
        cacheRequest := UIA.CreateCacheRequest(['Type', 'LocalizedType', 'AutomationId', 'Name', 'Value', 'ClassName', 'AcceleratorKey', 'WindowCanMaximize'], ['Window'], 'Subtree')
        expRpt := UIA.ElementFromChromium(title,,, cacheRequest)

        if (expRpt) {
            this.ShowInfo('Successfully retrieved Chrome River element')
            return true
        } else {
            this.ShowInfo('Failed to retrieve Chrome River element')
            return false
        }
    }
}

class Categories {
    static categoriesList := ['Travel', 'Meals / Entertainment', 'Telecom', 'Office Expenses', 'Company Car', 'Professional Memberships / Development', 'Fees / Advances', 'Misc', 'Engineer / Equipment']
    
    Travel := Travel()
    MealsEntertainment := MealsEntertainment()
    Telecom := Telecom()
    OfficeExpenses := OfficeExpenses()
    CompanyCar := CompanyCar()
    ProfessionalMembershipsDevelopment := ProfessionalMembershipsDevelopment()
    FeesAdvances := FeesAdvances()
    Misc := Misc()
    EngineerEquipment := EngineerEquipment()

    GetCategories() {
        return Categories.categoriesList
    }

    GetClassifications(category) {
        categoryName := StrReplace(category, ' / ', '')
        categoryName := StrReplace(categoryName, ' ', '')
        if (this.HasProp(categoryName)) {
            return this.%categoryName%.GetClassifications()
        }
        return []
    }
}

class Travel {
    Airfare := 'Airfare'
    AirlineFee := 'Airline Fee'
    BusinessMileage := 'Business Mileage - Personal Car'
    CarRental := 'Car Rental'
    CarRentalFuel := 'Car Rental - Fuel'
    CarService := 'Car Service'
    GiftInLieuOfHotel := 'Gift in Lieu of Hotel'
    GroundTravel := 'Ground Travel'
    Hotel := 'Hotel'
    ParkingAndTolls := 'Parking and Tolls'
    Passport := 'Passport / Visa / Immigration Fees'
    Rail := 'Rail'
    Tips := 'Tips / Gratuities'
    TravelAgencyFees := 'Travel Agency Transaction Fees - TMC'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class MealsEntertainment {
    ClientGifts := 'Client Gifts'
    ClientMeals := 'Client Meals'
    EmployeeMeals := 'Employee Meals'
    Entertainment := 'Entertainment'
    Events := 'Events'
    MktClientEvent := 'Mkt Client Event'
    OtherClientRelatedExpenses := 'Other Client Related Expenses'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class Telecom {
    MobileCellularDataCharges := 'Mobile Cellular / Data Charges'
    CellularBroadbandMiFi := 'Cellular Broadband / MiFi'
    HomeInternet := 'Home Internet'
    HotSpotWifiCharges := 'Hot Spot / Wifi Charges'
    PhoneBusinessCalls := 'Phone / Business Calls'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class OfficeExpenses {
    OfficeSupplies := 'Office Supplies'
    OutsidePrinting := 'Outside Printing / Photocopying Charges'
    PostageMailCouriers := 'Postage / Mail / Couriers'
    Software := 'Software'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class CompanyCar {
    Fuel := 'Fuel / Company Car'
    Mileage := 'Mileage / Company Car'
    Wash := 'Wash / Company Car'
    Other := 'Other / Company Car'
    HomeChargerInstallation := 'Home Charger Installation'
    HomeChargingElectricityCosts := 'Home Charging Electricity Costs'
    EVPublicChargingStation := 'EV Public Charging Station'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class ProfessionalMembershipsDevelopment {
    AnnualMembershipFees := 'Annual Membership Fees'
    Certification := 'Certification / Re-Certification'
    ConferenceSeminarFees := 'Conference / Seminar Fees'
    ProfessionalAssociationDues := 'Professional Association Dues'
    Subscriptions := 'Subscriptions'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class FeesAdvances {
    BankATMFees := 'Bank / ATM Fees'
    CashAdvance := 'Cash Advance'
    ForeignTransactionFees := 'Foreign Transaction Fees'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class Misc {
    EmployeeMedical := 'Employee Medical'
    MeetingRoom := 'Meeting Room'
    PersonalAmexExpense := 'Personal / Amex Expense'
    SWE := 'SWE - Soc of Women Eng'
    TradeShowExpense := 'Trade Show Expense'
    OtherMisc := 'Other / Misc'
    MemorialExpressionsOfSympathy := 'Memorial / Expressions of Sympathy'
    EmployeeGifts := 'Employee Gifts'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

class EngineerEquipment {
    EngineeringSupplyTools := 'Engineering Supply / Tools'
    Maps := 'Maps'
    SafetyExpenses := 'Safety Expenses'
    SundryServiceWaterTest := 'Sundry Service / Water Test'

    GetClassifications() {
        classifications := []
        for prop in this.OwnProps() {
            classifications.Push(this.%prop%)
        }
        return classifications
    }
}

; Create an instance of the GUI
chromeRiverHelper := ChromeRiverGUI()
