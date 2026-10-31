class_name AIPWorld
## Port of cAIReality.pas + cAIEnvironment.pas + AIThingList - owns the whole
## simulation. Rendering only listens to signals; the sim stays headless-safe.

signal thing_added(thing)
signal thing_removed(thing)
signal event_logged(text, thing)
signal speech(thing, text)
signal vibe(thing, sound)
signal camera_shake(strength)
signal effect_requested(kind_name, position, param)
signal stats_tick

const SPECIES_SCRIPTS := {}

var space := AIPSpace.new()
var things: Array = []
var by_handle := {}
var communities: Array = []
var hash := AIPSpatialHash.new()
var forms := {}
var time := 0
var unique_handle := 1
var creator := "User"
var collisions_enabled := true
var ai_enabled := true
var meteors_enabled := false
var maximums := {}
var counters := {}
var stats_history: Array = []
var running := true
var speed := 1.0
var step_mode := false


func _init() -> void:
	space.world = self
	for i in AIP.KIND_COUNT:
		maximums[i] = AIP.SPECIES.get(i, {}).get("max", 100)
		counters[i] = 0
	_load_forms()


func _load_forms() -> void:
	for k in [AIP.Kind.FOX, AIP.Kind.RABBIT, AIP.Kind.LADYBUG]:
		var ini := "res://data/dna/"
		match k:
			AIP.Kind.FOX:
				ini += "fox.ini"
			AIP.Kind.RABBIT:
				ini += "rabbit.ini"
			AIP.Kind.LADYBUG:
				ini += "ladybug.ini"
		if FileAccess.file_exists(ini):
			forms[k] = AIPDNA.from_ini(ini)
	for k in [AIP.Kind.EVOLVING_TREE, AIP.Kind.EVOLVING_FRUIT, AIP.Kind.EVOLVING_SEED]:
		var path := "res://data/dna/evolving %s.ini" % ["tree" if k == AIP.Kind.EVOLVING_TREE
				else "fruit" if k == AIP.Kind.EVOLVING_FRUIT else "seed"]
		if FileAccess.file_exists(path):
			forms[k] = AIPDNA.from_ini(path)


static func script_for_kind(k: int) -> GDScript:
	match k:
		AIP.Kind.APPLE, AIP.Kind.ORANGE, AIP.Kind.EVOLVING_FRUIT:
			if k == AIP.Kind.EVOLVING_FRUIT:
				return AIPPlants.EvolvingFruit
			return AIPPlants.Fruit
		AIP.Kind.APPLE_TREE, AIP.Kind.ORANGE_TREE:
			return AIPPlants.AppTree
		AIP.Kind.APPLE_SEED, AIP.Kind.ORANGE_SEED:
			return AIPPlants.Seed
		AIP.Kind.EVOLVING_TREE:
			return AIPPlants.EvolvingTree
		AIP.Kind.AQUA_PLANT:
			return AIPPlants.AquaPlant
		AIP.Kind.GRASS:
			return AIPPlants.Grass
		AIP.Kind.FIRE_TREE:
			return AIPPlants.FireTree
		AIP.Kind.EVOLVING_SEED:
			return AIPPlants.EvolvingSeed
		AIP.Kind.BIRD:
			return AIPSpeciesMating.Bird
		AIP.Kind.FISH:
			return AIPSpeciesMating.Fish
		AIP.Kind.DUCK:
			return AIPSpeciesMating.Duck
		AIP.Kind.GRAZER:
			return AIPSpeciesMating.Grazer
		AIP.Kind.FOX:
			return AIPSpeciesGenetic.Fox
		AIP.Kind.RABBIT:
			return AIPSpeciesGenetic.Rabbit
		AIP.Kind.LADYBUG:
			return AIPSpeciesGenetic.Ladybug
		AIP.Kind.CRAB:
			return AIPSpeciesLearning.Crab
		AIP.Kind.TURTLE:
			return AIPSpeciesLearning.Turtle
		AIP.Kind.SHARK, AIP.Kind.HAWK, AIP.Kind.TREX, AIP.Kind.TIGER, AIP.Kind.TERRIER, \
		AIP.Kind.MOUSE, AIP.Kind.BOT:
			match k:
				AIP.Kind.SHARK:
					return AIPSpeciesSimple.Shark
				AIP.Kind.HAWK:
					return AIPSpeciesSimple.Hawk
				AIP.Kind.TREX:
					return AIPSpeciesSimple.Trex
				AIP.Kind.TIGER:
					return AIPSpeciesSimple.Tiger
				AIP.Kind.TERRIER:
					return AIPSpeciesSimple.Terrier
				AIP.Kind.MOUSE:
					return AIPSpeciesSimple.Mouse
				_:
					return AIPSpeciesSimple.Bot
		AIP.Kind.ANT:
			return AIPSpeciesSimple.Ant
		AIP.Kind.DOLPHIN:
			return AIPSpeciesSimple.Dolphin
		AIP.Kind.CLOUD:
			return AIPWeather.Cloud
		AIP.Kind.LIGHTNING:
			return AIPWeather.Lightning
		AIP.Kind.ICEBERG:
			return AIPWeather.Iceberg
		AIP.Kind.EARTHQUAKE:
			return AIPWeather.Earthquake
		AIP.Kind.SUN:
			return AIPSpaceThings.Sun
		AIP.Kind.MOON:
			return AIPSpaceThings.Moon
		AIP.Kind.ASTEROID:
			return AIPSpaceThings.Asteroid
		AIP.Kind.MISSILE_DEFENCE:
			return AIPSpaceThings.MissileDefence
		AIP.Kind.MISSILE:
			return AIPSpaceThings.Missile
		AIP.Kind.WEAPON:
			return AIPTools.Weapon
		AIP.Kind.BALL:
			return AIPTools.Ball
		AIP.Kind.BOMB:
			return AIPTools.Bomb
		AIP.Kind.BEACON:
			return AIPTools.Beacon
		AIP.Kind.EXPLOSION:
			return AIPTools.Explosion
		AIP.Kind.VIBE:
			return AIPTools.Vibe
		AIP.Kind.SPEECH:
			return AIPTools.Speech
		_:
			return null


func spawn_at(k: int, cell: AIPCell):
	if counters.get(k, 0) >= maximums.get(k, 100):
		return null
	var script := script_for_kind(k)
	if script == null:
		return null
	var thing = script.new()
	thing.setup(self, k)
	thing.handle = unique_handle
	unique_handle += 1
	if cell != null:
		var c: Vector3 = cell.center()
		thing.pos.x = c.x + randf_range(-4.0, 4.0)
		thing.pos.y = c.z + randf_range(-4.0, 4.0)
		thing.pos.h = cell.land_height() + 1.0 if not cell.underwater else cell.water_height()
	var sc: float = AIP.SPECIES.get(k, {}).get("scale", 1.0)
	thing.pos.size = Vector3(sc, sc, sc)
	thing.birthday = time
	if thing is AIPGeneticCreature:
		thing.setup_dna()
	things.append(thing)
	by_handle[thing.handle] = thing
	counters[k] = counters.get(k, 0) + 1
	thing_added.emit(thing)
	return thing


func notify_removed(thing) -> void:
	thing_removed.emit(thing)


func add_community(comm: AIPCommunity) -> void:
	communities.append(comm)


func communities_of(kind: int) -> Array:
	var result := []
	for c in communities:
		if c.kind_filter == kind:
			result.append(c)
	return result


func tick() -> void:
	time += 1
	var alive_now := things.filter(func(t): return t.exists)
	hash.rebuild(alive_now)
	for c in communities:
		c.update()
	if collisions_enabled:
		_check_collisions(alive_now)
	var snapshot := things.duplicate()
	for t in snapshot:
		if t.exists and not t.purgatory:
			if ai_enabled or not (t is AIPCreature):
				t.fuel()
			else:
				if t.pos.tangible:
					t.pos.integrate(space)
	var rest := []
	for t in things:
		if t.exists and not t.purgatory:
			rest.append(t)
		else:
			counters[t.kind] = max(0, counters.get(t.kind, 0) - 1)
	things = rest
	for c in communities:
		if c.members.is_empty():
			communities.erase(c)
	if time % 25 == 0:
		_record_stats()
		stats_tick.emit()


func _check_collisions(pool: Array) -> void:
	for t in pool:
		if not t.pos.collider or not t.pos.tangible:
			continue
		var near := hash.query_radius(Vector2(t.pos.x, t.pos.y), 8.0)
		for o in near:
			if o == t or not o.exists or not o.pos.collider:
				continue
			if o.handle < t.handle:
				continue
			var diff: Vector3 = t.world_pos() - o.world_pos()
			var d := diff.length()
			var min_d: float = (t.pos.size.x + o.pos.size.x) * 1.5
			if d < min_d and d > 0.001:
				var push: Vector3 = diff.normalized() * (min_d - d) * 0.5
				t.pos.apply_force(push)
				o.pos.apply_force(-push)


func _record_stats() -> void:
	var snapshot := {}
	for k in AIP.KIND_COUNT:
		var c: int = counters.get(k, 0)
		if c > 0:
			snapshot[k] = c
	stats_history.append({"time": time, "counts": snapshot})
	if stats_history.size() > 1000:
		stats_history.pop_front()


func explode(at: Vector3, radius: float, style: String) -> void:
	var e = spawn_at(AIP.Kind.EXPLOSION, space.cell_at_world(Vector2(at.x, at.z)))
	if e != null:
		e.radius = radius
		e.style = style
		e.pos.x = at.x
		e.pos.y = at.z
		e.pos.h = at.y
		e.pos.tangible = false
		e.pos.collider = false
	effect_requested.emit(style, at, radius)


func spawn_meteor() -> void:
	var cell: AIPCell = space.random_location()
	var a = spawn_at(AIP.Kind.ASTEROID, cell)
	if a != null:
		a.pos.h = 160.0
		a.pos.velocity = Vector3(randf_range(-0.5, 0.5), -0.3, randf_range(-0.5, 0.5))


func try_spawn_cloud(cell: AIPCell) -> void:
	if cell == null:
		return
	var c = spawn_at(AIP.Kind.CLOUD, cell)
	if c != null:
		c.pos.h = 45.0


func try_spawn_iceberg(cell: AIPCell) -> void:
	if cell != null:
		spawn_at(AIP.Kind.ICEBERG, cell)


func speak(thing, text: String) -> void:
	var s = spawn_at(AIP.Kind.SPEECH, space.cell_at_world(Vector2(thing.pos.x, thing.pos.y)))
	if s != null:
		s.text = text
		s.pos.x = thing.pos.x
		s.pos.y = thing.pos.y
		s.pos.h = thing.pos.h + 5.0
		s.pos.tangible = false
	speech.emit(thing, text)


func emit_vibe(thing, sound: String) -> void:
	var v = spawn_at(AIP.Kind.VIBE, space.cell_at_world(Vector2(thing.pos.x, thing.pos.y)))
	if v != null:
		v.custom = {"sound": sound, "origin": thing.handle}
		v.pos.tangible = false


func play_vibe(v) -> void:
	vibe.emit(v, v.custom.get("sound", ""))


func spawn_rain_effect(cloud) -> void:
	effect_requested.emit("rain", cloud.world_pos(), cloud.water_mass)


func spawn_explosion_effect(e) -> void:
	effect_requested.emit(e.style, e.world_pos(), e.radius)


func shake_camera(strength: float) -> void:
	camera_shake.emit(strength)


func log_event(text: String, thing = null) -> void:
	event_logged.emit(text, thing)


func to_dict() -> Dictionary:
	var things_data := []
	for t in things:
		if t.exists:
			things_data.append(t.to_dict())
	return {"version": AIP.VERSION, "creator": creator, "time": time,
			"unique_handle": unique_handle, "collisions": collisions_enabled,
			"ai": ai_enabled, "meteors": meteors_enabled,
			"maximums": str(var_to_str(maximums)),
			"space": space.to_dict(), "things": things_data,
			"stats_history": stats_history}


func from_dict(d: Dictionary) -> void:
	creator = d.get("creator", "User")
	time = int(d.get("time", 0))
	unique_handle = int(d.get("unique_handle", 1))
	collisions_enabled = d.get("collisions", true)
	ai_enabled = d.get("ai", true)
	meteors_enabled = d.get("meteors", false)
	if d.has("maximums"):
		maximums = str_to_var(d["maximums"])
	things.clear()
	by_handle.clear()
	communities.clear()
	counters = {}
	for i in AIP.KIND_COUNT:
		counters[i] = 0
	space.from_dict(d.get("space", {}))
	for td in d.get("things", []):
		var k: int = int(td.get("kind", 0))
		var script := script_for_kind(k)
		if script == null:
			continue
		var t = script.new()
		t.setup(self, k)
		t.from_dict(td)
		things.append(t)
		by_handle[t.handle] = t
		counters[k] = counters.get(k, 0) + 1
		thing_added.emit(t)
	stats_history = d.get("stats_history", [])


func generate_world(preset: String, w: int, h: int, water_level: float,
		hill_height: float, with_sun := true) -> void:
	things.clear()
	by_handle.clear()
	communities.clear()
	counters = {}
	for i in AIP.KIND_COUNT:
		counters[i] = 0
	time = 0
	space.generate(preset, w, h, water_level, hill_height)
	if with_sun:
		spawn_at(AIP.Kind.SUN, null)
		spawn_at(AIP.Kind.MOON, null)


func population(k: int) -> int:
	return counters.get(k, 0)


func population_total() -> int:
	var total := 0
	for k in counters:
		total += counters[k]
	return total
