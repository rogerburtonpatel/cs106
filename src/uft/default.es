  (define figure-6 (arg)
      (case arg
        [C1 'one]
        [_          'four]))

    (check-expect (figure-6 (C1 3 C4)) 'four)