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


  fun curry f x y = f (x, y)
  fun curry3 f x y z = f (x, y, z)
  (************** the code generator ******************)

  (* three contexts for code generation: to put into a register,
     to run for side effect, or (in module 8) to return. *)


(* TODO ADD GLOBALS *)
  fun toRegK' (dest : reg) (ex : reg KNormalForm.exp) : instruction hughes_list =
        (case ex
          of K.LITERAL l => S (A.loadlit dest l)
           | K.NAME r    => S (A.copyreg dest r)
           | K.VMOP (p as P.SETS_REGISTER _, rs) => S (A.setreg dest p rs)
           | K.VMOP (P.HAS_EFFECT _, _) => forEffectK' ex
           | K.VMOPLIT (p as P.SETS_REGISTER _, rs, l) => 
                                                    S (A.setregLit dest p rs l) 
           | K.VMOPLIT (P.HAS_EFFECT _, rs, l) => forEffectK' ex
           | K.FUNCALL (r, rs) => Impossible.exercise "wait till module 8!"
           | K.IFX (r, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto r lab) o (toRegK' r e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (toRegK' r e1) 
                                   o S (A.deflabel lab')
            end
            (* Floatables *)
           | K.LETX (r, e, e') => (toRegK' r e) o (toRegK' dest e')
           | K.BEGIN (e1, e2)  => (forEffectK' e1) o (toRegK' dest e2)
           | K.SET (r, e)      => (toRegK' r e) o S (A.copyreg dest r)
           | K.WHILEX _        => (forEffectK' ex)
                                    o S (A.loadlit dest (K.BOOL false))
           | K.FUNCODE (rs, e) =>
                       S (A.loadfunc dest (List.length rs) ((toReturnK' e []))))
  and forEffectK' (ex: reg KNormalForm.exp) : instruction hughes_list  =
(case ex
          of K.LITERAL _ => empty
           | K.NAME _    => empty
           | K.VMOP (p as P.SETS_REGISTER _, _) => empty 
           | K.VMOP (p as P.HAS_EFFECT _, ns) => S (A.effect p ns)
           | K.VMOPLIT (p as P.SETS_REGISTER _, _, _) => empty
           | K.VMOPLIT (p as P.HAS_EFFECT _, ns, l) => S (A.effectLit p ns l)

           | K.FUNCALL (r, ns) => Impossible.exercise "wait till module 8!"
           | K.IFX (r, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto r lab) o (forEffectK' e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (forEffectK' e1) 
                                   o S (A.deflabel lab')
            end
           | K.LETX  (r, e, e')  => (toRegK' r e) o (forEffectK' e')
           | K.BEGIN (e1, e2)    => (forEffectK' e1) o (forEffectK' e2)
           | K.SET   (r, e)      => (toRegK' r e)
           | K.WHILEX (r, e, e') => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.goto lab) o S (A.deflabel lab') o (forEffectK' e')
                o S (A.deflabel lab) o (toRegK' r e) o S (A.ifgoto r lab')          
            end
           | K.FUNCODE (rs, e) => 
              let val r = 255 (* TODO change this *)
              in toRegK' r ex
              end)
  and toReturnK' (e:  reg KNormalForm.exp) : instruction hughes_list  =
        forEffectK' e  (* this will change in module 8 *)

  fun toRegA' (dest : reg) (expr : reg ANormalForm.exp) : instruction hughes_list =
        (case expr
          of AN.SIMPLE ex =>
          (case ex
            of AN.LITERAL l => S (A.loadlit dest l)
             | AN.NAME r    => S (A.copyreg dest r)
             | AN.VMOP (p as P.SETS_REGISTER _, rs) => S (A.setreg dest p rs)
             | AN.VMOP (P.HAS_EFFECT _, _) => forEffectA' expr
             | AN.VMOPLIT (p as P.SETS_REGISTER _, rs, l) => 
                                                     S (A.setregLit dest p rs l) 
             | AN.VMOPLIT (P.HAS_EFFECT _, rs, l) => forEffectA' expr
             | AN.FUNCALL (r, rs) => Impossible.exercise "wait till module 8!"
 
             | AN.FUNCODE (rs, e) =>
                       S (A.loadfunc dest (List.length rs) ((toReturnA' e []))))

            | AN.SET (r, e)      => (toRegA' r e) o S (A.copyreg dest r)
            | AN.BEGIN (e1, e2)  => (forEffectA' e1) o (toRegA' dest e2)
            | AN.IFX (r, e1, e2) => 
              let val lab  = A.newlabel ()
                  val lab' = A.newlabel ()
              in S (A.ifgoto r lab) o (toRegA' r e2) o S (A.goto lab')
                                    o S (A.deflabel lab) o (toRegA' r e1) 
                                    o S (A.deflabel lab')
          end
          (* Floatables *)
          | AN.LETX (r, e, e') => (toRegA' r (AN.SIMPLE e)) o (toRegA' dest e')
          | AN.WHILEX _        => (forEffectA' expr)
                                  o S (A.loadlit dest (AN.BOOL false)))
  and forEffectA' (expr: reg ANormalForm.exp) : instruction hughes_list  =
        (case expr
          of AN.SIMPLE ex =>
          (case ex
            of AN.LITERAL _ => empty
             | AN.NAME _    => empty
             | AN.VMOP (p as P.SETS_REGISTER _, _) => empty 
             | AN.VMOP (p as P.HAS_EFFECT _, ns) => S (A.effect p ns)
             | AN.VMOPLIT (p as P.SETS_REGISTER _, _, _) => empty
             | AN.VMOPLIT (p as P.HAS_EFFECT _, ns, l) => S (A.effectLit p ns l)

             | AN.FUNCALL (r, ns) => Impossible.exercise "wait till module 8!"
             | AN.FUNCODE (rs, e) => 
                 let val r = 255 (* TODO change this *)
                 in toRegA' r expr
                 end)

           | AN.SET   (r, e)      => (toRegA' r e)
           | AN.BEGIN (e1, e2)    => (forEffectA' e1) o (forEffectA' e2)
           | AN.IFX (r, e1, e2) => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.ifgoto r lab) o (forEffectA' e2) o S (A.goto lab')
                                   o S (A.deflabel lab) o (forEffectA' e1) 
                                   o S (A.deflabel lab')
             end
           | AN.LETX  (r, e, e')  => (toRegA' r (AN.SIMPLE e)) o (forEffectA' e')
           | AN.WHILEX (r, e, e') => 
             let val lab  = A.newlabel ()
                 val lab' = A.newlabel ()
             in S (A.goto lab) o S (A.deflabel lab') o (forEffectA' e')
                 o S (A.deflabel lab) o (toRegA' r e) o S (A.ifgoto r lab')          
               end)
  and toReturnA' (e:  reg ANormalForm.exp) : instruction hughes_list  =
        forEffectA' e  (* this will change in module 8 *)


  val _ = forEffectK' :        reg KNormalForm.exp -> instruction hughes_list
  val _ = toRegK'     : reg -> reg KNormalForm.exp -> instruction hughes_list

  val _ = forEffectA' :        reg ANormalForm.exp -> instruction hughes_list
  val _ = toRegA'     : reg -> reg ANormalForm.exp -> instruction hughes_list

  fun forEffectK e  = forEffectK'  e []
  fun toRegK dest e = toRegK' dest e []

  fun forEffectA e  = forEffectA'  e []
  fun toRegA dest e = toRegA' dest e []

end
