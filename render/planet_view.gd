class_name AIPPlanetView
extends Node3D
## Builds and maintains the planet meshes from the simulation grid.
## Terrain is colored by land state; water is a separate wave-shaded surface.
## Only rebuilds when cells changed, at most every 100 ms.

const LAND_COLORS := {
	AIP.LandState.DESERT: Color(0.82, 0.71, 0.44),
	AIP.LandState.DIRT: Color(0.55, 0.43, 0.30),
	AIP.LandState.FIELD: Color(0.55, 0.62, 0.33),
	AIP.LandState.GRASS: Color(0.33, 0.60, 0.25),
	AIP.LandState.POND: Color(0.25, 0.45, 0.35),
	AIP.LandState.LAKE: Color(0.22, 0.42, 0.55),
	AIP.LandState.SEA: Color(0.15, 0.34, 0.60),
	AIP.LandState.OCEAN: Color(0.08, 0.24, 0.52),
	AIP.LandState.SNOW: Color(0.93, 0.95, 0.98),
	AIP.LandState.ROCK: Color(0.48, 0.46, 0.44),
}

const WATER_SHADER := """
shader_type spatial;
render_mode blend_mix, depth_draw_always, cull_back;
uniform vec3 albedo : source_color = vec3(0.15, 0.38, 0.65);
uniform float transparency : hint_range(0.0, 1.0) = 0.55;
uniform float wave_strength = 0.25;
uniform float wave_scale = 0.35;
void vertex() {
	VERTEX.y += sin(VERTEX.x * wave_scale + TIME * 1.4) * wave_strength
			+ cos(VERTEX.z * wave_scale * 1.3 + TIME * 1.1) * wave_strength * 0.6;
}
void fragment() {
	METALLIC = 0.1;
	ROUGHNESS = 0.08;
	ALBEDO = albedo;
	ALPHA = mix(0.92, transparency, 0.5 + 0.5 * sin(TIME * 0.6));
}
"""

var world = null
var terrain_mesh: MeshInstance3D
var water_mesh: MeshInstance3D
var _dirty := true
var _timer := 0.0
var _height_scale := 0.6


func build(p_world) -> void:
	world = p_world
	terrain_mesh = MeshInstance3D.new()
	terrain_mesh.name = "Terrain"
	add_child(terrain_mesh)
	water_mesh = MeshInstance3D.new()
	water_mesh.name = "Water"
	var mat := ShaderMaterial.new()
	var shader := Shader.new()
	shader.code = WATER_SHADER
	mat.shader = shader
	water_mesh.material_override = mat
	add_child(water_mesh)
	rebuild()


func mark_dirty() -> void:
	_dirty = true


func _process(delta: float) -> void:
	_timer += delta
	if _timer < 0.1:
		return
	_timer = 0.0
	if not _dirty:
		var space0 = world.space
		for x in space0.width:
			var any_dirty := false
			for y in space0.height:
				if space0.map[x][y].dirty:
					any_dirty = true
					break
			if any_dirty:
				_dirty = true
				break
	if not _dirty:
		return
	_dirty = false
	rebuild()


func _vertex_height(x: int, y: int) -> float:
	var space = world.space
	var cx := clampi(x, 0, space.width - 1)
	var cy := clampi(y, 0, space.height - 1)
	return space.map[cx][cy].height * _height_scale


func rebuild() -> void:
	var space = world.space
	var w: int = space.width
	var h: int = space.height
	var st := SurfaceTool.new()
	st.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in w:
		for y in h:
			var cell = space.map[x][y]
			cell.dirty = false
			var color: Color = LAND_COLORS.get(cell.land_state, Color.WHITE)
			color = color.darkened(clampf(cell.temperature * 0.008, 0.0, 0.08))
			var x0: float = x * AIP.CELL_SIZE
			var z0: float = y * AIP.CELL_SIZE
			var h00 := _vertex_height(x, y)
			var h10 := _vertex_height(x + 1, y)
			var h11 := _vertex_height(x + 1, y + 1)
			var h01 := _vertex_height(x, y + 1)
			var p00 := Vector3(x0, h00, z0)
			var p10 := Vector3(x0 + AIP.CELL_SIZE, h10, z0)
			var p11 := Vector3(x0 + AIP.CELL_SIZE, h11, z0 + AIP.CELL_SIZE)
			var p01 := Vector3(x0, h01, z0 + AIP.CELL_SIZE)
			_quad(st, p00, p10, p11, p01, color)
	st.generate_normals()
	terrain_mesh.mesh = st.commit()
	var wst := SurfaceTool.new()
	wst.begin(Mesh.PRIMITIVE_TRIANGLES)
	for x in w:
		for y in h:
			var cell = space.map[x][y]
			if not cell.underwater:
				continue
			var x0: float = x * AIP.CELL_SIZE
			var z0: float = y * AIP.CELL_SIZE
			var wh: float = cell.water * 0.05 * _height_scale + cell.height * _height_scale + 0.25
			var p00 := Vector3(x0, wh, z0)
			var p10 := Vector3(x0 + AIP.CELL_SIZE, wh, z0)
			var p11 := Vector3(x0 + AIP.CELL_SIZE, wh, z0 + AIP.CELL_SIZE)
			var p01 := Vector3(x0, wh, z0 + AIP.CELL_SIZE)
			_quad(wst, p00, p10, p11, p01, Color.WHITE)
	wst.generate_normals()
	water_mesh.mesh = wst.commit()


func _quad(st: SurfaceTool, p00: Vector3, p10: Vector3, p11: Vector3,
		p01: Vector3, color: Color) -> void:
	st.set_color(color)
	st.add_vertex(p00)
	st.add_vertex(p10)
	st.add_vertex(p11)
	st.add_vertex(p00)
	st.add_vertex(p11)
	st.add_vertex(p01)


func pick_cell(from: Vector3, dir: Vector3):
	var space = world.space
	var p: Vector3 = from
	var step: Vector3 = dir.normalized() * 8.0
	var max_h: float = 40.0 * _height_scale + 12.0
	for i in 500:
		p += step
		if p.y < -10.0 or absf(p.x) > space.width * AIP.CELL_SIZE + 200.0 \
				or absf(p.z) > space.height * AIP.CELL_SIZE + 200.0:
			return null
		if p.y <= max_h:
			var cell = space.cell_at_world(Vector2(p.x, p.z))
			if cell != null:
				var terrain: float = cell.height * _height_scale
				if cell.underwater:
					terrain = minf(terrain, cell.water * 0.05 * _height_scale + cell.height * _height_scale)
				if p.y <= terrain + 2.0:
					return cell
	return null
