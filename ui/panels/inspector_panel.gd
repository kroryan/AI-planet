class_name AIPInspectorPanel
extends AIPPanel
## Entity inspector (remaster of fmSpirit): live stats plus godly actions.

var hud: AIPHUD
var info: RichTextLabel
var follow_button: Button


func setup(p_hud: AIPHUD) -> void:
	hud = p_hud


func panel_title() -> String:
	return tr("INSPECTOR")


func _build() -> void:
	info = RichTextLabel.new()
	info.size_flags_vertical = Control.SIZE_EXPAND_FILL
	info.scroll_following = true
	body.add_child(info)
	var row := HBoxContainer.new()
	var heal := Button.new()
	heal.text = tr("HEAL")
	heal.pressed.connect(func():
		if hud != null and hud.selected != null:
			hud.selected.health = AIP.MAX_HEALTH
			hud.set_selected(hud.selected))
	row.add_child(heal)
	var kill := Button.new()
	kill.text = tr("KILL")
	kill.pressed.connect(func():
		if hud != null and hud.selected != null:
			hud.selected.cease())
	row.add_child(kill)
	follow_button = Button.new()
	follow_button.text = tr("FOLLOW")
	follow_button.pressed.connect(_follow)
	row.add_child(follow_button)
	body.add_child(row)


func _follow() -> void:
	if hud == null or hud.selected == null:
		return
	var game := hud.game()
	if game != null:
		var view = game.views.get(hud.selected.handle)
		if view != null:
			game.camera.follow(view)


func _process(_delta: float) -> void:
	if hud != null:
		if hud.selected == null:
			info.text = "—"
		elif Engine.get_process_frames() % 15 == 0:
			info.text = "[color=#9fd0ff]" + hud.selected.full_display().replace("\n", "\n") + "[/color]"
