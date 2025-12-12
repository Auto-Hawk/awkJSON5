; This work is released into the public domain under CC0 1.0 Universal.

/** @description The perfomance counter allows times between two points in the code to be measured.
  * @author      Auto-Hawk
  * @version     1.0.0
  * @created     2025-11-12
  * @see Specification<br>
  * https://learn.microsoft.com/de-de/windows/win32/api/profileapi/nf-profileapi-queryperformancecounter<br>
  * https://learn.microsoft.com/en-us/windows/win32/api/profileapi/nf-profileapi-queryperformancefrequency
 */
class awkPerfCounter {

  _Frequency := 0
  _CntBefore := 0
  _TimeFactor := 1  ; 1 = in seconds
  _Time := 0

  __New( fTimeFactor := 1 ) {

     this.SetFactor(fTimeFactor)
     DllCall("QueryPerformanceFrequency", "Int64*", &lFrequency := 0)
     this._Frequency := lFrequency
  }

/** @description Resets the performance counter<br>
  * Gets the current number of ticks from QueryPerformanceCounter,
  * means it starts a new fresh measure
  */
  Reset() {

    DllCall("QueryPerformanceCounter", "Int64*", &lCnt := 0)
    this._CntBefore := lCnt
    this._Time := 0
  }


/** @description Sets the time factor for measuring<br>
  * @param {(Number)} fTimeFactor The time factor
  * - 1 = in seconds
  * - 1000  = in milliseconds
  */
  SetFactor( fTimeFactor ) {
    if ( fTimeFactor <= 0 )
     fTimeFactor := 1

    this._TimeFactor := fTimeFactor
  }

/** @description Returns the elapsed time<br>
  * Gets the current number of ticks from QueryPerformanceCounter and
  * caluates the number of ticks since reset or last measuring.<br>
  * @param {(Boolean)} [fResetTime=true] If true, it resets the time from the last measure,<br>
  * If false, subsequent calls add up the elapsed time.<br>
  * If you want to measure the time between two calls set it to true (or ommit it)
  * @param {(Number)} fTimeFactor The time factor<br>
  * Sets the time factor temporarily in this measurement
  * Values are i.e.:
  * - 1 = in seconds
  * - 1000  = in milliseconds
  */
  Measure( fResetTime := true, fTimeFactor := this._TimeFactor ) {

     DllCall("QueryPerformanceCounter", "Int64*", &lCnt := 0)

     if ( fResetTime )
      this._Time := 0

     this._Time += ((lCnt - this._CntBefore) / this._Frequency)
     this._CntBefore := lCnt

     return (this._Time * fTimeFactor)
  }

}
