-- FPCourse/Unit1/Derivation.lean
import Mathlib.Logic.Basic

/-! @@@
# Interlude: Deriving Terms from Types — the Method

This interlude follows Week 2 (Functions and Specifications).  It teaches *how* to
produce a term the compiler accepts — not by trial and error, but by a repeatable
**method**.

## The compiler is a grader, not a method

`#check`, `#eval`, and the red squiggle are an **oracle**: hand them a term and
they answer *accepted* or *rejected*.  That is a grader.  It never tells you how to
*arrive at* an accepted term.  If your only technique is to perturb a term until
the error disappears, you have learned to satisfy the oracle, not to construct.  A
term that finally typechecks that way is correct *by luck* — you cannot say why it
had to work.

The method that replaces guessing is **type-directed derivation**: the structure of
the goal *type* dictates the structure of the *term*, built top-down, each step
forced or chosen for a stated reason.  You should be able to **predict acceptance
before you build**.

## The rules: introduction and elimination

Each type constructor comes with two moves — a way to *build* a value
(introduction) and a way to *use* one (elimination).  This is the natural-deduction
discipline we name explicitly in Week 14 (Curry-Howard); here we use it as a
construction procedure.

| Goal / hypothesis | Move | In Lean you write |
|---|---|---|
| goal `A → B` | →I: introduce the argument | `fun (a : A) => ?` — new goal `B`, with `a : A` in scope |
| have `f : A → B`, `a : A` | →E: apply | `f a : B` |
| goal `A × B` | ×I: build a pair | `(?, ?)` — two goals, `A` and `B` |
| have `p : A × B` | ×E: project / match | `p.1 : A`, `p.2 : B`, or `match p with \| (a, b) => ?` |
| goal `A ⊕ B` | ⊕I: choose a side | `.inl ?` (goal `A`) or `.inr ?` (goal `B`) |
| have `s : A ⊕ B` | ⊕E: case-split | `match s with \| .inl a => ? \| .inr b => ?` |

Read the goal, pick the move its *outermost* constructor licenses, write that much
of the term, and read off the smaller goal(s) that remain.  Repeat until every goal
is closed by a hypothesis in scope.

## How Lean shows you the goal (the confirmer)

A hole `_` in a term is not a failure to be poked away — it is Lean *printing the
goal*.  The elaborator reports the expected type and the local context, exactly the
"remaining goal" of your derivation.  The canonical demonstration is in
`FPCourse/specsAndImpls.lean`:

```
def e : Empty := _     -- Lean reports:  ⊢ Empty   (the goal, with no context)
```

In VS Code, type the hole and watch the **InfoView**: as you fill in each step, the
goal *shrinks*.  That shrinking is your method made visible.  Use the compiler this
way — as a **confirmer** of a step you already predicted — and treat an error as
feedback on a *derivation step*, not as the signal driving a blind search.

## A derivation trace

We record a derivation as a short trace.  The trace — not the final term — is the
artifact you are graded on.  The final term is its by-product.

```
DERIVATION of  h : T
  goal: T
  step 1 [RULE]  write …   ⟶ remaining goal(s): …
  step 2 [RULE]  write …   ⟶ remaining goal(s): …
  ∎  every goal closed; the compiling term appears below.
```

The `RULE` at each step is one of `→I `→E `×I `×E `⊕I `⊕E`, or "use `h`" when a
goal is closed directly by a hypothesis.
@@@ -/

namespace Derivation

/-! @@@
## Worked derivation 1 — `Nat → Nat`

```
DERIVATION of  double : Nat → Nat
  goal: Nat → Nat
  step 1 [→I]  fun (a : Nat) => ?      ⟶ remaining goal: Nat, with a : Nat in scope
  step 2 [use a, ×… no]  a + a : Nat   ⟶ goal closed (a is the only Nat in scope)
  ∎
```
@@@ -/

def double : Nat → Nat := fun a => a + a

#check (double)          -- Nat → Nat

/-! @@@
## Worked derivation 2 — `(P → Q) → (Q → R) → (P → R)`

This is function composition.  Under the logical reading it is the transitivity of
implication — the *same* derivation certifies both.

```
DERIVATION of  compose : (P → Q) → (Q → R) → (P → R)
  goal: (P → Q) → (Q → R) → (P → R)
  step 1 [→I]  fun (f : P → Q) => ?            ⟶ goal: (Q → R) → (P → R)
  step 2 [→I]  fun (g : Q → R) => ?            ⟶ goal: P → R
  step 3 [→I]  fun (p : P) => ?                ⟶ goal: R,  with f, g, p in scope
  step 4 [→E]  f p : Q                         ⟶ now have a Q
  step 5 [→E]  g (f p) : R                     ⟶ goal closed
  ∎
```
@@@ -/

def compose {P Q R : Type} : (P → Q) → (Q → R) → (P → R) :=
  fun f g p => g (f p)

/-! @@@
## Worked derivation 3 — `A × B → B × A`

```
DERIVATION of  swapProd : A × B → B × A
  goal: A × B → B × A
  step 1 [→I]  fun (p : A × B) => ?            ⟶ goal: B × A,  with p : A × B
  step 2 [×E]  p.1 : A,  p.2 : B               ⟶ the two components are in hand
  step 3 [×I]  (p.2, p.1) : B × A              ⟶ goal closed
  ∎
```
@@@ -/

def swapProd {A B : Type} : A × B → B × A :=
  fun p => (p.2, p.1)

/-! @@@
## Worked derivation 4 — `A ⊕ B → B ⊕ A`

The outermost move on the *goal* `B ⊕ A` would be ⊕I — but we cannot choose a side
yet, because which side is right depends on the *input*.  So we eliminate the
hypothesis first (⊕E), and only then introduce.

```
DERIVATION of  swapSum : A ⊕ B → B ⊕ A
  goal: A ⊕ B → B ⊕ A
  step 1 [→I]  fun (s : A ⊕ B) => ?            ⟶ goal: B ⊕ A,  with s : A ⊕ B
  step 2 [⊕E]  match s with .inl a => ? | .inr b => ?
                                               ⟶ two goals, B ⊕ A;  case 1 has a : A, case 2 has b : B
  step 3 [⊕I]  case 1:  .inr a : B ⊕ A         ⟶ closed
  step 4 [⊕I]  case 2:  .inl b : B ⊕ A         ⟶ closed
  ∎
```
@@@ -/

def swapSum {A B : Type} : A ⊕ B → B ⊕ A :=
  fun s => match s with
    | .inl a => .inr a
    | .inr b => .inl b

/-! @@@
## The inverse direction

Derivation *builds* an inhabitant from a type.  Its inverse *reads* a type to learn
what **every** inhabitant must do — free theorems (the *Free Theorems* interlude,
`FPCourse/Unit3/FreeTheorems.lean`).  The two are one skill practised in opposite
directions, and parametricity is what links them: a polymorphic goal so constrains
the derivation that it becomes *deterministic*.

- `∀ α, α → α` — the derivation has **one** outcome: →I introduces `x : α`, and the
  only `α` in scope is `x`, so the term *must* be `fun _ x => x`.
- `∀ α, α → α → α` — →I twice yields `x y : α`; the goal `α` is closed by `x` **or**
  `y`, and nothing else — exactly **two** inhabitants.

Where a type is fully polymorphic, the method *forces* the answer and the oracle is
almost unnecessary; where a type is concrete (`Nat → Nat`), the method narrows the
space but you still choose.  Reading and building together make the type↔term
relationship a method you own, not a lottery the compiler adjudicates.

## Grading the trace

An inhabitation exercise is graded on the **trace**, not merely on whether the term
compiles.  A full-credit trace:

1. names the correct rule at each step (`→I`, `→E`, `×I`, `×E`, `⊕I`, `⊕E`, use `h`);
2. states the remaining goal after each step (goal-tracking, not just the answer);
3. closes every goal by a hypothesis in scope — no step unaccounted for.

A term that compiles but whose trace mis-names a rule or skips a goal is *not* full
credit: it may be correct by luck.  A trace that is correct but whose final term has
a typo the student can *see and fix from the goal* still earns most of the credit.

## Exercises

For 1–4, produce a **derivation trace** in the format above, then the compiling
`def`.  The trace is the graded artifact.

1. Derive `andComm : P ∧ Q → Q ∧ P`.  (Under the computational reading this is
   `A × B → B × A`; state which rule closes each goal.)

2. Derive `curry : (A × B → C) → (A → B → C)`.  How many `→I` steps appear before
   the first elimination, and why?

3. Derive `orElim : (A → C) → (B → C) → (A ⊕ B → C)`.  Name the step that *must*
   come before you can use either `A → C` or `B → C`, and say why.

4. Derive `apply : (A → B) → A → B`.  It has exactly one inhabitant — show the
   derivation is forced at every step.

For 5–6, answer in English only (method assessment; no term written):

5. Target type `(A → B → C) → B → A → C`.  Which introduction or elimination step
   must come **first**, and why?  Which hypothesis closes the final goal?

6. Target type `A ⊕ B → (A → C) → (B → C) → C`.  Explain why no derivation can
   choose between the two functions before a ⊕E step, and what the ⊕E step exposes
   in each branch.
@@@ -/

end Derivation
