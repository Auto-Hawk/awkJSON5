#Warn Unreachable, Off
#Include Includes.ahk


valid := [
{
  r: true, Nr: 1, desc_EN: "ending back-slash and multiline",
  case:
(
"
S1: `"(S1)ending back-slash\\`",
M1: `"(M1)multiline\\\`r`nNew Line`",
M2: `"(M2)multiline\\\`nNew Line`",
M3: `"(M3)multiline\\\`rNew Line`",
"
)},{
  r: true, Nr: 2, desc_EN: "single/double quoted String",
  case:
(
"
`"double quoted key`": `"double quoted String`",
 'single quoted key': 'single quoted String',
 unquotedKey: 'single quoted String',
"
)},{
  r: true, Nr: 3, desc_EN: "Multiline String and Key(quoted only)",
  case:
(
"
String: '😎 hello multiline\
world \
everybody 1',
`"Stri\
ng`": '😎 hello multiline\
world \
everybody 1',

"
)},{
  r: true, Nr: 4, desc_EN: "Pathes",
  case:
(
"
  PathString1: 'C:\Program Files\AutoHotkey\UX\Templates',
  PathString2: 'C:\\Program Files\\AutoHotkey\\UX\\Templates\\'
"
)}
]


invalid := [
{
  r: false, Nr: 4, desc_EN: "no matching delimiter(double quoted) in key",
  case:
(
"
`"Key: `"no matching delimiter(double quoted) in key`",
"
)},{
  r: false, Nr: 5, desc_EN: "no matching delimiter(single quoted) in string",
  case:
(
"
'key': 'no matching delimiter(single quoted) in string,
"
)},{
  r: false, Nr: 6, desc_EN: "Multiline in unescaped key",
  case:
(
"
    Stri\
ng: '😎 hello multiline\
world \
everybody 2',
"
)},{
  r: false, Nr: 7, desc_EN: "Unterminated string literal",
  case:
(
"
  PathString1: 'C:\\,
  PathString2: 'C:\Program Files\AutoHotkey\UX\Templates',
"
)}
]

values := []
values.Push(valid*)
values.Push(invalid*)

/*
values := [{
  r: true, Nr: 4, desc_EN: "Pathes",
  case:
(
"
  PathString1: 'C:\\,
  PathString2: 'C:\Program Files\AutoHotkey\UX\Templates',
  PathString3: 'C:\\Program Files\\AutoHotkey\\UX\\Templates\\'
"
)}]
*/


lValidCount := 0
lInvalidCount := 0
for eVal in values {

  JSON5Text :=
(
"{" eVal.case "}"
)

try {
				obj:= awkJSON5Dev.Parse(&JSON5Text,true)

				if (eval.r) {
          lMsg := "✔ " eVal.Nr " VALID " eval.desc_EN
          lValidCount++
        }
        else
          lMsg := "✔(✖) " eVal.Nr " INVALID `n" JSON5Text

		} catch Error as e {

			  if (!eval.r) {
         lMsg := "✖ " eVal.Nr " INVALID " eval.desc_EN
         lInvalidCount++
        } else {
         lMsg := "✖(✔) " eVal.Nr " INVALID " e.Message "->`n" JSON5Text
        }
		}
		OutputDebugLine lMsg

}

lMsg := "`nSummary`n"
lMsg .= ((valid.Length == lValidCount) ? "✔" : "✖") " Total Valids " valid.Length ", Valids=" lValidCount "`n"
lMsg .= ((invalid.Length == lInvalidCount) ? "✔" : "✖") " Total Invalids " invalid.Length ", Invalids=" lInvalidCount
OutputDebugLine lMsg