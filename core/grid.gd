class_name AIPCell
## Port of cAIGrid.pas - one terrain cell of the planet.

var x := 0
var y := 0
var water := 0.0
var temperature := 5.0
var humidity := 5.0
var height := 5.0
var normal := Vector3.UP
var underwater := false
var land_state := AIP.LandState.GRASS
var dirty := true
var links: Array[AIPCell] = []
var space: AIPSpace


func setup(p_space: AIPSpace, p_x: int, p_y: int) -> void:
	space = p_space
	x = p_x
	y = p_y


func center() -> Vector3:
	return Vector3(x * AIP.CELL_SIZE + AIP.CELL_SIZE * 0.5, 0.0,
			y * AIP.CELL_SIZE + AIP.CELL_SIZE * 0.5)


func land_height() -> float:
	return height


func water_height() -> float:
	return height + water * 0.05


func determine_land_state() -> void:
	var state := AIP.LandState.GRASS
	if underwater:
		if water > 8.0:
			state = AIP.LandState.OCEAN
		elif water > 4.0:
			state = AIP.LandState.SEA
		elif water > 1.5:
			state = AIP.LandState.LAKE
		else:
			state = AIP.LandState.POND
	else:
		if temperature < 1.0:
			state = AIP.LandState.SNOW
		elif height > 30.0:
			state = AIP.LandState.ROCK
		elif humidity < 1.0:
			state = AIP.LandState.DESERT
		elif humidity < 3.0:
			state = AIP.LandState.DIRT
		elif humidity < 5.0:
			state = AIP.LandState.FIELD
	if state != land_state:
		land_state = state
		dirty = true


func queue_water(amount: float) -> void:
	space.queue_event(AIPSpace.EventKind.WATER, amount, self)


func queue_temperature(amount: float) -> void:
	space.queue_event(AIPSpace.EventKind.TEMPERATURE, amount, self)


func queue_humidity(amount: float) -> void:
	space.queue_event(AIPSpace.EventKind.HUMIDITY, amount, self)


func queue_height(amount: float) -> void:
	space.queue_event(AIPSpace.EventKind.HEIGHT, amount, self)


func jiggle_water() -> void:
	if water <= 0.0:
		return
	for link in links:
		if link.water < water - AIP.SURFACE_TENSION and link.height <= height + water * 0.5:
			var flow: float = clamp((water - link.water) * 0.25, 0.0, water * 0.5)
			if flow > 0.01:
				queue_water(-flow)
				link.queue_water(flow)


func naturalize() -> void:
	temperature = clamp(temperature - 0.002, 0.0, 10.0)
	if humidity > 0.0:
		var n: float = space.neighbor_average(x, y)
		humidity = clamp((humidity + n) * 0.5, 0.0, 10.0)


func boil() -> void:
	if temperature >= 9.8 and water > 0.0:
		var steam: float = min(water * 0.1, 0.5)
		queue_water(-steam)
		queue_humidity(steam * 0.1)
		queue_temperature(-0.1)


func condense() -> void:
	if humidity > 9.0 and randf() < 0.02 and space.world != null:
		space.world.try_spawn_cloud(self)


func freeze() -> void:
	if temperature < 0.15 and water > 2.0 and randf() < 0.01:
		queue_temperature(0.5)
		if space.world != null:
			space.world.try_spawn_iceberg(self)


func to_dict() -> Dictionary:
	return {"x": x, "y": y, "water": water, "temperature": temperature,
			"humidity": humidity, "height": height,
			"normal": [normal.x, normal.y, normal.z], "underwater": underwater}


func from_dict(d: Dictionary) -> void:
	water = d.get("water", 0.0)
	temperature = d.get("temperature", 5.0)
	humidity = d.get("humidity", 5.0)
	height = d.get("height", 5.0)
	var n: Array = d.get("normal", [0.0, 1.0, 0.0])
	normal = Vector3(n[0], n[1], n[2])
	underwater = d.get("underwater", false)
