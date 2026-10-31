class_name AIPSpeciesMating
## Mating-family species: bird (flock), fish, duck, grazer.


class Bird extends AIPMatingCreature:
	var flap := 0.0

	func species_cruise_height() -> float:
		return 30.0 + sin(flap) * 4.0

	func _act() -> bool:
		flap += 0.3
		if community == null and randf() < 0.01:
			var flocks: Array = world.communities_of(AIP.Kind.BIRD)
			for f in flocks:
				if f.members.size() < f.max_members:
					join_community(f)
					break
			if community == null:
				var comm := AIPCommunity.new(AIP.Kind.BIRD)
				join_community(comm)
				world.add_community(comm)
		return super._act()

	func _perform() -> void:
		super._perform()
		if desire == AIP.Desire.WANDER and randf() < 0.002:
			noise("sparrow")

	func _on_death() -> void:
		super._on_death()
		noise("bird-die")


class Fish extends AIPMatingCreature:
	func species_cruise_height() -> float:
		return -2.0

	func _on_death() -> void:
		super._on_death()
		pos.buoyancy = 0.5


class Duck extends AIPMatingCreature:
	func _act() -> bool:
		var ok := super._act()
		pos.buoyancy = 0.9 if pos.underwater else pos.buoyancy
		return ok

	func _perform() -> void:
		super._perform()
		if randf() < 0.001:
			noise("quack")


class Grazer extends AIPMatingCreature:
	func _perform() -> void:
		super._perform()
		if desire == AIP.Desire.WANDER and randf() < 0.3:
			desire = AIP.Desire.FOOD
