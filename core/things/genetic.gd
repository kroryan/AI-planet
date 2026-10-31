class_name AIPGeneticCreature
extends AIPMatingCreature
## Port of cAIGeneticCreature.pas - creatures with heritable DNA that mutates
## at birth. Species default DNA comes from data/dna/<species>.ini.

var dna: AIPDNA = null


func setup_dna() -> void:
	if dna != null:
		return
	dna = AIPDNA.new()
	var ini := "res://data/dna/" + dna_ini_name() + ".ini"
	if FileAccess.file_exists(ini):
		dna = AIPDNA.from_ini(ini)
		if world != null and world.forms.has(kind):
			dna = world.forms[kind]
	pos.buoyancy = dna.buoyancy
	pos.bounce = dna.bounce
	pos.mass = clampf(dna.mass_max * 0.5, 0.5, 5.0)


func dna_ini_name() -> String:
	match kind:
		AIP.Kind.FOX:
			return "fox"
		AIP.Kind.RABBIT:
			return "rabbit"
		AIP.Kind.LADYBUG:
			return "ladybug"
		_:
			return ""


func species_lifespan() -> int:
	if dna != null and kind == AIP.Kind.LADYBUG:
		return dna.lifespan
	return super.species_lifespan()


func _act() -> bool:
	if dna == null:
		setup_dna()
	return super._act()


func _on_birth(baby) -> void:
	super._on_birth(baby)
	if baby is AIPGeneticCreature and dna != null and baby.dna != null:
		var father: AIPDNA = partner.dna if partner != null and is_instance_valid(partner) and partner.dna != null else dna
		baby.dna = AIPDNA.combine(dna, father)


func dna_color() -> Color:
	return dna.color() if dna != null else Color.WHITE


func _save_extra(d: Dictionary) -> void:
	super._save_extra(d)
	if dna != null:
		d["dna"] = dna.to_dict()


func _load_extra(d: Dictionary) -> void:
	super._load_extra(d)
	if d.has("dna"):
		setup_dna()
		dna.from_dict(d["dna"])
