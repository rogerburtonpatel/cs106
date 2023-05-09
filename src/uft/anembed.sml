(* Embeds ANormal-form Scheme into K-Normal form. This cannot fail. *)


structure ANEmbed :> sig
  val def   : int ANormalForm.exp -> int KNormalForm.exp
end 
  = 
struct
  structure A  = ANormalForm
  structure C  = ClosedScheme
  structure K  = KNormalForm
  structure P  = Primitive

  fun fst (x, y) = x
  fun snd (x, y) = y

  fun nameFrom (A.STRING s) = s
    | nameFrom _          = Impossible.impossible "misused function"

  fun regname r = "$r" ^ Int.toString r

  fun bindRegNames (rn, acc) = acc ^ " " ^ regname rn

  fun exp (A.SIMPLE se) = 
      (case se 
       of A.LITERAL v => K.LITERAL v
        | A.NAME x       => K.NAME x
        | A.VMOP (p, ns) => 
          (* if not (AsmGen.areConsecutive ns) then
            Impossible.impossible ("non-consecutive registers in AN->KN vmop " ^
                                  P.name p ^ ": " ^ (foldr bindRegNames "" ns))
          else *)
          K.VMOP (p, ns)
        | A.VMOPLIT (p, ns, l) => 
          (* if not (AsmGen.areConsecutive ns) then
            Impossible.impossible ("non-consecutive registers in AN->KN vmop " ^
                                  P.name p)
          else  *)
            K.VMOPLIT (p, ns, l)
        | A.FUNCALL (name, args) =>           
           (* if not (AsmGen.areConsecutive args) then
            Impossible.impossible ("non-consecutive registers in AN->KN func " ^
                                  "in register r" ^ Int.toString name)
          else  *)
            K.FUNCALL (name, args)
        | A.FUNCODE (params, body) => K.FUNCODE (params, exp body)
        | A.CAPTURED i => K.CAPTURED i
        | A.CLOSURE cl => K.CLOSURE (embedClosure cl)
        | A.BLOCK ns => K.BLOCK ns
        | A.SWITCH_VCON (n, branches, default) => 
              K.SWITCH_VCON (n, map 
                                (fn ((p, i), e) => ((p, i), exp e)) 
                                branches, exp default))
    | exp (A.IFX (n, e1, e2)) = K.IFX (n, exp e1, exp e2)
    | exp (A.LETX (n, e, e')) = K.LETX (n, exp (A.SIMPLE e), exp e')
    | exp (A.BEGIN (e1, e2))  = K.BEGIN (exp e1, exp e2)
    | exp (A.SET (n, e)) = K.SET (n, exp e)
    | exp (A.LETREC (bindings, body)) = 
        K.LETREC (map (fn (n, cl) => (n, embedClosure cl)) bindings, exp body)
    and embedClosure ((names, body), captured) = ((names, exp body), captured)
  
  fun regname r = "$r" ^ Int.toString r


  fun def e  = exp e
end
