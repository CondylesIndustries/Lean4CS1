-- INTRODUCTION RULES

-- Nat.zero
-- Nat.succ n

def n : Nat := Nat.zero     -- Nat.intro_zero
def m : Nat := Nat.succ n   -- Nat.intro_succ

def b : Bool := Bool.true   -- Bool.intro_true
def c : Bool := Bool.false  -- Bool.intro_false

def nb : Nat × Bool :=      -- × means Prod Nat Bool
  Prod.mk n b               -- Prod.intro

def nb' : Nat × Bool :=      -- × means Prod Nat Bool
  (                          -- Prod.mk Prod intro
    Nat.zero,                -- Nat.intro_zero
    Bool.false               -- Bool intro false
  )

-- ELIMINATION

def NB2Nat : (Nat × Bool) → Nat :=
  fun (p : Nat × Bool)  =>   -- → introduction
   Prod.fst p

def NB2Nat' : (Nat × Bool) → Nat :=
  fun (p : Nat × Bool)  =>    -- → introduction
   p.1                        -- Prod elim_1

#eval NB2Nat nb
#eval NB2Nat' nb

def NB2Bool : (Nat × Bool) → Bool :=
  fun p =>                    -- → introduction
    p.2                       -- Prod elim_2


/- @@@
Conjecture: Type product (×, times) is commutative.

This statement asserts that if you have *any* types,
call them α and β, there is a total function, call it
*swap*, that converts *any* ordered pair, *(a, b)* of
type *α × β* into the corresponding pair, *(b, a)* of
type *(β × α)*.

Moreover, there is an essential correctness condition
for any implementation of such a function: namely that
for any (a : α), (b : β), *swap (swap (a, b)) = (a, b)*.
In other words, `swap` applied twice is the *identity*
function for product

To gain deeper intuition it certainly helps to start
with simple concrete examples. So let's assume for now
that *α = Nat* and *β = Bool* and we'll just hardwire
these choices in our first examples.

To begin, let's prove, by simply programming, that
there is way, from *any* pair *(n, b) : Nat × Bool*
to derive a pair, *(b, n)* of type *Bool × Nat*. A
derivation of this form is just a *total function* of
type *(Nat × Bool) → (Bool × Nat)*.
@@@ -/

-- specification
def swap_nat_bool : (Nat × Bool) → (Bool × Nat)
-- implementation
:= fun nb =>               -- → introduction
    let n := nb.1         -- × elimination left/1
    let b := nb.2         -- × elimination right/2
    (b, n)


/- @@@
Here's a more concise way to write it. To the left
of the `=>` we destructure the argument (just as in
javascript and other such languages). As usual this
operation binds names to subparts of the argument. On
the right, we assemble them (intro) in the result.
@@@ -/

-- Specification
def swap_nat_bool' : (Nat × Bool) → (Bool × Nat)
:= fun (n, b) => (b, n)

#eval swap_nat_bool (3, true)

/- @@@
The notion of swapping the elements of any ordered
pair is entirely sensible. It's general. It applies
not only to Nat-Bool pairs but to pairs of values of
any type.

We can express this in English by saying, if *α* and
*β* are any types, with *(a, b)* is any pair of values
of the product type, *α × β*, there is a way from that
to derive the pair *(b, a)* of type *(β × α).* Call it
*swap*.

We can translate this English description directly
using the *forall (∀)* construct from basic predicate
logic.
@@@ -/

-- Specification
def swap'' :
  ∀                 -- forall ..., for any ..., for every ...
    (α : Type u)    -- for any type α
    (β : Type u),   -- for any type β
    α × β → β × α   -- from any α-β pair, derive a β-α
-- Implementation
:= fun α β (a, b) => (b, a)

-- Let's clean it up. First implicit arguments
def swap' :
  ∀                 -- forall ..., for any ..., for every ...
    {α : Type u}    -- for any type α
    {β : Type u},   -- for any type β
    α × β → β × α   -- from any α-β pair, derive a β-α
-- Now we omit explicit α and β arguments; they're inferred
:= fun (a, b) => (b, a)


-- Declare α and β together, bind both of them early, ∀ implicit
def swap {α β : Type u} : α × β → β × α := fun (a, b) => (b, a)

#eval swap (0, false)
#eval swap ("No", "Way")

-- works but Lean can't print function values
-- #eval swap (@swap Nat Bool, @swap' Bool Nat)


/- @@@
Finally, a correctness condition: swap is involutive!
What that means is that applying it to any pair then
applying it to the result returns the original input.
@@@ -/


/- @@@
And now for some actual logic!
@@@ -/



theorem andExample : (7 > 0) ∧ (7 ≤ 10) :=
  And.intro
    (by decide)
    (by decide)

theorem impExample : (7 > 0) ∧ (7 ≤ 10) → (7 ≤ 10) ∧ (7 > 0) :=
  fun conj =>       -- → introduction
    (
      And.intro     -- And introduction analogous to × introduction
        conj.2      -- And.elim_2/right
        conj.1      -- And.elim_1/left
    )

theorem impEx2 {P Q : Prop} : P ∧ Q → Q ∧ P :=
  fun pq =>         -- → introduction
    And.intro       -- And introduction
      pq.right      -- And.elim_right
      pq.left       -- And.elim_left

/- @@@
QED: This proves that for any propositions, P and Q
their logical conjunction, *P And Q*, with standard
notation, P ∧ Q, is *commutative*. One can also say
that conjunction (*And*) commutes.
@@@ -/

/-@@@
Now finally compare this with
@@@ -/
