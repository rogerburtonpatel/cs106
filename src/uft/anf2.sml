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
    | LETREC of ('a * 'a closure) list * 'a exp
    | SIMPLE  of 'a simple_exp
  and 'a simple_exp
  = LITERAL of literal 
  | NAME of 'a 
  | VMOP of vmop * 'a list
  | VMOPLIT of vmop * 'a list * literal
  | FUNCALL of 'a * 'a list 
  | FUNCODE of 'a list * 'a exp
  | CAPTURED of int
  | CLOSURE  of 'a closure
  | BLOCK of 'a list
     (* allocate a block and initialize each slot with the
        corresponding register *)  
  | SWITCH_VCON of 'a * ((Pattern.vcon * int) * 'a exp) list * 'a exp
       (* given SWITCH_VCON (r, choices, other), if the value in register
          r matches any (vcon, k) pair, then evaluate the corresponding
          expression, otherwise evaluate the other expression *)
  withtype 'a closure = ('a list * 'a exp) * 'a list
    (* (funcode, registers holding values of captured variables) *)  
  and 'a funcode = 'a list * 'a exp  (* lambda with no free names *)

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