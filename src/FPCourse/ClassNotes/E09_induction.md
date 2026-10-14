```lean
#check Empty.rec
#check PUnit.rec
#check Bool.rec
```

Bool.rec.{u}
    {motive : Bool → Sort u}
    (false : motive false)
    (true : motive true)
    (t : Bool) :
motive t
```lean
#check Nat
```

inductive Nat where
  | zero : Nat
  | succ (n : Nat) : Nat
```lean
#check Nat.rec
```

Nat.rec.{u}
    {motive : Nat → Sort u}
    (zero : motive Nat.zero)
    (succ : (n : Nat) → motive n → motive n.succ)
    (t : Nat) :
motive t
```lean
inductive natTree where
| empty
| node (left right : natTree)

#check natTree.rec
```

natTree.rec.{u}
    {motive : natTree → Sort u}
    (empty : motive natTree.empty)
    (node : (left right : natTree) → motive left → motive right → motive (left.node right))
    ---
    (t : natTree) :
    motive t
# Recursors

Every inductive type comes with a *recursor*, a function
Lean generates automatically from the type's constructors.
A recursor is the one principled way to consume a value of
the type: give it one case per constructor (a value, or a
function, matching that constructor's shape) and it tells
you how to produce a result for *any* value of the type.

`match` and pattern-matching `def`s are just friendlier
notation that compiles down to a call to the recursor. So
if you understand the recursor for a type, you understand
why pattern matching on it is allowed to look the way it
does, and why it has to cover the cases it covers.

One wrinkle you'll meet below: Lean's compiler knows how
to turn `match`-notation (and `Nat.rec` itself) into fast
executable code, but it doesn't yet know how to compile a
*bare* call to most other recursors. So several of the
`def`s below have to be marked `noncomputable`, and we
check their results with `#reduce` (plain symbolic
evaluation in the elaborator) instead of `#eval` (which
needs compiled code). `Nat.rec` is the exception -- it
*is* directly computable, which is why `factorial` below
can use `#eval`.

Below we look at the recursors for five familiar types,
from the one with zero constructors up to the ones that
carry recursive data.
## Empty / False: zero constructors

`Empty` and its `Prop` analog `False` have *no*
constructors. So its recursor needs no *case* arguments
at all, just a motive and the (impossible) value itself.
What you get back is a valid function term, albeit one
that can never be applied. This is "from a contradiction,
anything follows" (ex falso), but in the *computational*
realm.

For a concrete example, pick any computational type at
all. Take String, for example. You can for free have a
total function from Empty to String.
```lean
example : Empty → String := λ e => nomatch e
```

And it's easy to see that the same principle works for
*any* return type whatsoever.
```lean
example (α : Type u) : Empty → α := fun e => nomatch e
```

Now here's a walk-away lesson for the day. In deductive
logic as embedded in Lean, so-called *elimination rules*
for *inductively defined* propositions are applications
of the associated *recursors*, or *induction principles*.
In other words, the functions we just define ultimately
reduce to applications of the associated recursors. Here
we're given a value of type Empty, and to use it, we use
nice syntax to invoke the recursor for it. So let's look
at that!
```lean
#check @Empty.rec
```

Empty.rec :
  (motive : Empty → Sort u_1) →   -- given a function on non-existent values
  (t : Empty) →                   -- and given any such value in particular
  motive t                        -- the function will compute an answer
```lean
def e2s : Empty → String :=
  fun e =>
    Empty.rec
      (fun _ => String)
      e
```

That `(fun _ => String)` is the *motive* -- it's standing in
for the `motive : Empty → Sort u_1` argument that `Empty.rec`
asked for above. Recursors are stated for an arbitrary,
*type-valued* function of the value being eliminated, rather
than for one fixed return type, because in general which type
you land in is allowed to depend on which constructor you
matched (and, for types with data, on that data too). `Empty`
has no constructors to depend on, so the motive here just
ignores its argument (`_`) and names the same type, `String`,
no matter what. Handing `Empty.rec` that motive is how you
tell it "produce a `String` for me" -- it's what makes
`Empty.rec (fun _ => String) e` a term of type `String`,
exactly as `e2s`'s signature promises.
It says if you want a function (`motive`) from
Empty to any return type whatsoever, you can
have it without providing any additional terms,
and it will take any value `t` of that type to a
return value of the specified retur type (which
lives in `Sort u`, which is to say in any type
universe, even including `Prop`, i.e., `Sort 0`).
Reflecting the Curry-Howard correspondence the
associated logical reasoning principle, of False
elimination, is isomorphic to its computational
analog that you can always have a function taking
Empty to *any* other type *for free*.
```lean
#check @False.rec
```

False.rec :
  (motive : False → Sort u_1) →
  (t : False) →
  motive t
```lean
noncomputable def fromEmpty (e : Empty) : Nat :=
  Empty.rec (fun _ => Nat) e

theorem fromFalse (h : False) : 3 = 4 :=
  False.rec (fun _ => (3 = 4)) h
```

## Unit / True: one constructor, no data

`Unit` (and `True`) has exactly one constructor carrying
no data (`Unit.unit`, written `()`). So its recursor needs
exactly *one* case: a value to return for `Unit.unit`.
Since that's the only possible input, the recursor just
hands that one value back, no matter which `Unit` you give
it (there's only one anyway).

(`Unit` is just notation for `PUnit`, Lean's universe-
polymorphic one-element type, so its recursor is named
`PUnit.rec`.)
```lean
#check @PUnit.rec
#check @True.rec

noncomputable def fromUnit (u : Unit) : String :=
  PUnit.rec "the one and only" u

#reduce fromUnit ()   -- "()" is notation for Unit.unit
```

## Bool: two constructors, no data

`Bool` has two constructors, `false` and `true`, neither
carrying data. So its recursor needs *two* cases: one
result for `false`, one for `true`. This is exactly
if-then-else, just with the cases spelled out in
constructor order.
```lean
#check @Bool.rec

noncomputable def describe (b : Bool) : String :=
  Bool.rec "it's false" "it's true" b

#reduce describe true
#reduce describe false
```

## Nat: a recursive constructor

`Nat` has two constructors, `Nat.zero` and `Nat.succ`, and
`succ` carries another `Nat` inside it. So the recursor
needs a case for `zero`, and a case for `succ` that gets
handed *both* the smaller number `n` *and* the result
already computed for `n` (the "induction hypothesis").
That second piece is what makes it genuine recursion
rather than a one-step case split -- and it's why
induction and recursion are, underneath, the same thing.
```lean
#check @Nat.rec

def factorial (n : Nat) : Nat :=
  Nat.rec 1 (fun n ih => (n + 1) * ih) n

#eval factorial 0   -- 1
#eval factorial 5   -- 120
```

## String: one constructor, carrying data *and* a proof

In current Lean, `String` is a structure with a single
constructor holding a `ByteArray` together with a *proof*
that those bytes are valid UTF-8. So, like `Unit`, its
recursor needs only *one* case -- but here that case is a
function taking both pieces: the raw bytes, and the proof
obligation that goes with them. It's the same
proof-carrying-data idea you saw earlier with
`SquarePair`, just built into a type from the standard
library.
```lean
#check @String.rec

noncomputable def byteLength (s : String) : Nat :=
  String.rec (fun toByteArray _ => toByteArray.size) s

#reduce byteLength "hello"   -- 5
#reduce byteLength ""        -- 0
```


<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

