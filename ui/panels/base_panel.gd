class_name AIPPanel
extends PanelContainer
## Draggable floating panel base with close button.

signal closed

var title_bar: HBoxContainer
var body: VBoxContainer


func _ready() -> void:
	custom_minimum_size = Vector2(420, 320)
	set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	var root := VBoxContainer.new()
	add_child(root)
	title_bar = HBoxContainer.new()
	var title := Label.new()
	title.text = panel_title()
	title.add_theme_font_size_override("font_size", 17)
	title.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	title_bar.add_child(title)
	var close := Button.new()
	close.text = "×"
	close.pressed.connect(func():
		closed.emit()
		queue_free())
	title_bar.add_child(close)
	root.add_child(title_bar)
	var sep := HSeparator.new()
	root.add_child(sep)
	body = VBoxContainer.new()
	body.size_flags_vertical = Control.SIZE_EXPAND_FILL
	root.add_child(body)
	_build()


func panel_title() -> String:
	return "Panel"


func _build() -> void:
	pass
