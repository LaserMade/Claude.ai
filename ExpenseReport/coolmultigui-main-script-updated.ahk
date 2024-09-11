#Requires AutoHotkey v2.0

; Include necessary libraries and classes
#Include <Directives\__AE.v2>

class CoolMultiGUI {
    static instances := Map()
    dataManager := DataManager()
    errorLogger := ErrorLogger.GetInstance("CoolMultiGUI")

    __New() {
        this.errorLogger.Log("CoolMultiGUI constructor called")
        this.InitializeDataFile()
        this.CreateMainGUI()
        this.SetupTrayMenu()
    }

    InitializeDataFile() {
        this.errorLogger.Log("Initializing data file")
        if (!FileExist("CoolMultiGUIData.json")) {
            this.dataManager.SaveData({instances: []})
            this.errorLogger.Log("Created new data file")
        } else {
            this.errorLogger.Log("Data file already exists")
        }
    }

    CreateMainGUI() {
        this.errorLogger.Log("Creating main GUI")
        this.mainGui := Gui("+Resize", "CoolMultiGUI Manager")
        this.mainGui.DarkMode()
        this.mainGui.MakeFontNicer(12)
        
        this.mainGui.Add("Button", "w200 h30", "Create New Instance").OnEvent("Click", (*) => this.CreateInstance())
        this.listView := this.mainGui.Add("ListView", "r10 w400", ["Instance Name", "Status"])
        this.mainGui.Add("Button", "w200 h30", "Refresh Instances").OnEvent("Click", (*) => this.RefreshInstanceList())
        
        this.mainGui.OnEvent("Close", (*) => ExitApp())
        
        this.errorLogger.Log("Main GUI created")
        this.mainGui.Show()
        this.errorLogger.Log("Main GUI shown")
    }

    SetupTrayMenu() {
        this.errorLogger.Log("Setting up tray menu")
        A_TrayMenu.Add("Show Main GUI", (*) => this.ShowMainGUI())
        A_TrayMenu.Add("Create New Instance", (*) => this.CreateInstance())
        this.errorLogger.AddTrayMenuItem()
    }

    ShowMainGUI() {
        this.errorLogger.Log("Show Main GUI called")
        this.mainGui.Show()
    }

    CreateInstance() {
        this.errorLogger.Log("Creating new instance")
        inputGui := Gui("+AlwaysOnTop", "Create New Instance")
        inputGui.Add("Text", "x10 y10", "Enter instance name:")
        inputEdit := inputGui.Add("Edit", "x10 y30 w200 vInstanceName")
        inputGui.Add("Button", "x10 y60 w100 Default", "OK").OnEvent("Click", (*) => inputGui.Submit())
        inputGui.Add("Button", "x120 y60 w100", "Cancel").OnEvent("Click", (*) => inputGui.Destroy())
        
        result := inputGui.Show()
        
        if (result != "Cancel") {
            instanceName := inputGui["InstanceName"]
            if (instanceName != "") {
                try {
                    newInstance := this.CreateGUIInstance(instanceName)
                    CoolMultiGUI.instances[instanceName] := newInstance
                    this.dataManager.SaveData({instances: CoolMultiGUI.instances})
                    this.RefreshInstanceList()
                    this.errorLogger.Log("Created new instance: " . instanceName)
                } catch as err {
                    this.errorLogger.Log("Error creating instance: " . err.Message)
                    Info("Failed to create instance: " . err.Message, 3000)
                }
            }
        }
    }

    CreateGUIInstance(name) {
        newGui := Gui("+Resize", "Instance: " . name)
        newGui.DarkMode()
        newGui.MakeFontNicer(12)
        newGui.Add("Text", "x10 y10", "This is instance: " . name)
        newGui.Add("Edit", "x10 y30 w200 h100 vNotepad")
        newGui.Add("Button", "x10 y140 w100", "Save").OnEvent("Click", (*) => this.SaveInstanceData(name, newGui))
        newGui.Add("Button", "x120 y140 w100", "Load").OnEvent("Click", (*) => this.LoadInstanceData(name, newGui))
        newGui.Show()
        return newGui
    }

    SaveInstanceData(name, gui) {
        notepadContent := gui["Notepad"].Value
        this.dataManager.StoreRevision(name, {notepad: notepadContent})
        this.errorLogger.Log("Data saved for instance: " . name)
        Info("Data saved for " . name, 2000)
    }

    LoadInstanceData(name, gui) {
        revisions := this.dataManager.GetRevisions(name)
        if (revisions.Length > 0) {
            latestRevision := revisions[-1]
            gui["Notepad"].Value := latestRevision.data.notepad
            this.errorLogger.Log("Data loaded for instance: " . name)
            Info("Data loaded for " . name, 2000)
        } else {
            this.errorLogger.Log("No data found for instance: " . name)
            Info("No data found for " . name, 2000)
        }
    }

    RefreshInstanceList() {
        this.errorLogger.Log("Refreshing instance list")
        this.listView.Delete()
        for instanceName, instance in CoolMultiGUI.instances {
            status := WinExist("ahk_id " . instance.Hwnd) ? "Running" : "Hidden"
            this.listView.Add(, instanceName, status)
        }
        this.listView.ModifyCol()  ; Auto-size columns
    }
}

; Create and run the main application
app := CoolMultiGUI()

; Keep the script running
OnMessage(0x404, (*) => 1)
return
