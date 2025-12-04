extends Light3D # ¡Importante! No es Node3D

@export var toggle_action := "toggle_luz_dir"

func _process(delta):
	if Input.is_action_just_pressed(toggle_action):
		visible = !visible # Invierte la visibilidad
