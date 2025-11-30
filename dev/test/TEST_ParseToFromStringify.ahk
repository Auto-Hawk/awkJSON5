#Requires AutoHotkey v2.0
#Include Includes.ahk

JSONText := FileRead('awkJSON5Test_FULL.json5', "UTF-8")

Loop 2 {

  if ( A_Index == 1 ) {
    obj := awkJSON5Dev.Parse(&JSONText, true) ;object
    lType := "Object"
  } else {
    obj := awkJSON5Dev.Parse(&JSONText, false)  ;map
    lType := "Map"
  }

  JSONText2 := awkJSON5Dev.Stringify(obj, 2)
  obj := awkJSON5Dev.Parse(&JSONText2, true)
  JSONText3 := awkJSON5Dev.Stringify(obj, 2)
  ;awk_FileWrite('awkJSON5Test_FULL_TEST.json5',&JSONText3)

  if( JSONText2 == JSONText3 )
  OutputDebugLine "✔ [" lType "] Parse to/from Stringify is Valid"
  else
  OutputDebugLine "✖ [" lType "] Parse to/from Stringify is NOT Valid"

}


