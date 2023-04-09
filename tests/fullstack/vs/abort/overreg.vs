    r250 := function (1 arguments) {
        r2 := 0
        r2 := r1 = r2
        if r2 goto L1
        r2 := 1
        r253 := r1 - r2
        r252 := _G["the_worst_zero_youve_ever_seen"]
        r252 := call r252 (r253)
        L1:
          return r2
    }
    global the_worst_zero_youve_ever_seen := r250

    r251 := 5000
    r0 := call r250 (r251)
    check "a really horrible zero function" r0
    r0 := 0
    expect "0" r0