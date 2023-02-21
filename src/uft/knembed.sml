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

  fun lt' x e' e = S.LETX (S.LET, [(x, e')], e)   (* useful helper
                                                    I renamed this
                                                    because having
                                                    something 
                                                    named 'let'
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
    | nameFrom _          = Impossible.impossible "misused function"

(* 𝓔⟦let x = e in x⟧ = 𝓔⟦e⟧ *)
(* Todo: this case ^^ for easy reading *)
  fun exp (K.LITERAL v)    = S.LITERAL (value v)
    | exp (K.NAME x)       = S.VAR x
    | exp (K.VMOP (p, ns)) = S.APPLY (S.VAR (P.name p), List.map S.VAR ns)
    | exp (K.VMOPLIT (p, [n], v)) = 
      (case P.name p
        of "getglobal" => S.LITERAL (S.SYM (nameFrom v))
         | "setglobal" => S.SET (nameFrom v, S.VAR n) 
                              (* want to ask about this one *)
         | _           => Impossible.exercise "still need to get here")
    (* | exp getglobal STRING s = S.VAR *)
    (* | exp setglobal x, STRING s = S.SET *)
              (* @(x₁, …, xₙ)	APPLY
              @(x₁, …, xₙ, v)	APPLY
              x(x₁, …, xₙ)	APPLY *)
    | exp (K.IFX (a, e1, e2)) = S.IFX (S.VAR a, (exp e1), (exp e2))
    (* | exp (K.LETX (n, e, n)) = exp e *) (* want the special let form 
                                             𝓔⟦let x = e in x⟧ = 𝓔⟦e⟧ *)

    | exp (K.LETX (n, e1, e2)) = lt' n (exp e1) (exp e2)
    | exp (K.BEGIN (e1, e2)) = S.BEGIN [exp e1, exp e2]
    | exp (K.SET (n, e)) = S.SET (n, exp e)
    | exp (K.WHILEX (n, e1, e2)) = 
          let val e = exp e1
          in S.WHILEX ((lt' n e e), exp e2)
          end 
    | exp (K.FUNCODE (ns, e)) = S.LAMBDA (ns, exp e)

    (* | exp (K.VMOP (p, ns)) = S.APPLY (p, ns)  *)
    (* | exp  *)
    | exp _ = Impossible.impossible "Left as exercise"

  val _ = exp : VScheme.name KNormalForm.exp -> VScheme.exp 

  fun def e = VScheme.EXP (exp e)
end
