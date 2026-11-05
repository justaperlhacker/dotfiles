// CRT static noise for the Ghost Terminal look.
// Tiled scrolling grain, applied as a background/foreground tint with a
// tiny static grain on top. Restarts cleanly when the surface regains focus.

const float NOISE_STRENGTH = 0.02;   // dynamic grain amount
const float NOISE_GRAIN = 0.0015;    // static fine grain
const float NOISE_SCALE = 2.0;       // pixels per noise cell
const float NOISE_PERIOD = 256.0;    // tile period in cells
const float NOISE_TIME_A = 0.10;     // scroll period A
const float NOISE_TIME_B = 0.37;     // scroll period B
const float NOISE_VIGNETTE = 1.3;    // edge falloff

float noiseHash(vec2 p) {
    p = fract(p * vec2(443.897, 441.423));
    p += dot(p, p + 19.19);
    return fract(p.x * p.y);
}

float tileNoise(vec2 p) {
    vec2 i = floor(p);
    vec2 f = fract(p);
    f = f * f * (3.0 - 2.0 * f);

    float a = noiseHash(mod(i, NOISE_PERIOD));
    float b = noiseHash(mod(i + vec2(1.0, 0.0), NOISE_PERIOD));
    float c = noiseHash(mod(i + vec2(0.0, 1.0), NOISE_PERIOD));
    float d = noiseHash(mod(i + vec2(1.0, 1.0), NOISE_PERIOD));

    return mix(mix(a, b, f.x), mix(c, d, f.x), f.y);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 color = texture(iChannel0, fragCoord / iResolution.xy);

    // Restart the scroll when the surface regains focus.
    float noiseTime = (iFocus != 0) ? max(iTime - iTimeFocus, 0.0) : 0.0;
    vec2 offset = vec2(fract(noiseTime / NOISE_TIME_A),
                       fract(noiseTime / NOISE_TIME_B)) * NOISE_PERIOD;

    vec2 uv = fragCoord / iResolution.xy;
    float vignette = clamp(1.0 - length(uv - 0.5) * NOISE_VIGNETTE, 0.0, 1.0);

    float n = tileNoise(fragCoord / NOISE_SCALE + offset);
    vec3 tint = (iForegroundColor - iBackgroundColor) * n * NOISE_STRENGTH * vignette;
    color.rgb = clamp(color.rgb + tint, 0.0, 1.0);

    float grain = noiseHash(floor(fragCoord)) - 0.5;
    color.rgb = clamp(color.rgb + grain * NOISE_GRAIN, 0.0, 1.0);

    fragColor = color;
}
