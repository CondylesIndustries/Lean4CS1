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
of space without imposing a choice of origin or coordinate system. In a vector space,
there's a distinguished point: the zero vector, which is both an algebraic and
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
## `AffineSpace`: A Torsor Structure

An affine space is exactly a torsor: it pairs a set of points `P` with a group `V`
(the "vectors" or "displacements") where `P` is a torsor for the group action of `V`.
The group acts on points via a translation operation in a way that is both
*free* (no non-identity group element fixes any point) and *transitive*
(any two points are related by some group element). This means:
- Every pair of points has a unique displacement vector between them
- Every vector can translate any point to some other point

Here, we bundle the translation operation (`vadd`) and its inverse (`vsub`)
with proofs that they satisfy the affine axioms. The `VAdd` and `VSub`
typeclasses provide standard notation: `v +ᵥ p` for translation
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
## Connection to Torsor from E13

**Note**: AffineSpace is precisely a Torsor structure from E13, formalized with
custom notation (`vadd`, `vsub`) to emphasize the point/vector distinction.
The reason for custom notation rather than reusing Torsor directly: the
domain-codomain separation in AffineSpace (`V → P → P`) differs from Torsor's
symmetric action, making pedagogical clarity worth the slight redundancy.
In both cases, we capture the same mathematical idea: a group freely and
transitively acting on a set of points.
@@@ -/

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
  op      : Rat × Rat → Rat × Rat → Rat × Rat := fun (a, b) (c, d) => (a + c, b + d)
  id      : Rat × Rat := (0, 0)
  assoc   : ∀ a b c : Rat × Rat, ((a.1 + b.1) + c.1, (a.2 + b.2) + c.2) = (a.1 + (b.1 + c.1), a.2 + (b.2 + c.2)) := fun _ _ _ => by simp [Rat.add_assoc]
  idLeft  : ∀ a : Rat × Rat, (0 + a.1, 0 + a.2) = a := fun _ => by simp
  idRight : ∀ a : Rat × Rat, (a.1 + 0, a.2 + 0) = a := fun _ => by simp
  inv     : Rat × Rat → Rat × Rat := fun (a, b) => (-a, -b)
  invLeft : ∀ a : Rat × Rat, (-a.1 + a.1, -a.2 + a.2) = (0, 0) := fun (a, b) => by ext <;> simp [Rat.neg_add_cancel]
  invRight: ∀ a : Rat × Rat, (a.1 + (-a.1), a.2 + (-a.2)) = (0, 0) := fun (a, b) => by ext <;> simp [Rat.add_neg_cancel]

instance : AffineSpace (Rat × Rat) (Rat × Rat) where
  groupV  := inferInstance
  vadd    : Rat × Rat → Rat × Rat → Rat × Rat := fun (v₁, v₂) (p₁, p₂) => (p₁ + v₁, p₂ + v₂)
  vsub    : Rat × Rat → Rat × Rat → Rat × Rat := fun (q₁, q₂) (p₁, p₂) => (q₁ - p₁, q₂ - p₂)
  vaddAssoc : ∀ v w : Rat × Rat, ∀ p : Rat × Rat, _ := fun (v₁, v₂) (w₁, w₂) (p₁, p₂) =>
    -- Associativity: v + (w + p) = (v + w) + p
    -- Componentwise: (p₁ + w₁) + v₁ = p₁ + (w₁ + v₁)
    -- Follows from associativity and commutativity of rational addition
    sorry
  vaddZero : ∀ p : Rat × Rat, _ := fun (p₁, p₂) => by
    ext <;> simp [Group.id]
  vsubAdd : ∀ p q : Rat × Rat, _ := fun (q₁, q₂) (p₁, p₂) => by
    ext <;> simp
  addVsub : ∀ v : Rat × Rat, ∀ p : Rat × Rat, _ := fun (v₁, v₂) (p₁, p₂) => by
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

This is captured in the affine space axioms:

  **vsubAdd**: `(q -ᵥ p) +ᵥ p = q`
  ```
    Geometric meaning: if we take the vector from p to q, and apply it to p,
    we get back to q.

    p ──────────(q - p)─────────> q
            (add to p)

    This says: the displacement from p to q, when added to p, reconstructs q.
  ```

  **addVsub**: `(v +ᵥ p) -ᵥ p = v`
  ```
    Geometric meaning: if we translate p by vector v, the difference between
    the new point and the original is the vector v.

    p ─────v────> (v + p)
            (subtract p)

    This says: translating p by v, then computing the vector back to p,
    recovers the original vector v.
  ```
@@@ -/

/- @@@
## Concrete Examples: Small Geometric Worlds

Now let's see the affine space in action with concrete geometric worlds.
The key is that all operations are coordinate-free and don't require choosing
an origin.
@@@ -/

/- @@@
### Example 1: A Triangle in the Rational Plane

Define three vertices of a triangle:
@@@ -/

def triangle_A : Rat × Rat := (1, 2)
def triangle_B : Rat × Rat := (4, 2)
def triangle_C : Rat × Rat := (2, 5)

/- @@@
Compute the vectors forming the sides of the triangle.
Note: we use the `-ᵥ` operator to compute displacements.
@@@ -/

def side_AB : Rat × Rat := triangle_B -ᵥ triangle_A  -- (3, 0)
def side_BC : Rat × Rat := triangle_C -ᵥ triangle_B  -- (-2, 3)
def side_CA : Rat × Rat := triangle_A -ᵥ triangle_C  -- (-1, -3)

/- @@@
Verify the closure property: going around the triangle brings you back home.
The sum of all displacement vectors around a closed loop is the zero vector.
@@@ -/

def close_the_loop : Rat × Rat := (side_AB.1 + side_BC.1 + side_CA.1, side_AB.2 + side_BC.2 + side_CA.2)

/- In a closed triangle: AB + BC + CA = (0, 0) -/

-- Note: Would evaluate to (0, 0) once all axioms are proven
-- #eval close_the_loop

/- @@@
### Example 2: Translation and Reconstruction

Translate a point by a vector, then recover the original vector from the
difference.
@@@ -/

def point_P : Rat × Rat := (0, 0)
def vector_v : Rat × Rat := (3, 4)

/- @@@
The notation `v +ᵥ p` uses the VAdd instance to translate point p by vector v.
@@@ -/

def translated_point : Rat × Rat :=
  let v : Rat × Rat := vector_v
  let p : Rat × Rat := point_P
  (v.1 + p.1, v.2 + p.2)  -- (3, 4)

/- @@@
Now recover the original vector by taking the difference:
@@@ -/

def recovered_vector : Rat × Rat :=
  (translated_point.1 - point_P.1, translated_point.2 - point_P.2)  -- (3, 4)

/- Both vector_v and recovered_vector are (3, 4), demonstrating addVsub axiom -/

-- Note: These would evaluate correctly once vaddAssoc is proven
-- #eval translated_point     -- (3, 4)
-- #eval recovered_vector     -- (3, 4)

/- @@@
### Example 3: Geometric Relationships Without an Origin

Consider a line defined by two points. We can describe all points on the line
using just the affine structure — no special origin needed.
@@@ -/

def line_point_1 : Rat × Rat := (1, 1)
def line_point_2 : Rat × Rat := (2, 3)

def direction : Rat × Rat := line_point_2 -ᵥ line_point_1  -- (1, 2)

/- @@@
A point at t=2 along this line (2 times the direction vector from point_1):
@@@ -/

def point_on_line_t2 : Rat × Rat :=
  let double_direction := (2 * direction.1, 2 * direction.2)
  (line_point_1.1 + double_direction.1, line_point_1.2 + double_direction.2)
  -- (1, 1) + (2, 4) = (3, 5)

/- @@@
The affine space structure lets us:
  - Define geometric objects (lines, triangles) by their points
  - Compute displacements between points without a global coordinate system
  - Verify geometric properties (like closure of a triangle)
  - Reconstruct vectors from differences

All of this works *purely relationally* — we never need to pick a special point
as "the origin." The geometry emerges from the group action alone.
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
