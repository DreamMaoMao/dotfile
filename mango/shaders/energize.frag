// energize.frag. Ported from Burn My Windows (GPL-3.0-or-later).

const vec3  uColor = vec3(255.0, 200.0, 50.0) / 255.0;
const float uScale = 1.0;

const float FADE_IN_TIME    = 0.3;
const float FADE_OUT_TIME   = 0.6;
const float HEART_FADE_TIME = 0.3;
const float EDGE_FADE_WIDTH = 50.0;

vec3 hash33(vec3 p3) {
  p3 = fract(p3 * vec3(.1031, .1030, .0973));
  p3 += dot(p3, p3.yxz + 33.33);
  return fract((p3.xxy + p3.yxx) * p3.zyx);
}
float simplex3D(vec3 p) {
  const float F3 = 0.3333333;
  const float G3 = 0.1666667;
  vec3 s = floor(p + dot(p, vec3(F3)));
  vec3 x = p - s + dot(s, vec3(G3));
  vec3 e  = step(vec3(0.0), x - x.yzx);
  vec3 i1 = e * (1.0 - e.zxy);
  vec3 i2 = 1.0 - e.zxy * (1.0 - e);
  vec3 x1 = x - i1 + G3;
  vec3 x2 = x - i2 + 2.0 * G3;
  vec3 x3 = x - 1.0 + 3.0 * G3;
  vec4 w, d;
  w.x = dot(x, x); w.y = dot(x1, x1); w.z = dot(x2, x2); w.w = dot(x3, x3);
  w = max(0.6 - w, 0.0);
  d.x = dot(-0.5 + hash33(s), x);
  d.y = dot(-0.5 + hash33(s + i1), x1);
  d.z = dot(-0.5 + hash33(s + i2), x2);
  d.w = dot(-0.5 + hash33(s + 1.0), x3);
  w *= w; w *= w; d *= w;
  return dot(d, vec4(52.0)) * 0.5 + 0.5;
}

float easeOutQuad(float x) { return -1.0 * x * (x - 2.0); }

vec4 getInputColor(vec2 c) {
  vec4 col = texture(u_texture, c);
  col.rgb /= max(col.a, 1e-4);
  return col;
}

float getEdgeMask(vec2 uv, vec2 maxUV, float fadeWidth) {
  float mask = 1.0;
  mask *= smoothstep(0.0, 1.0, clamp(uv.x / fadeWidth, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp(uv.y / fadeWidth, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp((maxUV.x - uv.x) / fadeWidth, 0.0, 1.0));
  mask *= smoothstep(0.0, 1.0, clamp((maxUV.y - uv.y) / fadeWidth, 0.0, 1.0));
  return mask;
}
float getAbsoluteEdgeMask(float fadePixels) {
  return getEdgeMask(v_texcoord * u_size, u_size, fadePixels);
}
float getRelativeEdgeMask(float fadeAmount) {
  return getEdgeMask(v_texcoord, vec2(1.0), fadeAmount);
}

vec2 getMasks(float progress) {
  float fadeInProgress  = clamp(progress / FADE_IN_TIME, 0.0, 1.0);
  float fadeOutProgress = clamp((progress - FADE_IN_TIME) / FADE_OUT_TIME, 0.0, 1.0);
  float heartProgress   = clamp((progress - (1.0 - HEART_FADE_TIME)) / HEART_FADE_TIME, 0.0, 1.0);

  float dist     = length(v_texcoord - 0.5) * 4.0;
  float atomMask = smoothstep(0.0, 1.0, (fadeInProgress * 2.0 - dist + 1.0));
  atomMask *= fadeInProgress;
  atomMask *= smoothstep(1.0, 0.0, fadeOutProgress);
  atomMask *= getAbsoluteEdgeMask(EDGE_FADE_WIDTH);

  float heartMask = getRelativeEdgeMask(0.5);
  heartMask       = 3.0 * pow(heartMask, 5.0);
  heartMask *= fadeOutProgress;
  heartMask *= 1.0 - heartProgress;
  atomMask = clamp(heartMask + atomMask, 0.0, 1.0);

  float windowMask = pow(1.0 - fadeOutProgress, 2.0);
  return vec2(atomMask, windowMask);
}

void main() {
  float progress = easeOutQuad(u_progress);
  vec2 masks  = getMasks(progress);
  vec4 oColor = getInputColor(v_texcoord);

  oColor.rgb = mix(uColor, oColor.rgb, 0.2 * masks.y + 0.8);
  oColor.a   = oColor.a * masks.y;

  vec2 scaledUV = (v_texcoord - 0.5) * (1.0 + 0.1 * progress);
  scaledUV /= uScale;

  vec2 uv = scaledUV + vec2(0.0, 0.1 * u_time);
  uv *= 0.010598 * vec2(0.5 * u_size.x, u_size.y);
  float particles = 0.2 * pow(simplex3D(vec3(uv, 0.0)), 3.0);

  for (float i = 1.0; i <= 3.0; ++i) {
    vec2 luv  = scaledUV * 0.12154 / pow(1.5, i) * u_size;
    float atoms = simplex3D(vec3(luv, 2.0 * u_time / i));
    particles += 0.5 * pow(0.2 * (1.0 / (1.0 - atoms) - 1.0), 2.0);
  }

  oColor.rgb += uColor * particles * masks.x;
  oColor.a   += particles * masks.x;

  fragColor = vec4(oColor.rgb * oColor.a, oColor.a);
}
