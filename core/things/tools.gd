class_name AIPTools
## Player tools and effects: weapons, balls, beacons, bombs, explosions,
## vibes (sounds) and speech bubbles.


class Weapon extends AIPThing:
	var mode := "gun"

	func fire(at: Vector3) -> void:
		match mode:
			"gun":
				world.explode(at, 30.0, "shot")
				noise("shoot")
			"flamethrower":
				world.explode(at, 50.0, "fire")
				noise("fire")
			"nuke":
				world.explode(at, 400.0, "nuke")
				noise("explode")
				world.shake_camera(1.0)


class Ball extends AIPThing:
	func _act() -> bool:
		if pos.binding == AIP.Binding.LAND and pos.velocity.length() < 0.05:
			pos.apply_force(Vector3(randf_range(-0.3, 0.3), 0.4, randf_range(-0.3, 0.3)))
		return true


class Balloon extends Ball:
	func _act() -> bool:
		pos.apply_force(Vector3(randf_range(-0.01, 0.01), 0.03, randf_range(-0.01, 0.01)))
		if pos.h > 90.0:
			cease()
			return false
		return true


class Beacon extends AIPThing:
	var mode := "fruit"

	func _act() -> bool:
		var cell: AIPCell = pos.cell(world.space)
		if cell == null:
			return true
		if world.time % 64 != 0:
			return true
		match mode:
			"fruit":
				if randf() < 0.5:
					world.spawn_at(AIP.Kind.APPLE if randf() < 0.5 else AIP.Kind.ORANGE, cell)
			"drain":
				cell.queue_water(-0.5)
			"bubble":
				cell.queue_water(0.5)
		return true


class Bomb extends AIPThing:
	var fuse := 100

	func _act() -> bool:
		fuse -= 1
		if fuse <= 0:
			world.explode(world_pos(), 150.0, "bomb")
			noise("explode")
			cease()
			return false
		return true


class Explosion extends AIPThing:
	var radius := 100.0
	var style := "blast"
	var life := 12

	func _act() -> bool:
		life -= 1
		if life == 11:
			_blast()
		if life <= 0:
			cease()
			return false
		return true

	func _blast() -> void:
		var victims: Array = world.hash.query_radius(Vector2(pos.x, pos.y), radius)
		for v in victims:
			if v == null or not v.exists:
				continue
			var d: float = world_pos().distance_to(v.world_pos())
			if d < radius:
				if v.is_prey() or v.is_fruit() or v.kind in [AIP.Kind.FIRE_TREE, AIP.Kind.APPLE_TREE,
						AIP.Kind.ORANGE_TREE, AIP.Kind.EVOLVING_TREE]:
					v.damage(99999.0, self)
				elif v is AIPSpeciesSimple.Bot:
					v.damage(radius - d, self)
		var cell: AIPCell = pos.cell(world.space)
		if cell != null and style in ["nuke", "asteroid", "bomb"]:
			for dx in range(-2, 3):
				for dy in range(-2, 3):
					var n: AIPCell = world.space.wrap_cell(cell.x + dx, cell.y + dy)
					if n != null:
						n.queue_temperature(0.5 if style == "nuke" else 0.1)
						if style == "nuke":
							n.queue_humidity(-1.0)
		world.spawn_explosion_effect(self)


class Vibe extends AIPThing:
	func _act() -> bool:
		world.play_vibe(self)
		cease()
		return false


class Speech extends AIPThing:
	var text := ""
	var life := 90

	func _act() -> bool:
		life -= 1
		if life <= 0:
			cease()
			return false
		return true
