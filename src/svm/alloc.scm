; file alloc.scm
(set N 1000)

  (let* ([x #f]
        [y 'hello]
        [z y])
    (begin
      (while (> N 0)
             (begin
               (set x (cons 'a 'b))
               (set N (- N 1))))
      (println y)
      (println z)
      x))


