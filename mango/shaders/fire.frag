// fire.frag. Ported from Burn My Windows (GPL-3.0-or-later).

const float uScale        = 1.0;
const float uMovementSpeed = 0.5;
const vec4  uGradient1    = vec4(vec3(76.0, 51.0, 25.0) / 255.0, 0.0);
const vec4  uGradient2    = vec4(vec3(180.0, 55.0, 30.0) / 255.0, 0.7);
const vec4  uGradient3    = vec4(vec3(255.0, 76.0, 38.0) / 255.0, 0.9);
const vec4  uGradient4    = vec4(vec3(255.0, 166.0, 25.0) / 255.0, 1.0);
const vec4  uGradient5    = vec4(vec3(255.0, 255.0, 255.0) / 255.0, 1.0);

const float EDGE_FADE  = 70.0;
const float FADE_WIDTH = 0.1;
const float HIDE_TIME  = 0.4;

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

float easeOutQuad(float x) { return -1.0 * x * (x - 2.0); }

vec4 getInputColor(vec2 c) {
  vec4 col = texture(u_texture, c);
  col.rgb /= max(col.a, 1e-4);
  return col;
}

float getAbsoluteEdgeMask(float fadePixels) {
  vec2 uv = v_texcoord * u_size;
  float mask = 1.0;
  mask *= smoothstep(0.0, 1.0, clamp(uv.x / fadePixels, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp(uv.y / fadePixels, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp((u_size.x - uv.x) / fadePixels, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp((u_size.y - uv.y) / fadePixels, 0.0, 1.0));
  return mask;
}

vec4 alphaOver(vec4 under, vec4 over) {
  if (under.a == 0.0 && over.a == 0.0) return vec4(0.0);
  float a = mix(under.a, 1.0, over.a);
  return vec4(mix(under.rgb * under.a, over.rgb, over.a) / a, a);
}

vec4 getFireColor(float v) {
  float steps[5];
  steps[0] = 0.0; steps[1] = 0.2; steps[2] = 0.35; steps[3] = 0.5; steps[4] = 0.8;
  vec4 colors[5];
  colors[0] = uGradient1; colors[1] = uGradient2; colors[2] = uGradient3;
  colors[3] = uGradient4; colors[4] = uGradient5;
  if (v < steps[0]) return colors[0];
  for (int i = 0; i < 4; ++i) {
    if (v <= steps[i + 1]) {
      return mix(colors[i], colors[i + 1], vec4(v - steps[i]) / (steps[i + 1] - steps[i]));
    }
  }
  return colors[4];
}

vec2 effectMask() {
  float progress = easeOutQuad(u_progress);
  float burnProgress      = clamp(progress / HIDE_TIME, 0.0, 1.0);
  float afterBurnProgress = clamp((progress - HIDE_TIME) / (1.0 - HIDE_TIME), 0.0, 1.0);
  float t = v_texcoord.t * (1.0 - FADE_WIDTH);
  float windowMask = 1.0 - clamp((burnProgress - t) / FADE_WIDTH, 0.0, 1.0);
  float mask = clamp(t * (1.0 - windowMask) / burnProgress, 0.0, 1.0);
  if (progress > HIDE_TIME) {
    float fade = sqrt(1.0 - afterBurnProgress * afterBurnProgress);
    mask *= mix(1.0, 1.0 - t, afterBurnProgress) * fade;
  }
  mask *= getAbsoluteEdgeMask(EDGE_FADE);
  return vec2(windowMask, mask);
}

void main() {
  vec2 uv = v_texcoord * u_size / vec2(400.0, 600.0) / uScale;
  uv.y += u_time * uMovementSpeed;
  float noise = simplex2DFractal(uv * 4.0);

  vec2 mask = effectMask();
  noise *= mask.y;

  vec4 fire = getFireColor(noise);
  vec4 oColor = getInputColor(v_texcoord);
  oColor.a *= mask.x;
  oColor = alphaOver(oColor, fire);

  fragColor = vec4(oColor.rgb * oColor.a, oColor.a);
}
