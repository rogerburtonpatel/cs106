r0 := function ( 1 arguments ) {
  r2 := emptylist
  goto L1
  L2:
  r2 := r1 cons r2
  r3 := 1
  r1 := r1 - r3
  L1:
  r3 := 0
  r3 := r1 > r3
  if r3 goto L2
  return r2
}
_G[ "iota" ] := r0
r0 := function ( 1 arguments ) {
  r2 := #f
  goto L3
  L4:
  r3 := _G[ "iota" ]
  r4 := r1
  r2 := call r3 ( r4 )
  r3 := 1
  r1 := r1 - r3
  L3:
  r3 := 0
  r3 := r1 > r3
  if r3 goto L4
  return r2
}
_G[ "allocate" ] := r0
r0 := _G[ "iota" ]
r1 := 8
r0 := call r0 ( r1 )
check "(iota 8)" r0
r0 := 1
r1 := 2
r2 := 3
r3 := 4
r4 := 5
r5 := 6
r6 := 7
r7 := 8
r8 := emptylist
r7 := r7 cons r8
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(1 2 3 4 5 6 7 8)" r0
r0 := _G[ "allocate" ]
r1 := 1000
r0 := call r0 ( r1 )
check "(allocate 1000)" r0
r0 := 1
r1 := emptylist
r0 := r0 cons r1
expect "'(1)" r0
