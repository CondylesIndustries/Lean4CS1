# Verification tiers — a design note

*Status: draft for the FP Course (CS1). Companion reading: Software Logic Weeks 5, 6, 8, 11, 13.*

The course's central move is that **the specification lives in the type**, and that
"correct" often means "the compiler accepted this term at that type." That claim is
true — but it is true in *three different ways*, and they ask completely different
things of the student. Collapsing them into one slogan is where the design gets
into trouble (see Week 9, where `insertionSort_correct` is presented as "read this"
rather than "write this"). Naming the three tiers makes the claim honest and tells
us where assessment can legitimately sit.

## The three tiers

| Tier | Name | Lean mechanism | What the student produces | Evidence is… | Reading anchor |
| --- | --- | --- | --- | --- | --- |
| 1 | **decide-checkable** | `decide` on a decidable `Prop` | a proposition + the word `decide` | a *computation* | Claessen & Hughes 2000 (W12); Week 7 |
| 2 | **type-guaranteed** | a parametrically polymorphic type | a *type*, and a reading of what it forbids | *nothing* — parametricity | Reynolds 1983, Wadler 2015 (W6) |
| 3 | **proof-carrying** | a refinement type `{ x // P x }` | a term *containing a proof of `P`* | a *proof object* | Hoare 1972 (W11); Hoare 1969 (W5) |

### Tier 1 — decide-checkable

`decide` runs a decision procedure and the accepted term *is* the evidence. Real,
but bounded: it only closes decidable propositions over enumerable domains. On an
infinite domain, `decide` on a *concrete instance* is QuickCheck-grade evidence
(Claessen & Hughes) — confidence and counterexamples — **not** the universally
quantified theorem. Say this out loud whenever `decide` appears next to a `∀`.

### Tier 2 — type-guaranteed

Some properties hold of **every** inhabitant of a type, forced by Reynolds'
abstraction theorem, with **no proof written at all**. `∀ α, List α → List α`
cannot invent elements; `∀ α, List α → Nat` can only measure shape. This is the
*only* tier where correctness follows from the type **alone**, and it is the tier
with no analogue in SF or in any assertion-after-the-fact discipline. It is also
the tier the course currently under-exploits. The free-theorems material in Week 7
(§7.2) is tier 2 in pure form.

### Tier 3 — proof-carrying

`{ f : List Nat → List Nat // CorrectSort f }` looks like "just a type," but to
*construct* an inhabitant you must supply the proof component — and that proof is
exactly the object SF would make you write. Week 9's `insertionSort_correct` is
this tier, and its helpers are full inductive proofs (in `by`-mode, which the
course otherwise forbids), handed to the student **to read, not to produce**. That
is a legitimate pedagogical choice, but it must be *labelled* tier 3, or the
student who reaches the subtype exercise hits a cliff the earlier weeks disowned.

## Producing an inhabitant: derivation, not search

All three tiers require *producing* a term, and the course teaches one method for
doing so across all of them: **type-directed derivation** (Week 2 §2.6). The goal
type's outermost constructor licenses the next
introduction/elimination step; the term is built top-down, each step predicted and
then *confirmed* by the compiler rather than discovered by poking it. The graded
artifact is the **derivation trace**, not merely the accepted term — a term that
compiles by luck is not evidence the student can construct.

This is what keeps "the compiler is the grader" from degenerating into "the compiler
is the search engine." It also links the tiers to their inverse: free-theorem
*reading* (Tier 2) is derivation run backwards, and parametricity is what makes the
forward derivation deterministic — so the method bites hardest exactly where the
oracle is least necessary.

## Where assessment sits

**Assessment sits in tiers 1 and 2.** Both are things a student can *produce* under
the course's own constraints (no `by`, no `sorry`, compiler-as-grader):

- Tier 1 → the existing competencies "decidability identification" and
  "counterexample finding."
- Tier 2 → a new competency, **free-theorem reading**: given a signature, state
  what every inhabitant must satisfy and what the signature forbids. Proof-free,
  decidability-free, and impossible to fake by poking the compiler.

**Tier 3 is read, not produced.** Present its proofs as worked artifacts (as Week 9
already does) and assess only *comprehension* of them — never require the student to
author an inductive proof. This keeps "proof construction is not an assessment
target" true.

## "Correctness = typechecks" is the entry point, not the whole story

The slogan is an honest **entry point**: it lets a first-year student experience
machine-checked correctness on day one without a tactic language. But the design
should state plainly that **at scale the separated proof returns**. The two Week 13
readings are the evidence:

- **Leroy 2009 (CompCert)** — the compiler's correctness is a *separately proved*
  semantic-preservation theorem, not a typechecking artifact. Tier 3, industrial size.
- **Necula 1997 (Proof-Carrying Code)** — the code ships *with* an explicit proof
  object that the consumer checks. The "compiler as grader" you admire, but only
  after a proof was **produced**. Again tier 3.

So the honest arc is: *specification lives in the type; verification stratifies into
decide / free / proof-carrying; the flagship certified systems live in tier 3.* Told
this way, the contrast with SF is sturdier, because it stops overclaiming.

## Wiring the Hoare readings

Two Hoare papers already on the schedule anchor the two poles of this story, and
naming them makes the tiers land:

- **Hoare 1969, *An Axiomatic Basis for Computer Programming* (Week 5).** The
  assertion-after-the-fact world: `{P} C {Q}` are logical formulas *attached to*
  code, external to the program text. This is the SF paradigm in its birthplace, and
  the foil for tier 2 — there the property is a separate formula you attach and
  discharge; in tier 2 the property is already true by the time the type is written.
- **Hoare 1972, *Proof of Correctness of Data Representations* (Week 11).** The
  single most on-point paper for the abstract-types week and the best tier-3
  exemplar the course has. A representation invariant *is* a refinement type
  `{ r : Rep // Inv r }`; an abstraction function *is* the map from representation to
  abstract model; correctness *is* the operations commuting with that map and
  preserving the invariant. Have students write the invariant and the abstraction
  function **as types** — that is tier 3 made concrete, and it turns Liskov & Zilles
  (W6) and Liskov & Wing (W11) from prose into Lean.
  - Caveat to flag for students: Liskov–Wing *behavioral subtyping* and Lean's
    `{ x // P x }` *subset type* are a pun, not a synonym. Use the pun as a teaching
    moment, not a shortcut.
  - Logistics: per `READINGS.md`, Hoare 1972 is one of the two papers **not held
    locally** (closed access; read through the UVA library). The most on-point paper
    for Week 11 is the one you can't hand out as a PDF — plan the session around a
    library link or an in-class walkthrough.
