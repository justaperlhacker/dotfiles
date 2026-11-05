// Cool-Retro-Term "Ghost Terminal" cursor ghost for Ghostty.
// Emulates the phosphor burn-in trail from cool-retro-term's burn_in.frag:
// the previous cursor and intermediate copies fade along the movement path.
// Ghostty shaders are stateless, so this uses only the previous/current
// cursor, not a real full-screen burn-in buffer.

const float GHOST_DURATION = 0.45;      // seconds, from burnIn 0.2
const float GHOST_COUNT = 12.0;         // max copies on a long jump
const float GHOST_SPACING_CELLS = 0.85; // spacing between copies
const float GHOST_PREV_ALPHA = 0.65;    // previous cursor ghost
const float GHOST_ALPHA = 0.5;          // intermediate ghosts
const float GHOST_FALLOFF = 1.0;        // older copies fade faster
const float GHOST_OPACITY = 0.8;
const float GHOST_GLOW = 2.0;           // pixels of phosphor glow
const float GHOST_CELL_ASPECT = 0.6;    // used for bar/underline spacing

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
    float dominant = (abs(move.x) / max(cell.x, 1.0) > abs(move.y) / max(cell.y, 1.0))
        ? cell.x
        : cell.y;
    float stepPx = dominant * GHOST_SPACING_CELLS;

    float timeFade = clamp(1.0 - t / GHOST_DURATION, 0.0, 1.0);
    float alpha = 0.0;

    // Previous cursor position: this is what remains after typing.
    alpha = max(alpha, GHOST_PREV_ALPHA * timeFade *
        ghostCoverage(fragCoord, oldPos, oldSize));

    // Intermediate copies along a long jump.
    for (int i = 1; i <= int(GHOST_COUNT); ++i) {
        float dist = float(i) * stepPx;
        if (dist >= moveDist) {
            break;
        }
        float frac = dist / max(moveDist, 1e-4);
        vec2 pos = mix(newPos, oldPos, frac);
        float age = pow(1.0 - frac, GHOST_FALLOFF);
        alpha = max(alpha, GHOST_ALPHA * age * timeFade *
            ghostCoverage(fragCoord, pos, newSize));
    }

    // Keep the live cursor clean.
    float currentSdf = ghostSdRect(fragCoord, newPos, newSize);
    alpha *= smoothstep(-1.0, 1.0, currentSdf);

    if (alpha <= 0.0) {
        return;
    }

    vec4 ghostColor = iCurrentCursorColor;
    fragColor.rgb = mix(fragColor.rgb, ghostColor.rgb, alpha * GHOST_OPACITY);
}
