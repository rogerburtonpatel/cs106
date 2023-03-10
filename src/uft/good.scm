3 ; v
nil ; x
(let ([x 3])  (+ x x)); @(x1...xn)
(let*  ([x 3] [r1 list1]) (r1 x)) ; x(x1...xn)
(let ([x 3])  (if x x x)) ; IFX
(begin 1 2) ; e1; e2
(let ([x 3]) (set y x)) ; SETGLOBAL
(let ([x 3]) (set x 1)) ; SETLOCAL
(while (let ([x 3]) x) x) ; WHILEX
