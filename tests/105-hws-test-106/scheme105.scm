;  predefined uScheme functions 96a 
(define caar (xs) (car (car xs)))
(define cadr (xs) (car (cdr xs)))
(define cdar (xs) (cdr (car xs)))
;  predefined uScheme functions ((elided)) (THIS CAN'T HAPPEN -- claimed code was not used) 
;  more predefined combinations of [[car]] and [[cdr]] S151b 
(define cddr  (sx) (cdr (cdr  sx)))
(define caaar (sx) (car (caar sx)))
(define caadr (sx) (car (cadr sx)))
(define cadar (sx) (car (cdar sx)))
(define caddr (sx) (car (cddr sx)))
(define cdaar (sx) (cdr (caar sx)))
(define cdadr (sx) (cdr (cadr sx)))
(define cddar (sx) (cdr (cdar sx)))
(define cdddr (sx) (cdr (cddr sx)))
;  more predefined combinations of [[car]] and [[cdr]] S151c 
(define caaaar (sx) (car (caaar sx)))
(define caaadr (sx) (car (caadr sx)))
(define caadar (sx) (car (cadar sx)))
(define caaddr (sx) (car (caddr sx)))
(define cadaar (sx) (car (cdaar sx)))
(define cadadr (sx) (car (cdadr sx)))
(define caddar (sx) (car (cddar sx)))
(define cadddr (sx) (car (cdddr sx)))
;  more predefined combinations of [[car]] and [[cdr]] S151d 
(define cdaaar (sx) (cdr (caaar sx)))
(define cdaadr (sx) (cdr (caadr sx)))
(define cdadar (sx) (cdr (cadar sx)))
(define cdaddr (sx) (cdr (caddr sx)))
(define cddaar (sx) (cdr (cdaar sx)))
(define cddadr (sx) (cdr (cdadr sx)))
(define cdddar (sx) (cdr (cddar sx)))
(define cddddr (sx) (cdr (cdddr sx)))
;  predefined uScheme functions 96b 
(define list1 (x)     (cons x '()))
(define list2 (x y)   (cons x (list1 y)))
(define list3 (x y z) (cons x (list2 y z)))
;  predefined uScheme functions 99b 
(define append (xs ys)
  (if (null? xs)
     ys
     (cons (car xs) (append (cdr xs) ys))))
;  predefined uScheme functions 100b 
(define revapp (xs ys) ; (reverse xs) followed by ys
  (if (null? xs)
     ys
     (revapp (cdr xs) (cons (car xs) ys))))
;  predefined uScheme functions 101a 
(define reverse (xs) (revapp xs '()))
;  predefined uScheme functions ((elided)) (THIS CAN'T HAPPEN -- claimed code was not used) 
(define nth (n xs)
  (if (= n 0)
    (car xs)
    (nth (- n 1) (cdr xs))))

(define CAPTURED-IN (i xs) (nth (+ i 1) xs))
;  definitions of predefined uScheme functions [[and]], [[or]], and [[not]] 97a 
(define and (b c) (if b  c  b))
(define or  (b c) (if b  b  c))
; (define not (b)   (if b #f #t))
;  predefined uScheme functions 102c 
(define atom? (x) (or (symbol? x) (or (number? x) (or (boolean? x) (null? x)))))
;  predefined uScheme functions 103b 
(define equal? (sx1 sx2)
  (if (atom? sx1)
    (= sx1 sx2)
    (if (atom? sx2)
        #f
        (and (equal? (car sx1) (car sx2))
             (equal? (cdr sx1) (cdr sx2))))))
 predefined uScheme functions 105c 
(define make-alist-pair (k a) (list2 k a))
(define alist-pair-key        (pair)  (car  pair))
(define alist-pair-attribute  (pair)  (cadr pair))
;  predefined uScheme functions 105d 
(define alist-first-key       (alist) (alist-pair-key       (car alist)))
(define alist-first-attribute (alist) (alist-pair-attribute (car alist)))
;  predefined uScheme functions 106a 
(define bind (k a alist)
  (if (null? alist)
    (list1 (make-alist-pair k a))
    (if (equal? k (alist-first-key alist))
      (cons (make-alist-pair k a) (cdr alist))
      (cons (car alist) (bind k a (cdr alist))))))
(define find (k alist)
  (if (null? alist)
    '()
    (if (equal? k (alist-first-key alist))
      (alist-first-attribute alist)
      (find k (cdr alist)))))
;  predefined uScheme functions 125a 
;  predefined uScheme functions 126b 
;  predefined uScheme functions 129a 
(define filter (p? xs)
  (if (null? xs)
    '()
    (if (p? (car xs))
      (cons (car xs) (filter p? (cdr xs)))
      (filter p? (cdr xs)))))
;  predefined uScheme functions 129b 
(define map (f xs)
  (if (null? xs)
    '()
    (cons (f (car xs)) (map f (cdr xs)))))
;  predefined uScheme functions 130a 
(define app (f xs)
  (if (null? xs)
    #f
    (begin (f (car xs)) (app f (cdr xs)))))
 predefined uScheme functions 130b 
(define exists? (p? xs)
  (if (null? xs)
    #f
    (if (p? (car xs)) 
      #t
      (exists? p? (cdr xs)))))
(define all? (p? xs)
  (if (null? xs)
    #t
    (if (p? (car xs))
      (all? p? (cdr xs))
      #f)))
;  predefined uScheme functions 130d 
(define foldr (op zero xs)
  (if (null? xs)
    zero
    (op (car xs) (foldr op zero (cdr xs)))))
(define foldl (op zero xs)
  (if (null? xs)
    zero
    (foldl op (op (car xs) zero) (cdr xs))))
;  predefined uScheme functions S150c 
(val newline      10)   (val left-round    40)
(val space        32)   (val right-round   41)
(val semicolon    59)   (val left-curly   123)
(val quotemark    39)   (val right-curly  125)
                        (val left-square   91)
                        (val right-square  93)
;  predefined uScheme functions S150d 
; (define <= (x y) (not (> x y)))
; (define >= (x y) (not (< x y)))
(define != (x y) (not (= x y)))
;  predefined uScheme functions S150e 
(define max (x y) (if (> x y) x y))
(define min (x y) (if (< x y) x y))
;  predefined uScheme functions S151a 
(define negated (n) (- 0 n))
; (define mod (m n) (- m (* n (idiv m n))))
(define gcd (m n) (if (= n 0) m (gcd n (mod m n))))
(define lcm (m n) (if (= m 0) 0 (* m (idiv n (gcd m n)))))
;  predefined uScheme functions S151e 
(define list4 (x y z a)         (cons x (list3 y z a)))
(define list5 (x y z a b)       (cons x (list4 y z a b)))
(define list6 (x y z a b c)     (cons x (list5 y z a b c)))
(define list7 (x y z a b c d)   (cons x (list6 y z a b c d)))
(define list8 (x y z a b c d e) (cons x (list7 y z a b c d e)))
(define assoc (v pairs)
  (if (null? pairs)
      #f
      (let* ([first (car pairs)]
            [rest (cdr pairs)])
        (if (equal? v (car first))
            first
            (assoc v rest)))))

(define Table.new ()
  (cons nil '()))

(define Table.get (t k)
  (let ([pair (assoc k (cdr t))])
    (if pair
        (cdr pair)
        nil)))

(define Table.put (t k v)
  (let ([pair (assoc k (cdr t))])
    (if pair
        (set-cdr! pair v)
        (set-cdr! t (cons (cons k v) (cdr t))))))


;;;;;;;;;;;;;;;;;;; COMP 105 SCHEME ASSIGNMENT ;;;;;;;;;;;;;;;


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Exercise 2


;; (check-sublist xs ys) determines whether list xs is a contiguous 
;; subsequence list ys. It is called in the case (contig-sublist) input
;; takes the form
;; (contig-sublist (cons x xs) (cons x ys)). 

;; laws: 
;;   (check-sublist (cons x xs) (cons x ys)) == (|| (null? xs)
;;                                                 (check-sublist xs ys))
;;   (check-sublist (cons x xs) (cons y ys)) == #f, where (not (= x y))

(define check-sublist (xs ys)
    (if (equal? (car xs) (car ys))
        (if (null? (cdr xs))
            #t
            (check-sublist (cdr xs) (cdr ys)))
        #f))

        (check-expect #t (check-sublist '(1) '(1 2 3)))
        (check-expect #t (check-sublist '(1 2) '(1 2 3)))
        (check-expect #t (not (check-sublist '(2 2) '(1 2 3))))



;; (contig-sublist? xs ys) determines whether the first list is a contiguous 
;; subsequence of the second. 
;; In other words, (contig-sublist? xs ys) returns #t iff there are 
;; two other lists front and back, such that ys is equal to
;; (append (append front xs) back).

;; laws (if you want to attempt them; they are optional for this problem):
;;   (contig-sublist? '() ys ) == #t
;;   (contig-sublist? xs '() ) == #f
;;   (contig-sublist? (cons x xs) (cons y ys) ) == 
;;                                            (contig-sublist? (cons x xs) ys), 
;;                                                 where (not (= x y))
;;   (contig-sublist? (cons x xs) (cons x ys) ) == (|| (check-sublist xs ys)
;;                                                  (contig-sublist? xs ys)),


(define contig-sublist? (xs ys)
    (if (null? xs)
        #t
        (if (null? ys)
            #f
            (if (check-sublist xs ys)
                #t
                (contig-sublist? xs (cdr ys))))))
    
        (check-expect #t (contig-sublist? '() '()))
        (check-expect #t (contig-sublist? '() '(1)))
        (check-expect #t (not (contig-sublist? '(1) '())))
        (check-expect #t (contig-sublist? '(1) '(0 1 2 3 4)))
        (check-expect #t (contig-sublist? '(1 2 3) '(0 1 2 3 4)))
        (check-expect #t (not (contig-sublist? '(1 2 5) '(0 1 2 4 4))))
        (check-expect #t (not (contig-sublist? '(1 2 5) '(0 1 2 4 5))))



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Exercise 3


;; (flatten xs) consumes a list of S-expressions and erases internal
;; brackets, preserving the underlying list of atoms. 

;; laws:
;;   (flatten '()) == ()
;;   (flatten (list2 '() xs)) == (flatten (xs))
;;   (flatten (cons x xs)) == (cons x (flatten xs)), where (atom? x)
;;   (flatten (cons x xs)) == (append (flatten x) (flatten xs)), 
;;                                          where (not (atom? x))

(define flatten (xs)
    (if (null? xs)
        xs
        (if (null? (car xs))
            (flatten (cdr xs))
            (if (atom? (car xs))
                (cons (car xs) (flatten (cdr xs)))
                (append (flatten (car xs)) (flatten (cdr xs)))))))

        (check-expect (flatten '()) '())
        (check-expect (flatten '((((a))))) '(a))

        (check-expect (flatten '((I Ching) (U Thant) (E Coli)))
                            '(I Ching U Thant E Coli))
        (check-expect (flatten '((a) () ((b c) d e))) '(a b c d e))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Exercise 4


;; (take n xs) expects a natural number and a list of values, and returns 
;; a list containing the first n elements of xs, 
;; or all of xs if n is greater than the length of xs.

;; laws:
;;   (take 0 xs) == '()
;;   (take n '()) == '()
;;   (take (+ n 1) (cons x xs)) == (cons x (take n) xs)


(define take (n xs)
    (if (= n 0)
        '()
        (if (null? xs)
            '()
            (cons (car xs) (take (- n 1) (cdr xs))))))

        (check-expect (take 0 '()) '())
        (check-expect (take 9 '()) '())
        (check-expect (take 3 '(1 2 3)) '(1 2 3))
        (check-expect (take 2 '(1 2 3)) '(1 2))
        (check-expect (take 4 '(1 2 3)) '(1 2 3))

        



;; (drop n xs) expects a natural number and a list of values, and returns 
;; xs without the first n elements, 
;; or the empty list if n is greater than the length of xs.

;; laws:
;;   (drop n '()) == '()
;;   (drop 0 xs) == xs
;;   (drop ( + n 1) (cons x xs)) == (drop n xs)

(define drop (n xs)
    (if (null? xs)
        '()
        (if (= n 0)
            xs
            (drop (- n 1) (cdr xs)))))
   
        (check-expect (drop 9 '()) '())
        (check-expect (drop 0 '(1 2 3)) '(1 2 3))
        (check-expect (drop 3 '(1 2 3)) '())
        (check-expect (drop 2 '(1 2 3)) '(3))
        (check-expect (drop 4 '(1 2 3)) '())



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Exercise 5


;; (zip xs ys) converts a pair of lists to a list of pairs by associating 
;;; corresponding values in the two lists. 
;; Here, a “pair” is represented by a list of length two, 
;; e.g., a list formed using predefined function list2. 
;; xs and ys must be of equal length. 

;; laws:
;;   (zip '() '()) == ()
;;   (zip (cons x '()) (cons y '())) == (cons (list2 x y) '())
;;   (zip (cons x xs) (cons y ys)) == 
;;                                   (append (cons x (cons y '())) (zip xs ys))
;;   ...
;; [optional notes about where laws come from, or difficulty, if any]

(define zip (xs ys)
    (if (null? xs)
        '()
        (if (null? (cdr xs))
            (cons (list2 (car xs) (car ys)) '())
            (cons (list2 (car xs) (car ys)) (zip (cdr xs) (cdr ys))))))

        (check-expect (zip '() '()) '())
        (check-expect (zip '(1) '(a)) '((1 a)))
        (check-expect (zip '(1 2 3) '(a b c)) '((1 a) (2 b) (3 c)))

;; (unzip-half f ps xs) applies a function f to each element of list ps, 
;; stores the result in xs, and returns (reverse xs). 

;; laws:
;;   (unzip f '() (reverse xs))) == xs
;;   (unzip f (cons p ps) xs)) == (unzip-half f ps (cons (f ps) xs))

(define unzip-half (f ps xs)
    (if (null? ps)
        (reverse xs)
        (unzip-half f (cdr ps) (cons (f ps) xs))))

        (check-expect (unzip-half car '() (reverse '(1 2))) '(1 2))
        (check-expect (unzip-half car '(1 2) '(1 2)) '(2 1 1 2))


;; (unzip ps) converts a list of pairs ps to a pair of lists containing the
;; separate elements.

;; laws:
;;   (unzip '()) == '()
;;   (unzip (cons p ps)) == 
;;                      (list2 (unzip-half caar ps (unzip-half cadar ps '())))
;;                       * ik these aren't perfect, just putting them here

(define unzip (ps)
    (if (null? ps)
        '()
        (list2 (unzip-half caar ps '()) (unzip-half cadar ps '()))))

       (check-expect (unzip '()) '())
       (check-expect (unzip '((1 2))) '((1) (2)))
       (check-expect (unzip '((I Magnin) (U Thant) (E Coli))) 
                        '((I U E) (Magnin Thant Coli)))
       

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Exercise 6

; included for unit testing. 
(define square (a) (* a a))

;; (set-arg-max f xs) takes a function f that maps a value
;; in set X to a number, and a nonempty list xs of values in set X. 
;; It returns an element m in as for which (f x) is as large as possible to 
;; function arg-max. 

;; laws:
;;   (set-arg-max f m (cons x '())) == x, where (> (f x) (f m))
;;                                     m, where (not (> (f x) (f m)))
;;   (set-arg-max f m (cons x xs)) == (set-arg max f x xs), 
;;                                     where (> (f x) (f m))
;;                                     (set-arg max f m xs), 
;;                                     where (not (> (f x) (f m)))
;; 
;;  

(define set-arg-max (f m xs)
    (if (null? (cdr xs))
        (if (> (f (car xs)) (f m))
            (car xs)
            m)
        (if (> (f (car xs)) (f m))
            (set-arg-max f (car xs) (cdr xs))
            (set-arg-max f m (cdr xs)))))

        (check-expect (set-arg-max square 0 '(5)) 5)
        (check-expect (set-arg-max square 9 '(8 7)) 9)
        (check-expect (set-arg-max square 10 '(0 10 0 0 0)) 10)

;; (arg-max f xs) takes a function f that maps a value
;; in set X to a number, and a nonempty list xs of values in set AX 
;; It returns an element m in as for which (f x) is as large as possible; this
;; element is determined by (set-arg-max). 

;; laws:
;;   (arg-max f (cons x '())) == x
;;   (arg-max f (cons x xs)) == (set-arg-max f x xs)

;;  
(define arg-max (f xs) 
    (if (null? (cdr xs))
        (car xs)
        (set-arg-max f (car xs) (cdr xs))))
        ; sets the max to the front of the list xs

        (check-expect (arg-max square '(5 4 3 2 1)) 5)
        (check-expect (arg-max square '(8 7 9 7 7)) 9)
        (check-expect (arg-max square '(0 0 0 0 0)) 0)


