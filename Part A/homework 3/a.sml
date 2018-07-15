(* 1 *)
val only_capitals =
  List.filter (fn s => Char.isUpper (String.sub (s, 0)))

(* 2 *)
val longest_string1 =
let fun biggerString (s1, s2) =
    if String.size s1 > String.size s2
    then s1
    else s2
in
  List.foldl biggerString ""
end

(* 3 *)
val longest_string2 =
let fun biggerString (s1, s2) =
    if String.size s1 >= String.size s2
    then s1
    else s2
in
  List.foldl biggerString ""
end

(* 4 *)
fun longest_string_helper comparator =
let fun biggerString (s1, s2) =
    if comparator (String.size s1, String.size s2)
    then s1
    else s2
in
  List.foldl biggerString ""
end

fun longest_string3 strings =
  longest_string_helper (fn (a,b) => a > b) strings
fun longest_string4 strings =
  longest_string_helper (fn (a,b) => a >= b) strings

(* 5 *)
val longest_capitalized =
  longest_string1 o only_capitals

(* 6 *)
val rev_string =
  implode o List.rev o explode

(* 7 *)
exception NoAnswer

fun first_answer f xs =
  case xs of
       []    => raise NoAnswer
     | x::xs => case f x of
                  NONE   => first_answer f xs
                | SOME x => x

(* 8 *)
fun all_answers f xs =
let fun loop acc xs =
        case xs of
             []    => SOME acc
           | x::xs => case f x of
                        NONE => NONE
                      | SOME l => loop (l@acc) xs
in 
  loop [] xs
end

(* 9 *)

