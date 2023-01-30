- Div is floating, idiv is not 
If you want a rant on the topic, ask me. re: parsing. Maybe?
- ask about casting to StringBuffer with bogus
- depth pts mod 1!



            // case InitConsCell: {
            //     struct VMBlock *vmb = vmalloc_raw(sizeof(*vmb));
            //     vmb->nslots = 0;

            // }
            // Examines value v in rX and sets rY to falsey(v).

        // check that there are a positive num instructions
        // boolean interpretation from AS_BOOL
        // goto
        // catch div 0
        // cache instructions pointer
        // counter as uint32_t
        // remove reg vars
        // global names and values as sep lists-- genius


// TODO ask about \n vmrun.c:47

// TODO see if needed, or should be on VMHeap... svm.c:33

vmstate.c:48

I recommend that your loader call svmdebug_value("unparse") to see if unparsing 
is requested, and if so, have get_instruction call printasm on every 
instruction that the loader reads.

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