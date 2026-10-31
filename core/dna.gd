class_name AIPDNA
## Port of cAIDNA.pas - heritable genome with mutation on reproduction.

var mutation := 0.1
var growth_rate := 1.0
var size_max := 1.0
var mass_max := 2.0
var buoyancy := 0.2
var bounce := 0.3
var preferred_food := 0
var red := 0.8
var green := 0.5
var blue := 0.3
var lifespan := AIP.MATING_ELDER_TICKS


static func from_ini(path: String) -> AIPDNA:
	var dna := AIPDNA.new()
	var cfg := ConfigFile.new()
	if cfg.load(path) == OK and cfg.has_section("DNA"):
		dna.mutation = cfg.get_value("DNA", "Mutation", dna.mutation)
		dna.growth_rate = cfg.get_value("DNA", "GrowthRate", dna.growth_rate)
		dna.size_max = cfg.get_value("DNA", "SizeMax", dna.size_max)
		dna.mass_max = cfg.get_value("DNA", "MassMax", dna.mass_max)
		dna.buoyancy = cfg.get_value("DNA", "Buoyancy", dna.buoyancy)
		dna.bounce = cfg.get_value("DNA", "Bounce", dna.bounce)
		dna.preferred_food = int(cfg.get_value("DNA", "PreferredFood", dna.preferred_food))
		dna.red = cfg.get_value("DNA", "Red", dna.red)
		dna.green = cfg.get_value("DNA", "Green", dna.green)
		dna.blue = cfg.get_value("DNA", "Blue", dna.blue)
		dna.lifespan = int(cfg.get_value("DNA", "Lifespan", dna.lifespan))
	return dna


static func combine(a: AIPDNA, b: AIPDNA) -> AIPDNA:
	var dna := AIPDNA.new()
	var m := (a.mutation + b.mutation) * 0.5
	dna.mutation = _mutate_value(m, m)
	dna.growth_rate = _mutate_value((a.growth_rate + b.growth_rate) * 0.5, m)
	dna.size_max = _mutate_value((a.size_max + b.size_max) * 0.5, m)
	dna.mass_max = _mutate_value((a.mass_max + b.mass_max) * 0.5, m)
	dna.buoyancy = _mutate_value((a.buoyancy + b.buoyancy) * 0.5, m)
	dna.bounce = _mutate_value((a.bounce + b.bounce) * 0.5, m)
	dna.red = clampf(_mutate_value((a.red + b.red) * 0.5, m), 0.0, 1.0)
	dna.green = clampf(_mutate_value((a.green + b.green) * 0.5, m), 0.0, 1.0)
	dna.blue = clampf(_mutate_value((a.blue + b.blue) * 0.5, m), 0.0, 1.0)
	dna.preferred_food = a.preferred_food if randf() < 0.5 else b.preferred_food
	dna.lifespan = int(_mutate_value((a.lifespan + b.lifespan) * 0.5, m))
	return dna


static func _mutate_value(v: float, mutation_rate: float) -> float:
	return v * (1.0 + randf_range(-mutation_rate, mutation_rate))


func color() -> Color:
	return Color(red, green, blue, 1.0)


func to_dict() -> Dictionary:
	return {"mutation": mutation, "growth_rate": growth_rate, "size_max": size_max,
			"mass_max": mass_max, "buoyancy": buoyancy, "bounce": bounce,
			"preferred_food": preferred_food, "red": red, "green": green,
			"blue": blue, "lifespan": lifespan}


func from_dict(d: Dictionary) -> void:
	mutation = d.get("mutation", 0.1)
	growth_rate = d.get("growth_rate", 1.0)
	size_max = d.get("size_max", 1.0)
	mass_max = d.get("mass_max", 2.0)
	buoyancy = d.get("buoyancy", 0.2)
	bounce = d.get("bounce", 0.3)
	preferred_food = int(d.get("preferred_food", 0))
	red = d.get("red", 0.8)
	green = d.get("green", 0.5)
	blue = d.get("blue", 0.3)
	lifespan = int(d.get("lifespan", AIP.MATING_ELDER_TICKS))
