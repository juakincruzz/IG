extends MeshInstance3D # Asegúrate de que esto coincide con tu tipo de nodo

@export var velocidad_giro := 90.0

func _process(delta):
	# --- PRUEBA LOS EJES UNO POR UNO ---
	
	# Intento 1: Eje Z (El más habitual para frentes)
	rotate_z(deg_to_rad(velocidad_giro * delta))
	
	# Si no gira, comenta la línea de arriba (pon un # delante) 
	# y descomenta la de abajo para probar el eje X:
	# rotate_x(deg_to_rad(velocidad_giro * delta))
	
	# Si tampoco, prueba el Y:
	# rotate_y(deg_to_rad(velocidad_giro * delta))
