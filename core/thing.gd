class_name AIPThing
## Port of cAIThings.pas AIThing + cAILife.pas AILivingThing.

var kind: int = 0
var handle: int = 0
var pos := AIPPos.new()
var birthday: int = 0
var exists := true
var purgatory := false
var health: float = AIP.MAX_HEALTH
var water_level: float = AIP.MAX_HEALTH
var rot: int = 0
var age: int = 0
var world = null
var custom := {}


func _init() -> void:
	pos.thing = self


func setup(p_world = null, p_kind: int = 0) -> void:
	world = p_world
	kind = p_kind
	_setup()
	_species_setup()


func _setup() -> void:
	pass


func _species_setup() -> void:
	pass


func species() -> Dictionary:
	return AIP.SPECIES.get(kind, {})


func display_name() -> String:
	return species().get("name", "Thing")


func alive() -> bool:
	return health > 0.0 and exists and not purgatory


func age_ticks() -> int:
	return age


func is_fruit() -> bool:
	return kind in [AIP.Kind.APPLE, AIP.Kind.ORANGE, AIP.Kind.EVOLVING_FRUIT,
			AIP.Kind.APPLE_SEED, AIP.Kind.ORANGE_SEED, AIP.Kind.EVOLVING_SEED,
			AIP.Kind.GRASS, AIP.Kind.AQUA_PLANT]


func is_prey() -> bool:
	return species().has("meat")


func is_predator() -> bool:
	return species().has("prey")


func swims() -> bool:
	return species().get("habitat", "") == "water"


func flies() -> bool:
	return species().get("habitat", "") == "air"


func fuel() -> void:
	if not alive():
		if exists:
			_decompose()
		return
	age = world.time - birthday
	if not _act():
		return
	health = max(0.0, health - 1.0)


func _act() -> bool:
	return true


func _decompose() -> void:
	rot += 1
	if rot > AIP.ROT_TICKS:
		cease()


func die(reason := "") -> void:
	if not alive():
		return
	health = 0.0
	world.log_event(display_name() + " died" + (" (" + reason + ")" if reason != "" else ""),
			self)
	_on_death()


func _on_death() -> void:
	pass


func damage(amount: float, source = null) -> void:
	health -= amount
	if health <= 0.0:
		die("attacked by " + (source.display_name() if source != null else "unknown"))


func digest(food: float) -> float:
	var before := health
	health = min(AIP.MAX_HEALTH * 2.0, health + food)
	return health - before


func cease() -> void:
	if purgatory:
		return
	purgatory = true
	exists = false
	world.notify_removed(self)


func talk(text: String) -> void:
	world.speak(self, text)


func noise(sound: String) -> void:
	world.emit_vibe(self, sound)


func world_pos() -> Vector3:
	return Vector3(pos.x, pos.h, pos.y)


func to_dict() -> Dictionary:
	var d := {"kind": kind, "handle": handle, "birthday": birthday,
			"exists": exists, "health": health, "water_level": water_level,
			"rot": rot, "pos": pos.to_dict(), "custom": custom}
	_save_extra(d)
	return d


func from_dict(d: Dictionary) -> void:
	handle = int(d.get("handle", handle))
	birthday = int(d.get("birthday", 0))
	exists = d.get("exists", true)
	health = d.get("health", AIP.MAX_HEALTH)
	water_level = d.get("water_level", AIP.MAX_HEALTH)
	rot = int(d.get("rot", 0))
	custom = d.get("custom", {})
	pos.from_dict(d.get("pos", {}))
	_load_extra(d)


func _save_extra(_d: Dictionary) -> void:
	pass


func _load_extra(_d: Dictionary) -> void:
	pass


func full_display() -> String:
	var lines := [
		display_name() + " #" + str(handle),
		"Age: " + str(age_ticks()) + " ticks",
		"Health: " + str(int(health)),
		"Position: (%.1f, %.1f) height %.1f" % [pos.x, pos.y, pos.h],
		"Binding: " + str(AIP.Binding.keys()[pos.binding]) if pos.binding < AIP.Binding.size() else "?",
	]
	return "\n".join(lines)
