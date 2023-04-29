r0 := function ( 1 arguments ) {
  switch r1 {
    case "C1" (2): goto L1
  }
  r0 := "four"
  return r0
  L1:
  r2 := block r1 < 1 >
  switch r2 {
    case "C2" (0): goto L2
  }
  r3 := block r1 < 2 >
  switch r3 {
    case "C4" (0): goto L6
    case "C5" (0): goto L7
  }
  r0 := "four"
  return r0
  L6:
  r0 := "two"
  return r0
  L7:
  r0 := "three"
  return r0
  L2:
  r3 := block r1 < 2 >
  switch r3 {
    case "C3" (0): goto L3
    case "C4" (0): goto L4
    case "C5" (0): goto L5
  }
  r0 := "four"
  return r0
  L3:
  r0 := "one"
  return r0
  L4:
  r0 := "two"
  return r0
  L5:
  r0 := "three"
  return r0
}
_G[ "figure-6" ] := r0
r0 := _G[ "figure-6" ]
r1 := "C1"
r2 := "C2"
r2 := mkblock r2 1
r3 := "C3"
r3 := mkblock r3 1
r1 := mkblock r1 3
block r1 < 1 > := r2
block r1 < 2 > := r3
r0 := call r0 ( r1 )
check "(figure-6 ('C1 'C2 'C3))" r0
r0 := "one"
expect "'one" r0
r0 := _G[ "figure-6" ]
r1 := "C1"
r2 := 3
r3 := "C4"
r3 := mkblock r3 1
r1 := mkblock r1 3
block r1 < 1 > := r2
block r1 < 2 > := r3
r0 := call r0 ( r1 )
check "(figure-6 ('C1 3 'C4))" r0
r0 := "two"
expect "'two" r0
r0 := _G[ "figure-6" ]
r1 := "C1"
r2 := 3
r3 := "C5"
r3 := mkblock r3 1
r1 := mkblock r1 3
block r1 < 1 > := r2
block r1 < 2 > := r3
r0 := call r0 ( r1 )
check "(figure-6 ('C1 3 'C5))" r0
r0 := "three"
expect "'three" r0
r0 := _G[ "figure-6" ]
r1 := "C1"
r2 := 3
r3 := "C6"
r3 := mkblock r3 1
r1 := mkblock r1 3
block r1 < 1 > := r2
block r1 < 2 > := r3
r0 := call r0 ( r1 )
check "(figure-6 ('C1 3 'C6))" r0
r0 := "four"
expect "'four" r0
