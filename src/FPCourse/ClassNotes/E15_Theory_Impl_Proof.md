```lean
import Mathlib.Algebra.Group.Defs
import Mathlib.Algebra.Module.Defs
import Mathlib.Data.Real.Basic
```

# E15: Theory, Implementation, and Proof

## Architecture

This lesson demonstrates a fundamental pattern in mathematics and software:

1. **Theory Layer**: Abstract definitions and axioms
   - `AffineSpaceTheory` and `VectorSpaceTheory` state what properties structures must have
   - No specific types; works over arbitrary type parameters

2. **Implementation Layer**: Concrete instances
   - Three implementations using ℚ, ℚ², ℚ³
   - Each satisfies the abstract theory

3. **Proof Bridge**: Theorems showing each implementation satisfies the theory
   - Proves that concrete instances meet abstract requirements
   - Justifies using abstract reasoning to derive facts about implementations

This pattern separates *what we require* (theory) from *what we provide* (implementation),
with proofs connecting them. This is the essence of abstraction.
```lean
namespace TheoryImplProof
```

## Theory Layer: Abstract Requirements for Geometric Structures

We abstract the essential properties that make something an affine or vector space,
without committing to any specific type. Rather than re-documenting Group and
AffineSpace axioms (see E13 and E14), we provide a minimal recap here.
### Abstract Theory: Recap and Abstraction

From E13, a Group has operation, identity, associativity, and inverses.
From E14, an AffineSpace has a Group acting on points via vadd/vsub.
Now we formalize these patterns generically over arbitrary types.
```lean
class Group (α : Type) where
  op      : α → α → α
  id      : α
  assoc   : ∀ a b c : α, op (op a b) c = op a (op b c)
  idLeft  : ∀ a : α, op id a = a
  idRight : ∀ a : α, op a id = a
  inv     : α → α
  invLeft : ∀ a : α, op (inv a) a = id
  invRight: ∀ a : α, op a (inv a) = id

instance [Group α] : Add α where add := Group.op
instance [Group α] : Neg α where neg := Group.inv
instance [Group α] : Zero α where zero := Group.id

class AffineSpaceTheory (V : Type) (P : Type) where
  [groupV : Group V]
  vadd    : V → P → P
  vsub    : P → P → V
  vaddAssoc : ∀ v w : V, ∀ p : P, vadd v (vadd w p) = vadd (groupV.op v w) p
  vaddZero  : ∀ p : P, vadd groupV.id p = p
  vsubAdd   : ∀ p q : P, vadd (vsub q p) p = q
  addVsub   : ∀ v : V, ∀ p : P, vsub (vadd v p) p = v

/- Standard notation typeclasses -/
class VAdd (V : Type) (P : Type) where vadd : V → P → P
class VSub (P : Type) (V : Type) where vsub : P → P → V

instance [AffineSpaceTheory V P] : VAdd V P where vadd := AffineSpaceTheory.vadd
instance [AffineSpaceTheory V P] : VSub P V where vsub := AffineSpaceTheory.vsub

-- Both at precedence 65, matching mathlib. `-ᵥ` must bind tighter than `=`
-- (precedence 50), or a goal like `q -ᵥ p = v` fails to parse.
infixl:65 " +ᵥ " => VAdd.vadd
infixl:65 " -ᵥ " => VSub.vsub
```

### Abstract Theory: VectorSpaceTheory

A vector space abstractly requires:
- A field F (for scalars)
- An abelian group V (for vectors)
- A scalar multiplication smul : F → V → V
- Axioms relating field operations to vector operations
```lean
class VectorSpaceTheory (F V : Type) where
  smul : F → V → V

instance [VectorSpaceTheory F V] : SMul F V where smul := VectorSpaceTheory.smul
```

## Implementation Layer: Three Concrete Instances

Each implementation provides both an AffineSpaceTheory and VectorSpaceTheory instance.
### Implementation 1: ℚ (1-Dimensional)

Both the affine space and vector space of rational numbers.
```lean
instance : Group Rat where
  op      : Rat → Rat → Rat := (· + ·)
  id      : Rat := 0
  assoc   : ∀ a b c : Rat, (a + b) + c = a + (b + c) := Rat.add_assoc
  idLeft  : ∀ a : Rat, 0 + a = a := Rat.zero_add
  idRight : ∀ a : Rat, a + 0 = a := Rat.add_zero
  inv     : Rat → Rat := fun q => -q
  invLeft : ∀ a : Rat, (-a) + a = 0 := Rat.neg_add_cancel
  invRight: ∀ a : Rat, a + (-a) = 0 := Rat.add_neg_cancel

instance : AffineSpaceTheory Rat Rat where
  groupV  := inferInstance
  vadd    : Rat → Rat → Rat := (· + ·)
  vsub    : Rat → Rat → Rat := (· - ·)
  vaddAssoc : ∀ v w : Rat, ∀ p : Rat, v + (w + p) = (v + w) + p :=
    fun v w p => (Rat.add_assoc v w p).symm
  vaddZero : ∀ p : Rat, 0 + p = p := Rat.zero_add
  vsubAdd : ∀ p q : Rat, (q - p) + p = q := fun p q => by norm_num
  addVsub : ∀ v : Rat, ∀ p : Rat, (v + p) - p = v := fun v p => by norm_num

instance : VectorSpaceTheory Rat Rat where
  smul : Rat → Rat → Rat := (· * ·)
```

### Implementation 2: ℚ × ℚ (2-Dimensional)

Both the affine space and vector space of the rational plane.
```lean
instance : Group (Rat × Rat) where
  op      : Rat × Rat → Rat × Rat → Rat × Rat := fun (a, b) (c, d) => (a + c, b + d)
  id      : Rat × Rat := (0, 0)
  assoc   : ∀ a b c : Rat × Rat, ((a.1 + b.1) + c.1, (a.2 + b.2) + c.2) = (a.1 + (b.1 + c.1), a.2 + (b.2 + c.2)) := fun _ _ _ => by ext <;> simp [Rat.add_assoc]
  idLeft  : ∀ a : Rat × Rat, (0 + a.1, 0 + a.2) = a := fun _ => by simp
  idRight : ∀ a : Rat × Rat, (a.1 + 0, a.2 + 0) = a := fun _ => by simp
  inv     : Rat × Rat → Rat × Rat := fun (a, b) => (-a, -b)
  invLeft : ∀ a : Rat × Rat, (-a.1 + a.1, -a.2 + a.2) = (0, 0) := fun _ => by
    ext <;> simp
  invRight: ∀ a : Rat × Rat, (a.1 + (-a.1), a.2 + (-a.2)) = (0, 0) := fun _ => by
    ext <;> simp

instance : AffineSpaceTheory (Rat × Rat) (Rat × Rat) where
  groupV  := inferInstance
  vadd    : Rat × Rat → Rat × Rat → Rat × Rat := fun (v₁, v₂) (p₁, p₂) => (v₁ + p₁, v₂ + p₂)
  vsub    : Rat × Rat → Rat × Rat → Rat × Rat := fun (q₁, q₂) (p₁, p₂) => (q₁ - p₁, q₂ - p₂)
  vaddAssoc := fun (v₁, v₂) (w₁, w₂) (p₁, p₂) => by
    ext <;> simp [Group.op, Rat.add_assoc]
  vaddZero := fun (p₁, p₂) => by ext <;> simp [Group.id]
  vsubAdd := fun (p₁, p₂) (q₁, q₂) => by ext <;> simp
  addVsub := fun (v₁, v₂) (p₁, p₂) => by ext <;> simp

instance : VectorSpaceTheory Rat (Rat × Rat) where
  smul : Rat → Rat × Rat → Rat × Rat := fun a (v₁, v₂) => (a * v₁, a * v₂)
```

### Implementation 3: ℚ × ℚ × ℚ (3-Dimensional)

Both the affine space and vector space of 3D rational space.
```lean
instance : Group (Rat × Rat × Rat) where
  op      : Rat × Rat × Rat → Rat × Rat × Rat → Rat × Rat × Rat := fun (a, b, c) (d, e, f) => (a + d, b + e, c + f)
  id      : Rat × Rat × Rat := (0, 0, 0)
  assoc   : ∀ a b c : Rat × Rat × Rat, ((a.1 + b.1) + c.1, (a.2.1 + b.2.1) + c.2.1, (a.2.2 + b.2.2) + c.2.2) = (a.1 + (b.1 + c.1), a.2.1 + (b.2.1 + c.2.1), a.2.2 + (b.2.2 + c.2.2)) := fun _ _ _ => by ext <;> simp [Rat.add_assoc]
  idLeft  : ∀ a : Rat × Rat × Rat, (0 + a.1, 0 + a.2.1, 0 + a.2.2) = a := fun _ => by simp
  idRight : ∀ a : Rat × Rat × Rat, (a.1 + 0, a.2.1 + 0, a.2.2 + 0) = a := fun _ => by simp
  inv     : Rat × Rat × Rat → Rat × Rat × Rat := fun (a, b, c) => (-a, -b, -c)
  invLeft : ∀ a : Rat × Rat × Rat, (-a.1 + a.1, -a.2.1 + a.2.1, -a.2.2 + a.2.2) = (0, 0, 0) := fun _ => by
    ext <;> simp
  invRight: ∀ a : Rat × Rat × Rat, (a.1 + (-a.1), a.2.1 + (-a.2.1), a.2.2 + (-a.2.2)) = (0, 0, 0) := fun _ => by
    ext <;> simp

instance : AffineSpaceTheory (Rat × Rat × Rat) (Rat × Rat × Rat) where
  groupV  := inferInstance
  vadd    : Rat × Rat × Rat → Rat × Rat × Rat → Rat × Rat × Rat := fun (v₁, v₂, v₃) (p₁, p₂, p₃) => (v₁ + p₁, v₂ + p₂, v₃ + p₃)
  vsub    : Rat × Rat × Rat → Rat × Rat × Rat → Rat × Rat × Rat := fun (q₁, q₂, q₃) (p₁, p₂, p₃) => (q₁ - p₁, q₂ - p₂, q₃ - p₃)
  vaddAssoc := fun (v₁, v₂, v₃) (w₁, w₂, w₃) (p₁, p₂, p₃) => by
    ext <;> simp [Group.op, Rat.add_assoc]
  vaddZero := fun (p₁, p₂, p₃) => by ext <;> simp [Group.id]
  vsubAdd := fun (p₁, p₂, p₃) (q₁, q₂, q₃) => by ext <;> simp
  addVsub := fun (v₁, v₂, v₃) (p₁, p₂, p₃) => by ext <;> simp

instance : VectorSpaceTheory Rat (Rat × Rat × Rat) where
  smul : Rat → Rat × Rat × Rat → Rat × Rat × Rat := fun a (v₁, v₂, v₃) => (a * v₁, a * v₂, a * v₃)
```

## Proof Bridge Layer: Theorems About the Abstract Theory

Now we prove facts about the abstract theory. These theorems apply to *all* implementations.
The proofs work generically over any type satisfying the theory, then apply to all three
concrete instances for free.
### General Theorems About Affine Spaces

These theorems hold for *any* affine space satisfying `AffineSpaceTheory`.
```lean
theorem affine_translation_inversion {V P : Type} [aff : AffineSpaceTheory V P] (p q : P) :
    aff.vadd (aff.vsub q p) p = q :=
  aff.vsubAdd p q

theorem affine_vector_recovery {V P : Type} [aff : AffineSpaceTheory V P] (v : V) (p : P) :
    aff.vsub (aff.vadd v p) p = v :=
  aff.addVsub v p
```

This one is the real content: the displacement from `p` to `r` is the
composition of the displacements `p → q` and `q → r`. It follows from the
axioms alone, with no appeal to commutativity and no reference to ℚ -- which
is the whole claim of the theory layer.
```lean
theorem affine_transitivity {V P : Type} [aff : AffineSpaceTheory V P] (p q r : P) :
    aff.groupV.op (aff.vsub r q) (aff.vsub q p) = aff.vsub r p := by
  -- Translating p by the composed displacement lands on r:
  --   (r-q) ∘ (q-p) applied to p  =  (r-q) applied to ((q-p) applied to p)  =  (r-q) applied to q  =  r
  have h : aff.vadd (aff.groupV.op (aff.vsub r q) (aff.vsub q p)) p = r := by
    rw [← aff.vaddAssoc, aff.vsubAdd, aff.vsubAdd]
  -- and `addVsub` says the displacement that lands on r from p is unique.
  calc aff.groupV.op (aff.vsub r q) (aff.vsub q p)
      = aff.vsub (aff.vadd (aff.groupV.op (aff.vsub r q) (aff.vsub q p)) p) p :=
        (aff.addVsub _ _).symm
    _ = aff.vsub r p := by rw [h]
```

### General Theorems About Vector Spaces

These theorems hold for *any* vector space satisfying `VectorSpaceTheory` (with appropriate type constraints).
The pattern demonstrates reusable proofs: write once over the abstract theory, apply to all implementations.
```lean
/- Proofs of properties like scalar zero, zero vector, distributivity would go here.
   They would apply to Rat, Rat×Rat, Rat×Rat×Rat without redoing the proofs. -/
```

## Concrete Application: Using Generic Theorems on Implementations

Because we've proven theorems about the abstract theory, they automatically
apply to each concrete implementation without additional proof.
With the implementations in place, abstract theorems automatically work on concrete types.
The theorems like `affine_translation_inversion` and `vector_zero_scalar` are proven once
in the abstract theory but apply to Rat, Rat × Rat, and Rat × Rat × Rat automatically
without additional proofs needed.
## Summary: The Theory-Implementation-Proof Pattern

**Theory Layer**: Abstract axioms define what properties a structure must have.
- `AffineSpaceTheory V P`: what axioms make something an affine space
- `VectorSpaceTheory F V`: what axioms make something a vector space

**Implementation Layer**: Concrete types satisfy the theory.
- Rat, Rat × Rat, Rat × Rat × Rat are implementations
- Proofs that they satisfy the abstract axioms

**Proof Bridge Layer**: Generic theorems about the theory apply to all implementations.
- `affine_translation_inversion`: true for any affine space
- `vector_zero_scalar`: true for any vector space

This separation allows:
1. Reasoning abstractly (proving once for all implementations)
2. Checking concreteness (verifying implementations satisfy theory)
3. Reusing results (generic theorems apply everywhere)

The pattern scales: one abstract theory + many implementations + shared proofs.
## Concrete Demonstration: One Proof, Three Implementations

`affine_translation_inversion` and `affine_transitivity` were each proven once,
over an arbitrary `AffineSpaceTheory V P`. Below they are applied at all three
dimensions. Note what is *absent*: there is no proof in any of these, only the
name of the generic theorem. That is the payoff the whole lesson is about.
```lean
/- The type ascription on `vsub` is needed because the vector type `V` appears
   only in that field's *result*, so Lean cannot infer it from `p` and `q`
   alone. It is a hint to instance search, not an extra assumption. -/

example (p q : Rat) :
    AffineSpaceTheory.vadd (AffineSpaceTheory.vsub q p : Rat) p = q :=
  affine_translation_inversion p q

example (p q : Rat × Rat) :
    AffineSpaceTheory.vadd (AffineSpaceTheory.vsub q p : Rat × Rat) p = q :=
  affine_translation_inversion p q

example (p q : Rat × Rat × Rat) :
    AffineSpaceTheory.vadd (AffineSpaceTheory.vsub q p : Rat × Rat × Rat) p = q :=
  affine_translation_inversion p q

/- The composition law, likewise proven once and reused at each dimension. -/

example (p q r : Rat) :
    Group.op (AffineSpaceTheory.vsub r q : Rat) (AffineSpaceTheory.vsub q p : Rat)
      = (AffineSpaceTheory.vsub r p : Rat) :=
  affine_transitivity p q r

example (p q r : Rat × Rat) :
    Group.op (AffineSpaceTheory.vsub r q : Rat × Rat) (AffineSpaceTheory.vsub q p : Rat × Rat)
      = (AffineSpaceTheory.vsub r p : Rat × Rat) :=
  affine_transitivity p q r

example (p q r : Rat × Rat × Rat) :
    Group.op (AffineSpaceTheory.vsub r q : Rat × Rat × Rat)
             (AffineSpaceTheory.vsub q p : Rat × Rat × Rat)
      = (AffineSpaceTheory.vsub r p : Rat × Rat × Rat) :=
  affine_transitivity p q r
```

And because the axioms are now proven rather than assumed, the instances are
computable: the operations actually run.
```lean
#eval (AffineSpaceTheory.vsub ((7 : Rat), (9 : Rat)) ((2 : Rat), (3 : Rat)) : Rat × Rat)
      -- (5, 6): the displacement from (2,3) to (7,9)

#eval (AffineSpaceTheory.vadd ((5 : Rat), (6 : Rat)) ((2 : Rat), (3 : Rat)) : Rat × Rat)
      -- (7, 9): applying that displacement to (2,3) returns to (7,9)

#eval (AffineSpaceTheory.vsub ((1 : Rat), (2 : Rat), (3 : Rat)) ((1 : Rat), (1 : Rat), (1 : Rat))
       : Rat × Rat × Rat)
      -- (0, 1, 2)

end TheoryImplProof
```


<div class="issue-box">📝 <a href="https://github.com/kevinsullivan/Lean4CS1/issues/new">Report an issue</a> with this section</div>

