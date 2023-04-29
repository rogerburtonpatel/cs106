  (define nomatch (arg)
      (case arg
        [(C1 C2 C3) 'one]
        [(C1 x C4)  'two]
        [(C1 x C5)  'three]))

    (check-error (nomatch (HI 'norman))) ; for fun
    (check-expect (nomatch (C3 3 C4)) 'two) ; to see the error message