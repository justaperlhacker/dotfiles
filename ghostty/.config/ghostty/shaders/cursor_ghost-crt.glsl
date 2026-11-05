// Cool-Retro-Term "Ghost Terminal" cursor effect for Ghostty.
// Approximates the phosphor burn-in from cool-retro-term's burn_in.frag
// with a fading previous-cursor ghost plus a banded trail along the move.
// Ghostty shaders are stateless, so this is cursor-only, not full-screen
// burn-in.

const float GHOST_DURATION = 0.525;      // ghost persistence (25% faster than 0.7)
const float GHOST_PREV_ALPHA = 0.55;     // previous cursor ghost
const float GHOST_TRAIL_ALPHA = 0.45;    // trailing phosphor
const float GHOST_FALLOFF = 1.4;         // fade toward the old position
const float GHOST_SPACING_CELLS = 0.9;   // repeating band spacing
const float GHOST_BAND_POWER = 1.0;      // >1 = tighter ghost bands
const float GHOST_BAND_AMOUNT = 0.35;     // 0 = smooth streak, 1 = full bands
const float GHOST_OPACITY = 0.85;
const float GHOST_GLOW = 2.0;            // pixels of phosphor glow
const float GHOST_CELL_ASPECT = 0.6;     // for bar/underline spacing

// Extra ghosts behind the previous cursor, for a longer typing trail.
const float GHOST_EXTRA_COUNT = 1.0;
const float GHOST_EXTRA_ALPHA = 0.50;
const float GHOST_EXTRA_FALLOFF = 0.8;
const float GHOST_EXTRA_SPACING = 1.0;   // cells between extra ghosts
const float GHOST_EXTRA_MAX_CELLS = 2.5; // only extend the trail for small moves
const float GHOST_EXTRA_MIN_TEXT = 0.04; // skip ghosts over empty cells

// Make ghosts darker on light backgrounds. 0 = off, 1 = full.
const float GHOST_LIGHT_BOOST = 1.0;
const float GHOST_LIGHT_POWER = 0.5;     // lower = darker
const float GHOST_LIGHT_DARKEN = 0.55;   // ghost color multiplier on light bg

float ghostSdRect(vec2 p, vec2 topLeft, vec2 size) {
    vec2 center = topLeft + vec2(size.x * 0.5, -size.y * 0.5);
    vec2 halfSize = size * 0.5;
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 ghostCellSize(vec2 size, int style) {
    if (style == CURSORSTYLE_BAR) {
        return vec2(size.y * GHOST_CELL_ASPECT, size.y);
    }
    if (style == CURSORSTYLE_UNDERLINE) {
        return vec2(size.x, size.x / GHOST_CELL_ASPECT);
    }
    return size;
}

float ghostCoverage(vec2 p, vec2 pos, vec2 size) {
    float sdf = ghostSdRect(p, pos, size);
    float core = 1.0 - smoothstep(-1.0, 1.0, sdf);
    float glow = 1.0 - smoothstep(0.0, GHOST_GLOW, sdf);
    return max(core, glow * 0.35);
}

float ghostCellTextness(vec2 center, vec2 cell) {
    vec2 uv = center / iResolution.xy;
    vec2 dx = vec2(cell.x * 0.25, 0.0) / iResolution.xy;
    vec2 dy = vec2(0.0, cell.y * 0.25) / iResolution.xy;
    float d = distance(texture(iChannel0, uv).rgb, iBackgroundColor);
    d = max(d, distance(texture(iChannel0, uv + dx).rgb, iBackgroundColor));
    d = max(d, distance(texture(iChannel0, uv - dx).rgb, iBackgroundColor));
    d = max(d, distance(texture(iChannel0, uv + dy).rgb, iBackgroundColor));
    d = max(d, distance(texture(iChannel0, uv - dy).rgb, iBackgroundColor));
    return d;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = base;

    float t = iTime - iTimeCursorChange;
    if (t < 0.0 || t >= GHOST_DURATION) {
        return;
    }

    vec2 oldPos = iPreviousCursor.xy;
    vec2 oldSize = iPreviousCursor.zw;
    vec2 newPos = iCurrentCursor.xy;
    vec2 newSize = iCurrentCursor.zw;

    if (oldSize.x <= 0.0 || oldSize.y <= 0.0 || newSize.x <= 0.0 || newSize.y <= 0.0) {
        return;
    }

    vec2 oldCenter = oldPos + vec2(oldSize.x * 0.5, -oldSize.y * 0.5);
    vec2 newCenter = newPos + vec2(newSize.x * 0.5, -newSize.y * 0.5);
    vec2 move = newCenter - oldCenter;
    float moveDist = length(move);
    vec2 dir = moveDist > 0.0 ? move / moveDist : vec2(0.0);

    vec2 cell = ghostCellSize(newSize, iCurrentCursorStyle);
    float moveCells = max(abs(move.x) / max(cell.x, 1.0),
                          abs(move.y) / max(cell.y, 1.0));

    float timeFade = clamp(1.0 - t / GHOST_DURATION, 0.0, 1.0);
    // On long jumps the old position is the oldest part of the streak, so
    // dim its ghost; the trail should get brighter toward the new cursor.
    float prevFade = 1.0 - 0.85 * smoothstep(2.5, 8.0, moveCells);
    float alpha = GHOST_PREV_ALPHA * prevFade * timeFade *
        ghostCoverage(fragCoord, oldPos, oldSize);

    // Extra ghosts only trail in the normal typing directions: right or down.
    // This keeps backspace and up/left moves from growing ghosts on the
    // side the cursor never travelled from.
    bool forwardMove = (abs(move.x) >= abs(move.y))
        ? (move.x > 0.0)
        : (move.y < 0.0);

    if (moveDist > 0.0) {
        float dominant = (abs(move.x) / max(cell.x, 1.0) > abs(move.y) / max(cell.y, 1.0))
            ? cell.x
            : cell.y;
        float stepPx = max(dominant * GHOST_SPACING_CELLS, 1.0);

        float s = dot(fragCoord - oldCenter, dir) / moveDist;
        if (s > 0.0 && s < 1.0) {
            float age = 1.0 - s;
            vec2 pos = mix(newPos, oldPos, age);
            float bandPhase = fract((s * moveDist) / stepPx);
            float band = pow(0.5 + 0.5 * cos(bandPhase * 6.2831853), GHOST_BAND_POWER);
            band = mix(1.0, band, GHOST_BAND_AMOUNT);
            // Fresh near the new cursor, fading toward the old position.
            alpha = max(alpha, GHOST_TRAIL_ALPHA * pow(s, GHOST_FALLOFF) *
                timeFade * band * ghostCoverage(fragCoord, pos, newSize));
        }

        // Extra ghosts only for small moves, so HOME/END jumps don't grow
        // ghosts on the side the cursor never travelled from.
        if (moveCells <= GHOST_EXTRA_MAX_CELLS && forwardMove) {
            vec2 halfSize = vec2(newSize.x * 0.5, -newSize.y * 0.5);
            for (int i = 1; i <= int(GHOST_EXTRA_COUNT); ++i) {
                float dist = float(i) * stepPx * GHOST_EXTRA_SPACING;
                vec2 ghostCenter = oldCenter - dir * dist;
                if (ghostCellTextness(ghostCenter, cell) < GHOST_EXTRA_MIN_TEXT) {
                    continue;
                }
                vec2 pos = ghostCenter - halfSize;
                float fade = pow(1.0 - float(i) / (GHOST_EXTRA_COUNT + 1.0),
                                 GHOST_EXTRA_FALLOFF);
                alpha = max(alpha, GHOST_EXTRA_ALPHA * fade * timeFade *
                    ghostCoverage(fragCoord, pos, newSize));
            }
        }
    }

    // Keep the live cursor clean.
    float currentSdf = ghostSdRect(fragCoord, newPos, newSize);
    alpha *= smoothstep(-1.0, 1.0, currentSdf);

    if (alpha <= 0.0) {
        return;
    }

    // Stronger and darker on light backgrounds.
    float bgLum = dot(iBackgroundColor, vec3(0.299, 0.587, 0.114));
    float lightBg = smoothstep(0.35, 0.75, bgLum);
    alpha = mix(alpha, pow(alpha, GHOST_LIGHT_POWER), lightBg * GHOST_LIGHT_BOOST);

    vec3 ghostRgb = mix(iCurrentCursorColor.rgb,
                        iCurrentCursorColor.rgb * GHOST_LIGHT_DARKEN,
                        lightBg);
    fragColor.rgb = mix(fragColor.rgb, ghostRgb, alpha * GHOST_OPACITY);
}
