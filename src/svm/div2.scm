;; blondo01 -- Divide by Two Benchmark
;; Benchmark that divides by 2 using lists of n NIL’s.
;; Uses unary representation of numbers

(val N 2500) ;; problem size: number of elements and number of loops

(define cddr (sx) (cdr (cdr  sx)))
(define not (b)   (if b #f #t))



(define len (xs)
  (let ([i 0]
        [a xs])
    (begin 
      (while (not (null? a))
        (begin 
          (set i (+ i 1))
          (set a (cdr a))))
      i)))

(define create-n (n)
  (let ([a '()])
    (begin 
      (while (!= n 0)
        (begin 
          (set a (cons '() a))
          (set n (- n 1))))
      a)))

(val ll (create-n (* N 2))) ;; make it an even number

(define iterative-div2 (l)
  (let ([a '()])
    (begin 
      (while (not (null? l))
        (begin 
          (set a (cons (car l) a))
          (set l (cddr l))))

      
      a)))

(define recursive-div2 (l)
  (if (null? l)
    '()
    (cons (car l) (recursive-div2 (cddr l)))))

(define test-1 (l)
  (let ([i 300])
    (while (> i 0)
      (begin 
        (iterative-div2 l)
        (iterative-div2 l)
        (iterative-div2 l)
        (iterative-div2 l)
        (iterative-div2 l)
        (iterative-div2 l)
        (iterative-div2 l)
        (iterative-div2 l)
        (set i (- i 1))))))

(define test-2 (l)
  (let ([i 300])
    (while (> i 0)
      (begin 
        (recursive-div2 l)
        (recursive-div2 l)
        (recursive-div2 l)
        (recursive-div2 l)
        (recursive-div2 l)
        (recursive-div2 l)
        (recursive-div2 l)
        (recursive-div2 l)
        (set i (- i 1))))))

(define testdiv2-iter ()
  (test-1 ll))

(define testdiv2-recur ()
  (test-2 ll))

(define testdiv2 ()
  (begin 
    (testdiv2-iter)
    (testdiv2-recur)))

(testdiv2)
(check-expect (len (iterative-div2 ll)) N)
(check-expect (len (recursive-div2 ll)) N)