#Requires AutoHotkey v2.0

awk_FindObjectByName( fObject, fSearch ) {

        if ( fObject is Object && fSearch )
        {
            for index, item in fObject {
                if (item.name == fSearch) {
                    return item
                }
            }
        }

        return {}
}

awk_FindFirstValueInArray(fArray, fSearch) {
if ( fArray is Array ) {
    for eIdx, eValue in fArray {
        if (eValue == fSearch)
        return eIdx
    }
}
return -1
}

awk_MapToObject(obj) {
    result := {}

    if ( obj is Map ) {
        for eKey, eValue in obj {
            if (eValue is Map || eValue is Array)
                result.%eKey% := awk_MapToObject(eValue)
            else {
                result.%eKey% := eValue
            }
        }
        return result
    }
    else if ( obj is Array ) {
        result := []
        for eIndex, eValue in obj {
            if (eValue is Map || eValue is Array)
                result.Push(awk_MapToObject(eValue))
            else
                result.Push(eValue)
        }
        return result
    }
    else
        return obj
}