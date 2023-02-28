(* Representation of KNormal-form, with some utility functions *)

(* You'll define the representation of `'a exp`, and you'll write
   the utility functions. *)

structure ANormalForm = struct
  
  datatype literal = datatype KNormalForm.literal

  type vmop = Primitive.primitive

  datatype 'a exp      (* type parameter 'a is a _name_, typically
                          instantiated as `string` or `ObjectCode.reg` *)
    = I of 'a internal_allowed_exp | T of 'a top_level_only_exp

  and 'a internal_allowed_exp
  = LITERAL of literal 
  | NAME of 'a 
  | VMOP of vmop * 'a list
  | VMOPLIT of vmop * 'a list * literal
  | FUNCALL of 'a * 'a list 
  | BEGIN   of 'a exp * 'a exp 
  | SET     of 'a * 'a exp
  | FUNCODE of 'a list * 'a exp

  and 'a top_level_only_exp
  =   IFX     of 'a * 'a exp * 'a exp 
    | LETX    of 'a * 'a internal_allowed_exp * 'a exp
    | WHILEX  of 'a * 'a exp * 'a exp 
  

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

  fun setglobal (x, register) = A.I (A.VMOPLIT (Primitive.setglobal, 
                                            [register], A.STRING x))
  fun getglobal x             = A.I (A.VMOPLIT (Primitive.getglobal, [], A.STRING x))

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