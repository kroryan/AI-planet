class_name AIPCreature
extends AIPThing
## Port of cAICreature.pas - base creature with desires, senses and foraging.
## Includes the remaster's real neural brain hook (the original cAINeuralNet.pas
## was an unimplemented stub; here it drives steering, trained by reinforcement).

var desire: int = AIP.Desire.WANDER
var target = null
var grabber = null
var brain: AIPNeuralBrain = null
var eat_timer := 0
var wander_dir := randf() * TAU
var last_health := AIP.MAX_HEALTH


func _act() -> bool:
	if not super._act():
		return false
	last_health = health
	_sense()
	_decide()
	_perform()
	_learn()
	return true


func _sense() -> void:
	var p := Vector2(pos.x, pos.y)
	var diets: Array = species().get("prey", [])
	target = world.hash.nearest(p, diets, self) if not diets.is_empty() else null
	if brain == null:
		return
	var nearest_dist := 1.0
	var nearest_dir := 0.0
	if target != null:
		var dx: float = target.pos.x - pos.x
		var dy: float = target.pos.y - pos.y
		nearest_dist = clampf(Vector2(dx, dy).length() / 300.0, 0.0, 1.0)
		nearest_dir = atan2(dy, dx)
	brain.set_input(0, health / AIP.MAX_HEALTH)
	brain.set_input(1, clampf(age_ticks() / float(AIP.MATING_ELDER_TICKS), 0.0, 1.0))
	brain.set_input(2, nearest_dist)
	brain.set_input(3, sin(nearest_dir - wander_dir))
	brain.set_input(4, 1.0 if pos.underwater else 0.0)
	brain.set_input(5, clampf((pos.h - pos.land) / 20.0, 0.0, 1.0))


func _decide() -> void:
	if brain != null:
		brain.forward()
		wander_dir += (brain.get_output(0) - 0.5) * 1.2
	if age_ticks() > species_lifespan() * 0.9:
		desire = AIP.Desire.RETIRE
	elif health < AIP.MAX_HEALTH * 0.4 and target != null:
		desire = AIP.Desire.FOOD
	elif target != null and randf() < 0.8:
		desire = AIP.Desire.FOOD
	else:
		desire = AIP.Desire.WANDER


func species_lifespan() -> int:
	return AIP.MATING_ELDER_TICKS


func _perform() -> void:
	match desire:
		AIP.Desire.FOOD:
			if target == null or not is_instance_valid(target) or not target.exists:
				desire = AIP.Desire.WANDER
				return
			pos.seek(target.world_pos(), speed() * 0.35)
			_try_eat()
		AIP.Desire.RETIRE:
			pos.apply_force(Vector3(randf_range(-0.05, 0.05), -0.02, randf_range(-0.05, 0.05)))
		_:
			_wander()


func _wander() -> void:
	wander_dir += randf_range(-0.2, 0.2)
	var v := Vector3(cos(wander_dir), 0.0, sin(wander_dir)) * speed() * 0.12
	if flies():
		v.y = clampf((species_cruise_height() - pos.h) * 0.01, -0.1, 0.1)
	elif swims():
		v.y = 0.0
	pos.apply_force(v)


func species_cruise_height() -> float:
	return 25.0


func speed() -> float:
	return species().get("speed", 0.5)


func _try_eat() -> void:
	if target == null or not is_instance_valid(target) or not target.exists:
		return
	if eat_timer > 0:
		eat_timer -= 1
		return
	var d := Vector2(target.pos.x - pos.x, target.pos.y - pos.y).length()
	if d < 8.0 and absf(target.pos.h - pos.h) < 10.0:
		if target.is_prey():
			target.damage(99999.0, self)
			health = min(AIP.MAX_HEALTH * 2.0, health + target.species().get("meat", 128.0))
			noise("crunch")
		else:
			health = min(AIP.MAX_HEALTH * 2.0, health + target.species().get("food", 32.0))
			target.cease()
		eat_timer = 32
		if brain != null:
			brain.reward(1.0)


func _learn() -> void:
	if brain == null:
		return
	var delta: float = health - last_health
	if absf(delta) > 0.5:
		brain.reward(clampf(delta / 128.0, -1.0, 1.0))
	brain.decay_reward(0.999)


func _save_extra(d: Dictionary) -> void:
	super._save_extra(d)
	d["desire"] = desire
	if brain != null:
		d["brain"] = brain.to_dict()


func _load_extra(d: Dictionary) -> void:
	super._load_extra(d)
	desire = int(d.get("desire", AIP.Desire.WANDER))
	if d.has("brain"):
		if brain == null:
			brain = AIPNeuralBrain.new()
		brain.from_dict(d["brain"])
