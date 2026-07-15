// tv.frag — CRT power-off. Ported from Burn My Windows (GPL-3.0-or-later).
// SPDX-FileCopyrightText: Simon Schneegans <code@simonschneegans.de>
// SPDX-License-Identifier: GPL-3.0-or-later

const float BLUR_WIDTH = 0.01;
const float TB_TIME    = 0.7;
const float LR_TIME    = 0.4;
const float LR_DELAY   = 0.6;
const float FF_TIME    = 0.1;
const float SCALING    = 0.5;
const vec4  uColor     = vec4(1.0, 1.0, 1.0, 1.0);

float easeOutQuad(float x) { return -1.0 * x * (x - 2.0); }

void main() {
  float prog = easeOutQuad(u_progress);

  float scale = 1.0 / mix(1.0, SCALING, prog) - 1.0;
  vec2 coords = v_texcoord;
  coords.y    = coords.y * (scale + 1.0) - scale * 0.5;

  float tbProg = smoothstep(0.0, 1.0, clamp(prog / TB_TIME, 0.0, 1.0));
  float lrProg = smoothstep(0.0, 1.0, clamp((prog - LR_DELAY) / LR_TIME, 0.0, 1.0));
  float ffProg = smoothstep(0.0, 1.0, clamp((prog - 1.0 + FF_TIME) / FF_TIME, 0.0, 1.0));

  float tb = coords.y * 2.0;
  tb       = tb < 1.0 ? tb : 2.0 - tb;

  float lr = coords.x * 2.0;
  lr       = lr < 1.0 ? lr : 2.0 - lr;

  float tbMask = 1.0 - smoothstep(0.0, 1.0, clamp((tbProg - tb) / BLUR_WIDTH, 0.0, 1.0));
  float lrMask = 1.0 - smoothstep(0.0, 1.0, clamp((lrProg - lr) / BLUR_WIDTH, 0.0, 1.0));
  float ffMask = 1.0 - smoothstep(0.0, 1.0, ffProg);

  float mask = tbMask * lrMask * ffMask;

  vec4 col = texture(u_texture, coords);
  col.rgb = mix(col.rgb, uColor.rgb * col.a, uColor.a * smoothstep(0.0, 1.0, prog));
  col.a *= mask;

  fragColor = vec4(col.rgb * col.a, col.a);
}
