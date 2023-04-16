

(define CAPTURED-IN (i xs) (nth (+ i 1) xs))
;  definitions of predefined uScheme functions [[and]], [[or]], and [[not]] 97a 

(define check-sublist (xs ys)
    (if (= (car xs) (car ys))
        (if (null? (cdr xs))
            #t
            (check-sublist (cdr xs) (cdr ys)))
        #f))

        ; (check-assert (check-sublist '(1) '(1 2 3)))
        (check-assert (check-sublist '(1 2) '(1 2 3)))
        ; (check-assert (not (check-sublist '(2 2) '(1 2 3))))


