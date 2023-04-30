(record ('a) 2Dpoint ([x : int] [y : int] [value : 'a]))

(define 2Dpoint-x     (p) (case p ([make-2Dpoint x y value] x)))
(define 2Dpoint-y     (p) (case p ([make-2Dpoint x y value] y)))
(define 2Dpoint-value (p) (case p ([make-2Dpoint x y value] value)))

(implicit-data ('a) 2Dtree
   [POINT of (2Dpoint 'a)]
   [HORIZ of int (2Dtree 'a) (2Dtree 'a)] ; location below above
   [VERT  of int (2Dtree 'a) (2Dtree 'a)] ; location left right
)

(define square (n) (* n n))
(define point-distance-squared (x y p)
  (+ (square (- x (2Dpoint-x p)))
     (square (- y (2Dpoint-y p)))))
; (check-expect (point-distance-squared 7 1 (make-2Dpoint 3 4 'test))
;               25)

; (check-principal-type* point-distance-squared (forall ['a] (int int (2Dpoint 'a) -> int)))

; (check-type point-distance-squared (forall ['a] (int int (2Dpoint 'a) -> int)))
; (check-type argmin (forall ['a] (('a -> int) (list 'a) -> 'a)))
; (check-expect (argmin square '(5000 -4000 3000 -2000)) -2000)
(define argmin (f xs)
  (letrec ([find (lambda (best-x smallest-result xs)
                   (case xs
                     ['() best-x]
                     [(cons y ys)
                         (let ([result (f y)])
                           (if (< result smallest-result)
                               (find y result ys)
                               (find best-x smallest-result ys)))]))])
    (case xs
      ['() (error 'argmin-of-empty-list)]
      [(cons y ys) (find y (f y) ys)])))

; (check-type slow-nearest-point
;             (forall ['a] (int int (list (2Dpoint 'a)) -> (2Dpoint 'a))))
(define slow-nearest-point (x y pts)
  (argmin (lambda (pt) (+ (square (- (2Dpoint-x pt) x))
                          (square (- (2Dpoint-y pt) y))))
          pts))

(define closer (x y p1 p2)
  (if (< (point-distance-squared x y p1) (point-distance-squared x y p2))
      p1
      p2))

; (check-principal-type* closer (forall ['a] (int int (2Dpoint 'a) (2Dpoint 'a) -> (2Dpoint 'a))))

(define nearest-point (x y tree)
  (letrec (

[near-or-far
  (lambda (x y near far the-B-squared)
    (let* ([closest-near  (nearest-point x y near)]
           [the-N-squared (point-distance-squared x y closest-near)])
      (if (<= the-N-squared the-B-squared)
          closest-near ; don't need to search the far subtree
          (closer x y closest-near (nearest-point x y far)))))]

                                                              )
    (case tree
      [(POINT p) p]
      [(HORIZ y-boundary below above)
           (if (> y y-boundary)
               (near-or-far x y above below (square (- y y-boundary)))
               (near-or-far x y below above (square (- y y-boundary))))]
      [(VERT  x-boundary left right)
           (if (> x x-boundary)
               (near-or-far x y right left  (square (- x x-boundary)))
               (near-or-far x y left  right (square (- x x-boundary))))])))

; (check-principal-type* nearest-point (forall ['a] (int int (2Dtree 'a) -> (2Dpoint 'a))))

; (check-type mergesort
;    (forall ['a] (('a 'a -> order) -> ((list 'a) -> (list 'a)))))

; (check-expect (Int.compare 3 7) LESS)
; (check-expect (Int.compare 7 3) GREATER)
; (check-expect (Int.compare 7 7) EQUAL)

; (check-expect ((mergesort Int.compare) '()) '())
; (check-expect ((mergesort Int.compare) '(1)) '(1))
; (check-expect ((mergesort Int.compare) '(2 1)) '(1 2))

; (check-expect ((mergesort Int.compare) '(9 7 4 1 5 8 6 3 2))
;               '(1 2 3 4 5 6 7 8 9))


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

; (check-principal-type* mergesort (forall ['a] (('a 'a -> order) -> ((list 'a) -> (list 'a)))))
; (check-principal-type* sort-on (forall ['a] (('a -> int) -> ((list 'a) -> (list 'a)))))

; (check-expect (halves '(1 2 3 4))   (pair '(1 2) '(3 4)))
; (check-expect (halves '(1 2 3 4 5)) (pair '(1 2) '(3 4 5)))

(define halves (xs)
  (letrec ([scan (lambda (left^ right ys)
                   ; invariants: xs = (revapp left^ right)
                   ;             (length xs) = (length ys) + 2 * (length left^)
                   (case ys
                     ((cons _ (cons _ zs))
                        (case right
                          ('() (error 'this-cannot-happen))
                          ((cons w ws)
                             (scan (cons w left^) ws zs))))
                     (_ (pair (reverse left^) right))))])
    (scan '() xs xs)))

(define first (xs) (car xs))
(define last (xs)
  (case xs
    [(cons x '()) x]
    [(cons _ ys)  (last ys)]
    ['()          (error 'last-of-empty-list)]))

(record ('a) coord-funs
     ([project  : ((2Dpoint 'a) -> int)                       ]
      [mk-split : (int (2Dtree 'a) (2Dtree 'a) -> (2Dtree 'a))]))

(val vert-funs  (make-coord-funs 2Dpoint-x (lambda (x y z) (VERT x y z))))
(val horiz-funs (make-coord-funs 2Dpoint-y (lambda (x y z) (HORIZ x y z))))

; (check-principal-type* halves (forall ['a] ((list 'a) -> (pair (list 'a) (list 'a)))))

; (check-principal-type* vert-funs (forall ['a] (coord-funs 'a)))
; (check-principal-type* horiz-funs (forall ['a] (coord-funs 'a)))

(val all-coordinates (list2 vert-funs horiz-funs))
(define 2Dtree (points)
  (letrec
      ([build (lambda (points remaining-coordinates)
                  (case remaining-coordinates
                    ['() (build points all-coordinates)] ; start over
                    [(cons cfuns next-remaining)
                       (case points
                         [(cons pt '()) (POINT pt)]
                         [_  

(let* ([project    (coord-funs-project  cfuns)]
       [mk-split   (coord-funs-mk-split cfuns)]
       [sort       (sort-on project)]
       [points     (sort points)]
       [the-halves (halves points)]
       [small      (fst the-halves)]
       [large      (snd the-halves)]
       [_          (if (null? small) (error 'empty-small-tree) UNIT)]
       [_          (if (null? large) (error 'empty-large-tree) UNIT)]
       [average    (lambda (n m) (/ (+ n m) 2))]
       [median     (average (project (last small)) (project (first large)))])
  (mk-split median (build small next-remaining) (build large next-remaining)))

                                                                           ])]))])
      (build points all-coordinates)))

; (check-principal-type* 2Dtree (forall ['a] ((list (2Dpoint 'a)) -> (2Dtree 'a))))

(val test-points
   (list3 (make-2Dpoint 10 12 'A)
          (make-2Dpoint  5  6 'B)
          (make-2Dpoint 33 99 'C)))
(val test-tree (2Dtree test-points))
(check-expect (2Dpoint-value (nearest-point  11  11 test-tree)) 'A)
; (check-expect (2Dpoint-value (nearest-point 100 100 test-tree)) 'C)

; (record deg ([microdegrees : int]))

; (define deg-diff (d1 d2)
;   (make-deg (- (deg-microdegrees d1) (deg-microdegrees d2))))

; (check-principal-type* deg-diff (deg deg -> deg))

; (record poi ([name : sym] [lat : deg] [lon : deg]))

; (define easy-poi (name lat-n lat-frac lon-n lon-frac)
;   (let ([degrees (lambda (whole frac) (make-deg (+ (* 1000000 whole) frac)))])
;     (make-poi name (degrees lat-n lat-frac) (degrees lon-n lon-frac))))

; (check-principal-type* easy-poi (sym int int int int -> poi))

; (val boston (easy-poi 'City-of-Boston 42 332221 -71 -016432))
; (val meters-in-degree-lat 111080)
; (val meters-in-degree-lon  82418)

; (val distance-unit-in-meters 30)

; (define /-round (dividend divisor)
;   (/ (+ dividend (/ divisor 2)) divisor))

; (define distance-of-microdegrees (meters-in-degree microdegrees)
;   (let ([meters (* (/-round meters-in-degree 1000) (/-round microdegrees 1000))])
;     (/-round meters distance-unit-in-meters)))

; (define distance-of-degrees-lat (d)
;   (distance-of-microdegrees meters-in-degree-lat (deg-microdegrees d)))
; (define distance-of-degrees-lon (d)
;   (distance-of-microdegrees meters-in-degree-lon (deg-microdegrees d)))

; (define 2Dpoint-of-poi (p)
;   (let* ([delta-north (deg-diff (poi-lat p) (poi-lat boston))]
;          [delta-east  (deg-diff (poi-lon p) (poi-lon boston))])
;     (make-2Dpoint (distance-of-degrees-lon delta-east)
;                   (distance-of-degrees-lat delta-north)
;                   p)))

; (check-principal-type* 2Dpoint-of-poi (poi -> (2Dpoint poi)))

; (define nearest-to-poi (poi tree)
;   (case (2Dpoint-of-poi poi)
;     [(make-2Dpoint x y _) (nearest-point x y tree)]))

; (val pinnacle-rock    (easy-poi 'Pinnacle-Rock    42 439467 -71 -078238))
; (val gillette-stadium (easy-poi 'Gillette-Stadium 42 090900 -71 -264300))
; (val tufts            (easy-poi 'Tufts-University 42 408222 -71 -116402))
; (val mt-washington    (easy-poi 'Mount-Washington 44 270500 -71 -303200))
; (val the-breakers     (easy-poi 'The-Breakers     41 469722 -71 -298611))
; (val mark-twain-house (easy-poi 'Mark-Twain-House 41 767139 -72 -700500))