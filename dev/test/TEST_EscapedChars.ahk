#Warn Unreachable, Off
#Include Includes.ahk

Perf := awkPerfCounter(1000)


valid := [
{ Nr: 1, desc_EN: "Slash",
  case: "\/abcd \/ / \/\/\/\/\/",
  expected: "/abcd / / /////"
}, { Nr: 2, desc_EN: "Backslash and quotes",
  case: "\\\abcd\\\\ \ \`" \' `` ",
  expected: "\\abcd\\ \ `" ' `` "
}, { Nr: 3, desc_EN: "LF,CR,H/V-Tab,Line Feed and NULL",
  case: "\r\n  \t\v\b\f\0",
  expected: "`r`n  `t`v`b`f"
}, { Nr: 4, desc_EN: "Unicode",
  case: "\u0030 \u0009 \u2764",
  expected: "0 `t ❤"
}, { Nr: 5, desc_EN: "Multiline CRLF,CR and LF",
  case:
(
"L1\\\
L2\\\`r`nL3\\\`rL4\\\`nL5"
),
  expected: "L1\L2\L3\L4\L5"
}, { Nr: 6, desc_EN: "Regular expression",
  case: "fin._meta.hashbang.match(/\\/[^\\/]+\\/([^\\/]+)$/) || ['',''])[1]\r\n]]\r\n\r\n<form",
  expected: "fin._meta.hashbang.match(/\/[^\/]+\/([^\/]+)$/) || ['',''])[1]`r`n]]`r`n`r`n<form"
}, { Nr: 7, desc_EN: "HTML",
  case: '<form><a>href=\"/#!/blog/admin/login\">Login</a>\r\n\r\n</form>',
  expected: '<form><a>href="/#!/blog/admin/login">Login</a>`r`n`r`n</form>'
}, { Nr: 8, desc_EN: "URL",
  case: "https://api.github.com/repos/weiguo21/cl-picture/downloads",
  expected: "https://api.github.com/repos/weiguo21/cl-picture/downloads"
}, { Nr: 9, desc_EN: "URL2",
  case: "https://www.youtube.com/watch?v=KzqoSeVMGrQ&list=RDKzqoSeVMGrQ&start_radio=1",
  expected: "https://www.youtube.com/watch?v=KzqoSeVMGrQ&list=RDKzqoSeVMGrQ&start_radio=1"
}

]

values := []
values.Push(valid*)

lValidCount := 0
lInvalidCount := 0

Perf.Reset()
for eVal in values {

  ;if ( eVal.Nr != 4)
  ; continue

  JSON5Text :=
(
"{ case:`"" eVal.case "`" }"
)

try {
        OutputDebugLine "───────────────────────────────────────────"

				obj:= awkJSON5Dev.Parse(&JSON5Text,true)

				if ( eval.expected == obj.case ) {
          lMsg := "✔ " eVal.Nr " VALID - " eval.desc_EN "`n▶" eVal.case "◀`n▶" obj.case "◀"
          lValidCount++
        }
        else
          lMsg := "✖(✔) " eVal.Nr " INVALID - " eval.desc_EN "`n▶" eVal.case "◀`n▶" obj.case "◀`nn▶" eval.expected "◀"

		} catch Error as e {

         lMsg := "✖ " eVal.Nr " INVALID ▶" eVal.case "◀`n▶" eval.expected "◀ -> " e.Message
         lInvalidCount++

		}
		OutputDebugLine lMsg

}
lTime := Perf.Measure()

OutputDebugLine "`n`n━━━━ Summary ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
OutputDebugLine ((valid.Length == lValidCount) ? "✔" : "✖") " Total Valids " valid.Length ", Valids=" lValidCount
OutputDebugLine "elapsed time [ms] " lTime