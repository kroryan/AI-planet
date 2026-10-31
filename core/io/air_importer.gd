class_name AIPAirImporter
## Imports classic ai.planet .air worlds (GPL-2.0 originals from 2003-2005).
## The terrain grid (water, height, temperature, humidity) and population
## maximums are imported faithfully for format versions 920/960. Entities are
## NOT migrated: those files predate the stable save format and their entity
## layout changed across the ten historical format versions; the remaster
## re-seeds ecosystems on top of the imported terrain.


class Cursor:
	var lines: PackedStringArray = PackedStringArray()
	var i := 0

	func next() -> String:
		var v := ""
		if i < lines.size():
			v = lines[i].strip_edges()
		i += 1
		return v

	func f() -> float:
		return next().to_float()

	func b() -> bool:
		return next() == "0"  # writeFileBoolean: true='0', false='1'


static func can_import(path: String) -> bool:
	var f := FileAccess.open(path, FileAccess.READ)
	if f == null:
		return false
	var first := f.get_line().strip_edges()
	f.close()
	return first == "920" or first == "960"


static func import_world(path: String, world: AIPWorld) -> Dictionary:
	var fa := FileAccess.open(path, FileAccess.READ)
	if fa == null:
		return {"ok": false, "error": TranslationServer.translate("Cannot open file")}
	var c := Cursor.new()
	while not fa.eof_reached():
		c.lines.append(fa.get_line())
	fa.close()
	var ver := int(c.next())
	if ver != 920 and ver != 960:
		return {"ok": false, "error": TranslationServer.translate("Legacy format version %d is not supported") % ver}
	var space_base := 1 if ver == 920 else 2
	c.next(); c.next()          # reality base
	var unique := int(c.next())
	world.unique_handle = maxi(world.unique_handle, unique)
	world.creator = c.next()
	var time_stream := int(c.next())
	world.time = int(c.next())
	c.next()                   # time since execute
	c.next()                   # clock stagger
	var running: bool = c.b()  # is running
	running = running  # kept for clarity; the sim always resumes paused
	c.next(); c.next()          # environment base
	var env_name: String = c.next()
	world.creator = env_name if env_name != "" else world.creator
	c.b()                       # shadows
	for j in space_base:
		c.next()                # space base
	var w := int(c.next())
	var h := int(c.next())
	var radius: float = c.f()
	var def_h: float = c.f()
	var def_w: float = c.f()
	var def_t: float = c.f()
	var def_hum: float = c.f()
	if w < 4 or h < 4 or w > 200 or h > 200:
		return {"ok": false, "error": TranslationServer.translate("Invalid world dimensions")}
	world.space.build(world, w, h)
	world.space.radius = radius
	world.space.default_height = def_h
	world.space.default_water = def_w
	world.space.default_temperature = def_t
	world.space.default_humidity = def_hum
	for x in w:
		for y in h:
			var cell: AIPCell = world.space.map[x][y]
			c.next(); c.next()      # cell base handle/parent
			c.next(); c.next()      # coordinates x/y
			cell.water = c.f()
			cell.temperature = c.f()
			cell.humidity = c.f()
			cell.height = c.f()
			cell.normal = Vector3(c.f(), c.f(), c.f()).normalized()
			cell.underwater = c.b()
	for list_no in 2:            # event queues: rebuilt at runtime
		c.next(); c.next()
		var active := int(c.next())
		c.next(); c.next()
		for j in active * 3:
			c.next()
	if ver == 960:
		c.b(); c.b()               # collisions/ai flags
	var imported_max := {}
	for j in 64:
		imported_max[j] = int(c.next())
		if AIP.SPECIES.has(j):
			world.maximums[j] = maxi(1, int(imported_max[j]))
	var terrain_cells := w * h
	return {"ok": true, "width": w, "height": h, "terrain_cells": terrain_cells,
			"time": world.time, "creator": world.creator,
			"note": TranslationServer.translate("Classic terrain imported. Entities from 2003-2005 saves are re-seeded by the remaster.")}
