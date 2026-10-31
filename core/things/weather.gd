class_name AIPWeather
## Weather: clouds with rain, lightning, icebergs, earthquakes.


class Cloud extends AIPThing:
	var water_mass := 2.0
	var raining := false
	var storm := false

	func _act() -> bool:
		var cell: AIPCell = pos.cell(world.space)
		if cell == null:
			return true
		wind_drift()
		if age_ticks() > AIP.CLOUD_LIFESPAN:
			raining = true
		if cell.humidity > 8.0:
			water_mass += 0.05
		if water_mass > 8.0 and randf() < 0.01:
			var other = world.spawn_at(AIP.Kind.CLOUD, cell)
			if other != null and other is Cloud:
				other.water_mass = water_mass * 0.4
				water_mass *= 0.6
		if raining or storm:
			if cell.underwater or water_mass <= 0.0:
				if water_mass <= 0.0:
					world.log_event("A cloud dispersed")
					cease()
					return false
			else:
				var rain: float = minf(water_mass * 0.05, 0.4)
				cell.queue_water(rain)
				cell.queue_temperature(-0.1)
				cell.queue_humidity(-0.2)
				water_mass -= rain
				world.spawn_rain_effect(self)
		if storm and randf() < 0.005:
			var bolt = world.spawn_at(AIP.Kind.LIGHTNING, cell)
			if bolt != null:
				bolt.pos.x = pos.x
				bolt.pos.y = pos.y
		return true

	func wind_drift() -> void:
		pos.apply_force(Vector3(randf_range(-0.02, 0.02), 0.0, randf_range(-0.02, 0.02)))


class Lightning extends AIPThing:
	var strikes_in := 3

	func _act() -> bool:
		strikes_in -= 1
		var cell: AIPCell = pos.cell(world.space)
		if cell != null:
			cell.queue_temperature(1.5)
		if strikes_in <= 0:
			world.explode(world_pos(), 60.0, "lightning")
			noise("quake3")
			cease()
			return false
		return true


class Iceberg extends AIPThing:
	func _act() -> bool:
		var cell: AIPCell = pos.cell(world.space)
		if cell == null:
			return true
		cell.queue_temperature(-0.05)
		if cell.temperature > 5.0:
			health -= 2.0
			cell.queue_water(0.1)
		if age_ticks() > 4000:
			die("melted")
		return true


class Earthquake extends AIPThing:
	var ticks_left := 40

	func _act() -> bool:
		ticks_left -= 1
		world.space.shake_land(0.4)
		world.shake_camera(0.3)
		if randf() < 0.1:
			noise("rocksmash")
		if ticks_left <= 0:
			world.log_event("The earthquake ended")
			cease()
			return false
		return true
