(let* ([$r1 2] [$r2 3] [$r2 (set $r1 $r2)])
  (check $r2 'three))
(let ([$r4 3])
  (expect $r4 'three))