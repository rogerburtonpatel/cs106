(* In A-normal form, convert string names to register names *)

(* You'll write this file *)

structure ANRename :> sig
  val regOfName : string -> ObjectCode.reg Error.error
  val mapx : ('a -> 'b Error.error) ->
             ('a ANormalForm.exp -> 'b ANormalForm.exp Error.error)
end
  =
struct
  structure A = ANormalForm

  infix 3 <*>   val op <*> = Error.<*>
  infixr 4 <$>  val op <$> = Error.<$>

  val succeed = Error.succeed
  val errorList = Error.list

  fun curry  f x y   = f (x, y)
  fun curry3 f x y z = f (x, y, z)

  (* AsmLex.registerNum takes a string starting with "r" followed by a number n
     such that 0 <= n < 256, and returns n *)
  val regOfName = AsmLex.registerNum
exception typecheat
  fun mapx f = fn expr => 
  (case expr 
    of A.SIMPLE e => A.SIMPLE <$> (mapxSimple f e)
     | A.IFX (n, e1, e2) => curry3 A.IFX <$> f n <*> mapx f e1 <*> mapx f e2
     | A.LETX (n, e1, e2) => curry3 A.LETX <$> f n <*> mapxSimple f e1 <*> mapx f e2
     | A.BEGIN (e, e') => curry A.BEGIN <$> mapx f e <*> mapx f e'
     | A.WHILEX (n, e, e') => curry3 A.WHILEX <$> f n <*> mapx f e
                                                                 <*> mapx f e')
  and mapxSimple f = fn e =>
  (case e 
      of A.LITERAL l => succeed (A.LITERAL l)
       | A.NAME n => A.NAME <$> f n
       (* this need a lot of fixing *)
       | A.VMOP (p, ns) =>  curry A.VMOP <$> (succeed p) <*> errorList (map f ns)
       | A.VMOPLIT (p, ns, l) => curry3 A.VMOPLIT <$> (succeed p) <*> 
                                             errorList (map f ns) <*> (succeed l)
       | A.FUNCALL (n, ns) => curry A.FUNCALL <$> f n <*> errorList (map f ns)
       | A.SET (n, e) => curry A.SET <$> f n <*> mapx f e
       | A.FUNCODE (ns, e) => curry A.FUNCODE <$> errorList (map f ns) 
                                                                   <*> mapx f e)

    

end
