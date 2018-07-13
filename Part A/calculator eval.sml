datatype exp = Constant of int
             | Negate   of exp
             | Add      of exp * exp
             | Multiply of exp * exp

fun eval (expr: exp): int =
  case expr of Constant x     => x
             | Negate e       => ~ (eval e)
             | Add(e1, e2)      => (eval e1) + (eval e2)
             | Multiply(e1, e2) => (eval e1) * (eval e2)

val x: exp =
  (Add (Constant (10 + 9), Negate (Constant 4)))
val result: int = eval x


