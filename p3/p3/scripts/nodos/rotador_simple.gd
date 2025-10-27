extends Node3D

# Definimos una variable "exportable"
# Esto significa que podrás cambiar la velocidad
# desde el editor para cada pivote.
@export var rotation_speed_deg := 20.0 # grados por segundo

# Esta variable nos permite decir que accion (tecla) usa este nodo
@export var activar_accion := "toogle_principal"

# Esto guarda si la animacion esta encendida o apagada
var activa := true

func _process(delta):
	# 1. Comprueba si se ha pulsado la tecla que le hemos asignado
	if Input.is_action_just_pressed(activar_accion):
		activa = !activa # Invierte el valor (true -> false | false -> true)
	
	# 2. Solo rotamos si la variable 'activa' es verdadera
	if activa:
		rotation.y += deg_to_rad(rotation_speed_deg * delta)
