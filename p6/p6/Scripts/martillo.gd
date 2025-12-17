extends Node3D

@export var speed_deg := 180.0
@onready var pivot := $Pivot

func _physics_process(delta: float) -> void:
	pivot.rotate_y(deg_to_rad(speed_deg) * delta)
