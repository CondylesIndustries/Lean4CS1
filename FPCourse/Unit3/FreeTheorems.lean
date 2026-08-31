-- FPCourse/Unit3/FreeTheorems.lean
import Mathlib.Data.List.Basic

/-! @@@
# Interlude: Free Theorems — What a Signature Alone Forbids

This short unit sits between Week 8 (Higher-Order Functions) and Week 9
(Specifications).  It teaches a kind of correctness that needs **no proof term
and no decision procedure** — the guarantees you get from a *parametrically
polymorphic type* by itself.

The readings are **Reynolds, _Types, Abstraction and Parametric Polymorphism_
(1983)** and **Wadler, _Propositions as Types_ (2015)** — Week 6 of the Software
Logic schedule.  Reynolds' *abstraction theorem* is the precise statement that a
polymorphic function must treat its abstracted type *uniformly*.  Wadler's slogan
"theorems for free" is the working name for the consequences.

## The one idea

When a function is polymorphic in a type `α`, its code is handed a type it cannot
name.  It cannot test a value of `α`, cannot compare two of them, and cannot
manufacture one from nothing.  The *only* values of `α` it can return are the ones
it was given.  That single restriction pins down behaviour so tightly that we can
read real theorems straight off the type — before writing a line of proof.

The reading question for every signature below is one and the same:

> **What does this type forbid every inhabitant from doing?**

## Where this sits in the verification story

Three tiers of "the compiler accepted it, so it is correct" (see
`VERIFICATION_TIERS.md`):

- **Tier 1 — decide-checkable.**  A *decidable* proposition closed by `decide`;
  the evidence is a computation.  Bounded to enumerable domains (Week 7).
- **Tier 2 — type-guaranteed.**  Properties true of *every* inhabitant of a type,
  forced by parametricity, with no proof written at all.  **This unit.**
- **Tier 3 — proof-carrying.**  A refinement type `{ x // P x }` whose inhabitant
  *contains* a proof of `P` that you must supply (Week 9, Week 11).

Tier 2 is the only tier where correctness follows from the *type alone*.  It has
no analogue in an assertion-after-the-fact discipline such as Hoare logic
(Hoare 1969, Week 5): there a property is a separate formula you attach and
discharge; here the property is already *true by the time the type is written*.

A note on honesty: Lean does not *prove* these free theorems for you (it has no
built-in parametricity).  We do not prove them here either — this unit is about
*reading* them.  The `#eval` lines below **demonstrate** a free theorem on
concrete inputs; they are illustrations, not the theorem, exactly as a Tier-1
`decide` on one instance is not the `∀`.
@@@ -/

namespace FreeTheorems

/-! @@@
## 1  `∀ α, α → α` has essentially one inhabitant

Given an unknown type `α` and one value of it, return a value of `α`.  The
function cannot inspect its argument and cannot invent an `α`.  The only `α` in
sight is the one passed in, so it must return that one: the identity.

The free theorem for this type: for every `g : α → β`,

  `g (f α x) = f β (g x)`.

("Applying `g` before or after `f` gives the same result" — `f` is *natural*.)
@@@ -/

def myId : ∀ α : Type, α → α := fun _ x => x

#check (@myId)                       -- ∀ (α : Type), α → α

-- Naturality demonstrated with g = toString (which even changes the type α):
#eval myId String (toString 3)       -- "3"   =  g (f 3)
#eval toString (myId Nat 3)          -- "3"   =  f (g 3)

/-! @@@
## 2  `∀ α, α → α → α` has exactly two inhabitants

Two values of the unknown type go in; one comes out.  With no way to inspect or
combine them, the function can only return the first or the second.  There are
precisely two total inhabitants — the two projections.
@@@ -/

def fst' : ∀ α : Type, α → α → α := fun _ x _ => x
def snd' : ∀ α : Type, α → α → α := fun _ _ y => y

#eval fst' Nat 7 9                   -- 7
#eval snd' Nat 7 9                   -- 9

/-! @@@
## 3  `∀ α, List α → Nat` can only measure shape

A number out of a list of *unknown* elements.  The code cannot look *inside* the
elements — they support no operations — so the result can depend only on the
list's shape, and ultimately on its length.  The free theorem: for every
`g : α → β`,

  `f (xs.map g) = f xs`.

Mapping any function over the input cannot change the output.
@@@ -/

def len' : ∀ α : Type, List α → Nat := fun _ xs => xs.length

#eval len' Nat ([1, 2, 3].map (· * 10))   -- 3   =  f (map g xs)
#eval len' Nat [1, 2, 3]                    -- 3   =  f xs

/-! @@@
## 4  `∀ α, List α → List α`: rearrange, drop, duplicate — never invent

Every element of the output was an element of the input; parametricity forbids
fabricating an `α`.  *Which* positions are kept, dropped, or repeated is chosen by
shape alone, independent of the values.  Two consequences, both free:

- `f` commutes with `map`:  `f (xs.map g) = (f xs).map g`  for every `g`.
- the length of `f xs` depends only on the length of `xs`.

`reverse`, `id`, `tail`, `take 2`, and `fun _ => []` all inhabit this type.
"Return the singleton of the largest element" does **not** — it would have to
compare elements the type forbids it to inspect.
@@@ -/

def rev' : ∀ α : Type, List α → List α := fun _ xs => xs.reverse

-- Naturality demonstrated on reverse with g = (· * 10):
#eval rev' Nat ([1, 2, 3].map (· * 10))   -- [30, 20, 10]   =  f (map g xs)
#eval (rev' Nat [1, 2, 3]).map (· * 10)    -- [30, 20, 10]   =  (map g) (f xs)

/-! @@@
## 5  `∀ α, List α → Option α`: a `none`, or an element you were given

The result is either `none` or `some` element drawn from the input, at a position
fixed by shape.  `head?`, `getLast?`, and `fun _ => none` inhabit it; "the maximum
element" does not.
@@@ -/

def head'' : ∀ α : Type, List α → Option α := fun _ xs => xs.head?

#eval head'' Nat [4, 5, 6]                 -- some 4
#eval head'' Nat ([] : List Nat)           -- none

/-! @@@
## The boundary of Tier 2 (this is the payoff)

Free theorems are powerful but they have an edge.  A polymorphic signature can
force *naturality*, *no-invention*, and *shape-only* behaviour — but it cannot
force a property that depends on the **values** the elements happen to have.

The clearest example is the one Week 9 needs.  No signature of the form
`∀ α, List α → List α` forces "the output is a permutation of the input":
`reverse` satisfies it, but `fun _ => []` inhabits the very same type and does
not.  "Sorted" is even further out of reach — sorting requires *comparing*
elements, which a fully polymorphic type forbids.

That is exactly why `CorrectSort` in Week 9 is a **Tier 3** obligation:
`{ f : List Nat → List Nat // CorrectSort f }` carries a proof because the type
alone cannot.  Tier 2 tells you what you get for free; its boundary tells you
where a proof becomes unavoidable.

## Reading is the inverse of building

The *Deriving Terms from Types* interlude (`FPCourse/Unit1/Derivation.lean`) taught
the forward direction: given a type, *build* an inhabitant by type-directed steps.
Free-theorem reading is the same skill run backwards: given a type, say what *every*
inhabitant must do — without building one.  Parametricity is the hinge.  When a
derivation is **forced**, the free theorem is **total**:

- `∀ α, α → α` — the derivation has one outcome (`fun _ x => x`), so the reading is
  absolute: every inhabitant is the identity.
- `∀ α, α → α → α` — the derivation has two outcomes (return the first / the
  second), so the reading is: every inhabitant is one of the two projections.

Do a *matched pair* on the same type and the correspondence becomes concrete — one
trace that builds, one paragraph that reads, meeting in the middle.

## Exercises

These are *reading* exercises: no proofs, no `decide`.  For each signature, answer
in English — what does the type forbid, and what must every inhabitant satisfy?

1. `∀ α, α → Bool`.  The result cannot depend on the value of `α` (there is no way
   to observe it).  State the free theorem, and give **every** total inhabitant.
   How many are there?

2. `∀ α β, (α → β) → α → β`.  There is exactly one total inhabitant.  Write it as a
   Lean `def`, and say in one sentence why no other is possible.

3. `∀ α, List α → List α → List α`.  Is `append` the only inhabitant?  Give **three**
   genuinely different inhabitants, and state the one thing all of them are
   forbidden to do.

4. Someone claims the type `∀ α, List α → List α` guarantees "the output is a
   permutation of the input."  Give a one-line counterexample inhabitant that
   refutes the claim, and explain which tier ("decide-checkable",
   "type-guaranteed", or "proof-carrying") the permutation property actually
   requires, and why.

5. `∀ α, (α → α) → α → α`.  Describe the inhabitants informally.  (Hint: how many
   times can the function apply its argument?)  This type is the Church encoding of
   a number — a preview of Week 14's Curry-Howard correspondence.

6. **Matched pair.**  Take the type `∀ α β, (α → β) → α → β`.
   (a) *Build:* give a derivation trace (as in the Derivation interlude) for an
       inhabitant, and show every step is forced.
   (b) *Read:* in one paragraph, state what the free theorem guarantees about the
       single inhabitant — i.e. what it must do to its arguments and what it cannot
       do.  Confirm that (a) and (b) describe the same function.
@@@ -/

end FreeTheorems
