// melt.frag
float hash12(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash12(i * 0.0311);
	float b = hash12((i + vec2(1.0, 0.0)) * 0.0311);
	float c = hash12((i + vec2(0.0, 1.0)) * 0.0311);
	float d = hash12((i + vec2(1.0, 1.0)) * 0.0311);
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void main() {
	vec4 c = texture(u_texture, v_texcoord);
	vec2 px = v_texcoord * u_size;
	float n = 0.65 * vnoise(px / 56.0) + 0.35 * vnoise(px / 14.0);
	n = clamp((n - 0.5) * 1.6 + 0.5, 0.0, 1.0);
	float a = smoothstep(u_progress - 0.12, u_progress + 0.04, n);
	fragColor = c * a;
}
