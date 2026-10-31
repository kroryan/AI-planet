class_name AIPSpaceThings
## Orbitals: sun, moon, asteroids, missile defence and missiles.


class Sun extends AIPThing:
	var angle := 0.0

	func _setup() -> void:
		super._setup()
		health = 1e9

	func _act() -> bool:
		angle += 0.004
		var center := Vector3(world.space.width * AIP.CELL_SIZE * 0.5, 0.0,
				world.space.height * AIP.CELL_SIZE * 0.5)
		var r := maxf(world.space.width, world.space.height) * AIP.CELL_SIZE * 0.75
		pos.x = center.x + cos(angle) * r
		pos.y = center.z + sin(angle) * r
		pos.h = 60.0
		var cell: AIPCell = world.space.cell_at_world(Vector2(pos.x, pos.y))
		if cell != null:
			for dx in range(-2, 3):
				for dy in range(-2, 3):
					var n: AIPCell = world.space.wrap_cell(cell.x + dx, cell.y + dy)
					if n != null:
						n.queue_temperature(0.3 / maxf(1.0, Vector2i(dx, dy).length()))
		return true

	func die(reason := "") -> void:
		super.die(reason)
		for i in 26:
			world.spawn_meteor()

	func _decompose() -> void:
		cease()


class Moon extends AIPThing:
	var angle := PI

	func _setup() -> void:
		super._setup()
		health = 1e9

	func _act() -> bool:
		angle += 0.002
		var center := Vector3(world.space.width * AIP.CELL_SIZE * 0.5, 0.0,
				world.space.height * AIP.CELL_SIZE * 0.5)
		var r := maxf(world.space.width, world.space.height) * AIP.CELL_SIZE * 0.85
		pos.x = center.x + cos(angle) * r
		pos.y = center.z + sin(angle) * r
		pos.h = 70.0
		if world.time % 8 == 0:
			var cell: AIPCell = world.space.cell_at_world(Vector2(pos.x, pos.y))
			if cell != null and cell.underwater:
				cell.queue_water(-0.05)
				cell.queue_temperature(-0.02)
		return true

	func _decompose() -> void:
		cease()


class Asteroid extends AIPThing:
	func _act() -> bool:
		if pos.h > 100.0:
			pos.apply_force(Vector3(0, -0.15, 0))
			pos.apply_force(Vector3(randf_range(-0.01, 0.01), 0, randf_range(-0.01, 0.01)))
			return true
		var cell: AIPCell = pos.cell(world.space)
		if cell == null:
			return true
		if pos.h <= cell.land_height() + 1.0 or (cell.underwater and pos.h <= cell.water_height()):
			world.explode(world_pos(), 120.0, "asteroid")
			for dx in range(-1, 2):
				for dy in range(-1, 2):
					var n: AIPCell = world.space.wrap_cell(cell.x + dx, cell.y + dy)
					if n != null:
						n.queue_height(-randf_range(2.0, 5.0))
			noise("explode")
			world.log_event("An asteroid struck the planet!")
			cease()
			return false
		pos.apply_force(Vector3(0, -0.2, 0))
		return true


class MissileDefence extends AIPThing:
	var cooldown := 0

	func _act() -> bool:
		if cooldown > 0:
			cooldown -= 1
			return true
		var asteroid = world.hash.nearest_of_kind(Vector2(pos.x, pos.y), AIP.Kind.ASTEROID, self)
		if asteroid != null and asteroid.pos.h > 50.0:
			var missile = world.spawn_at(AIP.Kind.MISSILE, world.space.cell_at_world(Vector2(pos.x, pos.y)))
			if missile != null and missile is Missile:
				missile.target = asteroid
				missile.pos.x = pos.x
				missile.pos.y = pos.y
				missile.pos.h = pos.h
				cooldown = 100
				noise("incoming")
		return true


class Missile extends AIPThing:
	var target = null

	func _act() -> bool:
		if target == null or not is_instance_valid(target) or not target.exists:
			world.explode(world_pos(), 40.0, "shock")
			cease()
			return false
		var lead: Vector3 = target.world_pos() + target.pos.velocity * 10.0
		pos.seek(lead, 1.5)
		if world_pos().distance_to(target.world_pos()) < 12.0:
			world.explode(target.world_pos(), 80.0, "shock")
			target.cease()
			noise("blast")
			cease()
			return false
		if age_ticks() > 400:
			cease()
			return false
		return true
