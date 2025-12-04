extends MeshInstance3D

@export var columna := 0   # 0, 1, 2 → define color y textura
@export var fila := 0      # 0, 1, 2 → define posición

var ver_normales: bool = false
var mostrar_textura := false   # empieza solo con color (sin textura)
var mesh_normales: MeshInstance3D = null
var mat_variante: StandardMaterial3D  # material del peón
var textura: Texture2D
var base_color: Color


func _ready():
	# --- 1. Perfil del peón ---
	var perfil_peon = PackedVector2Array([
		Vector2(0.01, 0.0),
		Vector2(0.8, 0.0),
		Vector2(0.8, 0.2),
		Vector2(0.5, 0.4),
		Vector2(0.6, 1.0),
		Vector2(0.5, 1.2),
		Vector2(0.7, 1.3),
		Vector2(0.01, 1.4),
		Vector2(0.4, 1.6),
		Vector2(0.55, 1.8),
		Vector2(0.55, 2.1),
		Vector2(0.4, 2.3),
		Vector2(0.01, 2.4)
	])

	# --- 2. Generar revolución ---
	var vertices = PackedVector3Array()
	var triangulos = PackedInt32Array()
	AlgoritmoRevolucion.generar_malla_por_revolucion(perfil_peon, 32, vertices, triangulos)

	# --- 3. Calcular normales y UVs ---
	var normales = Utilidades.calcNormales(vertices, triangulos)
	var uvs = Utilidades.calcUV(vertices)

	# --- 4. Crear malla ---
	var tablas = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX] = triangulos
	tablas[Mesh.ARRAY_NORMAL] = normales
	tablas[Mesh.ARRAY_TEX_UV] = uvs

	var array_mesh = ArrayMesh.new()
	array_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)
	self.mesh = array_mesh

	# --- 5. Color y textura por columna ---
	match columna:
		0:
			base_color = Color(0.9, 0.4, 0.4)
			textura = preload("res://texturas/mapa_normales_ladrillos.jpg")
		1:
			base_color = Color(0.8, 0.7, 0.4)
			textura = preload("res://texturas/mapa_normales_madera.jpg")
		2:
			base_color = Color(0.6, 0.6, 0.6)
			textura = preload("res://texturas/mapa_normales_piedra.jpg")
		_:
			base_color = Color(1, 1, 1)
			textura = preload("res://texturas/mapa_normales_madera.jpg")

	# --- 6. Crear material (inicialmente sin textura) ---
	mat_variante = StandardMaterial3D.new()
	mat_variante.albedo_color = base_color
	mat_variante.metallic = 0.2
	mat_variante.roughness = 0.4
	mat_variante.specular = 0.6
	mat_variante.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	mat_variante.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	mat_variante.cull_mode = BaseMaterial3D.CULL_BACK

	self.material_override = mat_variante


	# --- 8. Normales opcionales ---
	mesh_normales = AlgoritmosVarios.generarSegmentosNormales(vertices, normales, 0.15, Color(1.0, 1.0, 1.0))
	mesh_normales.visible = ver_normales
	add_child(mesh_normales)


# ----------------------------
# INPUT HANDLERS
# ----------------------------
func _unhandled_key_input(event: InputEvent):
	if event is InputEventKey and not event.pressed:
		if event.keycode == KEY_N:
			ver_normales = !ver_normales
			mesh_normales.visible = ver_normales
			print("Normales:", ver_normales)
		elif event.keycode == KEY_T:
			_toggle_textura()


# ----------------------------
# FUNCIONES AUXILIARES
# ----------------------------
func _toggle_textura():
	mostrar_textura = !mostrar_textura
	if mostrar_textura:
		print("Mostrando textura, ocultando color base")
		mat_variante.albedo_texture = textura
		mat_variante.albedo_color = Color(1, 1, 1, 1)
	else:
		print("Mostrando solo color base (sin textura)")
		mat_variante.albedo_texture = null
		mat_variante.albedo_color = base_color


# =============================================================
# Función auxiliar para visualizar normales
# Crea un MeshInstance3D con segmentos (líneas blancas)
# que muestran la dirección de las normales en la superficie
# =============================================================
static func generarSegmentosNormales(vertices: PackedVector3Array, normales: PackedVector3Array, longitud: float, color: Color) -> MeshInstance3D:
	var lineas := MeshInstance3D.new()
	var mesh := ImmediateMesh.new()

	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_set_color(color)

	for i in range(vertices.size()):
		var v = vertices[i]
		var n = normales[i].normalized() * longitud
		mesh.surface_add_vertex(v)
		mesh.surface_add_vertex(v + n)

	mesh.surface_end()
	lineas.mesh = mesh
	return lineas
