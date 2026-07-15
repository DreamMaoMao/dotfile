// dissolve.frag
float hash12(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

void main() {
	vec4 c = texture(u_texture, v_texcoord);
	vec2 cell = mod(floor(v_texcoord * u_size / 2.0), 128.0);
	float n = hash12(cell * 0.0311);
	float a = step(u_progress, n);
	fragColor = c * a;
}
