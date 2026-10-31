class_name AIPSpeciesLearning
## Learning species with food memory: crab, turtle.


class Crab extends AIPLearningCreature:
	var play_target = null

	func _act() -> bool:
		if play_target == null or not is_instance_valid(play_target) or not play_target.exists:
			if randf() < 0.01:
				play_target = world.hash.nearest_of_kind(Vector2(pos.x, pos.y), AIP.Kind.BALL, self)
		elif randf() < 0.5:
			pos.seek(play_target.world_pos(), speed() * 0.4)
			return true
		return super._act()

	func _perform() -> void:
		super._perform()
		if randf() < 0.0005:
			noise("crunch")


class Turtle extends AIPLearningCreature:
	func _act() -> bool:
		if randf() < 0.001:
			talk(str(world.time))
		return super._act()
