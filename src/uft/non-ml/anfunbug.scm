; (set y 100)

; (define two-args (a b) (begin (println 'here-are-a-and-b:) (println a) (println b) b))
; ; (define 3-args (a b c) (begin (println 'here-are-a-and-b-and-c:) (println a) (println b) (println c)))

; ; (let [(x 
; ;       (let [(y (let [(g (two-args 1 2))] g))] (two-args x y)))] (two-args x y))
; (define test ()
; (let [(x 
;       (let [(y (two-args 1 2))] (let [(x (let [(y (two-args 1 2))] (+ y y)))] (+ x x))))] (+ x x)))
; (test)

(define add2 (f env)
    (if (even? f)
        (two-args (lambda (x) (chill x env)) (hi chill f))
        #t))