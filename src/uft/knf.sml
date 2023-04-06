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
  val freeIn    : string KNormalForm.exp -> name -> bool

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

  fun freeIn exp y =
  let fun member y []        = false
        | member y (z::zs)   = y = z orelse member y zs
      fun free   (K.LITERAL _)          = false
          | free (K.NAME n)             = n = y
          | free (K.VMOP (p, ns))       = member y ns
          | free (K.VMOPLIT (p, ns, l)) = member y ns
          | free (K.FUNCALL (n, ns))    = member y (n::ns)
          | free (K.FUNCODE (ns, body)) = (not (member y ns)) andalso free body

          | free (K.SET (n, e))        = n = y orelse free e
          | free (K.IFX (n, e1, e2))   = n = y orelse free e1 orelse free e2
          | free (K.WHILEX (n, e, e')) = n = y orelse free e orelse free e'
          | free (K.BEGIN (e1, e2))    = free e1 orelse free e2
          | free (K.LETX (n, e, e'))   = free e orelse 
                                        (n <> y andalso free e')
  in  free exp
  end


end
