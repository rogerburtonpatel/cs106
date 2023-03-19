(* Representation of KNormal-form, with some utility functions *)

(* You'll define the representation of `'a exp`, and you'll write
   the utility functions. *)

structure ANormalForm = struct
  
  datatype literal = datatype KNormalForm.literal

  type vmop = Primitive.primitive

  datatype 'a exp      (* type parameter 'a is a _name_, typically
                          instantiated as `string` or `ObjectCode.reg` *)
    = IFX     of 'a * 'a exp * 'a exp 
    | LETX    of 'a * 'a simple_exp * 'a exp
    | BEGIN   of 'a exp * 'a exp 
    | WHILEX  of 'a * 'a exp * 'a exp 
    | SET     of 'a * 'a exp
    | SIMPLE  of 'a simple_exp
  and 'a simple_exp
  = LITERAL of literal 
  | NAME of 'a 
  | VMOP of vmop * 'a list
  | VMOPLIT of vmop * 'a list * literal
  | FUNCALL of 'a * 'a list 
  | FUNCODE of 'a list * 'a exp

end

structure ANormalUtil :> sig
  type name = string
  val setglobal : name * 'a -> 'a ANormalForm.exp
  val getglobal : name -> 'a ANormalForm.exp

   (* create these @(x,...x, v) forms:
         setglobal(register, name-of-global)
         getglobal(name-of-global)
    *)

  (* you could consider adding similar functions for `check`, `expect`,
     and `check-assert` *)
end
  =
struct
  structure A = ANormalForm
  type name = string

  fun setglobal (x, register) = A.SIMPLE (A.VMOPLIT (Primitive.setglobal, 
                                            [register], A.STRING x))
  fun getglobal x             = A.SIMPLE (A.VMOPLIT (Primitive.getglobal, 
                                                     [], A.STRING x))

end


    (* = LITERAL of literal
    | NAME of 'a
    | VMOP of vmop * 'a list
    | VMOPLIT of vmop * 'a list * literal
    | FUNCALL of 'a * 'a list 
    | IFX     of 'a * 'a exp * 'a exp 
    | LETX    of 'a * 'a exp * 'a exp
    | BEGIN   of 'a exp * 'a exp 
    | SET     of 'a * 'a exp
    | WHILEX  of 'a * 'a exp * 'a exp 
    | FUNCODE of 'a list * 'a exp *)