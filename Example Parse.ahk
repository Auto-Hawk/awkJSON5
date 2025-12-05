#Requires AutoHotkey v2.0
#Include lib\Includes.ahk

JSON5Text :=
(
"
{
  // Single line comment
  unquotedKey: 'value',
  arr: [1, 2, 3,],
  sig\u03A3ma: `"the sum of all things`",

  /* String */
   String: ' `"Hello double quoted String`" ',
  `"Line Breaks\
String`": `"😎 Hello \
World`",


  /* Numbers */
   'Not a Number': NaN,
   NeverEnds: Infinity,
   nothing: null,
   positiveSign: +1,
}
"
)

obj := awkJSON5.Parse(&JSON5Text, true) ; true für AHK Objects, false für Maps

/* OutputDebugLine is using
   OutputDebug awkJSON5.Stringify(obj, 1)
*/
OutputDebugLine obj