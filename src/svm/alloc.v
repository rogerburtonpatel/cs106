.load module 10
.load 0 function 1 16
loadliteral 2 false
loadliteral 3 string 5 104 101 108 108 111
copy 4 3
goto 5
loadliteral 5 string 1 97
loadliteral 6 string 1 98
cons 2 5 6
loadliteral 5 1
- 1 1 5
loadliteral 5 0
> 5 1 5
if 5
goto -9
println 3
println 4
return 2
setglobal 0 string 8 97 108 108 111 99 97 116 101
getglobal 0 string 8 97 108 108 111 99 97 116 101
loadliteral 1 1000
call 0 0 1
check 0 string 15 40 97 108 108 111 99 97 116 101 32 49 48 48 48 41
loadliteral 0 string 1 97
loadliteral 1 string 1 98
cons 0 0 1
expect 0 string 12 40 99 111 110 115 32 39 97 32 39 98 41
