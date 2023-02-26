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

  fun toReg' (dest : reg) (e : reg KNormalForm.exp) : instruction hughes_list =
        (case e
          of K.LITERAL l => S(A.loadlit dest l)
           | K.NAME n    => S (A.copyreg dest n)
           | K.VMOP (p, ns) => S (A.setreg dest p ns) (*todo: check how do we know p sets a register?*)
           | K.VMOPLIT (p, ns, l) => S (A.setregLit dest p ns l)
           | K.FUNCALL (n, ns) => Impossible.exercise "wait till module 8!"
           | K.IFX (n, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto n lab) o (toReg' n e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (toReg' n e1) 
                                   o S (A.deflabel lab')
            end
           | K.LETX (n, e, e') => (toReg' n e) o (toReg' dest e')
           | _ => Impossible.exercise "not yet")
  and forEffect' (e: reg KNormalForm.exp) : instruction hughes_list  =
(case e
          of K.LITERAL l => empty
           | K.NAME n    => empty
           | K.VMOP (p, ns) => S (A.effect p ns)
           | K.VMOPLIT (p, ns, l) => S (A.effectLit p ns l)
           | K.FUNCALL (n, ns) => Impossible.exercise "wait till module 8!"
           | K.IFX (n, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto n lab) o (toReg' n e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (toReg' n e1) 
                                   o S (A.deflabel lab')
            end
           (* | K.LETX (n, e, e') => (toReg' n e) o (toReg' dest e') *)
           | _ => Impossible.exercise "not yet")
  and toReturn' (e:  reg KNormalForm.exp) : instruction hughes_list  =
        forEffect' e  (* this will change in module 8 *)

  val _ = forEffect' :        reg KNormalForm.exp -> instruction hughes_list
  val _ = toReg'     : reg -> reg KNormalForm.exp -> instruction hughes_list

  fun forEffect e = forEffect' e []

end
