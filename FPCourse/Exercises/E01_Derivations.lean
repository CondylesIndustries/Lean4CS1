/- @@@
# What are derivations?

In writing about deductive proofs the notions of
introduction and elimination rules are central.


## Introduction Rules

The term, *introduction rule*, refers to a way to
*construct* a value of a given type. In languages
like Lean, an introduction rule is a *constructor*
of a type. So if a type *T* has a constructor *mk*,
one can call *T.mk* an introduction rule for *T*.

As an example, the polymorphic type, *Prod α β*,
has a single constructor actually called *mk*. It
takes two separate values, *a : α* and *b : β* and
yields a single value, *(a, b)*, the ordered pair
with *a* as its first element and *b* as second.

*Prod.mk* is the single *introduction rule* of any
*Prod* type. Lean defines *(a, b)* as a concrete
notation for *Prod.mk a b*.

If one's goal to build such a value, then (a) one
must already have values, *a : α* and *b : β*, to
which (b) one then applies the introduction rule
to these values. Recall also that α × β is notation
for *Prod α β.
@@@ -/

/- @@@
A derivation of a value of type Nat can be as
simple as a single application of one of the two
*Nat* introduction rules: *zero* or *succ n*. A
derivation here is just one step long. The same
goes for String, like *Nat* with two constructors,
*nil* and *cons a l*. The *nil* value represents
an empty list. The *cons* constructor constructs
a list by pre-pending *a* to given smaller list,
*l*.
@@@ -/

def n : Nat   := Nat.zero   -- single step derivation
def b : Bool  := Bool.true  -- another one, for Bool
def nb    : Nat × Bool := Prod.mk n b  -- yet another
def nb'   : Nat × Bool := (0, true)   -- just notation

-- Use top-down type-driven derivation
def nb''  : Nat × Bool :=
  Prod.mk
    Nat.zero
    Bool.true

/- @@@
The term, *elimination rule*, by contrast, refers
to a fundamental way to *use* a value of a given
type. If given a value of type Prod Nat Bool, for
example, the *two* elimination rules  *destructure*
the pair, using pattern matching, to get handles on
the individual elements of the pair. The first of
the elimination rules, *Prod.fst* returns the first
element of a given pair, and *Prod.snd*, the second.
@@@ -/

#eval nb              -- a pair we want to *use*
#eval nb.fst          -- extract first element
#eval nb.snd          -- extract second element

/- @@@
## → Introduction and Elimination

To construct a value of a function type, α → β,
use the single → introduction rule. In English,
it says this: *assume* you are given a value of
type α and then show one can derive and return a
values of types β.
@@@ -/

def getFst : Nat × Bool → Nat :=
  fun ns =>       -- → introduction (assume ns)
  (
    ns.fst        -- Prod elimination (first)
  )

/- @@@
To use a value of a function type, you *apply* it
to arguments to obtain return values.
@@@ -/

#eval getFst nb     -- → elimination (application)

/- @@@
Now we can put these principles together to derive
a proof/value of this type: α × β → β × α. A value
of this type will be a function that *assumes* it is
give an argument, (a, b), of type α × β, and that
then return a value of type β × α.
@@@ -/

-- a "bottom up" derivation
def swap : α × β → β × α :=
  fun ab =>             -- → intro
    let a := ab.fst     -- × elim
    let b := ab.snd     -- × elim
    (b, a)              -- × intro

-- a top down derivation
def swap' : α × β → β × α :=
  fun ab =>             -- → intro
    (
      ab.snd,
      ab.fst
    )    -- × intro
