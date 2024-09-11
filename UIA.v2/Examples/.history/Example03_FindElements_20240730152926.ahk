;#include <UIA> ; Uncomment if you have moved UIA.ahk to your main Lib folder
; #include ..\Lib\UIA.ahk
; #Include <System\UIA>
; #Include <Tools\Info>
#Include <Directives\__AE.v2>
/*  To find elements we have a few methods available: FindElement, FindElements, WaitElement, ElementFromPath, and TreeWalkers.
    This file will demonstrate use of FindElement, FindElements, WaitElement, and using conditions.
    To see examples on ElementFromPath and TreeWalkers, see Example4.

    A "condition" is a set of conditions that the found elements must match.
    For example, we could only look for elements of certain Type, with certain Name, AutomationId etc.
*/
/*
if VerCompare(A_OSVersion, ">=10.0.22000") {
    MsgBox "This example works only in Windows 10. Press OK to Exit."
    ExitApp
}
*/
;Run "notepad.exe"
; WinWaitActive "ahk_exe Hznhorizon.exe"
; WinWaitActive("Polaris - Assignments ")
; Get the element for the Notepad window
; npEl := UIA.ElementFromHandle("ahk_exe Hznhorizon.exe")
; npEl := UIA.ElementFromHandle("Polaris - Assignments ")
title := 'Chrome River - Google Chrome'
cacheRequest := UIA.CreateCacheRequest()
cacheRequest.TreeScope := 5
cacheRequest := UIA.CreateCacheRequest(["Type", "LocalizedType", "AutomationId", "Name", "Value", "ClassName", "AcceleratorKey", "WindowCanMaximize"], ["Window"], "Subtree")
npEl := UIA.ElementFromChromium(title, cacheRequest)
try {
; A single property condition consists of an object where the key is the property name, and value is the property value:
; Infos("The first MenuItem element: " npEl.FindElement({Type:"MenuItem"}).Highlight().Dump())
element := []
element := npEl.FindAll({Type:"Group"}).Highlight().DumpAll()
; Infos("The first MenuItem element: " npEl.FindElement({Type:"Group", LocalizedType: 'group'}).Highlight().DumpAll())
for each, value in element {
    Infos(value)

}

; Everything inside curly brackets creates an "and" condition, which means the element has to match all the conditions at once:
try {
Infos("The first MenuItem element with Name 'File': " npEl.FindElement({Type:"MenuItem", Name:"File"}).Highlight().Dump())
}

; Everything inside square brackets creates an "or" condition, which means the element has to match at least one of the conditions:
; Note that we put two single conditions inside the square brackets: [{}, {}]
Infos("The first element with type Document or type Edit: " npEl.FindElement([{Type:"Document"}, {Type:"Edit"}]).Highlight().Dump())

; To find an nth element, supply either "index" or "i" property:
Infos("The third MenuItem element: " npEl.FindElement({Type:"MenuItem", index:3}).Highlight().Dump())

; By default, FindElement(s) and WaitElement looks for exact matches. To look for partial matches or by
; RegEx, then supply "matchmode" or "mm" property with the UIA.MatchMode value (same as AHK-s TitleMatchMode).
Infos("The first element with Name containing 'Bar': " npEl.FindElement({Name:"Bar", matchmode:"Substring"}).Highlight().Dump()) ; Short form for this matchmode is mm:2

; Search case-sensitivity can be changed with "casesense" or "c" property, which by default is case-sensitive:
Infos("The first element with Name 'file', case-insensitive: " npEl.FindElement({Name:"file", casesense:0}).Highlight().Dump())

; A "not" condition can be created by having the property key as "not", or supplying an "operator" or "op" property with value "not":
Infos("The first MenuItem element with Name not 'System': " npEl.FindElement({Type:"MenuItem", not:{Name:"System"}}).Highlight().Dump())

; FindElement can traverse the tree in reverse, starting the search from the end:
Infos("The first MenuItem element from the end: " npEl.FindElement({Type:"MenuItem", order:"LastToFirstOrder"}).Highlight().Dump())


; FindElements works like FindElement, but returns all the matches:
matches := ""
for el in npEl.FindElements({Type:"MenuItem"})
    matches .= el.Dump() "`n"
Infos("All elements with type MenuItem: `n`n" matches)

; WaitElement will wait for the element to exist. It works by calling FindElement until the element
; is found or the timeout is reached. This is useful when after an action (such as clicking) the
; user interface changes (such as a web page changing after clicking on a link) to wait for the 
; element to load properly. If we used instead FindElement, we might not find it because for example
; a webpage might still be loading.
; It works exactly like FindElement, only the second argument is the timeout.
Infos("Waited for the first MenuItem element (which might have been useful if Notepad were slow to load): " npEl.WaitElement({Type:"MenuItem"}).Highlight().Dump())
}

; ExitApp()
