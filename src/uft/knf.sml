(* Representation of KNormal-form, with some utility functions *)

(* You'll define the representation of `'a exp`, and you'll write
   the utility functions. *)

structure KNormalForm = struct
  
  datatype literal = datatype ObjectCode.literal

  type vmop = Primitive.primitive

  datatype 'a exp      (* type parameter 'a is a _name_, typically
                          instantiated as `string` or `ObjectCode.reg` *)
    = LITERAL of literal
    | NAME of 'a
    | VMOP of vmop * 'a list
    | VMOPLIT of vmop * 'a list * literal
    | FUNCALL of 'a * 'a list 
    | IFX     of 'a * 'a exp * 'a exp 
    | LETX    of 'a * 'a exp * 'a exp
    | BEGIN   of 'a exp * 'a exp 
    | SET     of 'a * 'a exp
    | WHILEX  of 'a * 'a exp * 'a exp 
    | FUNCODE of 'a list * 'a exp

end

structure KNormalUtil :> sig
  type name = string
  val setglobal : name * 'a -> 'a KNormalForm.exp
  val getglobal : name -> 'a KNormalForm.exp

   (* create these @(x,...x, v) forms:
         setglobal(register, name-of-global)
         getglobal(name-of-global)
    *)

  (* you could consider adding similar functions for `check`, `expect`,
     and `check-assert` *)
end
  =
struct
  structure K = KNormalForm
  type name = string

  fun setglobal (x, register) = K.VMOPLIT (Primitive.setglobal, 
                                            [register], K.STRING x)
  fun getglobal x             = K.VMOPLIT (Primitive.getglobal, [], K.STRING x)

end
