-- FPCourse/Unit1/Week02_FunctionsSpecifications.lean
import Mathlib.Data.Nat.Basic
import Mathlib.Logic.Basic

/-! @@@
# Week 2: Functions and Specifications

## The dual reading of →

The arrow `→` has two readings that are always simultaneously true.

**Computational reading**: `α → β` is the type of functions from `α` to `β`.
A term of this type takes an input of type `α` and returns an output of
type `β`.

**Logical reading**: `P → Q` (where `P Q : Prop`) is the type of proofs
that P *implies* Q.  A term of this type is a function that converts any
proof of P into a proof of Q.

These are not two different symbols.  They are one symbol with two
readings.  A function *is* an implication proof; an implication proof *is*
a function.  This identity is the beginning of the Curry-Howard
correspondence, which we will name explicitly in Week 14.
@@@ -/

namespace Week02

/-! @@@
## 2.1  Defining functions
@@@ -/

-- Named function definition
def double (n : Nat) : Nat := n * 2
def square (n : Nat) : Nat := n * n

-- Anonymous function (lambda)
def double' : Nat → Nat := fun n => n * 2

-- Multi-argument functions are curried by default
def add3 (a b c : Nat) : Nat := a + b + c
-- add3 has type Nat → Nat → Nat → Nat
-- Applying one argument returns a function: Nat → Nat → Nat

-- Evaluation (β-reduction): each application substitutes the argument.
--   add3 1 2 3
--   ↝ (fun a b c => a + b + c) 1 2 3
--   ↝ 1 + 2 + 3                        (three β-reductions)
--   ↝ 6
#eval add3 1 2 3    -- 6
#eval (add3 1) 2 3  -- same: (add3 1) is a Nat → Nat → Nat waiting for two more args

/-! @@@
## 2.2  → as implication: logical reading

When `P` and `Q` are propositions, `P → Q` is the claim that P implies Q.
A proof of `P → Q` is a function that takes any proof of P and returns a
proof of Q.  This is indistinguishable from an ordinary function — because
it *is* an ordinary function.
@@@ -/

-- A proof of P → Q is a term of type P → Q.
-- Here: "if n + 0 = n, then n = n + 0"
theorem add_zero_comm (n : Nat) : n + 0 = n → n = n + 0 :=
  fun h => h.symm

-- Universal claims: ∀ n : Nat, P n
-- This is also a function type: (n : Nat) → P n
-- A proof supplies the function.
theorem add_zero_all : ∀ n : Nat, n + 0 = n :=
  Nat.add_zero

-- The ∀ and → are the same thing: ∀ n, P n is (n : Nat) → P n
-- when P does not mention types not in scope.

/-! @@@
## 2.3  The design recipe

Every function in this course is designed using the following steps.
English descriptions are written as Lean *docstrings* (`/-- ... -/`
placed immediately before a definition) so the tooling surfaces them
in hover text.

| Step | Activity |
|------|----------|
| 0. Description | Write a `/-- docstring -/` saying what the function does in plain English. |
| 1. Signature | Write the name, argument types, and return type. |
| 2. Specification | Write a `∀` proposition over the signature expressing what the output must satisfy. |
| 3. Examples | Write `#eval` checks with `-- expected` comments; once `#eval` is familiar, strengthen to `example : f x = v := rfl`. |
| 4. Template | Write the function body shape from the input types. |
| 5. Code | Fill in the body. |
| 6. Check | Verify the compiler accepts both the definition and the specification. |

The description comes first so you understand *what* before *how*.
The signature must precede the specification — the spec names the
function, so the `def` must exist before the `theorem` can be stated.
@@@ -/

-- Example: doubling a number.

-- Step 0 — Description:
/-- `double'' n` returns twice `n`. -/
-- Step 1 — Signature + Steps 4/5 Template and code:
def double'' (n : Nat) : Nat := n + n

-- Step 3 — Examples (two forms):
-- Form 1: #eval with expected value in comment (explore interactively)
#eval double'' 0    -- 0
#eval double'' 5    -- 10
-- Form 2: rfl-based test (machine-verified; both sides evaluate to the same normal form)
example : double'' 0 = 0  := rfl
example : double'' 5 = 10 := rfl

-- Step 2 — Specification (stated after the def, since it names double''):
--   ∀ n : Nat, double'' n = n + n
-- Step 6 — Check (provided proof):
-- Evaluation: double'' n ↝ n + n (δ-reduction).  Both sides are identical.
theorem double''_spec : ∀ n : Nat, double'' n = n + n :=
  fun n => rfl

/-! @@@
## 2.4  Function composition
@@@ -/

-- ∘ is function composition: (f ∘ g) x = f (g x)
def double_then_square : Nat → Nat := square ∘ double

#eval double_then_square 3    -- square (double 3) = square 6 = 36

-- Composition and identity satisfy algebraic laws.
-- These are propositions about functions — logical types.
theorem comp_id (f : α → β) : f ∘ id = f := rfl
theorem id_comp (f : α → β) : id ∘ f = f := rfl
theorem comp_assoc (f : γ → δ) (g : β → γ) (h : α → β) :
    (f ∘ g) ∘ h = f ∘ (g ∘ h) := rfl

/-! @@@
## 2.5  Connectives as types

Logical connectives are type constructors.  A proposition built with a
connective has the same structure as a product or sum type in computation.

| Connective | Type constructor | Introduction |
|------------|-----------------|--------------|
| `P ∧ Q` | like `P × Q` | `And.intro : P → Q → P ∧ Q` |
| `P ∨ Q` | like `P ⊕ Q` | `Or.inl : P → P ∨ Q` |
| `¬P` | `P → False` | a function from P to absurdity |
| `P ↔ Q` | `(P → Q) × (Q → P)` | `Iff.intro` |

@@@ -/

-- ∧ introduction: supply proofs of both conjuncts
example : 1 < 2 ∧ 2 < 3 :=
  And.intro (by decide) (by decide)

-- ∨ introduction: supply a proof of one disjunct
example : 1 = 1 ∨ 1 = 2 :=
  Or.inl rfl

-- ¬P is P → False
example : ¬ (1 = 2) :=
  by decide

-- ↔ introduction: supply both directions
example : (1 + 1 = 2) ↔ (2 = 1 + 1) :=
  Iff.intro (fun h => h.symm) (fun h => h.symm)

/-! @@@
## 2.6  Deriving terms from types

A term the compiler accepts is worth little if you found it by trial and error.
`#check` and the red squiggle are an *oracle* — they answer *accepted* or *rejected* —
but an oracle is not a *method*: it never tells you how to *arrive at* a term.
Type-directed derivation is the method.  The structure of the goal *type* dictates the
structure of the *term*, built top-down, each step forced or chosen for a stated
reason.  You should be able to **predict acceptance before you build**.

### Introduction and elimination

Each type constructor comes with a way to *build* a value (introduction) and a way to
*use* one (elimination) — the natural-deduction discipline we name in Week 14.

| Goal / hypothesis | Move | In Lean you write |
|---|---|---|
| goal `A → B` | →I: introduce the argument | `fun (a : A) => ?` — new goal `B`, with `a : A` |
| have `f : A → B`, `a : A` | →E: apply | `f a : B` |
| goal `A × B` | ×I: build a pair | `(?, ?)` — goals `A` and `B` |
| have `p : A × B` | ×E: project / match | `p.1`, `p.2`, or `match p with \| (a, b) => ?` |
| goal `A ⊕ B` | ⊕I: choose a side | `.inl ?` (goal `A`) or `.inr ?` (goal `B`) |
| have `s : A ⊕ B` | ⊕E: case-split | `match s with \| .inl a => ? \| .inr b => ?` |

Read the goal, pick the move its *outermost* constructor licenses, write that much of
the term, and read off the smaller goal(s) that remain.  Recall from §2.5 that `∧`
behaves like `×` and `∨` like `⊕`, so the *same* moves derive proofs of logical claims.

### How Lean shows you the goal

A hole `_` in a term is Lean *printing the goal*: it reports the expected type and the
local context — the "remaining goal" of your derivation.  The canonical demonstration
is in `FPCourse/specsAndImpls.lean` (`def e : Empty := _` reports `⊢ Empty`).  In VS
Code, type the hole and watch the **InfoView** shrink as you fill each step.  Use the
compiler as a *confirmer* of a step you predicted, not as a blind search engine.

### The derivation trace

Record a derivation as a short trace.  The trace — not the final term — is the artifact
you are graded on; the final term is its by-product.  `RULE` at each step is one of
`→I`, `→E`, `×I`, `×E`, `⊕I`, `⊕E`, or "use `h`".
@@@ -/

/-! @@@
**Worked derivation 1 — `Nat → Nat`.**
```text
DERIVATION of  addSelf : Nat → Nat
  goal: Nat → Nat
  step 1 [→I]    fun (a : Nat) => ?   ⟶ goal: Nat, with a : Nat
  step 2 [use a] a + a                ⟶ closed (a is the only Nat in scope)
  ∎
```
@@@ -/

def addSelf : Nat → Nat := fun a => a + a

/-! @@@
**Worked derivation 2 — `(P → Q) → (Q → R) → (P → R)`.**  Composition; under the logical
reading, transitivity of implication — one derivation certifies both.
```text
  step 1 [→I]  fun (f : P → Q) => ?   ⟶ goal: (Q → R) → (P → R)
  step 2 [→I]  fun (g : Q → R) => ?   ⟶ goal: P → R
  step 3 [→I]  fun (p : P) => ?       ⟶ goal: R, with f, g, p
  step 4 [→E]  f p : Q
  step 5 [→E]  g (f p) : R            ⟶ closed
```
@@@ -/

def compose {P Q R : Type} : (P → Q) → (Q → R) → (P → R) :=
  fun f g p => g (f p)

/-! @@@
**Worked derivation 3 — `A × B → B × A`.**
```text
  step 1 [→I]  fun (p : A × B) => ?   ⟶ goal: B × A, with p : A × B
  step 2 [×E]  p.1 : A,  p.2 : B
  step 3 [×I]  (p.2, p.1) : B × A     ⟶ closed
```
@@@ -/

def swapProd {A B : Type} : A × B → B × A :=
  fun p => (p.2, p.1)

/-! @@@
**Worked derivation 4 — `A ⊕ B → B ⊕ A`.**  The goal `B ⊕ A` would call for ⊕I, but
which side is right depends on the input — so eliminate the hypothesis first.
```text
  step 1 [→I]  fun (s : A ⊕ B) => ?
  step 2 [⊕E]  match s with .inl a => ? | .inr b => ?   ⟶ two goals B ⊕ A
  step 3 [⊕I]  .inr a   (case inl)    ⟶ closed
  step 4 [⊕I]  .inl b   (case inr)    ⟶ closed
```
@@@ -/

def swapSum {A B : Type} : A ⊕ B → B ⊕ A :=
  fun s => match s with
    | .inl a => .inr a
    | .inr b => .inl b

/-! @@@
### Grading the trace

A derivation exercise is graded on the **trace**, not merely on whether the term
compiles.  Full credit: (1) name the correct rule at each step; (2) state the remaining
goal after each step; (3) close every goal by a hypothesis in scope.  A term that
compiles but whose trace mis-names a rule or skips a goal is *not* full credit — it may
be correct by luck.

### The inverse direction

Derivation *builds* a term from a type.  Its inverse *reads* a type to learn what
**every** inhabitant must do — *free theorems*, developed in Week 7 (§7.2).  Where a
type is fully polymorphic the derivation is *forced* and the free theorem is *total*:
`∀ α, α → α` has one inhabitant; `∀ α, α → α → α` has exactly two.  Building a term from
a type and reading what every term of a type must do are one skill in two directions.
@@@ -/

/-! @@@
## 2.7  Reading function specifications

When a function's type contains propositions, the type IS the specification.
The examples below show how to read proof-carrying function types.
@@@ -/

-- The type tells you: given a proof that the list is nonempty,
-- return the first element.  No runtime null check needed.
#check List.head   -- (l : List α) → l ≠ [] → α
-- (Actual Lean name may vary; the pattern is the point.)

-- The type tells you: given proofs about the index being in bounds,
-- return the element at that index.
#check List.get    -- (l : List α) → Fin l.length → α
-- Fin n is the type of natural numbers < n.  It IS the bounds proof.

/-! @@@
## Exercises

1. Write a function `pred' : Nat → Nat` that returns the predecessor,
   treating 0 as 0.  Write its specification as a ∀ proposition.

2. What is the type of `And.intro`?  Use `#check` to find out.
   Explain in English what a term of that type represents both
   computationally and logically.

3. Use `#print Iff` to inspect the definition of `↔`.  What are its
   two fields?  Use `decide` to verify:
   (a) `(2 < 3) ↔ ¬(3 ≤ 2)`
   (b) `(True ∧ True) ↔ True`
   (c) `(True ∧ False) ↔ False`
   For each, state in English what the biconditional asserts.

4. Use `decide` to verify `¬ (True ∧ False)`.
   Then explain: what is the type of `¬ (True ∧ False)` in full,
   unfolding `¬` to `→ False`?

5. State (as a Lean `Prop`) the specification for a function
   `max' : Nat → Nat → Nat` that returns the larger of two numbers.
   Your specification should assert: (a) the result is ≥ both inputs,
   and (b) the result equals one of the two inputs.

Deriving terms (§2.6).  For 6–8, give a **derivation trace** and then the term; the
trace is the graded artifact.

6. Derive `andComm : P ∧ Q → Q ∧ P`.  (Computationally this is `A × B → B × A`; state
   which rule closes each goal.)

7. Derive `curry : (A × B → C) → (A → B → C)`.  How many `→I` steps appear before the
   first elimination, and why?

8. Derive `orElim : (A → C) → (B → C) → (A ⊕ B → C)`.  Name the step that must come
   before you can use either function, and why.

9. Method only (no term): for the target `(A → B → C) → B → A → C`, which introduction-
   or elimination-step must come **first**, and which hypothesis closes the final goal?
@@@ -/

end Week02
