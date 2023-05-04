(* This is the universal forward translator. As you build the different VScheme 
    representations and the translations between them, you'll chain together 
    these translations here. It implements the actual translations *)

(* You'll get a partially complete version of this file, 
    which you'll need to complete *)

structure UFT :> sig
  type language = Languages.language
  exception NotForward of language * language
  val translate : language * language -> TextIO.instream * TextIO.outstream -> unit Error.error
end
  =
struct

  (**** I/O functions and types ****)

  type instream = TextIO.instream
  val lines  = IOUtil.lines : instream -> string list
  val output = IOUtil.output 
  val outln  = IOUtil.outln


  (**** function composition, including errors ****)

  type 'a error = 'a Error.error

  infix 0 >>> >=>
  fun f >>> g = fn x => g (f x)         (* function composition, Elm style *)
  val op >=> = Error.>=>

  fun liftMap f xs = Error.list (map f xs)  (* liftMap f == map f >>> Error.list *)


  (**** Reader functions ****)

  fun sourceReader defParser =
    lines                             (* line list *)
    >>>  SxParse.parse                (* sx list error *)
    >=>  Error.mapList defParser      (* def list list error *)
    >>>  Error.map List.concat        (* def list error *)
    >>>  Error.map VSchemeTests.delay

  val schemeOfFile : instream -> VScheme.def list error =
    sourceReader VSchemeParsers.defs
    
  val schemexOfFile : instream -> UnambiguousVScheme.def list error =
    schemeOfFile >>>
    Error.map (map Disambiguate.disambiguate)

  val eschemeOfFile : instream -> VScheme.def list error =
    sourceReader EschemeParsers.defs

  val eschemexOfFile : instream -> UnambiguousVScheme.def list error =
    eschemeOfFile >>>
    Error.map (map Disambiguate.disambiguate)


  val VS_of_file : instream -> AssemblyCode.instr list error =
    lines                    (* line list *)
    >>> map AsmLex.tokenize  (* token list error list *)
    >>> Error.list           (* token list list error *)
    >=> AsmParse.parse       (* instr list error *)    


  val KN_of_file: instream -> string KNormalForm.exp list error =
    schemexOfFile >=> Error.mapList KNProject.def

  val FO_of_file: instream -> FirstOrderScheme.def list error =
    schemexOfFile >=> Error.mapList FOUtil.project

  (* val AN_of_file: instream -> string ANormalForm.exp list error =
    schemexOfFile >=> Error.mapList ANProject.def *)

  (**** Support for materialization ****)
  
  exception Backward  (* for internal use only *)
                      (* raised if someone commands a backward translation *)

  datatype language = datatype Languages.language (* imports value constructors *)
  exception NoTranslationTo of language  (* used internally *)

  val ! = Error.map  (* useful abbreviation for materializers and `translate` *)

  (**** Materializer functions ****)
  
  fun HOX_of HOX  = schemexOfFile
    | HOX_of _    = raise Backward

  infixr 0 $ 
  fun f $ g = f g

  val VS_of_KN : ObjectCode.reg KNormalForm.exp list ->
               AssemblyCode.instr list
    = List.map Codegen.forEffectK (* AssemblyCode.instr list list*)
    >>> List.concat              (* AssemblyCode.instr list *)

  (* val VS_of_AN : ObjectCode.reg ANormalForm.exp list ->
               AssemblyCode.instr list
    = List.map Codegen.forEffectA (* AssemblyCode.instr list list*)
    >>> List.concat              AssemblyCode.instr list *)

  val namesOfRegs = Error.mapList (KNRename.mapx KNRename.nameOfReg)

  val anUpAndDown = (List.map ANormalize.def) 
                      >>> (List.map ANEmbed.def) 
                      >>> namesOfRegs

  fun HO_of HO   = schemexOfFile >=> Error.mapList Mutability.detect
    | HO_of HOX  = Impossible.unimp "imperative features (HOX to HO)"
    | HO_of _    = raise Backward

  fun FO_of FO = FO_of_file
    | FO_of _  = raise Backward

  fun ES_of ES   = eschemexOfFile 
    | ES_of _    = raise Backward

  fun CL_of CL     = CL_of FO   (* really *)
    | CL_of HO     = HO_of HO     >>> ! (map ClosureConvert.close)
    | CL_of HOX    = HO_of HOX    >>> ! (map ClosureConvert.close)
    | CL_of ES     = ES_of ES     >>> ! (map ClosureConvert.close)
    | CL_of inLang = FO_of inLang >>> ! (map FOCLUtil.embed)


  fun KN_reg_of KN = KN_of_file 
                     >=> Error.mapList (KNRename.mapx KNRename.regOfName)
    | KN_reg_of inLang = CL_of inLang
                     >>> ! (List.map KNormalize.def)

  fun AN_reg_of inLang = CL_of inLang >>> ! (List.map ANormalize.def)


  fun KN_of KN = KN_of_file
    | KN_of FO = KN_reg_of FO >=> Error.mapList (KNRename.mapx KNRename.nameOfReg)
    | KN_of CL = CL_of CL >>> ! (List.map KNormalize.def) >=> namesOfRegs
    | KN_of HO = CL_of HO >>> ! (List.map KNormalize.def) >=> namesOfRegs
    | KN_of ES = CL_of ES >>> ! (List.map KNormalize.def) >=> namesOfRegs
    | KN_of inLang = raise NoTranslationTo inLang

fun AN_of CL = CL_of CL >=> anUpAndDown
  | AN_of HO = CL_of HO >=> anUpAndDown
  | AN_of ES = CL_of ES >=> anUpAndDown
  | AN_of inLang = raise NoTranslationTo AN

  fun VS_of VS   = VS_of_file
    (* | VS_of AN = AN_reg_of AN >>> ! VS_of_AN *)
    | VS_of inLang = KN_reg_of inLang >>> ! VS_of_KN
                                  (* unwrap KN_reg_of inLang result 
                                  (error type), apply VS_of_KN to internals,
                                  and rewrap. *)
  fun VO_of VO     = (fn _ => Error.ERROR "There is no reader for .vo")
    | VO_of inLang = VS_of inLang >=> Assembler.translate


  (**** Emitter functions ****)

  val width =  (* parameter to prettyprinter *)
    case Option.mapPartial Int.fromString (OS.Process.getEnv "WIDTH")
      of SOME n => n
       | NONE => 72

  fun emitVO outfile = app (outln outfile) o ObjectUnparser.module
  fun emitVS outfile = app (outln outfile) o AsmParse.unparse

  fun emitScheme outfile = Wppx.toOutStream width outfile o WppScheme.pp

  fun emitHO outfile = app (emitScheme outfile o Disambiguate.ambiguate)

  fun emitFO outfile = app (emitScheme outfile o FOUtil.embed)
  
  fun emitCL outfile = app (emitScheme outfile o CSUtil.embed)

  fun emitKN outfile = app (emitScheme outfile o KNEmbed.def)
  
  (* fun emitAN outfile = app (emitScheme outfile o KNEmbed.def o ANEmbed.def) *)

  (**** The Universal Forward Translator ****)

  exception NotForward of language * language  (* for external consumption *)

  fun translate (inLang, outLang) (infile, outfile) =
    (case outLang
       of VO => VO_of      inLang >>> ! (emitVO outfile)
        | VS => VS_of      inLang >>> ! (emitVS outfile)
        | KN => KN_of      inLang >>> ! (emitKN outfile)
        | AN => AN_of      inLang >>> ! (emitKN outfile)
        | FO => FO_of      inLang >>> ! (emitFO outfile)
        | CL => CL_of      inLang >>> ! (emitCL outfile)
        | HO => HO_of      inLang >>> ! (emitHO outfile)
        | ES => ES_of      inLang >>> ! (emitHO outfile)
        | HOX => HOX_of    inLang >>> ! (emitHO outfile)
    ) infile
    handle Backward => raise NotForward (inLang, outLang)
         | NoTranslationTo outLang => raise NotForward (inLang, outLang)
end
