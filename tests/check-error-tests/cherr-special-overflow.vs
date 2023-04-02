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

          r4 := function (0 arguments) {
              r1 := 1
              return r0
          }
          r5 := function (0 arguments) {
              check-error "r1 := 1" r4
              return r0
          }
          check-error "check-error r1 := 1" r5
          return r1
    }
    global the_worst_zero_youve_ever_seen := r0

    r1 := 4998
    r0 := call r0 (r1)