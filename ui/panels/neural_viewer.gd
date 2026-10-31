class_name AIPNeuralViewer
extends AIPPanel
## Revives the original (stub) fNeuralNet viewer: draws the live MLP of the
## selected creature - inputs, hidden layer, outputs and connection weights.

const LAYOUT := {
	"in": Vector2(40, 0), "hid": Vector2(200, 0), "out": Vector2(340, 0),
}

var hud: AIPHUD
var net_view: Control
var info: Label


func setup(p_hud: AIPHUD) -> void:
	hud = p_hud


func panel_title() -> String:
	return tr("NEURAL_VIEWER")


func _build() -> void:
	net_view = Control.new()
	net_view.custom_minimum_size = Vector2(400, 240)
	net_view.draw.connect(_draw_net)
	body.add_child(net_view)
	info = Label.new()
	info.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	body.add_child(info)


func _process(_delta: float) -> void:
	net_view.queue_redraw()


func _brain_of(thing):
	if thing == null:
		return null
	if thing is AIPCreature:
		return thing.brain
	return null


func _draw_net() -> void:
	var brain = _brain_of(hud.selected if hud != null else null)
	if brain == null:
		net_view.draw_string(ThemeDB.fallback_font, Vector2(12, 30),
				tr("INSPECTOR") + " → 🧠", HORIZONTAL_ALIGNMENT_LEFT, -1, 14,
				Color(0.8, 0.85, 0.95))
		info.text = tr("NEURONS") + ": —"
		return
	var size: Vector2 = net_view.size
	var n_in: int = brain.N_IN
	var n_hid: int = brain.N_HID
	var n_out: int = brain.N_OUT
	var pos := {}
	for i in n_in:
		pos["i%d" % i] = Vector2(50, 30 + i * (size.y - 50) / maxf(1, n_in - 1))
	for h in n_hid:
		pos["h%d" % h] = Vector2(210, 20 + h * (size.y - 30) / maxf(1, n_hid - 1))
	for o in n_out:
		pos["o%d" % o] = Vector2(360, size.y * 0.35 + o * 60)
	for h in n_hid:
		for i in n_in:
			var w: float = brain.w_ih[h][i]
			var color := Color(0.3, 0.9, 0.4).lerp(Color(0.95, 0.3, 0.3), clampf(0.5 - w, 0, 1))
			net_view.draw_line(pos["h%d" % h], pos["i%d" % i], color, clampf(absf(w), 0.4, 3.0))
	for o in n_out:
		for h in n_hid:
			var w: float = brain.w_ho[o][h]
			var color := Color(0.3, 0.9, 0.4).lerp(Color(0.95, 0.3, 0.3), clampf(0.5 - w, 0, 1))
			net_view.draw_line(pos["o%d" % o], pos["h%d" % h], color, clampf(absf(w), 0.4, 3.0))
	for key in pos:
		var is_out: bool = key.begins_with("o")
		var is_hid: bool = key.begins_with("h")
		var activation := 0.0
		var idx := int(key.substr(1))
		if is_out:
			activation = brain.outputs[idx]
		elif is_hid:
			activation = brain.hidden[idx]
		else:
			activation = brain.inputs[idx]
		var node_color := Color(0.2, 0.35, 0.55).lerp(Color(0.4, 1.0, 0.6), clampf(activation, 0, 1))
		net_view.draw_circle(pos[key], 9.0 if is_out else 7.0, node_color)
		net_view.draw_circle(pos[key], 9.0 if is_out else 7.0, Color(1, 1, 1, 0.35), false, 1.0)
	info.text = "%s: %d → %d → %d | %s: %+.2f" % [tr("NEURONS"), n_in, n_hid, n_out,
			tr("REWARD"), brain.reward_value]
