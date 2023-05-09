(* ANormalizer from Closed Scheme to ANormal-form Scheme. 
    This is where register allocation happens! *)


structure Realloc :> sig
  type reg = int  (* register *)
  type regset     (* set of registers *)
  val regname : reg -> string
  val exp : reg Env.env -> regset -> reg ANormalForm.exp -> reg ANormalForm.exp
  val def :                          reg ANormalForm.exp -> reg ANormalForm.exp
end 
  =
struct 
  structure A  = ANormalForm
  structure E  = Env
  structure P  = Primitive
  structure S  = Set

  infix 6 <+>
  val op <+> = Env.<+>

  fun fst (x, y) = x
  fun snd (x, y) = y
  fun member x = List.exists (fn y => x = y)

  fun eprint s = TextIO.output (TextIO.stdErr, s)

  (************ Register and regset operations ************)

  type reg = int
  fun regname r = "$r" ^ Int.toString r

  datatype oldreg = OLD of reg

  datatype regset = RS of int (* RS n represents { r | r >= n } *)

  val smallest : regset -> reg = fn (RS r) => r


  val -- : regset * reg -> regset   (* remove a register *)
   = fn (RS n, toRemove) => RS (Int.max (toRemove + 1, n))
  infixr 6 --
  

  fun uncurry f (x, y) = f x y
  fun curry f x y = f (x, y)

  (************ Register reallocation ************)

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
          in S.diff (S.union' (free body :: freeSets closures), S.ofList names)
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
                       (* if member from_x params then
                            fc 
                           else if not (member for_y params) then 
                            A.FUNCODE (params, substitutor body)
                           else 
                            let val fresh = (freshName (freeVars (A.SIMPLE fc)))
                                val renamedParameters = 
                                                renameList fresh for_y params
                                val freshBody = rename (for_y, fresh) body
                                val substBody = rename (from_x, for_y) freshBody
                            in A.FUNCODE (renamedParameters, substBody)
                            end *)
                    | A.CAPTURED i => A.CAPTURED i
                    | cl as A.CLOSURE ((params, body), captured) =>
                           (* if member from_x params then *)
                            A.CLOSURE ((params, body), renameList from_x for_y captured)
                           (* else if not (member for_y params) then 
                            A.CLOSURE ((params, substitutor body), 
                                        renameList from_x for_y captured)
                           else 
                            let val fresh = (freshName (freeVars (A.SIMPLE cl)))
                                val renamedParameters = 
                                                renameList fresh for_y params
                                (* we don't have to rename in the captured bc
                                   we know neither from_x nor for_y are 
                                   captured in this expression *)
                                val freshBody = rename (for_y, fresh) body
                                val substBody = substitutor freshBody
                            in A.CLOSURE ((renamedParameters, substBody), 
                                          captured)
                            end *)
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
          | substitutor (A.LETREC (bindings, body)) = Impossible.exercise 
                                                        "substitute in a letrec"
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
                               let val z = freshName (x::(e2free @ e3free))
                               val subst = rename (y, z)
                                in
                            (* x != y and y is free in e3 and x is free in e2 *)
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

    | normalizeLet x (A.LETREC (bindings, body)) ex' = Impossible.exercise 
                                                       "normalize let on Letrec"
    | normalizeLet x (A.SIMPLE e) e'  = A.LETX (x, e, e')   

  and normalizeIf x e1 e2   = A.IFX (x, e1, e2)
  and normalizeSet x e      = A.SET (x, e)
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

  (* val _ = bindAnyReg   : regset -> exp -> (reg -> exp) -> exp
  val _ = bindSmallest : regset -> exp -> (reg -> exp) -> exp *)

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
  
  (* val inLocalVar : regset -> (reg -> exp) -> exp =
    fn rs => fn k => let val t = smallest rs in A.SET (t, k t) end *)

  
  fun map' f' [] k = k []
  | map' f' (x :: xs) k =
      f' x (fn y => map' f' xs (fn ys => k (y :: ys)))
  

  (* WEIGHTLIFTERS *)

  fun mkOld (A.SIMPLE se) = A.SIMPLE (mkOldSim se)
    | mkOld (A.IFX (n, e1, e2)) = A.IFX (regname n, mkOld e1, mkOld e2)
    | mkOld (A.LETX (n, e, e')) = A.LETX (regname n, mkOldSim e, mkOld e')
    | mkOld (A.BEGIN (e1, e2))  = A.BEGIN (mkOld e1, mkOld e2)
    | mkOld (A.SET (n, e)) = A.SET (regname n, mkOld e)
    | mkOld (A.LETREC (bindings, body)) = 
        A.LETREC (map (fn (n, cl) => (regname n, embedClosure cl)) bindings, mkOld body)
    and embedClosure ((names, body), captured) = ((map regname names, mkOld body), map regname captured)
    and mkOldSim simple = 
      (case simple 
       of A.LITERAL v => A.LITERAL v
        | A.NAME x       => A.NAME (regname x)
        | A.VMOP (p, ns) => 
          (* if not (AsmGen.areConsecutive ns) then
            Impossible.impossible ("non-consecutive registers in AN->KN vmop " ^
                                  P.name p)
          else *)
          A.VMOP (p, map regname ns)
        | A.VMOPLIT (p, ns, l) => 
          (* if not (AsmGen.areConsecutive ns) then
            Impossible.impossible ("non-consecutive registers in AN->KN vmop " ^
                                  P.name p)
          else  *)
            A.VMOPLIT (p, map regname ns, l)
        | A.FUNCALL (name, args) =>           
           (* if not (AsmGen.areConsecutive args) then
            Impossible.impossible ("non-consecutive registers in AN->KN func " ^
                                  "in register r" ^ Int.toString name)
          else  *)
            A.FUNCALL (regname name, map regname args)
        | A.FUNCODE (params, body) => A.FUNCODE (map regname params, mkOld body)
        | A.CAPTURED i => A.CAPTURED i
        | A.CLOSURE cl => A.CLOSURE (embedClosure cl)
        | A.BLOCK ns => A.BLOCK (map regname ns)
        | A.SWITCH_VCON (n, branches, default) => 
              A.SWITCH_VCON (regname n, map 
                                (fn ((p, i), e) => ((p, i), mkOld e)) 
                                branches, mkOld default))

  fun exp rho A ex = 
    let val exp : reg Env.env -> regset -> exp -> exp = exp
        val nbRegs = nbRegsWith (exp rho) 
        (*  ^ normalize and bind in _this_ environment *)
        fun mkNew rname = case AsmLex.registerNum rname 
                            of Error.OK r => r
                             | _ => Impossible.impossible "realloc rename bug." 
        fun exp' (A.SIMPLE se) = 
            (case se
              of A.VMOP (p, ns) => simp A.VMOP (p, map mkNew ns)
               | A.VMOPLIT (p, ns, l) => simp A.VMOPLIT (p, map mkNew ns, l)
               | A.BLOCK ns => simp A.BLOCK (map mkNew ns)
               | A.CAPTURED i => simp A.CAPTURED i
               | A.CLOSURE ((params, body), caps) => simp A.CLOSURE ((map mkNew params, exp' body), map mkNew caps)
               | A.FUNCALL (name, args) => if (AsmGen.areConsecutive (map mkNew args))
                                           then simp A.FUNCALL (mkNew name, map mkNew args)
                                           else
                    bindSmallest A (simp (A.NAME o mkNew) name)
                         (fn reg => nbRegs bindSmallest (A -- reg) (map (simp A.NAME o mkNew) args)
                            (fn regs => simp A.FUNCALL (reg, regs)))
               | A.FUNCODE (params, body) => simp A.FUNCODE (map mkNew params, exp' body)
               | A.LITERAL l => simp A.LITERAL l
               | A.NAME n => simp A.NAME (mkNew n)
               | A.SWITCH_VCON (name, branches, default) => 
                  simp A.SWITCH_VCON (mkNew name, map (fn (p_a, expr) => (p_a, exp' expr)) branches, exp' default))
  | exp' (A.BEGIN (e1, e2)) = A.BEGIN (exp' e1, exp' e2)
  | exp' (A.IFX (n, e1, e2)) = A.IFX (mkNew n, exp' e1, exp' e2)
  | exp' (A.LETREC (bindings, body)) = 
            A.LETREC (map (fn (n, ((params, body), caps)) => 
                              (mkNew n, 
                              ((map mkNew params, exp' body), 
                              map mkNew caps))) 
                          bindings, 
                      exp' body)
  | exp' (A.LETX (x, e1, e2)) = normalizeLet (mkNew x) (exp' (A.SIMPLE e1)) (exp' e2)
  | exp' (A.SET (x, e)) = A.SET (mkNew x, exp' e)
  in exp' (mkOld ex)
    end

fun def e = exp Env.empty (RS 0) e

end

