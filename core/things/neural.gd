class_name AIPNeuralBrain
## The remaster's real neural network (the original cAINeuralNet.pas was an
## empty stub). Tiny MLP 6-8-2 trained by reward-modulated Hebbian updates -
## deterministic, serializable and cheap enough for thousands of creatures.

const N_IN := 6
const N_HID := 8
const N_OUT := 2

var w_ih := []
var w_ho := []
var inputs: Array[float] = []
var hidden: Array[float] = []
var outputs: Array[float] = []
var reward_value := 0.0
var _last_hidden: Array[float] = []
var _last_inputs: Array[float] = []


func _init() -> void:
	for i in N_IN:
		inputs.append(0.0)
	for i in N_HID:
		hidden.append(0.0)
		_last_hidden.append(0.0)
		var row: Array[float] = []
		for j in N_IN:
			row.append(randf_range(-0.5, 0.5))
		w_ih.append(row)
	for i in N_OUT:
		outputs.append(0.0)
		var row: Array[float] = []
		for j in N_HID:
			row.append(randf_range(-0.5, 0.5))
		w_ho.append(row)


func set_input(i: int, v: float) -> void:
	if i >= 0 and i < N_IN:
		inputs[i] = v


func get_output(i: int) -> float:
	return outputs[i] if i >= 0 and i < N_OUT else 0.0


func forward() -> void:
	_last_inputs = inputs.duplicate()
	for h in N_HID:
		var sum := 0.0
		for i in N_IN:
			sum += w_ih[h][i] * inputs[i]
		hidden[h] = _sigmoid(sum)
	_last_hidden = hidden.duplicate()
	for o in N_OUT:
		var sum := 0.0
		for h in N_HID:
			sum += w_ho[o][h] * hidden[h]
		outputs[o] = _sigmoid(sum)


func reward_feedback() -> void:
	if reward_value == 0.0:
		return
	var lr := 0.05 * clampf(absf(reward_value), 0.0, 1.0) * signf(reward_value)
	for h in N_HID:
		for i in N_IN:
			w_ih[h][i] += lr * _last_hidden[h] * (1.0 - _last_hidden[h]) * _last_inputs[i] * 0.5
	for o in N_OUT:
		for h in N_HID:
			w_ho[o][h] += lr * outputs[o] * (1.0 - outputs[o]) * _last_hidden[h]
	reward_value = 0.0


func reward(amount: float) -> void:
	reward_value = clampf(reward_value + amount, -2.0, 2.0)
	reward_feedback()


func decay_reward(factor: float) -> void:
	reward_value *= factor


static func _sigmoid(v: float) -> float:
	return 1.0 / (1.0 + exp(-clampf(v, -20.0, 20.0)))


func to_dict() -> Dictionary:
	return {"w_ih": w_ih, "w_ho": w_ho}


func from_dict(d: Dictionary) -> void:
	if d.has("w_ih"):
		w_ih = d["w_ih"]
	if d.has("w_ho"):
		w_ho = d["w_ho"]
