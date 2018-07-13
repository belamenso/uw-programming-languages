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
### Tuples
N-tuples are syntactic sugar for records wiht fields 1..n.
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
