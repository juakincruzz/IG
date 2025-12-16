extends RigidBody3D

# Fuerza multiplicadora para el golpe
@export var fuerza_golpe := 5.0

func _ready():
	# Nos aseguramos de que no duerma la física al principio
	sleeping = false

func golpear(direccion: Vector3, potencia: float):
	# Aplicamos un impulso instantáneo
	# direccion debe estar normalizada
	# potencia suele ser un valor entre 0 y 1 (o más)
	
	var impulso = direccion * potencia * fuerza_golpe
	apply_central_impulse(impulso)
