// doom.frag. Ported from Burn My Windows (GPL-3.0-or-later).

const float uPixelSize       = 10.0;
const float uHorizontalScale = 10.0;
const float uVerticalScale   = 10.0;
const float uActorScale      = 1.0;

vec2 hash22(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * vec3(.1031, .1030, .0973));
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.xx + p3.yz) * p3.zy);
}
float simplex2D(vec2 p) {
  const float K1 = 0.366025404;
  const float K2 = 0.211324865;
  vec2 i  = floor(p + (p.x + p.y) * K1);
  vec2 a  = p - i + (i.x + i.y) * K2;
  float m = step(a.y, a.x);
  vec2 o  = vec2(m, 1.0 - m);
  vec2 b  = a - o + K2;
  vec2 c  = a - 1.0 + 2.0 * K2;
  vec3 h  = max(0.5 - vec3(dot(a, a), dot(b, b), dot(c, c)), 0.0);
  vec3 n  = h * h * h * h *
           vec3(dot(a, -1.0 + 2.0 * hash22(i + 0.0)),
                dot(b, -1.0 + 2.0 * hash22(i + o)),
                dot(c, -1.0 + 2.0 * hash22(i + 1.0)));
  return 0.5 + 0.5 * dot(n, vec3(70.0));
}
float simplex2DFractal(vec2 p) {
  mat2 m  = mat2(1.6, 1.2, -1.2, 1.6);
  float f = 0.5000 * simplex2D(p);
  p       = m * p;
  f += 0.2500 * simplex2D(p);
  p = m * p;
  f += 0.1250 * simplex2D(p);
  p = m * p;
  f += 0.0625 * simplex2D(p);
  return f;
}

vec4 getInputColor(vec2 c) {
  vec4 col = texture(u_texture, c);
  col.rgb /= max(col.a, 1e-4);
  return col;
}

float getEdgeMask(vec2 uv, float fadeWidth) {
  float mask = 1.0;
  mask *= smoothstep(0.0, 1.0, clamp(uv.y / fadeWidth, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp((1.0 - uv.y) / fadeWidth, 0.0, 1.0));
  return mask;
}

void main() {
  float pixelSize = max(1.0, ceil(uPixelSize * u_progress + 1.0));
  vec2 pixelGrid  = vec2(pixelSize) / u_size;

  vec2 texcoord = v_texcoord;
  texcoord.y    = texcoord.y * uActorScale + 0.5 - uActorScale * 0.5;
  texcoord -= mod(v_texcoord, pixelGrid);
  texcoord += pixelGrid * 0.5;

  float hScale = uHorizontalScale * u_size.x * 0.001;
  float noise  = simplex2DFractal(texcoord.xx * hScale) * 2.0 - 0.5;

  float vScale        = uVerticalScale * u_size.y * 0.00002 * uActorScale;
  float shift = noise * vScale + sin(u_progress * 3.14159265) * 0.3;

  texcoord.y -= 0.5 * uActorScale * shift;

  vec4 oColor = getInputColor(texcoord);
  oColor.a *= getEdgeMask(v_texcoord, 0.1);

  fragColor = vec4(oColor.rgb * oColor.a, oColor.a);
}
