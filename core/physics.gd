class_name AIPPos
## Port of cAIPosition.pas / cAIForce.pas - 2.5D physics per entity.
## The simulation keeps X/Y on the planet plane and H as altitude.

var x := 0.0
var y := 0.0
var h := 0.0
var direction_xy := 0.0
var direction_h := 0.0
var mass := 1.0
var bounce := 0.3
var buoyancy := 0.2
var size := Vector3(1, 1, 1)
var land := 0.0
var water := 0.0
var binding := AIP.Binding.AIR
var tangible := true
var underwater := false
var carried := false
var collider := true
var velocity := Vector3.ZERO
var acceleration := Vector3.ZERO
var thing = null


func copy_into(target: AIPPos) -> void:
	target.x = x
	target.y = y
	target.h = h
	target.velocity = velocity
	target.acceleration = acceleration


func cell(space: AIPSpace) -> AIPCell:
	return space.cell_at_world(Vector2(x, y))


func refresh_binding(space: AIPSpace) -> void:
	var cell := cell(space)
	if cell == null:
		return
	land = cell.land_height()
	water = cell.water_height()
	underwater = h < water - 0.05 and cell.underwater
	if h > 100.0:
		binding = AIP.Binding.SPACE
	elif underwater:
		binding = AIP.Binding.WATER
	elif h <= land + 0.05:
		binding = AIP.Binding.LAND
	else:
		binding = AIP.Binding.AIR


func integrate(space: AIPSpace) -> void:
	velocity += acceleration
	velocity.y += AIP.GRAVITY
	refresh_binding(space)
	match binding:
		AIP.Binding.LAND:
			velocity *= Vector3(AIP.LAND_FRICTION, 1.0, AIP.LAND_FRICTION)
		AIP.Binding.WATER:
			velocity *= Vector3(AIP.WATER_FRICTION, AIP.WATER_FRICTION, AIP.WATER_FRICTION)
			velocity.y += buoyancy * 0.08
			if velocity.y > 0.02:
				velocity.y = 0.02
		AIP.Binding.AIR:
			velocity *= Vector3(AIP.AIR_FRICTION, 1.0, AIP.AIR_FRICTION)
	var max_speed := 8.0
	if velocity.length() > max_speed:
		velocity = velocity.normalized() * max_speed
	x += velocity.x
	y += velocity.z
	h += velocity.y
	if thing != null and thing.swims():
		h = lerpf(h, water - 0.2, 0.2)
	var wrapped: Vector2 = space.wrap_point(Vector2(x, y))
	x = wrapped.x
	y = wrapped.y
	var cell := cell(space)
	if cell != null:
		var floor_h := land
		if underwater:
			floor_h = land
		if h < floor_h:
			h = floor_h
			if velocity.y < 0.0:
				velocity.y = -velocity.y * bounce
				if absf(velocity.y) < 0.02:
					velocity.y = 0.0
			var slope: Vector3 = cell.normal
			velocity.x += slope.x * 0.05
			velocity.z += slope.z * 0.05
	acceleration = Vector3.ZERO
	if velocity.length() > 0.001:
		direction_xy = atan2(velocity.z, velocity.x)
		direction_h = asin(clampf(velocity.y / maxf(velocity.length(), 0.001), -1.0, 1.0))


func apply_force(v: Vector3) -> void:
	acceleration += v


func seek(target: Vector3, strength: float) -> void:
	var dir := Vector3(target.x - x, (target.y - h) * 0.3, target.z - y)
	if dir.length() > 0.01:
		apply_force(dir.normalized() * strength)


func to_dict() -> Dictionary:
	return {"x": x, "y": y, "h": h, "direction_xy": direction_xy,
			"direction_h": direction_h, "mass": mass, "bounce": bounce,
			"buoyancy": buoyancy, "size": [size.x, size.y, size.z],
			"land": land, "water": water, "binding": binding,
			"tangible": tangible, "underwater": underwater,
			"carried": carried, "collider": collider,
			"velocity": [velocity.x, velocity.y, velocity.z],
			"acceleration": [acceleration.x, acceleration.y, acceleration.z]}


func from_dict(d: Dictionary) -> void:
	x = d.get("x", 0.0)
	y = d.get("y", 0.0)
	h = d.get("h", 0.0)
	direction_xy = d.get("direction_xy", 0.0)
	direction_h = d.get("direction_h", 0.0)
	mass = d.get("mass", 1.0)
	bounce = d.get("bounce", 0.3)
	buoyancy = d.get("buoyancy", 0.2)
	var s: Array = d.get("size", [1, 1, 1])
	size = Vector3(s[0], s[1], s[2])
	land = d.get("land", 0.0)
	water = d.get("water", 0.0)
	binding = d.get("binding", AIP.Binding.AIR)
	tangible = d.get("tangible", true)
	underwater = d.get("underwater", false)
	carried = d.get("carried", false)
	collider = d.get("collider", true)
	var v: Array = d.get("velocity", [0, 0, 0])
	velocity = Vector3(v[0], v[1], v[2])
	var a: Array = d.get("acceleration", [0, 0, 0])
	acceleration = Vector3(a[0], a[1], a[2])
