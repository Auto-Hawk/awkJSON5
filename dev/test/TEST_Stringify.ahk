#Requires AutoHotkey v2.0
#Include Includes.ahk

JSONText := FileRead('awkJSON5Test_FULL.json5')
;JSONText := FileRead('awkJSON5Test.json5')
obj := awkJSON5Dev.Parse(&JSONText, true)

JSONText := awkJSON5Dev.Stringify(obj, 2)

OutputDebugLine JSONText