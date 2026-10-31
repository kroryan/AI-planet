extends Node
## AI Planet Remaster - global autoload (port of cGlobals.pas).
## Owns the world instance, the tick loop and player settings.

const TICK_RATE := 25.0

signal world_replaced
signal world_loaded(info)

var world := AIPWorld.new()
var paused := true
var speed_multiplier := 1.0
var accumulator := 0.0
var classic_worlds: PackedStringArray = []
var settings := {
	"shadows": true,
	"audio": true,
	"volume_db": 0.0,
	"language": "",
	"last_world": "",
}


func _ready() -> void:
	process_priority = -100
	_scan_classic_worlds()
	_load_settings()
	var locale: String = settings.get("language", "")
	if locale != "":
		TranslationServer.set_locale(locale)
	new_world("continents", 40, 24, 2.0, 8.0, true)


func _process(delta: float) -> void:
	if paused or world == null:
		return
	accumulator += delta * TICK_RATE * speed_multiplier
	var guard := 0
	while accumulator >= 1.0 and guard < 32:
		world.tick()
		accumulator -= 1.0
		guard += 1
	if guard >= 32:
		accumulator = 0.0


func new_world(preset: String = "grass", w: int = 40, h: int = 24,
		water_level := 2.0, hill_height := 6.0, with_life := true) -> void:
	world = AIPWorld.new()
	world.generate_world(preset, w, h, water_level, hill_height)
	if with_life:
		seed_life(preset)
	paused = true
	world_replaced.emit()


func seed_life(preset: String = "grass") -> void:
	var space := world.space
	if preset != "barren":
		for i in 6:
			world.spawn_at(AIP.Kind.APPLE_TREE if i % 2 == 0 else AIP.Kind.ORANGE_TREE, space.random_land())
		for i in 40:
			world.spawn_at(AIP.Kind.GRASS, space.random_land())
		for i in 6:
			world.spawn_at(AIP.Kind.RABBIT, space.random_land())
		for i in 4:
			world.spawn_at(AIP.Kind.FISH, space.random_location())
		for i in 2:
			world.spawn_at(AIP.Kind.FOX, space.random_land())
		for i in 2:
			world.spawn_at(AIP.Kind.BIRD, space.random_land())
		for i in 2:
			world.spawn_at(AIP.Kind.DUCK, space.random_location())
		world.spawn_at(AIP.Kind.SHARK, space.random_location())
		world.spawn_at(AIP.Kind.TURTLE, space.random_location())
		for i in 3:
			world.spawn_at(AIP.Kind.ANT, space.random_land())


func load_classic(path: String) -> void:
	var info := AIPAirImporter.import_world(path, world)
	if info.get("ok", false):
		paused = true
		world_loaded.emit(info)
		world_replaced.emit()
	else:
		push_error("AIR import failed: " + str(info.get("error", "?")))


func save_game(path: String) -> bool:
	settings["last_world"] = path
	_save_settings()
	return AIPSaveLoad.save_world(world, path)


func load_game(path: String) -> bool:
	var ok := AIPSaveLoad.load_world(path, world)
	if ok:
		paused = true
		world_replaced.emit()
	return ok


func _scan_classic_worlds() -> void:
	var dir := DirAccess.open("res://worlds/classic")
	if dir == null:
		return
	dir.list_dir_begin()
	var name := dir.get_next()
	while name != "":
		if name.ends_with(".air") and AIPAirImporter.can_import("res://worlds/classic/" + name):
			classic_worlds.append(name)
		name = dir.get_next()
	dir.list_dir_end()
	classic_worlds.sort()


func _settings_path() -> String:
	return OS.get_user_data_dir() + "/settings.json"


func _load_settings() -> void:
	var f := FileAccess.open(_settings_path(), FileAccess.READ)
	if f == null:
		return
	var parsed = JSON.parse_string(f.get_as_text())
	f.close()
	if parsed is Dictionary:
		for k in parsed:
			settings[k] = parsed[k]


func _save_settings() -> void:
	var f := FileAccess.open(_settings_path(), FileAccess.WRITE)
	if f != null:
		f.store_string(JSON.stringify(settings))
		f.close()


func set_speed(mult: float) -> void:
	speed_multiplier = clampf(mult, 0.25, 8.0)


func toggle_pause() -> void:
	paused = not paused


func step_one_tick() -> void:
	if world != null:
		world.tick()
