#Warn Unreachable, Off
#Include Includes.ahk

; === VALID KEYS ===
Valid := [
  { r: true, Nr: 1, case: "_abc123", desc_DE: "Unterstrich am Anfang, Buchstaben und Zahlen", desc_EN: "Underscore at start, letters and digits" },
  { r: true, Nr: 2, case: "$dollarVar", desc_DE: "Dollar am Anfang, Buchstaben", desc_EN: "Dollar at start, letters" },
  { r: true, Nr: 3, case: "Abc", desc_DE: "Erstes Zeichen Buchstabe ASCII", desc_EN: "First character ASCII letter" },
  { r: true, Nr: 4, case: "Æther", desc_DE: "Erstes Zeichen Buchstabe außerhalb ASCII", desc_EN: "First character letter outside ASCII" },
  { r: true, Nr: 5, case: "var123", desc_DE: "Folgezeichen Ziffern", desc_EN: "Subsequent digits" },
  { r: true, Nr: 6, case: "π42", desc_DE: "Buchstabe + Ziffern", desc_EN: "Letter + digits" },
  { r: true, Nr: 7, case: "Ⅻ_key", desc_DE: "Letter Number (römische Ziffer) + Unterstrich", desc_EN: "Letter Number (Roman numeral) + underscore" },
  { r: true, Nr: 8, case: "ⅠⅡⅢvar", desc_DE: "Mehrere Letter Numbers", desc_EN: "Multiple letter numbers" },
  { r: true, Nr: 9, case: "a\u093e\u0940b", desc_DE: "Combining Marks", desc_EN: "Combining marks" },
  { r: true, Nr: 10, case: "x\u0E31y", desc_DE: "Combining Mark Thai", desc_EN: "Thai combining mark" },
  { r: true, Nr: 11, case: "var_name", desc_DE: "Connector Punctuation (Unterstrich)", desc_EN: "Connector punctuation (underscore)" },
  { r: true, Nr: 12, case: "key_part_2", desc_DE: "Unterstrich in Key", desc_EN: "Underscore in key" },
  { r: true, Nr: 13, case: "price$", desc_DE: "Dollar am Ende", desc_EN: "Dollar at the end" },
  { r: true, Nr: 14, case: "total$sum", desc_DE: "Dollar in der Mitte", desc_EN: "Dollar in the middle" },
  { r: true, Nr: 15, case: "a\u200Cb", desc_DE: "ZWNJ (Zero-Width Non-Joiner)", desc_EN: "Zero-Width Non-Joiner" },
  { r: true, Nr: 16, case: "c\u200Dd", desc_DE: "ZWJ (Zero-Width Joiner)", desc_EN: "Zero-Width Joiner" },
  { r: true, Nr: 17, case: "名字", desc_DE: "Chinesisches Zeichen", desc_EN: "Chinese character" },
  { r: true, Nr: 18, case: "年龄", desc_DE: "Chinesisches Zeichen", desc_EN: "Chinese character" },
  { r: true, Nr: 19, case: "अक्षर", desc_DE: "Hindi Zeichen", desc_EN: "Hindi characters" },
  { r: true, Nr: 20, case: "संख्या", desc_DE: "Hindi Zeichen", desc_EN: "Hindi characters" },
  { r: true, Nr: 21, case: "שֵם", desc_DE: "Hebräische Zeichen", desc_EN: "Hebrew letters" },
  { r: true, Nr: 22, case: "מספר", desc_DE: "Hebräische Zeichen", desc_EN: "Hebrew letters" },
  { r: true, Nr: 23, case: "اسم", desc_DE: "Arabische Zeichen", desc_EN: "Arabic letters" },
  { r: true, Nr: 24, case: "عدد", desc_DE: "Arabische Zeichen", desc_EN: "Arabic letters" },
  { r: true, Nr: 25, case: "πράξη", desc_DE: "Griechische Zeichen", desc_EN: "Greek letters" },
  { r: true, Nr: 26, case: "λόγος", desc_DE: "Griechische Zeichen", desc_EN: "Greek letters" },
  { r: true, Nr: 27, case: "キーネーム", desc_DE: "Japanische Katakana", desc_EN: "Japanese Katakana" },
  { r: true, Nr: 28, case: "ひらがな", desc_DE: "Japanische Hiragana", desc_EN: "Japanese Hiragana" },
  { r: true, Nr: 29, case: "한글", desc_DE: "Koreanische Hangul", desc_EN: "Korean Hangul" },
  { r: true, Nr: 30, case: "숫자", desc_DE: "Koreanische Hangul", desc_EN: "Korean Hangul" },
  { r: true, Nr: 31, case: "a०", desc_DE: "Devanagari-Ziffer als Folgezeichen", desc_EN: "Devanagari digit as subsequent character" },
  { r: true, Nr: 32, case: "_٣var", desc_DE: "Arabische-Indic-Ziffer als Folgezeichen", desc_EN: "Arabic-Indic digit as subsequent character" },
  { r: true, Nr: 33, case: "key๗", desc_DE: "Thai-Ziffer als Folgezeichen", desc_EN: "Thai digit as subsequent character" }
]


; === INVALID KEYS ===
Invalid := [
  { r: false, Nr: 34, case: "1abc", desc_DE: "Zahl am Anfang", desc_EN: "Digit at the start" },
  { r: false, Nr: 35, case: "-key", desc_DE: "Bindestrich am Anfang", desc_EN: "Hyphen at the start" },
  { r: false, Nr: 36, case: "abc-xyz", desc_DE: "Ungültiges Folgezeichen Bindestrich", desc_EN: "Invalid subsequent character: hyphen" },
  { r: false, Nr: 37, case: "name@", desc_DE: "Ungültiges Folgezeichen @", desc_EN: "Invalid subsequent character: @" },
  { r: false, Nr: 38, case: "var name", desc_DE: "Space im Key", desc_EN: "Space in key" },
  { r: false, Nr: 39, case: "hello world", desc_DE: "Space in der Mitte", desc_EN: "Space in the middle" },
  { r: false, Nr: 40, case: "x²y", desc_DE: "Ungültige Unicode-Zahl \\p{No} superscript 2", desc_EN: "Invalid Unicode number \\p{No} superscript 2" },
  { r: false, Nr: 41, case: "y¾z", desc_DE: "Ungültige Unicode-Zahl \\p{No} vulgar fraction", desc_EN: "Invalid Unicode number \\p{No} vulgar fraction" },
  { r: false, Nr: 42, case: "key!", desc_DE: "Sonderzeichen !", desc_EN: "Special character !" },
  { r: false, Nr: 43, case: "data#", desc_DE: "Sonderzeichen #", desc_EN: "Special character #" },
  { r: false, Nr: 44, case: "1-invalid", desc_DE: "Zahl + Bindestrich", desc_EN: "Digit + hyphen" },
  { r: false, Nr: 45, case: "key:part", desc_DE: "Doppelpunkt im Key", desc_EN: "Colon in key" },
  { r: false, Nr: 46, case: "section:2", desc_DE: "Doppelpunkt im Key", desc_EN: "Colon in key" },
  { r: false, Nr: 47, case: "file.name", desc_DE: "Punkt im Key", desc_EN: "Dot in key" },
  { r: false, Nr: 48, case: "version.1", desc_DE: "Punkt im Key", desc_EN: "Dot in key" },
  { r: false, Nr: 49, case: "data,value", desc_DE: "Komma im Key", desc_EN: "Comma in key" },
  { r: false, Nr: 50, case: "list,items", desc_DE: "Komma im Key", desc_EN: "Comma in key" },
  { r: false, Nr: 51, case: "end;", desc_DE: "Semikolon im Key", desc_EN: "Semicolon in key" },
  { r: false, Nr: 52, case: "stmt;", desc_DE: "Semikolon im Key", desc_EN: "Semicolon in key" },
  { r: false, Nr: 53, case: "alert!", desc_DE: "Ausrufezeichen im Key", desc_EN: "Exclamation mark in key" },
  { r: false, Nr: 54, case: "warn!", desc_DE: "Ausrufezeichen im Key", desc_EN: "Exclamation mark in key" },
  { r: false, Nr: 55, case: "hash#", desc_DE: "Raute im Key", desc_EN: "Hash/pound sign in key" },
  { r: false, Nr: 56, case: "tag#", desc_DE: "Raute im Key", desc_EN: "Hash/pound sign in key" },
  { r: false, Nr: 57, case: "question?", desc_DE: "Fragezeichen im Key", desc_EN: "Question mark in key" },
  { r: false, Nr: 58, case: "query?", desc_DE: "Fragezeichen im Key", desc_EN: "Question mark in key" },
  { r: false, Nr: 59, case: "star*", desc_DE: "Stern im Key", desc_EN: "Asterisk/star in key" },
  { r: false, Nr: 60, case: "multiply*", desc_DE: "Stern im Key", desc_EN: "Asterisk/star in key" },
  { r: false, Nr: 61, case: "path/to", desc_DE: "Schrägstrich im Key", desc_EN: "Forward slash in key" },
  { r: false, Nr: 62, case: "url/path", desc_DE: "Schrägstrich im Key", desc_EN: "Forward slash in key" },
  { r: false, Nr: 63, case: "folder\\name", desc_DE: "Backslash im Key", desc_EN: "Backslash in key" },
  { r: false, Nr: 64, case: "c\\drive", desc_DE: "Backslash im Key", desc_EN: "Backslash in key" },
  { r: false, Nr: 65, case: "०abc", desc_DE: "Devanagari-Ziffer am Anfang", desc_EN: "Devanagari digit at first character" },
  { r: false, Nr: 66, case: "٣xyz", desc_DE: "Arabische-Indic-Ziffer am Anfang", desc_EN: "Arabic-Indic digit at first character" }
]




values := []
values.Push(valid*)
values.Push(invalid*)

lValidCount := 0
lInvalidCount := 0

for eVal in values {


;if ( eVal.Nr != 45  )
; continue

		JSON5Text :=
		(
"{ " eVal.case ": `"" eVal.desc_EN "`" }"
		)

		try {
				obj:= awkJSON5Dev.Parse(&JSON5Text,true)

        if (eval.r) {
          lMsg := "✔ " eVal.Nr " VALID " JSON5Text
          lValidCount++
        }
        else
          lMsg := "✔(✖) " eVal.Nr " INVALID " JSON5Text

		} catch Error as e {

        if (!eval.r) {
         lMsg := "✖ " eVal.Nr " INVALID " JSON5Text " -> " e.Message
         lInvalidCount++
        } else {
         lMsg := "✖(✔) " eVal.Nr " VALID " JSON5Text " -> " e.Message
        }
		}

    OutputDebugLine lMsg


}

lMsg := "`nSummary`n"
lMsg .= ((valid.Length == lValidCount) ? "✔" : "✖") " Total Valids " valid.Length ", Valids=" lValidCount "`n"
lMsg .= ((invalid.Length == lInvalidCount) ? "✔" : "✖") " Total Invalids " invalid.Length ", Invalids=" lInvalidCount
OutputDebugLine lMsg
