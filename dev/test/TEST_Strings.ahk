#Warn Unreachable, Off
#Include Includes.ahk


values := [
  "`"String`": `"some Text 1`"",
  "'String': 'some Text 2'",
  "String: 'some Text 3'",
(
"
String: '😎 hello \
world \
everybody 4'
"
),
(
"
`"Stri\
ng`": `"😀 hello \
world \
everybody 5`"
"
),
  "String: some Text 6",
  "String': 'some Text 7'",
  "String`": 'some Text 8'",
  "`"String`": 'some Text 9"

]

for eVal in values {

		JSON5Text :=
(
"{
  " eVal "
}"
)

		try {
				obj:= awkJSON5Dev.Parse(&JSON5Text,true)
				OutputDebugLine("✔ VALID " JSON5Text " -> value: " obj.String )
		} catch Error as e {
				OutputDebugLine("✖ INVALID " JSON5Text " -> " e.Message)
		}

}