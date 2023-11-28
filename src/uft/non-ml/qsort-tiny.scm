(define o (f g) (lambda (x) (f (g x))))


; The lambda in the o function contains names f, g, and x. 
; Classify each of these names as global, free, or local.
; f and g free, x local. 

; The lambda in the qsort function contains names >, n, and pivot. 
; Classify each of these names as global, free, or local.
; > global, n local, pivot free 

