#Requires AutoHotkey v2.0

/** @description Returns the system's default web browser executable.
  */
awk_GetDefaultBrowser() {

        try {
            ; Hole den ProgID (z. B. ChromeHTML, FirefoxURL, ...)
            ProgId := RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\Shell\Associations\UrlAssociations\http\UserChoice", "ProgId")

            ; Hole den Pfad aus dem Classes-Zweig
            Cmd := RegRead("HKEY_CLASSES_ROOT\" ProgId "\shell\open\command", "")

            ; Extrahiere nur den Pfad zur .exe (Command-String kann Parameter enthalten)
            if RegExMatch(Cmd, '"([^"]+\.exe)"', &m) {
                return m[1]  ; Nur der Pfad zur EXE
            } else if RegExMatch(Cmd, '([^\s]+\.exe)', &m) {
                return m[1]  ; Fallback, wenn keine Anführungszeichen verwendet wurden
            } else {
                throw Error("Could not extract path.")

            }
        } catch as e {
            throw
        }
}

/** @description Converts characters or surrogate pairs in a URL into their corresponding escape sequences.
  * @param {(String)} fURL - The URL to convert
  * @param {(Integer)} [fFlags=0x000C3000] - <br>
  * 0x000C3000 = 0x00002000 (SEGMENT_ONLY) | 0x00001000 (ESCAPE_PERCENT) | 0x00080000 (ASCII_URI_COMPONENT) | 0x00040000 (AS_UTF8)
  * @returns {(String)} The escaped URL
  * @see<br>
  * https://learn.microsoft.com/en-us/windows/win32/api/shlwapi/nf-shlwapi-urlescapew
  */
awk_UrlEscapeW(fURL, fFlags := 0x000C3000) {
    pcchEscaped := 4096 ; Buffer size, after calling it contains the number of characters in the pszEscaped buffer
    pszEscaped := ""
    Result := ""

    Loop {
        VarSetStrCapacity(&pszEscaped, pcchEscaped)
        Result := DllCall("Shlwapi.dll\UrlEscapeW", "Str", fURL, "Str", &pszEscaped, "UIntP", &pcchEscaped, "UInt", fFlags, "UInt")
    } Until Result != 0x80004003

    /*
     Returns S_OK(0x00) if successful.
     If the pcchEscaped buffer was too small to contain the result,
     E_POINTER(0x80004003) is returned, and the value pointed to by pcchEscaped is set to the required buffer size.
     Otherwise, a standard error value is returned.
    */

    Return pszEscaped
}