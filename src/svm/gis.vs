r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L1
  }
  r0 := #f
  return r0
  L1:
  r0 := #t
  return r0
}
_G[ "2Dpoint?" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L2
  }
  r2 := "value passed to 2Dpoint-x is not a 2Dpoint record"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L2:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  r4 := block r1 < 3 >
  return r2
}
_G[ "2Dpoint-x" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L3
  }
  r2 := "value passed to 2Dpoint-y is not a 2Dpoint record"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L3:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  r4 := block r1 < 3 >
  return r3
}
_G[ "2Dpoint-y" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L4
  }
  r2 := "value passed to 2Dpoint-value is not a 2Dpoint record"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L4:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  r4 := block r1 < 3 >
  return r4
}
_G[ "2Dpoint-value" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L5
  }
  r0 := "no-matching-case"
  error r0
  return r0
  L5:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  r4 := block r1 < 3 >
  return r2
}
_G[ "2Dpoint-x" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L6
  }
  r0 := "no-matching-case"
  error r0
  return r0
  L6:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  r4 := block r1 < 3 >
  return r3
}
_G[ "2Dpoint-y" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-2Dpoint" (3): goto L7
  }
  r0 := "no-matching-case"
  error r0
  return r0
  L7:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  r4 := block r1 < 3 >
  return r4
}
_G[ "2Dpoint-value" ] := r0
r0 := function ( 1 arguments ) {
  r0 := r1 * r1
  return r0
}
_G[ "square" ] := r0
r0 := function ( 3 arguments ) {
  r4 := _G[ "square" ]
  r5 := _G[ "2Dpoint-x" ]
  r6 := r3
  r5 := call r5 ( r6 )
  r5 := r1 - r5
  r4 := call r4 ( r5 )
  r5 := _G[ "square" ]
  r6 := _G[ "2Dpoint-y" ]
  r7 := r3
  r6 := call r6 ( r7 )
  r6 := r2 - r6
  r5 := call r5 ( r6 )
  r0 := r4 + r5
  return r0
}
_G[ "point-distance-squared" ] := r0
r0 := function ( 2 arguments ) {
  r3 := function ( 3 arguments ) {
    switch r3 {
      case emptylist (0): goto L8
      case "cons" (2): goto L9
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L8:
    return r1
    L9:
    r4 := block r3 < 1 >
    r5 := block r3 < 2 >
    r6 := r0 < 1 >
    r7 := r4
    r6 := call r6 ( r7 )
    r7 := r6 < r2
    if r7 goto L10
    r7 := r0 < 0 >
    r8 := r1
    r9 := r2
    r10 := r5
    tailcall r7 ( r10 )
    goto L11
    L10:
    r7 := r0 < 0 >
    r8 := r4
    r9 := r6
    r10 := r5
    tailcall r7 ( r10 )
    L11:
  }
  r3 := mkclosure r3 2
  r3 < 0 > := r3
  r3 < 1 > := r1
  switch r2 {
    case emptylist (0): goto L12
    case "cons" (2): goto L13
  }
  r0 := "no-matching-case"
  error r0
  return r0
  L12:
  r4 := "argmin-of-empty-list"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L13:
  r4 := block r2 < 1 >
  r5 := block r2 < 2 >
  r6 := r3
  r7 := r4
  r8 := r1
  r9 := r4
  r8 := call r8 ( r9 )
  r9 := r5
  tailcall r6 ( r9 )
}
_G[ "argmin" ] := r0
r0 := function ( 3 arguments ) {
  r4 := _G[ "argmin" ]
  r5 := function ( 1 arguments ) {
    r6 := _G[ "square" ]
    r7 := _G[ "2Dpoint-x" ]
    r8 := r1
    r7 := call r7 ( r8 )
    r8 := r0 < 1 >
    r7 := r7 - r8
    r6 := call r6 ( r7 )
    r7 := _G[ "square" ]
    r8 := _G[ "2Dpoint-y" ]
    r9 := r1
    r8 := call r8 ( r9 )
    r9 := r0 < 0 >
    r8 := r8 - r9
    r7 := call r7 ( r8 )
    r0 := r6 + r7
    return r0
  }
  r5 := mkclosure r5 2
  r5 < 0 > := r2
  r5 < 1 > := r1
  r5 := r5
  r6 := r3
  tailcall r4 ( r6 )
}
_G[ "slow-nearest-point" ] := r0
r0 := function ( 4 arguments ) {
  r5 := _G[ "point-distance-squared" ]
  r6 := r1
  r7 := r2
  r8 := r3
  r5 := call r5 ( r6 - r8 )
  r6 := _G[ "point-distance-squared" ]
  r7 := r1
  r8 := r2
  r9 := r4
  r6 := call r6 ( r7 - r9 )
  r5 := r5 < r6
  if r5 goto L14
  return r4
  goto L15
  L14:
  return r3
  L15:
}
_G[ "closer" ] := r0
r0 := function ( 3 arguments ) {
  r0 := function ( 5 arguments ) {
    r6 := _G[ "nearest-point" ]
    r7 := r1
    r8 := r2
    r9 := r3
    r6 := call r6 ( r7 - r9 )
    r7 := _G[ "point-distance-squared" ]
    r8 := r1
    r9 := r2
    r10 := r6
    r7 := call r7 ( r8 - r10 )
    an unknown register-based assembly-code instruction <=
    if r8 goto L16
    r8 := _G[ "closer" ]
    r9 := r1
    r10 := r2
    r11 := r6
    r12 := _G[ "nearest-point" ]
    r13 := r1
    r14 := r2
    r15 := r4
    r12 := call r12 ( r13 - r15 )
    tailcall r8 ( r12 )
    goto L17
    L16:
    return r6
    L17:
  }
  return r0
}
_G[ "nearest-point" ] := r0
r0 := function ( 1 arguments ) {
  r4 := function ( 2 arguments ) {
    switch r1 {
      case emptylist (0): goto L18
      case "cons" (2): goto L19
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L18:
    return r2
    L19:
    r5 := block r1 < 1 >
    r6 := block r1 < 2 >
    switch r2 {
      case emptylist (0): goto L20
      case "cons" (2): goto L21
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L20:
    return r1
    L21:
    r7 := block r2 < 1 >
    r8 := block r2 < 2 >
    r9 := r0 < 0 >
    r10 := r5
    r11 := r7
    r9 := call r9 ( r10 - r11 )
    switch r9 {
      case "LESS" (0): goto L22
    }
    r11 := r0 < 1 >
    r12 := r8
    r13 := r1
    r11 := call r11 ( r12 - r13 )
    r10 := r7 cons r11
    return r10
    L22:
    r11 := r0 < 1 >
    r12 := r6
    r13 := r2
    r11 := call r11 ( r12 - r13 )
    r10 := r5 cons r11
    return r10
  }
  r4 := mkclosure r4 2
  r3 := function ( 3 arguments ) {
    switch r1 {
      case emptylist (0): goto L23
      case "cons" (2): goto L24
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L23:
    r5 := _G[ "pair" ]
    r6 := r2
    r7 := r3
    tailcall r5 ( r7 )
    L24:
    r5 := block r1 < 1 >
    r6 := block r1 < 2 >
    r7 := r0 < 0 >
    r8 := r6
    r9 := r3
    r10 := r5 cons r2
    r10 := r10
    tailcall r7 ( r10 )
  }
  r3 := mkclosure r3 1
  r2 := function ( 1 arguments ) {
    switch r1 {
      case emptylist (0): goto L25
      case "cons" (2): goto L26
    }
    r5 := r0 < 0 >
    r6 := r1
    r7 := emptylist
    r8 := emptylist
    r5 := call r5 ( r6 - r8 )
    switch r5 {
      case "PAIR" (2): goto L29
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L29:
    r6 := block r5 < 1 >
    r7 := block r5 < 2 >
    r8 := r0 < 2 >
    r9 := r0 < 1 >
    r10 := r6
    r9 := call r9 ( r10 )
    r10 := r0 < 1 >
    r11 := r7
    r10 := call r10 ( r11 )
    tailcall r8 ( r10 )
    L25:
    r0 := emptylist
    return r0
    L26:
    r5 := block r1 < 2 >
    switch r5 {
      case emptylist (0): goto L27
    }
    r6 := r0 < 0 >
    r7 := r1
    r8 := emptylist
    r9 := emptylist
    r6 := call r6 ( r7 - r9 )
    switch r6 {
      case "PAIR" (2): goto L28
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L28:
    r7 := block r6 < 1 >
    r8 := block r6 < 2 >
    r9 := r0 < 2 >
    r10 := r0 < 1 >
    r11 := r7
    r10 := call r10 ( r11 )
    r11 := r0 < 1 >
    r12 := r8
    r11 := call r11 ( r12 )
    tailcall r9 ( r11 )
    L27:
    r6 := block r1 < 1 >
    return r1
  }
  r2 := mkclosure r2 3
  r4 < 0 > := r1
  r4 < 1 > := r4
  r3 < 0 > := r3
  r2 < 0 > := r3
  r2 < 1 > := r2
  r2 < 2 > := r4
  return r2
}
_G[ "mergesort" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "mergesort" ]
  r3 := function ( 2 arguments ) {
    r4 := _G[ "Int.compare" ]
    r5 := r0 < 0 >
    r6 := r1
    r5 := call r5 ( r6 )
    r6 := r0 < 0 >
    r7 := r2
    r6 := call r6 ( r7 )
    tailcall r4 ( r6 )
  }
  r3 := mkclosure r3 1
  r3 < 0 > := r1
  r3 := r3
  tailcall r2 ( r3 )
}
_G[ "sort-on" ] := r0
r0 := function ( 1 arguments ) {
  r2 := function ( 3 arguments ) {
    switch r3 {
      case "cons" (2): goto L30
    }
    r4 := _G[ "pair" ]
    r5 := _G[ "reverse" ]
    r6 := r1
    r5 := call r5 ( r6 )
    r6 := r2
    tailcall r4 ( r6 )
    L30:
    r4 := block r3 < 2 >
    switch r4 {
      case "cons" (2): goto L31
    }
    r5 := _G[ "pair" ]
    r6 := _G[ "reverse" ]
    r7 := r1
    r6 := call r6 ( r7 )
    r7 := r2
    tailcall r5 ( r7 )
    L31:
    r5 := block r4 < 2 >
    switch r2 {
      case emptylist (0): goto L32
      case "cons" (2): goto L33
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L32:
    r6 := "this-cannot-happen"
    r0 := "effectful primitive error used in register-setting context on register r0"
    error r0
    return r0
    L33:
    r6 := block r2 < 1 >
    r7 := block r2 < 2 >
    r8 := r0 < 0 >
    r9 := r6 cons r1
    r9 := r9
    r10 := r7
    r11 := r5
    tailcall r8 ( r11 )
  }
  r2 := mkclosure r2 1
  r2 < 0 > := r2
  r3 := r2
  r4 := emptylist
  r5 := r1
  r6 := r1
  tailcall r3 ( r6 )
}
_G[ "halves" ] := r0
r0 := function ( 1 arguments ) {
  r0 := car r1
  return r0
}
_G[ "first" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "cons" (2): goto L34
    case emptylist (0): goto L36
  }
  r0 := "no-matching-case"
  error r0
  return r0
  L34:
  r2 := block r1 < 2 >
  switch r2 {
    case emptylist (0): goto L35
  }
  r3 := _G[ "last" ]
  r4 := r2
  tailcall r3 ( r4 )
  L35:
  r3 := block r1 < 1 >
  return r3
  L36:
  r2 := "last-of-empty-list"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
}
_G[ "last" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-coord-funs" (2): goto L37
  }
  r0 := #f
  return r0
  L37:
  r0 := #t
  return r0
}
_G[ "coord-funs?" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-coord-funs" (2): goto L38
  }
  r2 := "value passed to coord-funs-project is not a coord-funs record"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L38:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  return r2
}
_G[ "coord-funs-project" ] := r0
r0 := function ( 1 arguments ) {
  switch r1 {
    case "make-coord-funs" (2): goto L39
  }
  r2 := "value passed to coord-funs-mk-split is not a coord-funs record"
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L39:
  r2 := block r1 < 1 >
  r3 := block r1 < 2 >
  return r3
}
_G[ "coord-funs-mk-split" ] := r0
r0 := "make-coord-funs"
r1 := _G[ "2Dpoint-x" ]
r2 := function ( 3 arguments ) {
  r4 := "VERT"
  r0 := mkblock r4 4
  block r0 < 1 > := r1
  block r0 < 2 > := r2
  block r0 < 3 > := r3
  return r0
}
r0 := mkblock r0 3
block r0 < 1 > := r1
block r0 < 2 > := r2
_G[ "vert-funs" ] := r0
r0 := "make-coord-funs"
r1 := _G[ "2Dpoint-y" ]
r2 := function ( 3 arguments ) {
  r4 := "HORIZ"
  r0 := mkblock r4 4
  block r0 < 1 > := r1
  block r0 < 2 > := r2
  block r0 < 3 > := r3
  return r0
}
r0 := mkblock r0 3
block r0 < 1 > := r1
block r0 < 2 > := r2
_G[ "horiz-funs" ] := r0
r0 := _G[ "list2" ]
r1 := _G[ "vert-funs" ]
r2 := _G[ "horiz-funs" ]
r0 := call r0 ( r1 - r2 )
_G[ "all-coordinates" ] := r0
r0 := function ( 1 arguments ) {
  r2 := function ( 2 arguments ) {
    switch r2 {
      case emptylist (0): goto L40
      case "cons" (2): goto L41
    }
    r0 := "no-matching-case"
    error r0
    return r0
    L40:
    r3 := r0 < 0 >
    r4 := r1
    r5 := _G[ "all-coordinates" ]
    tailcall r3 ( r5 )
    L41:
    r3 := block r2 < 1 >
    r4 := block r2 < 2 >
    switch r1 {
      case "cons" (2): goto L42
    }
    r5 := _G[ "coord-funs-project" ]
    r6 := r3
    r5 := call r5 ( r6 )
    r6 := _G[ "coord-funs-mk-split" ]
    r7 := r3
    r6 := call r6 ( r7 )
    r7 := _G[ "sort-on" ]
    r8 := r5
    r7 := call r7 ( r8 )
    r8 := r7
    r9 := r1
    r8 := call r8 ( r9 )
    r9 := _G[ "halves" ]
    r10 := r8
    r9 := call r9 ( r10 )
    r10 := _G[ "fst" ]
    r11 := r9
    r10 := call r10 ( r11 )
    r11 := _G[ "snd" ]
    r12 := r9
    r11 := call r11 ( r12 )
    r12 := null? r10
    if r12 goto L48
    r12 := "UNIT"
    r12 := mkblock r12 1
    goto L49
    L48:
    r12 := "empty-small-tree"
    r0 := "effectful primitive error used in register-setting context on register r12"
    error r0
    L49:
    r13 := null? r11
    if r13 goto L50
    r13 := "UNIT"
    r13 := mkblock r13 1
    goto L51
    L50:
    r13 := "empty-large-tree"
    r0 := "effectful primitive error used in register-setting context on register r13"
    error r0
    L51:
    r14 := function ( 2 arguments ) {
      r14 := r1 + r2
      r15 := 2
      r0 := r14 / r15
      return r0
    }
    r15 := r14
    r16 := r5
    r17 := _G[ "last" ]
    r18 := r10
    r17 := call r17 ( r18 )
    r16 := call r16 ( r17 )
    r17 := r5
    r18 := _G[ "first" ]
    r19 := r11
    r18 := call r18 ( r19 )
    r17 := call r17 ( r18 )
    r15 := call r15 ( r16 - r17 )
    r16 := r6
    r17 := r15
    r18 := r0 < 0 >
    r19 := r10
    r20 := r4
    r18 := call r18 ( r19 - r20 )
    r19 := r0 < 0 >
    r20 := r11
    r21 := r4
    r19 := call r19 ( r20 - r21 )
    tailcall r16 ( r19 )
    L42:
    r5 := block r1 < 2 >
    switch r5 {
      case emptylist (0): goto L43
    }
    r6 := _G[ "coord-funs-project" ]
    r7 := r3
    r6 := call r6 ( r7 )
    r7 := _G[ "coord-funs-mk-split" ]
    r8 := r3
    r7 := call r7 ( r8 )
    r8 := _G[ "sort-on" ]
    r9 := r6
    r8 := call r8 ( r9 )
    r9 := r8
    r10 := r1
    r9 := call r9 ( r10 )
    r10 := _G[ "halves" ]
    r11 := r9
    r10 := call r10 ( r11 )
    r11 := _G[ "fst" ]
    r12 := r10
    r11 := call r11 ( r12 )
    r12 := _G[ "snd" ]
    r13 := r10
    r12 := call r12 ( r13 )
    r13 := null? r11
    if r13 goto L44
    r13 := "UNIT"
    r13 := mkblock r13 1
    goto L45
    L44:
    r13 := "empty-small-tree"
    r0 := "effectful primitive error used in register-setting context on register r13"
    error r0
    L45:
    r14 := null? r12
    if r14 goto L46
    r14 := "UNIT"
    r14 := mkblock r14 1
    goto L47
    L46:
    r14 := "empty-large-tree"
    r0 := "effectful primitive error used in register-setting context on register r14"
    error r0
    L47:
    r15 := function ( 2 arguments ) {
      r15 := r1 + r2
      r16 := 2
      r0 := r15 / r16
      return r0
    }
    r16 := r15
    r17 := r6
    r18 := _G[ "last" ]
    r19 := r11
    r18 := call r18 ( r19 )
    r17 := call r17 ( r18 )
    r18 := r6
    r19 := _G[ "first" ]
    r20 := r12
    r19 := call r19 ( r20 )
    r18 := call r18 ( r19 )
    r16 := call r16 ( r17 - r18 )
    r17 := r7
    r18 := r16
    r19 := r0 < 0 >
    r20 := r11
    r21 := r4
    r19 := call r19 ( r20 - r21 )
    r20 := r0 < 0 >
    r21 := r12
    r22 := r4
    r20 := call r20 ( r21 - r22 )
    tailcall r17 ( r20 )
    L43:
    r6 := block r1 < 1 >
    r7 := "POINT"
    r0 := mkblock r7 2
    block r0 < 1 > := r6
    return r0
  }
  r2 := mkclosure r2 1
  r2 < 0 > := r2
  r3 := r2
  r4 := r1
  r5 := _G[ "all-coordinates" ]
  tailcall r3 ( r5 )
}
_G[ "2Dtree" ] := r0
r0 := _G[ "list3" ]
r1 := "make-2Dpoint"
r2 := 10
r3 := 12
r4 := "A"
r1 := mkblock r1 4
block r1 < 1 > := r2
block r1 < 2 > := r3
block r1 < 3 > := r4
r2 := "make-2Dpoint"
r3 := 5
r4 := 6
r5 := "B"
r2 := mkblock r2 4
block r2 < 1 > := r3
block r2 < 2 > := r4
block r2 < 3 > := r5
r3 := "make-2Dpoint"
r4 := 33
r5 := 99
r6 := "C"
r3 := mkblock r3 4
block r3 < 1 > := r4
block r3 < 2 > := r5
block r3 < 3 > := r6
r0 := call r0 ( r1 - r3 )
_G[ "test-points" ] := r0
r0 := _G[ "2Dtree" ]
r1 := _G[ "test-points" ]
r0 := call r0 ( r1 )
_G[ "test-tree" ] := r0
r0 := _G[ "2Dpoint-value" ]
r1 := _G[ "nearest-point" ]
r2 := 11
r3 := 11
r4 := _G[ "test-tree" ]
r1 := call r1 ( r2 - r4 )
r0 := call r0 ( r1 )
check "(2Dpoint-value (nearest-point 11 11 test-tree))" r0
r0 := "A"
expect "'A" r0
