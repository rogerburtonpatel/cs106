; LITERAL

3
(let ([$r0 2])
  (check $r0 'two))
(let ([$r1 2])
  (expect $r1 'two))
; NAME 
(let* ([$r0 2] [$r1 $r0])
  (check $r1 'r1-as-two))
(let* ([$r0 2])
  (expect $r0 'r0-as-two))
; VMOP
(let* ([$r0 2] [$r1 2] [$r0 (+ $r0 $r1)])
  (check $r0 'two-plus-two))
(let* ([$r1 4])
  (expect $r1 'four))


; VMOPLIT
; As discussed on slack, we can't write this yet. 
; But we'll get there in generation
; FUNCALL
; We'll test these when we have callable functions. 
; (define foo (r10 r11) (+ r10 r11))
; (let* ([$r0 2] [$r1 2] [$r5 foo] [$r0 ($r5 $r0 $r1)])
;   (check $r0 'two-foo-two))
; (let* ([$r1 4])
;   (expect $r1 'four))

; IFX
(let* ([$r0 #f] [$r1 2] [$r2 3] [$r0 (if $r0 $r1 $r2)])
  (check $r0 'if-false-two-else-three))
(let ([$r1 3])
  (expect $r1 'three))
; LETX
(let ([$r0 1])
    (let ([$r1 $r0])
  (check $r1 'one)))
(let ([$r0 1])
  (expect $r0 'one))
; BEGIN
(let* ([$r0 4] [$r1 2] [$r2 (begin (println $r0) $r1)])
  (check $r1 'two))
(let ([$r4 2])
  (expect $r4 'two))
; SET
(let* ([$r1 2] [$r2 3] [$r2 (set global_ex $r2)])
  (check $r2 'three))
(let ([$r4 3])
  (expect $r4 'three))

; WHILEX
(let* ([$r1 2] [$r2 3] [$r3 (while (let ([$r5 #f]) $r5) $r5)])
  (check $r3 'three))
(let ([$r4 #f])
  (expect $r4 'three))
; FUNCODE -- this obviously crashes
; (let* ([$r1 2] [$r0 (lambda (r100) r100)] [$r3 ($r0 $r1)])
;   (check $r0 'two-plus-two))
; (let* ([$r0 2])
;   (expect $r0 'five))

; (let* ([$r0 2] [$r1 2] [$r0 (+ $r0 $r1)])
;   (check $r0 'two-plus-two))
; (let* ([$r0 5])
;   (expect $r0 'five))

; Something random
(let* (
    [r0 1]
    [r6 1]
    [r4 (check  r0 'r0-1)]
    [r5 (expect r6 'r0-1)]
    [r1 r0]
    [r3 (+ r1 r0)]
)
(+ r1 r0)
)