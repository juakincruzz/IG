extends Node3D

# --- REFERENCIAS ---
@export var pelota: Node3D
@export var camara_hija: Camera3D # Arrastra aquí la cámara hija

# --- VARIABLES DE CONFIGURACIÓN ---
@export_group("Ajustes de Cámara")
@export var distancia := 5.0      # Cuánto se aleja hacia atrás (Eje Z)
@export var altura := 3.0         # Cuánto sube (Eje Y)
@export var angulo_extra := -10.0 # Rotación extra por si quieres que mire más abajo/arriba
@export var velocidad_giro := 2.0

func _process(delta):
	if !pelota or !camara_hija: return

	# 1. POSICIÓN DEL SOPORTE (Seguimiento suave)
	# El soporte viaja a donde está la pelota
	global_position = global_position.lerp(pelota.global_position, 10.0 * delta)
	
	# 2. COLOCACIÓN DE LA CÁMARA (Usando tus variables)
	# En lugar de moverla con el ratón, le decimos por código dónde estar
	# respecto al soporte.
	camara_hija.position.x = 0
	camara_hija.position.y = altura
	camara_hija.position.z = distancia
	
	# 3. ROTACIÓN DE LA CÁMARA (Ángulo)
	# Primero: Hacemos que la cámara mire al soporte (la pelota)
	camara_hija.look_at(global_position)
	# Segundo: Le sumamos tu variable de rotación extra (Pitch)
	camara_hija.rotation_degrees.x += angulo_extra

	# 4. GIRO DEL JUGADOR (Rotar el soporte entero)
	if Input.is_action_pressed("ui_left"):
		rotate_y(velocidad_giro * delta)
	if Input.is_action_pressed("ui_right"):
		rotate_y(-velocidad_giro * delta)  
