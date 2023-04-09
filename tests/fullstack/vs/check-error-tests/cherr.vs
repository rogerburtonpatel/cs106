r0 := function (0 arguments) {
    r1 := 0
    r1 := r1 / r1
    return r0
    }
check-error "(/ 0 0)" r0
printlnl "we're done"