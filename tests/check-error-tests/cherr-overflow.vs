    r0 := function (1 arguments) {
        r2 := 0
        r2 := r1 = r2
        if r2 goto L1
        r2 := 1
        r3 := r1 - r2
        r2 := r0
        r2 := call r2 (r3)
        L1:
          return r2
    }
    r1 := function (0 arguments) {
        r1 := 10000
        r0 := call r0 (r1)
        return r0
    }
    check-error "calling a stack-overflowing function" r1
    r0 := function? r0
    check-assert "r0 is a function, not a value." r0