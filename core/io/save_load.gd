class_name AIPSaveLoad
## Native remaster save format: .aipr (gzip-compressed JSON), keeps the full
## simulation state including entities, DNA, brains and stats history.


static func save_world(world: AIPWorld, path: String) -> bool:
	var data := JSON.stringify(world.to_dict())
	var f := FileAccess.open_compressed(path, FileAccess.WRITE, FileAccess.COMPRESSION_GZIP)
	if f == null:
		return false
	f.store_string(data)
	f.close()
	return true


static func load_world(path: String, world: AIPWorld) -> bool:
	var f := FileAccess.open_compressed(path, FileAccess.READ, FileAccess.COMPRESSION_GZIP)
	if f == null:
		return false
	var text := f.get_as_text()
	f.close()
	var parsed = JSON.parse_string(text)
	if parsed == null or not parsed is Dictionary or not parsed.has("space"):
		return false
	world.from_dict(parsed)
	return true
