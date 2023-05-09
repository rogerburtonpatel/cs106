(* KNormalizer from Closed Scheme to KNormal-form Scheme. 
    This is where register allocation happens! *)

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
  structure C  = ClosedScheme
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

  fun allocAndRemoveRegs regset es = 
      List.foldr (fn (_, (A, regs)) => (A -- (smallest A), (smallest A)::regs)) 
                 (regset, []) es
  
  val inLocalVar : regset -> (reg -> exp) -> exp =
    fn rs => fn k => let val t = smallest rs in K.SET (t, k t) end
  
  fun map' f' [] k = k []
  | map' f' (x :: xs) k =
      f' x (fn y => map' f' xs (fn ys => k (y :: ys)))
  
  (* WEIGHTLIFTERS *)

  fun exp rho A ex =
    let val exp : reg Env.env -> regset -> ClosedScheme.exp -> exp = exp
        val nbRegs = nbRegsWith (exp rho) 
        (*  ^ normalize and bind in _this_ environment *)
    in  (case ex
          of C.PRIMCALL (p, es) =>
          (case (P.name p, es) 
            of (">", [e, C.LITERAL (C.INT 0)]) => 
            nbRegs bindAnyReg A [e] (curry K.VMOP P.gt0)
            | ("+", es as [e,  C.LITERAL (C.INT n)]) => 
              if n < 128 andalso n >= ~128 then 
                (* let val t = List.hd y *)
                    let val int_i = Word8.fromInt (n + 128)
                in nbRegs bindAnyReg A [e] (fn y =>
                                              K.VMOPINT (P.plusimm, List.hd y, int_i))
                end 
              else 
                nbRegs bindAnyReg A es (curry K.VMOP p)
            | ("-", [e,  C.LITERAL (C.INT n)]) => 
              exp rho A (C.PRIMCALL (P.plus, [e, C.LITERAL (C.INT (~n))]))
            | _ => nbRegs bindAnyReg A es (curry K.VMOP p))
           | C.LITERAL v => K.LITERAL v
           | C.LOCAL n => 
             let val r = Env.find (n, rho)
             in K.NAME r
             end
           | C.SETLOCAL (n, e) => 
             let val r = Env.find (n, rho)
             in K.SET (r, exp rho A e)
             end
           | C.GLOBAL n => KNormalUtil.getglobal n
           (* Note that in prettyprinting this you won't see the 'begin' *)
           | C.SETGLOBAL (n, e) => 
            bindWithTranslateExp A rho e 
                (fn reg => K.BEGIN (KNormalUtil.setglobal (n, reg), K.NAME reg))
           | C.BEGIN es  => translateBegin rho A es
           | C.IFX (e, e1, e2) => 
              bindWithTranslateExp A rho e 
                             (fn reg => K.IFX (reg, exp rho A e1, exp rho A e2))
           | C.WHILEX (e, e') => 
            let val t = smallest A
            in K.WHILEX (t, exp rho A e, exp rho A e')
            end
           | C.FUNCALL (e, es) => 
            bindSmallest A (exp rho A e) 
                         (fn reg => nbRegs bindSmallest (A -- reg) es 
                                           (fn regs => K.FUNCALL (reg, regs)))
           | C.LET (bindings, body) => 
             let val (names, rightSides) = ListPair.unzip bindings
                 val bindNamestoRegs     = ListPair.foldr Env.bind rho
             in nbRegs bindSmallest A rightSides 
                      (fn regs => exp (bindNamestoRegs (names, regs)) 
                                      (List.foldl (flip (op --)) A regs)
                                      body)
             end
          | C.CLOSURE (lambda, []) => K.FUNCODE (funcode lambda rho A)
          | C.CLOSURE (lambda, captured) =>
                  inLocalVar A (fn t =>
                    nbRegs bindAnyReg (A -- t) captured (fn regs => 
                          K.CLOSURE (funcode lambda rho (A -- t), regs)))
                                                    (* todo check this A -- t, and also if funcode needs these args in general
                                                       or can capture them *)
          | C.CAPTURED i => K.CAPTURED i
          | C.LETREC (bindings, body) => 
            let val (A', rs)     = allocAndRemoveRegs A bindings 
                val (names, cls) = ListPair.unzip bindings 
                val rho'         = ListPair.foldrEq Env.bind rho (names, rs)
                fun closure ((xs, e'), []) k = k (funcode (xs, e') rho' A', [])
                  | closure ((xs, e'), es) k = 
                    nbRegsWith (exp rho') bindAnyReg A' es 
                               (fn ts => k (funcode (xs, e') rho' A', ts))
                in map' closure cls 
                   (fn cs => K.LETREC (ListPair.zip (rs, cs), exp rho' A' body))
                end
          | C.CONSTRUCTED ("#t", []) => K.LITERAL (K.BOOL true)
          | C.CONSTRUCTED ("#f", []) => K.LITERAL (K.BOOL false)
          | C.CONSTRUCTED ("cons", [x, y]) => 
            (* could have es instead of [x, y] but this is more explicit *)
            inLocalVar A (fn t => nbRegs bindAnyReg (A -- t) [x, y] 
                                         (curry K.VMOP P.cons))
          | C.CONSTRUCTED ("'()", []) => K.LITERAL K.EMPTYLIST
          | C.CONSTRUCTED (con, es) => 
              inLocalVar A (fn t => 
                      bindAnyReg (A -- t) (K.LITERAL (K.STRING con)) 
                          (fn reg => nbRegs bindAnyReg ((A -- t) -- reg) es 
                                            (fn regs => K.BLOCK (reg::regs))))
          | C.CASE (e, choices) => bindWithTranslateExp A rho e 
                (fn t =>
                  let fun treeGen rset etree = 
                    (case etree
                      of MC.LET_CHILD ((r, slotnum), k) => 
                            bindAnyReg rset (K.VMOP 
                                              (P.getblockslot, [r, slotnum]))
                                    (fn x => treeGen (rset -- x) (k x))
                       | MC.MATCH (ex, env) => exp (rho <+> env) rset ex
                       | MC.TEST (r, edges, maybetree) => 
                          let val treeOfEdges = 
                            map (fn (MC.E (lcon, subtree)) => 
                                (lcon, treeGen rset subtree)) 
                                edges
                              val treeOrNoMatch = 
                                case maybetree 
                                  of SOME tree' => treeGen rset tree'
                                  |  NONE       => K.VMOPLIT (P.error, [], 
                                                   K.STRING "no-matching-case")
                          in 
                          K.SWITCH_VCON (r, treeOfEdges, treeOrNoMatch)
                          end)
                      val _ = treeGen : regset -> C.exp MC.tree -> reg K.exp
                      val A' = (A -- t)
                  in  treeGen A' (vizTree (MC.decisionTree (t, choices)))
                  end)
             )
    end


  and bindWithTranslateExp A rho e k = bindAnyReg A (exp rho A e) k
  and translateBegin rho A []        =  K.LITERAL (K.BOOL false)
    | translateBegin rho A [e]       = exp rho A e
    | translateBegin rho A (e::es)   = K.BEGIN (exp rho A e, 
                                                translateBegin rho A es)

  and funcode (ns, e) rho A = 
    let val (boundEnv, argregs, _) = (List.foldl (fn (n, (rho', rs, r)) => 
                                  (Env.bind (n, r, rho'), rs @ [r], r + 1))
                                  (rho, [], 1)
                                  ns)
        val availRegs = A -- List.length ns
    in (argregs, exp boundEnv availRegs e)
    end

  val funcode : C.funcode -> reg Env.env -> regset -> reg K.funcode = funcode

  fun def ex = 
    let val A   = RS 0
        val rho = Env.empty
    in 
    (case ex
      of C.EXP e => exp rho A e
       | C.CHECK_EXPECT (s1, e1, s2, e2) =>
          K.BEGIN (bindWithTranslateExp A rho e1 (vmopStringK P.check s1), 
                      bindWithTranslateExp A rho e2 (vmopStringK P.expect s2))
       | C.CHECK_ASSERT (s, e) =>
          bindWithTranslateExp A rho e (vmopStringK P.check_assert s)
          (* PRESENT ME: check-error becomes a lambda *)
       | C.CHECK_ERROR (s, e) => 
            bindAnyReg A (K.FUNCODE ([], exp rho A e)) 
                          (fn reg => 
                            K.VMOPLIT (P.check_error, [reg], K.STRING s))
       | C.VAL valdef => exp rho A (C.SETGLOBAL valdef)
       | C.DEFINE (n, lambda) => K.LETX (0, K.FUNCODE (funcode lambda rho A), 
                                            KNormalUtil.setglobal (n, 0)))
    end
end
(* here's the knf output from qsort: 

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
