class_name AIPPopulationsPanel
extends AIPPanel
## Live population chart (remaster of fmPopulations with TeeChart).

var world
var chart: Control
var series_checkboxes := {}
var enabled_kinds := {}


func setup(p_world) -> void:
	world = p_world


func panel_title() -> String:
	return tr("POPULATIONS")


func _build() -> void:
	chart = Control.new()
	chart.custom_minimum_size = Vector2(400, 220)
	chart.draw.connect(_draw_chart)
	body.add_child(chart)
	var clear := Button.new()
	clear.text = "Reset"
	clear.pressed.connect(func():
		world.stats_history.clear()
		chart.queue_redraw())
	body.add_child(clear)
	var refresh := Button.new()
	refresh.text = "Refresh"
	refresh.pressed.connect(chart.queue_redraw)
	body.add_child(refresh)


func _process(_delta: float) -> void:
	chart.queue_redraw()


func _draw_chart() -> void:
	if world == null or world.stats_history.is_empty():
		return
	var size: Vector2 = chart.size
	var history: Array = world.stats_history
	var top_kinds := {}
	for snap in history:
		for k in snap["counts"]:
			top_kinds[k] = maxf(top_kinds.get(k, 0), snap["counts"][k])
	var ranked: Array = top_kinds.keys()
	ranked.sort_custom(func(a, b): return top_kinds[a] > top_kinds[b])
	ranked = ranked.slice(0, 6)
	var max_count: float = 1.0
	for k in ranked:
		max_count = maxf(max_count, top_kinds[k])
	var palette := [Color(0.4, 0.8, 1), Color(1, 0.6, 0.3), Color(0.5, 1, 0.5),
		Color(1, 0.5, 0.8), Color(1, 0.9, 0.3), Color(0.7, 0.6, 1)]
	var legend_y := 4.0
	for idx in ranked.size():
		var k: int = ranked[idx]
		var color: Color = palette[idx % palette.size()]
		var prev := Vector2(0, size.y)
		var first := true
		var x_scale: float = size.x / maxf(1.0, float(history.size() - 1))
		for i in history.size():
			var snap: Dictionary = history[i]
			var count: float = snap["counts"].get(k, 0)
			var point := Vector2(i * x_scale,
					size.y - (count / max_count) * (size.y - 16.0) - 4.0)
			if not first:
				chart.draw_line(prev, point, color, 2.0)
			prev = point
			first = false
		chart.draw_string(ThemeDB.fallback_font, Vector2(8, legend_y + 12),
				"%s: %d" % [AIP.SPECIES[k]["name"], world.population(k)],
				HORIZONTAL_ALIGNMENT_LEFT, -1, 12, color)
		legend_y += 15.0
