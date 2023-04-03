;; F.LITERAL, F.CHECK_EXPECT, F.CHECK_ASSERT
;;
(check-expect (number? 3) #t)            
(check-expect (number? 'really?) #f)
(check-assert (symbol? 'really?))

;; F.CHECK_ERROR - TODO ADD 
(check-error (error 'bad))
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

;; F.LOCAL - TODO

;; F.DEFINE

(define constant-true () #t)
(define foo (a) (if a 1 2))
(define foo2 (a b c d e f) (if a b c))

(check-assert (function? constant-true))
; (check-assert (constant-true)) TODO



;; F.SETLOCAL

