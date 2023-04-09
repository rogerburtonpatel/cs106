(* KNormalizer from Closed Scheme to KNormal-form Scheme. 
    This is where register allocation happens! *)

(* You'll fill out the missing code in this file *)

structure KNormalize :> sig
  type reg = int  (* register *)
  type regset     (* set of registers *)
  val regname : reg -> string
  val exp : reg Env.env -> regset -> ClosedScheme.exp -> reg KNormalForm.exp
  val def :                          ClosedScheme.def -> reg KNormalForm.exp
end 
  =
struct 
  structure K  = KNormalForm
  structure F  = ClosedScheme
  structure E  = Env
  structure P  = Primitive

  structure MC = MatchCompiler(type register = int
                               fun regString r = "$r" ^ Int.toString r
                              )

  structure MV = MatchViz(structure Tree = MC)
  val vizTree = MV.viz (WppScheme.expString o CSUtil.embedExp)


  infix 6 <+>
  val op <+> = Env.<+>

  fun fst (x, y) = x
  fun member x = List.exists (fn y => x = y)

  fun eprint s = TextIO.output (TextIO.stdErr, s)

  (************ Register and regset operations ************)

  type reg = int
  fun regname r = "$r" ^ Int.toString r

  datatype regset = RS of int (* RS n represents { r | r >= n } *)

  val smallest : regset -> reg = fn (RS r) => r



  val -- : regset * reg -> regset   (* remove a register *)
   = fn (RS n, toRemove) => RS (Int.max (toRemove + 1, n))
  infixr 6 --
  

  fun uncurry f (x, y) = f x y
  fun curry f x y = f (x, y)

  (************ K-normalization ************)

  type exp = reg K.exp
  type policy = regset -> exp -> (reg -> exp) -> exp
    (* puts the expression in an register, continues *)


  fun bindAnyReg rset (K.NAME y) k = k y
    | bindAnyReg rset e          k = 
      let val t = smallest rset
      in  K.LETX (t, e, k t)
      end

(* problem is: (A -- reg) is setting a lower avail on [m n], leading to x getting r2 *)
(* see localLetMixed in kntest.scm *)
(* TODO ASK: 
    1. Weird let* construct
    2. the max thing *)

(* TODO CLEAN up MAX problem *)
  fun bindSmallest rset e k = 
      let val t = smallest rset
      in  K.LETX (t, e, k t)
      end

  val _ = bindAnyReg   : regset -> exp -> (reg -> exp) -> exp
  val _ = bindSmallest : regset -> exp -> (reg -> exp) -> exp

  fun flip f (x, y) = f (y, x)
  infixr 0 $
  fun f $ g = f g

  (* val revminus = flip -- *)

  type 'a normalizer = regset -> 'a -> exp

  fun nbRegsWith normalize bind A [] k      = k []
    | nbRegsWith normalize bind A (e::es) k = 
        bind A (normalize A e) 
          (fn reg => nbRegsWith normalize bind (A -- reg) es 
                     (fn ts => k (reg::ts)))
  val nbRegsWith : 'a normalizer -> policy -> regset -> 'a list -> 
                                              (reg list -> exp) -> exp
    = nbRegsWith

  (* Note: only works on strings! *)
  fun vmopStringK p s = fn reg => K.VMOPLIT (p, [reg], K.STRING s)

  (* DEUBGGING *)
  fun IntListToString [] = ""
    | IntListToString (i::is) = Int.toString i ^ "->" ^ IntListToString is

  fun printRegSet (RS n) = print ("A: RS (" ^ Int.toString n ^ ")\n")

  (* WEIGHTLIFTERS *)

  fun exp rho A ex =
    let val exp : reg Env.env -> regset -> ClosedScheme.exp -> exp = exp
        val nbRegs = nbRegsWith (exp rho) 
        (*  ^ normalize and bind in _this_ environment *)
    in  (case ex
          of F.PRIMCALL (p, es) => nbRegs bindAnyReg A es (curry K.VMOP p)
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
            bindWithTranslateExp A rho e 
                (fn reg => K.BEGIN (KNormalUtil.setglobal (n, reg), K.NAME reg))
           | F.BEGIN es  => translateBegin rho A es
           | F.IFX (e, e1, e2) => 
              bindWithTranslateExp A rho e 
                             (fn reg => K.IFX (reg, exp rho A e1, exp rho A e2))
           | F.WHILEX (e, e') => 
            let val t = smallest A
            in K.WHILEX (t, exp rho A e, exp rho A e')
            end
           | F.FUNCALL (e, es) => 
            bindSmallest A (exp rho A e) 
                         (fn reg => nbRegs bindSmallest (A -- reg) es 
                                           (fn regs => K.FUNCALL (reg, regs)))
           | F.LET (bindings, body) => 
             let val (names, rightSides) = ListPair.unzip bindings
                 val bindNamestoRegs     = ListPair.foldr Env.bind rho
             in nbRegs bindAnyReg A rightSides 
                      (fn regs => exp (bindNamestoRegs (names, regs)) 
                                      (List.foldl (flip (op --)) A regs)
                                      body)
             end
          | F.CLOSURE (lambda, captured) => Impossible.impossible "closure"
          | F.CAPTURED i => Impossible.impossible "captured"
          | F.LETREC (bindings, body) => Impossible.impossible "letrec"
             
             )
    end

  and bindWithTranslateExp A rho e k = bindAnyReg A (exp rho A e) k
  and translateBegin rho A []        =  K.LITERAL (K.BOOL false)
    | translateBegin rho A [e]       = exp rho A e
    | translateBegin rho A (e::es)   = K.BEGIN (exp rho A e, 
                                                translateBegin rho A es)
  fun def ex = 
    let val A   = RS 0
        val rho = Env.empty
    in 
    (case ex
      of F.EXP e => exp rho A e
       | F.CHECK_EXPECT (s1, e1, s2, e2) =>
          K.BEGIN (bindWithTranslateExp A rho e1 (vmopStringK P.check s1), 
                      bindWithTranslateExp A rho e2 (vmopStringK P.expect s2))
       | F.CHECK_ASSERT (s, e) =>
          bindWithTranslateExp A rho e (vmopStringK P.check_assert s)
                        (* TODO ASK: can we use 0 in check-error bc of toplevel? *)
       | F.CHECK_ERROR (s, e) => 
        bindAnyReg A (K.FUNCODE ([], exp rho A e)) 
                          (fn reg => 
                            K.VMOPLIT (P.check_error, [reg], K.STRING s))
       | F.VAL (n, e) => exp rho A (F.SETGLOBAL (n, e))
       | F.DEFINE (n, (ns, e)) =>
        let val (boundEnv, argregs, _) = (List.foldl (fn (n, (rho', rs, r)) => 
                                      (Env.bind (n, r, rho'), rs @ [r], r + 1))
                                      (rho, [], 1)
                                      ns)
            val availRegs = A -- List.length ns
        in K.LETX (0, 
                K.FUNCODE (argregs, exp boundEnv availRegs e), 
                KNormalUtil.setglobal (n, 0))
        end)
    end
end
(* TODO: ask about this output from qsort: 

(let* ([r0 append]
       [r1 (let* ([r1 qsort]
                  [r2 (let* ([r2 filter]
                             [r3 left?]
                             [r4 rest]) 
                        (r2 r3 r4))]) 
             (r1 r2))]
       [r2 (let* ([r3 pivot]
                  [r4 (let* ([r4 qsort]
                             [r5 (let* ([r5 filter]
                                        [r6 right?]
                                        [r7 rest]) 
                                   (r5 r6 r7))]) 
                        (r4 r5))]) 
             (cons r3 r4))]) 
  (r0 r1 r2))
  
  how can we get our nice let* stack? (as fun as this snake shape is)

   *)
