# StandardML Cheat Sheet
## General stuff
[Standard ML of New Jersey](https://www.smlnj.org/ "Standard ML of New Jersey")

[Full Standard ML '97 Grammar](https://people.mpi-sws.org/~rossberg/sml.html "SML Grammar")
```sml
(* comments *)
```
Unary negation is written as `~`, not `-`:
```sml
fun abs a = if a <= 0 then ~a else a
```
`<>` stands for not equal. Equality types have `=` and `<>` defined on them. You cannot check
equality between real and an int without converting one to another's type first.

Semicolons are mostly optional in files, sometimes requied in REPL (?).

Import source file (by evaluating pasted contents in REPL?):
```sml
use "my_lib.sml";
```
## Syntax
### Variables
```sml
val a = 10;
val a: int = 10;
```
No assignment, next declaration shadows previous one.
```sml
val a = 10;
val a = 42; (* OK, old a is shadowed *)
```
`val`s accept patterns
```sml
val {name=n, balance=b} = {name="John", balance=3795.8}
val x1::x2::[] = [1,2]
```
The pattern must match however; this raises error:
```sml
val NONE = SOME 10
```

Assign to `_` to ignore value. You can repeatedly assign to `_` in patterns (which wouldn't
work with normal names, it's a special form). `_` is also used as a universal match-all pattern.

### Tuples
N-tuples are syntactic sugar for records wiht fields 1..n. Elements may be of different types.
```sml
val t1 = (1,2,3)
val t2: int * bool = (0, false)
#1 t2 (* 0 : int *)
```
All functions accept exacly one argument, multiple arguments are simulated with a tuple, which
permits us to easily compose functions accepting/returning multiple arguments.
```sml
fun rotate_left (a, b, c) = (b, c, a);
fun rotate_right triple = rotate_left (rotate_left (triple))
```

### Records
Unordered data types with fields identified by symbols.
```sml
val studentData = {name = "John", surname = "Smith", id = 1234145}
(* val studentData : {name: string, surname: string, id: int}
```
You refer to the field with # and its name:
```sml
#name {name = "John", surname = "Smith", id = 1234145} (* "John" *)
```

### Lists
Elements must be of the same type. Pattern matches are usually prefered over `null`, `hs`, `tl`.
```sml
val a: int list = [1,2,3]
[] (* 'a list *)
null [] (* true *)
hd [1] (* 1 *)
tl [1] (* [] *)
1::2::[] (* [1,2] *)
```

### Custom data types
Tagged unions
```sml
datatype mytype = TwoInts of int * int
                | Str of string
                | Pizza
val a = Str "helo"; (* val a : mytype *)
val b = Pizza; (* val b : mytype *)

datatype my_list = Empty
                 | Cons of int * my_list
```

### Type synonyms
```sml
type name = string
type record = {name: string, balance: real}
```
Sometimes REPL chooses one of equivalent aliased types, it depends on internal representation
and optimizations. 

### Pattern matching
```sml
fun append xs ys =
  case xs of
    []    => ys
  | x::xs => x::(append xs ys)

val b = case f x of
          NONE   => []
        | SOME x => [x]
```
Branches are checked top-down.

Nested patterns are also possible: `x1::x2::xs`.

Integer literals can be used in patterns: `StudentID 1 => handle ()`.

### Conditionals and boolean operators
Both branches need to be of the same type.
```sml
if predicate then val1 else val2;
true andalso false;
x orelse y
```

### Let expressions
Let bindings can use previously defined let bindings (like `let*` in Racket).
```sml
let
  val X = 10
  fun fact n = if n = 0 then 1 else n * fact (n - 1)
in
  fact x
end
```
### Functions and lambdas
Lambdas are introduces using `fn` keyword:
```sml
map(fn x => x * x, numbers)
```
All functions accept exactly 1 argument. Multiple arguments can be simulated with
a tuple. In place of function argument you can place any pattern. Alternative syntax
with multiple disjoint pattern matches.
```sml
fun square x = x * x;
fun square (x: int): int = x * x;
fun get_name {name=n, surname=s, age=a} = n;
fun length []    = 0
  | length x::xs = 1 + length xs 
```
You cannot refer to function bindings that were not declared yet (e.g. are below in the file).

`fun` accepts a pattern
```sml
fun sum2 (a, b) = a + b
fun ageIn10Years {name=_, age=a} = a + 10
```

### Currying
Functions with multiple patterns are automatically curried.
```sml
fun filter pred xs =
  case xs of
    [] => []
  | x::xs => if pred x then x::(filter pred xs) else pred xs
val filterEven = filter (fn x => x mod 2 = 0)
```

## Type system
### Type constructors
Produce types
```sml
SOME 10 (* int option *)
[1,2,3] (* int list *)
```

### Polymorphic types
`'a` pronouced like greek letters.
```sml
fn x => x (* 'a -> 'a *)

fun length xs = (* length: 'a list -> int *)
  case xs of
    []    => 0
  | x::xs => 1 + length xs
```

## Standard library
### Operators
* `"hello" ^ "world"` - string concatenation
* `[1,2] @ [3,4]` - append
* `~10 = 20 - 10` - negate
* `mod`, `div`
* `Real.fromInt`
### Option
```sml
case x of
  NONE   => "nothing"
  SOME x => "something is here"
```
Additionally defined functions (usually inferior style to pattern matching):
```sml
if isSome x
then "something is " ^ valOf x
else "nothing"
```
## Style
I'm not sure yet, REPL and many resources place `:` separated by spaces between
variable name and its type. I think I prefer ommiting the first space, it seems more
familiar and terse.
```sml
val a : int = 10
val a: int = 10
```
Functions accepting multiple arguments (tuples) must use parentheses, I'm noticing inconsistent
placemnt of space between function name and tuple:
```sml
fun_call(a, b, c);
fun_call (a, b, c);
```
