// glitch.frag
void main() {
	float shift = u_progress * 0.05 *
		sin(mod(u_time * 40.0 + v_texcoord.y * 50.0, 6.2831853));
	vec4 c;
	c.r = texture(u_texture, v_texcoord + vec2(shift, 0.0)).r;
	c.g = texture(u_texture, v_texcoord).g;
	c.b = texture(u_texture, v_texcoord - vec2(shift, 0.0)).b;
	c.a = texture(u_texture, v_texcoord).a;
	fragColor = vec4(c.rgb * c.a, c.a) * (1.0 - u_progress);
}
