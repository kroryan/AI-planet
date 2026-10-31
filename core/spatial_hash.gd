class_name AIPSpatialHash
## Improvement over the original linear scans (cAIThingReferenceList.pas):
## uniform spatial hash over the planet plane for nearest queries.

var cell := 40.0
var buckets := {}


func clear() -> void:
	buckets.clear()


func _key(p: Vector2) -> Vector2i:
	return Vector2i(int(p.x / cell), int(p.y / cell))


func insert(thing) -> void:
	var k := _key(Vector2(thing.pos.x, thing.pos.y))
	if not buckets.has(k):
		buckets[k] = []
	buckets[k].append(thing)


func rebuild(things: Array) -> void:
	clear()
	for t in things:
		if t.exists and t.pos.tangible:
			insert(t)


func query_radius(p: Vector2, radius: float) -> Array:
	var result := []
	var r := int(ceil(radius / cell))
	var base := _key(p)
	for dx in range(-r, r + 1):
		for dy in range(-r, r + 1):
			var k := Vector2i(base.x + dx, base.y + dy)
			if buckets.has(k):
				result.append_array(buckets[k])
	return result


func nearest(p: Vector2, kinds: Array, exclude, max_radius: float = 400.0):
	var best = null
	var best_d := max_radius * max_radius
	var candidates := query_radius(p, max_radius)
	for t in candidates:
		if t == exclude or not t.exists or not kinds.has(t.kind):
			continue
		var dx: float = t.pos.x - p.x
		var dy: float = t.pos.y - p.y
		var d2 := dx * dx + dy * dy
		if d2 < best_d:
			best_d = d2
			best = t
	return best


func nearest_of_kind(p: Vector2, kind: int, exclude, max_radius: float = 400.0):
	return nearest(p, [kind], exclude, max_radius)
