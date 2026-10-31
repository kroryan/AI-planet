class_name AIPTutorialPanel
extends AIPPanel
## Guided tutorial (remaster of fmTutorial + the manual's getting-started).

const STEPS_EN := [
	"Welcome to AI Planet! You are the guardian of a living world.",
	"Use PLAY to start time. Each tick, every creature, cloud and river updates.",
	"Pick the Water tool and click the terrain to pour water. Water flows downhill and forms rivers and lakes.",
	"Use Raise/Lower/Mountain to sculpt the land. Valleys collect water; peaks stay dry.",
	"Plant Grass and Trees. Trees drink humidity and drop fruit; grass spreads on humid soil.",
	"Add Rabbits: they eat grass and fruit, mature, and mate. Foxes will hunt them.",
	"Open the Populations panel to watch the ecosystem evolve over time.",
	"Select any creature with the Select tool to inspect it. Genetic species carry DNA that mutates with every birth - watch colors drift over generations.",
	"The Sun heats the world and drives rain; the Moon pulls the tides. Asteroids strike unless your Missile Defence stops them.",
	"This world is yours. Experiment, and see what life becomes.",
]

const STEPS_ES := [
	"¡Bienvenido a AI Planet! Eres el guardián de un mundo vivo.",
	"Pulsa Jugar para iniciar el tiempo. En cada tick, cada criatura, nube y río se actualiza.",
	"Elige la herramienta Agua y haz clic en el terreno para verter agua. El agua fluye cuesta abajo y forma ríos y lagos.",
	"Usa Subir/Bajar/Montaña para esculpir la tierra. Los valles acumulan agua; las cumbres se mantienen secas.",
	"Planta Hierba y Árboles. Los árboles beben humedad y dan fruta; la hierba se extiende en suelo húmedo.",
	"Añade Conejos: comen hierba y fruta, maduran y se aparean. Los zorros los cazarán.",
	"Abre el panel Poblaciones para ver evolucionar el ecosistema en tiempo real.",
	"Selecciona cualquier criatura con la herramienta Seleccionar para inspeccionarla. Las especies genéticas llevan ADN que muta en cada nacimiento: observa cómo derivan los colores con las generaciones.",
	"El Sol calienta el mundo e impulsa la lluvia; la Luna mueve las mareas. Los asteroides caen salvo que tu Defensa de misiles los detenga.",
	"Este mundo es tuyo. Experimenta y descubre en qué se convierte la vida.",
]

var step := 0
var label: RichTextLabel


func panel_title() -> String:
	return tr("TUTORIAL")


func _build() -> void:
	label = RichTextLabel.new()
	label.size_flags_vertical = Control.SIZE_EXPAND_FILL
	label.bbcode_enabled = true
	label.fit_content = false
	body.add_child(label)
	var row := HBoxContainer.new()
	var prev := Button.new()
	prev.text = "←"
	prev.pressed.connect(func(): _show(step - 1))
	row.add_child(prev)
	var next := Button.new()
	next.text = "→"
	next.pressed.connect(func(): _show(step + 1))
	row.add_child(next)
	var progress := Label.new()
	progress.name = "Progress"
	progress.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	progress.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	row.add_child(progress)
	body.add_child(row)
	_show(0)


func _show(index: int) -> void:
	var steps := STEPS_ES if TranslationServer.get_locale().begins_with("es") else STEPS_EN
	step = clampi(index, 0, steps.size() - 1)
	label.text = "[color=#ffd97a]%d/%d[/color]\n%s" % [step + 1, steps.size(), steps[step]]
	var progress := body.get_node_or_null("HBoxContainer/Progress") as Label
	if progress != null:
		progress.text = "%d / %d" % [step + 1, steps.size()]
