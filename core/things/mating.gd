class_name AIPMatingCreature
extends AIPCommunityCreature
## Port of cAIMating.pas - gender, life stages, partners and births.

var gender := 0  # 0 male, 1 female
var partner = null
var mate_cooldown := 0
var pregnant := false


func _setup() -> void:
	super._setup()
	gender = 1 if randf() < 0.5 else 0


func is_baby() -> bool:
	return age_ticks() < AIP.MATING_BABY_TICKS


func is_adult() -> bool:
	return age_ticks() >= AIP.MATING_BABY_TICKS and age_ticks() < species_lifespan()


func _act() -> bool:
	if not super._act():
		return false
	if mate_cooldown > 0:
		mate_cooldown -= 1
	if age_ticks() >= species_lifespan():
		die("old age")
		return false
	if is_adult() and mate_cooldown <= 0:
		_mating_drive()
	if pregnant and gender == 1:
		give_birth()
	return true


func _mating_drive() -> void:
	if desire != AIP.Desire.WANDER and desire != AIP.Desire.FOOD:
		return
	if health < AIP.MAX_HEALTH * 0.7:
		return
	if partner == null or not is_instance_valid(partner) or not partner.exists:
		partner = _find_partner()
		if partner != null and partner.partner == null:
			partner.partner = self
	if partner != null and partner.exists:
		desire = AIP.Desire.MATE
		pos.seek(partner.world_pos(), speed() * 0.3)
		var d := Vector2(partner.pos.x - pos.x, partner.pos.y - pos.y).length()
		if d < 10.0 and gender == 1 and health > AIP.BIRTH_COST:
			pregnant = true
			mate_cooldown = AIP.MATING_COOLDOWN
			partner.mate_cooldown = AIP.MATING_COOLDOWN


func _find_partner():
	var candidates: Array = world.hash.query_radius(Vector2(pos.x, pos.y), 120.0)
	var best = null
	var best_d := 120.0
	for c in candidates:
		if c == self or c.kind != kind or not c.alive():
			continue
		if not c.is_adult() or c.mate_cooldown > 0 or c.gender == gender or c.partner != null:
			continue
		var d := Vector2(c.pos.x - pos.x, c.pos.y - pos.y).length()
		if d < best_d:
			best_d = d
			best = c
	return best


func give_birth() -> void:
	pregnant = false
	health -= AIP.BIRTH_COST
	if health <= 0.0:
		die("childbirth")
		return
	var baby = world.spawn_at(kind, world.space.cell_at_world(Vector2(pos.x, pos.y)))
	if baby != null:
		baby.birthday = world.time
		baby.health = AIP.MAX_HEALTH * 0.5
		world.log_event("A " + display_name() + " was born", self)
		_on_birth(baby)


func _on_birth(baby) -> void:
	if baby is AIPCommunityCreature and community != null:
		baby.join_community(community)


func _save_extra(d: Dictionary) -> void:
	super._save_extra(d)
	d["gender"] = gender
	d["pregnant"] = pregnant
	d["mate_cooldown"] = mate_cooldown
	if partner != null and is_instance_valid(partner):
		d["partner_handle"] = partner.handle


func _load_extra(d: Dictionary) -> void:
	super._load_extra(d)
	gender = int(d.get("gender", 0))
	pregnant = d.get("pregnant", false)
	mate_cooldown = int(d.get("mate_cooldown", 0))
