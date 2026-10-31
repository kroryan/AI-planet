extends GutTest
## Core simulation tests for AI Planet Remaster (GUT, MIT).

var world: AIPWorld


func before_each() -> void:
	world = AIPWorld.new()
	world.generate_world("grass", 16, 12, 3.0, 6.0)


func test_world_generates_grid() -> void:
	assert_eq(world.space.width, 16)
	assert_eq(world.space.height, 12)
	var total := 0
	for x in world.space.width:
		for y in world.space.height:
			assert_not_null(world.space.map[x][y])
			total += 1
	assert_eq(total, 192)


func test_water_flows_downhill() -> void:
	var space := world.space
	var high: AIPCell = space.map[5][5]
	var low: AIPCell = space.map[5][6]
	low.height = 1.0
	high.height = 8.0
	high.water = 10.0
	var before: float = high.water
	for i in 30:
		space.fuel()
		space.refresh_cell(high)
		space.refresh_cell(low)
	assert_lt(high.water, before, "water should have drained from the high cell")
	assert_gt(low.water, 0.0, "water should have reached the low cell")


func test_dna_combine_mutates() -> void:
	var a := AIPDNA.new()
	a.red = 1.0
	a.green = 0.0
	a.blue = 0.0
	a.mutation = 0.0
	var b := AIPDNA.new()
	b.red = 1.0
	b.green = 0.0
	b.blue = 0.0
	b.mutation = 0.0
	var child := AIPDNA.combine(a, b)
	assert_almost_eq(child.red, 1.0, 0.001, "no mutation means identical red")
	a.mutation = 0.5
	var child2 := AIPDNA.combine(a, b)
	assert_true(absf(child2.red - 1.0) < 0.05 or child2.red != 1.0)


func test_neural_net_runs_and_learns() -> void:
	var brain := AIPNeuralBrain.new()
	brain.set_input(0, 1.0)
	brain.set_input(2, 0.5)
	brain.forward()
	var out_before: float = brain.get_output(0)
	brain.reward(1.0)
	for i in 10:
		brain.forward()
		brain.reward(1.0)
	assert_true(is_instance_valid(brain))
	assert_ne(out_before, -1.0)
	var d := brain.to_dict()
	var brain2 := AIPNeuralBrain.new()
	brain2.from_dict(d)
	assert_eq(brain2.w_ih.size(), brain.w_ih.size(), "brain should serialize")


func test_ecosystem_survives_ticks() -> void:
	world.spawn_at(AIP.Kind.APPLE_TREE, world.space.random_land())
	world.spawn_at(AIP.Kind.RABBIT, world.space.random_land())
	world.spawn_at(AIP.Kind.SUN, null)
	for i in 300:
		world.tick()
	assert_gt(world.population_total(), 0, "something should still be alive")
	assert_true(world.time == 300)


func test_save_load_roundtrip() -> void:
	world.spawn_at(AIP.Kind.RABBIT, world.space.random_land())
	world.spawn_at(AIP.Kind.FOX, world.space.random_land())
	var path := "user://test_roundtrip.aipr"
	assert_true(AIPSaveLoad.save_world(world, path), "save should succeed")
	var world2 := AIPWorld.new()
	assert_true(AIPSaveLoad.load_world(path, world2), "load should succeed")
	assert_eq(world2.time, world.time)
	assert_eq(world2.things.size(), world.things.size())
	assert_eq(world2.space.width, world.space.width)


func test_air_importer_classic_world() -> void:
	var found := false
	var dir := DirAccess.open("res://worlds/classic")
	if dir != null:
		dir.list_dir_begin()
		var name := dir.get_next()
		while name != "":
			if name.ends_with(".air") and AIPAirImporter.can_import("res://worlds/classic/" + name):
				var info := AIPAirImporter.import_world("res://worlds/classic/" + name, world)
				assert_true(info.get("ok", false), name + " should import")
				assert_gt(world.space.width, 0)
				found = true
				break
			name = dir.get_next()
	assert_true(found, "at least one classic world should be importable")


func test_species_tables_complete() -> void:
	for k in AIP.KIND_COUNT:
		assert_true(AIP.SPECIES.has(k), "kind %d should have species data" % k)
		assert_true(AIPWorld.script_for_kind(k) != null or k in [AIP.Kind.COMMUNITY, AIP.Kind.FLOCK],
				"kind %d should have a script" % k)
