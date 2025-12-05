; This work is released into the public domain under CC0 1.0 Universal.
#Requires AutoHotkey v2.0

/** @description Repeats a string n times
 * @param {(String)} fStr The string to repeat
 * @param {(Integer)} fCount Number of Repeats
 * @returns the result the new string
 */
awk_StrRepeat(fStr, fCount) {
    lResult := ""
    Loop fCount
        lResult .= fStr
    return lResult
}