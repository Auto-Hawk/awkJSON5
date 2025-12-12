#Requires AutoHotkey v2.0
#Include Includes.ahk

; ------------------------------------------------5-
; Testfälle definieren
; -------------------------------------------------

baseCases := [
    "'`"\`b`f`n`r`t`v",
    "<" Chr(28) " - " Chr(30) ">"
]

testCases2 := [
    "Line1`nLine2",
    "Hello World",
    "`"Hello World`"",
    '`'Hello World`'',
    "Tab`tSeparated",
    "Quote: `"`"",
    "Backslash: \\",
    "Slash / and \/ escaped",
    "Unicode: äöü ÄÖÜ ß",
    "Mixed: `t`"Line`nWith\\Backslash\u2764",
    "",                                      ; leerer String
    "`"",                                    ; nur ein Anführungszeichen
    "\\",                                    ; nur ein Backslash
    "\/\/",                                  ; nur Slashes
    "Control: `n`t`r`b`f",                            ; nur Steuerzeichen
    "Emoji: 😀😎🚀",                          ; Emojis
    "Non-ASCII: 漢字, кириллица, عربى",      ; andere Unicode-Zeichen
    "Long text: " awk_StrRepeat("ABCD1234", 50), ; langer String
    "Mixed escapes: `"`\`n`t`r\u2764",       ; Kombination aller Escapes
    "Nested JSON: {`"`"key`"`":`"`"value`"`"}",      ; JSON-ähnliche Struktur
    "Quotes and backslashes: `"\\\`"`"",      ; abwechselnd Quotes und Backslashes
    "Multiple lines:`nLine2`nLine3",         ; mehrere Zeilen
    "Tabs and spaces: `t`tSpace`tEnd",      ; gemischte Tabs und Leerzeichen
    "Forward slash: / and backslash: \\",    ; beide Slashes kombiniert
    "Special chars: ~!@#$%^&*()_+-={}|[]\\:;'<>,.?/", ; Sonderzeichen
    "JSON string: {`"array`":[1,2,3],`"obj`":{`"a`":true}}", ; komplexe JSON-Struktur
    "Escape sequences: `b`f`n`r`t\\\`"`""     ; alle Escapes in Kombination
]

; -------------------------------------------------
; Testfunktionen
; -------------------------------------------------

TestEscapeAndUnescape() {
    global lValidCount := 0
    ;For index, str in baseCases {
    for index, str in testCases2 {
        escaped := awkJSON5Dev.EscapeStr(str, fQuote := '"')
        unescaped := awkJSON5Dev.UnescapeStr(escaped)
        isEqual := ('"' str '"' = unescaped) ? "✔" : "✖"
        if ( isEqual )
         lValidCount++

        OutputDebugLine("Test " index ":")
        OutputDebugLine("Original   : " '"' str '"')
        OutputDebugLine("Unescaped  : " unescaped)
        OutputDebugLine("Escaped    : " escaped)
        OutputDebugLine("Result     : " isEqual)
        OutputDebugLine("───────────────────────────────────────────")
    }

}

; -------------------------------------------------
; Script ausführen
; -------------------------------------------------
Perf := awkPerfCounter(1000)
Perf.Reset()
TestEscapeAndUnescape()
lTime := Perf.Measure()
OutputDebugLine "`n━━━━ Summary ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
OutputDebugLine ((testCases2.Length == lValidCount) ? "✔" : "✖") " Total Valids " testCases2.Length ", Valids=" lValidCount
OutputDebugLine "elapsed time [ms] " lTime