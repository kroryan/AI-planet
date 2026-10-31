class_name AIPGameCamera
extends Camera3D
## Orbit / follow / free camera with mouse + touch support.

signal moved

var pivot := Vector3.ZERO
var distance := 220.0
var yaw := 0.6
var pitch := 0.9
var follow_target: AIPEntityView = null
var shake := 0.0
var _dragging := false
var _pinch_start := 0.0


func _ready() -> void:
	_update_transform()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT or event.button_index == MOUSE_BUTTON_MIDDLE:
			_dragging = event.pressed
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			distance = clampf(distance * 0.9, 20.0, 900.0)
			_update_transform()
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			distance = clampf(distance * 1.1, 20.0, 900.0)
			_update_transform()
	elif event is InputEventMouseMotion and _dragging:
		yaw -= event.relative.x * 0.005
		pitch = clampf(pitch + event.relative.y * 0.004, 0.15, 1.5)
		follow_target = null
		_update_transform()
	elif event is InputEventScreenTouch:
		if event.index == 0:
			_dragging = event.pressed
	elif event is InputEventScreenDrag and _dragging and event.index == 0:
		yaw -= event.relative.x * 0.006
		pitch = clampf(pitch + event.relative.y * 0.005, 0.15, 1.5)
		follow_target = null
		_update_transform()


func _process(delta: float) -> void:
	if follow_target != null and is_instance_valid(follow_target):
		pivot = follow_target.position
		_update_transform()
	if shake > 0.001:
		shake = lerpf(shake, 0.0, delta * 4.0)
		var offset := Vector3(randf_range(-1, 1), randf_range(-1, 1), randf_range(-1, 1)) * shake * 4.0
		global_position += offset


func _update_transform() -> void:
	var offset := Vector3(
		cos(yaw) * cos(pitch),
		sin(pitch),
		sin(yaw) * cos(pitch)) * distance
	global_position = pivot + offset
	look_at(pivot, Vector3.UP)
	moved.emit()


func center_on(p: Vector3) -> void:
	pivot = p
	follow_target = null
	_update_transform()


func follow(view: AIPEntityView) -> void:
	follow_target = view
	distance = clampf(distance, 30.0, 120.0)


func add_shake(strength: float) -> void:
	shake = clampf(maxf(shake, strength), 0.0, 1.5)
