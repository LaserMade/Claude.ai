;#include <UIA> ; Uncomment if you have moved UIA.ahk to your main Lib folder
#Requires AutoHotkey v2
#include <..\..
#Warn All, OutputDebug
DetectHiddenText(1)
DetectHiddenWindows(1)
; #5::
; {
cacheRequest := UIA.CreateCacheRequest()
; Set TreeScope to include the starting element and all descendants as well
cacheRequest.TreeScope := 5 
; Add all the necessary properties that DumpAll uses: ControlType, LocalizedControlType, AutomationId, Name, Value, ClassName, AcceleratorKey
cacheRequest.AddProperty("Type") 
cacheRequest.AddProperty("LocalizedType")
cacheRequest.AddProperty("AutomationId")
cacheRequest.AddProperty("Name")
cacheRequest.AddProperty("Value")
cacheRequest.AddProperty("ClassName")
cacheRequest.AddProperty("AcceleratorKey")

; To use cached patterns, first add the pattern
cacheRequest.AddPattern("Window") 
; cacheRequest.AddPattern("Subtree") 
; Also need to add any pattern properties we wish to use
cacheRequest.AddProperty("WindowCanMaximize") 

; This all can be done in one line as well:
; cacheRequest := UIA.CreateCacheRequest(["Type", "LocalizedType", "AutomationId", "Name", "Value", "ClassName", "AcceleratorKey", "WindowCanMaximize"], ["Window"], "Subtree")

; Run "notepad.exe"
WinWaitActive "ahk_exe Hznhorizon.exe"

; Get element and also build the cache
npEl:= UIA.ElementFromHandle("ahk_exe Hznhorizon.exe", cacheRequest)
; We now have a cached "snapshot" of the window from which we can access our desired elements faster.
OutputDebug(npEl.CachedDump() '`n')
OutputDebug(npEl.CachedWindowPattern.CachedCanMaximize '`n')
; }
ExitApp