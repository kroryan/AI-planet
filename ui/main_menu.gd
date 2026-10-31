class_name AIPMainMenu
extends Control
## Title screen: new world generator, classic .air worlds, saves, about.

var logo: TextureRect
var pages := {}
var current_page := "home"


func _ready() -> void:
	theme = AIPUITheme.build()
	set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	var bg := ColorRect.new()
	bg.color = Color(0.05, 0.07, 0.12, 0.97)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var center := CenterContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(center)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 14)
	column.custom_minimum_size = Vector2(560, 0)
	center.add_child(column)
	var title := Label.new()
	title.text = "AI PLANET REMASTER"
	title.add_theme_font_size_override("font_size", 42)
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_color_override("font_color", Color(0.65, 0.85, 1.0))
	column.add_child(title)
	logo = TextureRect.new()
	logo.texture = load("res://assets/logos/planet_big.png")
	logo.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	logo.stretch_mode = TextureRect.STRETCH_KEEP_CENTERED
	logo.custom_minimum_size = Vector2(0, 200)
	column.add_child(logo)
	var subtitle := Label.new()
	subtitle.text = tr("WELCOME")
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	column.add_child(subtitle)
	var content := VBoxContainer.new()
	content.name = "Content"
	content.add_theme_constant_override("separation", 10)
	content.size_flags_vertical = Control.SIZE_EXPAND_FILL
	column.add_child(content)
	var buttons := HBoxContainer.new()
	buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	buttons.add_theme_constant_override("separation", 8)
	for entry in [["home", tr("NEW_WORLD")], ["classic", tr("CLASSIC_WORLD")],
			["load", tr("LOAD_GAME")], ["about", tr("CREDITS")]]:
		var page: String = entry[0]
		var b := Button.new()
		b.text = entry[1]
		b.toggle_mode = true
		b.toggled.connect(func(on):
			if on:
				show_page(page, b))
		buttons.add_child(b)
		pages[page] = {"button": b}
	column.add_child(buttons)
	var quit := Button.new()
	quit.text = tr("QUIT")
	quit.pressed.connect(func(): get_tree().quit())
	column.add_child(quit)
	show_page("home", pages["home"]["button"])


func show_page(page: String, button: Button) -> void:
	current_page = page
	for key in pages:
		var b: Button = pages[key]["button"]
		b.set_pressed_no_signal(b == button)
	var content := find_child("Content", true, false) as VBoxContainer
	for c in content.get_children():
		c.queue_free()
	match page:
		"home":
			_build_home(content)
		"classic":
			_build_classic(content)
		"load":
			_build_load(content)
		"about":
			_build_about(content)


func _build_home(box: VBoxContainer) -> void:
	var preset_row := _row(box, tr("PRESET"))
	var presets := OptionButton.new()
	for p in ["grass", "continents", "islands", "watery", "barren", "halo", "random"]:
		presets.add_item(tr(p.to_upper()))
	presets.selected = 0
	preset_row.add_child(presets)
	var size_row := _row(box, tr("WORLD_SIZE"))
	var width := SpinBox.new()
	width.min_value = 12
	width.max_value = 120
	width.value = 40
	var height := SpinBox.new()
	height.min_value = 8
	height.max_value = 80
	height.value = 24
	size_row.add_child(width)
	size_row.add_child(height)
	var water_row := _row(box, tr("WATER_LEVEL"))
	var water := SpinBox.new()
	water.min_value = 0.0
	water.max_value = 20.0
	water.step = 0.5
	water.value = 3.0
	water_row.add_child(water)
	var hills_row := _row(box, tr("HILL_HEIGHT"))
	var hills := SpinBox.new()
	hills.min_value = 1.0
	hills.max_value = 30.0
	hills.step = 0.5
	hills.value = 6.0
	hills_row.add_child(hills)
	var life_row := _row(box, tr("SEED_LIFE"))
	var life := CheckButton.new()
	life.button_pressed = true
	life_row.add_child(life)
	var create := Button.new()
	create.text = tr("CREATE") + " ▶"
	create.custom_minimum_size = Vector2(0, 52)
	var preset_keys := ["grass", "continents", "islands", "watery", "barren", "halo", "random"]
	create.pressed.connect(func():
		W.new_world(preset_keys[presets.selected], int(width.value), int(height.value),
				water.value, hills.value, life.button_pressed)
		hide())
	box.add_child(create)


func _build_classic(box: VBoxContainer) -> void:
	var note := Label.new()
	note.text = tr("IMPORTED") + " (.air 920/960):"
	box.add_child(note)
	if W.classic_worlds.is_empty():
		var empty := Label.new()
		empty.text = "—"
		box.add_child(empty)
	var scroll := ScrollContainer.new()
	scroll.custom_minimum_size = Vector2(540, 260)
	var list := VBoxContainer.new()
	list.name = "List"
	scroll.add_child(list)
	box.add_child(scroll)
	for world_name in W.classic_worlds:
		var name: String = world_name
		var b := Button.new()
		b.text = name.get_basename().replace("-", " ").replace("_", " ")
		b.alignment = HORIZONTAL_ALIGNMENT_LEFT
		b.pressed.connect(func():
			W.load_classic("res://worlds/classic/" + name)
			hide())
		list.add_child(b)


func _build_load(box: VBoxContainer) -> void:
	var path_edit := LineEdit.new()
	path_edit.text = OS.get_user_data_dir() + "/save.aipr"
	path_edit.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	box.add_child(path_edit)
	var row := HBoxContainer.new()
	var browse := Button.new()
	browse.text = "..."
	browse.pressed.connect(func():
		var dialog := FileDialog.new()
		dialog.access = FileDialog.ACCESS_FILESYSTEM
		dialog.file_mode = FileDialog.FILE_MODE_OPEN_FILE
		dialog.current_path = OS.get_user_data_dir() + "/"
		add_child(dialog)
		dialog.popup_centered(Vector2i(700, 480))
		dialog.file_selected.connect(func(p):
			path_edit.text = p
			dialog.queue_free()))
	row.add_child(browse)
	var load_btn := Button.new()
	load_btn.text = tr("LOAD_GAME")
	load_btn.pressed.connect(func():
		if W.load_game(path_edit.text):
			hide())
	row.add_child(load_btn)
	box.add_child(row)


func _build_about(box: VBoxContainer) -> void:
	var text := RichTextLabel.new()
	text.bbcode_enabled = true
	text.fit_content = false
	text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	var about: String = tr("ABOUT_TEXT")
	text.text = "[center]" + about + "[/center]\n\n[center]ai.planet (2003-2005) - Dave Kerr & contributors[/center]\n[center]Remaster: kroryan - Godot 4.7[/center]\n[center][color=#7fb8ff]https://github.com/kroryan/AI-planet[/color][/center]"
	box.add_child(text)


func _row(box: VBoxContainer, label_text: String) -> HBoxContainer:
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 10)
	var label := Label.new()
	label.text = label_text
	label.custom_minimum_size = Vector2(140, 0)
	row.add_child(label)
	box.add_child(row)
	return row
