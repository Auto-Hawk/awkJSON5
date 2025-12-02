#Requires AutoHotkey v2.0

awk_StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}