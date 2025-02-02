﻿; Link:   	https://raw.githubusercontent.com/infogulch/AsyncHttp/master/testing-ash.ahk_l
; Author:	
; Date:   	
; for:     	AHK_L

/*


*/

#SingleInstance, Force
#Include AsyncHttp.ahk
#Include ..\LSON\LSON.ahk

reqs := new AsyncHttp({ OnResponseFinished: Func("Finished") })

tooltip Getting repositories list...

reqs.Request("get", "https://api.github.com/orgs/ahklib/repos")
if !reqs.Wait(10)
    ExitError("Didn't receive repos list!")

; get the response text and discard the request
; make new requests based on the returned JSON

repos := []

for i, repo in LSON(reqs.remove(1).whr.responsetext)
    if repo.name != "AutoHotkey-StdLib"
    {
        names .= ", " repo.name
        repos[repo.name, "i_details"]   := reqs.request("get", repo.url)
        repos[repo.name, "i_downloads"] := reqs.request("get", "https://api.github.com/repos/ahklib/" repo.name "/tags")
    }

tooltip % "Getting repositories details: " SubStr(names, 3)

if !reqs.wait(10)
    ExitError("Timed out getting repos!")

for name, repo in repos
{
    details   := LSON(reqs[repo.i_details].whr.ResponseText)
    downloads := LSON(reqs[repo.i_downloads].whr.ResponseText)
    info .= "`n" details.name ": " details.description 
         . "`n`tmaster branch: " details.master_branch
         . "`n`tdownloads: "
    loop % downloads.maxindex()
        info .= "`n`t`t" downloads[A_Index].name ": " downloads[A_Index].zipball_url
    info .= "`n"
}
info := substr(info, 2)

tooltip
msgbox % info

Finished( id ) {
    tooltip % "Finished request " id.idx, 10, 10, 2
}

ExitError(error = "`r") {
    if (error != "`r")
        msgbox % error
    ExitApp
}