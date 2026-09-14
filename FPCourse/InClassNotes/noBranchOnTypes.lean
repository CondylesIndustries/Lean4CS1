/- @@@
This won't build because you can't branch on values
of variables of type Type. That's the rule. The logic
would break down were that allowed, so it's just not.
If you want it you have to simulate it using values
of ordinary types then interpreted as representing as
ordinary data the types of the values they label. You
can pattern match on ordinary data.

This code uncommented won't build. The core reason is
as just stated. You can't write a function that takes
a type, such as Nat or Bool, then branch depending on
which you got. The proximate technical reason for the
build error is that the pattern matching doesn't even
represent Nat or String (left of =>) as the names of
types. Now when a fresh variable such as Nat in this
specific context is used to pattern match an argument
(here the incoming type) it matches any such value.
Thus function will then return "Nat" for everything.
And the error is given because there's nothing left
for the second case to handle--a presumed mistake. So
it says the String case is redundant, as any argument
value would already have been handled by the preceding
case. Hover over Nat or String to the left of the =>s.
You should see Lean knows their types. But now change
Nat to something silly, maybe Hip. Ah hah. The Nat to
the left of => doesn't refer to the ℕ (Nat) type, it
is just an identifier to be bound to the argument. No
matching on inhabitants of Type will work.
@@@ -/

def branchOnType : Type → String :=
  fun t =>
    match t with
    | Nat => "Nat"
    | String => "String"

#eval branchOnType Nat
#eval branchOnType Bool
#eval branchOnType String


/- @@@

@@@-/
