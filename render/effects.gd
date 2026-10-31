class_name AIPEffects
extends Node3D
## Visual + audio effects: explosions, rain bursts, fire, 3D positional audio
## from the original 40 wav set (now .ogg, GPL-2.0 originals).

const EXPLOSION_COLORS := {
	"nuke": Color(1.0, 0.75, 0.2), "asteroid": Color(1.0, 0.55, 0.2),
	"bomb": Color(1.0, 0.6, 0.25), "lightning": Color(0.7, 0.8, 1.0),
	"fire": Color(1.0, 0.4, 0.1), "shot": Color(1.0, 0.9, 0.7),
	"shock": Color(0.8, 0.9, 1.0), "blast": Color(1.0, 0.65, 0.3),
}

var _sounds := {}
var _fallback_sound: AudioStream = null


func _ready() -> void:
	var dir := DirAccess.open("res://assets/audio")
	if dir != null:
		dir.list_dir_begin()
		var name := dir.get_next()
		while name != "":
			if name.ends_with(".ogg"):
				_sounds[name.get_basename()] = load("res://assets/audio/" + name)
			name = dir.get_next()
		dir.list_dir_end()


func play_sound(sound_name: String, at: Vector3, volume := 0.0) -> void:
	if _sounds.is_empty() or not W.settings.get("audio", true):
		return
	var stream: AudioStream = _sounds.get(sound_name)
	if stream == null:
		stream = _sounds.get("explode")
	if stream == null:
		return
	var player := AudioStreamPlayer3D.new()
	player.stream = stream
	player.unit_size = 60.0
	player.volume_db = volume + float(W.settings.get("volume_db", 0.0))
	add_child(player)
	player.global_position = at
	player.play()
	player.finished.connect(player.queue_free)


func burst(at: Vector3, color: Color, count := 40, spread := 8.0, lifetime := 1.2) -> void:
	var particles := CPUParticles3D.new()
	particles.one_shot = true
	particles.emitting = false
	particles.amount = count
	particles.lifetime = lifetime
	particles.explosiveness = 1.0
	particles.direction = Vector3.UP
	particles.spread = 180.0
	particles.initial_velocity_min = spread * 0.5
	particles.initial_velocity_max = spread
	particles.gravity = Vector3(0, -14.0, 0)
	particles.scale_amount_min = 0.6
	particles.scale_amount_max = 1.6
	var mesh := QuadMesh.new()
	mesh.size = Vector2(0.7, 0.7)
	var mat := StandardMaterial3D.new()
	mat.albedo_color = color
	mat.emission_enabled = true
	mat.emission = color
	mat.emission_energy_multiplier = 2.0
	mat.billboard_mode = BaseMaterial3D.BILLBOARD_PARTICLES
	mesh.material = mat
	particles.draw_pass_1 = mesh
	add_child(particles)
	particles.global_position = at
	particles.emitting = true
	get_tree().create_timer(lifetime + 0.5).timeout.connect(particles.queue_free)


func on_effect(kind_name: String, at: Vector3, param) -> void:
	match kind_name:
		"rain":
			burst(at + Vector3(0, -6, 0), Color(0.5, 0.7, 1.0, 0.5), 24, 3.0, 0.8)
		"fire":
			burst(at, Color(1.0, 0.45, 0.1), 30, 6.0, 1.0)
			play_sound("fire", at, -6.0)
		_:
			var color: Color = EXPLOSION_COLORS.get(kind_name, Color(1, 0.7, 0.3))
			var size: float = clampf(float(param) * 0.15, 6.0, 40.0)
			burst(at, color, int(size), size * 0.4, 1.4)
			play_sound("explode", at, -4.0)
