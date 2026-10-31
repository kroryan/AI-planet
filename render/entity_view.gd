class_name AIPEntityView
extends Node3D
## Visual proxy for one simulation thing: original .3ds model (now .glb),
## DNA tinting, speech bubbles and simple bobbing animation.

var thing
var model: Node3D
var label: Label3D
var _base_y := 0.0
var _t := randf() * TAU

static var _scene_cache := {}


static func scene_for_kind(kind: int) -> PackedScene:
	if _scene_cache.has(kind):
		return _scene_cache[kind]
	var model_name: String = AIP.SPECIES.get(kind, {}).get("model", "")
	var path := "res://assets/models/%s.glb" % model_name
	var ps: PackedScene = null
	if model_name != "" and ResourceLoader.exists(path):
		ps = load(path)
	_scene_cache[kind] = ps
	return ps


func setup(p_thing) -> void:
	thing = p_thing
	var ps := scene_for_kind(thing.kind)
	if ps != null:
		model = ps.instantiate()
		var sc: float = AIP.SPECIES.get(thing.kind, {}).get("scale", 1.0)
		model.scale = Vector3.ONE * sc * 2.0
		add_child(model)
		_apply_dna_tint()
	if thing is AIPTools.Speech:
		label = Label3D.new()
		label.text = thing.text
		label.font_size = 64
		label.billboard = BaseMaterial3D.BILLBOARD_ENABLED
		label.modulate = Color(1, 1, 0.6)
		label.no_depth_test = true
		label.pixel_size = 0.02
		add_child(label)


func _apply_dna_tint() -> void:
	var color := Color.WHITE
	if thing is AIPGeneticCreature and thing.dna != null:
		color = thing.dna.color()
	elif thing is AIPPlants.EvolvingFruit and thing.dna != null:
		color = thing.dna.color()
	if color == Color.WHITE:
		return
	for child in _iter_meshes(model):
		var mesh_inst: MeshInstance3D = child
		var mat := mesh_inst.get_active_material(0)
		if mat is StandardMaterial3D:
			var dup: StandardMaterial3D = mat.duplicate()
			dup.albedo_color = dup.albedo_color.lerp(color, 0.7)
			mesh_inst.material_override = dup


func _iter_meshes(node) -> Array:
	var result := []
	if node is MeshInstance3D:
		result.append(node)
	for c in node.get_children():
		result.append_array(_iter_meshes(c))
	return result


func sync_from_sim(delta: float) -> void:
	if thing == null or thing.purgatory or not thing.exists:
		return
	var p: Vector3 = thing.world_pos()
	_t += delta
	var bob := 0.0
	if thing.flies():
		bob = sin(_t * 6.0) * 0.6
	elif thing.alive() and thing.pos.binding == AIP.Binding.LAND:
		bob = absf(sin(_t * 8.0)) * 0.15
	position = Vector3(p.x, p.y * 0.6 + bob, p.z)
	if model != null:
		var target_yaw: float = thing.pos.direction_xy
		model.rotation.y = lerp_angle(model.rotation.y, -target_yaw, 0.2)
	if label != null:
		label.position = Vector3(0, 3.0 + sin(_t * 2.0) * 0.2, 0)
