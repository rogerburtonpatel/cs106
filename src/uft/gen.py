for s in "function?   cdr pair?       car  symbol?  number?   boolean? null? nil?".split():
#    print (f'| ("{s}", [x, y]) => \n\
#               spaceSep [reg x, ":=", "{s}", reg y]')
    print(f'r1 := {s} r1')
              