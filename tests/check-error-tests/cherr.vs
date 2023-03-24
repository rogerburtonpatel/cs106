begin-check-error 3
r1 := 0
r1 := r1 / r1
end-check-error "r1 / r1"
printlnl "we're done"