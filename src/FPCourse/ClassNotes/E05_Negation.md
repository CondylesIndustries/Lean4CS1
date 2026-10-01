
# Notes 9/21/26


- Curry-Howard Injection: Deductive Reasoning (Prop) => Computation (Type)

- Deep vs Shallow embedding of abstract theories into Lean 4
  - Deep embedding: Syntax as a type with constructor for each kind of term (propositional logic)
  - Shallow embedding: Syntax as collection of types, one for each kind of term (predicate logic)

  - Empty and False
  - Unit and True
  - Prod and And
  - Sum and Or
  - -> Empty and -> False (Not!)


```lean
def e2e : Empty → Empty
| e => e

def fimpf : False → False
| f => f

inductive MyEmpty : Type where

def me2e : MyEmpty → Empty
| m => nomatch m

inductive MyFalse : Prop where
-- | mk

theorem myFalseIsReallyFalse : MyFalse → False
| m => nomatch m

def neg (a : Prop) : Prop := a → False

#check MyFalse

example : neg MyFalse
| m => nomatch m

example : ¬MyFalse
| m => nomatch m

#check (@And)

inductive KevinIsFromCville : Prop where
| driversLicense

example : KevinIsFromCville := KevinIsFromCville.driversLicense

inductive JorgIsFromToronto : Prop where
| driversLicense
| utilityBill
| healthCard

example : And KevinIsFromCville JorgIsFromToronto :=
And.intro
  KevinIsFromCville.driversLicense
  JorgIsFromToronto.healthCard

inductive Cat : Type where
| siamese
| tabby

example : ¬ (Cat.tabby = Cat.siamese)
| m => nomatch m

example :
JorgIsFromToronto.driversLicense = JorgIsFromToronto.healthCard :=
rfl
```

## Next Lecture: Existence, Witnesses, and Nonconstructive Proofs

`∃ x : α, R x` says that some value x has property R. To introduce
an existential proof constructively, provide a *witness* w : α
and a proof of R w. `Exists.intro` packages these together:
```lean
example : ∃ n : Nat, n = 3 :=
  Exists.intro 3 rfl
```

To eliminate an existential proof, unpack its witness and evidence
and use them to prove a conclusion S. The conclusion must not
depend on which witness was hidden inside the existential:
```lean
example {α : Type} (R : α → Prop) (S : Prop) :
    (∃ x : α, R x) → (∀ x : α, R x → S) → S :=
  fun existsRx =>
    fun useWitness =>
      match existsRx with
      | Exists.intro w rw => useWitness w rw
```

This is reasoning with a witness inside a proof. Lean's `Exists`
lives in `Prop`; unpacking it to prove S does not give us a general
executable function that returns its witness as data.

Classically, we can also prove existence by contradiction, without
explicitly constructing a witness. Substitute `∃ x, R x` for P
in our previous proof. See `E05_ClassicalVsConstructive.lean` for
an introduction to `open Classical` and the `em` it provides.
```lean
open Classical

example {α : Type} (R : α → Prop) :
    (¬(∃ x : α, R x) → False) → ∃ x : α, R x :=
  fun notNotExists =>
    match em (∃ x : α, R x) with
    | Or.inl existsRx => existsRx
    | Or.inr notExists => False.elim (notNotExists notExists)
```

## A Provocation: Banach–Tarski

The Banach–Tarski theorem (1924) says that a solid ball in
three-dimensional space can be partitioned into finitely many
sets, then those sets moved by rotations and translations to
form two disjoint balls, each the same size as the original.
The usual proof uses the axiom of choice. The pieces cannot all
have ordinary volume: nonmeasurable sets are involved. This is
a theorem about sets of points, not a physical recipe for cutting
up a ball and doubling its material.
See [Banach and Tarski's original paper](https://pldml.icm.edu.pl/pldml/element/bwmeta1.element.bwnjournal-article-fmv6i1p27bwm)
and [Terence Tao's explanation](https://www.math.ucla.edu/~tao/resource/general/121.1.00s/tarski.html).

It vividly illustrates the constructive objection: what counts
as evidence that these pieces exist if we cannot construct them
in the required sense? A constructivist does not have to accept
the classical proof as a constructive existence proof. The issue
is the justification of existence, not merely that the conclusion
is surprising. Excluded middle alone should not be confused with
the choice principle used in the Banach–Tarski argument.

Historically, this did not launch constructive mathematics:
Brouwer's foundational work dates to 1907–1908, before this
theorem. Use Banach–Tarski as an illustration of the demand for
construction that motivated constructive approaches, rather than
as their historical cause. Heyting later formalized intuitionistic
(constructive) logic. See [the history of intuitionistic logic](https://plato.stanford.edu/entries/intuitionistic-logic-development/).
```lean
example{P : Prop} : ¬(P ∧ ¬P) :=
  fun (pnp : P ∧ ¬P) =>
    pnp.right pnp.left
```

## Predicates

Every proposition so far has been a fixed claim: `KevinIsFromCville`,
`P ∧ ¬P`, `¬¬P → P`. A *predicate* generalizes the idea. Informally,
a predicate is a property that a value may or may not have: *is
even*, *is empty*, *is less than ten*. Think of it as a sentence
with a hole in it, "___ is even", which becomes a definite
proposition only once the hole is filled with a particular value.

Lean 4 needs no new machinery to express this. A predicate on a
type α is simply a *function from α to `Prop`*:

- `P : α → Prop` is a predicate on α,
- `P a`, for `a : α`, is a proposition, something we can try to prove,
- so a predicate is a whole *family* of propositions, one for each
  value of α.

Here is a predicate on `Nat` and two of the propositions it yields.
Note the types reported by `#check`. For a definition Lean prints
the signature, `IsZero (n : Nat) : Prop`; the `@` form shows the
same thing as a function type, `Nat → Prop`. Each *application*
of the predicate is a `Prop`.
```lean
def IsZero (n : Nat) : Prop := n = 0

#check IsZero         -- IsZero (n : Nat) : Prop
#check @IsZero        -- Nat → Prop, a predicate
#check IsZero 0       -- Prop, a proposition
#check IsZero 1       -- Prop, also a proposition
```

`IsZero 0` unfolds to `0 = 0`, which `rfl` proves. `IsZero 1`
unfolds to `1 = 0`, a perfectly well formed proposition that
happens to be false, so we can prove its negation instead. Being
a predicate application says nothing about being true.
```lean
example : IsZero 0 := rfl
example : ¬IsZero 1 := fun h => Nat.one_ne_zero h
```

Predicates do not have to be named. A function literal from values
to propositions is a predicate too.
```lean
#check fun n : Nat => n > 3
```

A predicate may take extra parameters before the value it is
about. Here `Between lo hi` is a predicate on `Nat` for each
choice of bounds, built from the connectives we already know.
```lean
def Between (lo hi n : Nat) : Prop := lo ≤ n ∧ n ≤ hi

example : Between 0 10 4 := And.intro (Nat.zero_le 4) (Nat.le_add_left 4 6)
```

A predicate of two arguments, `α → α → Prop`, is what we usually
call a *relation*: it asserts that a property holds *of a pair*.
Equality and ≤ on `Nat` are exactly this, and the second is defined
inductively, which is how such predicates are often given.
```lean
#check @Eq             -- {α : Sort u_1} → α → α → Prop
#check @Nat.le         -- Nat → Nat → Prop

def Divides (d n : Nat) : Prop := n % d = 0

#check Divides 3       -- Nat → Prop, "is divisible by three"

example : Divides 3 9 := rfl
example : ¬Divides 3 10 := fun h => nomatch h
```

One distinction is worth stressing, because Lean maintains it
carefully. A predicate returns a `Prop`, a *proposition* whose
proofs are evidence. A function returning `Bool` returns *data*,
the result of a *computation*. `isZeroBool 1` evaluates to `false`;
`IsZero 1` does not evaluate to anything, it is a claim we can
refute. Propositions are what we reason about; Booleans are what
we compute with. Connecting the two, deciding a proposition by
running a Boolean test, is the topic of decidability.
```lean
def isZeroBool (n : Nat) : Bool := n == 0

#check @isZeroBool     -- Nat → Bool, a decision procedure
#eval isZeroBool 1     -- false, a computed value
```

Predicates are what the quantifiers quantify over. `∀ x : α, P x`
says every value of α satisfies the predicate P, and `∃ x : α, P x`
says at least one does. Having predicates in hand, we can now
turn to the second of these.
## Exist
### A Concrete Introduction
```lean
inductive Dog : Type where
| Iris
| Fido
| Sargent

open Dog


inductive Friendly : Dog → Prop where
| irisFriendly : Friendly Iris
| fidoFriendly : Friendly Fido

inductive Furry : Dog → Prop where
| irisFurry : Furry Iris
| sargentFurry : Furry Sargent

-- Iris is friendly and furry

example : Friendly Iris ∧ Furry Iris :=
  -- Remember here ⟨_,_⟩ is shorthand for And.intro
  ⟨ Friendly.irisFriendly,Furry.irisFurry ⟩
  -- Notation usable for any one-constructor type

def Suitable'  : Dog → Prop := fun d => (Friendly d ∧ Furry d)

def Suitable (d : Dog) : Prop := (Friendly d ∧ Furry d)

example : Suitable Iris :=
  And.intro Friendly.irisFriendly Furry.irisFurry

#check (Suitable)
#check (Friendly)
#check (Furry)

#check (∀ (d : Dog), Friendly d)
#check ∀ (d : Dog), Friendly d

example : ∀ (d : Dog), Friendly d :=
  fun d =>
    match d with
    | Iris => Friendly.irisFriendly
    | Fido => Friendly.fidoFriendly
    | Sargent => _

example : ¬(∀ (d : Dog), Friendly d ):=
  fun allDogsFriendly =>
    let sf := allDogsFriendly Sargent
    nomatch sf

example : ∃ (d : Dog), Friendly d :=
  Exists.intro Iris Friendly.irisFriendly
```

### General Presentation

The existential quantifier, `∃ x : α, R x`, asserts that *some*
value of type α satisfies the predicate R. Like every connective
we have studied, it comes with an introduction rule, telling us
how to build a proof, and an elimination rule, telling us how to
use one.

#### Introduction: Exhibit a Witness

`Exists` has exactly one constructor, `Exists.intro`. It takes
two arguments: a *witness*, `w : α`, and a proof, `pf : R w`,
that this particular value has the property in question. To prove
that something exists, produce it, then show that it works.
```lean
#check @Exists
#check @Exists.intro

example : ∃ n : Nat, n + 1 = 4 := Exists.intro 3 rfl
```

The angle-bracket notation `⟨w, pf⟩` is Lean's *anonymous
constructor*: it means "apply the sole constructor of the expected
type to these arguments." For an existential it means exactly
`Exists.intro w pf`.
```lean
example : ∃ n : Nat, n + 1 = 4 := ⟨3, rfl⟩
example : ∃ n : Nat, n > 3 := ⟨4, Nat.le.refl⟩
```

Nested existentials are nested pairs, and the anonymous
constructor notation nests to match.
```lean
example : ∃ a : Nat, ∃ b : Nat, a + b = 5 := ⟨2, 3, rfl⟩
```

A crucial observation: the *proposition* `∃ n : Nat, n + 1 = 4`
records only that a witness exists. Two proofs can use different
witnesses and still prove the very same proposition, and nothing
in the proposition tells us which one was used.
```lean
example : ∃ n : Nat, n < 10 := ⟨0, Nat.zero_lt_succ 9⟩
example : ∃ n : Nat, n < 10 := ⟨9, Nat.le.refl⟩
```

#### Elimination: Unpack the Witness

To *use* a proof of `∃ x : α, R x`, take it apart. Because there
is only one constructor, a proof must have been built as
`Exists.intro w pf`, so we may pattern match to recover a name
w for the witness and a proof pf of `R w`, then use them to build
whatever we are trying to prove.

Two constraints govern this unpacking. First, w is a *local*
name, bound only inside the branch of the match. Second, and as a
consequence, the goal being proved must be stated without
mentioning w: we are proving one fixed conclusion no matter which
value was hidden inside.

Here is the general rule, stated and proved by matching:
```lean
example {α : Type} (R : α → Prop) (S : Prop) :
    (∃ x : α, R x) → (∀ x : α, R x → S) → S :=
  fun existsRx =>
    fun useWitness =>
      match existsRx with
      | Exists.intro w pf => useWitness w pf
```

The same rule is packaged in the standard library as
`Exists.elim`, so this pattern need not be rewritten each time.
```lean
#check @Exists.elim

example {α : Type} (R : α → Prop) (S : Prop)
    (h : ∃ x : α, R x) (k : ∀ x : α, R x → S) : S :=
  Exists.elim h k
```

Anonymous constructor notation works in patterns, too, which makes
`fun ⟨w, pf⟩ => ...` the idiomatic way to eliminate an existential
in term mode. In the next example we weaken what we know about the
witness: we keep the same witness and upgrade its evidence.
```lean
example {α : Type} (P Q : α → Prop) (imp : ∀ x : α, P x → Q x) :
    (∃ x : α, P x) → (∃ x : α, Q x) :=
  fun ⟨w, pw⟩ => ⟨w, imp w pw⟩
```

Patterns nest, so a conjunction inside an existential can be
unpacked in the same binder. Here we eliminate an existential and
then immediately introduce a new one, reusing the witness we were
handed.
```lean
example {α : Type} (P Q : α → Prop) :
    (∃ x : α, P x ∧ Q x) → (∃ x : α, Q x ∧ P x) :=
  fun ⟨w, pw, qw⟩ => ⟨w, qw, pw⟩
```

Existentials and negation combine as expected. A witness that
*fails* a predicate refutes the claim that the predicate holds
universally: unpack the counterexample, apply the universal claim
to that witness, and hand the result to the negation.
```lean
example {α : Type} (P : α → Prop) :
    (∃ x : α, ¬P x) → ¬(∀ x : α, P x) :=
  fun ⟨w, notPw⟩ =>
    fun allP => notPw (allP w)
```

Finally, the boundary. The witness genuinely cannot escape the
match. `Exists` lives in `Prop`, so a proof of an existential may
be taken apart to build another *proof*, but not to compute a
*value*. The following is rejected by Lean, and the error is worth
reading: `recursor Exists.casesOn can only eliminate into Prop`.
We were asking proof-level evidence to yield data.
```lean
/-
example : (∃ n : Nat, n > 3) → Nat :=
  fun ⟨w, _⟩ => w
-/
```

This is the same phenomenon we met with classical negation
elimination. `∃` is a logical claim of existence. When we want a
witness *as data*, usable in later computation, we need a value in
`Type`, such as a `Subtype` or a dependent pair `Σ`, rather than a
proof in `Prop`.
```lean
example
  (em : ∀ (X : Prop),  X ∨ ¬X) :
  ¬(P ∧ Q) → ¬P ∨ ¬Q :=
  fun npandq =>
    match (em P) with
    | Or.inl p =>
      match (em Q) with
      | Or.inl q =>  False.elim (npandq (And.intro p q))
      | Or.inr nq => Or.inr nq
    | Or.inr np => Or.inl np
```


<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

