float hash12(vec2 p) {
	return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}
vec2 shard_map(vec2 p) {
	vec2 n = floor(p);
	vec2 f = fract(p);
	float f1 = 8.0;
	float f2 = 8.0;
	vec2 best = vec2(0.0);
	for (int j = -1; j <= 1; j++) {
		for (int i = -1; i <= 1; i++) {
			vec2 g = vec2(float(i), float(j));
			vec2 cell = n + g;
			vec2 o = vec2(hash12(cell * 0.0311),
						  hash12(cell * 0.0311 + 0.5));
			vec2 r = g + o - f;
			float d = dot(r, r);
			if (d < f1) {
				f2 = f1;
				f1 = d;
				best = cell;
			} else if (d < f2) {
				f2 = d;
			}
		}
	}
	float edge = sqrt(f2) - sqrt(f1); // 0 at shard borders
	return vec2(edge, hash12(best * 0.0311 + 0.25));
}

const float SHARD_LAYERS = 5.0;
const float BLOW_FORCE = 0.4;
const float GRAVITY = 1.5;
const float SHARD_SIZE = 110.0;

void main() {
	float p = u_progress;
	float aspect = u_size.x / max(u_size.y, 1.0);
	vec2 epicenter = vec2(0.5, 0.5);
	vec4 o = vec4(0.0);

	for (float i = 0.0; i < SHARD_LAYERS; i += 1.0) {
		vec2 coords = v_texcoord - epicenter;
		coords.x *= aspect;
		coords /= mix(1.0, 1.0 + BLOW_FORCE * (i + 2.0) / SHARD_LAYERS, p);
		float rot = (mod(i, 2.0) - 0.5) * 0.2 * p;
		float cr = cos(rot);
		float sr = sin(rot);
		coords = vec2(coords.x * cr - coords.y * sr,
					  coords.x * sr + coords.y * cr);
		coords.y -= GRAVITY * 0.1 * (i + 1.0) * p * p;
		coords.x /= aspect;
		coords += epicenter;
		vec2 sm = shard_map(coords * u_size / SHARD_SIZE);
		float group = floor(sm.y * SHARD_LAYERS * 0.999);
		if (group == i && sm.x * 2.5 + 0.1 - (p + 0.1) * (p + 0.1) > 0.0) {
			vec4 c = (coords.x < 0.0 || coords.x > 1.0 ||
					  coords.y < 0.0 || coords.y > 1.0)
				? vec4(0.0)
				: vec4(texture(u_texture, coords).rgb, 1.0);
			float layer_off = i / SHARD_LAYERS * 0.3;
			float fade = 1.0 -
				smoothstep(0.3 + layer_off, 0.8 + layer_off * 0.5, p);
			c.a *= fade;
			o = c;
		}
	}

	fragColor = vec4(o.rgb * o.a, o.a);
}
