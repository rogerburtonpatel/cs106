(* ANormalizer from Closed Scheme to ANormal-form Scheme. 
    This is where register allocation happens! *)

structure ANormalize :> sig
  type reg = int  (* register *)
  type regset     (* set of registers *)
  val regname : reg -> string
  val exp : reg Env.env -> regset -> ClosedScheme.exp -> reg ANormalForm.exp
  val def :                          ClosedScheme.def -> reg ANormalForm.exp
  val realloc :                   reg ANormalForm.exp -> reg ANormalForm.exp
end 
  =
struct 
  structure A  = ANormalForm
  structure C  = ClosedScheme
  structure E  = Env
  structure P  = Primitive
  structure S  = Set

  structure MC = MatchCompiler(type register = int
                               fun regString r = "$r" ^ Int.toString r
                              )

  structure MV = MatchViz(structure Tree = MC)
  val vizTree = MV.viz (WppScheme.expString o CSUtil.embedExp)


  infix 6 <+>
  val op <+> = Env.<+>

  fun fst (x, y) = x
  fun snd (x, y) = y
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

  (************ A-normalization ************)

  type exp = reg A.exp
  type policy = regset -> exp -> (reg -> exp) -> exp
    (* puts the expression in an register, continues *)

  fun simp con e = A.SIMPLE (con e)


  fun freeVars expr = 
    let fun free (A.SIMPLE se) = 
        (case se 
          of A.LITERAL _ => S.empty
          | A.NAME x => S.insert (x, S.empty)
          | A.VMOP(_, xs) => S.ofList xs
          | A.VMOPLIT(_, xs, _) => S.ofList xs
          | A.FUNCALL(x, xs) => S.ofList (x::xs)
          | A.FUNCODE(xs, e) => S.diff (free e, S.ofList xs)
          | A.CAPTURED _ => S.empty
          | A.CLOSURE ((names, body), captured) => 
               S.union' [S.diff (free body, S.ofList names), S.ofList captured]
          | A.BLOCK xs => S.ofList xs
          | A.SWITCH_VCON (_, branches, default) => 
            let val exps = map snd branches
            in S.union' (free default :: freeSets exps)
            end)
      | free (A.IFX (_, e1, e2)) = S.union' [free e1, free e2]
      | free (A.LETX (x, se, e)) = 
          S.union' [S.diff (free e, S.singleton x), free (A.SIMPLE se)]
      | free (A.BEGIN (e1, e2)) = S.union' [free e1, free e2]
      | free (A.SET (_, e)) = free e
      | free (A.LETREC (bindings, body)) = 
        let val (names, cls) = ListPair.unzip bindings
            val closures = map (simp A.CLOSURE) cls
          in S.diff (S.union' (free body :: freeSets closures), S.fromList names)
          end
    and freeSets es = foldl (fn (e, set) => (free e)::set) nil es
    in S.elems (free expr)
    end

  fun freshName badnames = 
    let fun max(x, y) = if x > y then x else y
        fun goodMax [] = 0
          | goodMax [x] = x
          | goodMax(x::xs) = let val y = goodMax xs in max(x, y) end
     in 1 + goodMax badnames
     end 
  fun rename (from_x, for_y) = 
    let fun substIfEq name = if name = from_x then for_y else name
    val () = ()
    (* print ( ("renaming " ^ regname from_x ^ " to " ^ regname for_y) ^ "\n") *)
        fun renameList n1 n2 [] = []
                             | renameList n1 n2 (x::xs) = 
                                (if x = n1 then n2 else x) :: renameList n1 n2 xs
        fun substitutor (A.SIMPLE se) =
              let val simp = 
                (case se 
                  of A.LITERAL l => A.LITERAL l
                    | A.NAME n    => A.NAME (substIfEq n)
                    | A.VMOP (v, names) => A.VMOP (v, map substIfEq names)
                    | A.VMOPLIT (v, names, l) => 
                                           A.VMOPLIT (v, map substIfEq names, l)
                    | A.FUNCALL (funname, args) => 
                               A.FUNCALL (substIfEq funname, map substIfEq args)
                    (* interestingly, naming fc 'fun' will annahilate millet *)
                    | fc as A.FUNCODE (params, body) => fc
                    | A.CAPTURED i => A.CAPTURED i
                    | A.CLOSURE ((params, body), captured) =>
                            A.CLOSURE ((params, body), 
                                        renameList from_x for_y captured)
                    | A.BLOCK names => A.BLOCK (map substIfEq names)
                    | A.SWITCH_VCON (n, branches, default) => 
                        A.SWITCH_VCON (substIfEq n, 
                                       map (fn (match, e) => 
                                            (match, substitutor e)) 
                                           branches, 
                                      substitutor default))
              in A.SIMPLE simp
              end 
          | substitutor (A.IFX (n, e1, e2)) = 
            A.IFX (substIfEq n, substitutor e1, substitutor e2)
          | substitutor (A.LETX (n, e1, e2)) =
            if from_x = n then 
              normalizeLet n (substitutor (A.SIMPLE e1)) e2
            else 
              normalizeLet n (substitutor (A.SIMPLE e1)) (substitutor e2)
          | substitutor (A.SET (n, e)) = A.SET (substIfEq n, substitutor e)
          | substitutor (A.BEGIN (e1, e2)) = A.BEGIN (substitutor e1, 
                                                      substitutor e2)
          | substitutor (A.LETREC (bindings, body)) = 
            let fun renameCaptures [] = []
                  | renameCaptures ((r, (lam, caps))::bs) = 
                    (r, (lam, renameList from_x for_y caps))::renameCaptures bs
            in A.LETREC (renameCaptures bindings, substitutor body)
            end 
    (* PRESENT ME: This matters *) 
    (* fun substitutor e = e *)
    in substitutor 
    end 

    and normalizeLet x (A.LETX (y, e1, e2)) e3 = 
                      if x = y then 
                         A.LETX (x, e1, normalizeLet x e2 e3)
                      else 
                        (* x != y *)
                        let val e3free = freeVars e3
                        in if not (member y e3free) then 

                              A.LETX (y, e1, normalizeLet x e2 e3)
                           else 
                            (* x != y and y is free in e3 *)
                            let val e2free = freeVars e2
                            in if not (member x e2free) then 
                                let val subst = rename (y, x)
                                in A.LETX (x, e1, 
                                              normalizeLet x (subst e2) e3)
                                end
                               else 
                            (* x != y and y is free in e3 and x is free in e2 *)
                               let val z = freshName (x::(e2free @ e3free))
                               val subst = rename (y, z)
                                in
                                A.LETX (z, e1, normalizeLet x (subst e2) e3)
                                end
                              end
                        end
    | normalizeLet x (A.IFX (y, e1, e2)) ex' = 
                     A.IFX (y, (normalizeLet x e1 ex'), (normalizeLet x e2 ex'))

    | normalizeLet x (A.BEGIN (e1, e2)) ex' = 
                A.BEGIN(e1, (normalizeLet x e2 ex'))
    | normalizeLet x (A.SET (n, e)) ex' = 
                A.BEGIN ((A.SET (n,  e)), 
                        (normalizeLet x (A.SIMPLE (A.NAME n)) ex'))

    | normalizeLet x (A.LETREC (bindings, body)) ex' = 
        let val freeVarsE = freeVars ex'
            val funNames = map fst bindings
            val freeFunNames = 
                List.filter (fn t => t <> x andalso member t freeVarsE) funNames
            in if null freeFunNames
            then A.LETREC (bindings, normalizeLet x body ex')
            else Impossible.impossible "die"
            end 
    | normalizeLet x (A.SIMPLE e) e'  = A.LETX (x, e, e')   

  and normalizeIf x e1 e2       = A.IFX (x, e1, e2)
  and normalizeSet x e          = A.SET (x, e)
  and normalizeLetrec lams body = A.LETREC (lams, body) (* this isn't needed. *)
  and normalizeBegin (A.BEGIN (e1, e2)) e3 = normalizeBegin e1 
                                             (normalizeBegin e2 e3)
    | normalizeBegin e1 e2 = A.BEGIN (e1, e2)
 


  fun normalizeLet' t (A.SIMPLE e) k = A.LETX (t, e, k t)
    | normalizeLet' t e k = normalizeLet t e (k t)

  fun bindAnyReg rset (A.SIMPLE (A.NAME y)) k = k y
    | bindAnyReg rset e          k = 
      let val t = smallest rset
      in  normalizeLet' t e k
      end

  fun bindSmallest rset e k = 
      let val t = smallest rset
      in  normalizeLet' t e k
      end
  
    fun bindSmallest' rset e k = 
      let val t = smallest rset
      in  case e of A.SIMPLE se => A.LETX (t, se, k t)
                  | _ => Impossible.impossible "misused bindSmallest'"
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
  fun vmopStr p s = fn reg => A.VMOPLIT (p, [reg], A.STRING s)

  (* DEUBGGING *)
  fun IntListToString [] = ""
    | IntListToString (i::is) = Int.toString i ^ "->" ^ IntListToString is

  fun printRegSet (RS n) = print ("A: RS (" ^ Int.toString n ^ ")\n")

  fun allocAndRemoveRegs regset es = 
      List.foldr (fn (_, (A, regs)) => (A -- (smallest A), (smallest A)::regs)) 
                 (regset, []) es
  
  val inLocalVar : regset -> (reg -> exp) -> exp =
    fn rs => fn k => let val t = smallest rs in A.SET (t, k t) end

  
  fun map' f' [] k = k []
  | map' f' (x :: xs) k =
      f' x (fn y => map' f' xs (fn ys => k (y :: ys)))
  

  (* WEIGHTLIFTERS *)

  fun exp rho A ex = 
    let val exp : reg Env.env -> regset -> ClosedScheme.exp -> exp = exp
        val nbRegs = nbRegsWith (exp rho) 
        (*  ^ normalize and bind in _this_ environment *)
    in  (case ex
          of C.PRIMCALL (p, es) => nbRegs bindAnyReg A es (simp (curry A.VMOP p))
           | C.LITERAL v => simp A.LITERAL v
           | C.LOCAL n => 
             let val r = Env.find (n, rho)
             in simp A.NAME r
             end
           | C.SETLOCAL (n, e) => 
             let val r = Env.find (n, rho)
             in A.SET (r, exp rho A e)
             end
           | C.GLOBAL n => ANormalUtil.getglobal n
           (* Note that in prettyprinting this you won't see the 'begin' *)
           | C.SETGLOBAL (n, e) => 
            bindWithTranslateExp A rho e 
                (fn reg => A.BEGIN (ANormalUtil.setglobal (n, reg), simp A.NAME reg))
           | C.BEGIN es  => translateBegin rho A es
           | C.IFX (e, e1, e2) => 
              bindWithTranslateExp A rho e 
                             (fn reg => A.IFX (reg, exp rho A e1, exp rho A e2))
           | C.WHILEX (e, e') => 
              Impossible.impossible ("You can't A-Normalize a 'while' " ^
                            "expression. You'll have to go through KN instead.")
           | C.FUNCALL (e, es) => 
            bindSmallest A (exp rho A e) 
                         (fn reg => nbRegs bindSmallest (A -- reg) es 
                                  (fn regs => simp A.FUNCALL (reg, regs)))
           | C.LET (bindings, body) => 
             let val (names, rightSides) = ListPair.unzip bindings
                 val bindNamestoRegs     = ListPair.foldr Env.bind rho
             in nbRegs bindSmallest A rightSides 
                      (fn regs => exp (bindNamestoRegs (names, regs)) 
                                      (List.foldl (flip (op --)) A regs)
                                      body)
             end
          | C.CLOSURE (lam, []) => simp A.FUNCODE (funcode lam rho A)
          | C.CLOSURE (lambda, captured) =>
                  inLocalVar A (fn t =>
                    nbRegs bindAnyReg (A -- t) captured (fn regs => 
                          simp A.CLOSURE (funcode lambda rho (A -- t), regs)))
          | C.CAPTURED i => simp A.CAPTURED i
          | C.LETREC (bindings, body) => 
            let val (A', rs)     = allocAndRemoveRegs A bindings 
                val (names, cls) = ListPair.unzip bindings 
                val rho'         = ListPair.foldrEq Env.bind rho (names, rs)
                fun closure ((xs, e'), []) k = k (funcode (xs, e') rho' A', [])
                  | closure ((xs, e'), es) k = 
                    nbRegsWith (exp rho') bindAnyReg A' es 
                               (fn ts => k (funcode (xs, e') rho' A', ts))
                in map' closure cls 
                   (fn cs => A.LETREC (ListPair.zip (rs, cs), exp rho' A' body))
                end
          | C.CONSTRUCTED ("#t", []) => simp A.LITERAL (A.BOOL true)
          | C.CONSTRUCTED ("#f", []) => simp A.LITERAL (A.BOOL false)
          | C.CONSTRUCTED ("cons", [x, y]) => 
            (* could have es instead of [x, y] but this is more explicit *)
            inLocalVar A (fn t => nbRegs bindAnyReg (A -- t) [x, y] 
                                         (simp (curry A.VMOP P.cons)))
          | C.CONSTRUCTED ("'()", []) => simp A.LITERAL A.EMPTYLIST
          | C.CONSTRUCTED (con, es) => 
                inLocalVar A (fn t => 
                  bindAnyReg (A -- t) (simp A.LITERAL (A.STRING con)) 
                       (fn reg => nbRegs bindAnyReg ((A -- t) -- reg) es 
                                         (fn regs => simp A.BLOCK (reg::regs))))
          | C.CASE (e, choices) => bindWithTranslateExp A rho e 
                (fn t =>
                  let fun treeGen rset etree = 
                    (case etree
                      of MC.LET_CHILD ((r, slotnum), k) => 
                            bindAnyReg rset (simp A.VMOP 
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
                                  |  NONE       => simp A.VMOPLIT (P.error, [], 
                                                    A.STRING "no-matching-case")
                          in 
                          simp A.SWITCH_VCON (r, treeOfEdges, treeOrNoMatch)
                          end)
                      val _ = treeGen : regset -> C.exp MC.tree -> reg A.exp
                      val A' = (A -- t)
                  in  treeGen A' (vizTree (MC.decisionTree (t, choices)))
                  end)
             )
    end


  and bindWithTranslateExp A rho e k = bindAnyReg A (exp rho A e) k
  and translateBegin rho A []        =  A.SIMPLE (A.LITERAL (A.BOOL false))
    | translateBegin rho A [e]       = exp rho A e
    | translateBegin rho A (e::es)   = A.BEGIN (exp rho A e, 
                                                translateBegin rho A es)

  and funcode (ns, e) rho A = 
    let val (boundEnv, argregs, _) = (List.foldl (fn (n, (rho', rs, r)) => 
                                  (Env.bind (n, r, rho'), rs @ [r], r + 1))
                                  (rho, [], 1)
                                  ns)
        val availRegs = A -- List.length ns
    in (argregs, exp boundEnv availRegs e)
    end

  (* val funcode : C.funcode -> reg Env.env -> regset -> reg A.funcode = funcode *)

  fun def ex = 
    let val A   = RS 0
        val rho = Env.empty
    in 
    (case ex
      of C.EXP e => exp rho A e
       | C.CHECK_EXPECT (s1, e1, s2, e2) =>
          A.BEGIN (bindWithTranslateExp A rho e1 (simp (vmopStr P.check s1)), 
                   bindWithTranslateExp A rho e2 (simp (vmopStr P.expect s2)))
       | C.CHECK_ASSERT (s, e) =>
          bindWithTranslateExp A rho e (simp (vmopStr P.check_assert s))
       | C.CHECK_ERROR (s, e) => 
        bindAnyReg A (simp A.FUNCODE ([], exp rho A e)) 
                          (fn reg => 
                            simp A.VMOPLIT (P.check_error, [reg], A.STRING s))
       | C.VAL valdef => exp rho A (C.SETGLOBAL valdef)
       | C.DEFINE (n, lambda) => A.LETX (0, A.FUNCODE (funcode lambda rho A), 
                                            ANormalUtil.setglobal (n, 0)))
    end

  (************ Reallocation ************)


  fun mkOld (A.SIMPLE se) = A.SIMPLE (mkOldSim se)
    | mkOld (A.IFX (n, e1, e2)) = A.IFX (regname n, mkOld e1, mkOld e2)
    | mkOld (A.LETX (n, e, e')) = A.LETX (regname n, mkOldSim e, mkOld e')
    | mkOld (A.BEGIN (e1, e2))  = A.BEGIN (mkOld e1, mkOld e2)
    | mkOld (A.SET (n, e)) = A.SET (regname n, mkOld e)
    | mkOld (A.LETREC (bindings, body)) = 
        A.LETREC (map (fn (n, cl) => (regname n, embedClosure cl)) 
                      bindings, 
                  mkOld body)
    and embedClosure ((names, body), captured) = 
                     ((map regname names, mkOld body), map regname captured)
    and mkOldSim simple = 
      (case simple 
       of A.LITERAL v    => A.LITERAL v
        | A.NAME x       => A.NAME (regname x)
        | A.VMOP (p, ns) => A.VMOP (p, map regname ns)
        | A.VMOPLIT (p, ns, l) => A.VMOPLIT (p, map regname ns, l)
        | A.FUNCALL (name, args) => A.FUNCALL (regname name, map regname args)
        | A.FUNCODE (params, body) => A.FUNCODE (map regname params, mkOld body)
        | A.CAPTURED i => A.CAPTURED i
        | A.CLOSURE cl => A.CLOSURE (embedClosure cl)
        | A.BLOCK ns => A.BLOCK (map regname ns)
        | A.SWITCH_VCON (n, branches, default) => 
              A.SWITCH_VCON (regname n, map 
                                (fn ((p, i), e) => ((p, i), mkOld e)) 
                                branches, mkOld default))

  fun realloc' rho A ex =
    let val realloc' : reg Env.env -> regset -> exp -> exp = realloc'
        val nbRegs = nbRegsWith (realloc' rho) 
        (*  ^ normalize and reallocate in _this_ environment *)
        fun mkNew rname = 
        case AsmLex.registerNum rname 
          of Error.OK r => r
           | _ => Impossible.impossible 
                      "A realloc rename bug that literally can never happen." 
        fun exp' (A.SIMPLE se) = 
            (case se
              of A.VMOP (p, ns) => simp A.VMOP (p, map mkNew ns)
               | A.VMOPLIT (p, ns, l) => simp A.VMOPLIT (p, map mkNew ns, l)
               | A.BLOCK ns => simp A.BLOCK (map mkNew ns)
               | A.CAPTURED i => simp A.CAPTURED i
               | A.CLOSURE ((params, body), caps) => 
                  simp A.CLOSURE ((map mkNew params, exp' body), map mkNew caps)
               | A.FUNCALL (name, args) => 
                          if (AsmGen.areConsecutive (mkNew name :: map mkNew args))
                          then simp A.FUNCALL (mkNew name, map mkNew args)
                          else
                        let val () = ()
                        (* print ("normalizing funcall of (" ^ name ^ foldr (fn (arg, acc) => acc ^ " " ^ arg) "" args  ^ ")\n") *)
                        in 
                        bindSmallest' A (simp (A.NAME o mkNew) name)
                         (fn reg => nbRegs bindSmallest' (A -- reg) 
                                      (map (simp A.NAME o mkNew) args)
                              (fn regs => 
                              let val () = ()
                              (* print ("normalized to funcall of (" ^ regname reg ^ foldr (fn (arg, acc) => acc ^ " " ^ regname arg) "" regs  ^ ")\n") *)
                              in simp A.FUNCALL (reg, regs)
                              end))
                              end 
                              
               | A.FUNCODE (params, body) => simp A.FUNCODE (map mkNew params, exp' body)
               | A.LITERAL l => simp A.LITERAL l
               | A.NAME n => simp A.NAME (mkNew n)
               | A.SWITCH_VCON (name, branches, default) => 
                  simp A.SWITCH_VCON (mkNew name, map (fn (p_a, expr) => 
                                      (p_a, exp' expr)) branches, exp' default))
  | exp' (A.BEGIN (e1, e2)) = A.BEGIN (exp' e1, exp' e2)
  | exp' (A.IFX (n, e1, e2)) = A.IFX (mkNew n, exp' e1, exp' e2)
  | exp' (A.LETREC (bindings, body)) = 
            A.LETREC (map (fn (n, ((params, body), caps)) => 
                              (mkNew n, 
                              ((map mkNew params, exp' body), 
                              map mkNew caps))) 
                          bindings, 
                      exp' body)
  | exp' (A.LETX (x, e1, e2)) = 
        normalizeLet (mkNew x) (exp' (A.SIMPLE e1)) (exp' e2)
  | exp' (A.SET (x, e)) = A.SET (mkNew x, exp' e)
  in exp' (mkOld ex)
  end

  fun realloc e = realloc' Env.empty (RS 0) e

end



(* qsort is beautiful now!    *)
