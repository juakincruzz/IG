extends MeshInstance3D

var ver_normales : bool = false ## Tecla 'N' para alternar
var mesh_normales : MeshInstance3D = null

func _ready() -> void:
	# Cubo centrado en el (0, 0 ,0)
	var vertices := PackedVector3Array([
		# Cara trasera
		Vector3(0, 1, -1), # 0
		Vector3(1, 1, -1), # 1
		Vector3(0, 0, -1), # 2
		Vector3(1, 0, -1), # 3
		
		# Cara delantera
		Vector3(0, 1, 0), # 4
		Vector3(1, 1, 0), # 5
		Vector3(0, 0, 0), # 6
		Vector3(1, 0, 0), # 7
		
		# Cara superior
		Vector3(0, 1, -1), # 8
		Vector3(1, 1, -1), # 9
		Vector3(0, 1, 0), # 10
		Vector3(1, 1, 0), # 11
		
		# Cara inferior
		Vector3(0, 0, -1), # 12
		Vector3(1, 0, -1), # 13
		Vector3(0, 0, 0), # 14
		Vector3(1, 0, 0), # 15
		
		# Cara izquierda
		Vector3(0, 1, -1), # 16
		Vector3(0, 0, -1), # 17
		Vector3(0, 0, 0), # 18
		Vector3(0, 1, 0), # 19
		
		# Cara derecha
		Vector3(1, 1, -1), # 20
		Vector3(1, 0, -1), # 21
		Vector3(1, 0, 0), # 22
		Vector3(1, 1, 0), # 23
	])

	#12 triangulos (2 por cara)
	var triangulos := PackedInt32Array([
		# FRENTE (z = 0) 
		4, 5, 7,
		4, 7, 6,
		
		# DETRAS (z = -1)
		0, 2, 3,
		0, 3, 1,
		
		# IZQUIERDA (x = 0)
		19, 18, 17, 
		19, 17, 16,
		
		# DERECHA (x = 1)
		23, 20, 21,
		23, 21, 22,
		
		# ARRIBA ( y = 1)
		8, 9, 11,
		8, 11, 10,
		
		# DEBAJO (y = 0)
		12, 15, 13,
		12, 14, 15
	])

	var normales := Utilidades.calcNormales( vertices, triangulos )
	assert( vertices.size() == normales.size() )
			
	## inicializar el array con las tablas
	var tablas : Array = []   ## tabla vacía incialmente
	tablas.resize( Mesh.ARRAY_MAX ) ## redimensionar al tamaño adecuado
	tablas[ Mesh.ARRAY_VERTEX ] = vertices
	tablas[ Mesh.ARRAY_INDEX  ] = triangulos
	tablas[ Mesh.ARRAY_NORMAL ] = normales
	
	## crear e inicialzar el objeto 'mesh' de este nodo 
	mesh = ArrayMesh.new() ## crea malla en modo diferido, vacía
	mesh.add_surface_from_arrays( Mesh.PRIMITIVE_TRIANGLES, tablas )
	
	## crear un material
	var mat := StandardMaterial3D.new() 
	mat.albedo_color = Color(0.278, 0.748, 0.686, 1.0)
	mat.metallic = 0.3
	mat.roughness = 0.2
	mat.shading_mode = BaseMaterial3D.SHADING_MODE_PER_PIXEL
	
	material_override = mat
	
	## añadir normales para verlas
	mesh_normales = AlgoritmosVarios.generarSegmentosNormales( vertices, normales, 0.15, Color(1.0,1.0,1.0) )
	mesh_normales.visible = ver_normales
	add_child( mesh_normales )
	
	
	
func _unhandled_key_input( key_event: InputEvent ):

	if mesh_normales == null:
		return 
			
	if key_event.keycode == KEY_N and not key_event.pressed :
		ver_normales = not ver_normales
		if ver_normales:
			print("Normales del Cubo8: activado")
		else:
			print("Normales del Cubo8: desactivado")
		mesh_normales.visible = ver_normales
		
	
