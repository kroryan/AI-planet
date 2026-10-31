class_name AIPGame
extends Node3D
## Builds the 3D scene, bridges simulation signals to visuals and applies
## godly tools picked on the planet (port of fm3DEnvironment + tools).

var world
var camera: AIPGameCamera
var planet: AIPPlanetView
var effects: AIPEffects
var sun_light: DirectionalLight3D
var env: Environment
var entity_root: Node3D
var views := {}
var selected = null
var hud = null

const TOOL_IDS := [
	"select", "kill", "water", "sponge", "heat", "cool", "humidify",
	"raise", "lower", "flatten", "mountain", "valley", "grass", "tree",
	"firetree", "evolving", "apple", "orange", "rabbit", "fox", "bird",
	"fish", "duck", "shark", "turtle", "crab", "ladybug", "ant", "mouse",
	"grazer", "dolphin", "trex", "tiger", "terrier", "hawk", "bot",
	"ball", "bomb", "beacon", "earthquake", "cloud", "iceberg",
	"asteroid", "missiledefence", "sun", "moon",
]


func _ready() -> void:
	world = W.world
	W.world_replaced.connect(_on_world_replaced)
	_build_scene()
	hud = get_node_or_null(^"HUD")
	var menu := get_node_or_null(^"MainMenu")
	if hud != null and menu != null:
		hud.menu_requested.connect(menu.show)
	_on_world_replaced()
	if "--shot" in OS.get_cmdline_user_args():
		_capture_shots()


func _capture_shots() -> void:
	W.paused = true
	await get_tree().process_frame
	for i in 90:
		await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png("/tmp/aip_menu.png")
	var menu := get_node_or_null(^"MainMenu")
	print("SHOT menu visible=", menu.visible if menu != null else "null",
			" size=", menu.size if menu != null else "-")
	if menu != null:
		menu.hide()
	W.paused = false
	W.set_speed(4.0)
	for i in 150:
		await get_tree().process_frame
	get_viewport().get_texture().get_image().save_png("/tmp/aip_game.png")
	get_tree().quit()


func _connect_world() -> void:
	if world.thing_added.is_connected(_track):
		return
	world.thing_added.connect(_track)
	world.thing_removed.connect(_untrack)
	world.effect_requested.connect(_on_effect)
	world.camera_shake.connect(_on_shake)
	world.vibe.connect(_on_vibe)


func _on_shake(s: float) -> void:
	camera.add_shake(s)


func _build_scene() -> void:
	env = Environment.new()
	env.background_mode = Environment.BG_SKY
	env.ambient_light_source = Environment.AMBIENT_SOURCE_SKY
	env.ambient_light_energy = 1.1
	env.sky = Sky.new()
	var sky_mat := ProceduralSkyMaterial.new()
	sky_mat.sky_top_color = Color(0.25, 0.45, 0.85)
	sky_mat.sky_horizon_color = Color(0.65, 0.78, 0.92)
	sky_mat.ground_bottom_color = Color(0.18, 0.22, 0.3)
	env.sky.sky_material = sky_mat
	env.fog_enabled = true
	env.fog_light_color = Color(0.75, 0.82, 0.92)
	env.fog_density = 0.002
	var world_env := WorldEnvironment.new()
	world_env.environment = env
	add_child(world_env)
	sun_light = DirectionalLight3D.new()
	sun_light.shadow_enabled = true
	sun_light.light_energy = 1.3
	sun_light.add_to_group("aip_lights")
	add_child(sun_light)
	camera = AIPGameCamera.new()
	add_child(camera)
	camera.make_current()
	entity_root = Node3D.new()
	entity_root.name = "Entities"
	add_child(entity_root)
	effects = AIPEffects.new()
	add_child(effects)


func _on_world_replaced() -> void:
	world = W.world
	for v in views.values():
		if is_instance_valid(v):
			v.queue_free()
	views.clear()
	if planet != null:
		planet.queue_free()
	planet = AIPPlanetView.new()
	add_child(planet)
	planet.build(world)
	for t in world.things:
		_track(t)
	var center := Vector3(world.space.width * AIP.CELL_SIZE * 0.5, 0,
			world.space.height * AIP.CELL_SIZE * 0.5)
	camera.center_on(center)
	camera.distance = maxf(world.space.width, world.space.height) * AIP.CELL_SIZE * 1.2
	_connect_world()
	if hud != null:
		hud.refresh_tool_visibility()


func _track(thing) -> void:
	if thing == null or thing.kind in [AIP.Kind.COMMUNITY, AIP.Kind.FLOCK,
			AIP.Kind.VIBE, AIP.Kind.EXPLOSION, AIP.Kind.EARTHQUAKE]:
		return
	var view := AIPEntityView.new()
	view.setup(thing)
	entity_root.add_child(view)
	views[thing.handle] = view


func _untrack(thing) -> void:
	var view = views.get(thing.handle)
	if view != null and is_instance_valid(view):
		view.queue_free()
	views.erase(thing.handle)
	if selected == thing and hud != null:
		hud.set_selected(null)


func _process(delta: float) -> void:
	for handle in views:
		var view = views[handle]
		if view != null and is_instance_valid(view):
			view.sync_from_sim(delta)
	var sun = world.by_handle.get(_first_handle_of(AIP.Kind.SUN))
	if sun != null:
		var p: Vector3 = sun.world_pos()
		if p.length() > 1.0:
			sun_light.look_at_from_position(p, Vector3.ZERO)
			sun_light.visible = true
	else:
		var moon = world.by_handle.get(_first_handle_of(AIP.Kind.MOON))
		if moon != null:
			var mp: Vector3 = moon.world_pos()
			if mp.length() > 1.0:
				sun_light.look_at_from_position(mp, Vector3.ZERO)
				sun_light.light_energy = 0.25


func _first_handle_of(kind: int) -> int:
	for t in world.things:
		if t.exists and t.kind == kind:
			return t.handle
	return -1


func _on_effect(kind_name: String, at: Vector3, param) -> void:
	effects.on_effect(kind_name, at * Vector3(1, 0.6, 1), param)


func _on_vibe(v, sound: String) -> void:
	var origin = world.by_handle.get(v.custom.get("origin", -1)) if v != null else null
	var at: Vector3 = origin.world_pos() if origin != null else Vector3.ZERO
	effects.play_sound(sound, at)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		_apply_pointer(event.position)
	elif event is InputEventScreenTouch and event.pressed and event.index == 0:
		_apply_pointer(event.position)


func _apply_pointer(screen_pos: Vector2) -> void:
	if hud == null:
		return
	var tool: String = hud.current_tool
	var from := camera.project_ray_origin(screen_pos)
	var dir := camera.project_ray_normal(screen_pos)
	if tool == "select":
		_pick_entity(from, dir)
		return
	var cell: AIPCell = planet.pick_cell(from, dir)
	if cell == null:
		return
	apply_tool(tool, cell, from, dir)


func _pick_entity(from: Vector3, dir: Vector3) -> void:
	var best = null
	var best_t := 1e9
	for t in world.things:
		if not t.exists or t.kind in [AIP.Kind.COMMUNITY, AIP.Kind.FLOCK, AIP.Kind.VIBE,
				AIP.Kind.SPEECH, AIP.Kind.EXPLOSION]:
			continue
		var p: Vector3 = t.world_pos()
		var to: Vector3 = p - from
		var proj: float = to.dot(dir)
		if proj < 0:
			continue
		var closest := from + dir * proj
		if closest.distance_to(p) < 14.0 and proj < best_t:
			best_t = proj
			best = t
	if best != null:
		hud.set_selected(best)
		var view = views.get(best.handle)
		if view != null:
			camera.follow(view)


func apply_tool(tool: String, cell: AIPCell, from: Vector3 = Vector3.ZERO,
		dir: Vector3 = Vector3.ZERO) -> void:
	match tool:
		"kill":
			var kill_kinds := []
			for k in AIP.SPECIES:
				if k not in [AIP.Kind.COMMUNITY, AIP.Kind.FLOCK, AIP.Kind.VIBE,
						AIP.Kind.SPEECH, AIP.Kind.EXPLOSION, AIP.Kind.EARTHQUAKE,
						AIP.Kind.SUN, AIP.Kind.MOON]:
					kill_kinds.append(k)
			var victim = world.hash.nearest(Vector2(cell.center().x, cell.center().z),
					kill_kinds, null, 30.0)
			if victim != null:
				victim.cease()
				effects.burst(victim.world_pos(), Color(0.9, 0.2, 0.2), 20, 5.0, 0.8)
		"water":
			cell.queue_water(2.0)
			effects.play_sound("watersploosh", cell.center())
		"sponge":
			cell.queue_water(-2.0)
		"heat":
			cell.queue_temperature(1.0)
		"cool":
			cell.queue_temperature(-1.0)
		"humidify":
			cell.queue_humidity(2.0)
		"raise":
			cell.queue_height(2.0)
			effects.play_sound("rocksmash", cell.center())
		"lower":
			cell.queue_height(-2.0)
		"flatten":
			var avg := 0.0
			for n in cell.links:
				avg += n.height
			avg /= maxf(1.0, float(cell.links.size()))
			cell.queue_height((avg - cell.height) * 0.5)
		"mountain":
			for dx in 2:
				for dy in 2:
					var n: AIPCell = world.space.wrap_cell(cell.x + dx - 1, cell.y + dy - 1)
					if n != null:
						n.queue_height(6.0 / (1.0 + Vector2i(dx - 1, dy - 1).length()))
		"valley":
			for dx in 2:
				for dy in 2:
					var n: AIPCell = world.space.wrap_cell(cell.x + dx - 1, cell.y + dy - 1)
					if n != null:
						n.queue_height(-6.0 / (1.0 + Vector2i(dx - 1, dy - 1).length()))
		"grass":
			world.spawn_at(AIP.Kind.GRASS, cell)
		"tree":
			world.spawn_at(AIP.Kind.APPLE_TREE if randf() < 0.5 else AIP.Kind.ORANGE_TREE, cell)
		"firetree":
			world.spawn_at(AIP.Kind.FIRE_TREE, cell)
		"evolving":
			var t = world.spawn_at(AIP.Kind.EVOLVING_TREE, cell)
			if t != null and t is AIPPlants.EvolvingTree:
				t.setup_evolving()
		"apple":
			world.spawn_at(AIP.Kind.APPLE, cell)
		"orange":
			world.spawn_at(AIP.Kind.ORANGE, cell)
		"rabbit":
			world.spawn_at(AIP.Kind.RABBIT, cell)
		"fox":
			world.spawn_at(AIP.Kind.FOX, cell)
		"bird":
			world.spawn_at(AIP.Kind.BIRD, cell)
		"fish":
			world.spawn_at(AIP.Kind.FISH, cell)
		"duck":
			world.spawn_at(AIP.Kind.DUCK, cell)
		"shark":
			world.spawn_at(AIP.Kind.SHARK, cell)
		"turtle":
			world.spawn_at(AIP.Kind.TURTLE, cell)
		"crab":
			world.spawn_at(AIP.Kind.CRAB, cell)
		"ladybug":
			world.spawn_at(AIP.Kind.LADYBUG, cell)
		"ant":
			world.spawn_at(AIP.Kind.ANT, cell)
		"mouse":
			world.spawn_at(AIP.Kind.MOUSE, cell)
		"grazer":
			world.spawn_at(AIP.Kind.GRAZER, cell)
		"dolphin":
			world.spawn_at(AIP.Kind.DOLPHIN, cell)
		"trex":
			world.spawn_at(AIP.Kind.TREX, cell)
		"tiger":
			world.spawn_at(AIP.Kind.TIGER, cell)
		"terrier":
			world.spawn_at(AIP.Kind.TERRIER, cell)
		"hawk":
			world.spawn_at(AIP.Kind.HAWK, cell)
		"bot":
			world.spawn_at(AIP.Kind.BOT, cell)
		"ball":
			world.spawn_at(AIP.Kind.BALL, cell)
		"bomb":
			var b = world.spawn_at(AIP.Kind.BOMB, cell)
			if b != null:
				b.pos.h = cell.land_height() + 8.0
		"beacon":
			world.spawn_at(AIP.Kind.BEACON, cell)
		"earthquake":
			world.spawn_at(AIP.Kind.EARTHQUAKE, cell)
			world.log_event("An earthquake begins!")
		"cloud":
			W.world.try_spawn_cloud(cell)
		"iceberg":
			world.spawn_at(AIP.Kind.ICEBERG, cell)
		"asteroid":
			var a = world.spawn_at(AIP.Kind.ASTEROID, cell)
			if a != null:
				a.pos.h = 180.0
		"missiledefence":
			var md = world.spawn_at(AIP.Kind.MISSILE_DEFENCE, cell)
			if md != null:
				md.pos.h = 90.0
		"sun":
			if world.population(AIP.Kind.SUN) == 0:
				world.spawn_at(AIP.Kind.SUN, cell)
		"moon":
			if world.population(AIP.Kind.MOON) == 0:
				world.spawn_at(AIP.Kind.MOON, cell)
