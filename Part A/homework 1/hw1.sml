fun year (date: int * int * int) = #1 date
fun month (date: int * int * int) = #2 date
fun day (date: int * int * int) = #3 date
val month_names = ["January", "February", "March", "April", "May", "June",
                  "July", "August", "September", "October", "November", "December"]
val month_lengths = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

(* 1 *)
fun is_older (a: int * int * int, b: int * int * int) =
  year a < year b
  orelse (year a = year b andalso month a < month b)
  orelse (year a = year b andalso month a = month b andalso day a < day b)

(* 2 *)
fun number_in_month (dates: (int * int * int) list, given_month: int) = 
let
  fun count_month date = if month date = given_month then 1 else 0
  fun loop dates = if null dates
                   then 0
                   else count_month (hd dates) + loop (tl dates)
in
  loop dates
end

(* 3 *)
fun number_in_months (dates: (int * int * int) list, months: int list) =
  if null months
  then 0
  else number_in_month (dates, hd months)
       + number_in_months (dates, tl months)

(* 4 *)
fun dates_in_month (dates: (int * int * int) list, given_month: int) =
  if null dates
  then []
  else if month (hd dates) = given_month
       then (hd dates)::dates_in_month (tl dates, given_month)
       else dates_in_month (tl dates, given_month)

(* 5 *)
fun dates_in_months (dates: (int * int * int) list, months: int list) =
  if null months
  then []
  else dates_in_month (dates, hd months) @ dates_in_months (dates, tl months)

(* 6 *)
fun get_nth (strings: string list, n: int) =
  if n = 1
  then hd strings
  else get_nth (tl strings, n - 1)

(* 7 *)
fun date_to_string (date: int * int * int) =
  get_nth (month_names, month date) ^ " " ^ Int.toString (day date) ^ ", "
    ^ Int.toString (year date)

(* 8 *)
fun number_before_reaching_sum (sum: int, xs: int list) =
let fun loop (n: int, partial_sum: int, xs: int list) =
        if partial_sum >= sum
        then n - 1
        else loop (n + 1, partial_sum + (hd xs), tl xs)
in
  loop (0, 0, xs)
end

(* 9 *)
fun what_month (day: int) =
  1 + number_before_reaching_sum (day, month_lengths)

(* 10 *)
fun month_range (day1: int, day2: int) =
  if day1 > day2
  then []
  else 1 + number_before_reaching_sum (day1, month_lengths)
       :: month_range(day1 + 1, day2)

(* 11 *)
fun oldest (dates: (int * int * int) list) =
let fun loop (dates: (int * int * int) list,
              current_oldest: int * int * int) =
        if null dates
        then current_oldest
        else if is_older (hd dates, current_oldest)
             then loop (tl dates, hd dates)
             else loop (tl dates, current_oldest)
in
  if null dates
  then NONE
  else SOME (loop (tl dates, hd dates))
end

(* Challenge 12 *)
fun remove_duplicates (xs: int list) =
let
  fun member(x: int, xs: int list) =
    if null xs
    then false
    else x = (hd xs) orelse (member (x, tl xs))
  fun loop(acc: int list, xs: int list) =
        if null xs
        then acc
        else if member (hd xs, acc)
             then loop (acc, tl xs)
             else loop ((hd xs)::acc, tl xs)
in
  loop ([], xs)
end

fun number_in_months_challenge (dates: (int * int * int) list, months: int list) =
  number_in_months (dates, remove_duplicates months)


fun dates_in_months_challenge (dates: (int * int * int) list, months: int list) =
  dates_in_months (dates, remove_duplicates months)

(* Challange 13 *)
fun reasonable_date (date: int * int * int) =
let
  fun is_leap_year(date: int * int * int) =
    (year date) mod 400 = 0 orelse ((year date) mod 100 <> 0 andalso
                                    (year date) mod 4 = 0)
  fun get_nth(xs: int list, n: int) =
    if n = 1
    then hd xs
    else get_nth (tl xs, n - 1)
in
  (year date) > 0 andalso
  1 <= (month date) andalso (month date) <= 12 andalso
  (day date) >= 1 andalso
  if is_leap_year date andalso (month date) = 2
  then (day date) <= 29
  else (day date) <= (get_nth (month_lengths, month date))
end

