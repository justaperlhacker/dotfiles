// Sliding horizontal CRT scanline for the Ghost Terminal look.
// No static raster lines; only the moving glow band.

const float SCANLINE_STRENGTH = 0.004; // line brightness
const float SCANLINE_SWEEP_TIME = 6.7; // seconds per pass (previous speed)
const float SCANLINE_INTERVAL = 9.0;   // total cycle including the pause
const float SCANLINE_WIDTH = 12.0;     // line half-width in pixels

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 color = texture(iChannel0, fragCoord / iResolution.xy);

    float cycle = fract(iTime / SCANLINE_INTERVAL);
    float sweepFraction = SCANLINE_SWEEP_TIME / SCANLINE_INTERVAL;
    if (cycle < sweepFraction) {
        float progress = cycle / sweepFraction;
        float bandY = (1.0 - progress) * iResolution.y;
        float d = (fragCoord.y - bandY) / SCANLINE_WIDTH;
        float band = exp(-d * d);
        color.rgb += band * SCANLINE_STRENGTH * vec3(1.0);
    }

    fragColor = clamp(color, 0.0, 1.0);
}
