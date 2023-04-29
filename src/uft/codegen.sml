(* Generates abstract assembly code from KNormal-form VScheme *)

(* You'll write this file *)

structure Codegen
  :>
sig 
  type reg = ObjectCode.reg
  type instruction = AssemblyCode.instr
  val forEffectK : reg KNormalForm.exp -> instruction list
  val forEffectA : reg ANormalForm.exp -> instruction list
end
  =
struct
  structure A = AsmGen
  structure K = KNormalForm
  structure AN = ANormalForm
  structure P = Primitive
  structure O = ObjectCode
  structure ASM = AssemblyCode

  type reg = ObjectCode.reg
  type instruction = AssemblyCode.instr

  fun fst (x, y) = x
  fun snd (x, y) = y

  (********* Join lists, John Hughes (1986) style *********)

  type 'a hughes_list = 'a list -> 'a list
    (* append these lists using `o` *)

  (* don't look at these implementations; look at the types below! *)
  fun empty tail = tail
  fun S e  tail = e :: tail
  fun L es tail = es @ tail

  val _ = empty : 'a hughes_list
  val _ = S     : 'a      -> 'a hughes_list   (* singleton *)
  val _ = L     : 'a list -> 'a hughes_list   (* conversion *)

  val hconcat : 'a hughes_list list -> 'a hughes_list
    = fn xs => foldr op o empty xs


  fun curry f x y = f (x, y)
  fun curry3 f x y z = f (x, y, z)
  (************** the code generator ******************)

  (* three contexts for code generation: to put into a register,
     to run for side effect, or (in module 8) to return. *)

(* Thank you matt! *)
  fun translateifK r e1 e2 f = 
    let 
      val lab  = A.newlabel()
      val lab' = A.newlabel()
    in S (A.ifgoto r lab) o (f e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (f e1) 
                                   o S (A.deflabel lab')
    end

  fun translateifA r e1 e2 f = 
    let 
      val lab  = A.newlabel()
      val lab' = A.newlabel()
    in S (A.ifgoto r lab) o (f e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (f e1) 
                                   o S (A.deflabel lab')
    end

  fun translateCall dest r rs = 
        if A.areConsecutive (r::rs)
        then S (A.call dest r (List.last (r::rs)))
        else 
        Impossible.impossible ("non-consecutive " ^
        "registers in call to dest " ^ Int.toString dest)
                    (* todo ask: why couldn't I use MatchCompiler.labeled_constructor here? *)
  val conLiteral : (string * int) -> A.literal =
    fn lcon => case lcon of ("#t", 0)  => ObjectCode.BOOL true
                          | ("#f", 0)  => ObjectCode.BOOL false
                          | ("'()", 0) => ObjectCode.EMPTYLIST
                          | (ds, 0)  => if CharVector.all Char.isDigit ds 
                                          then ObjectCode.INT 
                                              (Option.getOpt (Int.fromString ds,
                                                              ~9999))
                                                      (* if you see this, bad *)
                                          else ObjectCode.STRING ds
                          | (name, _) =>  ObjectCode.STRING name

  fun switchVcon gen finish (r, choices, fallthru) = 
    let
        fun mkBranchAndCase (lcon as (_, arity), e) = 
        (* we need to generate these together since they use the same label *)
                         let val lab = A.newlabel() 
                         in (S (A.deflabel lab) o gen e o finish, 
                                    (conLiteral lcon, arity, lab)) (* a pair *)
                         end
        val (branches, cases) = ListPair.unzip (map mkBranchAndCase choices)
        val gotovcon = A.gotoVcon r cases
    in S gotovcon o gen fallthru o hconcat branches 
    end

  val _ = switchVcon :  (reg KNormalForm.exp -> instruction hughes_list) 
           -> instruction hughes_list 
           -> reg * ((string * int) * reg KNormalForm.exp) list * reg KNormalForm.exp 
           -> instruction hughes_list
  (* for a bit of clarity *)
  val r0 = 0


(* mapi : (int * 'a ‑> 'b) ‑> 'a list ‑> 'b list *)
fun mapi f xs =  (* missing from mosml *)
  let fun go k [] = []
        | go k (x::xs) = f (k, x) :: go (k + 1) xs
  in  go 0 xs
  end




  (* let binding to error *)
  fun instrOrErrorIfArityMismatch p rs extra good = 
    if P.arity p = List.length rs + extra
    then good
    else L (A.mkerror ("bad number of arguments in primitive " ^ P.name p))


fun letrec gen (bindings, body) =
   let val _ = letrec : (reg K.exp -> instruction hughes_list)
                     -> (reg * reg K.closure) list * reg K.exp
                     -> instruction hughes_list
      (* one helper function to allocate and another to initialize *)
      fun alloc (f_i, closure as (funcode as (formals, body), captures)) = 
        toRegK' f_i (K.FUNCODE funcode)
        o S (A.mkclosure f_i f_i (List.length captures))
      fun init  (f_i, closure as (funcode as (formals, body), captures)) = 
        L (mapi (fn (k, v) => A.setclslot f_i k v) captures)

  in  hconcat (map alloc bindings) o hconcat (map init bindings) o gen body
  end
  and toRegK' (dest : reg) (ex : reg KNormalForm.exp) : instruction hughes_list =
        (case ex
          of K.LITERAL l => S (A.loadlit dest l)
           | K.NAME r    => S (A.copyreg dest r)
           | K.VMOP (p as P.SETS_REGISTER _, rs) => 
                  (case (P.name p, rs)
                    of ("getblockslot", [r, i]) => S (A.getblockslot dest r i)
                     | _ =>
                  instrOrErrorIfArityMismatch p rs 0 (S (A.setreg dest p rs)))
           | K.VMOP (p as P.HAS_EFFECT _, rs) => 
              L (A.mkerror ("effectful primitive " ^ P.name p ^ " used in " ^
                  "register-setting context on register r" ^ 
                                                         Int.toString dest))
           | K.VMOPLIT (p as P.SETS_REGISTER _, rs, l) => 
             instrOrErrorIfArityMismatch p rs 1 (S (A.setregLit dest p rs l))
           | K.VMOPLIT (p as P.HAS_EFFECT _, rs, l) => 
               (case (P.name p, l) of ("error", O.STRING msg) => 
                L (A.mkerror msg)
              | _ =>
               L (A.mkerror ("effectful primitive " ^ P.name p ^ " used in " ^
                  "register-setting context on register r" ^ 
                                                         Int.toString dest)))
           (* | K.VMOPINT (p as P.SETS_REGISTER _, r1, r2, i) => 
             instrOrErrorIfArityMismatch p [r1, r2] 1 (S (A.setregLit dest p rs l))
           | K.VMOPINT (p as P.HAS_EFFECT _, _, _) => 
               L (A.mkerror ("effectful primitive " ^ P.name p ^ " used in " ^
                  "register-setting context on register r" ^ Int.toString dest)) *)
          
           | K.FUNCALL (r, rs) => translateCall dest r rs
           | K.IFX (r, e1, e2) => translateifK r e1 e2 (toRegK' dest)
            (* Floatables *)
           | K.LETX (r, e, e') => (toRegK' r e) o (toRegK' dest e')
           | K.BEGIN (e1, e2)  => (forEffectK' e1) o (toRegK' dest e2)
           | K.SET (r, e)      => (toRegK' r e) o S (A.copyreg dest r)
           | K.WHILEX _        => (forEffectK' ex)
                                    o S (A.loadlit dest (K.BOOL false))
           | K.FUNCODE lambda => funcode dest lambda
           | K.CAPTURED i => S (A.captured dest i)
           | K.CLOSURE (lambda, captured) => putClIntoReg dest lambda captured
           | K.LETREC lr => letrec (toRegK' dest) lr
           | K.BLOCK rs => S (A.mkblock dest (hd rs) (List.length rs))
                           o L (mapi 
                                  (fn (slotnum, blkreg) =>
                                    A.setblockslot dest (slotnum + 1) blkreg) 
                                    (* todo ask *)
                               (tl rs))
           | K.SWITCH_VCON sv => 
              let val exitLabel = A.newlabel ()
              in switchVcon (toRegK' dest) (S (A.goto exitLabel)) sv
                 o S (A.deflabel exitLabel)
                                    (* todo ask *)
              end)
  and forEffectK' (ex: reg KNormalForm.exp) : instruction hughes_list  =
    (case ex
      of K.LITERAL _ => empty
        | K.NAME _    => empty
        | K.VMOP (p as P.SETS_REGISTER _, rs) => 
                      instrOrErrorIfArityMismatch p rs 0 empty
        | K.VMOP (p as P.HAS_EFFECT _, rs) => 
                      instrOrErrorIfArityMismatch p rs 0 (S (A.effect p rs))
        | K.VMOPLIT (p as P.SETS_REGISTER _, rs, _) => 
                      instrOrErrorIfArityMismatch p rs 1 empty
        | K.VMOPLIT (p as P.HAS_EFFECT _, rs, l) => 
                instrOrErrorIfArityMismatch p rs 1 (S (A.effectLit p rs l))
        | K.FUNCALL (r, rs) => translateCall r r rs
        | K.IFX (r, e1, e2) => translateifK r e1 e2 forEffectK'

        | K.LETX  (r, e, e')  => (toRegK' r e) o (forEffectK' e')
        | K.BEGIN (e1, e2)    => (forEffectK' e1) o (forEffectK' e2)
        | K.SET   (r, e)      => toRegK' r e
        | K.WHILEX (r, e, e') => 
          let val lab  = A.newlabel ()
              val lab' = A.newlabel ()
          in S (A.goto lab) o S (A.deflabel lab') o (forEffectK' e')
            o S (A.deflabel lab) o (toRegK' r e) o S (A.ifgoto r lab')      
        end
        | K.FUNCODE (rs, e) => empty
        | K.CAPTURED i => empty
        | K.CLOSURE cl => empty
        | K.LETREC lr => letrec forEffectK' lr
        | K.BLOCK _ => empty
        | K.SWITCH_VCON sv => 
        let val exitLabel = A.newlabel ()
              in switchVcon forEffectK' (S (A.goto exitLabel)) sv 
                 o S (A.deflabel exitLabel)
                                    (* todo ask *)
              end)
  and toReturnK' (e:  reg KNormalForm.exp) : instruction hughes_list  =
        (* toRegK' 255 e o S (A.return 255) *)
        (case e
          of K.NAME n => S (A.return n)
           | K.IFX (r, e1, e2) => translateifK r e1 e2 toReturnK'
           | K.LETX (r, e1, e') => toRegK' r e1 o toReturnK' e'
           | K.BEGIN (e1, e2) => forEffectK' e1 o toReturnK' e2
           | K.SET (r, ex) => toRegK' r ex o S (A.return r)
           (* TODO here we'll add tail recursion optimization *)
           | K.FUNCALL (reg, reglist) => 
                                  S (A.tailcall reg (List.last (reg::reglist))) 
          (* 'wildcard' *)
           | K.WHILEX _ => toRegK' r0 e o S (A.return r0)
           | K.FUNCODE _ => toRegK' r0 e o (S (A.return r0))
           | K.LITERAL _ => toRegK' r0 e o (S (A.return r0))
           | K.VMOP _ => toRegK' r0 e o (S (A.return r0))
           | K.VMOPLIT _ => toRegK' r0 e o (S (A.return r0))
           | K.CAPTURED i => S (A.captured r0 i) o S (A.return r0)
           | K.CLOSURE (lambda, captured) => (putClIntoReg r0 lambda captured) o S (A.return r0)
           | K.LETREC lr => letrec toReturnK' lr
           | block as K.BLOCK _ => toRegK' r0 block 
           | K.SWITCH_VCON sv => 
              switchVcon toReturnK' empty sv)
                                    (* todo ask *)
  and funcode r (rs, e) = S (A.loadfunc r (List.length rs) (toReturnK' e []))
  and putClIntoReg r lambda captured = (funcode r lambda) 
                                  o S (A.mkclosure r r (List.length captured))
                                  o L (mapi (fn (slotnum, capreg) => A.setclslot r slotnum capreg) captured)



(* NOTE: I'm not maintaining these any more. I'm spending that time working on 
   actual A-Normal form in my other branch. If I choose to come back to have
   both paths for conversion, I might use a functor instead, as you suggested. 
                                  |
                                  V
*)

  
  fun toRegA' (dest : reg) (ex : reg ANormalForm.exp) : instruction hughes_list =
        (case ex
          of AN.LITERAL l => S (A.loadlit dest l)
           | AN.NAME r    => S (A.copyreg dest r)
           | AN.VMOP (p as P.SETS_REGISTER _, rs) => S (A.setreg dest p rs)
           | AN.VMOP (P.HAS_EFFECT _, _) => forEffectA' ex
           | AN.VMOPLIT (p as P.SETS_REGISTER _, rs, l) => 
                                                    S (A.setregLit dest p rs l) 
           | AN.VMOPLIT (p as P.HAS_EFFECT _, rs, l) => forEffectA' ex
           | AN.FUNCALL (r, rs) => translateCall dest r rs
           | AN.IFX (r, e1, e2) => translateifA r e1 e2 (toRegA' dest)

            (* Floatables *)
           | AN.LETX (r, e, e') => (toRegA' r e) o (toRegA' dest e')
           | AN.BEGIN (e1, e2)  => (forEffectA' e1) o (toRegA' dest e2)
           | AN.SET (r, e)      => (toRegA' r e) o S (A.copyreg dest r)
           | AN.WHILEX _        => (forEffectA' ex)
                                    o S (A.loadlit dest (AN.BOOL false))
           | AN.FUNCODE (rs, e) =>
                       S (A.loadfunc dest (List.length rs) (toReturnA' e [])))
  and forEffectA' (ex: reg ANormalForm.exp) : instruction hughes_list  =
(case ex
          of AN.LITERAL _ => empty
           | AN.NAME _    => empty
           | AN.VMOP (p as P.SETS_REGISTER _, _) => empty 
           | AN.VMOP (p as P.HAS_EFFECT _, ns) => S (A.effect p ns)
           | AN.VMOPLIT (p as P.SETS_REGISTER _, _, _) => empty
           | AN.VMOPLIT (p as P.HAS_EFFECT _, ns, l) => S (A.effectLit p ns l)

           | AN.FUNCALL (r, rs) => translateCall r0 r rs
           | AN.IFX (r, e1, e2) => translateifA r e1 e2 forEffectA'
           | AN.LETX  (r, e, e')  => (toRegA' r e) o (forEffectA' e')
           | AN.BEGIN (e1, e2)    => (forEffectA' e1) o (forEffectA' e2)
           | AN.SET   (r, e)      => toRegA' r e
           | AN.WHILEX (r, e, e') => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.goto lab) o S (A.deflabel lab') o (forEffectA' e')
                o S (A.deflabel lab) o (toRegA' r e) o S (A.ifgoto r lab')          
            end
           | AN.FUNCODE (rs, e) => 
              let val r = 255
              in toRegA' r ex
              end)
  and toReturnA' (e:  reg ANormalForm.exp) : instruction hughes_list  =
        (case e
          of AN.FUNCODE (reglist, ex) => (toRegA' r0 e) o (S (A.return r0))
           | AN.NAME n => S (A.return n)
           | AN.IFX (r, e1, e2) => translateifA r e1 e2 toReturnA'
           | AN.LETX (r, e1, e') => toRegA' r e1 o toReturnA' e'
           | AN.BEGIN (e1, e2) => forEffectA' e1 o toReturnA' e2
           | AN.SET (r, ex) => toRegA' r ex o S (A.return r)
           | AN.WHILEX (r, ex, ex') => toRegA' r0 e o S (A.return r0)
           | AN.FUNCALL (reg, reglist) => 
                                  S (A.tailcall reg (List.last (reg::reglist))) 
          (* 'wildcard' *)
           | AN.LITERAL _ => (toRegA' r0 e) o (S (A.return r0))
           | AN.VMOP _ => (toRegA' r0 e) o (S (A.return r0))
           | AN.VMOPLIT _ => (toRegA' r0 e) o (S (A.return r0)))



  val _ = forEffectK' :        reg KNormalForm.exp -> instruction hughes_list
  val _ = toRegK'     : reg -> reg KNormalForm.exp -> instruction hughes_list

  val _ = forEffectA' :        reg ANormalForm.exp -> instruction hughes_list
  val _ = toRegA'     : reg -> reg ANormalForm.exp -> instruction hughes_list

  fun forEffectK e  = forEffectK' e []
  fun toRegK dest e = toRegK' dest e []

  fun forEffectA e  = forEffectA'  e []
  fun toRegA dest e = toRegA' dest e []

end
