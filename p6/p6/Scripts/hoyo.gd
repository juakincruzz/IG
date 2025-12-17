extends Area3D

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if "Pelota" in body.name:
		print("¡Pelota en el tubo!")
		
		# 1. Llamamos a mostrar victoria (saldrá el texto en pantalla)
		var raiz = get_tree().current_scene
		if raiz.has_method("mostrar_victoria"):
			raiz.mostrar_victoria()
