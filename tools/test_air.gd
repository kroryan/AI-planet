extends SceneTree
func _init() -> void:
	var w := AIPWorld.new()
	var dir := DirAccess.open("res://worlds/classic")
	dir.list_dir_begin()
	var name := dir.get_next()
	var ok := 0
	while name != "":
		if name.ends_with(".air") and AIPAirImporter.can_import("res://worlds/classic/" + name):
			var info := AIPAirImporter.import_world("res://worlds/classic/" + name, w)
			if info.get("ok", false):
				ok += 1
			else:
				print("FAIL ", name, ": ", info.get("error"))
		name = dir.get_next()
	print("IMPORTED ", ok)
	quit(0)
