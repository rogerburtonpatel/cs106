(* Label elimination: translate assembly code into virtual object code *)

(* You'll complete this file *)

structure Assembler :>
  sig
    val translate : AssemblyCode.instr list -> ObjectCode.instr list Error.error
      (* What can go wrong: An undefined or multiply-defined label *)
  end
  =
struct

  structure A = AssemblyCode
  structure E = Env
  structure O = ObjectCode

  type 'a error = 'a Error.error
  val (succeed, <*>, <$>, >=>) = (Error.succeed, Error.<*>, Error.<$>, Error.>=>)
  val (>>=) = Error.>>=
  infixr 4 <$>
  infix 3  <*>
  infix 2  >=>
  infix 0  >>=
  val fail = Error.ERROR

  fun curry f x y = f (x, y)
  fun curry3 f x y z = f (x, y, z)
  fun flip f x y  = f y x
  fun cons x xs = x :: xs


  (* A "translation" that cannot handle any labels.  You will define a better one *)
  fun translate instrs =
    let fun cvt (A.OBJECT_CODE instr)       = Error.OK instr
          | cvt (A.LOADFUNC (r, k, instrs)) = curry3 O.LOADFUNC r k <$> translate instrs
          | cvt _                           = Error.ERROR "assembler not implemented"
    in  Error.list (map cvt instrs)
    end
    (* this gets redefined *)

  (* In lab, define `fold`, `lift`, `labelEnv`, `labelElim`, and `translate` here *)
  val position : A.instr -> int = 
    fn i => 
    (case i of A.DEFLABEL _ => 0
             | A.IF_GOTO_LABEL _ => 2
             | _ => 1)

  (* right-fold, analogous to foldr *)
  fun fold f a instrs = 
        let fun fold_with_pos f a [] n      = a
              | fold_with_pos f a (i::is) n = 
                let val total = n + position i
                  in f (total, i, fold_with_pos f a is total)
                end
          in fold_with_pos f a instrs 0
        end

  val fail = Error.ERROR

  val _ = fold : (int * AssemblyCode.instr * 'a -> 'a) -> 'a -> AssemblyCode.instr list -> 'a

  (* fun lift g = 
    fn (a, b, c) => 
    (case c of Error.ERROR msg => c
             | (Error.OK x) => g (a, b, x)) *)

  fun lift g (a, b, Error.ERROR msg) = Error.ERROR msg
    | lift g (a, b, Error.OK c) = g (a, b, c)

   val _ = lift : ('a * 'b * 'c -> 'c error) -> ('a * 'b * 'c error -> 'c error)

  fun labelEnv is = 
    let fun g (n, A.DEFLABEL label, envir) = 
                  if (E.binds (envir, label))
                  then Error.ERROR (label ^ "already exists")
                  else Error.OK (E.bind (label, n, envir))
         |  g (_, _, envir) = Error.OK envir
        in fold (lift g) (Error.OK E.empty) is 
      end

  val _ = labelEnv : AssemblyCode.instr list -> int Env.env error

    fun mkGoto (n, envir, label, objinstrs) =
      let val ost = (E.find(label, envir) - n)
      in (curry op ::) (O.GOTO ost) <$> objinstrs
        handle (E.NotFound x) => 
                    Error.ERROR (label ^ "not defined in environment")
      end

    fun labelElim instrs envir = 
        let fun g (n, asminstr, objinstrs) =
              (case asminstr
                of (A.GOTO_LABEL label)    => mkGoto(n, envir, label, objinstrs)
                 | (A.DEFLABEL label)      => objinstrs 
                 | (A.OBJECT_CODE code)    => (curry op ::) code <$> objinstrs
                 | (A.IF_GOTO_LABEL (r, label)) => 
                    (curry op ::) (O.REGS("if", [r]))
                    <$> mkGoto(n, envir, label, objinstrs)
                 | (A.LOADFUNC (r, i, instrs))  =>
                    (case translate instrs
                      of Error.ERROR objs => Error.ERROR objs
                      |  Error.OK objs    => 
                        (curry op ::) (O.LOADFUNC (r, i, objs)) <$> objinstrs
                    )
              )
      in fold g (succeed []) instrs
      end
      and translate instrs = (labelEnv >=> labelElim instrs) instrs

    val _ = labelElim :
      AssemblyCode.instr list -> int Env.env ->
      ObjectCode.instr list Error.error


    val _ = translate : 
      AssemblyCode.instr list -> ObjectCode.instr list Error.error
      
end
