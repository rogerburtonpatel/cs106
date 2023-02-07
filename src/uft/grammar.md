<comment> ::= from ; to end-of-line
<reg>     ::= rNN, where NN is any decimal number from 0-255
<k>       ::= <decimal-literal> | <string-literal> | <boolean-literal> | <null> | <emptylist>
<relop>   ::= != | == | < | > | <= | >=
<binop>   ::= + | - | * | / | idiv | and | or | mod
<unop>    ::= - | ~ 
<lvalue>  ::= <reg> 
<rvalue>  ::= <reg> | <k>
<instr>   ::= <reg> := <rvalue>
           |  <reg> := <rvalue> <binop> <rvalue>
           | check <string-literal> <reg>
           |  <unop> <reg>
           |  print <reg>
           | if <reg>
           | goto <string-literal>
           |  halt

