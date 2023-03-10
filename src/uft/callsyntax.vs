    r0 := function (0 arguments) {
      r1 := "arrived"
      check "arrived", r1
      expect "arrived", r1
      return r1
    }
    r1 := call r0 ()
    r1 := call r0 

    r0 := function (1 arguments) {
      r2 := r1
      r3 := 5
      check "r2", r1
      expect "5", r3
      return r2
    }
    r1 := 5
    r2 := call r0 (r1)

    r0 := function (3 arguments) {
      r4 := r1 + r2
      r4 := r4 + r3
      r5 := 15
      check "r4", r4
      expect "15", r5
      halt
    }
    r1 := 5
    r2 := 5
    r3 := 5
    r2 := call r0 (r1, ..., r3)