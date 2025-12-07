# JSON5 Parser for AutoHotkey v2

A **JSON5/JSON parser** and a **JSON stringifier**, designed for AutoHotkey v2.


## Features

* **Parser:**
  * Supports JSON and JSON5 according to the specification
  * May return AHK Objects ( `{}` ) or Maps ( `Map` )

* **Stringifier:** Generates JSON
* JSON5 features:

  * Comments (`//` and `/* */`)
  * Unquoted keys
  * Single-quoted strings
  * Multiline strings
  * Trailing commas
  * numbers may be hexadecimal
  * numbers may be positive infinity, negative infinity, and NaN
  * numbers may begin with an explicit plus sign
* Pure AutoHotkey v2 implementation – no external dependencies

## Installation

A class `awkJSON5` is included in `awkJSON5.ahk`. Simply include it:

```ahk
#Requires AutoHotkey v2.0
#Include ...\awkJSON5.ahk
```

## Example: Parsing (JSON5/JSON)

```ahk
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

/* OutputDebugLine is using (see lib\debug.ahk)
   OutputDebug awkJSON5.Stringify(obj, 1)
*/
OutputDebugLine obj
```

## Example: Stringify (JSON)

```ahk
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
```

## API

The implementation is encapsulated in the `awkJSON5` class, which provides parsing and stringify functions.

#### `awkJSON5.Parse(&fStr, fToObject := false)`

Parses a JSON or JSON5 string.

* **Parameters**:

  * `&fSrc` – JSON / JSON5 string to parse. **Must be passed by reference.**
  * `fToObject` – `true` produces AHK objects, otherwise Maps
* **Return**: Parsed JSON5 object / map

#### `awkJSON5.Stringify(fObj, fIndent := "")`

Converts AHK data structures ( objects or maps ) to a **JSON** string.

* **Parameters**:

  * `fObj` – the object / map to be stringified
  * `fIndent` – character(s) used to indent each level of the JSON tree.
   <br>A Number indicates the number of spaces to use for each indent.
* **Return**: JSON string

## Compatibility

* AutoHotkey v2
* Tested with 2.0.19

## Development Status

Version **1.0.1** – stable.<br>
see CHANGELOG.md

## References

* [https://json5.org](https://json5.org)
* [https://spec.json5.org](https://spec.json5.org)

## License

MIT License<br>
see https://opensource.org/licenses/MIT
