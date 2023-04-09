check "hello" r1
expect "hello" r1
if r1 goto "hello"
goto "hello"
r1 := _G["name"]
_G["name"] := r2
r2 := r1
error r1
r1 := 1
halt 
; Look above for step 2

r2 := r1 + r1
r2 := r1 - r1
r2 := r1 * r1
r2 := r1 / r1
r2 := r1 // r1
r2 := r1 mod r1 

deflabel "hello"
inc r2
dec r2
r2 := neg r2
r2 := not r2
r1 := function (3 arguments) {
    r1 := function? r1
    r1 := cdr r1
    r1 := pair? r1
}
r1 := boolOf r2

; Look below for step 7: 
print r1
println r1
printu r1
error r1
r1 := car r1
r1 := cdr r1
r1 := r1 cons r1
r1 := r2 > r1
r1 := r3 < r1
r1 := symbol? r1
r1 := function? r1
r1 := pair? r1
r1 := number? r1
r1 := boolean? r1
r1 := null? r1
r1 := nil? r1
r1 := r1 + 10
r1 := r1 + r1
r1 := r1 - r1
r1 := r1 * r1
r1 := r1 / r1
r1 := r1 // r1 ; idiv, python-style
r1 := r1 mod r1 
r1 := r1 = r1
r1 := hash r1
; poor r1
@ swap 1 2
halt

; calls
r0 := call r0
r0 := call r0 ()
r0 := call r0 (r1)
r0 := call r0 (r1, ..., r2)

tailcall r0
tailcall r0 ()
tailcall r0 (r1)
tailcall r0 (r1, ..., r5)
