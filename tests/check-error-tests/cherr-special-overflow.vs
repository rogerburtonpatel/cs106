    r0 := function (1 arguments) {
        r2 := 0
        r2 := r1 = r2
        if r2 goto L1
        r2 := 1
        r3 := r1 - r2
        r2 := r0
        r2 := call r2 (r3)
        return r1
        L1:
          begin-check-error 4
          begin-check-error 2
          r1 := 0
          end-check-error "this test should never fully run."
          end-check-error "an overflowing check-error function"
          return r1
    }
    global the_worst_zero_youve_ever_seen := r0

    r1 := 4998
    r0 := call r0 (r1)