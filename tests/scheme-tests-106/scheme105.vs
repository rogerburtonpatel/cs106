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
  r4 := r1 - 1
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
  r4 := r1 + 1
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
  r3 := r1 idiv r2
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
  r3 := r2 idiv r3
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
r0 := function ( 2 arguments ) {
  r3 := null? r1
  if r3 goto L65
  r3 := null? r2
  if r3 goto L67
  r3 := _G[ "check-sublist" ]
  r4 := r1
  r5 := r2
  r3 := call r3 ( r4 - r5 )
  if r3 goto L69
  r3 := _G[ "contig-sublist?" ]
  r4 := r1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L70
  L69:
  r0 := #t
  return r0
  L70:
  goto L68
  L67:
  r0 := #f
  return r0
  L68:
  goto L66
  L65:
  r0 := #t
  return r0
  L66:
}
_G[ "contig-sublist?" ] := r0
r0 := function ( 1 arguments ) {
  r2 := null? r1
  if r2 goto L71
  r2 := car r1
  r2 := null? r2
  if r2 goto L73
  r2 := _G[ "atom?" ]
  r3 := car r1
  r2 := call r2 ( r3 )
  if r2 goto L75
  r2 := _G[ "append" ]
  r3 := _G[ "flatten" ]
  r4 := car r1
  r3 := call r3 ( r4 )
  r4 := _G[ "flatten" ]
  r5 := cdr r1
  r4 := call r4 ( r5 )
  tailcall r2 ( r4 )
  goto L76
  L75:
  r2 := car r1
  r3 := _G[ "flatten" ]
  r4 := cdr r1
  r3 := call r3 ( r4 )
  r0 := r2 cons r3
  return r0
  L76:
  goto L74
  L73:
  r2 := _G[ "flatten" ]
  r3 := cdr r1
  tailcall r2 ( r3 )
  L74:
  goto L72
  L71:
  return r1
  L72:
}
_G[ "flatten" ] := r0
r0 := function ( 2 arguments ) {
  r3 := 0
  r3 := r1 = r3
  if r3 goto L77
  r3 := null? r2
  if r3 goto L79
  r3 := car r2
  r4 := _G[ "take" ]
  r5 := r1 - 1
  r6 := cdr r2
  r4 := call r4 ( r5 - r6 )
  r0 := r3 cons r4
  return r0
  goto L80
  L79:
  r0 := emptylist
  return r0
  L80:
  goto L78
  L77:
  r0 := emptylist
  return r0
  L78:
}
_G[ "take" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r2
  if r3 goto L81
  r3 := 0
  r3 := r1 = r3
  if r3 goto L83
  r3 := _G[ "drop" ]
  r4 := r1 - 1
  r5 := cdr r2
  tailcall r3 ( r5 )
  goto L84
  L83:
  return r2
  L84:
  goto L82
  L81:
  r0 := emptylist
  return r0
  L82:
}
_G[ "drop" ] := r0
r0 := function ( 2 arguments ) {
  r3 := null? r1
  if r3 goto L85
  r3 := cdr r1
  r3 := null? r3
  if r3 goto L87
  r3 := _G[ "list2" ]
  r4 := car r1
  r5 := car r2
  r3 := call r3 ( r4 - r5 )
  r4 := _G[ "zip" ]
  r5 := cdr r1
  r6 := cdr r2
  r4 := call r4 ( r5 - r6 )
  r0 := r3 cons r4
  return r0
  goto L88
  L87:
  r3 := _G[ "list2" ]
  r4 := car r1
  r5 := car r2
  r3 := call r3 ( r4 - r5 )
  r4 := emptylist
  r0 := r3 cons r4
  return r0
  L88:
  goto L86
  L85:
  r0 := emptylist
  return r0
  L86:
}
_G[ "zip" ] := r0
r0 := function ( 3 arguments ) {
  r4 := null? r2
  if r4 goto L89
  r4 := _G[ "unzip-half" ]
  r5 := r1
  r6 := cdr r2
  r7 := r1
  r8 := r2
  r7 := call r7 ( r8 )
  r7 := r7 cons r3
  tailcall r4 ( r7 )
  goto L90
  L89:
  r4 := _G[ "reverse" ]
  r5 := r3
  tailcall r4 ( r5 )
  L90:
}
_G[ "unzip-half" ] := r0
r0 := function ( 1 arguments ) {
  r2 := null? r1
  if r2 goto L91
  r2 := _G[ "list2" ]
  r3 := _G[ "unzip-half" ]
  r4 := _G[ "caar" ]
  r5 := r1
  r6 := emptylist
  r3 := call r3 ( r4 - r6 )
  r4 := _G[ "unzip-half" ]
  r5 := _G[ "cadar" ]
  r6 := r1
  r7 := emptylist
  r4 := call r4 ( r5 - r7 )
  tailcall r2 ( r4 )
  goto L92
  L91:
  r0 := emptylist
  return r0
  L92:
}
_G[ "unzip" ] := r0
r0 := function ( 1 arguments ) {
  r0 := r1 * r1
  return r0
}
_G[ "square" ] := r0
r0 := function ( 3 arguments ) {
  r4 := cdr r3
  r4 := null? r4
  if r4 goto L93
  r4 := r1
  r5 := car r3
  r4 := call r4 ( r5 )
  r5 := r1
  r6 := r2
  r5 := call r5 ( r6 )
  r4 := r4 > r5
  if r4 goto L95
  r4 := _G[ "set-arg-max" ]
  r5 := r1
  r6 := r2
  r7 := cdr r3
  tailcall r4 ( r7 )
  goto L96
  L95:
  r4 := _G[ "set-arg-max" ]
  r5 := r1
  r6 := car r3
  r7 := cdr r3
  tailcall r4 ( r7 )
  L96:
  goto L94
  L93:
  r4 := r1
  r5 := car r3
  r4 := call r4 ( r5 )
  r5 := r1
  r6 := r2
  r5 := call r5 ( r6 )
  r4 := r4 > r5
  if r4 goto L97
  return r2
  goto L98
  L97:
  r0 := car r3
  return r0
  L98:
  L94:
}
_G[ "set-arg-max" ] := r0
r0 := function ( 2 arguments ) {
  r3 := cdr r2
  r3 := null? r3
  if r3 goto L99
  r3 := _G[ "set-arg-max" ]
  r4 := r1
  r5 := car r2
  r6 := cdr r2
  tailcall r3 ( r6 )
  goto L100
  L99:
  r0 := car r2
  return r0
  L100:
}
_G[ "arg-max" ] := r0
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
r0 := _G[ "contig-sublist?" ]
r1 := emptylist
r2 := emptylist
r0 := call r0 ( r1 - r2 )
check-assert "(contig-sublist? '() '())" r0
r0 := _G[ "contig-sublist?" ]
r1 := emptylist
r2 := 1
r3 := emptylist
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check-assert "(contig-sublist? '() '(1))" r0
r0 := _G[ "contig-sublist?" ]
r1 := 1
r2 := emptylist
r1 := r1 cons r2
r2 := emptylist
r0 := call r0 ( r1 - r2 )
r0 := not r0
check-assert "(not (contig-sublist? '(1) '()))" r0
r0 := _G[ "contig-sublist?" ]
r1 := 1
r2 := emptylist
r1 := r1 cons r2
r2 := 0
r3 := 1
r4 := 2
r5 := 3
r6 := 4
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check-assert "(contig-sublist? '(1) '(0 1 2 3 4))" r0
r0 := _G[ "contig-sublist?" ]
r1 := 1
r2 := 2
r3 := 3
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 0
r3 := 1
r4 := 2
r5 := 3
r6 := 4
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check-assert "(contig-sublist? '(1 2 3) '(0 1 2 3 4))" r0
r0 := _G[ "contig-sublist?" ]
r1 := 1
r2 := 2
r3 := 5
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 0
r3 := 1
r4 := 2
r5 := 4
r6 := 4
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
r0 := not r0
check-assert "(not (contig-sublist? '(1 2 5) '(0 1 2 4 4)))" r0
r0 := _G[ "contig-sublist?" ]
r1 := 1
r2 := 2
r3 := 5
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 0
r3 := 1
r4 := 2
r5 := 4
r6 := 5
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
r0 := not r0
check-assert "(not (contig-sublist? '(1 2 5) '(0 1 2 4 5)))" r0
r0 := _G[ "flatten" ]
r1 := emptylist
r0 := call r0 ( r1 )
check "(flatten '())" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "flatten" ]
r1 := "a"
r2 := emptylist
r1 := r1 cons r2
r2 := emptylist
r1 := r1 cons r2
r2 := emptylist
r1 := r1 cons r2
r2 := emptylist
r1 := r1 cons r2
r0 := call r0 ( r1 )
check "(flatten '((((a)))))" r0
r0 := "a"
r1 := emptylist
r0 := r0 cons r1
expect "'(a)" r0
r0 := _G[ "flatten" ]
r1 := "I"
r2 := "Ching"
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := "U"
r3 := "Thant"
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r3 := "E"
r4 := "Coli"
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := call r0 ( r1 )
check "(flatten '((I Ching) (U Thant) (E Coli)))" r0
r0 := "I"
r1 := "Ching"
r2 := "U"
r3 := "Thant"
r4 := "E"
r5 := "Coli"
r6 := emptylist
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(I Ching U Thant E Coli)" r0
r0 := _G[ "flatten" ]
r1 := "a"
r2 := emptylist
r1 := r1 cons r2
r2 := emptylist
r3 := "b"
r4 := "c"
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r4 := "d"
r5 := "e"
r6 := emptylist
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := call r0 ( r1 )
check "(flatten '((a) () ((b c) d e)))" r0
r0 := "a"
r1 := "b"
r2 := "c"
r3 := "d"
r4 := "e"
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(a b c d e)" r0
r0 := _G[ "take" ]
r1 := 0
r2 := emptylist
r0 := call r0 ( r1 - r2 )
check "(take 0 '())" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "take" ]
r1 := 9
r2 := emptylist
r0 := call r0 ( r1 - r2 )
check "(take 9 '())" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "take" ]
r1 := 3
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(take 3 '(1 2 3))" r0
r0 := 1
r1 := 2
r2 := 3
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(1 2 3)" r0
r0 := _G[ "take" ]
r1 := 2
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(take 2 '(1 2 3))" r0
r0 := 1
r1 := 2
r2 := emptylist
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(1 2)" r0
r0 := _G[ "take" ]
r1 := 4
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(take 4 '(1 2 3))" r0
r0 := 1
r1 := 2
r2 := 3
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(1 2 3)" r0
r0 := _G[ "drop" ]
r1 := 9
r2 := emptylist
r0 := call r0 ( r1 - r2 )
check "(drop 9 '())" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "drop" ]
r1 := 0
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(drop 0 '(1 2 3))" r0
r0 := 1
r1 := 2
r2 := 3
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(1 2 3)" r0
r0 := _G[ "drop" ]
r1 := 3
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(drop 3 '(1 2 3))" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "drop" ]
r1 := 2
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(drop 2 '(1 2 3))" r0
r0 := 3
r1 := emptylist
r0 := r0 cons r1
expect "'(3)" r0
r0 := _G[ "drop" ]
r1 := 4
r2 := 1
r3 := 2
r4 := 3
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(drop 4 '(1 2 3))" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "zip" ]
r1 := emptylist
r2 := emptylist
r0 := call r0 ( r1 - r2 )
check "(zip '() '())" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "zip" ]
r1 := 1
r2 := emptylist
r1 := r1 cons r2
r2 := "a"
r3 := emptylist
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(zip '(1) '(a))" r0
r0 := 1
r1 := "a"
r2 := emptylist
r1 := r1 cons r2
r0 := r0 cons r1
r1 := emptylist
r0 := r0 cons r1
expect "'((1 a))" r0
r0 := _G[ "zip" ]
r1 := 1
r2 := 2
r3 := 3
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r2 := "a"
r3 := "b"
r4 := "c"
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(zip '(1 2 3) '(a b c))" r0
r0 := 1
r1 := "a"
r2 := emptylist
r1 := r1 cons r2
r0 := r0 cons r1
r1 := 2
r2 := "b"
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := 3
r3 := "c"
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'((1 a) (2 b) (3 c))" r0
r0 := _G[ "unzip-half" ]
r1 := function ( 1 arguments ) {
  r0 := car r1
  return r0
}
r2 := emptylist
r3 := _G[ "reverse" ]
r4 := 1
r5 := 2
r6 := emptylist
r5 := r5 cons r6
r4 := r4 cons r5
r3 := call r3 ( r4 )
r0 := call r0 ( r1 - r3 )
check "(unzip-half car '() (reverse '(1 2)))" r0
r0 := 1
r1 := 2
r2 := emptylist
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(1 2)" r0
r0 := _G[ "unzip-half" ]
r1 := function ( 1 arguments ) {
  r0 := car r1
  return r0
}
r2 := 1
r3 := 2
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r3 := 1
r4 := 2
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r0 := call r0 ( r1 - r3 )
check "(unzip-half car '(1 2) '(1 2))" r0
r0 := 2
r1 := 1
r2 := 1
r3 := 2
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
expect "'(2 1 1 2)" r0
r0 := _G[ "unzip" ]
r1 := emptylist
r0 := call r0 ( r1 )
check "(unzip '())" r0
r0 := emptylist
expect "'()" r0
r0 := _G[ "unzip" ]
r1 := 1
r2 := 2
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := emptylist
r1 := r1 cons r2
r0 := call r0 ( r1 )
check "(unzip '((1 2)))" r0
r0 := 1
r1 := emptylist
r0 := r0 cons r1
r1 := 2
r2 := emptylist
r1 := r1 cons r2
r2 := emptylist
r1 := r1 cons r2
r0 := r0 cons r1
expect "'((1) (2))" r0
r0 := _G[ "unzip" ]
r1 := "I"
r2 := "Magnin"
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r2 := "U"
r3 := "Thant"
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r3 := "E"
r4 := "Coli"
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := call r0 ( r1 )
check "(unzip '((I Magnin) (U Thant) (E Coli)))" r0
r0 := "I"
r1 := "U"
r2 := "E"
r3 := emptylist
r2 := r2 cons r3
r1 := r1 cons r2
r0 := r0 cons r1
r1 := "Magnin"
r2 := "Thant"
r3 := "Coli"
r4 := emptylist
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r2 := emptylist
r1 := r1 cons r2
r0 := r0 cons r1
expect "'((I U E) (Magnin Thant Coli))" r0
r0 := _G[ "set-arg-max" ]
r1 := _G[ "square" ]
r2 := 0
r3 := 5
r4 := emptylist
r3 := r3 cons r4
r0 := call r0 ( r1 - r3 )
check "(set-arg-max square 0 '(5))" r0
r0 := 5
expect "5" r0
r0 := _G[ "set-arg-max" ]
r1 := _G[ "square" ]
r2 := 9
r3 := 8
r4 := 7
r5 := emptylist
r4 := r4 cons r5
r3 := r3 cons r4
r0 := call r0 ( r1 - r3 )
check "(set-arg-max square 9 '(8 7))" r0
r0 := 9
expect "9" r0
r0 := _G[ "set-arg-max" ]
r1 := _G[ "square" ]
r2 := 10
r3 := 0
r4 := 10
r5 := 0
r6 := 0
r7 := 0
r8 := emptylist
r7 := r7 cons r8
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r0 := call r0 ( r1 - r3 )
check "(set-arg-max square 10 '(0 10 0 0 0))" r0
r0 := 10
expect "10" r0
r0 := _G[ "arg-max" ]
r1 := _G[ "square" ]
r2 := 5
r3 := 4
r4 := 3
r5 := 2
r6 := 1
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(arg-max square '(5 4 3 2 1))" r0
r0 := 5
expect "5" r0
r0 := _G[ "arg-max" ]
r1 := _G[ "square" ]
r2 := 8
r3 := 7
r4 := 9
r5 := 7
r6 := 7
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(arg-max square '(8 7 9 7 7))" r0
r0 := 9
expect "9" r0
r0 := _G[ "arg-max" ]
r1 := _G[ "square" ]
r2 := 0
r3 := 0
r4 := 0
r5 := 0
r6 := 0
r7 := emptylist
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r0 := call r0 ( r1 - r2 )
check "(arg-max square '(0 0 0 0 0))" r0
r0 := 0
expect "0" r0
