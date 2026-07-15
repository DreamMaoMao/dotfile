float hash12(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float vnoise(vec2 p) {
	vec2 i = floor(p);
	vec2 f = fract(p);
	f = f * f * (3.0 - 2.0 * f);
	float a = hash12(i * 0.0117);
	float b = hash12((i + vec2(1.0, 0.0)) * 0.0117);
	float c = hash12((i + vec2(0.0, 1.0)) * 0.0117);
	float d = hash12((i + vec2(1.0, 1.0)) * 0.0117);
	return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

float fbm(vec2 p) {
	float v = 0.0;
	float amp = 0.5;
	for (int i = 0; i < 5; i++) {
		v += amp * vnoise(p);
		p *= 2.1;
		amp *= 0.5;
	}
	return v;
}

void main() {
	vec4 win = texture(u_texture, v_texcoord);
	float p = 1.0 - u_progress;
	vec2 uv = v_texcoord;
	float blob = fbm(uv * 3.5);
	float fingers = fbm(uv * 14.0);
	float distortion = (blob - 0.5) * 0.5 + (fingers - 0.5) * 0.18;
	vec2 c = uv - vec2(0.5);
	c.x *= u_size.x / max(u_size.y, 0.0001);
	float d = length(c);
	float splash_d = d + distortion;
	float boundary = p * 1.7 - 0.15;
	float reveal = smoothstep(0.04, -0.04, splash_d - boundary);
	fragColor = win * reveal;
}
