extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if "Pelota" in body.name:
		# Opción 1: Reiniciar el nivel completo
		get_tree().reload_current_scene()
		
		# Opción 2 (Más Pro): Teletransportar la bola al inicio sin recargar
		# body.global_position = Vector3(0, 1, 0) # Pon aquí las coordenadas de salida
		# body.linear_velocity = Vector3.ZERO
		# body.angular_velocity = Vector3.ZERO
