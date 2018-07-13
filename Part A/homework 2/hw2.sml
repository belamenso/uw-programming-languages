(* 1a *)
fun all_except_option (str, strings) =
let fun loop(acc_list, left_list, found) =
        case left_list of
             []    => if found
                      then SOME acc_list
                      else NONE
           | s::ss => if same_string(s, str)
                      then loop(acc_list, ss, true)
                      else loop(s::acc_list, ss, found)
in
  loop([], strings, false)
end

(* 1b *)
fun get_substitutions1(subs, str) =
  case subs of
       []    => []
     | x::xs => case all_except_option(str, x) of
                     NONE   => get_substitutions1(xs, str)
                   | SOME l => l @ (get_substitutions1 (xs, str))

(* 1c *)
fun get_substitutions2(subs, str) =
let fun loop(acc, subs) =
        case subs of
             [] => acc
           | x::xs => case all_except_option(str, x) of
                           NONE   => loop(acc, xs)
                         | SOME l => loop(l @ acc, xs)
in
  loop([], subs)
end

(* 1d *)
fun similar_names(subs, {first=f, middle=m, last=l}) =
let
  fun names_to_records [] = []
    | names_to_records (name::names) =
      {first=name, middle=m, last=l}::(names_to_records names)
  fun loop(acc, []) = acc
    | loop(acc, aliases::subs) = 
      case all_except_option(f, aliases) of
           NONE => loop(acc, subs)
         | SOME names => loop(acc @ (names_to_records names), subs)
in
  {first=f, middle=m, last=l}::loop([], subs)
end

(* 2a *)
fun card_color (suit, _) =
  case suit of
       Spades => Black
     | Clubs => Black
     | Diamonds => Red
     | Hearts => Red

(* 2b *)
fun card_value (_, rank) =
  case rank of
       Num i => i
     | Ace   => 11
     | _     => 10

(* 2c *)
fun remove_card (cards, card, err) =
  case cards of
       [] => raise err
     | c::cs => if c = card
                then cs
                else c::(remove_card (cs, card, err))

(* 2d *)
fun all_same_color cards =
  case cards of
       []         => true
     | x::[]      => true
     | x1::x2::xs => if card_color x1 = card_color x2
                     then all_same_color (x2::xs)
                     else false
(* 2e *)
fun sum_cards cards =
let fun loop (sum, cards) =
        case cards of
             []    => sum
           | c::cs => loop (card_value c + sum, cs)
in
  loop (0, cards)
end

(* 2f *)
fun score (cards: card list, goal: int) =
let 
  val cards_sum = sum_cards cards
  val same_colors = all_same_color cards
in
  if cards_sum > goal
  then if same_colors
          then (3 * (cards_sum - goal)) div 2
          else 3 * (cards_sum - goal)
  else if all_same_color cards
       then (goal - cards_sum) div 2
       else (goal - cards_sum)
end

(* 2g *)
fun officiate (cards, moves, goal) =
let fun play (held_cards, stack, moves) =
        case moves of
             []              => score (held_cards, goal)
           | (Discard c)::ms => play (remove_card (held_cards, c, IllegalMove), stack, ms)
           | Draw::ms        => case stack of
                                     [] => score (held_cards, goal)
                                   | c::cs =>
                                       if (sum_cards (c::held_cards)) > goal
                                       then score (c::held_cards, goal)
                                       else play (c::held_cards, cs, ms)
in
  play ([], cards, moves)
end

