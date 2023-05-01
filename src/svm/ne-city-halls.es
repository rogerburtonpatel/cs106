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
(check-expect (point-distance-squared 7 1 (make-2Dpoint 3 4 'test))
              25)

(check-principal-type* point-distance-squared (forall ['a] (int int (2Dpoint 'a) -> int)))

(check-type point-distance-squared (forall ['a] (int int (2Dpoint 'a) -> int)))
(check-type argmin (forall ['a] (('a -> int) (list 'a) -> 'a)))
(check-expect (argmin square '(5000 -4000 3000 -2000)) -2000)
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

(check-type slow-nearest-point
            (forall ['a] (int int (list (2Dpoint 'a)) -> (2Dpoint 'a))))
(define slow-nearest-point (x y pts)
  (argmin (lambda (pt) (+ (square (- (2Dpoint-x pt) x))
                          (square (- (2Dpoint-y pt) y))))
          pts))

(define closer (x y p1 p2)
  (if (< (point-distance-squared x y p1) (point-distance-squared x y p2))
      p1
      p2))

(check-principal-type* closer (forall ['a] (int int (2Dpoint 'a) (2Dpoint 'a) -> (2Dpoint 'a))))

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

(check-principal-type* nearest-point (forall ['a] (int int (2Dtree 'a) -> (2Dpoint 'a))))

(check-type mergesort
   (forall ['a] (('a 'a -> order) -> ((list 'a) -> (list 'a)))))

(check-expect (Int.compare 3 7) LESS)
(check-expect (Int.compare 7 3) GREATER)
(check-expect (Int.compare 7 7) EQUAL)

(check-expect ((mergesort Int.compare) '()) '())
(check-expect ((mergesort Int.compare) '(1)) '(1))
(check-expect ((mergesort Int.compare) '(2 1)) '(1 2))

(check-expect ((mergesort Int.compare) '(9 7 4 1 5 8 6 3 2))
              '(1 2 3 4 5 6 7 8 9))


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

(check-principal-type* mergesort (forall ['a] (('a 'a -> order) -> ((list 'a) -> (list 'a)))))
(check-principal-type* sort-on (forall ['a] (('a -> int) -> ((list 'a) -> (list 'a)))))

(check-expect (halves '(1 2 3 4))   (pair '(1 2) '(3 4)))
(check-expect (halves '(1 2 3 4 5)) (pair '(1 2) '(3 4 5)))

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

(check-principal-type* halves (forall ['a] ((list 'a) -> (pair (list 'a) (list 'a)))))

(check-principal-type* vert-funs (forall ['a] (coord-funs 'a)))
(check-principal-type* horiz-funs (forall ['a] (coord-funs 'a)))

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

(check-principal-type* 2Dtree (forall ['a] ((list (2Dpoint 'a)) -> (2Dtree 'a))))

(val test-points
   (list3 (make-2Dpoint 10 12 'A)
          (make-2Dpoint  5  6 'B)
          (make-2Dpoint 33 99 'C)))
(val test-tree (2Dtree test-points))
(check-principal-type* (nearest-point  11  11 test-tree) 2Dpoint)
(check-expect (2Dpoint-value (nearest-point  11  11 test-tree)) 'A)
(check-expect (2Dpoint-value (nearest-point 100 100 test-tree)) 'C)

(record deg ([microdegrees : int]))

(define deg-diff (d1 d2)
  (make-deg (- (deg-microdegrees d1) (deg-microdegrees d2))))

(check-principal-type* deg-diff (deg deg -> deg))

(record poi ([name : sym] [lat : deg] [lon : deg]))

(define easy-poi (name lat-n lat-frac lon-n lon-frac)
  (let ([degrees (lambda (whole frac) (make-deg (+ (* 1000000 whole) frac)))])
    (make-poi name (degrees lat-n lat-frac) (degrees lon-n lon-frac))))

(check-principal-type* easy-poi (sym int int int int -> poi))

(val boston (easy-poi 'City-of-Boston 42 332221 -71 -016432))
(val meters-in-degree-lat 111080)
(val meters-in-degree-lon  82418)

(val distance-unit-in-meters 30)

(define /-round (dividend divisor)
  (/ (+ dividend (/ divisor 2)) divisor))

(define distance-of-microdegrees (meters-in-degree microdegrees)
  (let ([meters (* (/-round meters-in-degree 1000) (/-round microdegrees 1000))])
    (/-round meters distance-unit-in-meters)))

(define distance-of-degrees-lat (d)
  (distance-of-microdegrees meters-in-degree-lat (deg-microdegrees d)))
(define distance-of-degrees-lon (d)
  (distance-of-microdegrees meters-in-degree-lon (deg-microdegrees d)))

(define 2Dpoint-of-poi (p)
  (let* ([delta-north (deg-diff (poi-lat p) (poi-lat boston))]
         [delta-east  (deg-diff (poi-lon p) (poi-lon boston))])
    (make-2Dpoint (distance-of-degrees-lon delta-east)
                  (distance-of-degrees-lat delta-north)
                  p)))

(check-principal-type* 2Dpoint-of-poi (poi -> (2Dpoint poi)))

(define nearest-to-poi (poi tree)
  (case (2Dpoint-of-poi poi)
    [(make-2Dpoint x y _) (nearest-point x y tree)]))

(val pinnacle-rock    (easy-poi 'Pinnacle-Rock    42 439467 -71 -078238))
(val gillette-stadium (easy-poi 'Gillette-Stadium 42 090900 -71 -264300))
(val tufts            (easy-poi 'Tufts-University 42 408222 -71 -116402))
(val mt-washington    (easy-poi 'Mount-Washington 44 270500 -71 -303200))
(val the-breakers     (easy-poi 'The-Breakers     41 469722 -71 -298611))
(val mark-twain-house (easy-poi 'Mark-Twain-House 41 767139 -72 -700500))
(val pois
  (let* ((things '())
         (things (cons (easy-poi 'Warwick-City-Hall/RI 41 699200 -72 541399) things))
         (things (cons (easy-poi 'East-Providence-City-Hall/RI 41 819400 -72 622399) things))
         (things (cons (easy-poi 'Pittsfield-City-Hall/MA 42 450100 -74 747999) things))
         (things (cons (easy-poi 'Springfield-City-Hall/MA 42 101483 -73 409355) things))
         (things (cons (easy-poi 'Northampton-City-Hall/MA 42 317312 -73 364909) things))
         (things (cons (easy-poi 'Quincy-City-Hall/MA 42 250933 -72 996062) things))
         (things (cons (easy-poi 'Newton-City-Hall-and-War-Memorial/MA 42 337597 -72 791611) things))
         (things (cons (easy-poi 'New-Britain-City-Hall/CT 41 668433 -73 217679) things))
         (things (cons (easy-poi 'Hartford-City-Hall/CT 41 762600 -73 326295) things))
         (things (cons (easy-poi 'Bridgeport-City-Hall/CT 41 180375 -74 809331) things))
         (things (cons (easy-poi 'New-Haven-City-Hall/CT 41 307597 -73 75730) things))
         (things (cons (easy-poi 'Milford-City-Hall/CT 41 224264 -74 941559) things))
         (things (cons (easy-poi 'Norwich-City-Hall/CT 41 526209 -73 923811) things))
         (things (cons (easy-poi 'New-London-City-Hall/CT 41 354543 -73 903534) things))
         (things (cons (easy-poi 'Middletown-City-Hall/CT 41 561765 -73 352128) things))
         (things (cons (easy-poi 'Rutland-City-Hall/VT 43 605346 -73 21837) things))
         (things (cons (easy-poi 'Saint-Albans-City-Hall/VT 44 813379 -74 915974) things))
         (things (cons (easy-poi 'Montpelier-City-Hall/VT 44 260337 -73 424612) things))
         (things (cons (easy-poi 'Barre-City-Hall/VT 44 197006 -73 498783) things))
         (things (cons (easy-poi 'Burlington-City-Hall/VT 44 476994 -74 786816) things))
         (things (cons (easy-poi 'Vergennes-City-Hall/VT 44 168666 -74 749043) things))
         (things (cons (easy-poi 'Keene-City-Hall/NH 42 934248 -73 721858) things))
         (things (cons (easy-poi 'Enfield-City-Hall/NH 43 642850 -73 855745) things))
         (things (cons (easy-poi 'Franklin-City-Hall/NH 43 443965 -72 351867) things))
         (things (cons (easy-poi 'Concord-City-Hall/NH 43 206192 -72 459927) things))
         (things (cons (easy-poi 'Lebanon-City-Hall-and-Opera-House/NH 43 640627 -73 748242) things))
         (things (cons (easy-poi 'Berlin-City-Hall/NH 44 470058 -72 819922) things))
         (things (cons (easy-poi 'Nashua-City-Hall/NH 42 758144 -72 534933) things))
         (things (cons (easy-poi 'Milford-City-Hall/NH 42 835920 -72 349927) things))
         (things (cons (easy-poi 'Manchester-City-Hall/NH 42 992584 -72 536321) things))
         (things (cons (easy-poi 'Laconia-City-Hall/NH 43 527855 -72 530204) things))
         (things (cons (easy-poi 'Alton-City-Hall/NH 43 456191 -72 779932) things))
         (things (cons (easy-poi 'Somersworth-City-Hall/NH 43 258973 -71 137717) things))
         (things (cons (easy-poi 'Rochester-City-Hall/NH 43 305082 -71 24103) things))
         (things (cons (easy-poi 'Durham-City-Hall/NH 43 132585 -71 79940) things))
         (things (cons (easy-poi 'Portsmouth-City-Hall/NH 43 70922 -71 246335) things))
         (things (cons (easy-poi 'Brewer-City-Hall/ME 44 795627 -69 238019) things))
         (things (cons (easy-poi 'Bangor-City-Hall/ME 44 803682 -69 229685) things))
         (things (cons (easy-poi 'Portland-City-Hall/ME 43 659804 -71 745784) things))
         (things (cons (easy-poi 'Ellsworth-City-Hall/ME 44 542854 -69 575535) things))
         (things (cons (easy-poi 'Biddeford-City-Hall/ME 43 493140 -71 543559) things))
         (things (cons (easy-poi 'Presque-Isle-City-Hall/ME 46 683098 -69 985804) things))
         (things (cons (easy-poi 'Rockland-City-Hall/ME 44 102025 -70 891347) things))
         (things (cons (easy-poi 'Lewiston-City-Hall/ME 44 94240 -71 784389) things))
         (things (cons (easy-poi 'Woonsocket-City-Hall/RI 42 2321 -72 485771) things))
         (things (cons (easy-poi 'Providence-City-Hall/RI 41 823989 -72 587442) things))
         (things (cons (easy-poi 'Pawtucket-City-Hall/RI 41 878989 -72 617721) things))
         (things (cons (easy-poi 'Cranston-City-Hall/RI 41 779267 -72 563275) things))
         (things (cons (easy-poi 'Central-Falls-City-Hall/RI 41 887044 -72 612443) things))
         (things (cons (easy-poi 'Newport-City-Hall/RI 41 490102 -72 687171) things))
         (things (cons (easy-poi 'Old-City-Hall/MA 42 645647 -72 689105) things))
         (things (cons (easy-poi 'Gloucester-City-Hall/MA 42 615095 -71 337732) things))
         (things (cons (easy-poi 'Easthampton-City-Hall/MA 42 271201 -73 327130) things))
         (things (cons (easy-poi 'Woburn-City-Hall/MA 42 470929 -72 845500) things))
         (things (cons (easy-poi 'Waltham-City-Hall/MA 42 376207 -72 764388) things))
         (things (cons (easy-poi 'Lawrence-City-Hall/MA 42 708147 -72 839941) things))
         (things (cons (easy-poi 'Taunton-City-Hall/MA 41 900101 -72 910787) things))
         (things (cons (easy-poi 'Brockton-City-Hall/MA 42 82045 -72 981065) things))
         (things (cons (easy-poi 'Worcester-City-Hall/MA 42 262593 -72 199928) things))
         (things (cons (easy-poi 'Marlborough-City-Hall/MA 42 345927 -72 452434) things))
         (things (cons (easy-poi 'Westfield-City-Hall/MA 42 120926 -73 246016) things))
         (things (cons (easy-poi 'Chicopee-City-Hall/MA 42 148427 -73 394354) things))
         (things (cons (easy-poi 'Newton-City-Hall/MA 42 337597 -72 791333) things))
         (things (cons (easy-poi 'Peabody-City-Hall/MA 42 942589 -71 71332) things))
         (things (cons (easy-poi 'Salem-City-Hall/MA 42 522318 -71 104672) things))
         (things (cons (easy-poi 'Beverly-City-Hall/MA 42 547317 -71 121339) things))
         (things (cons (easy-poi 'Lynn-City-Hall/MA 42 464263 -71 48561) things))
         (things (cons (easy-poi 'Newburyport-City-Hall/MA 42 811202 -71 122724) things))
         (things (cons (easy-poi 'Gardner-City-Hall/MA 42 577033 -72 4088) things))
         (things (cons (easy-poi 'North-Adams-City-Hall/MA 42 698693 -74 886006) things))
         (things (cons (easy-poi 'Revere-City-Hall/MA 42 407875 -72 986893) things))
         (things (cons (easy-poi 'Chelsea-City-Hall/MA 42 393986 -72 966615) things))
         (things (cons (easy-poi 'Everett-City-Hall/MA 42 408430 -72 945503) things))
         (things (cons (easy-poi 'Malden-City-Hall/MA 42 425930 -72 932725) things))
         (things (cons (easy-poi 'Melrose-City-Hall/MA 42 456763 -72 934669) things))
         (things (cons (easy-poi 'Cambridge-City-Hall-Annex/MA 42 370375 -72 896613) things))
         (things (cons (easy-poi 'Cambridge-City-Hall/MA 42 367319 -72 893836) things))
         (things (cons (easy-poi 'Boston-City-Hall/MA 42 360375 -72 942170) things))
         (things (cons (easy-poi 'New-Bedford-City-Hall/MA 41 635660 -71 72461) things))
         (things (cons (easy-poi 'Attleboro-City-Hall/MA 41 945100 -72 714946) things))
         (things (cons (easy-poi 'Lowell-City-Hall/MA 42 645925 -72 686049) things))
         (things (cons (easy-poi 'Somerville-City-Hall/MA 42 387319 -72 901336) things))
         (things (cons (easy-poi 'Haverhill-City-Hall/MA 42 775646 -72 921608) things)))
    things))

(val city-halls pois)

(val nearest-city-hall
      (let ([t (2Dtree (map 2Dpoint-of-poi city-halls))])
        (lambda (poi) (poi-name (2Dpoint-value (nearest-to-poi poi t))))))

(check-expect (nearest-city-hall tufts) 'Somerville-City-Hall/MA)