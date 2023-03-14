(* Project disambiguated VScheme into ANormal representation. 
    Note that this can fail if the disambiguated VScheme is not already 
    written in ANormal-form. *)

(* You'll complete this file *)

structure ANProject :> sig
  val value : UnambiguousVScheme.value -> ANormalForm.literal
  val def   : UnambiguousVScheme.def -> string ANormalForm.exp Error.error
end 
  = 
struct
  structure A  = ANormalForm
  structure AU = ANormalUtil
  structure P  = Primitive
  structure X  = UnambiguousVScheme

  infix  0 >>=  val op >>= = Error.>>=
  infix  3 <*>  val op <*> = Error.<*>
  infixr 4 <$>  val op <$> = Error.<$>
  val succeed = Error.succeed
  val error = Error.ERROR
  val errorList = Error.list

  fun curry  f x y   = f (x, y)
  fun curry3 f x y z = f (x, y, z)

  fun checky p = P.name p = "check" orelse P.name p = "expect"

  val asName : X.exp -> X.name Error.error
         (* project into a name; used where ANF expects a name *)
    = fn X.LOCAL x => succeed x 
       | e => error ("expected a local variable but instead got " ^ (X.whatIs e))

(* val exp   : UnambiguousVScheme.exp -> string ANormalForm.exp Error.error *)
  fun eqnames n1 (Error.OK s) = n1 = s
    | eqnames n1 (Error.ERROR msg) = false

  fun value (X.SYM s) = A.STRING s
    | value (X.INT i) = A.INT i
    | value (X.REAL r) = A.REAL r
    | value (X.BOOLV b) = A.BOOL b
    | value  X.EMPTYLIST = A.EMPTYLIST

  fun exp (X.LITERAL v) = succeed (A.LITERAL (value v))
    | exp (X.LOCAL x) = succeed (A.NAME x)
    | exp (X.GLOBAL x) = succeed (AU.getglobal x)
    | exp (X.IFX (e1, e2, e3)) =
      curry3 A.IFX <$> asName e1 <*> exp e2 <*> exp e3
    | exp (X.LETX (X.LETREC, nes, e)) = error "no letrec in A-Normal dingus"
    | exp (X.LETX (X.LET, nes, e)) =
      (case nes
        of [(n, X.IFX _)] => error "no if as let binder in A-Normal form"
         | [(n, X.WHILEX _)] => error "no while as let binder in A-Normal form"
         | [(n, X.LETX _)] => error "no let as let binder in A-Normal form"
         | [(n, e')] => curry3 A.LETX <$> (succeed n) <*> exp e' <*> exp e
         | _ => error "let must have only one binding in projection to \
                                                          \A-Normal form!")
    | exp (X.WHILEX (e, e')) = 
      (case e
        of X.LETX (X.LET, [(n, X.IFX _)], e2) => 
            error "no if as let binder in a-normal form"
         | X.LETX (X.LET, [(n, X.WHILEX _)], e2) => 
            error "no while as let binder in a-normal form"
         | X.LETX (X.LET, [(n, X.LETX _)], e2) => 
            error "no while as let binder in a-normal form"            
         | X.LETX (X.LET, [(n, e1)], e2) => 
          if eqnames n (asName e2)
          then curry3 A.WHILEX <$> (succeed n) <*> exp e1 <*> exp e2
          else error "while name bound in let must be the one called in \
                                                  \projection to A-Normal form!"
        | _ => error "ill-formed let binding in while expression") 
    | exp (X.BEGIN (es)) = 
      (case es 
        of [e1, e2] => curry A.BEGIN <$> exp e1 <*> exp e2
         | _ => error "begin must have only two expressions in projection to \
                                                              \A-Normal form!")
    | exp (X.SETLOCAL (x, e))   = curry A.SET <$> (succeed x) <*> exp e
    | exp (X.SETGLOBAL (x, x')) = 
                                curry AU.setglobal <$> (succeed x) <*> asName x'

    | exp (X.FUNCALL (e, es)) = curry A.FUNCALL <$> asName e 
                                              <*> errorList (List.map asName es) 
    | exp (X.PRIMCALL (p, es)) = 
      let fun mkVmop prim exps = 
                curry A.VMOP <$> (succeed p) <*> errorList (List.map asName es)
      in
      (case (P.name p, es)
        of (n, [e, X.LITERAL v]) =>
         if n = "check" orelse n = "expect"
         then curry3 A.VMOPLIT p <$> errorList [asName e] <*> succeed (value v)
         else  mkVmop p es
        | _ => mkVmop p es)
      end
    
    | exp (X.LAMBDA (ns, e)) = curry A.FUNCODE <$> (succeed ns) <*> exp e
    (* error "no non-global functions in projection to \
                                                              \A-Normal form!" *)
  (* val fundef : string ANormalForm.exp -> string ANormalForm.exp = 
  fn e => curry3 A.LETX <$> (succeed t) 
                        <*> (curry A.FUNCODE <$> (succeed xs) <*> exp e)
                        <*> (curry AU.setglobal <$> (succeed f) <*> asName t') *)
  fun list nil     = succeed nil 
  | list (p::ps) = curry op :: <$> p <*> list ps

  (* val lt' : 'a parser list -> 'b parser -> ('a list * 'b) parser
  val lambda' : 'a parser -> (name list * exp) parser
  val setglobal : (name * exp) parser

  lt' [bind (lambda' exp)] [setglobal exp] *)

  fun def (X.EXP e) = exp e
          (* (case e 
          of (X.LETX (X.LET, [(t, X.LAMBDA (xs, e))], (X.SETGLOBAL (f, t')))) =>
          if eqnames t (asName t')
          then 
          curry3 A.LETX <$> (succeed t) 
                        <*> (curry A.FUNCODE <$> (succeed xs) <*> exp e)
                        <*> (curry AU.setglobal <$> (succeed f) <*> asName t')
          else exp e
          | _ => exp e) *)
    | def (X.VAL _) = error "val not allowed when projecting to A-Normal Form"
    | def (X.CHECK_ASSERT _) = error "check-assert not allowed when projecting \
                                                              \to A-Normal Form"
    | def (X.CHECK_EXPECT _) = error "check-expect not allowed when projecting \
                                                              \to A-Normal Form"
    | def (X.DEFINE (f, (xs, e))) = 
    (* TODO change this r100 nonsense *)
      exp e >>= (fn e' => succeed (A.LETX ("$r100", e', 
                                A.VMOPLIT (P.setglobal, ["$r100"], A.STRING f))))

end


