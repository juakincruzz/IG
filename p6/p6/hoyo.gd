extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	# Imprimimos el nombre para ver qué está chocando
	print("Ha entrado algo: ", body.name)
	
	# Si el nombre contiene "Pelota" (por si se llama Pelota2, Pelota3...)
	if "Pelota" in body.name:
		print("¡ES LA PELOTA!")
		
		body.linear_velocity = Vector3.ZERO
		body.angular_velocity = Vector3.ZERO
		
		# Intentamos llamar a la victoria en la escena principal
		var raiz = get_tree().current_scene
		if raiz.has_method("mostrar_victoria"):
			raiz.mostrar_victoria()
		else:
			print("ERROR: No encuentro la función 'mostrar_victoria' en el nodo raíz")
