(let* ([$r0 2] [$r1 2] [$r0 (+ $r0 $r1)])
  (check $r0 'two-plus-two))
(let* ([$r0 5])
  (expect $r0 'five))