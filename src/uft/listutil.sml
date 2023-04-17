structure ListUtil :> sig  
  (* missing from mosml *)
  val mapi : (int * 'a -> 'b) -> 'a list -> 'b list
  val concatMap : ('a -> 'b list) -> ('a list -> 'b list)
end
  =
struct
  fun mapi f xs =
    let fun go k [] = []
          | go k (x::xs) = f (k, x) :: go (k + 1) xs
    in  go 0 xs
    end

  fun concatMap f xs = foldr (fn (x, tail) => f x @ tail) [] xs
end


