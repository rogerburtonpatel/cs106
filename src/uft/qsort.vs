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
r0 := function ( 1 arguments ) {
  r0 := function ( 1 arguments ) {
    r2 := r0 < 0 >
    r0 := function ( 1 arguments ) {
      r2 := r0 < 0 >
      r3 := r0 < 1 >
      r4 := r1
      tailcall r2 ( r4 )
    }
    r0 := mkclosure r0 2
    r0 < 0 > := r2
    r0 < 1 > := r1
    return r0
  }
  r0 := mkclosure r0 1
  r0 < 0 > := r1
  return r0
}
_G[ "curry" ] := r0
r0 := function ( 1 arguments ) {
  r0 := function ( 2 arguments ) {
    r3 := r0 < 0 >
    r4 := r1
    r3 := call r3 ( r4 )
    r4 := r2
    tailcall r3 ( r4 )
  }
  r0 := mkclosure r0 1
  r0 < 0 > := r1
  return r0
}
_G[ "uncurry" ] := r0
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
r0 := function ( 1 arguments ) {
  r2 := null? r1
  if r2 goto L61
  r2 := car r1
  r3 := cdr r1
  r4 := function ( 1 arguments ) {
    r4 := r0 < 0 >
    r0 := r1 > r4
    return r0
  }
  r4 := mkclosure r4 1
  r4 < 0 > := r2
  r5 := _G[ "o" ]
  r6 := function ( 1 arguments ) {
    r0 := not r1
    return r0
  }
  r7 := r4
  r5 := call r5 ( r6 - r7 )
  r6 := _G[ "append" ]
  r7 := _G[ "qsort" ]
  r8 := _G[ "filter" ]
  r9 := r5
  r10 := r3
  r8 := call r8 ( r9 - r10 )
  r7 := call r7 ( r8 )
  r8 := _G[ "qsort" ]
  r9 := _G[ "filter" ]
  r10 := r4
  r11 := r3
  r9 := call r9 ( r10 - r11 )
  r8 := call r8 ( r9 )
  r8 := r2 cons r8
  tailcall r6 ( r8 )
  goto L62
  L61:
  r0 := emptylist
  return r0
  L62:
}
_G[ "qsort" ] := r0
r0 := function ( 1 arguments ) {
  r2 := 0
  r2 := r1 = r2
  if r2 goto L63
  r2 := _G[ "iota^" ]
  r3 := 1
  r3 := r1 - r3
  r2 := call r2 ( r3 )
  r0 := r1 cons r2
  return r0
  goto L64
  L63:
  r0 := emptylist
  return r0
  L64:
}
_G[ "iota^" ] := r0
r0 := _G[ "qsort" ]
r1 := 65
r2 := 15
r3 := 87
r4 := 42
r5 := 62
r6 := 45
r7 := 6
r8 := 81
r9 := 53
r10 := 34
r11 := 33
r12 := 82
r13 := 79
r14 := 7
r15 := 17
r16 := 39
r17 := 71
r18 := 18
r19 := 98
r20 := 92
r21 := 77
r22 := 41
r23 := 51
r24 := 16
r25 := 86
r26 := 30
r27 := 49
r28 := 10
r29 := 4
r30 := 68
r31 := 35
r32 := 52
r33 := 69
r34 := 12
r35 := 85
r36 := 36
r37 := 47
r38 := 5
r39 := 1
r40 := 61
r41 := 74
r42 := 64
r43 := 31
r44 := 80
r45 := 25
r46 := 29
r47 := 93
r48 := 78
r49 := 72
r50 := 24
r51 := 99
r52 := 48
r53 := 76
r54 := 19
r55 := 66
r56 := 70
r57 := 3
r58 := 56
r59 := 23
r60 := 32
r61 := 84
r62 := 100
r63 := 91
r64 := 58
r65 := 20
r66 := 60
r67 := 26
r68 := 37
r69 := 97
r70 := 54
r71 := 46
r72 := 13
r73 := 21
r74 := 63
r75 := 28
r76 := 14
r77 := 59
r78 := 67
r79 := 38
r80 := 88
r81 := 57
r82 := 40
r83 := 55
r84 := 94
r85 := 11
r86 := 95
r87 := 22
r88 := 44
r89 := 27
r90 := 9
r91 := 83
r92 := 50
r93 := 43
r94 := 8
r95 := 90
r96 := 73
r97 := 75
r98 := 96
r99 := 89
r100 := 2
r101 := emptylist
r100 := r100 cons r101
r99 := r99 cons r100
r98 := r98 cons r99
r97 := r97 cons r98
r96 := r96 cons r97
r95 := r95 cons r96
r94 := r94 cons r95
r93 := r93 cons r94
r92 := r92 cons r93
r91 := r91 cons r92
r90 := r90 cons r91
r89 := r89 cons r90
r88 := r88 cons r89
r87 := r87 cons r88
r86 := r86 cons r87
r85 := r85 cons r86
r84 := r84 cons r85
r83 := r83 cons r84
r82 := r82 cons r83
r81 := r81 cons r82
r80 := r80 cons r81
r79 := r79 cons r80
r78 := r78 cons r79
r77 := r77 cons r78
r76 := r76 cons r77
r75 := r75 cons r76
r74 := r74 cons r75
r73 := r73 cons r74
r72 := r72 cons r73
r71 := r71 cons r72
r70 := r70 cons r71
r69 := r69 cons r70
r68 := r68 cons r69
r67 := r67 cons r68
r66 := r66 cons r67
r65 := r65 cons r66
r64 := r64 cons r65
r63 := r63 cons r64
r62 := r62 cons r63
r61 := r61 cons r62
r60 := r60 cons r61
r59 := r59 cons r60
r58 := r58 cons r59
r57 := r57 cons r58
r56 := r56 cons r57
r55 := r55 cons r56
r54 := r54 cons r55
r53 := r53 cons r54
r52 := r52 cons r53
r51 := r51 cons r52
r50 := r50 cons r51
r49 := r49 cons r50
r48 := r48 cons r49
r47 := r47 cons r48
r46 := r46 cons r47
r45 := r45 cons r46
r44 := r44 cons r45
r43 := r43 cons r44
r42 := r42 cons r43
r41 := r41 cons r42
r40 := r40 cons r41
r39 := r39 cons r40
r38 := r38 cons r39
r37 := r37 cons r38
r36 := r36 cons r37
r35 := r35 cons r36
r34 := r34 cons r35
r33 := r33 cons r34
r32 := r32 cons r33
r31 := r31 cons r32
r30 := r30 cons r31
r29 := r29 cons r30
r28 := r28 cons r29
r27 := r27 cons r28
r26 := r26 cons r27
r25 := r25 cons r26
r24 := r24 cons r25
r23 := r23 cons r24
r22 := r22 cons r23
r21 := r21 cons r22
r20 := r20 cons r21
r19 := r19 cons r20
r18 := r18 cons r19
r17 := r17 cons r18
r16 := r16 cons r17
r15 := r15 cons r16
r14 := r14 cons r15
r13 := r13 cons r14
r12 := r12 cons r13
r11 := r11 cons r12
r10 := r10 cons r11
r9 := r9 cons r10
r8 := r8 cons r9
r7 := r7 cons r8
r6 := r6 cons r7
r5 := r5 cons r6
r4 := r4 cons r5
r3 := r3 cons r4
r2 := r2 cons r3
r1 := r1 cons r2
r0 := call r0 ( r1 )
check "(qsort 
'(65 
15 
87 
42 
62 
45 
6 
81 
53 
34 
33 
82 
79 
7 
17 
39 
71 
18 
98 
92 
77 
41 
51 
16 
86 
30 
49 
10 
4 
68 
35 
52 
69 
12 
85 
36 
47 
5 
1 
61 
74 
64 
31 
80 
25 
29 
93 
78 
72 
24 
99 
48 
76 
19 
66 
70 
3 
56 
23 
32 
84 
100 
91 
58 
20 
60 
26 
37 
97 
54 
46 
13 
21 
63 
28 
14 
59 
67 
38 
88 
57 
40 
55 
94 
11 
95 
22 
44 
27 
9 
83 
50 
43 
8 
90 
73 
75 
96 
89 
2))" r0
r0 := _G[ "reverse" ]
r1 := _G[ "iota^" ]
r2 := 100
r1 := call r1 ( r2 )
r0 := call r0 ( r1 )
expect "(reverse (iota^ 100))" r0
