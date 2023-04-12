; bug: unused let-bound name in lambda crashes with NameNotFound

; fine
(let ([z 1]) (+ 3 3))

; crashes
(lambda (y) (let ([z 1]) (+ 1 2)))

; because cl gives us:
; (mkclosure (lambda ($closure y) (let ([z 1]) (+ 1 2))) (cons z '()))

; fine
(lambda (y) (let ([z 1]) (+ 1 z)))
