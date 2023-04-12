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


  fun curry f x y = f (x, y)

  fun indexOf x xs = 
    (* returns `SOME i`, where i is the position of `x` in `xs`,
       or if `x` does not appear in `xs`, returns `NONE` *)
    let fun find k []        = NONE 
          | find k (y :: ys) = if x = y then SOME k else find (k + 1) ys
    in  find 0 xs
    end

  fun free (expr : X.exp) = 
  let fun freeSets es = foldl (fn (e, set) => (free e)::set) nil es
  in
    (case expr
      of X.LITERAL _ => S.empty
       | X.LOCAL n   => S.insert (n, S.empty)
       | X.GLOBAL _  => S.empty
       | X.SETLOCAL (n, e) => S.union' [S.insert (n, S.empty), free e]
       | X.SETGLOBAL (n, e) => free e
       | X.IFX (e1, e2, e3) => S.union' [free e1, free e2, free e3]
       | X.WHILEX (e, e')   => S.union' [free e, free e']
       | X.BEGIN es         => S.union' (freeSets es)
       | X.FUNCALL (e, es)  => S.union' (freeSets (e::es))
       | X.PRIMCALL (_, es) => S.union' (freeSets es)
       | X.LETX (X.LET, bindings, body) => 
          let val (names, rhss) = ListPair.unzip bindings
          in S.union' (S.diff (free body, S.ofList names)::freeSets rhss)
          end
       | X.LETX (X.LETREC, bindings, body) => 
          let val (names, rhss) = ListPair.unzip bindings
          in S.diff (S.union' (free body :: freeSets rhss), S.ofList names)
          end
       | X.LAMBDA  (ns, e)  => S.diff (free e, S.ofList ns))
    (* in fr expr S.empty *)
    end 

  val _ = free : X.exp -> X.name S.set

  fun closeExp captured e =
    (* Given an expression `e` in Unambiguous vScheme, plus a list
       of the free variables of that expression, return the closure-
       converted version of the expression in Closed Scheme *)
    let val _ = closeExp : X.name list -> X.exp -> C.exp


        fun unLambda (X.LAMBDA lambda) = lambda
          | unLambda _ = 
                    Impossible.impossible "parser failed to insist on a lambda"

        (* proud of this: pattern matching on option type *)
        fun slotIfCaptured x [] _ = NONE 
          | slotIfCaptured x (y::ys) n = 
          if x = y then SOME n else slotIfCaptured x ys (n + 1)

        (* I recommend internal function closure : X.lambda -> C.closure *)
        fun closure (xs, body) = 
              let val capturedNames = S.elems (free (X.LAMBDA (xs, body)))
              in ((xs, closeExp capturedNames body),
                     map (fn n => closeExp captured (X.LOCAL n)) capturedNames)
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
          | exp (X.LETX (X.LETREC, bindings, body)) = 
              let val (names, lambdas) = ListPair.unzip bindings
                  val lambdas'         = map unLambda lambdas
              in C.LETREC (ListPair.zip (names, map closure lambdas'), exp body)
              end
          | exp (X.LAMBDA lambda) = C.CLOSURE (closure lambda)

        val _ = closure : X.lambda -> C.closure
    in  exp e
    end

  fun close def = 
    let val closeNoCap = closeExp []
    in case def 
        of X.VAL (v, e) => C.VAL (v, closeNoCap e)
    | X.DEFINE (n, (ns, e)) => C.DEFINE (n, (ns, closeNoCap e))
    | X.EXP e => C.EXP (closeNoCap e)
    | X.CHECK_EXPECT (s1, e1, s2, e2) => 
                  C.CHECK_EXPECT (s1, closeNoCap e1, s2, closeNoCap e2)
    | X.CHECK_ASSERT (s, e) => C.CHECK_ASSERT (s, closeNoCap e)
    | X.CHECK_ERROR (s, e)  => C.CHECK_ERROR  (s, closeNoCap e)

    end
  


end
