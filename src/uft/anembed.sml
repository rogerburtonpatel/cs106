(* Embeds ANormal-form Scheme into K-Normal form. This cannot fail. *)


structure ANEmbed :> sig
  val def   : 'a ANormalForm.exp -> 'a KNormalForm.exp
end 
  = 
struct
  structure A  = ANormalForm
  structure K  = KNormalForm
  structure P  = Primitive

  fun fst (x, y) = x
  fun snd (x, y) = y

  (* fun value (A.INT i)    = K.INT i
    | value (A.REAL r)   = K.REAL r
    | value (A. s) = K.SYM s
    | value (A.BOOL b)   = K.BOOLV b
    | value  A.EMPTYLIST = K.EMPTYLIST
    | value  A.NIL       = K.NIL *)

  fun nameFrom (A.STRING s) = s
    | nameFrom _          = Impossible.impossible "misused function"


  fun exp (A.SIMPLE se) = 
      (case se 
       of A.LITERAL v => K.LITERAL v
        | A.NAME x       => K.NAME x
        | A.VMOP (p, ns) => K.VMOP (p, ns)
        | A.VMOPLIT (p, ns, l) => K.VMOPLIT (p, ns, l)
        | A.FUNCALL (name, args) => K.FUNCALL (name, args)
        | A.FUNCODE (params, body) => K.FUNCODE (params, exp body)
        | A.CAPTURED i => K.CAPTURED i
        | A.CLOSURE cl => K.CLOSURE (embedClosure cl)
        | A.BLOCK ns => K.BLOCK ns
        | A.SWITCH_VCON (n, branches, default) => 
              K.SWITCH_VCON (n, map 
                                (fn ((p, i), e) => ((p, i), exp e)) 
                                branches, exp default))
    | exp (A.IFX (n, e1, e2)) = K.IFX (n, exp e1, exp e2)
    | exp (A.LETX (n, e, e')) = K.LETX (n, exp (A.SIMPLE e), exp e')
    | exp (A.BEGIN (e1, e2))  = K.BEGIN (exp e1, exp e2)
    | exp (A.WHILEX (n, cond, body)) = 
            K.WHILEX (n, exp (A.SIMPLE cond), exp body)
    | exp (A.SET (n, e)) = K.SET (n, exp e)
    | exp (A.LETREC (bindings, body)) = 
        K.LETREC (map (fn (n, cl) => (n, embedClosure cl)) bindings, exp body)
    and embedClosure ((names, body), captured) = ((names, exp body), captured)

  (*  | exp (A.VMOP (p, ns)) = S.APPLY (S.VAR (P.name p), List.map S.VAR ns)
    | exp (A.VMOPLIT (p, ns, v)) = 
      (case (P.name p, ns, v)
        of ("getglobal", [], A.STRING s)  => S.VAR s
         | ("setglobal", [n], A.STRING s) => S.SET (s, S.VAR n)
                              (* want to ask about this one *)
         | (pn, names, v)       => S.APPLY (S.VAR pn, (List.map S.VAR names)
                                                       @ [S.LITERAL (value v)]))
    | exp (A.FUNCALL (n, ns)) = S.APPLY (S.VAR n, List.map S.VAR ns)

    | exp (A.IFX (a, e1, e2)) = S.IFX (S.VAR a, exp e1, exp e2)
    | exp (A.LETX (n, e, A.NAME n')) = 
          if n = n'
          then exp e 
          else lt' n (exp e) (exp (A.NAME n'))
          (* 𝓔⟦let x = e in x⟧ = 𝓔⟦e⟧ *)
    | exp (A.LETX (n, e1, e2)) = lt' n (exp e1) (exp e2)
    | exp (A.BEGIN (e1, e2)) = S.BEGIN [exp e1, exp e2]
    | exp (A.SET (n, e)) = S.SET (n, exp e)
    | exp (A.WHILEX (n, e1, e2)) = S.WHILEX (lt' n (exp e1) (S.VAR n), exp e2)
    | exp (A.FUNCODE (ns, e)) = S.LAMBDA (ns, exp e)
  val _ = exp : VScheme.name ANormalForm.exp -> VScheme.exp  *)

  fun def e = exp e
end
