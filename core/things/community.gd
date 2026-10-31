class_name AIPCommunity
## Port of cAICommunity.pas - flock/community of creatures (boids).

var members: Array = []
var max_members := 40
var center := Vector3.ZERO
var heading := Vector3.ZERO
var kind_filter: int = -1


func _init(p_kind: int = -1) -> void:
	kind_filter = p_kind


func admit(creature) -> bool:
	if members.size() >= max_members:
		return false
	if kind_filter >= 0 and creature.kind != kind_filter:
		return false
	members.append(creature)
	return true


func leave(creature) -> void:
	members.erase(creature)


func update() -> void:
	if members.is_empty():
		return
	var c := Vector3.ZERO
	var h := Vector3.ZERO
	var count := 0
	for m in members:
		if m == null or not m.exists:
			continue
		c += m.world_pos()
		h += m.pos.velocity
		count += 1
	if count == 0:
		members.clear()
		return
	center = c / float(count)
	heading = h / float(count)


func cohesion(creature) -> Vector3:
	var to_c: Vector3 = center - creature.world_pos()
	var d: float = to_c.length()
	if d < 30.0:
		return Vector3.ZERO
	return to_c.normalized() * 0.06


func alignment(creature) -> Vector3:
	return heading.normalized() * 0.02 if heading.length() > 0.01 else Vector3.ZERO


func separation(creature) -> Vector3:
	var push := Vector3.ZERO
	for m in members:
		if m == null or m == creature or not m.exists:
			continue
		var diff: Vector3 = creature.world_pos() - m.world_pos()
		var d: float = diff.length()
		if d > 0.01 and d < 10.0:
			push += diff.normalized() * (10.0 - d) * 0.01
	return push
