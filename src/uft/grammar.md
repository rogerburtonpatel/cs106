<comment> ::= from ; to end-of-line
<reg>     ::= rNN, where NN is any decimal number from 0-255
<k>       ::= <decimal-literal> | <boolean-literal> | <null> | <emptylist>
<relop>   ::= != | == | < | > | <= | >=
<binop>   ::= + | - | * | / | idiv | and | or | mod
<unop>    ::= - | ~ 
<lvalue>  ::= <reg> 
<rvalue>  ::= <reg> | <k>
<instr>   ::= <lvalue> := <rvalue>
           |  <lvalue> := <rvalue> <binop> <rvalue>
           |  <lvalue> := <unop> <rvalue>
           |  print <rvalue>
           |  halt

