r0 := function ( 2 arguments ) {
  r0 := function ( 1 arguments ) {
    r3 := r0 < 0 >
    r4 := r0 < 1 >
    r5 := r1
    r4 := call r4 ( r5 )
    tailcall r3 ( r4 )
  }
  r0 := mkclosure r0 2
  r0 < 0 > := r1
  r0 < 1 > := r2
  return r0
}
_G[ "o" ] := r0
