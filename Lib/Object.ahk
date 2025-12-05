; This work is released into the public domain under CC0 1.0 Universal.
#Requires AutoHotkey v2.0

/** @description Searches an array of Objects or Maps for an entry whose specified property
 *               matches the given search value.
 * @param {(Array)} fArray An array to search through.
 * @param {(String)} fSearch The value to search for.
 * @param {(String)} fPropName The property name to compare.
 * @param {(Bool)} fCaseSensitive [fCaseSensitive=true] If true, performs a case-sensitive comparsion<br><br>
 * @return {Object} The matching item, or an empty string if nothing was found
 */
awk_FindObjectByPropName( fArray, fSearch, fPropName, fCaseSensitive := true ) {

        if ( fArray is Array && fSearch && fPropName )
        {
            for , eItem in fArray {

							lVal := (eItem is Map) ? eItem[fPropName] : eItem.%fPropName%

							try {

                if ( fCaseSensitive ) {
									if (lVal == fSearch) {
											return eItem
									}

                } else {
									if (lVal = fSearch) {
											return eItem
									}
								}
							}
						}
        }

  			return ""
}

/** @description Searches an array of strings matches the given search value.
 * @param {(Array)} fArray An array to search through.
 * @param {(String)} fSearch The value to search for.
 * @param {(Bool)} fCaseSensitive [fCaseSensitive=true] If true, performs a case-sensitive comparsion<br><br>
 * @return {Object} The first matching item index, or -1 if nothing was found
 */
awk_FindFirstValueInArray(fArray, fSearch, fCaseSensitive := true) {

  if ( fArray is Array ) {

      for eIdx, eValue in fArray {
          if ( fCaseSensitive ) {
            if (eValue == fSearch) {
              return eIdx
            }
          } else {
            if (eValue = fSearch) {
              return eIdx
            }
          }

      }
  }
  return -1
}

/** @description Converts Maps to Objects
 * @param {(Map)} fMap The Map to convert
 * @return {Object} An Object converted from Map
 */
awk_MapToObject(fMap) {
    result := {}

    if ( fMap is Map ) {
        for eKey, eValue in fMap {
            if (eValue is Map || eValue is Array)
                result.%eKey% := awk_MapToObject(eValue)
            else {
                result.%eKey% := eValue
            }
        }
        return result
    }
    else if ( fMap is Array ) {
        result := []
        for eIndex, eValue in fMap {
            if (eValue is Map || eValue is Array)
                result.Push(awk_MapToObject(eValue))
            else
                result.Push(eValue)
        }
        return result
    }
    else
        return fMap
}