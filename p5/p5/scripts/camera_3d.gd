extends Camera3D

@onready var ray = $RayCast3D

# --- VARIABLES NUEVAS PARA EL ARRASTRE ---
var objeto_seleccionado = null
var plano_arrastre = Plane()
# -----------------------------------------

func _input(event):
	var mouse_pos = get_viewport().get_mouse_position()
	var from = project_ray_origin(mouse_pos)
	var to = from + project_ray_normal(mouse_pos) * 1000.0
	
	# 1. DETECTAR CLIC (PRESIONAR Y SOLTAR)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			# --- Lógica original de Raycast al hacer clic ---
			ray.global_position = from
			ray.look_at(to)
			ray.target_position = Vector3(0, 0, -1000) 
			ray.force_raycast_update()
			
			if ray.is_colliding():
				var objeto = ray.get_collider()
				
				if objeto.name == "Suelo":
					# Tu lógica original para crear cubos
					crear_cubo_en(ray.get_collision_point())
					print("Creado cubo en:", ray.get_collision_point())
				else:
					# NUEVO: Si no es suelo, empezamos a arrastrar
					print("Seleccionado para mover:", objeto.name)
					
					# Usamos get_parent() para mover la Malla, no solo el colisionador invisible.
					objeto_seleccionado = objeto.get_parent() 
					
					# Creamos un plano imaginario a la altura del objeto para moverlo por ahí
					plano_arrastre = Plane(Vector3.UP, objeto_seleccionado.global_position.y)
		else:
			# NUEVO: Al soltar el clic, soltamos el objeto
			objeto_seleccionado = null

	# 2. DETECTAR MOVIMIENTO DEL RATÓN (ARRASTRAR)
	elif event is InputEventMouseMotion and objeto_seleccionado != null:
		# Calculamos dónde corta el rayo del ratón con el plano imaginario
		var punto_corte = plano_arrastre.intersects_ray(from, project_ray_normal(mouse_pos))
		
		if punto_corte:
			objeto_seleccionado.global_position = punto_corte


func crear_cubo_en(pos):
	var nuevo_cubo = MeshInstance3D.new()
	nuevo_cubo.mesh = BoxMesh.new()

	# Elevarlo para que no atraviese el suelo
	nuevo_cubo.position = pos + Vector3.UP * 0.5

	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(randf(), randf(), randf())

	nuevo_cubo.material_override = mat

	get_tree().get_current_scene().add_child(nuevo_cubo)
