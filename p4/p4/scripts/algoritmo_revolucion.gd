# archivo: algoritmo_revolucion.gd
extends Node

# Función que genera una malla 3D revolucionando un perfil 2D alrededor del eje Y.
# - perfil: Un array de Vector2 que define la forma a revolucionar.
# - num_copias: El número de "gajos" o secciones para formar el objeto. Más copias, más suave será.
# - vertices: El array de salida para los vértices 3D (se rellena aquí).
# - triangulos: El array de salida para los índices de los triángulos (se rellena aquí).
func generar_malla_por_revolucion(perfil: PackedVector2Array, num_copias: int, vertices: PackedVector3Array, triangulos: PackedInt32Array) -> void:
	
	if perfil.size() < 2 or num_copias < 3:
		print("Error: El perfil necesita al menos 2 puntos y se necesitan al menos 3 copias.")
		return

	# --- 1. Generación de Vértices ---
	var angulo_incremento = (2.0 * PI) / num_copias
	
	# Bucle para cada copia/sección alrededor del eje Y
	for i in range(num_copias):
		var angulo_actual = i * angulo_incremento
		var transformacion = Transform3D().rotated(Vector3(0, 1, 0), angulo_actual)
		
		# Bucle para cada punto del perfil original
		for punto2D in perfil:
			# Convertimos el punto 2D (x,y) a un punto 3D (x,y,0) y lo rotamos
			var punto3D = Vector3(punto2D.x, punto2D.y, 0)
			vertices.append(transformacion * punto3D)

	# --- 2. Generación de Triángulos ---
	var num_puntos_perfil = perfil.size()
	
	# Bucle para cada "cara" entre dos copias consecutivas
	for i in range(num_copias):
		# Bucle para cada segmento del perfil
		for j in range(num_puntos_perfil - 1):
			# Índices de los 4 vértices que forman un "quad"
			var v1 = i * num_puntos_perfil + j
			var v2 = i * num_puntos_perfil + (j + 1)
			# Usamos el módulo (%) para que la última copia conecte con la primera
			var v3 = ((i + 1) % num_copias) * num_puntos_perfil + j
			var v4 = ((i + 1) % num_copias) * num_puntos_perfil + (j + 1)
			
			# Creamos dos triángulos para formar el quad
			# Triángulo 1: v1, v3, v2
			triangulos.append(v1)
			triangulos.append(v2)
			triangulos.append(v3)
			
			# Triángulo 2: v3, v4, v2
			triangulos.append(v2)
			triangulos.append(v4)
			triangulos.append(v3)
