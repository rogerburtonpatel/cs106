(* Project disambiguated VScheme into KNormal representation. 
    Note that this can fail if the disambiguated VScheme is not already 
    written in KNormal-form. *)

(* You'll complete this file *)

structure KNProject :> sig
  val value : UnambiguousVScheme.value -> KNormalForm.literal
  val def   : UnambiguousVScheme.def -> string KNormalForm.exp Error.error
end 
  = 
struct
  structure K  = KNormalForm
  structure KU = KNormalUtil
  structure P  = Primitive
  structure X  = UnambiguousVScheme

  infix  3 <*>  val op <*> = Error.<*>
  infixr 4 <$>  val op <$> = Error.<$>
  val succeed = Error.succeed
  val error = Error.ERROR
  val errorList = Error.list

  fun curry  f x y   = f (x, y)
  fun curry3 f x y z = f (x, y, z)

  fun checky p = P.name p = "check" orelse P.name p = "expect"

  val asName : X.exp -> X.name Error.error
         (* project into a name; used where KNF expects a name *)
    = fn X.LOCAL x => succeed x 
       | e => error ("expected a local variable but instead got " ^ (X.whatIs e))

(* val exp   : UnambiguousVScheme.exp -> string KNormalForm.exp Error.error *)
  fun eqnames n1 (Error.OK s) = n1 = s
    | eqnames n1 (Error.ERROR msg) = false

  fun value (X.SYM s) = K.STRING s
    | value (X.INT i) = K.INT i
    | value (X.REAL r) = K.REAL r
    | value (X.BOOLV b) = K.BOOL b
    | value  X.EMPTYLIST = K.EMPTYLIST

  fun exp (X.LITERAL v) = succeed (K.LITERAL (value v))
    | exp (X.LOCAL x) = succeed (K.NAME x)
    | exp (X.GLOBAL x) = succeed (KU.getglobal x)
    | exp (X.IFX (e1, e2, e3)) =
      curry3 K.IFX <$> asName e1 <*> exp e2 <*> exp e3
    | exp (X.LETX (X.LET, nes, e)) = 
      (case nes
        of [(n, e')] => curry3 K.LETX <$> (succeed n) <*> exp e' <*> exp e
         | _ => error "let must have only one binding in projection to \
                                                          \K-Normal form!")
    | exp (X.LETX (X.LETREC, nes, e)) = error "no letrec dingus"
    | exp (X.WHILEX (e, e')) = 
      (case e
        of X.LETX (X.LET, [(n, e1)], e2) => 
          if eqnames n (asName e2)
          then curry3 K.WHILEX <$> (succeed n) <*> exp e1 <*> exp e2
          else error "while name bound in let must be the one called in \
                                                  \projection to K-Normal form!"
        | _ => error "ill-formed let binding in while expression") 
    | exp (X.BEGIN (es)) = 
      (case es 
        of [e1, e2] => curry K.BEGIN <$> exp e1 <*> exp e2
         | _ => error "begin must have only two expressions in projection to \
                                                              \K-Normal form!")
    | exp (X.SETLOCAL (x, e))   = curry K.SET <$> (succeed x) <*> exp e
    | exp (X.SETGLOBAL (x, x')) = 
                                curry KU.setglobal <$> (succeed x) <*> asName x'
                                                       (* todo: why a name, 
                                                          when setglobal takes
                                                          a register? *)
    | exp (X.FUNCALL (e, es)) = curry K.FUNCALL <$> asName e 
                                              <*> errorList (List.map asName es) 
    | exp (X.PRIMCALL (p, es)) = curry K.VMOP <$> (succeed p) 
                                              <*> errorList (List.map asName es)
    | exp (X.LAMBDA (ns, e)) = curry K.FUNCODE <$> succeed ns <*> exp e
                                                      

  fun def (X.EXP e) = exp e
    | def (X.VAL _) = error "val not allowed when projecting to K-Normal Form"
    | def (X.CHECK_ASSERT _) = error "check-assert not allowed when projecting \
                                                              \to K-Normal Form"
    | def (X.CHECK_EXPECT _) = error "check-expect not allowed when projecting \
                                                              \to K-Normal Form"
    | def _ = Impossible.exercise "not done yet"
                                                                                                                           

end


