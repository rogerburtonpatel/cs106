# 6. 
A struct for a VM state: well, the state is 
<I1 o i . I2, R, L, G, sigma>
instruction counter and list-- instruction, 
pointer to next?
Registers: vars or an array
Literals and Globals maybe can just be 
global C vars
store is the heap so no need to store it. 

# 7. and 8. 
The 5 tags are
               Boolean,   
               Number,
               String,
               Emptylist,
               ConsCell,   // represented as Block (for now)

3 instructions based on tags to work on:
- Math on numbers: add 2, sub 2, etc. FORMAT: R3
- Boolean truth extraction. FORMAT: R3
  case analysis. 
- car/cdr: consume a cons cell and give FORMAT: R3i
car: a value
cdr: a cons cell or Emptylist

for these, decoding funcs are opcode, uX, uY, and uZ.


- if time: goto. take a number and address to that num. FORMAT: R0I24
for this, decoder is iXYZ


# 9. 
A. Generally 1 day after assignment. 
B. Before dinner, but after is fine. 
C. Encouragement of ideas. Eclectic skills in programming 
   and automation/testing. Lots of affirmation and gratitude
   in partnership. 
D. Enthusiasm, belief in self and in pair, willingness to 
   tell me I'm wrong and OK being wrong themselves. Loves
   to try ideas. 
   Good music taste also is a plus!
