--- E0.1

--- a: yes. Decidable predicate. Basic type, product
--- b: yes. decidable predicate. Basic type, sum
--- c: yes. decidable predicate. Basic type, a is uninhabited,
--- d: yes. decidable predicate. Basic type, product. a is uninhabited

#guard decide (2 < 3 ∧ 3 < 4) = true
#guard decide (2 < 3 ∨ 3 < 2) = true
#guard decide (¬ (2 = 3)) = true
#guard decide (¬ (2 < 3 ∧ 3 < 2)) = true

--- E0.2
