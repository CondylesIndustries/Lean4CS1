import Mathlib.Algebra.Group.Defs
import Mathlib.Algebra.Module.Defs
import Mathlib.Data.Real.Basic

/- @@@
# Affine Spaces: Groups Acting on Structure-Free Geometry

## What Affine Spaces Are: Geometry Without an Origin

Last class we saw that a *torsor* is a set `T` where a group `G` acts
in two special ways: *freely* (no non-identity element fixes any point)
and *transitively* (any two points are related by some group element).

An *affine space* is a torsor with a specific structure: we have a group `V`
(the "displacement vectors") acting on a set `P` (the "points") in a torsor fashion.
The group structure on `V` lets us describe how displacements compose:
to move from point `p` to point `q` by displacement `v`, we compute `p + v`.
The freeness and transitivity of the action mean every pair of points has a unique
displacement vector relating them, and conversely, every vector can translate
any point to some other point.

Why does this matter? Because it captures *pure geometry* -- the essence
of space without imposing a choice of origin. In a vector space, there's
a distinguished point: the zero vector, which is both an algebraic and
geometric identity. In an affine space, there's no such point. All points
are equivalent, related only through the group action.

Examples: points in a Euclidean plane, events in spacetime (with vectors
representing intervals), locations on a calendar (with integer vectors
representing day offsets), positions in a color space.

An affine space has two core operations:
  - *Point translation*: given point `p` and vector `v`, compute `p + v` (new point)
  - *Vector subtraction*: given points `p` and `q`, compute `q - p` (displacement vector)

These must satisfy:
  - `p + (v + w) = (p + v) + w`  (translation is associative)
  - `p + 0 = p`                   (identity: adding zero vector doesn't move anything)
  - `(p + v) - p = v`             (subtracting a point from its translation recovers the vector)
  - `(q - p) + p = q`             (translating by the difference of two points reaches the second)
@@@ -/

namespace AffineSpaces

/- @@@
## Recap: `Group` (From E13)

We'll need the group structure we developed last class: an associative
operation with identity and inverses.
@@@ -/

class Group (α : Type) where
  op      : α → α → α
  id      : α
  assoc   : ∀ a b c, op (op a b) c = op a (op b c)
  idLeft  : ∀ a, op id a = a
  idRight : ∀ a, op a id = a
  inv     : α → α
  invLeft : ∀ a, op (inv a) a = id
  invRight: ∀ a, op a (inv a) = id

instance [Group α] : Add α where add := Group.op
instance [Group α] : Neg α where neg := Group.inv
instance [Group α] : Zero α where zero := Group.id

/- @@@
## `AffineSpace`: A Vector Space Acting on Points

An affine space pairs a set of points `P` with a group `V` (the
"vectors" or "displacements"). The group acts on points via a
translation operation. The structure enforces that this action is
both free and transitive, which means vectors are uniquely determined
by the points they connect.

Here, we bundle the translation operation (`vadd`) and its inverse
(`vsub`) with proofs that they satisfy the affine axioms. The `VAdd`
and `VSub` typeclasses provide standard notation: `v +ᵥ p` for translation
and `q -ᵥ p` for vector subtraction.
@@@ -/

class AffineSpace (V : Type) (P : Type) where
  [groupV : Group V]
  vadd    : V → P → P
  vsub    : P → P → V
  vaddAssoc : ∀ v w : V, ∀ p : P, vadd v (vadd w p) = vadd (groupV.op v w) p
  vaddZero  : ∀ p : P, vadd groupV.id p = p
  vsubAdd   : ∀ p q : P, vadd (vsub q p) p = q
  addVsub   : ∀ v : V, ∀ p : P, vsub (vadd v p) p = v

/- Standard notation typeclasses for affine operations -/
class VAdd (V : Type) (P : Type) where vadd : V → P → P
class VSub (P : Type) (V : Type) where vsub : P → P → V

instance [AffineSpace V P] : VAdd V P where vadd := AffineSpace.vadd
instance [AffineSpace V P] : VSub P V where vsub := AffineSpace.vsub

infixl:65 " +ᵥ " => VAdd.vadd
infixl:50 " -ᵥ " => VSub.vsub

/- @@@
## Instance 1: `Rat` × `Rat` (Rational Points in the Plane)

The rational plane is an affine space over the vector space `Rat × Rat`.
Points and displacement vectors are both pairs of rationals, but
conceptually they play different roles: vectors represent displacements,
points represent locations (with no special origin).

The translation operation is componentwise addition, and the subtraction
operation subtracts coordinates to recover the displacement vector.
@@@ -/

instance : Group (Rat × Rat) where
  op      := fun (a, b) (c, d) => (a + c, b + d)
  id      := (0, 0)
  assoc   := fun _ _ _ => by simp [Rat.add_assoc]
  idLeft  := fun _ => by simp
  idRight := fun _ => by simp
  inv     := fun (a, b) => (-a, -b)
  invLeft := fun (a, b) => by ext <;> simp [Rat.neg_add_cancel]
  invRight:= fun (a, b) => by ext <;> simp [Rat.add_neg_cancel]

instance : AffineSpace (Rat × Rat) (Rat × Rat) where
  groupV  := inferInstance
  vadd    := fun (v₁, v₂) (p₁, p₂) => (p₁ + v₁, p₂ + v₂)
  vsub    := fun (q₁, q₂) (p₁, p₂) => (q₁ - p₁, q₂ - p₂)
  vaddAssoc := fun (v₁, v₂) (w₁, w₂) (p₁, p₂) => sorry
  vaddZero := fun (p₁, p₂) => by
    ext <;> simp [Group.id]
  vsubAdd := fun (q₁, q₂) (p₁, p₂) => by
    ext <;> simp
  addVsub := fun (v₁, v₂) (p₁, p₂) => by
    ext <;> simp

/- @@@
This instance encodes a fundamental truth: the rational plane has no
distinguished origin. We can pick any point as a reference, and describe
all others relative to it via vectors. The structure guarantees that the
two directions of translation (point + vector, point - point) are inverses.
@@@ -/

/- With the VAdd instance, we can now write `v +ᵥ p` for translation.
   Example: translating point (2, 3) by vector (1, -1) gives (3, 2).
-/

/- @@@
## Instance 2: Decidable Equality Points Over ℚ Vectors

For a general decidable equality type `P` (the points), we can construct
an affine space where the vectors are `Rat` and the action is addition
of a rational scalar to... well, we'd need `P` to be a `Rat`-module, which
requires more structure. Instead, let's construct an affine space where
both `P` and `V` are the same type with decidable equality, and the action
is a free group action via an embedding `f : V → P → P`.

Actually, the cleanest general instance: treat `P` itself as a `Rat`
vector space (which we'll formalize next class), and then the affine
space is just `P` acting on itself.
@@@ -/

/- @@@
## Properties of Affine Spaces

Once we have an affine space, we can derive useful facts. For instance,
vector subtraction is a kind of "difference" operation: the vector that
takes us from one point to another is unique, and going from p to q to r
is the same as going directly from p to r.

This is captured in the affine space axioms: `vsubAdd` says that translating
by a difference recovers the target point, and `addVsub` says that the
difference of a translated point is the translation vector.
@@@ -/

/- @@@
The key insight: affine spaces capture *pure geometry* in the sense that
we can describe the relationships between points without choosing an origin.
The group action encodes all the geometric information we need.

In the next lesson, we'll generalize this further by building vector spaces
from scratch, which will let us construct affine spaces over arbitrary
vector spaces, not just ℚ × ℚ.
@@@ -/

end AffineSpaces
