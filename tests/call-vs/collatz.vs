    r0 := function (1 arguments) {
      r2 := 1
      r2 := r1 = r2
      if r2 goto L1 ;; if arg is 1, stop
        ;; even? n
        r2 := 2
        r2 := r1 mod r2
        r3 := 0
        r2 := r2 = r3
        
        if r2 goto L2 ;; arg even

        r2 := r0  ; collatz
        r4 := 1
        r3 := 3
        r3 := r1 * r3
        r3 := r1 + r4
        r2 := call r2 (r3)
        return r2
      L1:
        r0 := 1
        return r0
      L2:
        r2 := 2
        r3 := r1 / r2
        r2 := r0 ; collatz
        r2 := call r2 (r3)
        return r2
    }
    global collatz := r0

    r1 := 5234872342343
    r0 := call r0 (r1)
    check "collatz (5234872342343)" r0
    expect "1" r0