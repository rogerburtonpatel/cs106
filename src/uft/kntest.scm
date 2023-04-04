;; F.LITERAL, F.CHECK_EXPECT, F.CHECK_ASSERT
;;
(check-expect (number? 3) #t)            
(check-expect (number? 'really?) #f)
(check-assert (symbol? 'really?))

;; F.CHECK_ERROR - TODO ADD 
(check-error (begin (error 'bad) 2))
(check-error (+ 1 'hi))

;; F.GLOBAL, F.SETGLOBAL
(val x 3)
(check-expect x 3)
(check-expect (set x 2) 2)
(check-expect x 2)

;; F.BEGIN 
(check-expect (begin) #f)
(check-expect (begin x) 2)
(check-expect (begin 1 2 (set x 3)) 3)
(check-expect (begin (begin)) #f)
(check-expect (begin 1 2 3 4 5) 5)

;; F.IFX
(check-expect (if #f 1 2) 2)
(check-assert (if (number? 3) (symbol? 'really?) (function? x)))

;; F.WHILEX
(val z #t)
(check-expect (while z (begin (set z #f) 3 (set x 4))) #f)


;; F.DEFINE

(define constant-true () #t)
(define foo (a) (if a 1 2))
(define foo2 (a b c d e f) (if a b c))

(check-assert (function? constant-true))
(check-assert (constant-true))

;; FULL PRIMITIVES
(check-assert (= 1 1))
(check-error (+ 1 'hi))
(check-expect (begin (set x 1) (+ x x)) 2)
(check-expect (+ (+ 1 2) 2) 5)

;; FUNCALLS, F.LOCAL, F.SETLOCAL


(define even? (n)
    (= 0 (mod n 2)))

(define odd? (n) (not (even? n)))

(check-assert (even? 2))
(check-assert (odd? 3))
(check-assert (number? (hash 3)))

(define nIsNow2 (n) (set n 2))
(define nIsNow2Fancier (n) (begin (set n 2) (+ n 1)))

(check-expect (nIsNow2 1) 2)
(check-expect (nIsNow2Fancier 1) 3)

; (append (qsort (filter left? rest))
;         (cons pivot (qsort (filter right? rest))))

; F.LET, LETSTAR
(let ([x 1]) (+ x 1))
(check-expect (let ([x 1]) (+ x 1)) 2)

(define localLet (n m)
   (let ([n m] [m n]) (+ n m)))
(check-expect (localLet 1 2) 3)

(define localLetStar (n m)
   (let* ([n m] [m n]) (+ n m)))
(check-expect (localLetStar 1 2) 4)

(define localLetSimple (n m)
   (let ([x 3]) (+ x (+ n m))))
(check-expect (localLetSimple 1 2) 6)

(define localLetSimple2 (n m)
   (let ([m n] [x 3]) (+ x (+ n m))))
(check-expect (localLetSimple2 1 2) 5)

(define localLetMixed (n m)
   (let ([n m] [m n] [x 3]) (+ x (+ n m))))
(check-expect (localLetMixed 1 2) 6)

(define localLetStarMixed (n m)
   (let* ([n m] [m n] [x 3]) (+ x (+ n m))))
(check-expect (localLetStarMixed 1 2) 7)

