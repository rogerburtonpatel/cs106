(* Generates abstract assembly code from KNormal-form VScheme *)

(* You'll write this file *)

structure Codegen
  :>
sig 
  type reg = ObjectCode.reg
  type instruction = AssemblyCode.instr
  val forEffect : reg KNormalForm.exp -> instruction list
end
  =
struct
  structure A = AsmGen
  structure K = KNormalForm
  structure P = Primitive

  type reg = ObjectCode.reg
  type instruction = AssemblyCode.instr

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

  fun validatePrimitive p ifSets ifEffect = 
      (case p 
        of P.SETS_REGISTER b => ifSets
         | P.HAS_EFFECT    b => ifEffect)


(* TODO ADD GLOBALS *)
  fun toReg' (dest : reg) (ex : reg KNormalForm.exp) : instruction hughes_list =
        (case ex
          of K.LITERAL l => S (A.loadlit dest l)
           | K.NAME r    => S (A.copyreg dest r)
           | K.VMOP (p as P.SETS_REGISTER _, rs) => S (A.setreg dest p rs)
           | K.VMOP (P.HAS_EFFECT _, _) => forEffect' ex
           (* | K.VMOP (p, rs) => 
              validatePrimitive p (S (A.setreg dest p rs)) (forEffect' ex) *)
           | K.VMOPLIT (p as P.SETS_REGISTER _, rs, l) => 
                                                    S (A.setregLit dest p rs l) 
           | K.VMOPLIT (P.HAS_EFFECT _, rs, l) => forEffect' ex
           | K.FUNCALL (r, rs) => Impossible.exercise "wait till module 8!"
           | K.IFX (r, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto r lab) o (toReg' r e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (toReg' r e1) 
                                   o S (A.deflabel lab')
            end
            (* Floatables *)
           | K.LETX (r, e, e') => (toReg' r e) o (toReg' dest e')
           | K.BEGIN (e1, e2)  => (forEffect' e1) o (toReg' dest e2)
           | K.SET (r, e)      => (toReg' r e) o S (A.copyreg dest r)

           | K.WHILEX (r, e, e') => (forEffect' e) 
                                    o S (A.loadlit r (K.BOOL false))
           | K.FUNCODE (rs, e)   => 
                        S (A.loadfunc dest (List.length rs) ((toReturn' e []))))
  and forEffect' (ex: reg KNormalForm.exp) : instruction hughes_list  =
(case ex
          of K.LITERAL _ => empty
           | K.NAME _    => empty
           | K.VMOP (p as P.SETS_REGISTER _, _) => empty 
           | K.VMOP (p as P.HAS_EFFECT _, ns) => S (A.effect p ns)
           | K.VMOPLIT (p as P.SETS_REGISTER _, _, _) => empty
           | K.VMOPLIT (p as P.HAS_EFFECT _, ns, l) => S (A.effectLit p ns l)
           (* | K.VMOPLIT (p, ns, l) => 
              validatePrimitive p empty (S (A.effectLit p ns l)) *)
           | K.FUNCALL (r, ns) => Impossible.exercise "wait till module 8!"
           | K.IFX (r, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto r lab) o (forEffect' e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (forEffect' e1) 
                                   o S (A.deflabel lab')
            end
           | K.LETX  (r, e, e')  => (toReg' r e) o (forEffect' e')
           | K.BEGIN (e1, e2)    => (forEffect' e1) o (forEffect' e2)
           | K.SET   (r, e)      => (toReg' r e)
           | K.WHILEX (r, e, e') => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.goto lab) o S (A.deflabel lab') o (forEffect' e')
                o S (A.deflabel lab) o (toReg' r e) o S (A.ifgoto r lab')             
            end
           | K.FUNCODE (rs, e) => 
              let val r = 255 (* TODO change this *)
              in toReg' r ex
              end)
  and toReturn' (e:  reg KNormalForm.exp) : instruction hughes_list  =
        forEffect' e  (* this will change in module 8 *)

  val _ = forEffect' :        reg KNormalForm.exp -> instruction hughes_list
  val _ = toReg'     : reg -> reg KNormalForm.exp -> instruction hughes_list

  fun forEffect e  = forEffect'  e []
  fun toReg dest e = toReg' dest e []

end
