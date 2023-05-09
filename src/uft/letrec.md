                                                    {fs}           {x}
let x = (letrec f1 = (lam (args) body), f2 = ... in letrecbody) in e
                                                    {fs}       {x, fs}
(letrec f1 = (lam (args) body), f2 = ... in let x = letrecbody in e)

for each f free in e, rename it in the closures of the rhss and letrecbody