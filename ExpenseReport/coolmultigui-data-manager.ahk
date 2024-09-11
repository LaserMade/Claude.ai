#Requires AutoHotkey v2.0

class DataManager {
    static dataFile := "CoolMultiGUIData.json"

    SaveData(data) {
        jsonString := JSON.Stringify(data)
        try {
            FileDelete(this.dataFile)
            FileAppend(jsonString, this.dataFile, "UTF-8")
        } catch as err {
            MsgBox("Error saving data: " . err.Message)
        }
    }

    LoadData() {
        try {
            if FileExist(this.dataFile) {
                fileContent := FileRead(this.dataFile, "UTF-8")
                return JSON.Parse(fileContent)
            }
        } catch as err {
            MsgBox("Error loading data: " . err.Message)
        }
        return {instances: []}
    }

    StoreRevision(instanceName, revisionData) {
        data := this.LoadData()
        if !data.HasOwnProp("revisions")
            data.revisions := Map()
        
        if !data.revisions.Has(instanceName)
            data.revisions[instanceName] := []
        
        data.revisions[instanceName].Push({
            timestamp: A_Now,
            data: revisionData
        })
        
        this.SaveData(data)
    }

    GetRevisions(instanceName) {
        data := this.LoadData()
        if data.HasOwnProp("revisions") && data.revisions.Has(instanceName)
            return data.revisions[instanceName]
        return []
    }

    DeleteInstance(instanceName) {
        data := this.LoadData()
        for index, instance in data.instances {
            if instance.name == instanceName {
                data.instances.RemoveAt(index)
                break
            }
        }
        this.SaveData(data)
    }
}

; Helper function to check if JSON library is available
if !IsObject(JSON) {
    #Include <JSON>
}
