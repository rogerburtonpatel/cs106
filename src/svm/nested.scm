; the useful unnested patterns:  | K.VMOP (P.HAS_EFFECT p, rs) and 
;                              | exp (K.LETX (n, e, K.NAME n')) 
; from codegen.sml:151 and knembed.sml:60, respectively. 

(define f (maybeEffectfulVmop)
    (case maybeEffectfulVmop
        [(K.VMOP (P.HAS_EFFECT p) rs) 'success]
        [_ 'fail]))

(define g (maybeLetWithName)
    (case maybeLetWithName
        [(K.LETX n e (K.NAME n')) 'success]
        [_ 'fail]))

(check-expect (f (K.VMOP (P.HAS_EFFECT 3) 4)) 'success)
(check-expect (f (K.VMOP P.HAS_EFFECT 3 4)) 'fail)
(check-expect (g (K.LETX 'hi 3 (K.NAME 'hi2))) 'success)
(check-expect (g (K.VMOP 'hi 3 (K.NAME 'hi2))) 'fail)
(define f-unnested (maybeEffectfulVmop)
    (case maybeEffectfulVmop
        [(K.VMOP prim rs) 
            (case prim
                [(P.HAS_EFFECT p) 'success]
                [_ 'fail])]
        [_ 'fail]))

(define g-unnested (maybeLetWithName)
    (case maybeLetWithName
        [(K.LETX n e name) 
            (case name
                [(K.NAME n') 'success]
                [_ 'fail])]
        [_ 'fail]))

(check-expect (f-unnested (K.VMOP (P.HAS_EFFECT 3) 4)) 'success)
(check-expect (f-unnested (K.VMOP P.HAS_EFFECT 3 4)) 'fail)
(check-expect (g-unnested (K.LETX 'hi 3 (K.NAME 'hi2))) 'success)
(check-expect (g-unnested (K.VMOP 'hi 3 (K.NAME 'hi2))) 'fail)