shader_type spatial;

// Variables que podrás tocar desde el Inspector
uniform vec3 color_agua : source_color = vec3(0.0, 0.4, 0.8);
uniform float altura_olas = 0.2;
uniform float velocidad = 1.0;

void vertex() {
	// Calculamos el movimiento basado en el tiempo (TIME) y la posición (VERTEX)
	float movimiento = sin(VERTEX.x * 2.0 + TIME * velocidad) * cos(VERTEX.z * 1.5 + TIME * velocidad);

	// Aplicamos ese movimiento a la altura (Y)
	VERTEX.y += movimiento * altura_olas;
}

void fragment() {
	// Pintamos el agua
	ALBEDO = color_agua;

	// Le damos brillo y transparencia
	METALLIC = 0.5;
	ROUGHNESS = 0.1;
	ALPHA = 0.8; // Un poco transparente
}