r0 := function (0 arguments) {
    r1 := 0
    r1 := r1 / r1
    return r0
}
r2 := function (0 arguments) {
    check-error "r1 / r1" r0
    return r0  
}
check-error "check-error r1 / r1" r2