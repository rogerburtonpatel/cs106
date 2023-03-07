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