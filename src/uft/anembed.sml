(* Embeds ANormal-form Scheme into VScheme. This cannot fail. *)

(* You'll complete this file *)

structure ANEmbed :> sig
  (* val value : ANormalForm.literal -> KNormalForm.value *)
  val def   : VScheme.name ANormalForm.exp -> VScheme.def
end 
  = 
struct
  structure A  = ANormalForm
  structure S  = VScheme
  structure K = KNormalForm
  structure SU = VSchemeUtils
  structure P  = Primitive

  (* fun lt' x e' e = S.LETX (S.LET, [(x, e')], e)   (* useful helper
                                                    I renamed this
                                                    because having
                                                    something 
                                                    named 'let'
                                                    REALLY 
                                                    messes up 
                                                    the syntax
                                                    highlighter :) *) *)

  fun nameFrom (A.STRING s) = s
    | nameFrom _          = Impossible.impossible "misused function"

  fun value (A.INT i)    = S.INT i
    | value (A.REAL r)   = S.REAL r
    | value (A.STRING s) = S.SYM s
    | value (A.BOOL b)   = S.BOOLV b
    | value  A.EMPTYLIST = S.EMPTYLIST
    | value  A.NIL       = S.BOOLV false

(* 𝓔⟦let x = e in x⟧ = 𝓔⟦e⟧ *)
(* Todo: this case ^^ for easy reading *)
  fun exp (A.I expr) = 
      (case expr 
        of (A.LITERAL v)    => S.LITERAL (value v)
        | _ => Impossible.exercise "todo")
    | exp (A.T expr) = 
      (case expr 
        of _ => Impossible.exercise "todo")
    (* | exp (A.NAME x)       = S.VAR x
    | exp (A.VMOP (p, ns)) = S.APPLY (S.VAR (P.name p), List.map S.VAR ns)
    | exp (A.VMOPLIT (p, ns, v)) = 
      (case (P.name p, ns, v)
        of ("getglobal", [], A.STRING s)  => S.VAR s
         | ("setglobal", [n], A.STRING s) => S.SET (s, S.VAR n)
                              (* want to ask about this one *)
         | (pn, names, v)       => S.APPLY (S.VAR pn, (List.map S.VAR names)
                                                       @ [S.LITERAL (value v)]))
    | exp (A.FUNCALL (n, ns)) = S.APPLY (S.VAR n, List.map S.VAR ns)

    | exp (A.IFX (a, e1, e2)) = S.IFX (S.VAR a, (exp e1), (exp e2))
    | exp (A.LETX (n, e, A.NAME n')) = 
          if n = n'
          then exp e 
          else lt' n (exp e) (exp (A.NAME n'))
          (* 𝓔⟦let x = e in x⟧ = 𝓔⟦e⟧ *)
    | exp (A.LETX (n, e1, e2)) = lt' n (exp e1) (exp e2)
    | exp (A.BEGIN (e1, e2)) = S.BEGIN [exp e1, exp e2]
    | exp (A.SET (n, e)) = S.SET (n, exp e)
    | exp (A.WHILEX (n, e1, e2)) = S.WHILEX ((lt' n (exp e1) (S.VAR n)), exp e2)
    | exp (A.FUNCODE (ns, e)) = S.LAMBDA (ns, exp e) *)
  val _ = exp : VScheme.name ANormalForm.exp -> VScheme.exp 

  fun def e = VScheme.EXP (exp e)
end