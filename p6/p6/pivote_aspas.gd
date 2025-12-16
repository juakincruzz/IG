extends Node3D

@export var velocidad_giro := 90.0

func _physics_process(delta):
	# Rotamos en el eje Z local (asegúrate de que las aspas giren en este eje)
	rotate_z(deg_to_rad(velocidad_giro * delta))
