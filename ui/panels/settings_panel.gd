class_name AIPSettingsPanel
extends AIPPanel
## Settings: language, audio, shadows (remaster of fmSettings).

var _audio_toggle: CheckButton
var _shadow_toggle: CheckButton
var _volume: HSlider


func panel_title() -> String:
	return tr("SETTINGS")


func _build() -> void:
	var lang_row := HBoxContainer.new()
	lang_row.add_child(_label(tr("LANG_LANGUAGE")))
	var options := OptionButton.new()
	options.add_item("English")
	options.add_item("Español")
	options.selected = 0 if W.settings.get("language", "en") == "en" else 1
	options.item_selected.connect(func(index):
		var locale := "en" if index == 0 else "es"
		W.settings["language"] = locale
		W._save_settings()
		TranslationServer.set_locale(locale))
	lang_row.add_child(options)
	body.add_child(lang_row)
	var audio_row := HBoxContainer.new()
	audio_row.add_child(_label(tr("AUDIO")))
	_audio_toggle = CheckButton.new()
	_audio_toggle.button_pressed = W.settings.get("audio", true)
	_audio_toggle.toggled.connect(func(on):
		W.settings["audio"] = on
		W._save_settings())
	audio_row.add_child(_audio_toggle)
	body.add_child(audio_row)
	var vol_row := HBoxContainer.new()
	vol_row.add_child(_label(tr("VOLUME")))
	_volume = HSlider.new()
	_volume.min_value = -30.0
	_volume.max_value = 6.0
	_volume.value = W.settings.get("volume_db", 0.0)
	_volume.custom_minimum_size = Vector2(200, 20)
	_volume.value_changed.connect(func(v):
		W.settings["volume_db"] = v
		W._save_settings())
	vol_row.add_child(_volume)
	body.add_child(vol_row)
	var shadow_row := HBoxContainer.new()
	shadow_row.add_child(_label(tr("SHADOWS")))
	_shadow_toggle = CheckButton.new()
	_shadow_toggle.button_pressed = W.settings.get("shadows", true)
	_shadow_toggle.toggled.connect(func(on):
		W.settings["shadows"] = on
		W._save_settings()
		get_tree().call_group("aip_lights", "set", "shadow_enabled", on))
	shadow_row.add_child(_shadow_toggle)
	body.add_child(shadow_row)


func _label(text: String) -> Label:
	var l := Label.new()
	l.text = text
	l.custom_minimum_size = Vector2(110, 0)
	return l
