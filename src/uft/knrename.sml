(* In K-normal form, convert string names to register names *)

(* You'll write this file *)

structure KNRename :> sig
  val regOfName : string -> ObjectCode.reg Error.error
  val nameOfReg : ObjectCode.reg -> string Error.error
  val mapx : ('a -> 'b Error.error) ->
             ('a KNormalForm.exp -> 'b KNormalForm.exp Error.error)
end
  =
struct
  structure K = KNormalForm

  infix 3 <*>   val op <*> = Error.<*>
  infixr 4 <$>  val op <$> = Error.<$>

  val succeed = Error.succeed
  val errorList = Error.list

  fun curry  f x y   = f (x, y)
  fun curry3 f x y z = f (x, y, z)
  fun pair x y = (x, y)

  (* AsmLex.registerNum takes a string starting with "r" followed by a number n
     such that 0 <= n < 256, and returns n *)
  val regOfName = AsmLex.registerNum
  fun nameOfReg r = succeed ("r" ^ Int.toString r)

  fun pair x y = (x, y)
  fun curryClBody x y z = ((x, y), z)
 

  fun mapx f = 
    fn e => 
    (case e 
     of K.LITERAL l => succeed (K.LITERAL l)
      | K.NAME n => K.NAME <$> f n
      | K.VMOP (p, ns) => curry K.VMOP <$> (succeed p) <*> errorList (map f ns)
      | K.VMOPLIT (p, ns, l) => curry3 K.VMOPLIT <$> (succeed p) <*> 
                                            errorList (map f ns) <*> (succeed l)
      | K.FUNCALL (n, ns) => curry K.FUNCALL <$> f n <*> errorList (map f ns)
      | K.IFX (n, e1, e2) => curry3 K.IFX <$> f n <*> mapx f e1 <*> mapx f e2
      | K.LETX (n, e1, e2) => curry3 K.LETX <$> f n <*> mapx f e1 <*> mapx f e2
      | K.BEGIN (e, e') => curry K.BEGIN <$> mapx f e <*> mapx f e'
      | K.SET (n, e) => curry K.SET <$> f n <*> mapx f e 
      | K.WHILEX (n, e, e') => curry3 K.WHILEX <$> f n <*> mapx f e 
                                                                  <*> mapx f e'
      | K.FUNCODE (ns, e) => curry K.FUNCODE <$> errorList (map f ns) 
                                                                  <*> mapx f e
      | K.CAPTURED i => succeed (K.CAPTURED i)
      | K.CLOSURE ae => K.CLOSURE <$> clRename f ae)
    and clRename f ((formals, body), captured) = 
      curryClBody <$> Error.mapList f formals <*> mapx f body <*> Error.mapList f captured
(* TODO- fix this. Thanks matt! *)

end
