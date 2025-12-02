#requires AutoHotkey v2.0

/** @description write something to a file
  * @param {(String)} fPath - The filename to write to
  * @param {(&String)} fData - The data to write. **Must be passed by reference.**
  * @param {(String)} [fFileEncoding="UTF-8"] - i.e. UTF-8[Default] or UTF-16<br>
  * @param {(String)} [fMode="w"]
  * - w = overwrite
  * - a = append
  * @see in AHK documentation
  * - FileOpen()
  */
awk_FileWrite( fFilename, &fData, fFileEncoding := "UTF-8", fMode := "w" ) {

    if( fMode == 'w' || fMode := 'a' ) {
          lFileO := FileOpen(fFilename, fMode, fFileEncoding)
          lFileO.Write(fData)
          lFileO.Close()
    }
}

/** @description this function searches for files
  * @param {(String)} fPath - The name of a folder to search
  * @param {(Bool)} [fFullDetail=true] - If true, breaks the file name (path) or URL into its name, directory, extension and drive.<br>
  * see SplitPath() in AHK Dokumentation
  * @param {(Bool)} [fInSubfolders=true] - If true, searches recursively in subdirectories
  * @param {(String)} fFilePattern - A list of file patterns, e.g., "*.htm", "*.txt", ...
  * @returns If fFullDetail is true, an array of detail objects is returned; otherwise, a simple array.<br>
  * @see in AHK documention
  * - Loop Files ...
  * - SplitPath()
  */
awk_SearchFiles(fPath, fFullDetail := true, fInSubfolders := true, fFilePattern* )
{
  files := []

  lMode := "F" (fInSubfolders) ? "R" : ""

  for ePattern in fFilePattern {
    Loop Files fPath ePattern, lMode
    {
      if ( fFullDetail ) {
        fileObj := {}
        SplitPath(A_LoopFileFullPath, &FileName, &FilePath, &FileExt, &FileNameNoExt)
        fileObj.File := A_LoopFileFullPath
        fileObj.FilePath := FilePath
        fileObj.FileName := FileName
        fileObj.FileNameNoExt := FileNameNoExt
        fileObj.FileExt := FileExt
        files.Push(fileObj)
      } else
       files.Push(A_LoopFileFullPath)
    }
  }

  return files
}