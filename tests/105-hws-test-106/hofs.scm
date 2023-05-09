;;;;;;;;;;;;;;;;;;; COMP 105 SCHEME II ASSIGNMENT ;;;;;;;;;;;;;;;

; ; included for unit-testing
(define even? (n) (= (mod n 2) 0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 2

;; Forms of data: a 2 argument function. 

;; Example input: >, <, (append)

;; (flip f) takes a two-argument function as argument and returns a
;;          function that is like the argument function, except 
;;          the result function expects its arguments in the opposite order.

;; laws: 
;;   ((flip f) x y) == (f y x) 

(define flip (f)
    (lambda (x y) (f y x)))

        (check-assert ((flip >) 3 4))
        (check-assert (not ((flip <) 3 4)))
        (check-assert (not ((flip <=) 3 4)))
        (check-expect ((flip append) '(a b c) '(1 2 3)) '(1 2 3 a b c))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 3

;; Forms of data: a 1-argument boolean function p?, a list xs. 

;; Example input: (even? '()), (atom? '(1)), (function? '(f a 2))

;; (takewhile p? xs) takes a predicate p? and a list xs and returns the longest 
;;                   prefix of the list in which every element satisfies 
;;                   the predicate.

;; laws: 
;; (takewhile p? '()) == '()
;; (takewhile p? (cons x xs)) == '(), where (not (p? x))
;; (takewhile p? (cons x xs)) == (cons x (takewhile xs)), where (p? x)

(define takewhile (p? xs)
    (if (null? xs)
        xs
        (if (p? (car xs))
            (cons (car xs) (takewhile p? (cdr xs)))
            '())))
    
        (check-expect (takewhile even? '() ) '())
        (check-expect (takewhile even? '(3 4)) '())
        (check-expect (takewhile even? '(4 3)) '(4))
        (check-expect (takewhile even? '(2 4 6 7 8 10 12)) '(2 4 6))

;; Forms of data: a 1-argument boolean function p?, a list xs. 

;; Example input: (even? '()), (atom? '(1)), (function? '(f a 2))

;; (dropwhile p? xs) takes a predicate p? and a list xs and 
;;                   removes the longest prefix in which each element 
;;                   satisfies the predicate and returns whatever is left over.

;; laws: 
;; (dropwhile p? '()) == '()
;; (dropwhile p? (cons x xs)) == xs, where (not (p? x))
;; (dropwhile p? (cons x xs)) == (dropwhile xs), where (p? x)

(define dropwhile (p? xs)
    (if (null? xs)
        xs
        (if (p? (car xs))
            (dropwhile p? (cdr xs))
            xs)))
    
        (check-expect (dropwhile even? '() ) '())
        (check-expect (dropwhile even? '(4 3)) '(3))
        (check-expect (dropwhile even? '(3 4)) '(3 4))
        (check-expect (dropwhile even? '(2 4 6 7 8 10 12)) '(7 8 10 12))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 4

;; Forms of data: a 2-argument boolean function p? 

;; Example input: (<), (>), (equal?)

;; (ordered-by? p?) takes a comparison function p? that represents a transitive
;;                  relation and returns a predicate that tells if a list of 
;;                  values is totally ordered by that relation.

;; laws: 
;; ((ordered-by? p?) '()) == #t
;; ((ordered-by? p?) (cons x '())) == #t
;; ((ordered-by? p?) (cons x (cons y ys))) == (&& (p? x y) 
;;                                              ((ordered-by? p?) (cons y ys)))


;; Contract for nested function list-ordered?, which inherits p?
;; (list-ordered? xs) takes a list xs and returns true iff each 
;;                    element of xs follows an order as defined by p?. 

;; laws for nested function list-ordered?, which inherits p?
;; (list-ordered? '()) == #t
;; (list-ordered? (cons x '())) == #t
;; (list-ordered? (cons x (cons y ys))) == (&& (p? x y) 
;;                                         (list-ordered? (cons y ys)))

(define ordered-by? (p?)
    (letrec 
        ([list-ordered? 
            (lambda (xs)
                (if (null? xs)
                    #t
                    (if (null? (cdr xs))
                        #t
                        (&& (p? (car xs) (cadr xs)) 
                            (list-ordered? (cdr xs))))))])
        list-ordered?)) ; call the darn function 


        ; given sanity checks- thanks!
        (check-assert (function? ordered-by?))
        (check-assert (function? (ordered-by? <)))
        (check-error (ordered-by? < (list3 1 2 3)))  
        ; self-defined tests
        (check-assert ((ordered-by? <) '()))
        (check-assert ((ordered-by? <) '(1)))
        (check-assert ((ordered-by? <) '(1 2 3)))
        (check-assert (not ((ordered-by? >) '(1 2 3))))
        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 5

;; 28(b)
;; Forms of data: a non-empty list of integers xs 

;; Example input: '(1), '(1 2 3 4 5 2 7) '(3 0 0 0 1 3)

;; (max* xs) takes a non-empty integer list xs and returns the greatest 
;;           element in xs. 

(define max* (xs) (foldr max (car xs) xs))

        (check-expect (max* '(1)) 1)
        (check-expect (max* '(1 2 3 4 5 3 7)) 7)
        (check-expect (max* '(3 0 0 0 1 3)) 3)
;; 26(e)

;; Forms of data: a non-empty list of integers xs 

;; Example input: '(1), '(1 2 3 4 5 2 7) '(3 0 0 0 1 3)

;; (sum xs) takes a non-empty integer list xs and returns the sum of all 
;;          xs' elements. 

(define sum (xs) (foldr + 0 xs))

        (check-expect (sum '(1)) 1)
        (check-expect (sum '(1 2 3 4 5 3 7)) 25)
        (check-expect (sum '(3 0 0 0 1 3)) 7)

;; 26(f)
;; Forms of data: a non-empty list of integers xs 

;; Example input: '(1), '(1 2 3 4 5 2 7) '(3 0 0 0 1 3)

;; (product xs) takes a non-empty integer list xs and returns the product of
;;              all xs' elements. 

(define product (xs) (foldr * 1 xs))

        (check-expect (product '(1)) 1)
        (check-expect (product '(1 2 3 4 5 3 7)) 2520)
        (check-expect (product '(3 0 0 0 1 3)) 0)

;; wow these were fast. HOFs are insane. 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 6

;; 29(a)
;; Forms of data: two lists xs and ys

;; Example input: ('() '()), ('() '(1)), ('(1) '()), ('(1) '(1)), 
;;                  ('(1 2 3) '(4 5)), ('(1 2) '(4 5 6)), ('(1 2 3) '(4 5 6)), 
;;                  ('(1 '(2) #f 'hello) '(even? 5 6))
;; (append xs ys) takes two lists xs and ys and returns the list containing 
;;                the elements of xs followed by the elements of ys. 

(define append (xs ys) 
    (if (null? xs)
        ys
        (if (null? ys)
            xs
            (foldr cons ys xs))))
    
        (check-expect (append '() '()) '())
        (check-expect (append '() '(1)) '(1))
        (check-expect (append '(1) '()) '(1)) 
        (check-expect (append '(1) '(1)) '(1 1))
        (check-expect (append '(1 2) '(4 5 6)) '(1 2 4 5 6))
        (check-expect (append '(1 2 3) '(4 5)) '(1 2 3 4 5))
        (check-expect (append '(1 2 3) '(4 5 6)) '(1 2 3 4 5 6))
                        ; I renamed my function 'appendp'
                        ; and compared its output to that of the OG append. 
;        (check-expect (appendp '(1 '(2) #f 'hello) '(even? 5 6)) 
;                      (append '(1 '(2) #f 'hello) '(even? 5 6)))

;; 29(c)
;; Forms of data: a list xs

;; Example input: '(), '(1), '(1 2), '(1 2 3 4 5 6), 
;;                              '(1 '(2) #f 'hello even? 5 6) 
;; (reverse xs) takes a list xs returns the list containing 
;;              the elements of xs in reverse order. 

(define reverse (xs) 
    (if (null? xs)
        '()
        (foldl cons (list1 (car xs)) (cdr xs))))    

        (check-expect (reverse '()) '())
        (check-expect (reverse '(1)) '(1))
        (check-expect (reverse '(1 2)) '(2 1)) 
        (check-expect (reverse '(1 2 3 4 5 6)) '(6 5 4 3 2 1))
                        ; I renamed my function 'reversep'
                        ; and compared its output to that of the OG revserse. 
;        (check-expect (reversep '(1 '(2) #f 'hello even? 5 6)) 
;                      (reverse '(1 '(2) #f 'hello even? 5 6)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 7

;; map
;; Forms of data: a single-argument function f, a list xs

;; Example input: (even? '()), (not '(#f)), ((lambda (i) (* i i)) '(1 2 3))

;; (map f xs) takes a single-argument function f and a list xs and returns 
;;            the list of results of applying f to each element of xs. 

(define map (f xs)
    (if (null? xs)
        '()
        (reverse (foldl (lambda (x y) (cons (f x) y))
                    (list1 (f (car xs))) (cdr xs)))))
 ; applies f to each element and cons's it with the rest of the list. 
 ; result is the mapped list, reversed, so 'reverse' is called. 

        (check-expect (map not '()) '())
        (check-expect (map not '(#t)) (list1 #f ))
        (check-expect (map not (list6 #t #f #t #t #f #t)) (list6 #f #t #f #f #t #f)) ; failing
        (check-expect (map even? '(1 2 3 4 5 6)) (list6 #f #t #f #t #f #t))
        (check-expect (map (lambda (i) (* i i)) '(1 2 3 4 5 6))
                                            '(1 4 9 16 25 36))

; I named my overloaded map function to 'mapn' and tested it against the 
; original 'map'. 
;    (check-expect (mapn pair? '(1 '() '(3 4))) (map pair? '(1 '() '(3 4))))


;; filter
;; Forms of data: a single-argument predicate p?, a list xs

;; Example input: (even? '()), (atom? '(#f)), (atom? '(1 #t '(3 4) 5))

;; (filter p? xs) takes a single-argument predicate p? and a list xs and 
;;                returns the list of xs' elements which satisfy the predicate.

(define filter (p? xs) 
    (if (null? xs)
        '()
        (reverse 
            (foldl 
                (lambda (x y) ; again, returns filtered list reversed
                    (if (p? x)                   ; so reverse is called 
                        (cons x y)  ; returns each element f applies to
                        y))
                    (if (p? (car xs)) ; individual check for first element, 
                        (list1 (car xs)) ;  needed due to behavior of foldl
                        '())
                            (cdr xs)))))
            
        (check-expect (filter even? '()) '())
        (check-expect (filter even? '(2 3 4)) '(2 4))
        (check-expect (filter even? '(2 4 6)) '(2 4 6))
        (check-expect (filter even? '(1 1 3)) '())
    ; I named my overloaded filter function to 'filterp' and tested it against
    ; the original 'filter'. 
    ;        (check-expect (filterp atom? '(1 #t '(3 4) 5)) '(1 #t 5))


;; exists?
;; Forms of data: a single-argument predicate p?, a list xs

;; Example input: (even? '()), (atom? '(#f)), (atom? '(1 #t '(3 4) 5))

;; (exists? p? xs) takes a single-argument predicate p? and a list xs and 
;;                returns true if xs contains an element which satisfies
;;                the predicate and false otherwise. 


(define exists? (p? xs) 
    (if (null? xs)
        #f
        (foldl (lambda (x y)  (|| (p? x) y)) (p? (car xs)) (cdr xs))))

        (check-assert (not (exists? even? '())))
        (check-assert (exists? even? '(2)))
        (check-assert (not (exists? even? '(1))))
        (check-assert (exists? even? '(1 2 1 2)))
        (check-assert (not (exists? even? '(1 3 5))))

    ; I named my overloaded exists function to 'existsp' and tested it against
    ; the original 'exists'. 
        ;    (check-expect (existsp? pair? '(1 #t '(3 4) 5))
        ;                     (exists? pair? '(1 #t '(3 4) 5)))

;; all?
;; Forms of data: a single-argument predicate p?, a list xs

;; Example input: (even? '()), (atom? '(#f)), (atom? '(1 #t '(3 4) 5))

;; (all? p? xs) takes a single-argument predicate p? and a list xs and 
;;                returns false if xs contains an element which does not 
;;                satisfy the predicate and true otherwise. 

(define all? (p? xs) 
    (if (null? xs)
        #t
        (foldl (lambda (x y) (equal? (p? x) y)) (p? (car xs)) (cdr xs))))

        (check-assert (all? even? '()))
        (check-assert (all? even? '(2)))
        (check-assert (not (all? even? '(1))))
        (check-assert (not (all? even? '(2 1 2))))
        (check-assert (all? even? '(2 4 6)))
    ; I named my overloaded all function to 'allp' and tested it against
    ; the original 'all'. 
        ;    (check-expect (allp? pair? '(1 #t '(3 4) 5))
        ;                     (all? pair? '(1 #t '(3 4) 5)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 8

; included for unit testing 
(val atoms (lambda (x) (atom? x)))
(define member? (x s) (s x))

;; evens
;; Forms of data: an integer x

;; Example input: 0, 1, 9, 10, 200

;; (evens x) takes an integer x and returns #t if x is even and false
;;           otherwise. evens represents the set of all even integers.

; Abstract solution is (define evens (x) (even? x)), which can be written as 
(val evens (lambda (x) (= (mod x 2) 0)))

        (check-assert (evens 0))
        (check-assert (evens 4))
        (check-assert (not (evens 5)))
        (check-assert (evens 200))

;; two-digits
;; Forms of data: an integer x

;; Example input: 0, 1, 9, 10, 200

;; (two-digits x) takes an integer x and returns #t if x has exactly two 
;;                digits and is positive and false otherwise. 
;;                two-digits represents the set of all positive 
;;                two-digit integers. 

(val two-digits (lambda (x) (&& (&& (> (idiv x 10) 0) (= (idiv x 100) 0)) (> x 9))))

        (check-assert (not (two-digits 0)))
        (check-assert (not (two-digits 4)))
        (check-assert (two-digits 10))
        (check-assert (two-digits 55))
        (check-assert (not (two-digits 100)))
        (check-assert (not (two-digits (- 55 100))))
;; add-element
;; Forms of data: a s-expression x, a function s (which represents a set)

;; Example input: (1 evens) (4 two-digits) ('(1) atoms)

;; (add-element x s) takes an s-expression x and a set-representing function s
;;                and returns a new set-representing function, which 
;;                returns true if its input is either x or a member of s, and 
;;                false otherwise. 

;; laws: 
;; (member? x (add-element x s)) == #t
;; (member? x (add-element y s)) == (s x), where (not (equal? y x))

(define add-element (x s) 
    (lambda (y) (|| (equal? x y) (s y))))

        (check-assert (member? 1 (add-element 1 evens)))
        (check-assert (member? 4 (add-element 4 two-digits)))
        (check-assert (member? '(1) (add-element '(1) atoms))) 
        (check-assert (member? 2 (add-element '(1) atoms))) 
        (check-assert (not (member? '(1) (add-element '(2) atoms)))) 

;; union
;; Forms of data: two functions s1, s2 (which represents sets)

;; Example input: (two-digts evens)

;; (union s1 s2) takes two set-representing functions s1 and s2 
;;                and returns a new set-representing function, which 
;;                returns true if its input is a member of s1 or a member of
;;                s2 (inclusive), and false otherwise. 

;; laws: 
;; (member? x (union s1 s2))     == (|| (member? x s1) (member? x s2))

(define union (s1 s2) 
    (lambda (x) (|| (s1 x) (s2 x))))
        ; TODO SEGFAULT
        (check-assert (member? 2 (union evens two-digits)))
        (check-assert (member? 11 (union evens two-digits)))
        (check-assert (member? 5 (union atoms two-digits)))
        (check-assert (not (member? 5 (union evens two-digits))))


;; inter
;; Forms of data: two functions s1, s2 (which represents sets)

;; Example input: (two-digts evens)

;; (inter s1 s2) takes two set-representing functions s1 and s2 
;;                and returns a new set-representing function, which 
;;                returns true if its input is a member of s1 and a member of
;;                s2, and false otherwise. 

;; laws: 
;; (member? x (inter s1 s2))     == (&& (member? x s1) (member? x s2))

(define inter (s1 s2) 
    (lambda (x) (&& (s1 x) (s2 x))))
        (check-assert (member? 22 (inter evens two-digits)))
        (check-assert (not (member? 11 (inter evens two-digits))))
        (check-assert (member? 55 (inter atoms two-digits)))
        (check-assert (not (member? 5 (inter atoms two-digits))))

;; diff
;; Forms of data: two functions s1, s2 (which represents sets)

;; Example input: (two-digts evens)

;; (diff s1 s2) takes two set-representing functions s1 and s2 
;;                and returns a new set-representing function, which 
;;                returns true if its input is a member of s1 and not a member
;;                of s2, and false otherwise. 

;; laws: 

;; (member? x (diff  s1 s2))     == (&& (member? x s1) (not (member? x s2)))

(define diff (s1 s2) 
    (lambda (x) (&& (s1 x) (not (s2 x)))))

        (check-assert (member? 2 (diff evens two-digits)))
        (check-assert (member? 11 (diff two-digits evens)))
        (check-assert (member? 5 (diff atoms two-digits)))
        (check-assert (not (member? 55 (diff evens two-digits))))
        (check-assert (not (member? 22 (diff evens two-digits))))
