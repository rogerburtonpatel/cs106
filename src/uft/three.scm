; (define three (n) (if (= n 0) 3 (three (- n 1))))


; (define changex (x) (set x 5))

; (let ([z 2]) (begin (changex z) (println z)))

(define changex (x) (set x 5))
(define caller (x) (begin (changex x) (println x) x))
(caller 3)