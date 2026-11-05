// Kitty's built-in cursor trail, ported to a Ghostty shader.
// Sources: kitty/kitty/cursor_trail.c, kitty/kitty/shaders/trail.slang
//
// Each cursor corner eases exponentially toward its target. Leading
// corners use the fast decay, trailing corners the slow decay.
// Ghostty shaders are stateless: rapid moves restart from the previous
// cursor rect; kitty's history and trigger delay are unavailable.

// Matches this repo's kitty.conf: cursor_trail_decay 0.2 0.6.
const float KITTY_TRAIL_DECAY_FAST = 0.2;
const float KITTY_TRAIL_DECAY_SLOW = 0.6;

// Threshold 1 skips one-cell moves; 0 animates every move.
const float KITTY_TRAIL_START_THRESHOLD_CELLS = 1.0;

// Cell width / height, used for bar/underline threshold math.
const float KITTY_CELL_ASPECT = 0.6;

const float KITTY_TRAIL_OPACITY = 1.0;

float kittyEaseCorner(float t, float decay) {
    return exp2(-10.0 * t / max(decay, 1e-4));
}

void kittyQuadEdge(vec2 p, vec2 a, vec2 b, inout float minDistSq, inout float inside) {
    vec2 edge = b - a;
    vec2 pa = p - a;

    float t = clamp(dot(pa, edge) / dot(edge, edge), 0.0, 1.0);
    vec2 diff = pa - edge * t;
    minDistSq = min(minDistSq, dot(diff, diff));

    float cross = edge.x * pa.y - edge.y * pa.x;
    inside = min(inside, step(0.0, cross));
}

float kittySdQuad(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float minDistSq = 1e20;
    float inside = 1.0;

    kittyQuadEdge(p, v0, v1, minDistSq, inside);
    kittyQuadEdge(p, v1, v2, minDistSq, inside);
    kittyQuadEdge(p, v2, v3, minDistSq, inside);
    kittyQuadEdge(p, v3, v0, minDistSq, inside);

    float dist = sqrt(max(minDistSq, 0.0));
    return mix(dist, -dist, inside);
}

float kittySdRect(vec2 p, vec2 topLeft, vec2 size) {
    vec2 center = topLeft + vec2(size.x * 0.5, -size.y * 0.5);
    vec2 halfSize = size * 0.5;
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

vec2 kittyCellSize(vec2 size, int style) {
    if (style == CURSORSTYLE_BAR) {
        return vec2(size.y * KITTY_CELL_ASPECT, size.y);
    }
    if (style == CURSORSTYLE_UNDERLINE) {
        return vec2(size.x, size.x / KITTY_CELL_ASPECT);
    }
    return size;
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = base;

    vec2 oldPos = iPreviousCursor.xy;
    vec2 oldSize = iPreviousCursor.zw;
    vec2 newPos = iCurrentCursor.xy;
    vec2 newSize = iCurrentCursor.zw;

    if (oldSize.x <= 0.0 || oldSize.y <= 0.0 || newSize.x <= 0.0 || newSize.y <= 0.0) {
        return;
    }

    // Corner order: TR, BR, BL, TL.
    vec2 oldTR = oldPos + vec2(oldSize.x, 0.0);
    vec2 oldBR = oldPos + vec2(oldSize.x, -oldSize.y);
    vec2 oldBL = oldPos + vec2(0.0, -oldSize.y);
    vec2 oldTL = oldPos;

    vec2 newTR = newPos + vec2(newSize.x, 0.0);
    vec2 newBR = newPos + vec2(newSize.x, -newSize.y);
    vec2 newBL = newPos + vec2(0.0, -newSize.y);
    vec2 newTL = newPos;

    vec2 start[4] = vec2[4](oldTR, oldBR, oldBL, oldTL);
    vec2 target[4] = vec2[4](newTR, newBR, newBL, newTL);

    // Start threshold in cells.
    vec2 cell = kittyCellSize(newSize, iCurrentCursorStyle);
    float dxCells = abs(round((oldTR.x - newTR.x) / max(cell.x, 1.0)));
    float dyCells = abs(round((oldTR.y - newTR.y) / max(cell.y, 1.0)));
    if (dxCells <= KITTY_TRAIL_START_THRESHOLD_CELLS &&
        dyCells <= KITTY_TRAIL_START_THRESHOLD_CELLS) {
        return;
    }

    float t = iTime - iTimeCursorChange;
    if (t < 0.0) {
        return;
    }

    // Per-corner decay.
    vec2 cursorCenter = newPos + vec2(newSize.x * 0.5, -newSize.y * 0.5);
    float cursorDiag2 = max(length(newSize) * 0.5, 1e-4);

    float dots[4];
    float minDot = 1e20;
    float maxDot = -1e20;
    for (int i = 0; i < 4; ++i) {
        vec2 d = target[i] - start[i];
        float len = length(d);
        if (len < 1e-6) {
            dots[i] = 0.0;
        } else {
            dots[i] = dot(d, target[i] - cursorCenter) / cursorDiag2 / len;
        }
        minDot = min(minDot, dots[i]);
        maxDot = max(maxDot, dots[i]);
    }

    vec2 corners[4];
    for (int i = 0; i < 4; ++i) {
        vec2 d = target[i] - start[i];
        if (length(d) < 1e-6) {
            corners[i] = target[i];
            continue;
        }

        float decay = (maxDot - minDot < 1e-6)
            ? KITTY_TRAIL_DECAY_SLOW
            : KITTY_TRAIL_DECAY_SLOW +
              (KITTY_TRAIL_DECAY_FAST - KITTY_TRAIL_DECAY_SLOW) *
              (dots[i] - minDot) / (maxDot - minDot);

        corners[i] = target[i] + (start[i] - target[i]) * kittyEaseCorner(t, decay);
    }

    // Stop within half a cell of the target.
    float dxThreshold = cell.x * 0.5;
    float dyThreshold = cell.y * 0.5;
    bool needsRender = false;
    for (int i = 0; i < 4; ++i) {
        if (abs(target[i].x - corners[i].x) >= dxThreshold ||
            abs(target[i].y - corners[i].y) >= dyThreshold) {
            needsRender = true;
            break;
        }
    }
    if (!needsRender) {
        return;
    }

    float opacity = (iCursorVisible != 0) ? KITTY_TRAIL_OPACITY : 0.0;
    if (opacity <= 0.0) {
        return;
    }

    // Quad is clockwise; SDF wants counter-clockwise.
    float sdf = kittySdQuad(fragCoord, corners[3], corners[2], corners[1], corners[0]);

    const float AA = 1.0;
    float alpha = 1.0 - smoothstep(-AA, AA, sdf);

    // Mask the current cursor rect.
    float cursorSdf = kittySdRect(fragCoord, newPos, newSize);
    alpha *= smoothstep(-AA, AA, cursorSdf);

    if (alpha <= 0.0) {
        return;
    }

    vec4 trailColor = iCurrentCursorColor;
    fragColor.rgb = mix(fragColor.rgb, trailColor.rgb, alpha * opacity);
}
