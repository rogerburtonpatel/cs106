<comment> ::= from ; to end-of-line
<reg>     ::= rNN, where NN is any decimal number from 0-255
<k>       ::= <decimal-literal> | <string-literal> | <boolean-literal> | <null> | <emptylist>
<relop>   ::= != | == | < | > | <= | >=
<binop>   ::= + | - | * | / | idiv | and | or | mod
<unop>    ::= - | ~ | ++ | -- | boolOf 
<rvalue>  ::= <reg> | <k>
<instr>   ::= <reg> := <rvalue>
                     | <reg> <binop> <reg>
                     | <unop> <reg>
           | check <string-literal> <reg>
           | expect <string-literal> <reg>
           | @ <obj-instr>
           | <unop> <reg>
           | print <reg>
           | println <reg>
           | printu <reg>
           | if <reg> goto <string-literal>
           | deflabel <string-literal>
           | goto <string-literal>
           | halt

