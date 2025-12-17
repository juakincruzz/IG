extends Node3D

# --- REFERENCIAS ---
@export var pelota: RigidBody3D
@export var soporte_camara: Node3D
@export var flecha_visual: Node3D
@export var label_ui: Label

# --- CONFIGURACIÓN DE FUERZAS ---
@export_group("Potencia de Palos")
@export var fuerza_putter := 5.0
@export var fuerza_hierro := 20.0
@export var fuerza_driver := 40.0

# --- VARIABLES INTERNAS ---
var fuerza_seleccionada := 0.0 
var nombre_palo := "Putter (1)"
var golpes := 0

func _ready():
	print("--- JUEGO INICIADO ---")
	
	fuerza_seleccionada = fuerza_putter
	nombre_palo = "Putter (1)"
	
	actualizar_ui()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _process(delta):
	# Soporte sigue a la pelota
	if pelota and soporte_camara:
		soporte_camara.global_position = pelota.global_position

	# Teclas para cambiar palo
	if Input.is_action_just_pressed("tecla_1"): 
		cambiar_fuerza(fuerza_putter, "Putter (1)")
	if Input.is_action_just_pressed("tecla_2"): 
		cambiar_fuerza(fuerza_hierro, "Hierro (2)")
	if Input.is_action_just_pressed("tecla_3"): 
		cambiar_fuerza(fuerza_driver, "Driver (3)")
	
	# Salir con ESC
	if Input.is_key_pressed(KEY_ESCAPE):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		if flecha_visual: flecha_visual.visible = false

func _input(event):
	# Giro de cámara
	if event is InputEventMouseMotion:
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			if soporte_camara:
				soporte_camara.rotate_y(-event.relative.x * 0.005)

	# Clic Izquierdo
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			if flecha_visual: flecha_visual.visible = true
		elif Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			disparar()

func cambiar_fuerza(fuerza, nombre):
	fuerza_seleccionada = fuerza
	nombre_palo = nombre
	actualizar_ui()
	print("Cambiado a: ", nombre)

func actualizar_ui():
	if label_ui:
		label_ui.text = "Golpes: " + str(golpes) + "\nPalo: " + nombre_palo + "\nFuerza: " + str(fuerza_seleccionada)

func disparar():
	if not pelota: return

	# Sumamos el golpe
	golpes += 1
	actualizar_ui()
	
	print("PUM! Fuerza: ", fuerza_seleccionada)
	
	var direccion = -soporte_camara.global_transform.basis.z
	direccion.y = 0 
	pelota.apply_central_impulse(direccion.normalized() * fuerza_seleccionada)

# --- FUNCIÓN DE VICTORIA ---
func mostrar_victoria():
	print("¡VICTORIA CONFIRMADA!")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if label_ui:
		label_ui.text = "HAS GANADO!!\nGolpes totales: " + str(golpes)
