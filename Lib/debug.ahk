; This work is released into the public domain under CC0 1.0 Universal.
#Requires AutoHotkey v2.0
#Include Includes.ahk
#Include thirdparty\peep.ahk

/** @description Send the string to the debugger (if available) to display it,<br>
 * similar to OutputDebug.<br>
 * New features:
 * - a new line is added to end of the string
 * - AHK-objects or AHK-maps are outputed stringified
 * @param {(fIndent)} [fIndent=1] Defines the indent used to indent each level of the JSON tree.<br>
 * - Number indicates the number of spaces to use for each indent.<br>
 * - String indiciates the characters to use, i.e. '`t' would be 1 tab for each indent level.<br>
 * - If omitted or an empty string is passed in, the JSON string will export as a single line of text.
 */
OutputDebugLine(fData, fIndent := 1) {

    if IsObject(fData)
        OutputDebug awkJSON5.Stringify(fData, fIndent)
    else
        OutputDebug fData

    OutputDebug "`r`n"
}