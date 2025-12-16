extends Node3D

# Referencias
@export var pelota: RigidBody3D
@export var camara: Camera3D

# --- NUEVAS REFERENCIAS PARA UI ---
@export var label_puntuacion: Label
@export var label_victoria: Label
# ----------------------------------

# Configuración del golpe
@export var fuerza_maxima := 50.0
@export var velocidad_carga := 30.0

var potencia_actual := 0.0
var cargando := false
var golpes := 0 # Contador de intentos

func _process(delta):
	# --- LÓGICA DE DISPARO (ESPACIO) ---
	if Input.is_action_pressed("disparo"):
		cargando = true
		potencia_actual += velocidad_carga * delta
		if potencia_actual > fuerza_maxima: potencia_actual = fuerza_maxima
		print("Potencia: ", int(potencia_actual))

	elif cargando and Input.is_action_just_released("disparo"):
		disparar()
		cargando = false
		potencia_actual = 0.0

func _unhandled_input(event):
	# --- LÓGICA DE CREACIÓN (CLICK DERECHO) ---
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
		crear_obstaculo()

func disparar():
	if not pelota or not camara: return
	
	# SUMAR GOLPE Y ACTUALIZAR TEXTO
	golpes += 1
	if label_puntuacion:
		label_puntuacion.text = "Golpes: " + str(golpes)
	
	var direccion = -camara.global_transform.basis.z
	direccion.y = 0
	direccion = direccion.normalized()
	if pelota.has_method("golpear"):
		pelota.golpear(direccion, potencia_actual)

func crear_obstaculo():
	if not camara: return

	# 1. RAYCAST MANUAL
	var mouse_pos = get_viewport().get_mouse_position()
	var origin = camara.project_ray_origin(mouse_pos)
	var end = origin + camara.project_ray_normal(mouse_pos) * 1000
	
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(origin, end)
	var result = space_state.intersect_ray(query)
	
	if result:
		# Si clicamos en el Suelo, creamos el obstáculo
		if result.collider.name == "Suelo":
			var nuevo_obstaculo = StaticBody3D.new()
			add_child(nuevo_obstaculo) 
			nuevo_obstaculo.global_position = result.position + Vector3(0, 0.5, 0)
			
			var mesh_instance = MeshInstance3D.new()
			mesh_instance.mesh = BoxMesh.new() 
			var mat = StandardMaterial3D.new()
			mat.albedo_color = Color(0.6, 0.4, 0.2) 
			mesh_instance.material_override = mat
			nuevo_obstaculo.add_child(mesh_instance) 
			
			var colision = CollisionShape3D.new()
			colision.shape = BoxShape3D.new() 
			nuevo_obstaculo.add_child(colision)
			
			print("Obstáculo creado")
			
# --- FUNCIÓN NUEVA PARA GANAR ---
func mostrar_victoria():
	if label_victoria:
		label_victoria.visible = true
		label_victoria.text = "¡GANASTE EN " + str(golpes) + " GOLPES!"
