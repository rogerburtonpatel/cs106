(* Embeds KNormal-form Scheme into VScheme. This cannot fail. *)

(* You'll complete this file *)

structure KNEmbed :> sig
  val value : KNormalForm.literal -> VScheme.value
  val def   : VScheme.name KNormalForm.exp -> VScheme.def
end 
  = 
struct
  structure K  = KNormalForm
  structure S  = VScheme
  structure SU = VSchemeUtils
  structure P  = Primitive

  fun lt' x e' e = S.LETX (S.LET, [(x, e')], e)   (* useful helper.
                                                    I renamed this
                                                    because having
                                                    something 
                                                    named let'
                                                    REALLY 
                                                    messes up 
                                                    the syntax
                                                    highlighter :) *)

  fun value (K.INT i)    = S.INT i
    | value (K.REAL r)   = S.REAL r
    | value (K.STRING s) = S.SYM s
    | value (K.BOOL b)   = S.BOOLV b
    | value  K.EMPTYLIST = S.EMPTYLIST
    | value  K.NIL       = S.BOOLV false

  fun nameFrom (K.STRING s) = s
    | nameFrom _          = Impossible.impossible 
                            "internal error: misused function nameFrom"

  fun setIfSetGlobalElseBegin e1 e2 = 
    (case (e1, e2)
      of (K.VMOPLIT (p, [localname], ObjectCode.STRING globalname), 
          K.NAME localname') =>
        if P.name p = "setglobal" andalso localname = localname'
        then SOME (S.SET (globalname, S.VAR localname))
        else NONE
      | _ => NONE)



  fun exp (K.LITERAL v)    = S.LITERAL (value v)
    | exp (K.NAME x)       = S.VAR x
    | exp (K.VMOP (p, ns)) = 
     (* if not (AsmGen.areConsecutive ns) then
            Impossible.impossible ("non-consecutive registers in AN->KN vmop " ^
                                  P.name p)
          else *)
    S.APPLY (S.VAR (P.name p), List.map S.VAR ns)
    | exp (K.VMOPLIT (p, ns, v)) = 
      (case (P.name p, ns, v)
        of ("getglobal", [], K.STRING s)  => S.VAR s
         | ("setglobal", [n], K.STRING s) => S.SET (s, S.VAR n)
         | ("check-assert", [n], msg) => S.APPLY (S.VAR "check-assert", [S.VAR n])
         | (pn, names, v)       => S.APPLY (S.VAR pn, (List.map S.VAR names)
                                                       @ [S.LITERAL (value v)]))
    | exp (K.VMOPINT (p, r, i)) =  
        S.APPLY (S.VAR (P.name p), [S.VAR r, S.LITERAL (S.INT (Word8.toInt i))])
    | exp (K.FUNCALL (n, ns)) = S.APPLY (S.VAR n, List.map S.VAR ns)

    | exp (K.IFX (a, e1, e2)) = S.IFX (S.VAR a, exp e1, exp e2)
    | exp (K.LETX (n, e, K.NAME n')) = 
          if n = n'
          then exp e 
          else lt' n (exp e) (exp (K.NAME n'))
    (* 𝓔⟦let x = e in x⟧ = 𝓔⟦e⟧ *)
    | exp (K.LETX (n, e1, e2)) = lt' n (exp e1) (exp e2)
    | exp (K.BEGIN (e1, e2)) = (case setIfSetGlobalElseBegin e1 e2
                                 of SOME e => e
                                  | NONE => S.BEGIN [exp e1, exp e2])
    | exp (K.SET (n, e)) = S.SET (n, exp e)
    | exp (K.WHILEX (n, e1, e2)) = S.WHILEX (lt' n (exp e1) (S.VAR n), exp e2)
    | exp (K.FUNCODE (ns, e)) = S.LAMBDA (ns, exp e)
    | exp (K.CAPTURED i) = 
          S.APPLY (S.VAR "CAPTURED-IN", [S.LITERAL (S.INT i), S.VAR "$closure"])
    | exp (K.CLOSURE ((formals, body), captured)) = 
        S.APPLY (S.VAR "mkclosure", [S.LAMBDA ("$closure"::formals, exp body), 
        SU.list (map S.VAR captured)])
        (* todo check if this is right *)
    | exp (K.LETREC (bindings, body)) = 
              S.LETX (S.LETREC, map (fn (name, ((bindings, body), captured)) => 
                                    (name, exp body)) 
                                    bindings, exp body)
    | exp (K.BLOCK xs) = S.APPLY (S.VAR "block", map S.VAR xs)
    | exp (K.SWITCH_VCON (x, choices, e)) =
    let val lastQa = [(S.LITERAL (S.BOOLV true), exp e)]
        fun isCon (vcon, arity) =
              S.APPLY (S.VAR "matches-vcon-arity?",
                       [S.VAR x, S.LITERAL (S.SYM vcon), (S.LITERAL o S.INT) arity])
        fun qa (c, e) = (isCon c, exp e)
    in  S.COND (map qa choices @ lastQa)
    end

  
  val _ = exp : VScheme.name KNormalForm.exp -> VScheme.exp 

  fun def e = VScheme.EXP (exp e)
end
