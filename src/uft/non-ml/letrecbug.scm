; (define foo1 (n)
;   (letrec ([f1  (lambda (m) (f2 m))]
;            [f2 (lambda (m) 3)])
;     (f1 n)))

(define foo2 (n)
  (letrec ([f1  (lambda (m) m)]
           ;[f2 (lambda (m) 3)]
           )
    (f1 n)))

; (check-expect (foo1 0) 3)
(check-expect (foo2 0) 0)
; (check-expect (parity 1) 'odd)
; (check-expect (parity 30) 'even)
; (check-expect (parity 91) 'odd)