class_name AIPHUD
extends Control
## In-game HUD: top bar, godly tool palette, selection info, panels.

signal menu_requested

var current_tool := "select"
var selected = null
var time_label: Label
var tool_buttons := {}
var selection_label: Label
var panels := {}
var _menu_button: Button
var _play_button: Button


func _ready() -> void:
	theme = AIPUITheme.build()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	_build_top_bar()
	_build_tool_palette()
	_build_selection_bar()
	W.world.event_logged.connect(_on_event_logged)


func game() -> AIPGame:
	var parent := get_parent()
	return parent if parent is AIPGame else null


func _build_top_bar() -> void:
	var bar := PanelContainer.new()
	bar.set_anchors_and_offsets_preset(Control.PRESET_TOP_WIDE)
	bar.mouse_filter = Control.MOUSE_FILTER_STOP
	var box := HBoxContainer.new()
	box.add_theme_constant_override("separation", 6)
	bar.add_child(box)
	_menu_button = _btn("MENU", func(): menu_requested.emit())
	box.add_child(_menu_button)
	_play_button = _btn(tr("PLAY"), _toggle_play)
	box.add_child(_play_button)
	box.add_child(_btn(tr("STEP"), func(): W.step_one_tick()))
	var slower := _btn("«", func(): W.set_speed(W.speed_multiplier / 2.0))
	var faster := _btn("»", func(): W.set_speed(W.speed_multiplier * 2.0))
	box.add_child(slower)
	box.add_child(faster)
	time_label = Label.new()
	time_label.custom_minimum_size = Vector2(190, 0)
	box.add_child(time_label)
	for panel_name in [["populations", tr("POPULATIONS")], ["dna", tr("DNA_EDITOR")],
			["neural", tr("NEURAL_VIEWER")], ["inspector", tr("INSPECTOR")],
			["events", tr("EVENTS")], ["settings", tr("SETTINGS")], ["tutorial", tr("TUTORIAL")]]:
		var pname: String = panel_name[0]
		box.add_child(_btn(panel_name[1], func(): toggle_panel(pname)))
	add_child(bar)


func _btn(text: String, handler: Callable) -> Button:
	var b := Button.new()
	b.text = text
	b.pressed.connect(handler)
	return b


func _toggle_play() -> void:
	W.toggle_pause()
	_play_button.text = tr("PAUSE") if not W.paused else tr("PLAY")


func _build_tool_palette() -> void:
	var bar := PanelContainer.new()
	bar.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
	bar.mouse_filter = Control.MOUSE_FILTER_STOP
	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_SHOW_NEVER
	scroll.vertical_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	var flow := HFlowContainer.new()
	flow.add_theme_constant_override("h_separation", 4)
	flow.add_theme_constant_override("v_separation", 4)
	scroll.add_child(flow)
	bar.add_child(scroll)
	for tool in AIPGame.TOOL_IDS:
		var t: String = tool
		var b := Button.new()
		b.toggle_mode = true
		b.text = _tool_label(t)
		b.custom_minimum_size = Vector2(0, 44)
		b.toggled.connect(func(on): _select_tool(t, on, b))
		flow.add_child(b)
		tool_buttons[t] = b
	(tool_buttons["select"] as Button).button_pressed = true
	add_child(bar)


func _tool_label(t: String) -> String:
	return tr("TOOL_" + t.to_upper())


func _select_tool(t: String, on: bool, b: Button) -> void:
	if not on:
		if current_tool == t:
			b.set_pressed_no_signal(true)
		return
	current_tool = t
	for key in tool_buttons:
		var other: Button = tool_buttons[key]
		other.set_pressed_no_signal(other == b)


func _build_selection_bar() -> void:
	selection_label = Label.new()
	selection_label.set_anchors_and_offsets_preset(Control.PRESET_CENTER_TOP)
	selection_label.position = Vector2(40, 60)
	selection_label.add_theme_font_size_override("font_size", 16)
	selection_label.add_theme_color_override("font_color", Color(1, 0.95, 0.7))
	add_child(selection_label)


func set_selected(thing) -> void:
	selected = thing
	if thing == null:
		selection_label.text = ""
	else:
		selection_label.text = thing.full_display()


func refresh_tool_visibility() -> void:
	pass


func _on_event_logged(text: String, _thing) -> void:
	var log_panel = panels.get("events")
	if log_panel != null and is_instance_valid(log_panel):
		log_panel.append_event(text)


func _process(_delta: float) -> void:
	if W.world != null:
		time_label.text = "%s %s %dx %s %d" % [tr("TIME"), tr("PAUSED") if W.paused else "",
				int(round(W.speed_multiplier)), tr("TICKS"), W.world.time]
	if selected != null and not selected.exists:
		set_selected(null)


func toggle_panel(pname: String) -> void:
	var existing = panels.get(pname)
	if existing != null and is_instance_valid(existing):
		existing.queue_free()
		panels.erase(pname)
		return
	var panel: AIPPanel = _create_panel(pname)
	if panel == null:
		return
	panel.closed.connect(func(): panels.erase(pname))
	add_child(panel)
	panels[pname] = panel


func _create_panel(pname: String):
	match pname:
		"populations":
			var p := AIPPopulationsPanel.new()
			p.setup(W.world)
			return p
		"dna":
			var p := AIPDNAEditor.new()
			p.setup(self)
			return p
		"neural":
			var p := AIPNeuralViewer.new()
			p.setup(self)
			return p
		"inspector":
			var p := AIPInspectorPanel.new()
			p.setup(self)
			return p
		"events":
			var p := AIPEventsPanel.new()
			return p
		"settings":
			var p := AIPSettingsPanel.new()
			return p
		"tutorial":
			var p := AIPTutorialPanel.new()
			return p
	return null
