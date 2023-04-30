(define mergesort (compare)
  (letrec
    ((merge (lambda (xs ys)
        (case xs
           ['() ys]
           [(cons z zs)
                (case ys
                   ['() xs]
                   [(cons w ws)
                       (case (compare z w)
                          [LESS (cons z (merge zs ys))]
                          [_    (cons w (merge ws xs))])])])))

     (split (lambda (xs half other-half)
               (case xs
                  ['() (pair half other-half)]
                  [(cons y ys)
                      (split ys other-half (cons y half))])))

     (sort (lambda (xs)
              (case xs
                 ['() '()]
                 [(cons y '()) xs]
                 [_ (case (split xs '() '())
                       [(PAIR half1 half2)
                           (merge (sort half1) (sort half2))])]))))
    sort))

(define sort-on (project)
  (mergesort (lambda (x1 x2) (Int.compare (project x1) (project x2)))))

(check-expect ((mergesort Int.compare) '(1 3 2)) '(1 2 3))