(* FOR USE IN LAB ONLY.  IF YOU COPY DATATYPE DEFINITIONS, YOU LOSE *)


fun curry f x y = f(x, y)


functor Lab03 (datatype loader_token = TU32 of int | TNAME of string | TDOUBLE of real
               datatype 'a error = OK of 'a | ERROR of string
               datatype value = NUM of real
                              | BOOL of bool
                              | NIL
                              | EMPTYLIST
                              | STRING of string

               type input = loader_token
               type 'a producer = input list -> ('a error * input list) option

               type reg = int
               val reg    : reg producer             (* parses a register number *)
               val int    : int producer             (* parses an integer literal *)
               val string : string producer          (* parses a string literal *)
               val name   : string producer          (* parses a name *)
               val the    : string -> unit producer  (* one token, like a comma or bracket *)

               type opcode = string
               type instr (* instruction *)
               val eR0 : opcode -> instr
               val eR1 : opcode -> reg -> instr
               val eR2 : opcode -> reg -> reg -> instr
               val eR3 : opcode -> reg -> reg -> reg -> instr
              )
  : sig
      type input = loader_token
      type 'a producer = input list -> ('a error * input list) option
      val int  : int producer
      val name : string producer
      val eos : unit producer   (* recognizes end of stream *)
      val one : input producer  (* takes one input token, if present *)
      val succeed : 'a -> 'a producer
      val <*> : ('a -> 'b) producer * 'a producer -> 'b producer
      val <$> : ('a -> 'b) * 'a producer -> 'b producer
      val <|> : 'a producer * 'a producer -> 'a producer
      val sat : ('a -> bool) -> 'a producer -> 'a producer
(*
      val maybe : ('a -> 'b option) -> 'a producer -> 'b producer
*)
      val optional : 'a producer -> 'a option producer  (* zero or one *)    
      val many  : 'a producer -> 'a list producer
      val many1 : 'a producer -> 'a list producer
      val count : int -> 'a producer -> 'a list producer (* exactly N *)
      val <~> : 'a producer * 'b producer -> 'a producer
      val >>  : 'a producer * 'b producer -> 'b producer

      type instr
      val step8 : instr producer

    end
 =
struct
  exception DefineThisOrJustWriteTheLaws
  exception DefineThis
  type input = loader_token
  type 'a producer = input list -> ('a error * input list) option
  type instr = instr

  fun int (TU32 n :: tokens) = SOME (OK n, tokens)
    | int _                  = NONE

  fun name (TNAME x :: tokens) = SOME (OK x, tokens)
    | name _                   = NONE

  fun eos []       = SOME (OK (), [])
    | eos (_ :: _) = NONE

  fun one [] = NONE
    | one (y :: ys) = SOME (OK y, ys)

  fun succeed a = (fn ts => SOME (OK a, ts))

  infix 3 <*>
  fun tx_f <*> tx_b =  (* uglier than its laws *)
    fn xs => case tx_f xs
               of NONE => NONE
                | SOME (ERROR msg, xs) => SOME (ERROR msg, xs)
                | SOME (OK f, xs) =>
                    case tx_b xs
                      of NONE => NONE
                       | SOME (ERROR msg, xs) => SOME (ERROR msg, xs)
                       | SOME (OK y, xs) => SOME (OK (f y), xs)

  infixr 4 <$>
  fun f <$> p = succeed f <*> p

  (* LAB, step 6 *)

  infix 2 <|>

  fun p1 <|> p2 = 
      fn xs => case p1 xs
               of NONE => p2 xs
                | SOME (ERROR msg, xs) => SOME (ERROR msg, xs)
                | SOME (OK f, xs) => SOME (OK f, xs)

  (* fun p1 <|> p2 = 
    fn xs => case p1 xs
            of NONE => p2
            | (SOME(ERROR msg, xs)) => (SOME (ERROR msg, xs))
            | (SOME(OK f, xs))      => (SOME(OK f, xs)) *)


  (* step 6 bonus: *)

    fun sat f p ts = 
              case p ts 
               of NONE => NONE
                | (SOME (ERROR msg, xs)) => (SOME (ERROR msg, xs))
                | (SOME (OK a, xs))      => if f a then SOME(OK a, xs) else NONE

  (* fun sat f NONE              = NONE
    | sat f (SOME(ERROR msg, ts)) = SOME (ERROR msg, ts)
    | sat f (SOME(OK a, ts))  = if f a then SOME(OK a, ts) else NONE *)

  (* LAB, step 7 *)

  (* optional p == SOME <$> p <|> succeed NONE *)

  (* optional p == succeed with NONE, if p fails
     optional p == ERROR, if p produces an ERROR
     optional p == succeed with SOME a, if p finds valid input and produces a *)

  (* many p == curry op :: <$> p <*> (many p) <|> succeed [] *)
  (* many1 p == curry op :: <$> p <*> (many1 p) <|> p *)

  (* count 0     p == succeed [] *)
  (* count (n+1) p ==  curry op :: <$> p <*> count n p *)

  (* p <~> q ==  *)
  (* p >> q ==  *)



  fun optional p = SOME <$> p <|> succeed NONE

  fun many p = curry op :: <$> p <*> (many p) <|> succeed []

  fun many1 p = 
            curry op :: <$> p <*> (many1 p) <|> curry op :: <$> p <*> succeed []

  (* step 7 bonus (either `count` or the other two): *)

  fun count 0 p = succeed []
    | count n p = curry op :: <$> p <*> count (n-1) p

  infix 6 <~> >>

  fun p <~> q = raise DefineThisOrJustWriteTheLaws
  fun p  >> q = raise DefineThisOrJustWriteTheLaws

  (* step 8 *)
  val step8 : instr producer = raise DefineThis

end
