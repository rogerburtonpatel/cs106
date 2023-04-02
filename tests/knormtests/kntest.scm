; ;; F.LITERAL, F.CHECK_EXPECT, F.CHECK_ASSERT
; ;;
; (check-expect (number? 3) #t)            
; (check-expect (number? 'really?) #f)
; (check-assert (symbol? 'really?))

; ;; F.CHECK_ERROR

; TODO: this needs to fail!
; (check-error (neg 1))

; ;; F.GLOBAL, F.SETGLOBAL
; (val x 3)
; (check-expect x 3)
; (check-expect (set x 2) 2)
; (check-expect x 2)

; ;; F.BEGIN 
; (check-expect (begin) #f)
; (check-expect (begin x) 2)
; (check-expect (begin 1 2 (set x 3)) 3)
; (check-expect (begin (begin)) #f)
; ;; F.LOCAL 
; (check-expect (begin 1 2 3 4 5) 5)

; ;; F.IFX

; ;; F.WHILEX
; (val z #t)
; (check-expect (while z (begin (set z #f) 3 (set x 4))) #f)





;; F.SETLOCAL

