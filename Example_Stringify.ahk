#Requires AutoHotkey v2.0
#Include lib\Includes.ahk

obj := {
   key: "value",
   n: [ 1, 2, 3 ],
   sigΣma: "the sum of all things",
   nothing: "",
   bool: true
}

JSONText := awkJSON5.Stringify(obj, 2)

OutputDebugLine JSONText