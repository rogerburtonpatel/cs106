r0 := function ( 3 arguments ) {
  switch r1 {
    case emptylist (0): goto L1
    case "cons" (2): goto L2
  }
  r0 := "effectful primitive error used in register-setting context on register r0"
  error r0
  return r0
  L1:
  r4 := "PAIR"
  r0 := mkblock r4 3
  block r0 < 0 > := r2
  block r0 < 1 > := r3
  L2:
  r4 := block r1 < 1 >
  r5 := block r1 < 2 >
  r6 := _G[ "split" ]
  r7 := r5
  r8 := r3
  r9 := r4 cons r2
  r9 := r9
  tailcall r6 ( r9 )
}
_G[ "split" ] := r0
r0 := _G[ "split" ]
r1 := 1
r2 := 2
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := emptylist
r3 := emptylist
r0 := call r0 ( r1 - r3 )
check "(split '(1 2) '() '())" r0
r0 := "PAIR"
r1 := 1
r2 := emptylist
r1 := r1 cons r2
r2 := 2
r3 := emptylist
r2 := r2 cons r3
r0 := mkblock r0 3
block r0 < 0 > := r1
block r0 < 1 > := r2
expect "('PAIR '(1) '(2))" r0
r0 := _G[ "split" ]
r1 := 1
r2 := 2
r3 := 3
r4 := 4
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r2 := emptylist
r3 := emptylist
r0 := call r0 ( r1 - r3 )
check "(split '(1 2 3 4) '() '())" r0
r0 := "PAIR"
r1 := 3
r2 := 1
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 4
r3 := 2
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r0 := mkblock r0 3
block r0 < 0 > := r1
block r0 < 1 > := r2
expect "('PAIR '(3 1) '(4 2))" r0
