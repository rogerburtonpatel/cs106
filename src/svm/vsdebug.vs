r0 := function ( 2 arguments ) {
  r3 := _G[ "nth" ]
  r4 := 1
  r4 := r1 + r4
  r5 := r2
  tailcall r3 ( r5 )
}
_G[ "CAPTURED-IN" ] := r0
r0 := function ( 2 arguments ) {
  r3 := car r1
  r4 := car r2
  r3 := r3 = r4
  if r3 goto L1
  r0 := #f
  return r0
  goto L2
  L1:
  r3 := cdr r1
  r3 := null? r3
  if r3 goto L3
  r3 := _G[ "check-sublist" ]
  r4 := cdr r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L4
  L3:
  r0 := #t
  return r0
  L4:
  L2:
}
_G[ "check-sublist" ] := r0
r0 := _G[ "check-sublist" ]
r1 := 1
r2 := 2
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5 ; bug line
r3 := r3 cons r4
r2 := r2 cons r3 ; new bug line?
r0 := call r0 ( r1 - r2 )
check-assert "(check-sublist '(1 2) '(1 2 3))" r0
