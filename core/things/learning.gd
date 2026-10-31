class_name AIPLearningCreature
extends AIPCommunityCreature
## Port of cAILearningCreature.pas - episodic food memory (AIReportCard).
## Chooses food by weight/distance and remembers whether meals helped.

var reports := {}
var meals := 0
var bad_meals := 0


func report_for(k: int) -> Dictionary:
	if not reports.has(k):
		reports[k] = {"success": 0, "total": 0, "weight": 1.0}
	return reports[k]


func _sense() -> void:
	super._sense()
	var diets: Array = species().get("prey", [])
	if diets.is_empty():
		return
	var candidates: Array = world.hash.query_radius(Vector2(pos.x, pos.y), 250.0)
	var best = null
	var best_score := 0.0
	for c in candidates:
		if c == self or not c.exists or not diets.has(c.kind):
			continue
		var d := Vector2(c.pos.x - pos.x, c.pos.y - pos.y).length()
		if d > 250.0:
			continue
		var r := report_for(c.kind)
		var score: float = r["weight"] / maxf(d, 1.0)
		if score > best_score:
			best_score = score
			best = c
	if best != null:
		target = best


func _try_eat() -> void:
	if target == null or not is_instance_valid(target) or not target.exists:
		return
	var before := health
	var eaten_kind: int = target.kind
	super._try_eat()
	if health > before:
		meals += 1
		var r := report_for(eaten_kind)
		r["success"] = int(r["success"]) + 1
		r["total"] = int(r["total"]) + 1
		r["weight"] = minf(float(r["weight"]) + 0.1, 5.0)
	elif health == before and target != null and not is_instance_valid(target):
		bad_meals += 1
		var r := report_for(eaten_kind)
		r["total"] = int(r["total"]) + 1
		r["weight"] = maxf(float(r["weight"]) - 0.2, 0.05)
		if randf() < 0.1:
			talk("That " + target.display_name() + " was yucky")


func full_display() -> String:
	var text := super.full_display()
	text += "\nMeals: " + str(meals) + " (bad: " + str(bad_meals) + ")"
	for k in reports:
		var r: Dictionary = reports[k]
		text += "\n  " + AIP.SPECIES[k]["name"] + ": " + str(r["success"]) + "/" + str(r["total"]) \
				+ " weight " + "%.2f" % float(r["weight"])
	return text


func _save_extra(d: Dictionary) -> void:
	super._save_extra(d)
	d["reports"] = reports
	d["meals"] = meals
	d["bad_meals"] = bad_meals


func _load_extra(d: Dictionary) -> void:
	super._load_extra(d)
	reports = d.get("reports", {})
	meals = int(d.get("meals", 0))
	bad_meals = int(d.get("bad_meals", 0))
