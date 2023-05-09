(* This is the universal forward translator. As you build the different VScheme 
    representations and the translations between them, you'll chain together 
    these translations here. It implements the actual translations *)

(* You'll get a partially complete version of this file, 
    which you'll need to complete *)

structure UFTList :> sig
  type language = Languages.language
  exception NotForward of language * language
  val translate : language list -> TextIO.instream * TextIO.outstream -> unit Error.error
    (* nonempty, target first, source last *)
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

(*@ module >= 5 and module < 13 *)
  val schemeOfFile : instream -> VScheme.def list error =
    lines                                   (* line list *)
    >>>  SxParse.parse                      (* sx list error *)
    >=>  Error.mapList VSchemeParsers.defs  (* def list list error *)
    >>>  Error.map List.concat              (* def list error *)
    >>>  Error.map VSchemeTests.delay
    
  val schemexOfFile : instream -> UnambiguousVScheme.def list error =
    schemeOfFile >>>
    Error.map (map Disambiguate.disambiguate)

(*@ module >= 13 *)
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


(*@ false *)
  val FO_of_file : instream -> FirstOrderScheme.def list error =
    schemexOfFile >=> Error.mapList FOUtil.project

  val KN_of_file  : instream -> string KNormalForm.exp list error =
    schemexOfFile  (* def list *)
    >=>
    Error.mapList KNProject.def

(*@ true *)
  val VS_of_file : instream -> AssemblyCode.instr list error =
    lines                    (* line list *)
    >>> map AsmLex.tokenize  (* token list error list *)
    >>> Error.list           (* token list list error *)
    >=> AsmParse.parse       (* instr list error *)    


  (**** Support for materialization ****)
  
  datatype language = datatype Languages.language (* imports value constructors *)
  exception Unreachable of language  (* used internally *)
  exception NotForward of language * language  (* for external consumption *)
    (* XXX error message is no good now: fo-vs-kn *)

  fun request lang f path =
        f path handle Unreachable l2 => raise NotForward (l2, lang)

  val ! = Error.map  (* useful abbreviation for materializers and `translate` *)

  fun idWarning tx a = ( app IOUtil.eprint
                             ["UFT warning: Translation ", tx, " is the identity function\n"]
                       ; a
                       )

  (**** Materializer functions ****)
  
(*@ false *)
    (* ===> I need some bread crumbs for the conditional compilation below <=== *)
(*@ module >= 10 *)
  fun HOX_of []      = schemexOfFile
    | HOX_of [HOX]   = schemexOfFile
    | HOX_of (HOX::inputs) = idWarning "hox-hox" HOX_of inputs
    | HOX_of (la::_) = raise NotForward (la, HOX)

(*@ module >= 5 and module < 10 *)
(*
  fun HO_of HO   = schemexOfFile
    | HO_of HOX  = Impossible.unimp "imperative features (HOX to HO)"
    | HO_of _    = raise Backward
*)

(*@ module >= 10 *)
(*
  fun HO_of HO   = schemexOfFile >=> Error.mapList Mutability.detect
    | HO_of HOX  = Impossible.unimp "imperative features (HOX to HO)"
    | HO_of _    = raise Backward
*)

(*@ false *)
  fun HO_of (HOX :: inputs) = request HOX HOX_of inputs >>> ! (map Mutability.moveToHeap)
    | HO_of []     = schemexOfFile >=> Error.mapList Mutability.detect
    | HO_of [HO]   = HO_of []
    | HO_of (HO::inputs) = idWarning "ho-ho" HO_of inputs
    | HO_of (l::_) = raise Unreachable l

  fun FO_of []     = FO_of_file
    | FO_of [FO]   = FO_of []
    | FO_of (inLang::_) = raise Unreachable inLang

(*@ module >= 13 *)
  fun ES_of []     = eschemexOfFile 
    | ES_of [ES]   = ES_of []
    | ES_of (la::_) = raise Unreachable la
(*@ module >= 10 *)
  fun CL_of (CL  :: ins) = CL_of (FO :: ins)   (* really *)
    | CL_of (ES  :: ins) = request ES  ES_of ins >>> ! (map ClosureConvert.close)
    | CL_of []           = FO_of []     >>> ! (map FOCLUtil.embed)
    | CL_of inputs       = HO_of inputs >>> ! (map ClosureConvert.close)
(*
    | CL_of 
    | CL_of (HO  :: ins) = request HO  HO_of  (ins)     >>> ! (map ClosureConvert.close)
    | CL_of (HOX :: ins) = request HOX HOX_of (ins)     >>> ! (map ClosureConvert.close)
    | CL_of (FO  :: ins) = request FO
                           FO_of ins    >>> ! (map FOCLUtil.embed)
    | CL_of inputs       = FO_of inputs >>> ! (map FOCLUtil.embed)
*)

(*@ false *)
  fun KN_reg_of []             = KN_of_file >=> Error.mapList (KNRename.mapx KNRename.regOfName)
    | KN_reg_of (CL :: inputs) = request CL CL_of inputs >>> ! (map KNormalize.def)
    | KN_reg_of inputs         = CL_of inputs >>> ! (map KNormalize.def)

  fun KN_text_of []     = KN_of_file
    | KN_text_of [KN]   = KN_of_file
    | KN_text_of inputs = KN_reg_of inputs >=>
                          Error.mapList (KNRename.mapx (Error.OK o KNormalize.regname))

  val VS_of_KN : ObjectCode.reg KNormalForm.exp list -> AssemblyCode.instr list error
   = map Codegen.forEffect >>> List.concat >>> Error.OK

  val KN_reg_of_KN : string KNormalForm.exp list -> 
                     ObjectCode.reg KNormalForm.exp list error
   = Error.mapList (KNRename.mapx KNRename.regOfName)

(*
  fun KN_reg_of (KN :: ins) = request KN KN_text_of ins >=> KN_reg_of_KN
    | KN_reg_of inputs = CL_of inputs >>> ! (map KNormalize.def)
*)

(*@ true *)
  fun VS_of []   = VS_of_file
    | VS_of (VS :: ins)   = request VS VS_of ins
(*@ true
    | VS_of inputs = raise NoTranslationTo VS
**@ false *)
    | VS_of inputs = KN_reg_of inputs >=> VS_of_KN 
(* >>> !(map Codegen.forEffect >>> List.concat) *)

(*@ true *)

  fun VO_of []     = (fn _ => Error.ERROR "There is no reader for .vo")
    | VO_of (VO :: ins) = request VO VO_of ins
    | VO_of inLang = VS_of inLang >=> Assembler.translate

  fun CA_of (ES :: ins) = request ES ES_of ins >>> Error.map (map CaseElim.compile)
    | CA_of [] = Impossible.unimp "projection into CA not implemented"
    | CA_of (CA :: ins) = idWarning "ca-ca" CA_of ins
    | CA_of (la :: _) = raise Unreachable la

(*@ false *)
  (* N.B. STUDENTS ARE NOT GOING TO NEED THIS EMBEDDING BULLSHIT *)
  fun embedding (HOX :: _) = KNEmbed.def KNEmbed.SCHEME_LIST
    | embedding (HO :: _)  = KNEmbed.def KNEmbed.SCHEME_LIST
    | embedding _          = KNEmbed.def KNEmbed.SCHEME_FUN
(*@ true *)  

  (**** Emitter functions ****)

(*@ module >= 5 *)
  val width =  (* parameter to prettyprinter *)
    case Option.mapPartial Int.fromString (OS.Process.getEnv "WIDTH")
      of SOME n => n
       | NONE => 72

(*@ true *)
  fun emitVO outfile = app (outln outfile) o ObjectUnparser.module
  fun emitVS outfile = app (outln outfile) o AsmParse.unparse

(*@ module >= 5 *)
  fun emitScheme outfile = Wppx.toOutStream width outfile o WppScheme.pp

(*@ false *)
  fun emitKN embed outfile = app (emitScheme outfile o embed)
  fun emitCL outfile = app (emitScheme outfile o CSUtil.embed)
  fun emitFO outfile = app (emitScheme outfile o FOUtil.embed)
(*@ module >= 5 *)
  fun emitHO outfile = app (emitScheme outfile o Disambiguate.ambiguate)

(*@ module >= 3 *)

  fun emitCA outfile = app (emitScheme outfile o CaUtil.embed)


  (**** The Universal Forward Translator ****)


  fun translate [] _ = Impossible.impossible "contract violation: translate"
    | translate (outLang :: inLangs) (infile, outfile) =
    (case outLang
       of VO => request VO VO_of      inLangs >>> ! (emitVO outfile)
        | VS => request VS VS_of      inLangs >>> ! (emitVS outfile)
(*@ false *)
        | KN => request KN KN_text_of inLangs >>> ! (emitKN (embedding inLangs) outfile)
        | FO => request FO FO_of      inLangs >>> ! (emitFO outfile)
        | CL => request CL CL_of      inLangs >>> ! (emitCL outfile)
(*@ module >= 5 *)
        | HO => request HO HO_of      inLangs >>> ! (emitHO outfile)
(*@ false *)
        | HOX =>request HOX HOX_of    inLangs >>> ! (emitHO outfile)
(*@ module >= 13 *)
        | CA => request CA CA_of      inLangs >>> ! (emitCA outfile)
        | ES => request ES ES_of      inLangs >>> ! (emitHO outfile)
(*@ module >= 3
        | _  => raise NoTranslationTo outLang
**@ module >= 3 *)
    ) infile
(*@ true *)
end
