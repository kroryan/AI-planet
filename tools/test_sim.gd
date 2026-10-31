extends SceneTree
## Headless smoke test: generates a world, runs 600 ticks, prints populations.


func _init() -> void:
	var world := AIPWorld.new()
	world.generate_world("grass", 30, 18, 2.0, 6.0)
	for i in 6:
		world.spawn_at(AIP.Kind.APPLE_TREE, world.space.random_land())
	for i in 40:
		world.spawn_at(AIP.Kind.GRASS, world.space.random_land())
	for i in 6:
		world.spawn_at(AIP.Kind.RABBIT, world.space.random_land())
	for i in 2:
		world.spawn_at(AIP.Kind.FOX, world.space.random_land())
	for i in 4:
		world.spawn_at(AIP.Kind.FISH, world.space.random_location())
	for i in 2:
		world.spawn_at(AIP.Kind.BIRD, world.space.random_land())
	world.spawn_at(AIP.Kind.SUN, null)
	world.spawn_at(AIP.Kind.MOON, null)
	for tick in 600:
		world.tick()
	var report := ""
	for k in [AIP.Kind.RABBIT, AIP.Kind.FOX, AIP.Kind.GRASS, AIP.Kind.APPLE_TREE,
			AIP.Kind.BIRD, AIP.Kind.FISH, AIP.Kind.APPLE, AIP.Kind.CLOUD]:
		report += "%s=%d " % [AIP.SPECIES[k]["name"], world.population(k)]
	print("TICKS=600 ", report)
	print("TOTAL=", world.population_total(), " THINGS=", world.things.size())
	var under := 0
	var cells := 0
	for x in world.space.width:
		for y in world.space.height:
			cells += 1
			if world.space.map[x][y].underwater:
				under += 1
	print("WATER_CELLS=", under, "/", cells)
	var save_ok := AIPSaveLoad.save_world(world, "/tmp/test.aipr")
	var world2 := AIPWorld.new()
	var load_ok := save_ok and AIPSaveLoad.load_world("/tmp/test.aipr", world2)
	print("SAVE=", save_ok, " LOAD=", load_ok, " THINGS_AFTER=", world2.things.size())
	quit(0 if load_ok else 1)
