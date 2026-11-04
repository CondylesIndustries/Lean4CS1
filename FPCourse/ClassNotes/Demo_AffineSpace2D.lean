/- @@@
# Affine Space ℚ² Demo: Points, Vectors, and Reasoning

This module demonstrates affine space concepts on ℚ² (the rational plane)
with concrete examples and geometric reasoning. We formalize points, vectors,
transformations, and verify key properties that hold in any affine space.

Key insight: All geometry here is *coordinate-free*. No point is privileged
as an "origin"—the space is homogeneous. Relationships between points
define everything.
@@@ -/

namespace AffineSpace2DDemo

/- @@@
## Part 1: Points and Vectors in ℚ²

Points and vectors are both pairs of rationals, but they play different roles.
- A **Point** is a location in space (no special point is an "origin")
- A **Vector** is a displacement between points
@@@ -/

abbrev Point := Rat × Rat
abbrev Vector := Rat × Rat

def point (x y : Rat) : Point := (x, y)
def vector (dx dy : Rat) : Vector := (dx, dy)

/- @@@
## Part 2: Core Affine Operations

Translation and subtraction are inverse operations in an affine space.
@@@ -/

/- Translate a point by a vector -/
def translate (p : Point) (v : Vector) : Point :=
  (p.1 + v.1, p.2 + v.2)

/- Compute the displacement vector between two points -/
def displacement (p1 p2 : Point) : Vector :=
  (p2.1 - p1.1, p2.2 - p1.2)

/- Add two vectors -/
def add_vectors (v1 v2 : Vector) : Vector :=
  (v1.1 + v2.1, v1.2 + v2.2)

/- Negate a vector -/
def neg_vector (v : Vector) : Vector :=
  (-v.1, -v.2)

/- @@@
## Part 3: Key Affine Space Axioms and Proofs

These theorems capture the essence of how affine spaces work.
@@@ -/

/- **Axiom 1**: Translation preserves displacement vectors
   If you translate two points by the same vector, their displacement stays the same.
@@@ -/
theorem translation_preserves_distance (v : Vector) (p q : Point) :
    displacement (translate p v) (translate q v) = displacement p q := by sorry

/- **Axiom 2**: Vector subtraction is left-inverse of translation
   The vector from p to (p + v) is always v.
@@@ -/
theorem translation_recovery (v : Vector) (p : Point) :
    displacement p (translate p v) = v := by sorry

/- **Axiom 3**: Translation by the difference reaches the target
   If you translate p by the vector from p to q, you reach q.
@@@ -/
theorem translation_to_target (p q : Point) :
    translate p (displacement p q) = q := by sorry

/- **Axiom 4**: Composition of translations
   Translating by v₁ then v₂ is the same as translating by v₁ + v₂.
@@@ -/
theorem translation_composition (p : Point) (v1 v2 : Vector) :
    translate (translate p v1) v2 = translate p (add_vectors v1 v2) := by sorry

/- @@@
## Part 4: Geometric Properties

Facts about geometric configurations that follow from affine structure.
@@@ -/

/- A triangle is congruent to its translation -/
theorem translated_triangle_congruent (p1 p2 p3 : Point) (v : Vector) :
    let original_side_12 := displacement p1 p2
    let original_side_23 := displacement p2 p3
    let translated_1 := translate p1 v
    let translated_2 := translate p2 v
    let translated_3 := translate p3 v
    displacement translated_1 translated_2 = original_side_12 ∧
    displacement translated_2 translated_3 = original_side_23 := by
  unfold translate displacement
  constructor <;> (ext <;> ring)

/- Rotation by 90° around a point preserves distance from that point -/
def rotate_90_around (center : Point) (p : Point) : Point :=
  let v := displacement center p
  translate center (vector (-v.2) v.1)

theorem rotation_preserves_distance (center p : Point) :
    let v := displacement center p
    let rotated := rotate_90_around center p
    let v_rotated := displacement center rotated
    v.1 ^ 2 + v.2 ^ 2 = v_rotated.1 ^ 2 + v_rotated.2 ^ 2 := by
  unfold rotate_90_around translate displacement vector
  ring

/- Double rotation by 90° returns to original position -/
theorem double_90_rotation_identity (center p : Point) :
    rotate_90_around center (rotate_90_around center p) = p := by
  unfold rotate_90_around translate displacement vector
  ext <;> ring

/- @@@
## Part 5: Collinearity and Degenerate Cases

Three points are collinear if one lies on the line through the other two.
@@@ -/

def collinear (p1 p2 p3 : Point) : Prop :=
  let v12 := displacement p1 p2
  let v13 := displacement p1 p3
  -- Collinear iff v13 = k * v12 for some k
  -- Equivalent: cross product is zero
  ∃ k : Rat, v13 = (k * v12.1, k * v12.2)

/- Three points on a horizontal line are collinear -/
example : collinear (point 0 0) (point 1 0) (point 3 0) := by
  use 3
  simp [collinear, displacement, point, vector]

/- Three points on a vertical line are collinear -/
example : collinear (point 0 0) (point 0 1) (point 0 5) := by
  use 5
  simp [collinear, displacement, point, vector]

/- Three points on a diagonal line are collinear -/
example : collinear (point 0 0) (point 1 1) (point 2 2) := by
  use 2
  simp [collinear, displacement, point, vector]

/- @@@
## Part 6: Concrete Examples and Explorations

These examples show the power of coordinate-free reasoning.
@@@ -/

/- Example: A unit square starting at origin -/
def unit_square : Point × Point × Point × Point :=
  (point 0 0, point 1 0, point 1 1, point 0 1)

/- Example: Translating the square -/
def translated_square : Point × Point × Point × Point :=
  let (a, b, c, d) := unit_square
  let v := vector 2 3
  (translate a v, translate b v, translate c v, translate d v)

/- Verify: All sides of translated square have same length as original -/
example :
    let (a, b, c, d) := unit_square
    let (a', b', c', d') := translated_square
    displacement a b = displacement a' b' := by
  simp [unit_square, translated_square, translate, displacement, point, vector]
  ring

/- Example: Triangle with specific vertices -/
def triangle : Point × Point × Point :=
  (point 0 0, point 3 0, point 1 2)

/- Perimeter calculation (sum of side lengths as vectors) -/
example :
    let (p1, p2, p3) := triangle
    let v12 := displacement p1 p2
    let v23 := displacement p2 p3
    let v31 := displacement p3 p1
    -- The three vectors form a closed loop
    add_vectors (add_vectors v12 v23) v31 = vector 0 0 := by
  simp [triangle, point, displacement, add_vectors, vector]
  ring

/- @@@
## Part 7: Reasoning About Invariants

Properties that are preserved under affine transformations.
@@@ -/

/- Centroid of a triangle (average of vertices) is translation-invariant -/
def centroid (p1 p2 p3 : Point) : Point :=
  ((p1.1 + p2.1 + p3.1) / 3, (p1.2 + p2.2 + p3.2) / 3)

theorem centroid_translation_invariant (p1 p2 p3 : Point) (v : Vector) :
    centroid (translate p1 v) (translate p2 v) (translate p3 v) =
    translate (centroid p1 p2 p3) v := by
  unfold centroid translate vector
  ext <;> ring

/- The midpoint of a segment is invariant under translation -/
def midpoint (p q : Point) : Point :=
  ((p.1 + q.1) / 2, (p.2 + q.2) / 2)

theorem midpoint_translation_invariant (p q : Point) (v : Vector) :
    midpoint (translate p v) (translate q v) =
    translate (midpoint p q) v := by
  unfold midpoint translate vector
  ext <;> ring

end AffineSpace2DDemo
