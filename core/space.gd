class_name AIPSpace
## Port of cAISpace.pas - the planet map with toroidal X and folded poles.

enum EventKind { WATER, TEMPERATURE, HUMIDITY, HEIGHT }

var world = null
var width := 20
var height := 11
var radius := 100.0
var default_height := 5.0
var default_water := 0.0
var default_temperature := 5.0
var default_humidity := 5.0
var spherical := false
var map: Array = []
var _active: Array[Dictionary] = []
var _queued: Array[Dictionary] = []
var changed_cells: Array[AIPCell] = []


func build(p_world, p_width: int, p_height: int) -> void:
	world = p_world
	width = p_width
	height = p_height
	map = []
	for x in width:
		var col: Array[AIPCell] = []
		for y in height:
			var cell := AIPCell.new()
			cell.setup(self, x, y)
			cell.water = default_water
			cell.temperature = default_temperature
			cell.humidity = default_humidity
			cell.height = default_height
			col.append(cell)
		map.append(col)
	connect_map()
	refresh_all()


func connect_map() -> void:
	for x in width:
		for y in height:
			var cell: AIPCell = map[x][y]
			cell.links.clear()
			for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
				var n := wrap_cell(x + dir.x, y + dir.y)
				if n != null:
					cell.links.append(n)


func wrap_cell(x: int, y: int) -> AIPCell:
	var yy := y
	if y < 0 or y >= height:
		return null
	var xx := posmod(x, width)
	return map[xx][yy]


func wrap_point(p: Vector2) -> Vector2:
	var cx := float(width) * AIP.CELL_SIZE
	return Vector2(posmod(p.x, cx), clamp(p.y, 0.0, float(height) * AIP.CELL_SIZE))


func cell_at(x: int, y: int) -> AIPCell:
	if x < 0 or x >= width or y < 0 or y >= height:
		return null
	return map[x][y]


func cell_at_world(p: Vector2) -> AIPCell:
	return cell_at(int(p.x / AIP.CELL_SIZE), int(p.y / AIP.CELL_SIZE))


func random_location() -> AIPCell:
	return map[randi() % width][randi() % height]


func random_location_away_from_poles() -> AIPCell:
	var nice := height - height / 4
	return map[randi() % width][height / 8 + randi() % nice]


func random_land() -> AIPCell:
	for i in 40:
		var cell := random_location()
		if not cell.underwater:
			return cell
	return random_location()


func queue_event(kind: int, modifier: float, cell: AIPCell) -> void:
	_queued.append({"kind": kind, "modifier": modifier, "cell": cell})


func fuel() -> void:
	var tmp := _active
	_active = _queued
	_queued = tmp
	_queued.clear()
	for event in _active:
		var cell: AIPCell = event["cell"]
		match event["kind"]:
			EventKind.WATER:
				cell.water = max(0.0, cell.water + event["modifier"])
			EventKind.TEMPERATURE:
				cell.temperature = clamp(cell.temperature + event["modifier"], 0.0, 10.0)
			EventKind.HUMIDITY:
				cell.humidity = clamp(cell.humidity + event["modifier"], 0.0, 10.0)
			EventKind.HEIGHT:
				cell.height = clamp(cell.height + event["modifier"], 0.0, 40.0)
		cell.dirty = true
	_active.clear()
	for i in 3:
		random_location().naturalize()
	if world.meteors_enabled and world.time % AIP.METEOR_INTERVAL == 0 and randi() % 32 == 0:
		world.spawn_meteor()


func neighbor_average(x: int, y: float) -> float:
	var total := 0.0
	var count := 0
	for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
		var n := wrap_cell(x + dir.x, int(y) + dir.y)
		if n != null:
			total += n.humidity
			count += 1
	return total / float(count) if count > 0 else 5.0


func refresh_all() -> void:
	for x in width:
		for y in height:
			refresh_cell(map[x][y])


func refresh_cell(cell: AIPCell) -> void:
	cell.underwater = cell.water > 0.5
	cell.determine_land_state()
	cell.jiggle_water()
	cell.boil()
	cell.condense()
	cell.freeze()
	var n := Vector3.UP
	for link in cell.links:
		var to_l := link.center() - cell.center()
		var dh: float = link.height - cell.height
		if abs(dh) > 0.01:
			n += Vector3(-to_l.x, 0.0, -to_l.z).normalized() * dh * -0.1
	cell.normal = n.normalized()


func shake_land(strength: float) -> void:
	for i in 12:
		var cell := random_location()
		cell.queue_height(randf_range(-strength, strength))


func naturalize_all() -> void:
	for x in width:
		for y in height:
			map[x][y].naturalize()


func generate(preset: String, p_w: int, p_h: int, water_level: float, hill_height: float) -> void:
	build(world, p_w, p_h)
	default_water = water_level
	default_height = hill_height
	match preset:
		"barren":
			for x in width:
				for y in height:
					var cell: AIPCell = map[x][y]
					cell.height = hill_height
					cell.water = 0.0
					cell.humidity = 0.0
					cell.temperature = 6.0
		"watery":
			for x in width:
				for y in height:
					var cell: AIPCell = map[x][y]
					cell.height = hill_height
					cell.water = water_level
					cell.humidity = 8.0
		"grass":
			for x in width:
				for y in height:
					var cell: AIPCell = map[x][y]
					cell.height = hill_height
					cell.humidity = 6.0
					if not cell.underwater and randf() < 0.3:
						world.spawn_at(AIP.Kind.GRASS, cell)
		"continents":
			_make_noise(6, hill_height, 0.55)
			for x in width:
				for y in height:
					var cell: AIPCell = map[x][y]
					cell.water = 0.0
					if cell.height <= water_level:
						cell.water = water_level - cell.height + 2.0
		"islands":
			_make_islands(maxi(2, p_w * p_h / 60), hill_height)
		"halo":
			for x in width:
				for y in height:
					var cell: AIPCell = map[x][y]
					var dx: float = absf(x - width * 0.5)
					cell.height = clamp(hill_height - dx * 0.4 + randf() * 2.0, 0.0, 40.0)
		_:
			for x in width:
				for y in height:
					map[x][y].height = hill_height + randf_range(-1.0, 1.0)
	freeze_poles()
	refresh_all()


func _make_noise(features: int, base: float, decay: float) -> void:
	for x in width:
		for y in height:
			map[x][y].height = base * 0.5
	for f in features:
		var cx := randi() % width
		var cy := randi() % height
		var strength := base * randf_range(0.5, 1.5)
		var rad := randf_range(2.0, 5.0)
		for dx in range(-int(rad) - 1, int(rad) + 2):
			for dy in range(-int(rad) - 1, int(rad) + 2):
				var cell := wrap_cell(cx + dx, cy + dy)
				if cell != null:
					var dist := Vector2(dx, dy).length()
					if dist <= rad:
						cell.height = clamp(cell.height + strength * (1.0 - dist / rad) * decay, 0.0, 40.0)


func _make_islands(count: int, base: float) -> void:
	for x in width:
		for y in height:
			var cell: AIPCell = map[x][y]
			cell.height = max(0.0, base * 0.15)
			cell.water = 2.0
	for i in count:
		var cx := randi() % width
		var cy := 1 + randi() % maxi(1, height - 2)
		var rad := randf_range(1.5, 4.0)
		for dx in range(-int(rad) - 1, int(rad) + 2):
			for dy in range(-int(rad) - 1, int(rad) + 2):
				var cell := wrap_cell(cx + dx, cy + dy)
				if cell != null:
					var dist := Vector2(dx, dy).length()
					if dist <= rad:
						cell.height = clamp(base * (1.0 - dist / (rad + 1.0)) + randf() * 2.0, 0.0, 40.0)
						cell.water = 0.0


func freeze_poles() -> void:
	for x in width:
		for y in [0, height - 1]:
			var cell: AIPCell = map[x][y]
			cell.temperature = clamp(cell.temperature - float(y) * 0.0, 0.0, 10.0)
		map[x][0].temperature = 0.5
		map[x][height - 1].temperature = 0.5


func to_dict() -> Dictionary:
	var cells := []
	for x in width:
		for y in height:
			cells.append(map[x][y].to_dict())
	return {"width": width, "height": height, "radius": radius,
			"default_height": default_height, "default_water": default_water,
			"default_temperature": default_temperature,
			"default_humidity": default_humidity, "spherical": spherical,
			"cells": cells}


func from_dict(d: Dictionary) -> void:
	var w: int = d.get("width", 20)
	var h: int = d.get("height", 11)
	default_height = d.get("default_height", 5.0)
	default_water = d.get("default_water", 0.0)
	default_temperature = d.get("default_temperature", 5.0)
	default_humidity = d.get("default_humidity", 5.0)
	spherical = d.get("spherical", false)
	build(world, w, h)
	var cells: Array = d.get("cells", [])
	var i := 0
	for x in w:
		for y in h:
			if i < cells.size():
				map[x][y].from_dict(cells[i])
			i += 1
	refresh_all()
