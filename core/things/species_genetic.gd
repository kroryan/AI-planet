class_name AIPSpeciesGenetic
## Genetic species with evolving DNA: fox, rabbit, ladybug.


class Fox extends AIPGeneticCreature:
	func _sense() -> void:
		var diets: Array = species().get("prey", [])
		if dna != null and dna.preferred_food > 0 and world != null and AIP.SPECIES.has(dna.preferred_food):
			diets = [dna.preferred_food]
		target = world.hash.nearest(Vector2(pos.x, pos.y), diets, self) if world != null else null
		if brain == null:
			return
		var nearest_dist := 1.0
		if target != null:
			nearest_dist = clampf(Vector2(target.pos.x - pos.x, target.pos.y - pos.y).length() / 300.0, 0.0, 1.0)
		brain.set_input(0, health / AIP.MAX_HEALTH)
		brain.set_input(1, clampf(age_ticks() / float(species_lifespan()), 0.0, 1.0))
		brain.set_input(2, nearest_dist)
		brain.set_input(3, 0.0)
		brain.set_input(4, 1.0 if pos.underwater else 0.0)
		brain.set_input(5, clampf((pos.h - pos.land) / 20.0, 0.0, 1.0))

	func _perform() -> void:
		super._perform()
		if randf() < 0.001:
			talk("fox says hi")


class Rabbit extends AIPGeneticCreature:
	var hop := 0.0

	func _perform() -> void:
		hop += 0.2
		super._perform()
		if pos.binding == AIP.Binding.LAND and randf() < 0.1:
			pos.apply_force(Vector3(0, 0.15, 0))
		if randf() < 0.001:
			noise("mouse1")


class Ladybug extends AIPGeneticCreature:
	func species_lifespan() -> int:
		return dna.lifespan if dna != null else AIP.MATING_ELDER_TICKS

	func _act() -> bool:
		if dna == null:
			setup_dna()
		return super._act()

	func _perform() -> void:
		super._perform()
		if randf() < 0.001:
			pos.apply_force(Vector3(0, 0.2, 0))
