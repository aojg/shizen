shader_type spatial;
varying vec3 col;

void vertex() {
	col = vec3(abs(VERTEX.x), abs(VERTEX.y), abs(VERTEX.z));
}

void fragment() {
	ALBEDO = col;
}
	