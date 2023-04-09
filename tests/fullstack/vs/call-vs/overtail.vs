    r0 := function (1 arguments) {
        r2 := 0
        r3 := r1 = r2
        if r3 goto L1
        r2 := 1
        r3 := r1 - r2
        r2 := r0
        tailcall r2 (r3)
        L1:
          return r2
    }
    global the_worst_zero_youve_ever_seen := r0

    r1 := 10000
    r0 := call r0 (r1)
    check "a really horrible zero function" r0
    r0 := 0
    expect "0" r0
