#Requires AutoHotkey v2.0
#Include Includes.ahk
#Include thirdparty\peep.ahk

OutputDebugLine(fData, fIndent := 1) {

    if IsObject(fData)
        OutputDebug awkJSON5.Stringify(fData, fIndent)
    else
        OutputDebug fData

    OutputDebug "`r`n"
}