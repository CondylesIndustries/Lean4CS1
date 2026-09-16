```lean
inductive Variable where
| Xvar
| Yvar
| Zvar

open Variable

inductive PropLogicSyntax where
| T
| F
| And (left right : PropLogicSyntax) : PropLogicSyntax
| Or (left right : PropLogicSyntax) : PropLogicSyntax
| Not (p : PropLogicSyntax)
| Var (v : Variable)

open PropLogicSyntax

def X := PropLogicSyntax.Var Xvar
def Y := PropLogicSyntax.Var Yvar
def Z := PropLogicSyntax.Var Zvar

def varInterp : Type := Variable → Bool

def i1 : varInterp :=
  fun (v : Variable) =>
    match v with
    | Xvar => true
    | Yvar => true
    | Zvar => true

def i2 : varInterp :=
  fun (v : Variable) =>
    match v with
    | Xvar => false
    | Yvar => true
    | Zvar => true

def eval : PropLogicSyntax → varInterp → Bool
| T, _ => true
| F, _ => false
| (PropLogicSyntax.And p1 p2), i => (eval p1 i) && (eval p2 i)
| (PropLogicSyntax.Or p1 p2), i => (eval p1 i) || (eval p2 i)
| (PropLogicSyntax.Not p1), i => !(eval p1 i)
| (PropLogicSyntax.Var v), i => i v

def e1 := F
def e2 := T
def e3 := PropLogicSyntax.And e1 e2
def e4 := PropLogicSyntax.And X Y

#eval eval e1 i1
#eval eval e2 i1
#eval eval e3 i1
#eval eval e4 i1
#eval eval e4 i2
```


<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

