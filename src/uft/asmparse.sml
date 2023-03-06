(* A parser for assembly language *)

(* You'll get a partially complete version of this file, 
  which you'll need to complete. *)

structure AsmParse :>
  sig
    type line = string (* one line of assembly code *)
    val parse   : AsmLex.token list  list -> AssemblyCode.instr list Error.error
    val unparse : AssemblyCode.instr list -> line list
  end
  =
struct
  (* visualize list of tokens using Unicode middle dot as separator *)
  fun showTokens ts = "[" ^ String.concatWith "\194\183" (map AsmLex.unparse ts) ^ "]"

  structure P = MkListProducer (val species = "parser"
                                type input = AsmLex.token
                                val show = showTokens
                               )
      (* P for parser; builds a module that takes AsmLex.token as input *)

  structure L = AsmLex
  structure A = AssemblyCode
  structure O = ObjectCode

  type line = string (* one line of assembly code *)

  (* Operations on producers: Wishing for Modula-style FROM IMPORT here ... *)
  infix 3 <*>      val op <*> = P.<*>
  infixr 4 <$>     val op <$> = P.<$>
  infix 3 <~>      val op <~> = P.<~>
  infix 1 <|>      val op <|> = P.<|>
  infix 3 >>       val op >> = P.>>

  infixr 0 $         fun f $ g = f o g

  val succeed = P.succeed
  val curry = P.curry
  val curry3 = P.curry3
  val id = P.id
  val fst = P.fst
  val snd = P.snd
  val optional = P.optional
  val many = P.many
  val many1 = P.many1
  val sat = P.sat
  val one = P.one
  val notFollowedBy = P.notFollowedBy
  val eos = P.eos
  fun flip f x y = f y x

  (* utilities *)

  fun eprint s = TextIO.output (TextIO.stdErr, s)

  type 'a parser = 'a P.producer

  (* always-error parser; useful for messages *)
  fun expected what =
    let fun bads ts = Error.ERROR ("looking for " ^ what ^
                                   ", got this input: " ^ showTokens ts)
    in  P.check ( bads <$> many one )
    end

  (* always-succeed parser; prints msg when run *)
  fun debug msg =
      P.ofFunction (fn ts => (app eprint ["@> ", msg, "\n"]; SOME (Error.OK (), ts)))

  (* make another parser chatter on entry *)
  val verbose : string -> 'a parser -> 'a parser
   = (fn msg => fn p => debug msg >> p)

  val veryVerbose : string -> 'a parser -> 'a parser
      = (fn what => fn p =>
           let fun shout s = app eprint ["looking for ", what, s, "\n"]
           in  P.ofFunction (fn ts =>
                                let val _ = shout "..."
                                    val answer = P.asFunction p ts
                                    val _ =
                                        case answer
                                          of NONE => shout ": failed"
                                           | SOME (Error.ERROR _, _) => shout ": errored"
                                           | SOME (Error.OK _, _) => shout ": succeeded"
                                in  answer
                                end)
           end)

  (****************************************************************************)

  (**** parsers for common tokens ****)

      (* These are your workhorse parsers---the analog of the `get`
         functions from the `tokens.h` interface in the SVM *)

  val int       = P.maybe (fn (L.INT   n)    => SOME n  | _ => NONE) one
  val name      = P.maybe (fn (L.NAME  n)    => SOME n  | _ => NONE) one
  val string    = P.maybe (fn (L.STRING s)   => SOME s  | _ => NONE) one
  val reg       = P.maybe (fn (L.REGISTER n) => SOME n  | _ => NONE) one
  
  val string' : O.literal parser = O.STRING <$> string
  val name' : O.literal parser = O.STRING <$> name

  fun token t = sat (P.eq t) one >> succeed () (* parse any token *)
  val eol = token L.EOL

  fun lit_of_token l = 
    case l of L.INT n => SOME (O.INT n)
            | L.NAME "true" => SOME (O.BOOL true)
            | L.NAME "#t" => SOME (O.BOOL true)
            | L.NAME "false" => SOME (O.BOOL false)
            | L.NAME "#f" => SOME (O.BOOL false)
            | L.NAME "emptylist" => SOME (O.EMPTYLIST)
            | L.NAME "nil" => SOME (O.NIL)
            | L.STRING s => SOME (O.STRING s)
            | _ => NONE

  val literal = P.maybe lit_of_token one

  (* turn any single-token string into a parser for that token *)
  fun the "\n" = eol
    | the s =
        case AsmLex.tokenize s
          of Error.OK [t, AsmLex.EOL] => sat (P.eq t) one >> succeed ()
           | _ => (app eprint ["fail: `", s, "`\n"]; Impossible.impossible "non-token in assembler parser")
  (* val the = many1 the *)



  (***** instruction-building functions for parsers ****)

  fun regs operator operands = A.OBJECT_CODE (O.REGS (operator, operands))
     (* curried instruction builder *)
  fun regslit operator regs lit = A.OBJECT_CODE (O.REGSLIT (operator, regs, lit))

(* follow-ups: switch arguments, and labeler needing a string *)

  fun labeler operator label = A.DEFLABEL label
  fun gotoer operator label  = A.GOTO_LABEL label
  fun ifgotoer operator r1 label  = A.IF_GOTO_LABEL (r1, label)

  fun eR0 operator          = regs operator []
  fun eR1 operator r1       = regs operator [r1]
  fun eR2 operator r1 r2    = regs operator [r1, r2]
  fun eR3 operator r1 r2 r3 = regs operator [r1, r2, r3]

  fun eRMany operator r1 rs = regs operator ([r1] @ rs)

  (*Dirty trick : parsing call with accounting for the missing argument *)
  fun eRCall operator r1 r2 rs = 
    let val regargs = if rs = nil then [r1, r2, r2] else [r1, r2] @ rs
    in regs operator regargs
    end
  

  fun eRL operator r1 lit   = regslit operator [r1] lit
  fun eLR operator lit r1   = eRL operator r1 lit


  (***** Example parser for you to extend *****)

  (* The example parser includes "passthrough" syntax and three
     demonstration instructions:

        - Add two registers, put result in a third

        - Add a small immediate constaint to a register,
          or subtract a small immediate constant from a register,
          put result in a third.

        - Swap the contents of two registers.

     The latter two demonstrations show some more sophisticated
     parsing techniques.
   *)
                      

  (* Swap uses standard multiple-assignment syntax:  $r9, $r33 := $r33, $r9
     Helper function `swap` ensures that register numbers't match.
   *)
  fun swap r1 r2 r3 r4 =
    if r1 = r4 andalso r2 = r3 then
        Error.OK (eR2 "swap" r1 r2)
    else
        Error.ERROR "multiple assignment is allowed only for register swaps"

  (* The add-immediate instruction uses "offset coding": a byte
     in the range 0..255 is converted to signed by subtracting 128.
   *)
  val offset_code : int -> int Error.error =
    fn n => if n >= ~128 andalso n < 128 then Error.OK (n + 128)
            else Error.ERROR ("small integer " ^ Int.toString n ^
                              " out of range -128..127")

  (* To use offset coding, I define a version of <$> that checks for errors *)
  infixr 4 <$>!
  fun f <$>! p = P.check (f <$> p)

  exception TypeCheat 
  (* Example parser: reads an instruction /without/ reading end of line *)
    fun list nil     = succeed nil 
      | list (p::ps) = curry op :: <$> p <*> list ps


    val _ = list : 'a parser list -> 'a list parser

  val _ = succeed : 'a -> 'a parser
    

  (* these help make the code more legible, I think. *)
  fun oneParser    name = eR1 name <$> (the name >> reg) : A.instr parser
  fun binopParser  name = eR3 name <$> reg <~> the ":=" <*> reg <~> the name <*> reg
  fun unopParser   name = eR2 name <$> reg <~> the ":=" <~> the name <*> reg

  fun parseOps psr []      = P.pzero
    | parseOps psr (x::xs) = psr x <|> parseOps psr xs

  val binops = ["+", "-", "*", "/", "//", "mod", "cons", "<", ">", "="]
  val unops = ["boolOf", "function?", "pair?", "symbol?", "number?", "boolean?", 
                "null?", "nil?", "car", "cdr", "hash"]
  val oneops = ["print", "println", "printu", "error", 
                "inc", "dec", "neg", "not"]

  (* val parseBinops = parseOps binopParser *)

  val one_line_instr : A.instr parser
     =  the "@" >> regs <$> name <*> many int  (* "passthrough" syntax *)
    <|> eR3 "+imm" <$> reg <~> the ":=" <*> reg <~> the "+" <*> (offset_code <$>! int)
    <|> eR3 "+imm" <$> reg <~> the ":=" <*>
                       reg <~> the "-" <*> ((offset_code o ~) <$>! int)
                                           (* the ~ is ML's unary minus (negation) *)
    <|> P.check
        (swap <$> reg <~> the "," <*> reg <~> the ":=" <*> reg <~> the "," <*> reg)
        
    <|> parseOps binopParser binops

    <|> parseOps oneParser oneops

    <|> eRL "getglobal" <$> reg <~> the ":=" <~> the "_G" <~> the "[" <*> string' <~> the "]"
    <|> eRL "getglobal"  <$> reg <~> the ":=" <~> the "global" <*> name'


    <|> eLR "setglobal"  <$> (the "_G" >> the "[" >> string') <~> the "]" <~> the ":=" <*> reg
    <|> eLR "setglobal" <$> (the "global" >> name') <~> the ":=" <*> reg

    <|> eLR "check" <$> (the "check" >> string') <~> optional (the ",") <*> reg
    <|> eLR "expect" <$> (the "expect" >> string') <~> optional (the ",") <*> reg
                            
    <|> eRL "loadliteral" <$> reg <~> the ":=" <*> literal
    <|> succeed (eR0 "halt") <~> the "halt"
    <|> labeler "deflabel" <$> (the "deflabel" >> string)
    <|> labeler "deflabel" <$> name <~> the ":"
    <|> gotoer "goto" <$> (the "goto" >> name)
    <|> gotoer "goto" <$> (the "goto" >> string)
    <|> ifgotoer "if-goto" <$> (the "if" >> reg) <*> (the "goto" >> name)
    <|> ifgotoer "if-goto" <$> (the "if" >> reg) <*> (the "goto" >> string)
    
    <|> parseOps unopParser unops

    <|> eR2 "copy" <$> reg <~> the ":=" <*> reg

    <|> eRCall "call" <$> reg <~> the ":=" <~> the "call" <*> reg <~> the "(" <*> many reg <~> the ")" (* TODO AS THIS HAS TO BE BETTER *)
    <|> eR1 "return" <$> (the "return" >> reg)
    <|> eRMany "tailcall" <$> (the "tailcall" >> reg) <~> the "(" <*> many reg <~> the ")" (* TODO AS THIS HAS TO BE BETTER *)

   fun commaSep p = curry (op ::) <$> p <*> many (the "," >> p) <|> succeed []
  (* `commaSep p` returns a parser that parser a sequence
      of zero or more p's separated by commas *)
    


   (**** recursive parser that handles end-of-line and function loading ****)

   (* Parsers for start and end of "load function", for you to write.
      Designing syntax so each one terminates with `eol` is recommended. *)

   fun loadfunc (reg, arity) body = A.LOADFUNC (reg, arity, body)
   val loadfunStart : (int * int) parser = 
      P.pair <$> reg <~> the ":=" <~> the "function" 
        <~> the "(" <*> int <~> the "arguments" <~> the ")" 
        <~> the "{" <~> eol (* TODO THIS CAN BE BETTER *)
   val loadfunEnd : unit parser = the "}" <~> eol

   (* grammar :   <instruction> ::= <one_line_instruction> EOL
                                 | <loadfunStart> {<instruction>} <loadfunEnd> *)

   (* simple parser with no error detection *)
   val instruction : A.instr Error.error parser
     = Error.OK <$>
       P.fix (fn instruction : A.instr parser =>
                   one_line_instr <~> many1 eol
               <|> loadfunc <$> loadfunStart <*> many instruction <~> loadfunEnd)

   (* A better parser is juiced up with extra error detection *)

   fun badTokens ts = Error.ERROR ("unrecognized assembly line: " ^ showTokens ts)
   val nonEOL = sat (curry op <> L.EOL) one  (* any token except EOL *)

   val instruction : A.instr Error.error parser
     = P.fix
       (fn instruction : A.instr Error.error parser =>
              Error.OK <$> one_line_instr <~> many1 eol
          <|> Error.OK <$>
              (loadfunc <$> loadfunStart <*> 
                            P.check (Error.list <$> many instruction) <~>
                            loadfunEnd)
          <|> P.notFollowedBy loadfunEnd >>
              (* gobble to end of line, then succeed by producing error message: *)
              badTokens <$> many nonEOL <~> eol  
       )


  val parse = Error.join o P.produce (Error.list <$> (many eol >> many instruction)) o List.concat
            

  (*************************** unparsing *****************************)

  val int = Int.toString
  fun reg r = "r" ^ int r
  val spaceSep = String.concatWith " "

  fun stringify s = "\034" ^ s ^ "\034"

  fun unparse_lit (O.INT n)  = int n
    | unparse_lit (O.REAL r) = Real.toString r
    | unparse_lit (O.STRING s) = stringify s
    | unparse_lit (O.BOOL true) = "#t"
    | unparse_lit (O.BOOL false) = "#f"
    | unparse_lit O.EMPTYLIST = "'()"
    | unparse_lit O.NIL = "nil"

(* factor out binops/unops if you can. also factor out object code wrapper *)

  fun unparse1 (A.OBJECT_CODE (rs)) =
      (case rs 
        of (O.REGS (opAndRegs)) =>
          (case opAndRegs 
            of ("+", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "+", reg z]
            | ("-", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "-", reg z]
            | ("*", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "*", reg z]
            | ("/", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "/", reg z]
            | ("//", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "//", reg z]
            | ("mod", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "mod", reg z]
            | ("inc", [x]) =>
              spaceSep ["inc", reg x]
            | ("dec", [x]) =>
              spaceSep ["dec", reg x]
            | ("neg", [x]) =>
              spaceSep ["neg", reg x]
            | ("not", [x]) =>
              spaceSep ["not", reg x]
            | ("cons", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "cons", reg z]   
            | ("=", [x, y, z]) =>
              spaceSep [reg x, ":=", reg y, "=", reg z]   
            | ("hash", [x, y]) =>
              spaceSep [reg x, ":=", "hash", reg y] 
            | ("function?", [x, y]) => 
              spaceSep [reg x, ":=", "function?", reg y]
            | ("cdr", [x, y]) => 
              spaceSep [reg x, ":=", "cdr", reg y]
            | ("pair?", [x, y]) => 
              spaceSep [reg x, ":=", "pair?", reg y]
            | ("car", [x, y]) => 
              spaceSep [reg x, ":=", "car", reg y]
            | (">", [x, y, z]) => 
              spaceSep [reg x, ":=", reg y, ">", reg z]
            | ("<", [x, y, z]) => 
              spaceSep [reg x, ":=", reg y, "<", reg z]
            | ("symbol?", [x, y]) => 
              spaceSep [reg x, ":=", "symbol?", reg y]
            | ("cons", [x, y]) => 
              spaceSep [reg x, ":=", "cons", reg y]
            | ("number?", [x, y]) => 
              spaceSep [reg x, ":=", "number?", reg y]
            | ("boolean?", [x, y]) => 
              spaceSep [reg x, ":=", "boolean?", reg y]
            | ("null?", [x, y]) => 
              spaceSep [reg x, ":=", "null?", reg y]
            | ("nil?", [x, y]) => 
              spaceSep [reg x, ":=", "nil?", reg y]
            | ("swap", [x, y]) =>
              spaceSep [reg x, ",", reg y, ":=", reg y, ",", reg x] 
            | ("+imm", [x, y, z]) =>
                let val n = z - 128
                in  if n < 0 then
                        spaceSep [reg x, ":=", reg y, "-",  int (~n)]
                    else
                        spaceSep [reg x, ":=", reg y, "+",  int n]
                end                  
            | ("boolOf", [x, y]) =>
                spaceSep [reg x, ":=", "boolOf", reg y]
            | ("copy", [x, y]) =>
                spaceSep [reg x, ":=", reg y]
            | ("print", [x]) =>
              spaceSep ["print", reg x]
            | ("println", [x]) =>
              spaceSep ["println", reg x]
            | ("printu", [x]) =>
              spaceSep ["printu", reg x]
            | ("error", [x]) =>
              spaceSep ["error", reg x]
              (* Dirty trick: parse and unparse prettily with custom formatting *)
              (* TODO PULL TO HELPER *)
            | ("call", [x, y, z]) =>
              let val regarg = if y = z then "" else reg z
              in spaceSep ([reg x, ":=", "call", reg y, "(", regarg, ")"])
              end 
            | ("call", (x::y::zs)) =>
              spaceSep ([reg x, ":=", "call", reg y, "("] @ map reg zs @ [")"])

            | ("return", [x]) =>
              spaceSep (["return", reg x])
            | ("tailcall", [x]) =>
              spaceSep (["tailcall", reg x, "( )"])
            | ("tailcall", (x::ys)) =>
              spaceSep (["tailcall", reg x, "("] @ map reg ys @ [")"])

            | ("halt", []) => "halt"
            | _ => 
              "an unknown register-based assembly-code instruction") 
        | (O.REGSLIT (regAndLit)) =>
          (case regAndLit 
          of ("loadliteral", [x], l) =>
            spaceSep [reg x, ":=", unparse_lit l]
          | ("check", [x], l) => 
            spaceSep ["check", unparse_lit l, reg x]
          | ("expect", [x], l) => 
            spaceSep ["expect", unparse_lit l, reg x]
          | ("getglobal", [x], name) =>
            spaceSep [reg x, ":=", "_G[", unparse_lit name, "]"]
          | ("setglobal", [x], name) =>
            spaceSep ["_G[", unparse_lit name, "]", ":=", reg x]
          | _ => "an unknown register-string based assembly-code instruction")
        | _ => "an unknown assembly-code instruction")
    | unparse1 (A.DEFLABEL s) =
        s ^ ":"
    | unparse1 (A.GOTO_LABEL s) =
      spaceSep ["goto", s]
    | unparse1 (A.IF_GOTO_LABEL (x, s)) =
      spaceSep ["if", reg x, "goto", s]
    | unparse1 _ = "an unknown assembly-code instruction"

  fun unparse ((A.LOADFUNC (r, k, body))::instrs) = 
        spaceSep [reg r, ":=", "function", "(", int k, "arguments", ")", "{"] :: (List.map (curry (op ^) "\n  ") 
                            (unparse body)) @ ["}"] @ unparse instrs

    | unparse ((A.OBJECT_CODE (O.LOADFUNC (r, k, body)))::instrs) = 
                unparse (A.LOADFUNC (r, k, List.map A.OBJECT_CODE body)::instrs)
    | unparse []           = []
    | unparse (i::instrs)  = unparse1 i :: unparse instrs


  (* val unparse : AssemblyCode.instr list -> string list
    = map unparse1 *) (* not good enough in presence of LOADFUNC *)
        (* Note: When unparsed, the body of LOADFUNC should be indented *)

end
