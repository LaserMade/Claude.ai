#Requires AutoHotkey v2.0
#Include <Directives\__AE.v2>

/**
 *  @example Main GUI Class
 */


/**
 * @example
 * TODO:
 * Add: Type: '50005 (Link)', Name: "add", Value: "https://app.chromeriver.com/index#expense/new/details", LocalizedType: "link"
 * Add: Type: '50000 (Button)', Name: "Create New Expense Report Create New Expense Reports", LocalizedType: "button"
 * Note: Both do the same thing.
 */

ChromeRiverGUI.Prototype.Base := ButtonCreator

class ChromeRiverGUI {
	
	/**	@example Class properties	*/
    
    categories := {}
	categoryGroup := {}
	mainCategories := ["Travel", "Meals / Entertainment", "Company Car"]
    categoryOrder := []
    mainGui := {}
	buttons := {}
    rptGroup := {}
	expenses := []
    unclassifiedExpenses := []
	classifiedExpenses := []
    currentExpenseIndex := 1
    showInfoEnabled := true
    useOutputDebug := false
    infoTimer := 0
    tray := A_TrayMenu
    currentMonthYear := ''
    expRpt := this.GetChromeRiverElement(&expRpt)
    columnOptions := ["3 Columns", "4 Columns", "Dynamic"]
    currentColumnOption := 2  ; Default to "Dynamic" (index 2 in the array)
	config := {
        ; dynamicNavButtons: true  ; Set this to false if you don't want dynamic positioning
        dynamicNavButtons: false  ; Set this to false if you don't want dynamic positioning
    }
    settingsManager := SettingsManager()

    expenseListView := ''  ; Initialize expenseListView as null
	classificationDisplay := "Display only selected category"  ; Default value
    
    currentCategory := ""
    classificationButtons := Map()
	classificationGroup := {}
	
    __New() {
        this.settingsManager := SettingsManager()
        this._categories := Categories()
        this.mainGui := Gui('+AlwaysOnTop')
        this.mainGui.Title := 'Chrome River Expense Report Helper'
        
        this.LoadSettings()
        this.SetupTrayMenu()
        this.CreateGUI()
        
		this.LoadUnclassifiedExpenses()
		this.AutoLoadExpenses()  ; Add this line
		this.ShowGUI()
    }

	CreateTabbedClassifications() {
		this.categoryGroup.GetPos(&catGroupX, &catGroupY, &catGroupW, &catGroupH)
	
		this.classificationTabs := this.mainGui.AddTab3("xm y" (catGroupY + catGroupH + 10) " w750 h220", ["All Classifications"])
	
		this.classificationTabs.UseTab(1)
		this.CreateAllClassificationButtons()
	
		this.classificationTabs.UseTab()
	}
	
	CreateAllClassificationButtons() {
		buttonWidth := 180
		buttonHeight := 30
		xMargin := 10
		yMargin := 10
		xSpacing := 10
		ySpacing := 5
		columns := 4
	
		yPos := yMargin
		xPos := xMargin
		buttonCount := 0
	
		for category in this._categories.GetCategories() {
			classifications := this._categories.GetClassifications(category)
			for classification in classifications {
				btn := this.mainGui.AddButton("x" xPos " y" yPos " w" buttonWidth " h" buttonHeight, classification)
				btn.OnEvent("Click", (*) => this.SelectClassification(category, classification))
	
				buttonCount++
				if (Mod(buttonCount, columns) == 0) {
					xPos := xMargin
					yPos += buttonHeight + ySpacing
				} else {
					xPos += buttonWidth + xSpacing
				}
			}
		}
	}

	CreateMainTabButtons(mainCategories) {
		buttonWidth := 180
		buttonHeight := 30
		xMargin := 10
		yMargin := 10
		xSpacing := 10
		ySpacing := 5
	
		for index, category in mainCategories {
			; xPos := xMargin + ((index - 1) // 2) * (buttonWidth + xSpacing)
			xPos := 'm'
			yPos := yMargin + ((index - 1) // 2) * (buttonHeight * 5 + ySpacing)
	
			classifications := this._categories.GetClassifications(category)
			for classIndex, classification in classifications {
				classYPos := yPos + (classIndex - 1) * (buttonHeight + 5)
				btn := this.mainGui.AddButton("x" xPos " yp" " w" buttonWidth " h" buttonHeight, classification)
				btn.OnEvent("Click", (*) => this.SelectClassification(category, classification))
			}
		}
	}
	
	CreateCategoryButtons(category) {
		buttonWidth := 180
		buttonHeight := 30
		xMargin := 10
		yMargin := 10
		xSpacing := 10
		ySpacing := 5
	
		classifications := IsObject(category) ? category : this._categories.GetClassifications(category)
		columns := 4
		for index, classification in classifications {
			col := Mod(index - 1, columns)
			row := (index - 1) // columns
			xPos := xMargin + col * (buttonWidth + xSpacing)
			yPos := yMargin + row * (buttonHeight + ySpacing)
	
			btn := this.mainGui.AddButton("x" xPos " y" yPos " w" buttonWidth " h" buttonHeight, classification)
			btn.OnEvent("Click", (*) => this.SelectClassification(category, classification))
		}
	}

	LoadSettings(useDefault := false) {
		settings := this.settingsManager.LoadSettings(useDefault)
		this.currentColumnOption := settings.Has("columnLayout") ? settings["columnLayout"] : 0
		this.categoryOrder := settings.Has("categoryOrder") ? settings["categoryOrder"] : this._categories.GetCategories()
		this.showInfoEnabled := settings.Has("showInfoEnabled") ? settings["showInfoEnabled"] : true
		this.useOutputDebug := settings.Has("useOutputDebug") ? settings["useOutputDebug"] : false
		this.classificationDisplay := settings.Has("classificationDisplay") ? settings["classificationDisplay"] : "Display only selected category"
	}

    ShowSettingsGUI() {
		settingsGui := Gui('+Owner' this.mainGui.Hwnd)
		settingsGui.Title := 'Chrome River Helper Settings'
		settingsGui.OnEvent('Close', (*) => settingsGui.Hide())
	
		; Categories Tab
		tabControl := settingsGui.AddTab3("w600 h400", ["Categories", "Classifications", "Layout"])
		
		; Categories Tab
		tabControl.UseTab(1)
		lv := settingsGui.AddListView('r' this.categoryOrder.Length ' w300', ['Category'])
		lv.Name := "categoryListView"
		for category in this.categoryOrder {
			lv.Add(, category)
		}
	
		upButton := settingsGui.AddButton('w100', 'Move Up')
		upButton.OnEvent('Click', (*) => this.MoveCategoryInList(lv, -1))
	
		downButton := settingsGui.AddButton('x+10 yp w100', 'Move Down')
		downButton.OnEvent('Click', (*) => this.MoveCategoryInList(lv, 1))
	
		; Classifications Tab
		tabControl.UseTab(3)
		classificationOptions := settingsGui.AddDropDownList("w200", ["Display only selected category", "Display all", "Display top 3"])
		classificationOptions.Name := "classificationOptions"
		classificationOptions.Choose(1)  ; Default to "Display only selected category"
	
		; Layout Tab
		tabControl.UseTab(2)
		settingsGui.AddText("xm+10 yp", "Column Layout:")
		columnDropdown := settingsGui.AddDropDownList(
			"x+5 yp-4 w100 Choose" (
				this.currentColumnOption = 0 
				? 3 
				: this.currentColumnOption
			),
			this.columnOptions
		)
		columnDropdown.Name := "columnDropdown"
	
		; Add file format options (outside of tabs)
		tabControl.UseTab()
		settingsGui.AddText("xm+10 ", "Settings File Format:")
		formatDropdown := settingsGui.AddDropDownList("x+5 yp-4 w100", SettingsManager.supportedFormats)
		formatDropdown.Name := "formatDropdown"
		formatDropdown.Choose(SettingsManager.defaultFormat)
	
		; Add a save button
		saveButton := settingsGui.AddButton('xm y+10 w100', 'Save')
		saveButton.OnEvent('Click', (*) => this.SaveSettings(lv, columnDropdown, formatDropdown, classificationOptions, settingsGui))
	
		; Add a "Reset to Default" button
		resetButton := settingsGui.AddButton('xm y+10 w150', 'Reset to Default')
		resetButton.OnEvent('Click', (*) => this.ResetToDefaultSettings(settingsGui))
	
		settingsGui.Show()
	}
    
	ResetToDefaultSettings(settingsGui) {
		this.LoadSettings(true)  ; Load default settings
		this.SaveSettings(settingsGui.Controls, settingsGui.Controls["columnDropdown"], settingsGui.Controls["formatDropdown"], settingsGui.Controls["classificationOptions"], settingsGui)
		this.UpdateSettingsGUI(settingsGui)
		MsgBox("Settings reset to default values.")
	}

	UpdateSettingsGUI(settingsGui) {
		; Update the ListView with the new category order
		lv := settingsGui.Controls["categoryListView"]
		lv.Delete()
		for category in this.categoryOrder {
			lv.Add(, category)
		}
	
		; Update the column layout dropdown
		columnDropdown := settingsGui.Controls["columnDropdown"]
		columnDropdown.Choose(this.currentColumnOption = 0 ? 3 : this.currentColumnOption)
	
		; Update the classification display dropdown
		classificationOptions := settingsGui.Controls["classificationOptions"]
		classificationOptions.Choose(this.classificationDisplay)
	
		; Update other controls as needed
		; ...
	
		; Redraw the settings GUI
		settingsGui.Show("AutoSize")
	}

    SaveSettings(lv, columnDropdown, formatDropdown, classificationOptions, settingsGui) {
		settings := Map(
			"columnLayout", this.currentColumnOption,
			"categoryOrder", this.categoryOrder,
			"showInfoEnabled", this.showInfoEnabled,
			"useOutputDebug", this.useOutputDebug,
			"classificationDisplay", classificationOptions.Text
		)
        ; Collect new settings
        newOrder := []
        Loop lv.GetCount() {
            newOrder.Push(lv.GetText(A_Index))
        }
        this.categoryOrder := newOrder
    
        selectedColumnOption := columnDropdown.Value
        this.currentColumnOption := selectedColumnOption = "Dynamic" ? 0 : Integer(selectedColumnOption)
    
        settings := {
            columnLayout: this.currentColumnOption,
            categoryOrder: this.categoryOrder,
            showInfoEnabled: this.showInfoEnabled,
            useOutputDebug: this.useOutputDebug,
            classificationDisplay: classificationOptions.Text
        }
    
        ; Save settings
        selectedFormat := formatDropdown.Text
        saveResult := this.settingsManager.SaveSettings(settings, selectedFormat)
    
        ; Check save result and show confirmation
        if (saveResult) {
            this.ShowSaveConfirmation(selectedFormat)
        } else {
            this.ShowSaveError(selectedFormat)
        }
    
        ; Update GUI elements
        this.RecreateCategoryButtons()
        this.UpdateClassificationDisplay(classificationOptions.Text)
        settingsGui.Hide()
    }

    ShowSaveConfirmation(format) {
        filePath := this.settingsManager.GetSettingsFilePath(format)
        if (FileExist(filePath)) {
            fileSize := FileGetSize(filePath)
            Infos("Settings saved successfully!`nFile: " . filePath . "`nSize: " . fileSize . " bytes")
        } else {
            Infos("Settings file created, but not found at: " . filePath)
        }
    }
    
    ShowSaveError(format) {
        Infos("Error saving settings in " . format . " format.")
    }
    
    UpdateClassificationDisplay(option) {
        switch option {
            case "Display only selected category":
                this.ShowOnlySelectedCategoryClassifications()
            case "Display all":
                this.ShowAllClassifications()
            case "Display top 3":
                this.ShowTop3Classifications()
        }
    }
    
    ShowOnlySelectedCategoryClassifications() {
        ; Implement this method to show only the classifications for the selected category
    }
    
    ShowAllClassifications() {
        ; Implement this method to show all classifications
    }
    
    ShowTop3Classifications() {
        ; Implement this method to show top 3 classifications for each category
    }

    SetupTrayMenu() {
        this.tray.Add('Toggle Info Display', (*) => this.ToggleInfoDisplay())
        this.tray.Add('Toggle Output Mode', (*) => this.ToggleOutputMode())
        this.tray.Add('Settings', (*) => this.ShowSettingsGUI())
    }

	/**
     * @example Creates the main gui and the content of the GUI
     */

	CreateGUI() {
		this.mainGui.Opt("+Resize")  ; Make the GUI resizable
		this.CreateMenuBar()
		Gui2.SetDefaultFont(this.mainGui)
	
		this.CreateReportTitle()
		this.CreateReportButtons()
		this.CreateSelectButtons()
		this.CreateExpenseListView()
		this.CreateNavigationButtons()
		this.CreateCategoriesSection()
		this.CreateClassificationsSection()  ; This now creates the ListViews
	
		this.mainGui.OnEvent('Size', (*) => this.OnResize())
		this.mainGui.OnEvent('Close', (*) => ExitApp())
	}

	CreateCategoriesSection() {
		this.categoryGroup := this.mainGui.AddGroupBox("xm y+10 w750 h100", "Categories")
		this.categoryGroup.GetPos(&catGroupX, &catGroupY, &catGroupW, &catGroupH)
	
		categoryButtonWidth := Gui2.SetButtonWidth(this._categories.GetCategories())
		categoryButtonHeight := Gui2.SetButtonHeight()
	
		xMargin := 10
		yMargin := 20
		xSpacing := 10
		ySpacing := 10
	
		xStart := catGroupX + xMargin
		yStart := catGroupY + yMargin
	
		buttonsPerRow := 4  ; Set to 4 columns
		for index, category in this.categoryOrder {
			col := Mod(A_Index - 1, buttonsPerRow)
			row := (A_Index - 1) // buttonsPerRow
	
			xPos := xStart + (col * (categoryButtonWidth + xSpacing))
			yPos := yStart + (row * (categoryButtonHeight + ySpacing))
	
			this.buttons[category] := this.mainGui.AddButton("x" xPos " y" yPos " w" categoryButtonWidth " h" categoryButtonHeight, category)
			this.buttons[category].OnEvent('Click', this.CreateCategoryClickHandler(category))
		}
	}

	CreateReportTitle() {
		titleWidth := 300
		this.mainGui.AddText("xm ym w" . titleWidth, "Chrome River Expense Report:")
		this.reportTitle := this.mainGui.AddText("yp w" . titleWidth, "Loading...")
		this.reportTitle.GetPos(&lastX, &lastY, &lastW, &lastH)
		
		; Add the Refresh Expenses button to the right of the title
		refreshBtnWidth := 120
		refreshBtnX := lastX + lastW + 10
		this.refreshButton := this.mainGui.AddButton("x" refreshBtnX " yp-5 w" refreshBtnWidth, "Refresh Expenses")
		this.refreshButton.OnEvent("Click", (*) => this.RefreshExpenses())
	}

	CreateClassificationsSection() {
        this.categoryGroup.GetPos(&catGroupX, &catGroupY, &catGroupW, &catGroupH)
        
        listViewWidth := 180
        xMargin := 10
        yMargin := 10
        xSpacing := 10
        columns := 4

        xPos := xMargin
        yPos := catGroupY + catGroupH + 10

        this.classificationListViews := Map()
        
        for index, category in this._categories.GetCategories() {
            if (index > 1 && Mod(index - 1, columns) == 0) {
                xPos := xMargin
                yPos += 220  ; Increased spacing between rows
            }

            this.CreateCategoryListView(category, xPos, yPos, listViewWidth)
            
            xPos += listViewWidth + xSpacing
        }
    }

    CreateCategoryListView(category, xPos, yPos, listViewWidth) {
        this.mainGui.AddText("x" . xPos . " y" . yPos, category)
        yPos += 20

        listView := this.CreateListView(xPos, yPos, listViewWidth, category)
        this.classificationListViews[category] := listView

        classifications := this._categories.GetClassifications(category)
        for classification in classifications {
            listView.Add(, classification)
        }

        listView.OnEvent("DoubleClick", (*) => this.SelectClassificationFromListView(category))
    }

    CreateListView(x, y, width, category) {
        return this.mainGui.AddListView(
            "x" . x . " y" . y . " w" . width . " r5 +LV0x10000", 
            ["Classification"]
        )
    }
	
	/** @example Handles resizing of the GUI */
	OnResize(*) { ; Add * to make it a variadic function
	
		if (this.mainGui.HasProp("Pos"))  ; Check if Pos property exists
		{
			guiSize := this.mainGui.Pos
			if (guiSize.W > 600)
			{
				newWidth := guiSize.W - 20
				
				this.expenseListView.Move(,, newWidth)
				this.categoryGroup.Move(,, newWidth)
				
				; Recalculate positions for classification ListViews
				listViewWidth := 180  ; Should match the width in CreateClassificationsSection
				xMargin := 10
				xSpacing := 10
				columns := 4  ; Should match the number of columns in CreateClassificationsSection
	
				xPos := xMargin
				columnCount := 0
	
				for category, listView in this.classificationListViews {
					if (columnCount == columns) {
						columnCount := 0
						xPos := xMargin
					}
	
					listView.Move(xPos)
					
					columnCount++
					xPos += listViewWidth + xSpacing
				}
			}
		}
	}

	SelectClassificationFromListView(category) {
		listView := this.classificationListViews[category]
		if (rowNumber := listView.GetNext()) {
			classification := listView.GetText(rowNumber, 1)
			this.SelectClassification(category, classification)
		}
	}

	/**
	 * @example
		Positioning Translation Guide:

		Common Term              | AHK v2 Equivalent
		--------------------------|-------------------
		Left                     | x0 or xm (left margin)
		Right                    | x[GuiWidth - ControlWidth]
		Gui Centerline           | x[GuiWidth/2 - ControlWidth/2]
		Above                    | y[PreviousControl.Y - ControlHeight - Margin]
		Below                    | y+[Margin]
		Align Top                | yp (same Y as previous control)
		Align Center (Vertical)  | y[PreviousControl.Y + (PreviousControl.Height - ControlHeight)/2]
		Align Bottom             | y[PreviousControl.Y + PreviousControl.Height - ControlHeight]
		Align Horizontal-Middle  | x[GuiWidth/2 - ControlWidth/2]
		Align Vertical-Center    | y[GuiHeight/2 - ControlHeight/2]

		Additional Positioning Options:
		- xp: Same X-coordinate as the previous control
		- yp: Same Y-coordinate as the previous control
		- x+n: n pixels to the right of the previous control's right edge
		- y+n: n pixels below the previous control's bottom edge
		- xm: Left margin of the GUI
		- ym: Top margin of the GUI
		- xs: X-coordinate of the most recent section start
		- ys: Y-coordinate of the most recent section start

		Note: Replace [expression] with actual calculations in your code.
	* @example
		; ---------------------------------------------------------------------------
		useRefactoredGUI := false  ; Set this to true to use the refactored version

		CreateGUI() {
			if (this.useRefactoredGUI) {
				this.CreateRefactoredGUI()
			} else {
				this.CreateOriginalGUI()
			}
		}

		CreateOriginalGUI() {
			; Original CreateGUI method content
		}

		CreateRefactoredGUI() {
			; Refactored CreateGUI method content using CreateButtons
		}
		; ---------------------------------------------------------------------------
		this.CreateButtons("Nav", 
			["Previous", "Current", "Next"], 
			this.NavigationHandler, 
			{
				groupBox: true,
				groupName: "Navigation",
				groupOptions: "xm y+10 w750 h60",
				align: "centerX",  ; Centers buttons horizontally
				mWidth: 20,
				buttonOptions: "Default",
				individualButtonOptions: Map("Current", "Primary")
			}
		)
		; ---------------------------------------------------------------------------
		this.CreateButtons("Actions", 
			["Save", "Cancel", "Help"], 
			this.ActionHandler, 
			{
				groupBox: false,
				align: "right",  ; Aligns buttons to the right
				mHeight: 10,
				x: "xm",  ; Left margin
				y: "y+20"  ; 20 pixels below the previous control
			}
		)
		; ---------------------------------------------------------------------------
	*/
	CreateButtons(buttonType, buttonNames, eventHandler, options := {}) {
		defaultOptions := {
			; Determines whether to create a GroupBox to contain the buttons
			; true: Creates a GroupBox, false: Buttons are added directly to the GUI
			groupBox: false,
		
			; The title text for the GroupBox (if groupBox is true)
			; Set to "" for no title
			groupName: "",
		
			; Options string for the GroupBox (if groupBox is true)
			; Format: "x y w h [other_options]"
			; xm: Left margin, y+10: 10 pixels below previous control
			; w370 h70: Width 370, Height 70 pixels
			groupOptions: "xm y+10 w370 h70",
		
			; X-coordinate for the first button (if groupBox is false)
			; Ignored if groupBox is true
			x: 0,
		
			; Y-coordinate for the first button (if groupBox is false)
			; Ignored if groupBox is true
			y: 0,
		
			; Width of the button area (if groupBox is false)
			; Used for calculating button positions in grid layout
			w: 370,
		
			; Height of the button area (if groupBox is false)
			; Used for calculating button positions in grid layout
			h: 70,
		
			; Number of columns in the button grid
			; Set to 0 for automatic calculation based on the number of buttons
			columns: 2,
		
			; Number of rows in the button grid
			; 0 means auto-calculate based on 'columns' and total number of buttons
			; Set a specific number to force a certain number of rows
			rows: 0,
		
			; Horizontal margin between buttons (in pixels)
			mWidth: 10,
		
			; Vertical margin between buttons (in pixels)
			mHeight: 5,
		
			; Additional options string applied to all buttons
			; e.g., "Default", "Hidden", etc.
			buttonOptions: "",
		
			; Map of individual button options
			; Key: Button name, Value: Options string
			; e.g., Map("OK", "Default", "Cancel", "Hidden")
			individualButtonOptions: Map(),
		
			; Alignment method for buttons
			; "grid": Arrange in a grid (uses 'columns' and 'rows')
			; "left", "right", "center": Align buttons horizontally
			; "top", "bottom": Align buttons vertically
			align: "grid",
		
			; Vertical positioning relative to the previous control
			; "below": Place buttons below the previous control
			; "above": Place buttons above the previous control
			; "align-top", "align-center", "align-bottom": Align with previous control
			position: "below",
		
			; Reference point for button positioning
			; "previous": Position relative to the previously added control
			; "parent": Position relative to the parent container (GUI or GroupBox)
			reference: "previous"
		}
		options := this.MergeOptions(defaultOptions, options)
	
		if (options.groupBox) {
			this.%buttonType%Group := this.mainGui.AddGroupBox(options.groupOptions, options.groupName)
			this.%buttonType%Group.GetPos(&groupX, &groupY, &groupW, &groupH)
		} else {
			groupX := options.x
			groupY := options.y
			groupW := options.w
			groupH := options.h
		}
	
		btnWidth := Gui2.SetButtonWidth(buttonNames)
		btnHeight := Gui2.SetButtonHeight()
	
		this.%buttonType%Buttons := Map()
		
		if (options.rows == 0) {
			options.rows := Ceil(buttonNames.Length / options.columns)
		}
	
		for index, btnName in buttonNames {
			buttonOpt := this.CalculateButtonPosition(index, btnName, options, groupX, groupY, groupW, groupH, btnWidth, btnHeight)
			buttonOpt .= " " options.buttonOptions
	
			if (options.individualButtonOptions.Has(btnName)) {
				buttonOpt .= " " options.individualButtonOptions[btnName]
			}
	
			this.%buttonType%Buttons[btnName] := this.mainGui.AddButton(buttonOpt, btnName)
			this.%buttonType%Buttons[btnName].OnEvent("Click", eventHandler.Bind(this, btnName))
		}
	
		; Combine into this.buttons if necessary
		if (buttonType == "Report" || buttonType == "Select") {
			if (!this.HasProp("buttons")) {
				this.buttons := Map()
			}
			for key, value in this.%buttonType%Buttons {
				this.buttons[key] := value
			}
		}
	
		return this.%buttonType%Buttons
	}
	
	CalculateButtonPosition(index, btnName, options, groupX, groupY, groupW, groupH, btnWidth, btnHeight) {
		xPos := groupX
		yPos := groupY
	
		switch options.align {
			case "left":
				xPos += options.mWidth
			case "right":
				xPos += groupW - btnWidth - options.mWidth
			case "center", "gui-centerline":
				xPos += (groupW - btnWidth) / 2
			case "grid":
				col := Mod(index - 1, options.columns)
				row := (index - 1) // options.columns
				xPos += options.mWidth + (col * (btnWidth + options.mWidth))
				yPos += options.mHeight + (row * (btnHeight + options.mHeight))
				return "x" xPos " y" yPos " w" btnWidth " h" btnHeight
		}
	
		switch options.position {
			case "above":
				yPos -= btnHeight + options.mHeight
			case "below":
				yPos += options.mHeight
			case "align-top":
				; yPos remains unchanged
			case "align-center":
				yPos += (groupH - btnHeight) / 2
			case "align-bottom":
				yPos += groupH - btnHeight
			case "align-vertical-center":
				yPos += (groupH - btnHeight) / 2
		}
	
		return "x" xPos " y" yPos " w" btnWidth " h" btnHeight
	}

	MergeOptions(defaultOptions, userOptions) {
		mergedOptions := {}
	
		for key, value in defaultOptions {
			if (IsObject(value) && !value.HasMethod("__Call")) {  ; Check if it's an object but not a function
				if (userOptions.HasOwnProp(key) && IsObject(userOptions[key])) {
					mergedOptions[key] := this.MergeOptions(value, userOptions[key])
				} else {
					mergedOptions[key] := value.Clone()
				}
			} else {
				mergedOptions[key] := value
			}
		}
	
		for key, value in userOptions {
			if (!mergedOptions.HasOwnProp(key)) {
				mergedOptions[key] := (IsObject(value) && !value.HasMethod("__Call")) ? value.Clone() : value
			}
		}
	
		return mergedOptions
	}

    CreateReportButtons() {
        arrBtnRpt := ['Open Expense Report', 'Submit Expense Report']
        this.reportGroup := this.mainGui.AddGroupBox("xm w370 h70", "Report Actions")
        this.reportGroup.GetPos(&rptGroupX, &rptGroupY, &rptGroupW, &rptGroupH)
        
        btnWidth := Gui2.SetButtonWidth(arrBtnRpt)
        btnHeight := Gui2.SetButtonHeight()
        
        this.reportButtons := Map()
        for index, btnName in arrBtnRpt {
            xPos := rptGroupX + 10 + (index - 1) * (btnWidth + 10)
            yPos := rptGroupY + 25
            this.reportButtons[btnName] := this.mainGui.AddButton("x" xPos " y" yPos " w" btnWidth " h" btnHeight, btnName)
            this.reportButtons[btnName].OnEvent("Click", this.ButtonHandler.Bind(this, btnName))
        }

        return this.rptGroup := {x:rptGroupX, y:rptGroupY, w:rptGroupW, h:rptGroupH}
    }

	RefreshExpenses() {
		if (this.GetChromeRiverElement(&expRpt)) {
			this.ShowInfo("Refreshing expenses...")
			
			; Clear existing expenses
			this.expenses := []
			this.unclassifiedExpenses := []
			this.classifiedExpenses := []
			
			; Find and process expenses
			this.FindControls()
			
			; Update the GUI display
			this.UpdateExpenseDisplay()
			
			this.ShowInfo("Expenses refreshed successfully.")
		} else {
			this.ShowInfo("Unable to access Chrome River. Please make sure it's open and try again.")
		}
	}

    CreateSelectButtons() {
        arrBtnSel := ['Select All Transactions', 'Add Selected to Report']
        this.selectGroup := this.mainGui.AddGroupBox('x' (this.rptGroup.x + this.rptGroup.w + 10) ' y' (this.rptGroup.y) " w370 h70", "Selection Actions")
        this.selectGroup.GetPos(&selGroupX, &selGroupY, &selGroupW, &selGroupH)
        
        btnWidth := Gui2.SetButtonWidth(arrBtnSel)
        btnHeight := Gui2.SetButtonHeight()
        
        this.selectButtons := Map()
        for index, btnName in arrBtnSel {
            xPos := selGroupX + 10 + (index - 1) * (btnWidth + 10)
            yPos := selGroupY + 25
            this.selectButtons[btnName] := this.mainGui.AddButton("x" xPos " y" yPos " w" btnWidth " h" btnHeight, btnName)
            this.selectButtons[btnName].OnEvent("Click", this.ButtonHandler.Bind(this, btnName))
        }

        ; Combine all buttons into this.buttons
        this.buttons := this.reportButtons.Clone()
        for key, value in this.selectButtons {
            this.buttons[key] := value
        }
    }

    CreateExpenseListView() {
		this.expensesLabel := this.mainGui.AddText("xm y+10 w280", "Expenses:")
		this.expenseListView := this.mainGui.AddListView("xm y+5 w750 r10", ["Description", "Amount", "Date", "Category", "Classification", "Requires Receipt"])
		this.expenseListView.OnEvent("ItemSelect", (*) => this.SelectExpense())
		this.expenseListView.OnEvent("DoubleClick", (*) => this.HandleDoubleClick())
	}

	HandleDoubleClick() {
		this.SelectExpense()
		if (this.unclassifiedExpenses[this.currentExpenseIndex].classification == "Unclassified") {
			this.InvokeHelpGroup()
		} else {
			this.ShowInfo("This expense is already classified.")
		}
	}

	IsUnclassifiedExpense(expenseGroup) {
		return SubStr(expenseGroup.Name, 1, 4) == "help"
	}

	InvokeHelpGroup() {
		unclassBtn := {Type: '50026 (Group)', Name: "help", LocalizedType: "group"}
		if (this.GetChromeRiverElement(&expRpt)) {
			try {
				currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
				this.ShowInfo("Attempting to invoke help group for expense: " . currentExpense.description)
				expenseGroups := expRpt.FindCachedElements({Type: '50026 (Group)', LocalizedType: 'group'})
				currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
				for group in expenseGroups {
					; if (group.Name ~= 'Fm Amex') {
					if (group.Name ~= currentExpense.description && group.Name ~= currentExpense.amount) {
						if (elem := expRpt.FindElement({Name: group.Name})) {
							if (eChild := elem.FindElement(unclassBtn)) {
								eChild.Invoke()
								this.ShowInfo("Help group invoked for expense: " . currentExpense.description)
							}
							else {
								this.ShowInfo("Help group not found for unclassified expense: " . currentExpense.description)
							}
						}
						; infos(elem := expRpt.FindElement({Name: group.Name}))
						; eChild := elem.FindElement(unclassBtn)
						; Infos(eChild)
						; eChild.Invoke()
					}
				}
			} 
			catch as err {
				this.ShowInfo("Error invoking help group: " . err.Message)
			}
		}
	}

    CreateNavigationButtons() {
        this.navGroup := this.mainGui.AddGroupBox("xm y+10 w750 h60", "Navigation")
        this.navGroup.GetPos(&navGroupX, &navGroupY, &navGroupW, &navGroupH)
        
        navBtns := ["Previous", "Select", "Next"]
        navButtonWidth := Gui2.SetButtonWidth(navBtns)
        navButtonHeight := Gui2.SetButtonHeight()
        totalNavWidth := navButtonWidth * 3 + 20  ; 20 for gaps between buttons
        startX := navGroupX + (navGroupW - totalNavWidth) / 2  ; Center the nav buttons in the GroupBox

        this.navButtons := Map()
        for index, btnName in navBtns {
            xPos := startX + (index - 1) * (navButtonWidth + 10)  ; 10 pixel gap between buttons
            this.navButtons[btnName] := this.mainGui.AddButton("x" xPos " y" navGroupY + 25 " w" navButtonWidth " h" navButtonHeight, btnName)
            this.navButtons[btnName].OnEvent("Click", this.NavigationHandler.Bind(this, btnName))
        }
    }

    ; CreateCategoryButtons(catGroupX, catGroupY, catGroupW, catGroupH) {
	; 	categoryButtonWidth := Gui2.SetButtonWidth(this._categories.GetCategories())
	; 	categoryButtonHeight := Gui2.SetButtonHeight()
		
	; 	xMargin := 10
	; 	yMargin := 20
	; 	xSpacing := 10
	; 	ySpacing := 10
		
	; 	xStart := catGroupX + xMargin
	; 	yStart := catGroupY + yMargin
	
	; 	buttonsPerRow := 4  ; Set to 4 columns
	; 	this.categoryGroup := this.mainGui.AddGroupBox("x" . catGroupX . " y" . catGroupY . " w" . catGroupW . " h" . catGroupH, "Categories")
	; 	for index, category in this.categoryOrder {
	; 		col := Mod(A_Index - 1, buttonsPerRow)
	; 		row := (A_Index - 1) // buttonsPerRow
	
	; 		xPos := xStart + (col * (categoryButtonWidth + xSpacing))
	; 		yPos := yStart + (row * (categoryButtonHeight + ySpacing))
	
	; 		this.buttons.%category% := this.mainGui.AddButton("x" xPos " y" yPos " w" categoryButtonWidth " h" categoryButtonHeight, category)
	; 		; Use a function to create a closure that captures the current category
	; 		this.buttons.%category%.OnEvent('Click', this.CreateCategoryClickHandler(category))
	; 	}
	; }
	
	; Add this method to your class
	CreateCategoryClickHandler(category) {
		return (*) => this.SelectCategory(category)
	}

	RecreateCategoryButtons() {
		; Remove existing category buttons
		for category in this._categories.GetCategories() {
			if (this.buttons.Has(category)) {
				this.buttons[category].Destroy()
				this.buttons.Delete(category)
			}
		}
	
		; Remove existing classification ListViews
		for _, listView in this.classificationListViews {
			listView.Destroy()
		}
		this.classificationListViews := Map()
	
		; Recreate the Categories section
		this.CreateCategoriesSection()
	
		; Recreate the Classifications section
		this.CreateClassificationsSection()
	
		; Resize the GUI to fit the new layout
		this.mainGui.Show('AutoSize')
	}

	CreateClassificationButtons() {
		mainCategories := ["Travel", "Meals / Entertainment", "Telecom", "Company Car"]
		
		for tabIndex, category in this._categories.GetCategories() {
			this.classificationTabs.UseTab(tabIndex)
			
			if (tabIndex == 1) {
				this.CreateMainTabButtons(mainCategories)
			} else {
				classifications := this._categories.GetClassifications(category)
				this.CreateCategoryButtons(classifications)
			}
		}
		
		this.classificationTabs.UseTab()  ; Deselect all tabs
	}
	
	RemoveClassificationButtons() {
		if (this.HasProp("classificationTabs")) {
			this.classificationTabs.Destroy()
			for ctrl in this.mainGui {
				if (ctrl.Type == "Button" && !this.buttons.HasOwnProp(ctrl.Text)) {
					ctrl.Destroy()
				}
			}
		}
	}
	

    ShowGUI() {
        this.mainGui.Show('AutoSize')
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
            ; SetTimer(() => ToolTip(this.infoTimer), -300000)  ; Hide after 5 minutes
            Infos(message)
        }
    }

	; * Creates the menu bar for the GUI
	CreateMenuBar() {
		mBar := MenuBar()
		fileMenu := Menu()
		fileMenu.Add("Settings", (*) => this.ShowSettingsGUI())
		fileMenu.Add("Exit", (*) => ExitApp())
		mBar.Add("&File", fileMenu)

		viewMenu := Menu()
		viewMenu.Add("Toggle Info Display", (*) => this.ToggleInfoDisplay())
		viewMenu.Add("Toggle Output Mode", (*) => this.ToggleOutputMode())
		mBar.Add("&View", viewMenu)

		this.mainGui.MenuBar := mBar
	}

    GetLastActionButtonPos() {
        return ButtonCreator(this.mainGui, 0, 0, 0, 0).GetLastButtonPos()
    }

    /**
     * @section Event Handlers
     */

    /**
     * Handles clicks on main action buttons
     * @param {String} btnName - The name of the clicked button
     */
	ButtonHandler(btnName, *) {
		switch btnName {
			case 'Open Expense Report': this.AddNewExpense()
			case 'Submit Expense Report': this.SubmitExpenseReport()
			case 'Select All Transactions': this.SelectAllTransactions()
			case 'Add Selected to Report': this.AddSelectedToReport()
			case 'Refresh Expenses': this.RefreshExpenses()
		}
	}

    /**
     * Handles clicks on navigation buttons
     * @param {String} btnName - The name of the clicked button
     */
	NavigationHandler(btnName, *) {
		switch btnName {
			case 'Previous': 
				this.NavigateExpense(-1)
				this.SelectExpense()
			case 'Select': 
				this.InvokeHelpGroup()
			case 'Next': 
				this.NavigateExpense(1)
				this.SelectExpense()
		}
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

    LoadUnclassifiedExpenses() {
        this.FindControls()
        this.UpdateExpenseDisplay()
    }

	UpdateExpenseDisplay() {
		if (this.expenseListView) {
			this.expenseListView.Delete()  ; Clear existing items
			
			for index, expense in this.expenses {
				this.AddExpenseToListView(expense)
			}
			
			this.expenseListView.ModifyCol()  ; Auto-size columns
			this.expenseListView.ModifyCol(1, 'AutoHdr')  ; Auto-size header for the first column
		} else {
			Infos("expenseListView not initialized")
		}
	}

	AddExpenseToListView(expense) {
		description := expense.HasProp('description') ? expense.description : 'N/A'
		amount := (expense.HasProp('amount') ? expense.amount : 'N/A') . ' ' . (expense.HasProp('currency') ? expense.currency : '')
		date := expense.HasProp('date') ? expense.date : 'N/A'
		category := expense.HasProp('category') ? expense.category : 'N/A'
		classification := expense.HasProp('classification') ? expense.classification : 'N/A'
		requiresReceipt := expense.HasProp('requiresReceipt') ? (expense.requiresReceipt ? "Yes" : "No") : 'N/A'
		
		this.expenseListView.Add(, description, amount, date, category, classification, requiresReceipt)
	}

	SaveExpenses() {
		if (this.settingsManager.SaveExpenses(this.expenses)) {
			this.ShowInfo("Expenses saved successfully")
		} else {
			this.ShowInfo("Failed to save expenses")
		}
	}
	
	LoadExpenses() {
		loadedExpenses := this.settingsManager.LoadExpenses()
		if (loadedExpenses.Length > 0) {
			this.expenses := loadedExpenses
			this.UpdateExpenseDisplay()
			this.ShowInfo("Expenses loaded successfully")
		} else {
			this.ShowInfo("No expenses found or failed to load expenses")
		}
	}

	AutoLoadExpenses() {
		; Placeholder method for automatically loading the last known file
		; Uncomment the following line to enable auto-loading
		; this.LoadExpenses()
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
			this.ShowInfo("No unclassified expenses to select.")
			return
		}
	
		selectedRow := this.expenseListView.GetNext(0, 'Focused')
		if (selectedRow = 0) {
			selectedRow := 1
		}
		this.currentExpenseIndex := selectedRow
	
		if (this.GetChromeRiverElement(&expRpt)) {
			try {
				currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
				this.ShowInfo("Attempting to focus on expense: " . currentExpense.description)
				
				if (currentExpense.HasProp('element')) {
					this.ShowInfo("Using stored element")
					currentExpense.element.SetFocus()
					Sleep(100)
					currentExpense.element.ScrollIntoView()
					Sleep(100)
					currentExpense.element.Click()
				} else {
					this.ShowInfo("Searching for expense element")
					expenseGroup := expRpt.FindCachedElements({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description})
					if (expenseGroup) {
						this.ShowInfo("Found expense element, attempting to interact")
						expenseGroup.SetFocus()
						Sleep(100)
						expenseGroup.ScrollIntoView()
						Sleep(100)
						expenseGroup.Click()
					} else {
						this.ShowInfo("Unable to find expense element: " . currentExpense.description)
					}
				}
				
				this.ShowInfo("Selected expense: " . currentExpense.description)
			} catch as err {
				this.ShowInfo("Error selecting expense: " . err.Message)
			}
		}
	}

    SelectExpenseLV() {
        ; This method can be simplified and redundant parts removed
        if (this.unclassifiedExpenses.Length = 0) {
            return
        }

        selectedRow := this.expenseListView.GetNext(0, 'Focused')
        if (selectedRow = 0) {
            selectedRow := 1
        }
        this.currentExpenseIndex := selectedRow

        if (this.GetChromeRiverElement(&expRpt)) {
            currentExpense := this.unclassifiedExpenses[this.currentExpenseIndex]
            expenseGroup := expRpt.FindCachedElement({Type: '50026 (Group)', LocalizedType: 'group', Name: currentExpense.description})
            if (expenseGroup) {
                expenseGroup.Click()
                this.ShowInfo('Selected expense: ' . currentExpense.description)
            } else {
                this.ShowInfo('Unable to select expense: ' . currentExpense.description)
            }
        }
    }

	SelectCategory(category) {
		menuitem := {Type: '50011 (MenuItem)', Name: category, LocalizedType: "menu item"}
		if (this.GetChromeRiverElement(&expRpt)) {
			categoryElement := expRpt.FindFirst(menuitem)
			if (categoryElement) {
				this.FocusElement(categoryElement)
				categoryElement.SetFocus()
				Sleep(100)
				categoryElement.ScrollIntoView()
				Sleep(100)
				categoryElement.Invoke()
				this.ShowInfo('Selected category: ' . category)
				
				; Switch to the appropriate tab
				tabIndex := this._categories.GetCategories().IndexOf(category)
				if (tabIndex > 0) {
					this.classificationTabs.Choose(tabIndex + 1)  ; +1 because the first tab is "Main"
				} else {
					this.classificationTabs.Choose(1)  ; Default to "Main" tab
				}
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
			Sleep(500)  ; Allow time for the window to activate
			return true
		} else {
			this.ShowInfo('Chrome River window not found. Please open Chrome River in Google Chrome.')
			return false
		}
	}

    FocusElement(element) {
		if (element) {
			try {
				this.ShowInfo("Focusing on element: " . element.Name)
				element.SetFocus()
				Sleep(100)  ; Allow time for focus to take effect
				element.ScrollIntoView()
				Sleep(100)  ; Allow time for scrolling to complete
				this.ShowInfo("Element focused and scrolled into view")
			} catch as e {
				this.ShowInfo("Error focusing element: " . e.Message)
			}
		} else {
			this.ShowInfo("Cannot focus on null element")
		}
	}

	AddNewExpenses(){
		
		if this.GetChromeRiverElement(&expRpt) {
			addExpBtn := expRpt.FindCachedElement({Type: '50000 (Button)', Name: 'Add New Expense', LocalizedType: 'button'})
			addExpBtn.Invoke()
		}
	}

	; FindControls() {
	; 	this.expenses := []
	; 	this.unclassifiedExpenses := []
	; 	this.classifiedExpenses := []
	; 	if (this.GetChromeRiverElement(&expRpt)) {
	; 		expenseGroups := expRpt.FindAll({Type: '50026 (Group)', LocalizedType: 'group'})
			
	; 		for group in expenseGroups {
	; 			if (SubStr(group.Name, 1, 7) == "Fm Amex") {
	; 				expenseInfo := this.ExtractExpenseInfo(group)
	; 				this.expenses.Push(expenseInfo)
	; 				if (this.IsUnclassifiedExpense(group)) {
	; 					this.unclassifiedExpenses.Push(expenseInfo)
	; 				} else {
	; 					this.classifiedExpenses.Push(expenseInfo)
	; 				}
	; 			}
	; 		}
	; 	}
		
	; 	this.ShowInfo('Found ' . this.expenses.Length . ' expenses')
	; 	return this.expenses.Length
	; }

    ; ---------------------------------------------------------------------------

	FindControls() {
        this.expenses := []
        this.unclassifiedExpenses := []
        this.classifiedExpenses := []
        
        if (this.GetChromeRiverElement(&expRpt)) {
            expenseGroups := expRpt.FindCachedElements({Type: '50026 (Group)', LocalizedType: 'group'})
            
            for group in expenseGroups {
                if (group.Name ~= 'Fm Amex') {
                    expenseInfo := this.ExtractExpenseInfo(group)
                    this.expenses.Push(expenseInfo)

                    ; Check for "check" or "warning" elements to determine if the expense is classified
                    checkElement := group.FindCachedElement({Type: '50020 (Text)', Name: 'check', LocalizedType: 'text'}, UIA.TreeScope.Element, , 0)
                    warningElement := group.FindCachedElement({Type: '50020 (Text)', Name: 'warning', LocalizedType: 'text'}, UIA.TreeScope.Element, , 0)

                    if (checkElement || warningElement) {
                        this.classifiedExpenses.Push(expenseInfo)
                    } else {
                        this.unclassifiedExpenses.Push(expenseInfo)
                    }
                }
            }
        }
        
        this.ShowInfo('Found ' . this.expenses.Length . ' total expenses, ' . 
                      this.unclassifiedExpenses.Length . ' unclassified and ' . 
                      this.classifiedExpenses.Length . ' classified')
        return this.expenses.Length
    }

	ExtractExpenseInfo(group) {
		regexPattern := "(?:help\s)?Fm Amex (\w+) (.+?) (\d{2}/\d{2}/\d{4}) (.+?) (?:check_box_outline_blank|check|warning) (\d+\.\d{2}) (\w{3})"
		if (RegExMatch(group.Name, regexPattern, &matches)) {
			return {
				element: group,
				origin: matches[1],
				category: matches[2],
				date: matches[3],
				description: matches[4],
				amount: matches[5],
				currency: matches[6],
				classification: (group.FindCachedElement({Type: '50020 (Text)', Name: 'check', LocalizedType: 'text'}, UIA.TreeScope.Element, , 0) ? "Classified" : "Unclassified"),
				requiresReceipt: Number(matches[5]) > 75.00
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

		ele := ''
		if (expRpt) {
			this.ShowInfo('Successfully retrieved Chrome River element')

			return true
		} else {
			this.ShowInfo('Failed to retrieve Chrome River element')
			return false
		}
	}

	
}

Class UIA_ElementFromChromiumWCache {
	infoTimer := 0

	__New(scope := 5) {

	}
	
	/**
 	* @param scope TreeScope value: Element (1), Children (2), Family (Element+Children) (3), Descendants (4), Subtree (=Element+Descendants) (5). Default is Descendants.
 	*/
	ElementFromChromium_w_Cache(&expRpt, title := 'Chrome River - Google Chrome', scope := 5) {
		; title := 'Chrome River - Google Chrome'
		; scope := 5
		cacheRequest := UIA.CreateCacheRequest()
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
            ; SetTimer(() => ToolTip(this.infoTimer), -300000)  ; Hide after 5 minutes
            Infos(message)
        }
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

	FindControls() {
        this.expenses := []
        this.unclassifiedExpenses := []
        this.classifiedExpenses := []
        ; group := ''

        if (this.ElementFromChromium_w_Cache(&expRpt)) {
            expenseGroups := expRpt.FindCachedElements({Type: '50026 (Group)', LocalizedType: 'group'})
            
            for group in expenseGroups {
                if (group.Name ~= 'Fm Amex') {
                    expenseInfo := this.ElementFromChromium_w_Cache(group)
                    this.expenses.Push(expenseInfo)

                    ; Check for "check" or "warning" elements to determine if the expense is classified
                    checkElement := group.FindCachedElement({Type: '50020 (Text)', Name: 'check', LocalizedType: 'text'}, UIA.TreeScope.Element, , 0)
                    warningElement := group.FindCachedElement({Type: '50020 (Text)', Name: 'warning', LocalizedType: 'text'}, UIA.TreeScope.Element, , 0)

                    if (checkElement || warningElement) {
                        this.classifiedExpenses.Push(expenseInfo)
                    } else {
                        this.unclassifiedExpenses.Push(expenseInfo)
                    }
                }
            }
        }
        
        this.ShowInfo('Found ' . this.expenses.Length . ' total expenses, ' . 
                      this.unclassifiedExpenses.Length . ' unclassified and ' . 
                      this.classifiedExpenses.Length . ' classified')
        return this.expenses.Length
    }

	ExtractExpenseInfo(group := {}) {
		regexPattern := "(?:help\s)?Fm Amex (\w+) (.+?) (\d{2}/\d{2}/\d{4}) (.+?) (?:check_box_outline_blank|check|warning) (\d+\.\d{2}) (\w{3})"
		if (RegExMatch(group.Name, regexPattern, &matches)) {
			return {
				element: group,
				origin: matches[1],
				category: matches[2],
				date: matches[3],
				description: matches[4],
				amount: matches[5],
				currency: matches[6],
				classification: (group.FindCachedElement({Type: '50020 (Text)', Name: 'check', LocalizedType: 'text'}, UIA.TreeScope.Element, , 0) ? "Classified" : "Unclassified"),
				requiresReceipt: Number(matches[5]) > 75.00
			}
		}
		return {}
	}

}

/**
 *  @example Main Script Execution
 */

; Create an instance of the GUI
chromeRiverHelper := ChromeRiverGUI()

class SettingsManager {
	
    static supportedFormats := ["json", "ini", "xml", "html"]
    static defaultFormat := "json"
	static defaultSettings := Map(
        "columnLayout", 0,
        "categoryOrder", ["Travel", "Meals / Entertainment", "Company Car", "Telecom", "Office Expenses", "Professional Development", "Fees / Advances", "Misc", "Engineer / Equipment"],
        "showInfoEnabled", true,
        "useOutputDebug", false,
        "classificationDisplay", "Display only selected category"
    )
	static settingsFolder := A_ScriptDir
	static settingsFile := this.settingsFolder '\settings.' SettingsManager.defaultFormat


    ; __New(settingsFolder := A_ScriptDir) {
	__New() {
			this.settingsFolder := SettingsManager.settingsFolder
			this.settingsFile 	:= SettingsManager.settingsFile
	
        ; this.settingsFolder := settingsFolder ? settingsFolder : A_AppData "\ChromeRiverHelper"
		if !DirExist(this.settingsFolder){
			DirCreate(this.settingsFolder)
			this.settingsFile := this.settingsFolder "\settings." SettingsManager.defaultFormat
		}

        ; Check if settings file exists, create if it doesn't
        if !FileExist(this.settingsFile) {
            this.CreateDefaultSettingsFile()
        }
    }

	CreateDefaultSettingsFile() {
        this.SaveSettings(SettingsManager.defaultSettings, SettingsManager.defaultFormat)
    }

    LoadSettings(useDefault := false) {
        if (useDefault) {
            return SettingsManager.defaultSettings.Clone()
        }

        if !FileExist(this.settingsFile) {
            this.CreateDefaultSettingsFile()
            return SettingsManager.defaultSettings.Clone()
        }

        loadedSettings := this.LoadSettingsFromFile()
        
        ; Merge loaded settings with default settings to ensure all properties exist
        mergedSettings := SettingsManager.defaultSettings.Clone()
        for key, value in loadedSettings {
            if (mergedSettings.HasOwnProp(key)) {
                mergedSettings[key] := value
            }
        }

        return mergedSettings
    }

	LoadSettingsFromFile() {
        SplitPath(this.settingsFile,, &dir, &ext)
        switch ext {
            case "json":
                return this.LoadJSON()
            case "ini":
                return this.LoadINI()
            case "xml":
                return this.LoadXML()
            case "html", "htm":
                return this.LoadHTML()
            default:
                return SettingsManager.defaultSettings.Clone()
        }
    }

    SaveSettings(settings, format := "") {
        if (format = "")
            format := SettingsManager.defaultFormat

        if !this.IsFormatSupported(format)
            throw Error("Unsupported file format: " format)

        this.settingsFile := this.GetSettingsFilePath(format)

        ; Delete the existing file before writing new content
        if FileExist(this.settingsFile) {
            try {
                FileDelete(this.settingsFile)
            } catch as err {
                MsgBox("Error deleting existing settings file: " err.Message)
                return false
            }
        }

        try {
            switch format {
                case "json":
                    this.SaveJSON(settings)
                case "ini":
                    this.SaveINI(settings)
                case "xml":
                    this.SaveXML(settings)
                case "html", "htm":
                    this.SaveHTML(settings)
            }
            return true
        } catch as err {
            MsgBox("Error saving settings: " err.Message)
            return false
        }
    }

    GetSettingsFilePath(format) {
        return this.settingsFolder "\settings." format
    }

    IsFormatSupported(format) {
        return SettingsManager.supportedFormats.HasValue(format)
    }

	ObjectToMap(obj) {
		map := Map()
		for key, value in obj.OwnProps() {
			if (IsObject(value) && !value.HasMethod("__Call")) {
				map[key] := this.ObjectToMap(value)
			} else {
				map[key] := value
			}
		}
		return map
	}

	MapToObject(map) {
		obj := {}
		for key, value in map {
			if (Type(value) == "Map") {
				obj.%key% := this.MapToObject(value)
			} else {
				obj.%key% := value
			}
		}
		return obj
	}

    LoadJSON() {
		try {
			fileContent := FileRead(this.settingsFile, "UTF-8")
			loadedSettings := JSON.Parse(fileContent)
			
			; Convert Object to Map if necessary
			if (Type(loadedSettings) == "Object") {
				loadedSettings := this.ObjectToMap(loadedSettings)
			}
			
			; Ensure all expected properties exist
			settings := Map()
			for key, value in SettingsManager.defaultSettings {
				settings[key] := loadedSettings.Has(key) ? loadedSettings[key] : value
			}
			return settings
		} catch as err {
			MsgBox("Error loading JSON settings: " err.Message)
			return SettingsManager.defaultSettings.Clone()
		}
	}

    SaveJSON(settings) {
		try {
			jsonString := JSON.Stringify(this.MapToObject(settings), 4)  ; 4 spaces indentation
			FileAppend(jsonString, this.settingsFile, "UTF-8")
		} catch as err {
			MsgBox("Error saving JSON settings: " err.Message)
		}
	}

    LoadINI() {
        settings := SettingsManager.defaultSettings.Clone()
        try {
            settings.columnLayout := IniRead(this.settingsFile, "General", "ColumnLayout", 0)
            settings.showInfoEnabled := IniRead(this.settingsFile, "General", "ShowInfoEnabled", true)
            settings.useOutputDebug := IniRead(this.settingsFile, "General", "UseOutputDebug", false)
            
            categoryOrderStr := IniRead(this.settingsFile, "Categories", "Order", "")
            if (categoryOrderStr != "")
                settings.categoryOrder := StrSplit(categoryOrderStr, ",")
        } catch as err {
            MsgBox("Error loading INI settings: " err.Message)
        }
        return settings
    }

    SaveINI(settings) {
        try {
            IniWrite(settings.columnLayout, this.settingsFile, "General", "ColumnLayout")
            IniWrite(settings.showInfoEnabled, this.settingsFile, "General", "ShowInfoEnabled")
            IniWrite(settings.useOutputDebug, this.settingsFile, "General", "UseOutputDebug")
            IniWrite(settings.categoryOrder.Join(","), this.settingsFile, "Categories", "Order")
        } catch as err {
            MsgBox("Error saving INI settings: " err.Message)
        }
    }

    LoadXML() {
        settings := SettingsManager.defaultSettings.Clone()
        try {
            xml := FileRead(this.settingsFile, "UTF-8")
            xmlObj := ComObject("MSXML2.DOMDocument.6.0")
            xmlObj.async := false
            xmlObj.loadXML(xml)

            settings.columnLayout := Integer(xmlObj.selectSingleNode("//columnLayout").text)
            settings.showInfoEnabled := (xmlObj.selectSingleNode("//showInfoEnabled").text = "true")
            settings.useOutputDebug := (xmlObj.selectSingleNode("//useOutputDebug").text = "true")

            categoryNodes := xmlObj.selectNodes("//categoryOrder/category")
            settings.categoryOrder := []
            for category in categoryNodes
                settings.categoryOrder.Push(category.text)
        } catch as err {
            MsgBox("Error loading XML settings: " err.Message)
        }
        return settings
    }

	SaveXML(settings) {
		try {
			xmlObj := ComObject("MSXML2.DOMDocument.6.0")
			xmlObj.async := false
			rootNode := xmlObj.createElement("settings")

			; Explicitly define the properties we want to save
			propertiesToSave := ["columnLayout", "showInfoEnabled", "useOutputDebug", "categoryOrder"]

			for key in propertiesToSave {
				if (key != "categoryOrder") {
					node := xmlObj.createElement(key)
					node.text := settings.%key%
					rootNode.appendChild(node)
				} else {
					categoryOrderNode := xmlObj.createElement("categoryOrder")
					for category in settings.categoryOrder {
						categoryNode := xmlObj.createElement("category")
						categoryNode.text := category
						categoryOrderNode.appendChild(categoryNode)
					}
					rootNode.appendChild(categoryOrderNode)
				}
			}

			xmlObj.appendChild(rootNode)
			FileAppend(xmlObj.xml, this.settingsFile, "UTF-8")
		} catch as err {
			MsgBox("Error saving XML settings: " err.Message)
		}
	}

    LoadHTML() {
        settings := SettingsManager.defaultSettings.Clone()
        try {
            html := FileRead(this.settingsFile, "UTF-8")
            ; Simple parsing, assumes a specific structure
            settings.columnLayout := Integer(RegExMatch(html, "Column Layout:</td><td>(\d+)", &match) ? match[1] : 0)
            settings.showInfoEnabled := !!RegExMatch(html, "Show Info Enabled:</td><td>(true|false)", &match) && match[1] = "true"
            settings.useOutputDebug := !!RegExMatch(html, "Use Output Debug:</td><td>(true|false)", &match) && match[1] = "true"
            
            if (RegExMatch(html, "Category Order:</td><td>(.*?)</td>", &match)) {
                settings.categoryOrder := StrSplit(match[1], ",")
            }
        } catch as err {
            MsgBox("Error loading HTML settings: " err.Message)
        }
        return settings
    }

    SaveHTML(settings) {
        try {
            html := "
            (
            <!DOCTYPE html>
            <html>
            <head>
                <title>Chrome River Helper Settings</title>
            </head>
            <body>
                <table>
                    <tr><td>Column Layout:</td><td>" settings.columnLayout "</td></tr>
                    <tr><td>Show Info Enabled:</td><td>" (settings.showInfoEnabled ? "true" : "false") "</td></tr>
                    <tr><td>Use Output Debug:</td><td>" (settings.useOutputDebug ? "true" : "false") "</td></tr>
                    <tr><td>Category Order:</td><td>" settings.categoryOrder.Join(",") "</td></tr>
                </table>
            </body>
            </html>
            )"
            FileAppend(html, this.settingsFile, "UTF-8")
        } catch as err {
            MsgBox("Error saving HTML settings: " err.Message)
        }
    }

	SaveExpenses(expenses, format := "") {
		if (format = "")
			format := SettingsManager.defaultFormat
	
		if !this.IsFormatSupported(format)
			throw Error("Unsupported file format: " format)
	
		expensesFile := this.GetExpensesFilePath(format)
	
		try {
			switch format {
				case "json":
					this.SaveExpensesJSON(expenses, expensesFile)
				case "ini":
					this.SaveExpensesINI(expenses, expensesFile)
				case "xml":
					this.SaveExpensesXML(expenses, expensesFile)
				case "html", "htm":
					this.SaveExpensesHTML(expenses, expensesFile)
			}
			return true
		} catch as err {
			MsgBox("Error saving expenses: " err.Message)
			return false
		}
	}
	
	LoadExpenses(format := "") {
		if (format = "")
			format := SettingsManager.defaultFormat
	
		expensesFile := this.GetExpensesFilePath(format)
	
		if !FileExist(expensesFile) {
			return []
		}
	
		try {
			switch format {
				case "json":
					return this.LoadExpensesJSON(expensesFile)
				case "ini":
					return this.LoadExpensesINI(expensesFile)
				case "xml":
					return this.LoadExpensesXML(expensesFile)
				case "html", "htm":
					return this.LoadExpensesHTML(expensesFile)
			}
		} catch as err {
			MsgBox("Error loading expenses: " err.Message)
			return []
		}
	}
	
	GetExpensesFilePath(format) {
		return this.settingsFolder "\expenses." format
	}
	
	; Implement these methods for each format (JSON, INI, XML, HTML)
	SaveExpensesJSON(expenses, filePath) {
		FileOpen(filePath, "w").Write(JSON.Stringify(expenses))
	}
	
	LoadExpensesJSON(filePath) {
		return JSON.Parse(FileRead(filePath))
	}
	
	SaveExpensesINI(expenses, filePath) {
        ; Implement INI saving logic here
        ; This is a placeholder implementation
        for index, expense in expenses {
            section := "Expense" . index
            IniWrite(expense.description, filePath, section, "Description")
            IniWrite(expense.amount, filePath, section, "Amount")
            IniWrite(expense.date, filePath, section, "Date")
            IniWrite(expense.category, filePath, section, "Category")
            IniWrite(expense.classification, filePath, section, "Classification")
            IniWrite(expense.requiresReceipt, filePath, section, "RequiresReceipt")
        }
    }

    SaveExpensesXML(expenses, filePath) {
        ; Implement XML saving logic here
        ; This is a placeholder implementation
        xmlObj := ComObject("MSXML2.DOMDocument.6.0")
        xmlObj.async := false
        rootNode := xmlObj.createElement("Expenses")
        
        for expense in expenses {
            expenseNode := xmlObj.createElement("Expense")
            for key, value in expense.OwnProps() {
                node := xmlObj.createElement(key)
                node.text := value
                expenseNode.appendChild(node)
            }
            rootNode.appendChild(expenseNode)
        }
        
        xmlObj.appendChild(rootNode)
        FileAppend(xmlObj.xml, filePath, "UTF-8")
    }

    SaveExpensesHTML(expenses, filePath) {
        ; Implement HTML saving logic here
        ; This is a placeholder implementation
        html := "<table><tr><th>Description</th><th>Amount</th><th>Date</th><th>Category</th><th>Classification</th><th>Requires Receipt</th></tr>"
        for expense in expenses {
            html .= "<tr>"
            html .= "<td>" . expense.description . "</td>"
            html .= "<td>" . expense.amount . "</td>"
            html .= "<td>" . expense.date . "</td>"
            html .= "<td>" . expense.category . "</td>"
            html .= "<td>" . expense.classification . "</td>"
            html .= "<td>" . (expense.requiresReceipt ? "Yes" : "No") . "</td>"
            html .= "</tr>"
        }
        html .= "</table>"
        FileAppend(html, filePath, "UTF-8")
    }

    LoadExpensesINI(filePath) {
        expenses := []
        Loop {
            section := "Expense" . A_Index
            if (!IniRead(filePath, section).HasAny()) {
                break
            }
            expense := {
                description: IniRead(filePath, section, "Description"),
                amount: IniRead(filePath, section, "Amount"),
                date: IniRead(filePath, section, "Date"),
                category: IniRead(filePath, section, "Category"),
                classification: IniRead(filePath, section, "Classification"),
                requiresReceipt: IniRead(filePath, section, "RequiresReceipt")
            }
            expenses.Push(expense)
        }
        return expenses
    }

    LoadExpensesXML(filePath) {
        xmlObj := ComObject("MSXML2.DOMDocument.6.0")
        xmlObj.async := false
        xmlObj.load(filePath)
        
        expenses := []
        expenseNodes := xmlObj.selectNodes("//Expense")
        for expenseNode in expenseNodes {
            expense := {}
            for childNode in expenseNode.childNodes {
                expense[childNode.nodeName] := childNode.text
            }
            expenses.Push(expense)
        }
        return expenses
    }

    LoadExpensesHTML(filePath) {
        ; Implement HTML loading logic here
        ; This is a placeholder implementation and might not work correctly
        ; as parsing HTML can be complex without proper HTML parsing libraries
        html := FileRead(filePath)
        expenses := []
        Loop Parse, html, "<tr>"
        {
            if (A_Index == 1) {
                continue  ; Skip header
            }
            fields := StrSplit(A_LoopField, "</td><td>")
            if (fields.Length >= 6) {
                expense := {
                    description: RegExReplace(fields[1], "<td>"),
                    amount: fields[2],
                    date: fields[3],
                    category: fields[4],
                    classification: fields[5],
                    requiresReceipt: (InStr(fields[6], "Yes") ? true : false)
                }
                expenses.Push(expense)
            }
        }
        return expenses
    }
}

; Button Creator Class
class ButtonCreator {
    __New(guiobj, containerX, containerY, containerW, containerH) {
        this.gui := guiobj
        this.containerX := containerX
        this.containerY := containerY
        this.containerW := containerW
        this.containerH := containerH
        this.buttons := Map()
    }

	Create(btnNames, handler, type := "Map", options := {}) {
        btnWidth := this.gui.SetButtonWidth(btnNames)
        xPos := this.containerX + 10
        yPos := this.containerY + 20

        if (options.HasProp("dynamicPosition") && options.dynamicPosition) {
            return this.CreateDynamicButtons(btnNames, handler, btnWidth, options.referenceControl)
        }

        switch type {
            case "Map":
                this.buttons := Map()
                for btnName in btnNames {
                    this.buttons[btnName] := this.AddButton(xPos, yPos, btnWidth, btnName, handler)
                    this.buttons[btnName].GetPos(&btnX, &btnY, &btnW, &btnH)
                    xPos := btnX + btnW + 10
                }
            case "Array":
                this.buttons := []
                for btnName in btnNames {
                    this.buttons.Push(this.AddButton(xPos, yPos, btnWidth, btnName, handler))
                    this.buttons[-1].GetPos(&btnX, &btnY, &btnW, &btnH)
                    xPos := btnX + btnW + 10
                }
            case "Object":
                this.buttons := {}
                for btnName in btnNames {
                    this.buttons.%btnName% := this.AddButton(xPos, yPos, btnWidth, btnName, handler)
                    this.buttons.%btnName%.GetPos(&btnX, &btnY, &btnW, &btnH)
                    xPos := btnX + btnW + 10
                }
        }

        return this.buttons
    }

    AddButton(x, y, w, name, handler) {
        btn := this.gui.AddButton("x" x " y" y " w" w, name)
        btn.OnEvent("Click", handler.Bind(this.gui, name))
        return btn
    }

    GetLastButtonPos() {
        if (Type(this.buttons) = "Map" || Type(this.buttons) = "Object") {
            for _, btn in this.buttons {
                lastBtn := btn
            }
        } else if (Type(this.buttons) = "Array") {
            lastBtn := this.buttons[-1]
        }
        
        lastBtn.GetPos(&lastX, &lastY, &lastW, &lastH)
        return {x: lastX, y: lastY, w: lastW, h: lastH}
    }


    CreateDynamicButtons(btnNames, handler, btnWidth, referenceControl) {
        referenceControl.GetPos(&refX, &refY, &refW, &refH)
        
        selectX := refX + (refW / 2) - (btnWidth / 2)
        previousX := selectX - btnWidth - 10  ; 10 pixels gap
        nextX := selectX + btnWidth + 10  ; 10 pixels gap
        yPos := refY + refH + 10

        buttons := Map()
        buttons["Previous"] := this.AddButton(previousX, yPos, btnWidth, "Previous", handler)
        buttons["Select"] := this.AddButton(selectX, yPos, btnWidth, "Select", handler)
        buttons["Next"] := this.AddButton(nextX, yPos, btnWidth, "Next", handler)

        return buttons
    }
}

/**
 *  @example Categories and Classifications
 */

class Categories {
    static categoriesList := [
		'Travel',
		'Meals / Entertainment',
		'Telecom', 'Office Expenses',
		'Company Car',
		; 'Professional Memberships / Development',
		'Professional Development',
		'Fees / Advances',
		'Misc',
		'Engineer / Equipment'
	]

    
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
		if (IsObject(category)) {
			return category  ; Return the object if it's already an array of classifications
		}
		
		categoryName := StrReplace(category, ' / ', '')
		categoryName := StrReplace(categoryName, ' ', '')
		if (this.HasProp(categoryName)) {
			return this.%categoryName%.GetClassifications()
		}
		return []  ; Return an empty array if the category is not found
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
        return [this.Fuel, this.Mileage, this.Wash, this.Other, this.HomeChargerInstallation, this.HomeChargingElectricityCosts, this.EVPublicChargingStation]
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

