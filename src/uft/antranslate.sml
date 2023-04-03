(* Translate KNormal Form into ANormal representation. 
   This probably won't fail TODO FIX. *)

(* You'll complete this file *)

structure ANTranslate :> sig
  type reg = ObjectCode.reg
  (* val value : KNormalForm.value -> ANormalForm.literal *)
  val exp   : string KNormalForm.exp -> string ANormalForm.exp
end 
  = 
struct
  structure A  = ANormalForm
  structure AU = ANormalUtil
  structure P  = Primitive
  (* structure X  = UnambiguousVScheme *)
  structure K  = KNormalForm

  (* infix  0 >>=  val op >>= = Error.>>=
  infix  3 <*>  val op <*> = Error.<*>
  infixr 4 <$>  val op <$> = Error.<$>
  val succeed = Error.succeed
  val error = Error.ERROR
  val errorList = Error.list *)

  type reg = ObjectCode.reg

  fun curry  f x y   = f (x, y)
  fun curry3 f x y z = f (x, y, z)

  fun checky p = P.name p = "check" orelse P.name p = "expect"

  (* val asName : X.exp -> X.name Error.error
         (* project into a name; used where ANF expects a name *)
    = fn X.LOCAL x => succeed x 
       | e => error ("expected a local variable but instead got " ^ (X.whatIs e)) *)

(* val exp   : UnambiguousVScheme.exp -> string ANormalForm.exp Error.error *)

(* pick smallest register not free in e2, e3 *)

fun freshName name badnames = "y"
(* use regOfName, and search with actual name *)
      (* we'll reconstruct the actual name for efficient search *)



  (* fun value (X.SYM s) = A.STRING s
    | value (X.INT i) = A.INT i
    | value (X.REAL r) = A.REAL r
    | value (X.BOOLV b) = A.BOOL b
    | value  X.EMPTYLIST = A.EMPTYLIST *)

            (* 1     a  b                                *)
(* A[[let x = (if y e1 e2) in ex']]        = A[[(if y     a
                                              (let x = e1 in ex')
                                                        b
                                              (let x = e2 in ex'))]] *)

(* A[[let x = (while y := e do e') in ex']] = 
   ((while y := e do e'); let x = #f in ex') *)

(* A[[let x = (e1; e2) in ex']] = 
   (e1; let x = e2 in ex') *)

(* A[[let x = (y := e) in ex']] = 
   (y := e; let x = y in ex') *)


(* let y = (let x = e in e’) in body
≡ { provided y ≠ x and x ∉ fv(body) }
  let x = e in (let y = e’ in body) *)

(* MAJOR TODOS: 
   1. check over function structure 
   2. free variables *)

  fun member y []      = false
    | member y (z::zs) = y = z orelse member y zs

fun freeIn exp y =
  let fun member y []        = false
        | member y (z::zs)   = y = z orelse member y zs
      fun free (A.SIMPLE e) = 
        (case e 
          of A.LITERAL _         => false
          | A.NAME n             => n = y
          | A.VMOP (p, ns)       => member y ns
          | A.VMOPLIT (p, ns, l) => member y ns
          | A.FUNCALL (n, ns)    => member y (n::ns)
          | A.FUNCODE (ns, body) => (not (member y ns)) andalso free body)

        | free (A.SET (n, e))        = n = y orelse free e
        | free (A.IFX (n, e1, e2))   = n = y orelse free e1 orelse free e2
        | free (A.WHILEX (n, e, e')) = n = y orelse free e orelse free e'
        | free (A.BEGIN (e1, e2))    = free e1 orelse free e2
        | free (A.LETX (n, e, e'))   = free (A.SIMPLE e) orelse 
                                        (n <> y andalso free e')
  in  free exp
  end


fun freeVars (A.IFX (_, e1, e2)) = freeVars e1 @ freeVars e2
  | freeVars (A.LETX (x, se, e)) = freeVars (A.SIMPLE se) @ 
                                   List.filter (fn y => x <> y) (freeVars e)
  | freeVars (A.BEGIN (e1, e2)) = freeVars e1 @ freeVars e2
  | freeVars (A.WHILEX (_, e1, e2)) = freeVars e1 @ freeVars e2
  | freeVars (A.SET (_, e)) = freeVars e
    
  | freeVars (A.SIMPLE se) =
    (case se 
      of A.LITERAL(_) => []
       | A.NAME(x) => [x]
       (* TODO: are all these names free? *)
       | A.VMOP(_, xs) => xs
       | A.VMOPLIT(_, xs, _) => xs
       | A.FUNCALL(x, xs) => (x::xs)
       | A.FUNCODE(xs, e) => List.filter (fn y => 
                                           not (member y xs))
                                         (freeVars e))


  fun exp (K.LITERAL l)          = A.SIMPLE (A.LITERAL l)
    | exp (K.NAME n)             = A.SIMPLE (A.NAME n)
    | exp (K.VMOP (p, ns))       = A.SIMPLE (A.VMOP (p, ns))
    | exp (K.VMOPLIT (p, ns, l)) = A.SIMPLE (A.VMOPLIT (p, ns, l))
    | exp (K.FUNCALL (n, ns))    = A.SIMPLE (A.FUNCALL (n, ns))
    | exp (K.FUNCODE (ns, e))    = A.SIMPLE (A.FUNCODE (ns, exp e))
    
    | exp (K.SET (n, e)) = A.SET (n, exp e)
    
    | exp (K.LETX (x, e, e'))   = normalizeLet x (exp e) (exp e')
    | exp (K.IFX (x, e1, e2))   = normalizeIf x (exp e1) (exp e2)
    | exp (K.BEGIN (e1, e2))    = normalizeBegin (exp e1) (exp e2)
    | exp (K.WHILEX (x, e, e')) = normalizeWhile x (exp e) (exp e')

  (* and normalize (A.SIMPLE e) = A.SIMPLE e
                      (* todo again, ask- do we need this delegator function? *)
    | normalize (A.LETX (x, e, e'))   = normalizeLet x (A.SIMPLE e) e'
    | normalize (A.SET (x, e))        = normalizeSet x e
    | normalize (A.IFX (x, e1, e2))   = normalizeIf x e1 e2
    | normalize (A.BEGIN (e1, e2))    = normalizeBegin e1 e2
    | normalize (A.WHILEX (x, e, e')) = normalizeWhile x e e' *)
    
    (* https://www.cs.tufts.edu/cs/106/modules/06Atranslation.html#translations-of-let-bindings *)

  (* TODO needs freein check *)
  and normalizeLet x (A.LETX (y, ey, ey')) ex' = 
                      let val _ = TextIO.output (TextIO.stdOut, "normalizing on outer " ^ x ^ ", inner "  ^ y ^ "\n")
                      val freevars = freeVars ex'
                      val y_name = if x <> y andalso (not (member y freevars))
                                   then y
                                   else freshName y (x::freevars)
                      in 
                      (A.LETX (y_name, ey, normalizeLet x ey' ex'))
                      end
                     (* ask about where to look for free variables: if you 
                        keep normalizing and floating, can it affect the 
                        upper levels? *)
  (* TODO needs freein check *)
    | normalizeLet x (A.IFX (y, e1, e2)) ex' = 
                     A.IFX (y, (normalizeLet x e1 ex'), (normalizeLet x e2 ex'))

  (* TODO needs freein check *)
    | normalizeLet x (A.WHILEX (y, e, e')) ex' = 
            A.BEGIN ((normalizeWhile y e e'),
                          (normalizeLet x 
                                        (A.SIMPLE (A.LITERAL (A.BOOL false))))
                                        ex'
                    )
    | normalizeLet x (A.BEGIN (e1, e2)) ex' = 
                A.BEGIN( e1, (normalizeLet x e2 ex'))
    | normalizeLet x (A.SET (n, e)) ex' = 
                A.BEGIN ((A.SET (n,  e)), 
                        (normalizeLet x (A.SIMPLE (A.NAME n)) ex'))

    | normalizeLet x (A.SIMPLE e) e'  = A.LETX (x, e, e')  

  (* todo make these more interesting *)
  and normalizeIf x e1 e2   = A.IFX (x, e1, e2)
  and normalizeSet x e      = A.SET (x, e)
  and normalizeBegin (A.BEGIN (e1, e2)) e3 = normalizeBegin e1 (normalizeBegin e2 e3)
    | normalizeBegin e1 e2 = A.BEGIN (e1, e2)
  and normalizeWhile x e e' = A.WHILEX (x, e, e')
    (* float ifs *)
    (* float whiles *)
    (* float begins *)

    (* base cases- must come after recursive cases *)
                      (* A.SIMPLE here!  *)
    (* | normalize (A.WHILEX (x, e, e'))  = A.WHILEX (x, exp e, exp e')                                       
    | normalize (A.IFX    (y, e1, e2)) = A.IFX    (y, exp e1, exp e2)                                       
    | normalize (A.BEGIN  (e1, e2))    = A.BEGIN  (exp e1, exp e2) 
    | normalize _ = Impossible.impossible "normalize called on simple expr!" *)
  (* fun exp e = 
    (case e 
    (* each has its own normalize fn *)
      of K.LETX   _ => normalize e
       | K.IFX    _ => normalize e
       | K.BEGIN  _ => normalize e
       | K.WHILEX _ => normalize e
       (* todo: do we need to normalize set? *)
       | K.SET (n, e) => A.SET (n, exp e)
       | _ => A.SIMPLE (simpleExp e))
(* simpleExp could be inlined as pattern matching inside the let. *)
  and simpleExp (K.LITERAL l) = A.LITERAL l
    | simpleExp (K.NAME n)    = A.NAME n
    | simpleExp (K.VMOP (p, ns)) = A.VMOP (p, ns)
    | simpleExp (K.VMOPLIT (p, ns, l)) = A.VMOPLIT (p, ns, l)
    | simpleExp (K.FUNCALL (n, ns)) = A.FUNCALL (n, ns)
    | simpleExp (K.FUNCODE (ns, e)) = A.FUNCODE (ns, exp e)
    | simpleExp _ = Impossible.impossible "simpleExp used on non-simple expr!"

(* 
          1    a      b 
let x = (set z e) in ex'



          1     a                  b
let x = (let y = e in (set z y)) in ex'
(define law (e e') (= (+ e e') (+ e' e)))

 *)


  and normalize (K.LETX (x, (K.LETX (y, ey, ey')), ex')) = 
                normalize (K.LETX (y, ey, (K.LETX (x, ey', ex'))))
    | normalize (K.LETX (x, (K.IFX (y, e1, e2)), ex')) = 
                normalize (K.IFX (y, (K.LETX (x, e1, ex')), (K.LETX (x, e2, ex'))))
    | normalize (K.LETX (x, (K.WHILEX (y, e, e')), ex')) = 
                Impossible.impossible "let-while"
    | normalize (K.LETX (x, (K.BEGIN (e1, e2)), ex')) = 
                normalize (K.BEGIN (e1, (K.LETX (x, e2, ex'))))
    
    (* float ifs *)
    (* float whiles *)
    (* float begins *)

    (* base cases- must come after recursive cases *)
                      (* A.SIMPLE here!  *)
    | normalize (K.LETX   (x, e, e'))  = A.LETX   (x, simpleExp e, exp e')                                       
    | normalize (K.WHILEX (x, e, e'))  = A.WHILEX (x, exp e, exp e')                                       
    | normalize (K.IFX    (y, e1, e2)) = A.IFX    (y, exp e1, exp e2)                                       
    | normalize (K.BEGIN  (e1, e2))    = A.BEGIN  (exp e1, exp e2) 
    | normalize _ = Impossible.impossible "normalize called on simple expr!"       *)

  (* fun exp (K.LITERAL l) = succeed (A.SIMPLE (A.LITERAL l))
    | exp (K.NAME n)    = succeed (A.SIMPLE (A.NAME n))
    | exp (K.VMOP (p, ns)) = succeed (A.SIMPLE (A.VMOP (p, ns)))
    | exp (K.VMOPLIT (p, ns, l)) = A.SIMPLE <$> (curry3 A.VMOPLIT <$> (succeed p) <*> 
                                             (succeed ns) <*> (succeed l))
    | exp _ = error "nope" *)
(*
       | A.FUNCALL (n, ns) => curry A.FUNCALL <$> f n <*> errorList (map f ns)
       | A.BEGIN (e, e') => curry A.BEGIN <$> mapx f e <*> mapx f e'
       | A.SET (n, e) => curry A.SET <$> f n <*> mapx f e
       | A.FUNCODE (ns, e) => curry A.FUNCODE <$> errorList (map f ns) 
                                                                   <*> mapx f e) *)

  
  
  (* (X.LITERAL v) = succeed (A.LITERAL (value v))
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
                                                       (* todo: why a name, 
                                                          when setglobal takes
                                                          a register? *)
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
    
    | exp (X.LAMBDA (ns, e)) = curry A.FUNCODE <$> (succeed ns) <*> exp e *)
    (* error "no non-global functions in projection to \
                                                              \A-Normal form!" *)
  (* val fundef : string ANormalForm.exp -> string ANormalForm.exp = 
  fn e => curry3 A.LETX <$> (succeed t) 
                        <*> (curry A.FUNCODE <$> (succeed xs) <*> exp e)
                        <*> (curry AU.setglobal <$> (succeed f) <*> asName t') *)
  (* fun list nil     = succeed nil 
  | list (p::ps) = curry op :: <$> p <*> list ps *)

  (* val lt' : 'a parser list -> 'b parser -> ('a list * 'b) parser
  val lambda' : 'a parser -> (name list * exp) parser
  val setglobal : (name * exp) parser

  lt' [bind (lambda' exp)] [setglobal exp] *)

  (* fun def () *)
  (* fun def (X.EXP e) = exp e
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
                                A.VMOPLIT (P.setglobal, ["$r100"], A.STRING f)))) *)

end

