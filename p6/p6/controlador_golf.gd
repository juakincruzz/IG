extends Camera3D

@onready var ray = $RayCast3D

# Variables para el control del golpe
var pelota_seleccionada: RigidBody3D = null
var pos_inicial_raton: Vector2
var apuntando := false

# Configuración
@export var factor_potencia := 0.05 # Ajusta esto si el golpe es muy fuerte/débil
@export var potencia_maxima := 100.0

func _input(event):
	# 1. DETECTAR CLIC EN LA PELOTA
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# --- Al pulsar: Buscamos si hemos clicado la pelota ---
			var mouse_pos = get_viewport().get_mouse_position()
			var from = project_ray_origin(mouse_pos)
			var to = from + project_ray_normal(mouse_pos) * 1000.0
			
			ray.global_position = from
			ray.look_at(to)
			ray.force_raycast_update()
			
			if ray.is_colliding():
				var collider = ray.get_collider()
				
				# Comprobamos si lo que tocamos tiene el script de la pelota
				# (Asumiendo que el script de la pelota tiene la función 'golpear')
				if collider.has_method("golpear"):
					pelota_seleccionada = collider
					pos_inicial_raton = mouse_pos
					apuntando = true
					print("Apuntando...")
		
		# 2. SOLTAR CLIC (DISPARAR)
		elif apuntando:
			# --- Al soltar: Calculamos el vector y disparamos ---
			var pos_final_raton = get_viewport().get_mouse_position()
			disparar(pos_final_raton)
			
			# Reseteamos
			apuntando = false
			pelota_seleccionada = null

	# 3. MOVER RATÓN (SOLO VISUAL / DEBUG)
	elif event is InputEventMouseMotion and apuntando:
		# Aquí podríamos dibujar una flecha en el futuro
		pass

func disparar(pos_final: Vector2):
	if not pelota_seleccionada: return
	
	# Calculamos el vector de arrastre (Desde donde soltamos HASTA donde clicamos)
	# Esto hace que si arrastras hacia atrás, la bola salga hacia adelante (típico de golf/angry birds)
	var vector_arrastre = pos_inicial_raton - pos_final
	
	# Calculamos la magnitud (cuánto hemos arrastrado)
	var distancia = vector_arrastre.length()
	
	# Si el arrastre es muy pequeño, ignoramos (para evitar clics accidentales)
	if distancia < 10.0: return
	
	# Calculamos potencia y dirección
	var potencia = min(distancia * factor_potencia, potencia_maxima)
	
	# OJO: El ratón es 2D (pantalla), pero el mundo es 3D.
	# Tenemos que convertir la dirección del ratón a dirección de mundo.
	# Usamos la cámara para saber "hacia dónde es adelante".
	
	# Obtenemos la dirección en la que mira la cámara (pero plana en el suelo)
	var cam_forward = -global_transform.basis.z
	var cam_right = global_transform.basis.x
	cam_forward.y = 0
	cam_right.y = 0
	cam_forward = cam_forward.normalized()
	cam_right = cam_right.normalized()
	
	# Convertimos el movimiento del ratón (X, Y) a movimiento 3D (Right, Forward)
	# vector_arrastre.x influye en el eje derecho de la cámara
	# vector_arrastre.y (arriba/abajo pantalla) influye en el eje adelante de la cámara
	var direccion_golpe = (cam_right * vector_arrastre.x) + (cam_forward * -vector_arrastre.y)
	direccion_golpe = direccion_golpe.normalized()
	
	print("Disparando con potencia: ", potencia)
	
	# Llamamos a la función de la pelota
	pelota_seleccionada.golpear(direccion_golpe, potencia)
