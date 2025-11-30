#Requires AutoHotkey v2.0

/** @description JSON/JSON5-Parser / JSON-Stringifier
  * @author      Auto-Hawk
  * @version     1.0.0
  * @created     2025-11-11
  * @modified
  * @see Specification<br>
  * https://json5.org<br>
  * https://spec.json5.org
 */
class awkJSON5Dev {

  /**@description Parses a JSON / JSON5 string
   * @param {(String)} &fSrc - JSON / JSON5 string to parse. **Must be passed by reference.
   *         Modifying the content of fSrc during parsing may produce unexpected results.**
   * @param {(Bool)} [fToObject = false] - true produces AHK objects, otherwise Maps
   * @return {(Map|Object)} - Parsed JSON5 object / map
   *
   * Notes:
   * - Comments (`//` or `/* ... */`) are supported, nested /**/ comments are not.
   * - true/false/null are converted to AutoHotkeyV2 values (1/0/"") due new behaviour.
   * - The JSON5 specification can be found at https://json5.org/
   */
  static Parse(&fSrc, fToObject := false) {
    _pos := 1

    if( !IsSet(fSrc) )
      _Throw("Parameter 'fSrc' is not set!" )

    _ParseValue() {
      _SkipWhitespace()
      lCh := SubStr(fSrc, _pos, 1)
      if (lCh == "{")
        return _ParseObject()
      else if (lCh == "[")
        return _ParseArray()
      else if (lCh == '"' || lCh == "'")
        return _ParseString()
      else if (lCh == "")
       return ""
      else { ;Parse number/special literal begin *******************************************

          i := RegExMatch(fSrc, "[\]\},\s]|$",, _pos)
          lVal := SubStr(fSrc, _pos, i - _pos)
          _pos := i

          if (lVal == "true")
            return 1
          else if (lVal == "false")
            return 0
          else {
            try {
              lNumber := lVal + 0
              return lNumber
            } catch {
              if (lVal == "null")
                return "" ;representation of NULL in AHK2
              else if (lVal == "Infinity" || lVal == "-Infinity" || lVal == "+Infinity" || lVal == "NaN")
                return lVal
             else
              _Throw("Invalid number literal: [" lVal "]")
            }
          }
     } ;Parse number/special literal end *******************************************

    }

    _ParseObject() {
      lObj := fToObject ? {} : Map()
      _pos++
      while true {
        _SkipWhitespace()
        lCh := SubStr(fSrc, _pos, 1)
        if (lCh == "}")
          break

        { ; Parse key begin *******************************************

          lCh := SubStr(fSrc, _pos, 1)
          if (lCh = '"' || lCh = "'") {
            ;Parse quoted key
            key := _ParseString()
          } else { ; Parse unquoted key begin *******************************************

            lIndex := InStr(fSrc,":",false,_pos)
            lTempKey := SubStr(fSrc,_pos,lIndex - _pos)
            if ( lTempKey == "" || SubStr(fSrc,lIndex,1) != ':' )
              _Throw("Invalid unquoted key" )

            lLen := StrLen(lTempKey)
            lIndex := 1
            key := ""
            while( lIndex <= lLen ) {

              if ( SubStr(lTempKey,lIndex, 2) == "\u"  ) {

                    lHex := SubStr(lTempKey,lIndex + 2, 4)
                    if ( !(lHex ~= "[0-9A-Fa-f]{4}") ) {
                      _pos += lIndex - 1
                      _Throw "Invalid unicode escape [\u" lHex "] (must be exactly 4 digits)"
                    } else {
                      lCh := Chr("0x" lHex)
                      lOffset := 6
                    }

              } else {
                lCh := SubStr(lTempKey,lIndex,1)
                lOffset := 1
              }

              if ( (lIndex == 1 && !(lCh ~= "[\p{L}\p{Nl}_$]")) ;UnicodeLetter,NumericLetter,_,$
                  ||
                  lCh == "\" || lCh == "/"
                  ||
                  !(lCh ~= "[$\p{L}\p{Nd}\p{Nl}\p{Mc}\p{Mn}\p{Pc}\x{200C}\x{200D}]") ;UnicodeLetter,Unicode Digit(decimal,letter),UnicodeCombiningMark,UnicodeConnectorPunctuation,<ZWNJ>,<ZWJ>
                ) {
                  _pos += lIndex - 1
                  _Throw "Invalid character in unquoted key [" lTempKey "]" ((lIndex == 1) ? " at first character" : "") "`n" SubStr(fSrc,_pos)
              } else {
              key .= lCh
              lIndex += lOffset
              }

            }
            _pos += lLen

          } ; Parse unquoted key end *******************************************

        } ; Parse key end *******************************************

        _SkipWhitespace()
        if (SubStr(fSrc, _pos, 1) !== ":")
          _Throw("Expected ':' after key")
        _pos++
        lVal := _ParseValue()
        if (fToObject)
          lObj.%key% := lVal
        else
          lObj[key] := lVal
        _SkipWhitespace()
        lCh := SubStr(fSrc, _pos, 1)
        if (lCh == "}" || lCh == "" ) ;closed object / end of data
          break
        else if (lCh !== ",")
          return _Throw("Expected ',' or '}'")
        _pos++
      }
      _pos++
      return lObj
    }

    _ParseArray() {
      lArr := []
      _pos++
      while true {
        _SkipWhitespace()
        lCh := SubStr(fSrc, _pos, 1)
        if (lCh == "]")
          break
        lVal := _ParseValue()
        lArr.Push(lVal)
        _SkipWhitespace()
        lCh := SubStr(fSrc, _pos, 1)
        if (lCh == "]" || lCh == "") ;closed array or / end of data
          break
        else if (lCh !== ",")
          _Throw("Expected ',' or ']'")
        _pos++
      }
      _pos++
      return lArr
    }

    _ParseString() {
      lDelim := SubStr(fSrc, _pos, 1)
      lVal := ""
      _pos++

      while true {
        TemPos := InStr(fSrc, lDelim, false, _pos)
        if (!TemPos)
          _Throw("Unterminated string literal [" SubStr(fSrc,_pos - 1, 10) " ...]" )
        segment := SubStr(fSrc, _pos, TemPos - _pos)
        if (SubStr(segment, -1) != "\") {
          lVal .= segment
          break
        }
        lVal .= SubStr(segment, 1, -1) . lDelim
        _pos := TemPos + 1

      }
      lVal := StrReplace(lVal, "\`r`n", "") ; Multi line string PC
      lVal := StrReplace(lVal, "\`n", "")   ; Multi line string UNIX/MAC
      _pos := TemPos + 1

      try {
        return this.UnescapeStr(lVal)
      } catch Error as e {
        _Throw(e.Message)
      }
    }

    _SkipWhitespace() {
      while true {
        lCh := SubStr(fSrc, _pos, 1)
        if (!lCh)
          break
        else if (InStr(" `t`n`r`f`v", lCh)) {
          _pos++
        } else {
          pair := SubStr(fSrc, _pos, 2)
          if (pair == "//") {                     ; Single-line comment (can end with LF or CR)
            next := InStr(fSrc, "`n", false, _pos+2) ;
            if (next == 0)
              next := InStr(fSrc, "`r", false, _pos+2)

            _pos := (next > 0) ? next+1 : StrLen(fSrc)+1
          } else if (pair == "/*") {              ; Multi-line comment
            next := InStr(fSrc, "*/", false, _pos+2)
            if (!next)
              _Throw("Unterminated comment")
            _pos := next + 2
          } else
            break
        }
      }
    }

    _GetLineCol(p) {

      if ( IsSet(fSrc) ) {
        lLine := 1
        lCol := 1
        Loop Parse SubStr(fSrc, 1, p-1) {
          if (A_LoopField == "`n") {
            lLine++
            lCol := 1
          } else
            lCol++
        }
      } else {
        lLine := -1
        lCol := -1
      }


      return {line: lLine, col: lCol}
    }

    _Throw(msg) {

      lPosInfo := _GetLineCol(_pos)
      throw Error(msg " at line " lPosInfo.line ", col " lPosInfo.col ", pos " _pos)
    }


    return _ParseValue()
  }

  /** @description JSON Stringify
	 * @param {(Map|Object)} fObj - the object / map to be stringified
	 * @param {(String|Number)} [fIndent=""] - Defines the character used to indent each level of the JSON tree.
   *  Number indicates the number of spaces to use for each indent.
   *  String indiciates the characters to use. '`t' would be 1 tab for each indent level.
   *  If omitted or an empty string is passed in, the JSON string will export as a single line of text.
   * @returns {(String)} Returns a JSON string.
   */
  static Stringify(fObj, fIndent := "") {

      _IndentBase := ""
      if ( fIndent is Integer ) {

            if (fIndent < 0)
             fIndent := 0

            Loop fIndent
              _IndentBase .= " "
       }
       else if ( fIndent is String )
        _IndentBase := fIndent

      _Stringify(fObj, fLvl := 1) {

        if (IsObject(fObj)) {
            lIsArray := fObj is Array
            lIsMap   := fObj is Map

            If !(lIsArray || lIsMap || fObj is String || fObj is Number || fObj is Object)
              throw Error("Type '" Type(fObj) "' is not supported!")

            lIndent := ""
            Loop (_IndentBase ? fLvl : 0)
                lIndent .= _IndentBase
            fLvl += 1
            lOut := ""

            if (lIsArray || lIsMap) {
                for k, v in fObj {
                    if ( !lIsArray )
                        lOut .= this.EscapeStr(k) (_IndentBase ? ": " : ":")
                    lOut .= _Stringify(v, fLvl)
                    lOut .= (_IndentBase ? ",`n" . lIndent : ",")
                }
            } else { ; Properties

                for k, v in fObj.OwnProps() {
                    lOut .= this.EscapeStr(k) (_IndentBase ? ": " : ":")
                    lOut .= _Stringify(v, fLvl)
                    lOut .= (_IndentBase ? ",`n" . lIndent : ",")
                }
            }

            if (lOut != "") {
                lOut := Trim(lOut, ",`n" . _IndentBase)
                if (_IndentBase != "")
                    lOut := "`n" . lIndent . lOut . "`n" . SubStr(lIndent, StrLen(_IndentBase)+1)
            }

            return lIsArray ? "[" . lOut . "]" : "{" . lOut . "}"
        }
        else if ( fObj is Number )
            return fObj
        else
            return this.EscapeStr(fObj)
      }

      return _Stringify(fObj)
  }

 /** @description Escapes a JSON String
	 * @param {(String)} fStr - the string to be escaped
   * @param {(String)} [fQuote = '"'] - the character for quotation
   * @returns {(String)} Returns a escaped JSON string.
   */
  static EscapeStr(fStr, fQuote := '"') {
      lResult := ""
      Loop Parse fStr
      {
        switch A_LoopField {
            ;case "'":  lResult .= "\'" ; not supported in regular JSON
            ;case "`v": lResult .= "\v" ; not supported in regular JSON
            case '"':  lResult .= '\"'
            case "/":  lResult .= "\/"
            case "\":  lResult .= "\\"
            case "`b": lResult .= "\b"
            case "`f": lResult .= "\f"
            case "`n": lResult .= "\n"
            case "`r": lResult .= "\r"
            case "`t": lResult .= "\t"

            default:
                lCode := Ord(A_LoopField)
                if (lCode < 0x20)  ; control character < 0x20 ( Field Separator ^\ FS 0x1C -> \u001C)
                    lResult .= Format("\u{:04X}", lCode)
                else
                    lResult .= A_LoopField
          }
      }
      return fQuote . lResult . fQuote
	}

  /** @description Unescapes a JSON String
   * @param {(String)} fStr - the string to be unescaped
   * @returns {(String)} Returns the unescaped JSON string.
   */
  static UnescapeStr(fStr) {
    lResult := ""
    i := 1
    len := StrLen(fStr)

    while (i <= len) {
      c := SubStr(fStr, i, 1)
      if( c == "\" ) {
        next := SubStr(fStr, ++i, 1)
        switch next {
            case "'":  lResult .= "'"
            case '"':  lResult .= '"'
            case "\":  lResult .= "\"
            case "/":  lResult .= "/"
            case "b":  lResult .= "`b"
            case "f":  lResult .= "`f"
            case "n":  lResult .= "`n"
            case "r":  lResult .= "`r"
            case "t":  lResult .= "`t"
            case "v":  lResult .= "`v"
            case "0":  lResult .= "" ; representation of NULL in AHK2
            case "u":  ;\uXXXX
                    hex := SubStr(fStr, i + 1, 4)
                    if ( !(hex ~= "^[0-9A-Fa-f]{4}$") )
                      throw Error("Invalid unicode escape (must be exactly 4 digits)")

                    lResult .= Chr("0x" hex)
                    i += 4
            default:
                lResult .= "\" next
        }

      } else {
        lResult .= c
      }
      i++

    }

    return lResult
  }

}