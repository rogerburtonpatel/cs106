; (define testCaseLetrec (x)
;   (letrec (
; [hi2
;   (lambda (z) (* z z))]
; [hi
;   (lambda (z) (+ z z))]
; [bye (lambda (w) (- w w))])

;     (case x
;       [(POINT p) (bye p)]
;       [(HORIZ y) (hi y)])))

(define normalLetrec (x)
  (letrec (
(hi2
  (lambda (z) (* z z)))
(hi
  (lambda (z) (+ (hi2 z) z)))
(bye (lambda (w) (- (hi w) w))))

    (bye x)))

; (define mergesort (compare)
;   (letrec
;     ((merge (lambda (xs ys)
;         xs))

;      (split (lambda (xs half other-half)
;                (case xs
;                   ['() (pair half other-half)]
;                   [(cons y ys)
;                       (split ys other-half (cons y half))])))

;      (sort (lambda (xs)
;               (case xs
;                  ['() '()]
;                  [(cons y '()) xs]
;                  [_ (case (split xs '() '())
;                        [(PAIR half1 half2)
;                            (merge (sort half1) (sort half2))])])))
;                            )
;     sort))
