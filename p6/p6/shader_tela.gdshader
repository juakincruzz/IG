shader_type spatial;
// 'cull_disabled' hace que la tela se vea por las dos caras
render_mode cull_disabled;

// Variables ajustables en el inspector
uniform vec3 color_tela : source_color = vec3(0.8, 0.1, 0.1); // Rojo por defecto
uniform float velocidad_viento = 3.0;
uniform float fuerza_viento = 0.1;
uniform float frecuencia_ondas = 10.0;

void vertex() {
	// --- MAGIA DEL VIENTO ---
	// 1. Calculamos una onda basada en el tiempo y la posición horizontal (X)
	float onda = sin(VERTEX.x * frecuencia_ondas + TIME * velocidad_viento);
	
	// 2. Creamos una "máscara". Como el palo está en X=0 (aprox),
	// usamos la propia posición X como multiplicador.
	// Si X es 0 (pegado al palo), el movimiento será 0.
	// Cuanto más a la derecha (mayor X), más fuerte será el movimiento.
	float mascara_sujecion = clamp(VERTEX.x + 0.25, 0.0, 1.0); // Ajusta el 0.25 si no queda pegado

	// 3. Aplicamos el movimiento al eje Z (hacia "afuera" de la tela)
	VERTEX.z += onda * fuerza_viento * mascara_sujecion;
	
	// Opcional: Un poquito de movimiento en Y para que parezca gravedad
	VERTEX.y += cos(VERTEX.x * 5.0 + TIME * 2.0) * (fuerza_viento * 0.2) * mascara_sujecion;
}

void fragment() {
	// Pintamos la tela
	ALBEDO = color_tela;
	ROUGHNESS = 0.8; // La tela no brilla mucho
	SPECULAR = 0.1;
}