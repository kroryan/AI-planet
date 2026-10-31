class_name AIPDNAEditor
extends AIPPanel
## Live DNA editor for genetic creatures and evolving plants
## (remaster of fmDNA). Edits apply to the selected entity instantly.

var hud: AIPHUD
var sliders := {}


func setup(p_hud: AIPHUD) -> void:
	hud = p_hud


func panel_title() -> String:
	return tr("DNA_EDITOR")


func _build() -> void:
	_rebuild()


func _process(_delta: float) -> void:
	if hud != null and hud.selected != null and sliders.is_empty():
		_rebuild()
	elif hud != null and hud.selected == null and not sliders.is_empty():
		_rebuild()


func _dna_of(thing):
	if thing is AIPGeneticCreature:
		return thing.dna
	if thing is AIPPlants.EvolvingTree or thing is AIPPlants.EvolvingFruit \
			or thing is AIPPlants.EvolvingSeed:
		return thing.dna
	return null


func _rebuild() -> void:
	for c in body.get_children():
		c.queue_free()
	sliders.clear()
	var thing = hud.selected if hud != null else null
	if thing == null:
		var hint := Label.new()
		hint.text = tr("INSPECTOR") + " → " + tr("SPECIES")
		hint.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(hint)
		return
	var dna = _dna_of(thing)
	if dna == null:
		var hint2 := Label.new()
		hint2.text = thing.display_name() + tr("NEURONS") + " ≠ DNA"
		hint2.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		body.add_child(hint2)
		return
	for entry in [["mutation", 0.0, 1.0], ["growth_rate", 0.0, 4.0],
			["size_max", 0.2, 4.0], ["mass_max", 0.5, 8.0], ["buoyancy", -0.5, 1.0],
			["bounce", 0.0, 1.0], ["red", 0.0, 1.0], ["green", 0.0, 1.0],
			["blue", 0.0, 1.0]]:
		var field: String = entry[0]
		var row := HBoxContainer.new()
		var label := Label.new()
		label.text = field
		label.custom_minimum_size = Vector2(110, 0)
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		row.add_child(label)
		var slider := HSlider.new()
		slider.min_value = entry[1]
		slider.max_value = entry[2]
		slider.step = 0.01
		slider.value = dna.get(field)
		slider.custom_minimum_size = Vector2(180, 20)
		slider.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		slider.value_changed.connect(func(v): _on_changed(dna, field, v))
		row.add_child(slider)
		var value := Label.new()
		value.text = "%.2f" % float(dna.get(field))
		value.custom_minimum_size = Vector2(46, 0)
		row.add_child(value)
		slider.value_changed.connect(func(v): value.text = "%.2f" % v)
		body.add_child(row)
		sliders[field] = slider
	var lifespan_row := HBoxContainer.new()
	var lifespan_label := Label.new()
	lifespan_label.text = "lifespan"
	lifespan_row.add_child(lifespan_label)
	var spin := SpinBox.new()
	spin.min_value = 100
	spin.max_value = 50000
	spin.step = 100
	spin.value = dna.lifespan
	spin.value_changed.connect(func(v): dna.lifespan = int(v))
	lifespan_row.add_child(spin)
	body.add_child(lifespan_row)


func _on_changed(dna, field: String, value: float) -> void:
	dna.set(field, value)
	if hud != null and hud.selected != null:
		hud.set_selected(hud.selected)
