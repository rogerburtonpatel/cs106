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
(define not (b)   (if b #f #t))
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
(define <= (x y) (not (> x y)))
(define >= (x y) (not (< x y)))
(define != (x y) (not (= x y)))
;  predefined uScheme functions S150e 
(define max (x y) (if (> x y) x y))
(define min (x y) (if (< x y) x y))
;  predefined uScheme functions S151a 
(define negated (n) (- 0 n))
(define mod (m n) (- m (* n (idiv m n))))
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

;;;;;;;;;;;;;;;;;;; COMP 105 SCHEME III ASSIGNMENT ;;;;;;;;;;;;;;;

; included for unit-testing
(define even? (n) (= (mod n 2) 0))
(define value? (_) #t) ;; tell if the argument is a value

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 2

;; Forms of data: predicate function A?, an arbitrary value v.  

;; Example input: (atom? 1) (function? '('COMP)) (even? even?)

;; (list-of? A? v) takes a predicate function A? and any value v and returns 
;;                 #t if v is a list of values, each of which satisfies A?. 
;;                 Returns #f otherwise.

;; laws: 
;;      (list-of? A? '()) == #t
;;      (list-of? A? (cons k ks)) == #f, where (not (A? k))
;;      (list-of? A? (cons k ks)) == (list-of? A? ks), where (A? k) and 
;;                                                               ks is a list.
;;      (list-of? A? v) == #f, where v has none of the forms above.

(define list-of? (A? v) 
    (if (null? v)
        #t ; this is the only #t exit case, so that cons pairs can't pass
        (if (pair? v)
            (if (A? (car v))
                (list-of? A? (cdr v))
                #f)
            #f)))

        (check-assert (list-of? atom? '()))
        (check-assert (list-of? atom? (list3 1 2 'a)))
        (check-assert (not (list-of? atom? (list3 o 2 'a))))
        ; (check-assert (list-of? function? (list3 car cdr o)))
        (check-assert (not (list-of? even? even?)))
        (check-assert (list-of? even? (cons 2 '())))
        (check-assert (not (list-of? atom? (cons 1 2))))
        (check-assert (not (list-of? atom? (cons 1 (cons 'a 2)))))
        (check-assert (not (list-of? atom? (cons '() (cons '() 2)))))
        
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 3

; included for unit-testing
(record not [f])
(record and [fs])
(record or [fs])
;; Forms of data: an arbitrary value v.  

;; Example input: 1, function?, 'x, (make-not f) 

;; (formula? v) takes any value v and returns #t if v is a valid Boolean 
;;              formula for the SAT solver; i.e. is a symbol or a record 
;;              (make-not f), (make-and fs), or (make-or fs), 
;;              where f is a formula. 

;; laws: 
;;      (formula? v) == #t, where (symbol? v)
;;      (formula? (make-not f)) == (formula? f)
;;      (formula? (make-and fs)) == (list-of? formula? fs)
;;      (formula? (make-or fs)) == (list-of? formula? fs)
;;      (formula? v) == #f, where v has none of the forms above.

(define formula? (v)
    (if (symbol? v)
        #t
        (if (not? v)
            (formula? (not-f v))
            (if (and? v)
                (list-of? formula? (and-fs v))
                (if (or? v)
                    (list-of? formula? (or-fs v))
                    #f)))))

        ; null cases 
        (check-assert (formula? (make-and '()))) 
        (check-assert (formula? (make-or '()))) 
        (check-assert (not (formula? (make-not '()))))
        
        ; true cases for all  
        (check-assert (formula? 'x))
        (check-assert (formula? (make-not 'y)))
        (check-assert (formula? (make-and (list2 'y 'x)))) 
        (check-assert (formula? (make-or (list3 'y 'x 'z))))
        (check-assert (formula? 
                          (make-or (list3 (make-not 'x) 'x 
                                     (make-and (list2 'y 'z))))))
        ; false cases for all
        (check-assert (not (formula? #t)))
        (check-assert (not (formula? (make-not #t))))
        (check-assert (not (formula? (make-and (list2 'y #f)))))
        (check-assert (not (formula? (make-or (list3 'y 'x #t)))))
        (check-assert (not (formula? 
                                (make-or (list3 (make-not 'x) 'x 
                                            (make-and (list2 'y #t)))))))
        
        

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 4

;; environments for testing 
   (val test-env (list3 (list2 'x #t) (list2 'y #t) (list2 'z #t)))
  ;  (val test-env (list3 '(x #t) '(y #t) '(z #t)))

;; Forms of data: a formula f and an environment env. 

;; Example input: ('x test-env) ((make-not 'x) test-env) 
;;                ((make-or (list2 'x 'y)) test-env) 
;;                ((make-and (list2 'x 'y)) test-env) 

;; (eval-formula f env) takes a formula f and an environment env such that 
;;                      every variable in f is bound in env and returns 
;;                      the binding of f in env if f is a symbol and 
;;                      the evaluation of each formula in f if f is a list of
;;                      formulas. 

;; laws: 
;;      (eval-formula x env) == (find x env), where x is a symbol.
;;      (eval-formula (make-not f) env) == (not (eval-formula f))
;;      (eval-formula (make-and fs) env) == 
;;                                    (all? (lambda (f) eval-formula f env) fs)
;;      (formula? (make-or fs) env) ==
;;                                 (exists? (lambda (f) eval-formula f env) fs)

;; brief explanation of lambdas: they are used to iterate through fs using 
;;                               built-ins all? and exists?. being one-argument
;;                               functions, these require a parameter 
;;                               shortening, and unfortunately in the wrong 
;;                               direction of curry. 
(define eval-formula (f env)
    (if (symbol? f)
        (find f env)
        (if (not? f)
            (not (eval-formula (not-f f) env))
            (if (and? f)
                (all? (lambda (x) (eval-formula x env)) (and-fs f))
                (exists? (lambda (x) (eval-formula x env)) (or-fs f))))))
 
        (check-assert (eval-formula 'x test-env))
        (check-assert (not (eval-formula (make-not 'y) test-env)))
        (check-assert (eval-formula (make-and (list2 'y 'x)) test-env))
        (check-assert (eval-formula 
                        (make-or (list3 'y (make-not 'x) 'z)) test-env))

        (check-assert (not (eval-formula 
                                    (make-or (list2 (make-not 'x) 
                                              (make-and (list2 
                                                         (make-not 'y) 'z)))) 
                                                                   test-env)))

        (check-assert (eval-formula (make-and '()) test-env))
        (check-assert (not (eval-formula 
                                (make-or '()) test-env)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;
;;;;  Problem 6

;; Forms of data: a formula f, a failure continuation fail, and a success 
;;                continuation succ. 

;; Example input: 

;; (find-formula-true-asst f fail succ) takes a formula f, a failure 
;;                      continuation fail, and a success continuation succ and 
;;                      calls succ to return an association list of boolean 
;;                      values if f has a satisfying assignment thereof and 
;;                      calls fail to return failure if not.  

;; ~the contract brigade~


;; (find-formula-symbol x bool cur fail succeed), where x is a symbol, 
;;                                                does one of three things:
;; If x is bound to bool in cur, succeeds with environment cur and 
;;                                         resume continuation fail
;; If x is bound to (not bool) in cur, fails
;; If x is not bound in cur, extends cur with a binding of x to bool, 
;; then succeeds with the extended environment and resume continuation fail


;; (find-all-asst formulas bool cur fail succeed) extends cur to find an 
;; assignment that makes every formula in the list formulas equal to bool.


;; (find-any-asst formulas bool cur fail succeed) extends cur to find an 
;; assignment that makes any one of the formulas equal to bool.

;; (find-formula-asst formula bool cur fail succeed) extends assignment cur to 
;; find an assignment that makes the single formula equal to bool.


(define find-formula-true-asst (f fail succ)
    (letrec (

;; laws: 
;; (find-formula-symbol x bool cur fail succeed) == 
;;      (succeed (bind x bool cur) fail), where x is not bound in cur
;; (find-formula-symbol x bool cur fail succeed) == 
;;      (succeed cur fail), where x is bool in cur
;; (find-formula-symbol x bool cur fail succeed) == (fail), 
;;                                                 where x is (not bool) in cur
              [find-formula-symbol 
                  (lambda (x bool cur fail succeed)
                      (if (null? (find x cur))
                          (succeed (bind x bool cur) fail)
                              (if (= bool (find x cur))
                                  (succeed cur fail)
                                  (fail))))]
;; laws: 
;; (find-all-asst '()         bool cur fail succeed) == (succeed cur fail)
;; (find-all-asst (cons f fs) bool cur fail succeed) == 
;;      (find-formula-asst f bool cur fail
;;        (lambda (current resume) find-all-asst fs bool current fail succeed))
              [find-all-asst 
                  (lambda (formulas bool cur fail succeed)
                      (if (null? formulas)
                          (succeed cur fail)
                          (find-formula-asst (car formulas) bool cur fail
                              (lambda (current resume)
                                  (find-all-asst 
                                      (cdr formulas) 
                                      bool current resume succeed)))))]
;; laws: 
;; (find-any-asst '()         bool cur fail succeed) == (fail)
;; (find-any-asst (cons f fs) bool cur fail succeed) == 
;;      (find-formula-asst f bool cur
;;        (lambda () find-any-asst fs bool cur fail succeed)
;;         succ)

              [find-any-asst 
                  (lambda (formulas bool cur fail succeed)
                      (if (null? formulas)
                          (fail)
                          (find-formula-asst (car formulas) bool cur
                              (lambda () 
                                  (find-any-asst 
                                    (cdr formulas) bool cur fail succeed))
                                                               succeed)))]

;; laws: 
;; (find-formula-asst x bool cur fail succeed) == 
;;      (find-formula-symbol x bool cur fail succeed), where x is a symbol

;; (find-formula-asst (make-not f)  bool cur fail succeed) == 
;;      (find-formula-asst f (not bool) cur fail succeed)

;; (find-formula-asst (make-or fs) #t cur fail succeed) == 
;;      (find-any-asst fs #t cur fail succeed)

;; (find-formula-asst (make-or fs) #f cur fail succeed) == ...
;;      (find-all-asst fs #f cur fail succeed)

;; (find-formula-asst (make-and fs) #t cur fail succeed) == ...
;;      (find-all-asst fs #t cur fail succeed)

;; (find-formula-asst (make-and fs) #f cur fail succeed) == ...
;;      (find-any-asst fs #f cur fail succeed)

              [find-formula-asst 
                  (lambda (formula bool cur fail succeed)
                      (if (symbol? formula)
                          (find-formula-symbol formula bool cur fail succeed)
                          (if (not? formula)
                              (find-formula-asst 
                                  (not-f formula) (not bool) cur fail succeed)
                              (if (or? formula)
                                  (if bool
                                      (find-any-asst 
                                          (or-fs formula) #t cur fail succeed)
                                      (find-all-asst 
                                          (or-fs formula) #f cur fail succeed))
                                  (if bool
                                      (find-all-asst 
                                          (and-fs formula) #t cur fail succeed)
                                      (find-any-asst
                                          (and-fs formula) #f 
                                                          cur fail 
                                                          succeed))))))])
  
            ; body
                (find-formula-asst f #t '() fail succ)))
; tests of (find-formula asst) are in solver-interface-tests.scm and 
;                                                      solver_tests.scm