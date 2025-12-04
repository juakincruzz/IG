extends MeshInstance3D

@export var columna := 0  # 0, 1 o 2 (columna X)
@export var fila := 0      # 0, 1 o 2 (fila Y)

var mostrar_color := true
var mat_variante: StandardMaterial3D  # la guardamos para poder cambiarla luego


var ver_normales: bool = false
var mesh_normales: MeshInstance3D = null

var mat1: StandardMaterial3D
var mat2: StandardMaterial3D
var mat3: StandardMaterial3D

var base_mat: StandardMaterial3D
var textura_base: Texture2D

func _ready():
	# --- Generar el donut como antes ---
	var vertices := PackedVector3Array([])
	var triangulos := PackedInt32Array([])
	Utilidades.generarDonut(vertices, triangulos)
	var normales := Utilidades.calcNormales(vertices, triangulos)

	var tablas: Array = []
	tablas.resize(Mesh.ARRAY_MAX)
	tablas[Mesh.ARRAY_VERTEX] = vertices
	tablas[Mesh.ARRAY_INDEX]  = triangulos
	tablas[Mesh.ARRAY_NORMAL] = normales
	
	var uvs := Utilidades.calcUV(vertices)
	tablas[Mesh.ARRAY_TEX_UV] = uvs

	mesh = ArrayMesh.new()
	mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, tablas)

	# --- Cargar materiales base ---
	mat1 = preload("res://material_1.tres")
	mat2 = preload("res://material_2.tres")
	mat3 = preload("res://material_3.tres")

	# --- Elegir material base según columna ---
	var base_mat: StandardMaterial3D
	match columna:
		0:
			base_mat = mat1      # rojo
			textura_base = preload("res://texturas/ladrillos.jpg")
		1:
			base_mat = mat2      # amarillo
			textura_base = preload("res://texturas/madera.jpg")
		2:
			base_mat = mat3      # azul
			textura_base = preload("res://texturas/piedra.jpg")
		_:
			#base_mat = mat1
			textura_base = preload("res://texturas/madera.jpg")

	# --- Duplicamos y variamos por FILA (todo opaco) ---
	var mat_variante := base_mat.duplicate() as StandardMaterial3D

	match fila:
		0:  # MATE (difuso)
			mat_variante.metallic = 0.0
			mat_variante.roughness = 1.0
			mat_variante.specular = 0.0  # poca reflexión especular
			mat_variante.clearcoat = 0.0

		1:  # METÁLICO (pulido)
			mat_variante.metallic = 1.0
			mat_variante.roughness = 0.2
			mat_variante.specular = 0.5
			mat_variante.clearcoat = 0.0

		2:  # BRILLANTE (plástico/cerámica)
			mat_variante.metallic = 0.0
			mat_variante.roughness = 0.3
			mat_variante.specular = 1.0
			mat_variante.clearcoat = 0.6
			mat_variante.clearcoat_roughness = 0.2

	# Todo opaco y con sombras
	mat_variante.transparency = BaseMaterial3D.TRANSPARENCY_DISABLED
	mat_variante.cull_mode = BaseMaterial3D.CULL_BACK
	
	mat_variante.albedo_texture = textura_base

	
	# Asignar material a la malla
	set_surface_override_material(0, mat_variante)
	
	self.mat_variante = mat_variante

	# Asegura que esta malla proyecta sombras
	cast_shadow = GeometryInstance3D.SHADOW_CASTING_SETTING_ON


func _unhandled_key_input(key_event: InputEvent):
	if mesh_normales == null:
		return

	if key_event.keycode == KEY_N and not key_event.pressed:
		ver_normales = not ver_normales
		if ver_normales:
			print("Normales del Donut: activado")
		else:
			print("Normales del Donut: desactivado")
		mesh_normales.visible = ver_normales

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_T:
			mostrar_color = !mostrar_color
			if mostrar_color:
				print("Color base activado")
				# Restaurar el color original del material base (mat1, mat2, mat3)
				match columna:
					0: mat_variante.albedo_color = mat1.albedo_color
					1: mat_variante.albedo_color = mat2.albedo_color
					2: mat_variante.albedo_color = mat3.albedo_color
			else:
				print("Color base desactivado → solo textura visible")
				mat_variante.albedo_color = Color(1,1,1,1)
