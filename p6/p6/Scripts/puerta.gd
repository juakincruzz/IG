extends Node3D

@export var abierta_offset: Vector3 = Vector3(0, 2.0, 0)
@export var tiempo_mov: float = 0.8
@export var tiempo_espera: float = 0.6

@onready var body: AnimatableBody3D = $BodyPuerta 

var cerrada_pos: Vector3
var abierta_pos: Vector3
var abierta := false
var tween: Tween

func _ready():
	cerrada_pos = body.position
	abierta_pos = cerrada_pos + abierta_offset
	_bucle()

func _bucle() -> void:
	while true:
		await _mover_puerta(abierta_pos)
		await get_tree().create_timer(tiempo_espera).timeout
		await _mover_puerta(cerrada_pos)
		await get_tree().create_timer(tiempo_espera).timeout

func _mover_puerta(dest: Vector3) -> void:
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(body, "position", dest, tiempo_mov)
	await tween.finished
