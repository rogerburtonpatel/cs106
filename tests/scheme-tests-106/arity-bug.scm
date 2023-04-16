(define qsort-arity-bug (xs)
  (if (null? xs)
      '()
      (let* ([pivot  (car xs)]
             [rest   (cdr xs)]
             [right? (lambda (n) (> n pivot))]
             [left?  (o not right?)])
             (filter right? rest))))

(check-expect (qsort-arity-bug '(1 2)) '(2))