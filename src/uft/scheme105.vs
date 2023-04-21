r0 := function ( 1 arguments ) {
  r2 := car r1
  r0 := car r2
  return r0
}
_G[ "caar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := cdr r1
  r0 := car r2
  return r0
}
_G[ "cadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := car r1
  r0 := cdr r2
  return r0
}
_G[ "cdar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := cdr r1
  r0 := cdr r2
  return r0
}
_G[ "cddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caaar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cadr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "cadar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cddr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdaar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cadr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cddar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cddr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caaar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caaaar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caadr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caaadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cadar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caadar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caddr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caaddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdaar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "cadaar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdadr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "cadadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cddar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "caddar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdddr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := car r2
  return r0
}
_G[ "cadddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caaar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdaaar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caadr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdaadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cadar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdadar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "caddr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdaddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdaar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cddaar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdadr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cddadr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cddar" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cdddar" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cdddr" ]
  r3 := r1
  r2 := call r2 ( r3 )
  r0 := cdr r2
  return r0
}
_G[ "cddddr" ] := r0
r0 := function ( 1 arguments ) {
  r2 := emptylist
  r0 := r1 cons r2
  return r0
}
_G[ "list1" ] := r0
r0 := function ( 2 arguments ) {
  r3 := _G[ "list1" ]
  r4 := r2
  r3 := call r3 ( r4 )
  r0 := r1 cons r3
  return r0
}
_G[ "list2" ] := r0
r0 := function ( 3 arguments ) {
  r4 := _G[ "list2" ]
  r5 := r2
  r6 := r3
  r4 := call r4 ( r5 - r6 )
  r0 := r1 cons r4
  return r0
}
_G[ "list3" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r1
  if r3 goto L1
  r3 := car r1
  r4 := _G[ "append" ]
  r5 := cdr r1
  r6 := r2
  r4 := call r4 ( r5 - r6 )
  r0 := r3 cons r4
  return r0
  goto L2
  L1:
  return r2
  L2:
}
_G[ "append" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r1
  if r3 goto L3
  r3 := _G[ "revapp" ]
  r4 := cdr r1
  r5 := car r1
  r5 := r5 cons r2
  tailcall r3 ( r5 )
  goto L4
  L3:
  return r2
  L4:
}
_G[ "revapp" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "revapp" ]
  r3 := r1
  r4 := emptylist
  tailcall r2 ( r4 )
}
_G[ "reverse" ] := r0
r0 := function ( 2 arguments ) {
  r3 := 0
  r3 := r1 = r3
  if r3 goto L5
  r3 := _G[ "nth" ]
  r4 := 1
  r4 := r1 - r4
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L6
  L5:
  r0 := car r2
  return r0
  L6:
}
_G[ "nth" ] := r0
r0 := function ( 2 arguments ) {
  r3 := _G[ "nth" ]
  r4 := 1
  r4 := r1 + r4
  r5 := r2
  tailcall r3 ( r5 )
}
_G[ "CAPTURED-IN" ] := r0
r0 := function ( 2 arguments ) {
  if r1 goto L7
  return r1
  goto L8
  L7:
  return r2
  L8:
}
_G[ "and" ] := r0
r0 := function ( 2 arguments ) {
  if r1 goto L9
  return r2
  goto L10
  L9:
  return r1
  L10:
}
_G[ "or" ] := r0
r0 := function ( 1 arguments ) {
  if r1 goto L11
  r0 := #t
  return r0
  goto L12
  L11:
  r0 := #f
  return r0
  L12:
}
_G[ "not" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "or" ]
  r3 := symbol? r1
  r4 := _G[ "or" ]
  r5 := number? r1
  r6 := _G[ "or" ]
  r7 := boolean? r1
  r8 := null? r1
  r6 := call r6 ( r7 - r8 )
  r4 := call r4 ( r5 - r6 )
  tailcall r2 ( r4 )
}
_G[ "atom?" ] := r0
r0 := function ( 2 arguments ) {
  r3 := _G[ "atom?" ]
  r4 := r1
  r3 := call r3 ( r4 )
  if r3 goto L13
  r3 := _G[ "atom?" ]
  r4 := r2
  r3 := call r3 ( r4 )
  if r3 goto L15
  r3 := _G[ "and" ]
  r4 := _G[ "equal?" ]
  r5 := car r1
  r6 := car r2
  r4 := call r4 ( r5 - r6 )
  r5 := _G[ "equal?" ]
  r6 := cdr r1
  r7 := cdr r2
  r5 := call r5 ( r6 - r7 )
  tailcall r3 ( r5 )
  goto L16
  L15:
  r0 := #f
  return r0
  L16:
  goto L14
  L13:
  r0 := r1 = r2
  return r0
  L14:
}
_G[ "equal?" ] := r0
r0 := function ( 2 arguments ) {
  r3 := _G[ "list2" ]
  r4 := r1
  r5 := r2
  tailcall r3 ( r5 )
}
_G[ "make-alist-pair" ] := r0
r0 := function ( 1 arguments ) {
  r0 := car r1
  return r0
}
_G[ "alist-pair-key" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "cadr" ]
  r3 := r1
  tailcall r2 ( r3 )
}
_G[ "alist-pair-attribute" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "alist-pair-key" ]
  r3 := car r1
  tailcall r2 ( r3 )
}
_G[ "alist-first-key" ] := r0
r0 := function ( 1 arguments ) {
  r2 := _G[ "alist-pair-attribute" ]
  r3 := car r1
  tailcall r2 ( r3 )
}
_G[ "alist-first-attribute" ] := r0
r0 := function ( 3 arguments ) {
  r4 := null? r3
  if r4 goto L17
  r4 := _G[ "equal?" ]
  r5 := r1
  r6 := _G[ "alist-first-key" ]
  r7 := r3
  r6 := call r6 ( r7 )
  r4 := call r4 ( r5 - r6 )
  if r4 goto L19
  r4 := car r3
  r5 := _G[ "bind" ]
  r6 := r1
  r7 := r2
  r8 := cdr r3
  r5 := call r5 ( r6 - r8 )
  r0 := r4 cons r5
  return r0
  goto L20
  L19:
  r4 := _G[ "make-alist-pair" ]
  r5 := r1
  r6 := r2
  r4 := call r4 ( r5 - r6 )
  r5 := cdr r3
  r0 := r4 cons r5
  return r0
  L20:
  goto L18
  L17:
  r4 := _G[ "list1" ]
  r5 := _G[ "make-alist-pair" ]
  r6 := r1
  r7 := r2
  r5 := call r5 ( r6 - r7 )
  tailcall r4 ( r5 )
  L18:
}
_G[ "bind" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L21
  r3 := _G[ "equal?" ]
  r4 := r1
  r5 := _G[ "alist-first-key" ]
  r6 := r2
  r5 := call r5 ( r6 )
  r3 := call r3 ( r4 - r5 )
  if r3 goto L23
  r3 := _G[ "find" ]
  r4 := r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L24
  L23:
  r3 := _G[ "alist-first-attribute" ]
  r4 := r2
  tailcall r3 ( r4 )
  L24:
  goto L22
  L21:
  r0 := emptylist
  return r0
  L22:
}
_G[ "find" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L25
  r3 := r1
  r4 := car r2
  r3 := call r3 ( r4 )
  if r3 goto L27
  r3 := _G[ "filter" ]
  r4 := r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L28
  L27:
  r3 := car r2
  r4 := _G[ "filter" ]
  r5 := r1
  r6 := cdr r2
  r4 := call r4 ( r5 - r6 )
  r0 := r3 cons r4
  return r0
  L28:
  goto L26
  L25:
  r0 := emptylist
  return r0
  L26:
}
_G[ "filter" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L29
  r3 := r1
  r4 := car r2
  r3 := call r3 ( r4 )
  r4 := _G[ "map" ]
  r5 := r1
  r6 := cdr r2
  r4 := call r4 ( r5 - r6 )
  r0 := r3 cons r4
  return r0
  goto L30
  L29:
  r0 := emptylist
  return r0
  L30:
}
_G[ "map" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L31
  r3 := r1
  r4 := car r2
  r3 := call r3 ( r4 )
  r3 := _G[ "app" ]
  r4 := r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L32
  L31:
  r0 := #f
  return r0
  L32:
}
_G[ "app" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L33
  r3 := r1
  r4 := car r2
  r3 := call r3 ( r4 )
  if r3 goto L35
  r3 := _G[ "exists?" ]
  r4 := r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L36
  L35:
  r0 := #t
  return r0
  L36:
  goto L34
  L33:
  r0 := #f
  return r0
  L34:
}
_G[ "exists?" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L37
  r3 := r1
  r4 := car r2
  r3 := call r3 ( r4 )
  if r3 goto L39
  r0 := #f
  return r0
  goto L40
  L39:
  r3 := _G[ "all?" ]
  r4 := r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  L40:
  goto L38
  L37:
  r0 := #t
  return r0
  L38:
}
_G[ "all?" ] := r0
r0 := function ( 3 arguments ) {
  r4 := null? r3
  if r4 goto L41
  r4 := r1
  r5 := car r3
  r6 := _G[ "foldr" ]
  r7 := r1
  r8 := r2
  r9 := cdr r3
  r6 := call r6 ( r7 - r9 )
  tailcall r4 ( r6 )
  goto L42
  L41:
  return r2
  L42:
}
_G[ "foldr" ] := r0
r0 := function ( 3 arguments ) {
  r4 := null? r3
  if r4 goto L43
  r4 := _G[ "foldl" ]
  r5 := r1
  r6 := r1
  r7 := car r3
  r8 := r2
  r6 := call r6 ( r7 - r8 )
  r7 := cdr r3
  tailcall r4 ( r7 )
  goto L44
  L43:
  return r2
  L44:
}
_G[ "foldl" ] := r0
r0 := 10
_G[ "newline" ] := r0
r0 := 40
_G[ "left-round" ] := r0
r0 := 32
_G[ "space" ] := r0
r0 := 41
_G[ "right-round" ] := r0
r0 := 59
_G[ "semicolon" ] := r0
r0 := 123
_G[ "left-curly" ] := r0
r0 := 39
_G[ "quotemark" ] := r0
r0 := 125
_G[ "right-curly" ] := r0
r0 := 91
_G[ "left-square" ] := r0
r0 := 93
_G[ "right-square" ] := r0
r0 := function ( 2 arguments ) {
  r3 := r1 > r2
  r0 := not r3
  return r0
}
_G[ "<=" ] := r0
r0 := function ( 2 arguments ) {
  r3 := r1 < r2
  r0 := not r3
  return r0
}
_G[ ">=" ] := r0
r0 := function ( 2 arguments ) {
  r3 := r1 = r2
  r0 := not r3
  return r0
}
_G[ "!=" ] := r0
r0 := function ( 2 arguments ) {
  r3 := r1 > r2
  if r3 goto L45
  return r2
  goto L46
  L45:
  return r1
  L46:
}
_G[ "max" ] := r0
r0 := function ( 2 arguments ) {
  r3 := r1 < r2
  if r3 goto L47
  return r2
  goto L48
  L47:
  return r1
  L48:
}
_G[ "min" ] := r0
r0 := function ( 1 arguments ) {
  r2 := 0
  r0 := r2 - r1
  return r0
}
_G[ "negated" ] := r0
r0 := function ( 2 arguments ) {
  an unknown register-based assembly-code instruction
  r3 := r2 * r3
  r0 := r1 - r3
  return r0
}
_G[ "mod" ] := r0
r0 := function ( 2 arguments ) {
  r3 := 0
  r3 := r2 = r3
  if r3 goto L49
  r3 := _G[ "gcd" ]
  r4 := r2
  r5 := r1 mod r2
  tailcall r3 ( r5 )
  goto L50
  L49:
  return r1
  L50:
}
_G[ "gcd" ] := r0
r0 := function ( 2 arguments ) {
  r3 := 0
  r3 := r1 = r3
  if r3 goto L51
  r3 := _G[ "gcd" ]
  r4 := r1
  r5 := r2
  r3 := call r3 ( r4 - r5 )
  an unknown register-based assembly-code instruction
  r0 := r1 * r3
  return r0
  goto L52
  L51:
  r0 := 0
  return r0
  L52:
}
_G[ "lcm" ] := r0
r0 := function ( 4 arguments ) {
  r5 := _G[ "list3" ]
  r6 := r2
  r7 := r3
  r8 := r4
  r5 := call r5 ( r6 - r8 )
  r0 := r1 cons r5
  return r0
}
_G[ "list4" ] := r0
r0 := function ( 5 arguments ) {
  r6 := _G[ "list4" ]
  r7 := r2
  r8 := r3
  r9 := r4
  r10 := r5
  r6 := call r6 ( r7 - r10 )
  r0 := r1 cons r6
  return r0
}
_G[ "list5" ] := r0
r0 := function ( 6 arguments ) {
  r7 := _G[ "list5" ]
  r8 := r2
  r9 := r3
  r10 := r4
  r11 := r5
  r12 := r6
  r7 := call r7 ( r8 - r12 )
  r0 := r1 cons r7
  return r0
}
_G[ "list6" ] := r0
r0 := function ( 7 arguments ) {
  r8 := _G[ "list6" ]
  r9 := r2
  r10 := r3
  r11 := r4
  r12 := r5
  r13 := r6
  r14 := r7
  r8 := call r8 ( r9 - r14 )
  r0 := r1 cons r8
  return r0
}
_G[ "list7" ] := r0
r0 := function ( 8 arguments ) {
  r9 := _G[ "list7" ]
  r10 := r2
  r11 := r3
  r12 := r4
  r13 := r5
  r14 := r6
  r15 := r7
  r16 := r8
  r9 := call r9 ( r10 - r16 )
  r0 := r1 cons r9
  return r0
}
_G[ "list8" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L53
  r3 := car r2
  r4 := cdr r2
  r5 := _G[ "equal?" ]
  r6 := r1
  r7 := car r3
  r5 := call r5 ( r6 - r7 )
  if r5 goto L55
  r5 := _G[ "assoc" ]
  r6 := r1
  r7 := r4
  tailcall r5 ( r7 )
  goto L56
  L55:
  return r3
  L56:
  goto L54
  L53:
  r0 := #f
  return r0
  L54:
}
_G[ "assoc" ] := r0
r0 := function ( 0 arguments ) {
  r1 := _G[ "nil" ]
  r2 := emptylist
  r0 := r1 cons r2
  return r0
}
_G[ "Table.new" ] := r0
r0 := function ( 2 arguments ) {
  r3 := _G[ "assoc" ]
  r4 := r2
  r5 := cdr r1
  r3 := call r3 ( r4 - r5 )
  if r3 goto L57
  r0 := _G[ "nil" ]
  return r0
  goto L58
  L57:
  r0 := cdr r3
  return r0
  L58:
}
_G[ "Table.get" ] := r0
r0 := function ( 3 arguments ) {
  r4 := _G[ "assoc" ]
  r5 := r2
  r6 := cdr r1
  r4 := call r4 ( r5 - r6 )
  if r4 goto L59
  r5 := _G[ "set-cdr!" ]
  r6 := r1
  r7 := r2 cons r3
  r8 := cdr r1
  r7 := r7 cons r8
  tailcall r5 ( r7 )
  goto L60
  L59:
  r5 := _G[ "set-cdr!" ]
  r6 := r4
  r7 := r3
  tailcall r5 ( r7 )
  L60:
}
_G[ "Table.put" ] := r0
r0 := function ( 2 arguments ) {
  r3 := _G[ "equal?" ]
  r4 := car r1
  r5 := car r2
  r3 := call r3 ( r4 - r5 )
  if r3 goto L61
  r0 := #f
  return r0
  goto L62
  L61:
  r3 := cdr r1
  r3 := null? r3
  if r3 goto L63
  r3 := _G[ "check-sublist" ]
  r4 := cdr r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L64
  L63:
  r0 := #t
  return r0
  L64:
  L62:
}
_G[ "check-sublist" ] := r0
r0 := _G[ "check-sublist" ]
r1 := 1
r2 := emptylist
r1 := r1 cons r2
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check-assert "(check-sublist '(1) '(1 2 3))" r0
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
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check-assert "(check-sublist '(1 2) '(1 2 3))" r0
r0 := _G[ "check-sublist" ]
r1 := 2
r2 := 2
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
r0 := not r0
check-assert "(not (check-sublist '(2 2) '(1 2 3)))" r0
