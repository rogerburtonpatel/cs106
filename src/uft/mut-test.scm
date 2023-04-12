(define mutate-local (x)
   (let ([bad x])
     (begin (set bad 5)
            x)))
(check-expect (mutate-local 1) 1)

; (define has-arg-mutated (x) 
;        (lambda (y) (let ([z 1]) (begin (set x 3)))))
; (check-expect ((has-arg-mutated 5) 2) 3)