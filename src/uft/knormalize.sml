(* KNormalizer from First-Order Scheme to KNormal-form Scheme. 
    This is where register allocation happens! *)

(* You'll fill out the missing code in this file *)

structure KNormalize :> sig
  type reg = int  (* register *)
  type regset     (* set of registers *)
  val regname : reg -> string
  val exp : reg Env.env -> regset -> FirstOrderScheme.exp -> reg KNormalForm.exp
  val def :                          FirstOrderScheme.def -> reg KNormalForm.exp
end 
  =
struct 
  structure K  = KNormalForm
  structure F  = FirstOrderScheme
  structure E  = Env
  structure P  = Primitive

  fun fst (x, y) = x
  fun member x = List.exists (fn y => x = y)

  fun eprint s = TextIO.output (TextIO.stdErr, s)

  (************ Register and regset operations ************)

  type reg = int
  fun regname r = "$r" ^ Int.toString r

  datatype regset = RS of int (* RS n represents { r | r >= n } *)

  val smallest : regset -> reg = fn (RS r) => r



  val -- : regset * reg -> regset   (* remove a register *)
   = fn (_, toRemove) => RS (toRemove + 1)
  infixr 6 --
  

  (************ K-normalization ************)

  type exp = reg K.exp
  type policy = regset -> exp -> (reg -> exp) -> exp
    (* puts the expression in an register, continues *)


  fun bindAnyReg rset (K.NAME y) k = k y
    | bindAnyReg rset e          k = 
      let val t = smallest rset
      in K.LETX (t, e, k t)
      end
  (* val bindAnyReg : regset -> exp -> (reg -> exp) -> exp *)

  type 'a normalizer = regset -> 'a -> exp

  fun nbRegsWith normalize bind A xs k =
        Impossible.exercise "nbRegsWith, to be implemented in a later step"

  val nbRegsWith : 'a normalizer -> policy -> regset -> 'a list -> (reg list -> exp) -> exp
    = nbRegsWith

  fun vmopK p      = fn reg => K.VMOP (p, [reg])
  (* Note: only works on strings! *)
  fun vmopLitK p s = fn reg => K.VMOPLIT (p, [reg], K.STRING s)

(* todo add -- *)
  fun exp rho A e =
    let val exp : reg Env.env -> regset -> FirstOrderScheme.exp -> exp = exp
        val nbRegs = nbRegsWith (exp rho)   (* normalize and bind in _this_ environment *)
    in  (case e
          of F.PRIMCALL (p, [e]) => bindWithTranslateExp A rho e (vmopK p)
           | F.LITERAL v => K.LITERAL v
           | F.LOCAL n => 
             let val r = Env.find (n, rho)
             in K.NAME r
             end
           | F.SETLOCAL (n, e) => 
             let val r = Env.find (n, rho)
             in K.SET (r, exp rho A e)
             end
           | F.GLOBAL n => KNormalUtil.getglobal n
           (* Note that in prettyprinting this you won't see the 'begin' *)
           | F.SETGLOBAL (n, e) => 
            bindWithTranslateExp A rho e (fn reg => K.BEGIN (KNormalUtil.setglobal (n, reg), K.NAME reg))
           | F.BEGIN es  => translateBegin rho A es
           | F.IFX (e, e1, e2) => 
              bindWithTranslateExp A rho e 
                             (fn reg => K.IFX (reg, exp rho A e1, exp rho A e2))
           | F.WHILEX (e, e') => 
            let val t = smallest A
            in K.WHILEX (t, exp rho A e, exp rho A e')
            end
           | _ => Impossible.exercise "K-normalize an expression")
    end

  and bindWithTranslateExp A rho e k = bindAnyReg A (exp rho A e) k
  and translateBegin rho A []      =  K.LITERAL (K.BOOL false)
    | translateBegin rho A [e]     = exp rho A e
    | translateBegin rho A (e::es) = K.BEGIN (exp rho A e, translateBegin rho A es)
(* todo: should we let-bind A to (RS 0) and rho to Env.empty at the top? *)
  fun def (F.EXP e) = exp Env.empty (RS 0) e
    | def (F.CHECK_EXPECT  (s1, e1, s2, e2)) = 
          let val rho = Env.empty
              val A = (RS 0)
          in K.BEGIN (bindWithTranslateExp A rho e1 (vmopLitK P.check s1), 
                      bindWithTranslateExp A rho e2 (vmopLitK P.expect s2))
          end
    | def (F.CHECK_ASSERT (s, e)) = 
                        bindWithTranslateExp (RS 0) Env.empty e (vmopLitK P.check_assert s)
    | def (F.CHECK_ERROR (s, e)) = 
                         (K.LETX 
                              (0, 
                               K.FUNCODE ([], exp Env.empty (RS 0) e), 
                               K.VMOPLIT (P.check_error, [0], K.STRING s)))
    | def (F.VAL (n, e)) = exp Env.empty (RS 0) (F.SETGLOBAL (n, e))
    | def e = Impossible.exercise "K-normalize a definition"

end
