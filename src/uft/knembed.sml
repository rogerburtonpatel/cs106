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

  fun let' x e' e = S.LETX (S.LET, [(x, e')], e)   (* useful helper *)

  fun value (K.INT i)    = S.INT i
    | value (K.REAL r)   = S.REAL r
    | value (K.STRING s) = S.SYM s
    | value (K.BOOL b)   = S.BOOLV b
    | value K.EMPTYLIST  = S.EMPTYLIST
    | value K.NIL        = S.BOOLV false


  fun def   _ = Impossible.exercise "embedding of KNF expressions into definitions"

end
