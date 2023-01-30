If you want a rant on the topic, ask me. re: parsing. Maybe?
- depth pts mod 1!

            // case InitConsCell: {
            //     struct VMBlock *vmb = vmalloc_raw(sizeof(*vmb));
            //     vmb->nslots = 0;

            // }
            // Examines value v in rX and sets rY to falsey(v).


// TODO ask about \n vmrun.c:47

// TODO see if needed, or should be on VMHeap... svm.c:33

vmstate.c:48

I recommend that your loader call svmdebug_value("unparse") to see if unparsing 
is requested, and if so, have get_instruction call printasm on every 
instruction that the loader reads.

Each entry must include a parsing function and an unparsing template. - ask

The mapping defined by 
R
 is injective: different numbers designate different locations. In math, whenever 
i
≠
j
 then 
R
[
i
]
≠
R
[
j
]
. Likewise for 
G
 and globals.

The literal pool 
L
 need not be injective; it is possible for two different indices 
i
 and 
j
 to refer to the same literal. In math, it is possible for 
L
[
i
]
=
L
[
j
]
 even when 
i
≠
j
.

but what about not wanting duplicate literals?

"All of the words you said sounded sensible, but there were so many of them 
I can't hold them all in my head at once."

"Dinner is about to be served. I will reply later. I hope within an hour."

'The comments on struct VMState could serve as an object lesson in 
"how not to comment."'


