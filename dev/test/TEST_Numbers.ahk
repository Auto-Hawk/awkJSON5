#Warn Unreachable, Off
#Include Includes.ahk

; === VALID NUMERIC STRINGS ===
valid := [
  { r: true, Nr: 1, case: "Infinity", desc_DE: "Unendlichkeit", desc_EN: "Infinity" },
  { r: true, Nr: 2, case: "+Infinity", desc_DE: "Positive Unendlichkeit", desc_EN: "Positive Infinity" },
  { r: true, Nr: 3, case: "-Infinity", desc_DE: "Negative Unendlichkeit", desc_EN: "Negative Infinity" },
  { r: true, Nr: 4, case: "0x0", desc_DE: "Hexadezimal 0", desc_EN: "Hexadecimal 0" },
  { r: true, Nr: 5, case: "0x1A", desc_DE: "Hexadezimal 1A", desc_EN: "Hexadecimal 1A" },
  { r: true, Nr: 6, case: "0XFF", desc_DE: "Hexadezimal FF", desc_EN: "Hexadecimal FF" },
  { r: true, Nr: 7, case: "+0x10", desc_DE: "Positives Hexadezimal 10", desc_EN: "Positive hexadecimal 10" },
  { r: true, Nr: 8, case: "-0X2F", desc_DE: "Negatives Hexadezimal 2F", desc_EN: "Negative hexadecimal 2F" },
  { r: true, Nr: 9, case: "null", desc_DE: "Nullwert", desc_EN: "Null value" },
  { r: true, Nr: 10, case: "NaN", desc_DE: "Nicht eine Zahl", desc_EN: "Not a Number" },
  { r: true, Nr: 11, case: "true", desc_DE: "Boolean true", desc_EN: "Boolean true" },
  { r: true, Nr: 12, case: "false", desc_DE: "Boolean false", desc_EN: "Boolean false" },
  { r: true, Nr: 13, case: "0", desc_DE: "Null", desc_EN: "Zero" },
  { r: true, Nr: 14, case: "1", desc_DE: "Eins", desc_EN: "One" },
  { r: true, Nr: 15, case: "-1", desc_DE: "Minus eins", desc_EN: "Minus one" },
  { r: true, Nr: 16, case: "+1", desc_DE: "Plus eins", desc_EN: "Plus one" },
  { r: true, Nr: 17, case: "123456", desc_DE: "Ganzzahl", desc_EN: "Integer" },
  { r: true, Nr: 18, case: ".5", desc_DE: "Dezimalpunkt am Anfang", desc_EN: "Decimal point at start" },
  { r: true, Nr: 19, case: "5.", desc_DE: "Dezimalpunkt am Ende", desc_EN: "Decimal point at end" },
  { r: true, Nr: 20, case: "0.5", desc_DE: "Normale Dezimalzahl", desc_EN: "Normal decimal number" },
  { r: true, Nr: 21, case: "5.0", desc_DE: "Dezimalzahl mit Null", desc_EN: "Decimal with zero" },
  { r: true, Nr: 22, case: ".0", desc_DE: "Null als Dezimalpunkt", desc_EN: "Zero as decimal" },
  { r: true, Nr: 23, case: "0.", desc_DE: "Null mit Dezimalpunkt", desc_EN: "Zero with decimal point" },
  { r: true, Nr: 24, case: "-.5", desc_DE: "Negative Dezimalzahl am Anfang", desc_EN: "Negative decimal at start" },
  { r: true, Nr: 25, case: "+5.", desc_DE: "Positive Dezimalzahl am Ende", desc_EN: "Positive decimal at end" },
  { r: true, Nr: 26, case: "-0.5", desc_DE: "Negative Dezimalzahl", desc_EN: "Negative decimal" },
  { r: true, Nr: 27, case: "5e3", desc_DE: "Exponentielle Schreibweise", desc_EN: "Exponential notation" },
  { r: true, Nr: 28, case: "5E3", desc_DE: "Exponentielle Schreibweise groß E", desc_EN: "Exponential notation with capital E" },
  { r: true, Nr: 29, case: "5.e4", desc_DE: "Exponentielle Dezimalzahl", desc_EN: "Decimal exponential" },
  { r: true, Nr: 30, case: ".5e2", desc_DE: "Exponentielle Dezimalzahl am Anfang", desc_EN: "Decimal exponential at start" },
  { r: true, Nr: 31, case: "5.0e-2", desc_DE: "Exponentielle Dezimalzahl mit negativem Exponenten", desc_EN: "Decimal exponential with negative exponent" },
  { r: true, Nr: 32, case: "-3e+4", desc_DE: "Negativer Exponent", desc_EN: "Negative exponent" },
  { r: true, Nr: 33, case: "+3E-5", desc_DE: "Positiver Exponent mit kleinem Wert", desc_EN: "Positive exponent with small value" },
  { r: true, Nr: 34, case: "-.3E10", desc_DE: "Negative Dezimalzahl mit Exponent", desc_EN: "Negative decimal with exponent" }
]

; === INVALID NUMERIC STRINGS ===
Invalid := [
  { r: false, Nr: 35, case: "xInfinity", desc_DE: "Text vor Infinity", desc_EN: "Text before Infinity" },
  { r: false, Nr: 36, case: "Infinityx", desc_DE: "Text nach Infinity", desc_EN: "Text after Infinity" },
  { r: false, Nr: 37, case: "ffInfinityd", desc_DE: "Text um Infinity", desc_EN: "Text around Infinity" },
  { r: false, Nr: 38, case: "ff-Infinityd", desc_DE: "Text und Minus um Infinity", desc_EN: "Text with minus around Infinity" },
  { r: false, Nr: 39, case: "0x", desc_DE: "Ungültiges Hexadezimal", desc_EN: "Invalid hexadecimal" },
  { r: false, Nr: 40, case: "0xG1", desc_DE: "Ungültiges Hexadezimal G", desc_EN: "Invalid hex G" },
  { r: false, Nr: 41, case: "0x1H", desc_DE: "Ungültiges Hexadezimal H", desc_EN: "Invalid hex H" },
  { r: false, Nr: 42, case: "-0x", desc_DE: "Negatives unvollständiges Hex", desc_EN: "Negative incomplete hex" },
  { r: false, Nr: 43, case: "+0x", desc_DE: "Positives unvollständiges Hex", desc_EN: "Positive incomplete hex" },
  { r: false, Nr: 44, case: "0x1.2", desc_DE: "Hex mit Punkt", desc_EN: "Hex with dot" },
  { r: false, Nr: 45, case: "0x-FF", desc_DE: "Hex mit Minus", desc_EN: "Hex with minus" },
  { r: false, Nr: 46, case: "0xx12", desc_DE: "Doppelte x in Hex", desc_EN: "Double x in hex" },
  { r: false, Nr: 47, case: "nul", desc_DE: "Unvollständiges null", desc_EN: "Incomplete null" },
  { r: false, Nr: 48, case: "Null", desc_DE: "Falsches Null", desc_EN: "Wrong null" },
  { r: false, Nr: 49, case: "NULL", desc_DE: "Falsches Null groß", desc_EN: "Wrong null upper" },
  { r: false, Nr: 50, case: "nan", desc_DE: "Falsches NaN klein", desc_EN: "Wrong NaN lower" },
  { r: false, Nr: 51, case: "True", desc_DE: "Boolean groß T", desc_EN: "Boolean capital T" },
  { r: false, Nr: 52, case: "False", desc_DE: "Boolean groß F", desc_EN: "Boolean capital F" },
  { r: false, Nr: 53, case: "tru", desc_DE: "Unvollständiges true", desc_EN: "Incomplete true" },
  { r: false, Nr: 54, case: "fals", desc_DE: "Unvollständiges false", desc_EN: "Incomplete false" },
  { r: false, Nr: 55, case: ".", desc_DE: "Nur Punkt", desc_EN: "Only dot" },
  { r: false, Nr: 56, case: "e3", desc_DE: "Exponent ohne Zahl davor", desc_EN: "Exponent without number before" },
  { r: false, Nr: 57, case: ".e3", desc_DE: "Punkt + Exponent ohne Zahl davor", desc_EN: "Dot + exponent without number before" },
  { r: false, Nr: 58, case: "+.e3", desc_DE: "Plus + Punkt + Exponent", desc_EN: "Plus + dot + exponent" },
  { r: false, Nr: 59, case: "5e", desc_DE: "Exponent ohne Wert danach", desc_EN: "Exponent without value after" },
  { r: false, Nr: 60, case: "5e-", desc_DE: "Exponent mit nur Minus", desc_EN: "Exponent with only minus" },
  { r: false, Nr: 61, case: "5e+", desc_DE: "Exponent mit nur Plus", desc_EN: "Exponent with only plus" },
  { r: false, Nr: 62, case: "5ee3", desc_DE: "Doppelte e", desc_EN: "Double e" },
  { r: false, Nr: 63, case: "5..3", desc_DE: "Zwei Punkte", desc_EN: "Two dots" },
  { r: false, Nr: 64, case: "00.1.2", desc_DE: "Mehrere Punkte", desc_EN: "Multiple dots" },
  { r: false, Nr: 65, case: "1.2.3", desc_DE: "Mehrere Punkte", desc_EN: "Multiple dots" },
  { r: false, Nr: 66, case: "5e3e4", desc_DE: "Exponent doppelt", desc_EN: "Double exponent" },
  { r: false, Nr: 67, case: "5e--3", desc_DE: "Exponent mit doppeltem Minus", desc_EN: "Exponent with double minus" },
  { r: false, Nr: 68, case: "5e++3", desc_DE: "Exponent mit doppeltem Plus", desc_EN: "Exponent with double plus" },
  { r: false, Nr: 69, case: "5.0.0", desc_DE: "Dezimal mehrfach", desc_EN: "Decimal multiple times" },
  { r: false, Nr: 70, case: "--5", desc_DE: "Doppelte Minus", desc_EN: "Double minus" },
  { r: false, Nr: 71, case: "++5", desc_DE: "Doppelte Plus", desc_EN: "Double plus" }
]


values := []
values.Push(valid*)
values.Push(invalid*)

lValidCount := 0
lInvalidCount := 0

for eVal in values {

    Loop 2 {

	if ( A_Index == 1 ) {
		JSON5Text :=
		(
"{
	`"number`" : " eVal.case "
}"
		)
	} else {
		JSON5Text :=
		(
"
/* This is a comment */
" eVal.case "
/* This is a comment */
"
		)
		}
		lType := "(" ((A_Index == 1 ) ? 'Object' : 'Number') ")"

		try {
				obj:= awkJSON5Dev.Parse(&JSON5Text,true)

				lMsg := eVal.case " -> converted: " ((obj is Object) ? obj.number : obj)
				if (eval.r) {
          lMsg := "✔ " eVal.Nr lType " VALID " lMsg
          lValidCount++
        }
        else
          lMsg := "✔(✖) " eVal.Nr lType " INVALID " lMsg

		} catch {

			  if (!eval.r) {
         lMsg := "✖ " eVal.Nr lType " INVALID(" lType ") " eVal.case
         lInvalidCount++
        } else {
         lMsg := "✖(✔) " eVal.Nr lType " INVALID(" lType ") " eVal.case
        }
		}
		OutputDebugLine lMsg
	}
}

lMsg := "`nSummary`n"
lMsg .= ((valid.Length * 2 == lValidCount) ? "✔" : "✖") " Total Valids " valid.Length * 2 ", Valids=" lValidCount "`n"
lMsg .= ((invalid.Length * 2 == lInvalidCount) ? "✔" : "✖") " Total Invalids " invalid.Length * 2 ", Invalids=" lInvalidCount
OutputDebugLine lMsg