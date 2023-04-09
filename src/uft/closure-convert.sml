(* Closure conversion from unambiguous VScheme to Closed Scheme. 
    This is where we handle lambda and captured variables *)

(* You'll write this file *)

structure ClosureConvert :> sig
  val close : UnambiguousVScheme.def -> ClosedScheme.def
end 
= 
struct
  structure X = UnambiguousVScheme
  structure C = ClosedScheme
  structure S = Set

  fun literal (X.SYM x)   = C.STRING x
    | literal (X.INT i)   = C.INT i
    | literal (X.REAL i)  = C.REAL i
    | literal (X.BOOLV b) = C.BOOL b
    | literal X.EMPTYLIST = C.EMPTYLIST


  fun indexOf x xs = 
    (* returns `SOME i`, where i is the position of `x` in `xs`,
       or if `x` does not appear in `xs`, returns `NONE` *)
    let fun find k []        = NONE 
          | find k (y :: ys) = if x = y then SOME k else find (k + 1) ys
    in  find 0 xs
    end

  fun flip f x y = f y x

  fun free (expr : X.exp) = 
    let fun fr ex set = 
    (case ex
      of X.LITERAL _ => set
       | X.LOCAL n   => S.insert (n, set)
       | X.GLOBAL _  => set
       | X.SETLOCAL (n, e) => fr e (S.insert (n, set))
       | X.SETGLOBAL (n, e) => fr e set
       | X.IFX (e1, e2, e3) => S.union' [fr e1 set, fr e2 set, fr e3 set]
       | X.WHILEX (e, e')   => S.union' [fr e set, fr e' set]
       | X.BEGIN es         => S.union' (map (flip fr set) es)
       | X.FUNCALL (e, es)  => S.union' (fr e set :: (map (flip fr set) es))
       | X.PRIMCALL (_, es) => S.union' (map (flip fr set) es)
       | X.LETX (X.LET, bindings, body) => 
          let val (names, rhss) = ListPair.unzip bindings
          in S.union' (S.diff (S.ofList names, fr body set) 
                      :: (map (flip fr set) rhss))
          end
       | X.LETX (X.LETREC, bindings, body) => 
          let val (names, rhss) = ListPair.unzip bindings
          in S.diff (S.ofList names, 
                     S.union' (fr body set :: (map (flip fr set) rhss)))
          end
       | X.LAMBDA  (ns, e)  => S.diff (S.ofList ns, fr e set))
    in fr expr S.empty
    end

  val _ = free : X.exp -> X.name S.set

  fun closeExp captured e =
    (* Given an expression `e` in Unambiguous vScheme, plus a list
       of the free variables of that expression, return the closure-
       converted version of the expression in Closed Scheme *)
    let val _ = closeExp : X.name list -> X.exp -> C.exp
        
        (* proud of this: pattern matching on option type *)
        fun slotIfCaptured x [] _ = NONE 
          | slotIfCaptured x (y::ys) n = 
          if x = y then SOME n else slotIfCaptured x ys (n + 1)

        (* I recommend internal function closure : X.lambda -> C.closure *)
        fun closure (xs, body) = 
              let val capturedNames = S.elems (S.diff (S.ofList xs, free body))
              (* TODO WRONG C.LOCAL- need to get C.CAPUTRED if in captured *)
              in ((xs, exp body), map C.LOCAL capturedNames)
              end


        (* I recommend internal function exp : X.exp -> C.exp *)
        and exp (X.LITERAL l) = C.LITERAL (literal l)
          | exp (X.LOCAL n)   = 
            (case slotIfCaptured n captured 0 
             of SOME i => C.CAPTURED i
              | _ => C.LOCAL n)
          | exp (X.GLOBAL n) = C.GLOBAL n
          | exp (X.SETLOCAL (n, e)) = 
            (case slotIfCaptured n captured 0
              of NONE => C.SETLOCAL (n, exp e)
               | _ => Impossible.impossible 
                      "attempted to write to a captured variable")
          | exp (X.SETGLOBAL (n, e)) = C.SETGLOBAL (n, exp e)
          | exp (X.IFX (e1, e2, e3)) = C.IFX (exp e1, exp e2, exp e3)
          | exp (X.WHILEX (e, e'))   = C.WHILEX (exp e, exp e')
          | exp (X.BEGIN es)         = C.BEGIN (map exp es)
          | exp (X.PRIMCALL (p, es)) = C.PRIMCALL (p, map exp es)
          | exp (X.FUNCALL (e, es))  = C.FUNCALL (exp e, map exp es)
          | exp (X.LETX (X.LET, bindings, body)) = 
             C.LET (List.map (fn (name, e) => (name, exp e)) bindings, exp body)
          | exp (X.LETX (X.LETREC, bindings, body)) = Impossible.impossible "closure-convert letrec"
          | exp (X.LAMBDA (ns, e)) = C.CLOSURE (closure (ns, e))

        val _ = closure : X.lambda -> C.closure
    in  exp e
    end

  fun close def = Impossible.exercise "close a definition"


end
