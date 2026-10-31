class_name AIPEventsPanel
extends AIPPanel
## World event log (remaster of fmEvents).

var log_text: RichTextLabel
var _buffer: PackedStringArray = []


func panel_title() -> String:
	return tr("EVENTS")


func _build() -> void:
	log_text = RichTextLabel.new()
	log_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	log_text.scroll_following = true
	body.add_child(log_text)
	var clear := Button.new()
	clear.text = "Clear"
	clear.pressed.connect(func():
		_buffer.clear()
		log_text.clear())
	body.add_child(clear)


func append_event(text: String) -> void:
	_buffer.append("[color=#a0d8ff]%d[/color] %s" % [W.world.time if W.world != null else 0, text])
	if _buffer.size() > 200:
		_buffer = _buffer.slice(_buffer.size() - 200)
	if log_text != null:
		log_text.append_text(_buffer[_buffer.size() - 1] + "\n")
