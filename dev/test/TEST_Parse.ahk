#Requires AutoHotkey v2.0
#Include Includes.ahk

;JSONText := FileRead('awkJSON5Test_FULL.json5')
JSONText := FileRead('awkJSON5Test.json5')


obj := awkJSON5Dev.Parse(&JSONText, false)
OutputDebugLine obj



/*
MyMap := awkJSON5Dev.Parse(&JSONText, false)
for a in MyMap["cases"] {
  OutputDebugLine a["case"] " " a["desc_DE"]
}
*/
