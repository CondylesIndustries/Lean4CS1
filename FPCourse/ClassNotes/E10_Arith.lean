namespace Arith

-- syntax
inductive ArithExpr where
| lit (n : Nat) : ArithExpr
| plus (n m : ArithExpr) : ArithExpr

open ArithExpr

-- expressions using our syntax
def a1 : ArithExpr := lit 1
def a7 : ArithExpr := lit 7
def a1Pa7 : ArithExpr := plus a1 a7

-- operational semantics

def arithEval : ArithExpr → Nat
| lit n => n
| plus e1 e2 => (arithEval e1) + (arithEval e2)

def p1 : ArithExpr := plus (lit 7) (plus (lit 6) (lit 9))

#eval arithEval p1



end Arith
