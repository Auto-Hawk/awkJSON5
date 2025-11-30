#Warn Unreachable, Off
#Include Includes.ahk

JSON5Text :=
(
"
{
  `"case`": 1,
  `"desc_DE`": `"Extrem verschachtelte Arrays/Objects`",
  `"desc_EN`": `"Extremely nested arrays/objects`",
  Array50: [[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[[1]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]],
  Object50: {d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:{d:`"data`"}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}}

}
"
)

;OutputDebug JSON5Text
obj:= awkJSON5Dev.Parse(&JSON5Text,true)
OutputDebug awkJSON5Dev.Stringify(obj, 1)