class_name AIPSpeciesSimple
## Simpler creatures: shark, hawk, trex, tiger, terrier, mouse, ant, dolphin, bot.


class Shark extends AIPCreature:
	func species_cruise_height() -> float:
		return -3.0


class Hawk extends AIPCreature:
	var diving := false

	func species_cruise_height() -> float:
		return 45.0 if not diving else 2.0

	func _act() -> bool:
		diving = target != null and is_instance_valid(target) and Vector2(
				target.pos.x - pos.x, target.pos.y - pos.y).length() < 80.0
		return super._act()

	func _perform() -> void:
		super._perform()
		if diving and randf() < 0.02:
			noise("hawk")


class Trex extends AIPCreature:
	func _perform() -> void:
		super._perform()
		if randf() < 0.002:
			noise("lion")


class Tiger extends AIPCreature:
	func _perform() -> void:
		super._perform()
		if randf() < 0.002:
			noise("tiger")


class Terrier extends AIPCreature:
	func _perform() -> void:
		super._perform()
		if target != null and is_instance_valid(target) and Vector2(
				target.pos.x - pos.x, target.pos.y - pos.y).length() < 15.0:
			target.pos.apply_force(Vector3(0, 0.4, 0))


class Mouse extends AIPCreature:
	func _perform() -> void:
		super._perform()
		if randf() < 0.002:
			noise("mouse1")


class Ant extends AIPCommunityCreature:
	func _act() -> bool:
		if community == null and randf() < 0.02:
			var comms: Array = world.communities_of(AIP.Kind.ANT)
			for c in comms:
				if c.members.size() < c.max_members:
					join_community(c)
					break
			if community == null:
				var comm := AIPCommunity.new(AIP.Kind.ANT)
				join_community(comm)
				world.add_community(comm)
		return super._act()


class Dolphin extends AIPCommunityCreature:
	var jump := 0.0

	func _act() -> bool:
		if community == null and randf() < 0.02:
			var comms: Array = world.communities_of(AIP.Kind.DOLPHIN)
			for c in comms:
				if c.members.size() < c.max_members:
					join_community(c)
					break
			if community == null:
				var comm := AIPCommunity.new(AIP.Kind.DOLPHIN)
				join_community(comm)
				world.add_community(comm)
		return super._act()

	func _perform() -> void:
		super._perform()
		jump += 0.15
		if pos.underwater and sin(jump) > 0.98:
			pos.apply_force(Vector3(0, 1.2, 0))
			noise("watersplash")


class Bot extends AIPCreature:
	func _act() -> bool:
		return true

	func command(cmd: String) -> void:
		match cmd:
			"jump":
				pos.apply_force(Vector3(0, 2.0, 0))
			"wander":
				desire = AIP.Desire.WANDER
			"stop":
				pos.velocity = Vector3.ZERO
				pos.acceleration = Vector3.ZERO
			"happy":
				talk("beep beep!")
			"jetpack":
				pos.apply_force(Vector3(0, 0.8, 0))
				noise("quake3")
