class_name AIPPlants
## Flora: trees (apple/orange), fruit, seed, grass, aqua plant, fire tree and
## the evolving tree family (DNA-driven, port of cAIEvolvingTrees.pas).


class AppTree extends AIPThing:
	var fruit_kind := AIP.Kind.APPLE
	var seed_kind := AIP.Kind.APPLE_SEED
	var sapling := true
	var fruit_timer := 0

	func _act() -> bool:
		var cell: AIPCell = pos.cell(world.space)
		if cell == null:
			return true
		if sapling and age_ticks() > 400:
			sapling = false
			pos.size *= 2.0
		if age_ticks() > 2560:
			die("old age")
			return false
		if cell.underwater and cell.water > 1.0:
			health -= 4.0
		if sapling:
			return true
		if cell.humidity > 1.0 and randf() < 0.01:
			cell.queue_humidity(-0.05)
		fruit_timer -= 1
		if fruit_timer <= 0 and cell.humidity > 0.5 and randf() < 0.05:
			fruit_timer = randi_range(64, 192)
			_drop_fruit()
		return true

	func _drop_fruit() -> void:
		var fruit = world.spawn_at(fruit_kind, pos.cell(world.space))
		if fruit != null:
			fruit.pos.x = pos.x + randf_range(-5.0, 5.0)
			fruit.pos.y = pos.y + randf_range(-5.0, 5.0)
			fruit.pos.h = pos.h + 6.0

	func _on_death() -> void:
		var seed = world.spawn_at(seed_kind, pos.cell(world.space))
		if seed != null:
			seed.pos.x = pos.x
			seed.pos.y = pos.y
			seed.pos.h = pos.h


class Fruit extends AIPThing:
	func _act() -> bool:
		if age_ticks() > 1200:
			_become_seed()
			return false
		if pos.binding == AIP.Binding.LAND and randf() < 0.001:
			var seed = world.spawn_at(AIP.Kind.APPLE_SEED if kind == AIP.Kind.APPLE else AIP.Kind.ORANGE_SEED,
					world.space.cell_at_world(Vector2(pos.x, pos.y)))
			if seed != null:
				seed.pos.x = pos.x
				seed.pos.y = pos.y
				seed.pos.h = pos.h + 1.0
		return true

	func _become_seed() -> void:
		die("rotten")
		cease()

	func is_fruit() -> bool:
		return true


class Seed extends AIPThing:
	func _act() -> bool:
		var cell: AIPCell = pos.cell(world.space)
		if cell == null:
			return true
		if age_ticks() > 2000:
			cease()
			return false
		if pos.binding == AIP.Binding.LAND and cell.water >= 0.5 and cell.humidity > 1.0:
			if world.hash.nearest_of_kind(Vector2(pos.x, pos.y), AIP.Kind.APPLE_TREE,
					self, 50.0) == null and world.hash.nearest_of_kind(
					Vector2(pos.x, pos.y), AIP.Kind.ORANGE_TREE, self, 50.0) == null:
				_germinate()
				return false
		return true

	func _germinate() -> void:
		var tree = world.spawn_at(AIP.Kind.APPLE_TREE if kind == AIP.Kind.APPLE_SEED else AIP.Kind.ORANGE_TREE,
				world.space.cell_at_world(Vector2(pos.x, pos.y)))
		if tree != null:
			tree.pos.x = pos.x
			tree.pos.y = pos.y
			world.log_event("A seed sprouted into a tree")
		cease()


class Grass extends AIPThing:
	func _act() -> bool:
		if age_ticks() > AIP.GRASS_SPREAD_TICKS * 4:
			die("withered")
			return false
		if age_ticks() % AIP.GRASS_SPREAD_TICKS == 0:
			var cell: AIPCell = pos.cell(world.space)
			if cell != null and cell.humidity > 2.0 and not cell.underwater:
				for dir in [Vector2i(1, 0), Vector2i(-1, 0), Vector2i(0, 1), Vector2i(0, -1)]:
					if randf() < 0.25:
						var n: AIPCell = world.space.wrap_cell(cell.x + dir.x * 2, cell.y + dir.y * 2)
						if n != null and not n.underwater and n.humidity > 1.0:
							world.spawn_at(AIP.Kind.GRASS, n)
		return true

	func is_fruit() -> bool:
		return true


class AquaPlant extends AIPThing:
	func _act() -> bool:
		if not pos.underwater:
			health -= 2.0
		return true

	func is_fruit() -> bool:
		return true


class FireTree extends AppTree:
	var burning := 0.0

	func _act() -> bool:
		var cell: AIPCell = pos.cell(world.space)
		if cell != null:
			if burning > 0.0:
				burning -= 0.01
				if randf() < 0.05:
					_ignite_neighbors()
				if cell.underwater or cell.humidity > 6.0:
					burning = 0.0
					world.log_event("A forest fire was extinguished")
				if burning <= 0.0:
					die("burned")
					return false
			elif cell.temperature > 9.0 and randf() < 0.001:
				burning = 1.0
				noise("fire")
				world.log_event("A tree caught fire!")
		return super._act()

	func _ignite_neighbors() -> void:
		var near: Array = world.hash.query_radius(Vector2(pos.x, pos.y), 25.0)
		for t in near:
			if t.kind == AIP.Kind.FIRE_TREE and t is FireTree and not t.burning:
				t.burning = 1.0

	func _drop_fruit() -> void:
		pass


class EvolvingTree extends AppTree:
	var dna: AIPDNA = null

	func setup_evolving() -> void:
		if dna == null:
			var path := "res://data/dna/evolving tree.ini"
			dna = AIPDNA.from_ini(path) if FileAccess.file_exists(path) else AIPDNA.new()
			if world != null and world.forms.has(AIP.Kind.EVOLVING_TREE):
				dna = world.forms[AIP.Kind.EVOLVING_TREE]
		fruit_kind = AIP.Kind.EVOLVING_FRUIT
		seed_kind = AIP.Kind.EVOLVING_SEED

	func _act() -> bool:
		setup_evolving()
		return super._act()


class EvolvingFruit extends Fruit:
	var dna: AIPDNA = null

	func setup_evolving(parent_dna: AIPDNA = null) -> void:
		if dna == null:
			dna = AIPDNA.from_ini("res://data/dna/evolving fruit.ini") if FileAccess.file_exists(
					"res://data/dna/evolving fruit.ini") else AIPDNA.new()
			if parent_dna != null:
				dna = AIPDNA.combine(parent_dna, dna)
			pos.buoyancy = dna.buoyancy
			pos.bounce = dna.bounce

	func _become_seed() -> void:
		var seed = world.spawn_at(AIP.Kind.EVOLVING_SEED,
				world.space.cell_at_world(Vector2(pos.x, pos.y)))
		if seed != null and seed is EvolvingSeed:
			seed.setup_evolving(dna)
			seed.pos.x = pos.x
			seed.pos.y = pos.y
		cease()


class EvolvingSeed extends Seed:
	var dna: AIPDNA = null

	func setup_evolving(parent_dna: AIPDNA = null) -> void:
		if dna == null:
			dna = AIPDNA.from_ini("res://data/dna/evolving seed.ini") if FileAccess.file_exists(
					"res://data/dna/evolving seed.ini") else AIPDNA.new()
			if parent_dna != null:
				dna = AIPDNA.combine(parent_dna, dna)

	func _germinate() -> void:
		var tree = world.spawn_at(AIP.Kind.EVOLVING_TREE,
				world.space.cell_at_world(Vector2(pos.x, pos.y)))
		if tree != null and tree is EvolvingTree:
			tree.setup_evolving()
			if dna != null:
				tree.dna = AIPDNA.combine(dna, tree.dna)
			tree.pos.x = pos.x
			tree.pos.y = pos.y
			world.log_event("An evolving seed sprouted!")
		cease()
