If you want a rant on the topic, ask me. re: parsing. Maybe?
- depth pts!!! 'the' and explode/implode and others

            // case InitConsCell: {
            //     struct VMBlock *vmb = vmalloc_raw(sizeof(*vmb));
            //     vmb->nslots = 0;

            // }

Depth:
Dynamic compilation and loading [2 points]. 
μScheme and vScheme both have a use syntactic form, which tells the interpreter 
to load and run code. This goal is to implement two machine instructions, one to
 call popen and read from a pipe, and one to load a list of modules from an open
  file descriptor. These two instructions can then eventually be used to call 
  the compiler and load the results. These instructions can be tested now, and 
  then by the time of module 4, they can be used to implement a use function.

set as begin
higher-order testing

idempotency test- can we acheive idempotency, when set gets floated to a begin
with a set in it?

Projection to KNF should probably reject SETGLOBAL in a value (toReg) context.

^ ask abt


knproject.sml:71


Here's the anormal spiel:

What if we have 


Base case: 
A[[let x = SIMPLE ex in ex']] = let x = ex in ex'

float case of case 

float whiles-- chapter 2 semantics! 

             1       a     b                         a              b
A[[let x = (let y = ey in ey') in ex']] = A[[let y = ey in (let x = ey' in ex')]]

todo: y can't be free in what?
            1  a b  c                                a 
A[[let x = (if e e1 e2) in ex']]        = A[[let y = e in (if y       b
                                                            (let x = e1 in ex')
                                                                      c
                                                            (let x = e2 in ex'))]]

                                                            WRONG WHILE! book todo
            1          a    b                              a
A[[let x = (while y := e in e') in ex']]  = A[[(while y := e in 
                                                    b 
                                          (let x := e' in ex'))]]

            1     a    b                        a              b
A[[let x = (begin e1; e2) in ex']]  = A[[(begin e1; (let x := e2 in ex'))]]

BUT ey' is another let? We need recursive application, but i'm not quite sure 
how to normalize yet. Can we do it without a continuation?

For the depth point that checks for let-bound variables not being free in 
enclosing lets in KNF: 

the issue is that a variable that is bound in a let may not be bound in an 
enclosing let, or even on the right-hand side of an enclosing let. 
Otherwise you run into trouble not just with let but also with begin.

what is an enclosing let? can we check this invariant here, when we might 
have illegal forms?



Cons cells!!!! and clean up Eq and other instrs


Ask about setting globals to literals

FOR NORMAN: the goto in the provided vo code: returnt.vo was wrong. 
goto 5 skips over the instruction. why?

comment parser broken-- what's wrong with my code?


Add <:> operator : curry op cons + <$>

Ask about literal after @: can we have it, bc we use regs?

Any let with more than one binding is not valid. So what are all these let*s
doing? They got a lot. 

// add move instruction and short-circuit boolean logic


I recommend that your loader call svmdebug_value("unparse") to see if unparsing 
is requested, and if so, have get_instruction call printasm on every 
instruction that the loader reads.


Quotes

"All of the words you said sounded sensible, but there were so many of them 
I can't hold them all in my head at once."

"Dinner is about to be served. I will reply later. I hope within an hour."

'The comments on struct VMState could serve as an object lesson in 
"how not to comment."'

R: "Why is it called ld, if it's not a full loader?"
NR: "I don't know... some people were discussing it being a loader in the 70s..."
R: "Yeah, makes sense. I figured if anyone would've been there it would be you"
NR: "No, I was out playing touch football"


"charmingly naive"

"There's not enough words there for it to be wrong"

"As long as we can emacs, the mechanism is immaterial."