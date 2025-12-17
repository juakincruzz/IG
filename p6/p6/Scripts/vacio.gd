extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body is RigidBody3D:
		print("¡Caída al vacío! Reiniciando...")
		
		call_deferred("reiniciar_nivel")

func reiniciar_nivel():
	get_tree().reload_current_scene()
