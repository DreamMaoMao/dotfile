# mango shader examples

Example window-transition shaders for [mango-ext](https://github.com/mangowm/mango-ext), a Wayland compositor. Drop any of these `.frag` files into your shader directory and your windows will open and close with an effect instead of the default fade.

These are meant as starting points. Tweak them, remix them, or use them as a reference for writing your own.

## Requirements

- mango-ext installed and running.
- That's it. mango-ext already requires GLES 3.0-class hardware, which is exactly what these shaders need.

## Install

Copy the `.frag` files you want into mango-ext's shader directory:

```sh
mkdir -p ~/.config/mango-ext/shaders
cp *.frag ~/.config/mango-ext/shaders/
```

Then restart mango-ext.

## Use

Reference a shader in your config by its filename without the `.frag` extension:

```ini
effect_open=dissolve
effect_close=burn
```

You can also set one per window with a window rule:

```ini
windowrule=appid:firefox,effect_close:glitch
```

Full details on configuration and the shader contract (uniforms, progress direction, premultiplied alpha) are in the [shader docs](https://github.com/mangowm/mango-ext/blob/main/docs/visuals/shaders.md).

## Shaders

- **dissolve**: fine pixel-grain static. The window evaporates like sand blowing away, pixel by pixel.
- **burn**: same crisp grain as dissolve, but pixels about to disappear glow orange first, so the dissolve front looks like glowing embers.
- **melt**: soft cloudy patches. Regions fade out through a smooth organic edge instead of a hard one. The calm sibling of dissolve.
- **glitch**: chromatic aberration tear. Red and blue channels sample at a time-varying horizontal offset while green stays put, then the whole thing fades. Reads as a signal-break glitch.
- **ink**: an ink blot erases or reveals the window. The blot edge is distorted by layered noise so it grows blobby lobes and fine fingers instead of a clean circle.
- **glass**: the window shatters into voronoi shards across five layers, each blowing outward, rotating, and falling under gravity at its own pace. Adapted from the Burn My Windows "Broken Glass" effect.

Progress convention is the same for all of them: `0` is fully present, `1` is fully gone. mango-ext drives progress the right way for open vs. close, so each shader works for both directions.

## Write your own

A shader file is just the body of a `void main()` that writes to `fragColor`. mango-ext prepends a header declaring the uniforms (`u_texture`, `u_progress`, `u_time`, `u_size`) and the coordinate `v_texcoord`. See the [shader docs](https://github.com/mangowm/mango-ext/blob/main/docs/visuals/shaders.md) for the full contract, the GLSL ES 3.00 rules, and a minimal example to copy.

## License

GPL-3.0-or-later. Some shaders are adapted from other GPL-3.0 projects:

- `glass.frag` adapts the "Broken Glass" effect from [Burn My Windows](https://github.com/Schneegans/Burn-My-Windows) by Simon Schneegans.
- `ink.frag` adapts the ink-splash transition from the skwd-wall / niri project.

See `LICENSE` for the full text.
