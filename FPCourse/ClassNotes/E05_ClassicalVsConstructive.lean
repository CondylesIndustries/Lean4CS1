/- @@@
# Classical vs. Constructive Logic
@@@ -/

/- @@@
## Negation in Classical and Constructive Logic

We now turn to the interplay between negation and the two logics.
DeMorgan's laws expose the first asymmetry: some directions hold
constructively and some need an extra classical assumption. From
there we distinguish proof by negation from proof by contradiction,
and isolate excluded middle as the single assumption that bridges
the gap.
@@@ -/

/- @@@
### DeMorgan's Laws

For arbitrary propositions P and Q, negation distributes over
disjunction in both directions, constructively:
  ¬(P ∨ Q) ↔ (¬P ∧ ¬Q).

For conjunction, only (¬P ∨ ¬Q) → ¬(P ∧ Q) holds constructively
in general. The reverse implication,
  ¬(P ∧ Q) → (¬P ∨ ¬Q),
does not: knowing that P and Q cannot both hold does not give us
a choice of which one to refute. A proof of the disjunction must
provide either a proof of ¬P or a proof of ¬Q. Excluded middle
would let us split on P, but is not available constructively.
@@@ -/

-- Warmup: Negation

theorem noContradiction {P : Prop} : ¬(P ∧ ¬P) :=
 fun pandnotp =>
  let p : P := pandnotp.left
  let np : ¬P := pandnotp.right
  np p


-- example { P : Prop } : ¬¬P → P :=
--   fun nnp =>
--     _

theorem deMorganNotOr (P Q : Prop) : ¬(P ∨ Q) → (¬P ∧ ¬Q) :=
  fun notPorQ =>
    And.intro
      (fun p => notPorQ (Or.inl p))
      (fun q => notPorQ (Or.inr q))

theorem deMorganAndNot (P Q : Prop) : (¬P ∧ ¬Q) → ¬(P ∨ Q) :=
  fun notPandNotQ =>
    fun porq =>
      match porq with
      | Or.inl p => notPandNotQ.left p
      | Or.inr q => notPandNotQ.right q

theorem deMorganOrNot (P Q : Prop) : (¬P ∨ ¬Q) → ¬(P ∧ Q) :=
  fun notPorNotQ =>
    fun pandq =>
      match notPorNotQ with
      | Or.inl notP => notP pandq.left
      | Or.inr notQ => notQ pandq.right


theorem deMorganNotOrIff (P Q : Prop) : ¬(P ∨ Q) ↔ (¬P ∧ ¬Q) :=
  Iff.intro (deMorganNotOr P Q) (deMorganAndNot P Q)

/- @@@
Trying the reverse direction: choose the left disjunct, ¬P,
and assume P. To use ¬(P ∧ Q) to get False, we still need Q,
but nothing supplies it. Choosing the right disjunct instead
leaves the symmetric problem of needing P.

`#guard_msgs` checks the expected error, so this intentionally
unfinished attempt does not prevent the file from compiling.
@@@ -/

/--
error: don't know how to synthesize placeholder for argument `right`
context:
P Q : Prop
notPandQ : ¬(P ∧ Q)
p : P
⊢ Q
-/
#guard_msgs in
example (P Q : Prop) : ¬(P ∧ Q) → (¬P ∨ ¬Q) :=
  fun notPandQ =>
    Or.inl (fun p => notPandQ (And.intro p _))

example (P Q : Prop) : (¬P ∨ ¬Q) → ¬(P ∧ Q) :=
  fun notPorNotQ =>
    fun pandq =>
      match notPorNotQ with
      | Or.inl notP => notP pandq.left
      | Or.inr notQ => notQ pandq.right

/--
error: don't know how to synthesize placeholder
context:
P Q : Prop
em : ∀ (X : Prop), X ∨ ¬X
⊢ ¬(P ∧ Q) → ¬P ∨ ¬Q
-/
#guard_msgs in
example (P Q : Prop)  (em : ∀ (X : Prop), X ∨ ¬X) : ¬(P ∧ Q) → (¬P ∨ ¬Q) :=
  _

/- @@@
### Proof by Negation and by Contradiction

Constructively, we can prove ¬P by assuming P and deriving False:
that is exactly what a proof of P → False does. The theorem above
uses this reasoning to prove that P and ¬P cannot both hold. This
*proof strategy* is properly called *proof by negation*. It is not
*proof by contradiction*, even though deriving a contradiction is
the key step.

But suppose we want to prove P by assuming ¬P and deriving False.
What we have constructed is (¬P → False), which is ¬¬P. In general,
constructive logic does not let us turn this into a proof of P.
This extra step is called double-negation elimination, or the
classical rule of proof by contradiction.

Here is where a term-mode attempt gets stuck. `False.elim` can
produce P from False, but to get False from `notNotP` we must
supply a proof of ¬P. We have no such proof. The hole below asks
for exactly that missing input. This illustrates the obstruction;
a failed attempt alone is not a proof of unprovability.
@@@ -/

/--
error: don't know how to synthesize placeholder
context:
P : Prop
notNotP : ¬¬P
⊢ ¬P
-/
#guard_msgs in
example (P : Prop) : ¬¬P → P :=
  fun notNotP => False.elim (notNotP _)

/- @@@
### One Additional Assumption: Excluded Middle

Put a single additional assumption on the left of an implication:

  (∀ P : Prop, P ∨ ¬P) → (∀ P : Prop, ¬¬P → P).

Call the supplied proof `em`. Its type is ∀ P : Prop, P ∨ ¬P.
Under Curry-Howard, this is a machine: give it any proposition P,
and `em P` gives us a *proof* of P ∨ ¬P, for free! We supply no
evidence about P. Its output is a proof-bearing disjunction:
either `Or.inl p`, carrying a proof p of P, or `Or.inr notP`,
carrying a proof notP of ¬P. It is not just a Boolean answer.
We are assuming this machine, not implementing a constructive
algorithm that decides every proposition.

Now split on the proof `em P`. In the first case we already have
the desired proof of P. In the second case we have precisely the
proof of ¬P missing above. Applying `notNotP` to it gives False,
and `False.elim` turns that contradiction into a proof of P.
@@@ -/

theorem proofByContradictionFromExcludedMiddle :
    (∀ P : Prop, P ∨ ¬P) → (∀ P : Prop, ¬¬P → P) :=
  fun em =>
    fun P =>
      fun notNotP =>
        match em P with
        | Or.inl p => p
        | Or.inr notP => False.elim (notNotP notP)

/- @@@
All steps in this proof are constructive uses of the supplied
assumption. The classical power comes from `em`: keeping it on
the left makes explicit what the proof-by-contradiction rule needs.
@@@ -/

/- @@@
## Constructive and Classical Logic in Lean

Constructive logic requires evidence for the claims we make;
it does not supply P ∨ ¬P for every arbitrary proposition P.
Classical logic adds excluded middle (or an equivalent principle),
so general proof by contradiction becomes available. Both logics
allow us to derive any proposition from a proof of False.

In Lean, we can write `open Classical` and then use `em P` to
obtain a proof of P ∨ ¬P. Opening the namespace only makes names
such as `Classical.em` available as `em`; it does not itself make
a proof classical. Using this principle supplies the classical
power. We can also write `Classical.em P` without opening anything.
Although we often call excluded middle an axiom of classical logic,
Lean's `Classical.em` is a theorem derived using its underlying
axioms, including classical choice.

The example below supplies the proof machine from Lean's library,
so we no longer need to ask for it as an explicit assumption.
The two cases are exactly the ones in our previous proof.
@@@ -/

open Classical

/- @@@
Here is the full type of the library's excluded-middle theorem:

  Classical.em : ∀ (P : Prop), P ∨ ¬P

It takes a proposition P and returns a proof of P ∨ ¬P, with no
proof about P required as input. `#check` displays its type;
`#print` displays its actual definition, including the library's
proof body. We use this existing theorem rather than declare a
new axiom.
@@@ -/

#check (em : ∀ (P : Prop), P ∨ ¬P)
#print em

/- @@@
Here then is the elimination rule for negation, which is *not*
constructively valid.
@@@ -/
example (P : Prop) : ¬¬P → P :=
  fun notNotP =>
    match em P with
    | Or.inl p => p
    | Or.inr notP => False.elim (notNotP notP)

/- @@@
## The Tradeoff: Proofs Without Executable Constructions

With `em`, we gain the general rule of proof by contradiction:
from ¬¬P we can prove P. The price is that our proof now relies
on a machine for which we have no executable implementation.
`em P` supplies a proof of P ∨ ¬P, but it is not an algorithm
we can run to discover which side holds for an arbitrary P.

Look again at the match above. Each branch tells us what to do
with its evidence: return p, or derive False from notP. Those
branches are explicit, but `em` does not supply executable code
to select a branch. Thus this proof of ¬¬P → P is a valid logical
construction, not a general executable procedure for turning a
proof of ¬¬P into a constructively computed proof of P.

Lean still checks the entire proof term, including both branches;
classical reasoning does not bypass proof checking. What we lose
is the guarantee of a computational interpretation for this step.
In Lean, proofs in `Prop` are erased during compilation anyway,
including constructive proofs. So going classical does not delete
existing program code. Rather, using `em` adds a logical capability
without adding an executable implementation of that capability.
@@@ -/

/- @@@
### A Concrete Case: Is There an Odd Perfect Number?

Before any Lean, here is the question.

Call a positive number *perfect* if it is the sum of its proper
divisors, meaning its divisors other than itself. 6 is perfect:
its proper divisors are 1, 2, and 3, and 1 + 2 + 3 = 6. So is 28,
since 1 + 2 + 4 + 7 + 14 = 28. Perfect numbers appear in Euclid's
*Elements*, so people have been studying them for a very long time.

Every perfect number anyone has ever found is even. Nobody has
produced an odd one, and nobody has proved that none exists. This
is not for lack of effort: it is known that an odd perfect number,
if there is one, must be greater than 10^2200, and must satisfy a
long list of further constraints. The question

  Is there an odd perfect number?

is one of the oldest unresolved questions in mathematics.

Hold that question in mind. We are now going to pose it to Lean
and watch exactly what classical logic hands back.
@@@ -/

/- @@@
First, the part that is ordinary programming. Summing the proper
divisors of a number is a computation. Every proper divisor of n
is smaller than n, so it suffices to scan the numbers below n.
Don't worry about the programming of this function for now.
@@@ -/

def sumProperDivisors (n : Nat) : Nat :=
  (List.range n).foldl
    (fun acc d => if d > 0 && n % d == 0 then acc + d else acc) 0

def isPerfect (n : Nat) : Bool := n > 0 && sumProperDivisors n == n

/- @@@
These are total functions, and we can run them. Lean prints the
results below, and `#guard_msgs` checks that they are what we
claim they are.
@@@ -/

#eval sumProperDivisors 28

/-- info: true -/
#guard_msgs in
#eval isPerfect 28

/- @@@
Searching a *bounded* range is also ordinary programming. Here
are all the perfect numbers below ten thousand. This is a real
mathematical result about a finite range, and the code that
produced it is the evidence: we can rerun it, and we can read it
to see what it checked.
@@@ -/

/-- info: [6, 28, 496, 8128] -/
#guard_msgs in
#eval (List.range 10000).filter isPerfect

/- @@@
Look at that output: 6, 28, 496, 8128. Every one of them is even.
That is the observation that makes the open question interesting,
and we just computed it ourselves.

Testing whether a *given* number is an odd perfect number is
equally ordinary. 28 is perfect but even, so it fails.
@@@ -/

def isOddPerfect (n : Nat) : Bool := n % 2 == 1 && isPerfect n

/-- info: false -/
#guard_msgs in
#eval isOddPerfect 28

/- @@@
So far nothing is in doubt. Each function above carries executable
content, and every answer we got came out of running it.

The open question is the *unbounded* one. We are not asking about
any particular n, or about any finite range of them. We are asking
whether there is any such n at all. As a proposition:
@@@ -/

def SomeOddPerfect : Prop := ∃ n, isOddPerfect n = true

/- @@@
Now watch how cheap the classical answer is. A single application
of excluded middle settles the disjunction, right now, with no
search whatsoever.
@@@ -/

theorem oddPerfectOrNot : SomeOddPerfect ∨ ¬SomeOddPerfect :=
  em SomeOddPerfect

/- @@@
That is a complete proof, and Lean checks it. Read carefully what
we have and what we do not have. We have a proof that the question
has an answer. We do not have the answer. No n comes out of
`oddPerfectOrNot`, and there is nothing in it to run. A question
that has resisted mathematicians for centuries was not settled
here; only the claim that it has *some* answer was, and that claim
was free.

The gap turns into a compiler error the moment we try to *use* the
answer in a program. Recall that this chapter did `open Classical`,
which brings `Classical.propDecidable` into scope. That makes every
proposition count as `Decidable`, so the `if` below typechecks:
Lean accepts it as a well-formed program that branches on whether
an odd perfect number exists. Then code generation runs, and fails.
The error names exactly what is missing.
@@@ -/

/--
error: failed to compile definition, consider marking it as 'noncomputable' because it depends on 'propDecidable', which is 'noncomputable'
-/
#guard_msgs in
def oddPerfectAnswer : String :=
  if SomeOddPerfect then "one exists" else "none exists"

/- @@@
We are allowed to keep the definition if we mark it
`noncomputable`, because that marking is an honest declaration
that no code will be produced for it. The definition is then
accepted, and `#eval` still cannot run it.
@@@ -/

noncomputable def oddPerfectAnswer' : String :=
  if SomeOddPerfect then "one exists" else "none exists"

/--
error: failed to compile definition, consider marking it as 'noncomputable' because it depends on 'oddPerfectAnswer'', which is 'noncomputable'
-/
#guard_msgs in
#eval oddPerfectAnswer'

/- @@@
Compare the two halves of this example. `isPerfect` and the
bounded filter are constructions: they carry executable content,
and we extracted real answers from them. `oddPerfectAnswer` is a
proof dressed up as a program. Classical logic gave us the
proposition "this question has an answer" for free, and gave us
no way to compute the answer. That is the tradeoff of this
section, priced in code.

One caution about what this example does and does not show. For
this one fixed question, some constant program is correct: either
"one exists" or "none exists" is the right answer, and we simply
do not know which. So what failed here is *extraction*. The
classical proof does not hand us a program, even though a correct
program exists.

### Another Example: The Halting Problem

The stronger claim is about `em` read uniformly, as the machine
`∀ P : Prop, P ∨ ¬P` that answers for *every* P. No such machine
can have executable code. To see why, specialize it to
propositions of the form `∃ n, f n = true` for an arbitrary
`f : Nat → Bool`, which is the shape of `SomeOddPerfect`. A
program implementing that case would decide whether an arbitrary
computation ever succeeds, and that is the halting problem, which
is known to be undecidable. So the absence of code behind `em` is
not a gap in Lean's implementation that a better compiler might
close. It is a theorem about computation.
@@@ -/
