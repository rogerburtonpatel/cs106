    r0 := function (0 arguments) {
      ; a comment (only under the first line of a function) errors parser
      r1 := "arrived"
      check "arrived", r1
      expect "arrived", r1
      halt
    }
    r0 := call r0 ()
