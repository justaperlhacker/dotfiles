// Hybrid cursor animation: Konsole morph for small moves, kitty trail for
// large jumps. Blends by distance in cursor cells.
//
// Sources: konsole/src/terminalDisplay/TerminalPainter.cpp
//          kitty/kitty/cursor_trail.c, kitty/kitty/shaders/trail.slang
//
// Ghostty shaders are stateless: rapid moves restart from the previous
// cursor rect; kitty's history and trigger delay are unavailable.

// Konsole
const float KONSOLE_DURATION = 0.2;
const float KONSOLE_SHEAR_PER_PX = 0.015;
const float KONSOLE_SHEAR_MAX = 0.25;
const float KONSOLE_TAPER_PER_PX = 0.02;
const float KONSOLE_TAPER_MAX = 0.30;

// Block-only extra trail; 0 = exact Konsole morph.
const float KONSOLE_BLOCK_TRAIL_EXTEND = 0.9;
const float KONSOLE_IBEAM_TRAIL_EXTEND = 0.0;
const float KONSOLE_TRAIL_FADE = 0.75;

// Kitty; matches this repo's kitty.conf.
const float KITTY_TRAIL_DECAY_FAST = 0.2;
const float KITTY_TRAIL_DECAY_SLOW = 0.6;
const float KITTY_TRAIL_OPACITY = 1.0;

// Cell width / height, used for distance and cell reconstruction.
const float HYBRID_CELL_ASPECT = 0.6;

// Blend thresholds in cells: <=small is Konsole, >=large is kitty.
const float HYBRID_SMALL_CELLS = 1.5;
const float HYBRID_LARGE_CELLS = 3.5;

float hybridEaseOutCubic(float t) {
    float u = 1.0 - t;
    return 1.0 - u * u * u;
}

float hybridKittyDecay(float t, float decay) {
    return exp2(-10.0 * t / max(decay, 1e-4));
}

void hybridQuadEdge(vec2 p, vec2 a, vec2 b, inout float minDistSq, inout float inside) {
    vec2 edge = b - a;
    vec2 pa = p - a;

    float t = clamp(dot(pa, edge) / dot(edge, edge), 0.0, 1.0);
    vec2 diff = pa - edge * t;
    minDistSq = min(minDistSq, dot(diff, diff));

    float cross = edge.x * pa.y - edge.y * pa.x;
    inside = min(inside, step(0.0, cross));
}

float hybridSdQuad(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float minDistSq = 1e20;
    float inside = 1.0;

    hybridQuadEdge(p, v0, v1, minDistSq, inside);
    hybridQuadEdge(p, v1, v2, minDistSq, inside);
    hybridQuadEdge(p, v2, v3, minDistSq, inside);
    hybridQuadEdge(p, v3, v0, minDistSq, inside);

    float dist = sqrt(max(minDistSq, 0.0));
    return mix(dist, -dist, inside);
}

float hybridSdRect(vec2 p, vec2 topLeft, vec2 size) {
    vec2 center = topLeft + vec2(size.x * 0.5, -size.y * 0.5);
    vec2 halfSize = size * 0.5;
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float hybridShapeAnchorX(vec2 pos, vec2 size, int style) {
    return (style == CURSORSTYLE_BAR)
        ? pos.x + (size.x + 1.0) * 0.5
        : pos.x;
}

vec4 hybridCellRect(vec2 pos, vec2 size, int style) {
    if (style == CURSORSTYLE_BAR) {
        float cellLeft = pos.x + (size.x + 1.0) * 0.5;
        float cellHeight = size.y;
        float cellWidth = cellHeight * HYBRID_CELL_ASPECT;
        return vec4(cellLeft, pos.y, cellWidth, cellHeight);
    }

    if (style == CURSORSTYLE_UNDERLINE) {
        float cellWidth = size.x;
        float cellHeight = cellWidth / HYBRID_CELL_ASPECT;
        float cellTop = pos.y + (cellHeight - size.y);
        return vec4(pos.x, cellTop, cellWidth, cellHeight);
    }

    return vec4(pos, size);
}

vec2 hybridCellSize(vec2 size, int style) {
    if (style == CURSORSTYLE_BAR) {
        return vec2(size.y * HYBRID_CELL_ASPECT, size.y);
    }
    if (style == CURSORSTYLE_UNDERLINE) {
        return vec2(size.x, size.x / HYBRID_CELL_ASPECT);
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

    float t = iTime - iTimeCursorChange;
    if (t < 0.0) {
        return;
    }

    // Blend factor.
    vec2 cell = hybridCellSize(newSize, iCurrentCursorStyle);
    vec2 oldCenter = oldPos + vec2(oldSize.x * 0.5, -oldSize.y * 0.5);
    vec2 newCenter = newPos + vec2(newSize.x * 0.5, -newSize.y * 0.5);
    vec2 movePx = newCenter - oldCenter;
    float moveCells = max(
        abs(movePx.x) / max(cell.x, 1.0),
        abs(movePx.y) / max(cell.y, 1.0)
    );
    float blend = smoothstep(HYBRID_SMALL_CELLS, HYBRID_LARGE_CELLS, moveCells);

    // Konsole corners.
    vec4 oldCell = hybridCellRect(oldPos, oldSize, iPreviousCursorStyle);
    vec4 newShape = vec4(newPos, newSize);

    float newAnchorX = hybridShapeAnchorX(newPos, newSize, iCurrentCursorStyle);
    vec2 delta = vec2(oldCell.x - newAnchorX, newShape.y - oldCell.y);

    float shear = clamp(-delta.x * KONSOLE_SHEAR_PER_PX, -KONSOLE_SHEAR_MAX, KONSOLE_SHEAR_MAX);
    float taper = clamp(delta.y * KONSOLE_TAPER_PER_PX, -KONSOLE_TAPER_MAX, KONSOLE_TAPER_MAX);

    float dx = -shear * oldCell.w;
    float topReduction = (taper < 0.0) ? (oldCell.z * -taper) : 0.0;
    float bottomReduction = (taper > 0.0) ? (oldCell.z * taper) : 0.0;

    vec2 oldTL = oldCell.xy + vec2(dx + topReduction, 0.0);
    vec2 oldTR = oldCell.xy + vec2(oldCell.z + dx - topReduction, 0.0);
    vec2 oldBR = oldCell.xy + vec2(oldCell.z - bottomReduction, -oldCell.w);
    vec2 oldBL = oldCell.xy + vec2(bottomReduction, -oldCell.w);

    vec2 newTL = newShape.xy;
    vec2 newTR = newShape.xy + vec2(newShape.z, 0.0);
    vec2 newBR = newShape.xy + vec2(newShape.z, -newShape.w);
    vec2 newBL = newShape.xy + vec2(0.0, -newShape.w);

    // Konsole block trail extension.
    float trailExtend = (iCurrentCursorStyle == CURSORSTYLE_BLOCK)
        ? KONSOLE_BLOCK_TRAIL_EXTEND
        : KONSOLE_IBEAM_TRAIL_EXTEND;

    vec2 konsoleOldCenter = oldCell.xy + vec2(oldCell.z * 0.5, -oldCell.w * 0.5);
    vec2 konsoleNewCenter = newShape.xy + vec2(newShape.z * 0.5, -newShape.w * 0.5);
    vec2 konsoleMove = konsoleNewCenter - konsoleOldCenter;
    float konsoleMoveDist = length(konsoleMove);
    vec2 konsoleMoveDir = konsoleMoveDist > 0.0 ? konsoleMove / konsoleMoveDist : vec2(0.0);
    float extendPx = (konsoleMoveDist > 0.0)
        ? min(oldCell.w * trailExtend, konsoleMoveDist)
        : 0.0;

    if (extendPx > 0.0) {
        vec2 relTL = normalize(oldTL - konsoleOldCenter);
        vec2 relTR = normalize(oldTR - konsoleOldCenter);
        vec2 relBR = normalize(oldBR - konsoleOldCenter);
        vec2 relBL = normalize(oldBL - konsoleOldCenter);

        float wTL = 1.0 - smoothstep(-1.0, 1.0, dot(relTL, konsoleMoveDir));
        float wTR = 1.0 - smoothstep(-1.0, 1.0, dot(relTR, konsoleMoveDir));
        float wBR = 1.0 - smoothstep(-1.0, 1.0, dot(relBR, konsoleMoveDir));
        float wBL = 1.0 - smoothstep(-1.0, 1.0, dot(relBL, konsoleMoveDir));

        oldTL -= konsoleMoveDir * extendPx * wTL;
        oldTR -= konsoleMoveDir * extendPx * wTR;
        oldBR -= konsoleMoveDir * extendPx * wBR;
        oldBL -= konsoleMoveDir * extendPx * wBL;
    }

    float konsoleEased = hybridEaseOutCubic(clamp(t / KONSOLE_DURATION, 0.0, 1.0));

    vec2 konsoleTL = mix(oldTL, newTL, konsoleEased);
    vec2 konsoleTR = mix(oldTR, newTR, konsoleEased);
    vec2 konsoleBR = mix(oldBR, newBR, konsoleEased);
    vec2 konsoleBL = mix(oldBL, newBL, konsoleEased);

    // Kitty corners (TR, BR, BL, TL).
    vec2 kittyStartTR = oldPos + vec2(oldSize.x, 0.0);
    vec2 kittyStartBR = oldPos + vec2(oldSize.x, -oldSize.y);
    vec2 kittyStartBL = oldPos + vec2(0.0, -oldSize.y);
    vec2 kittyStartTL = oldPos;

    vec2 kittyTargetTR = newTR;
    vec2 kittyTargetBR = newBR;
    vec2 kittyTargetBL = newBL;
    vec2 kittyTargetTL = newTL;

    vec2 kittyStart[4] = vec2[4](kittyStartTR, kittyStartBR, kittyStartBL, kittyStartTL);
    vec2 kittyTarget[4] = vec2[4](kittyTargetTR, kittyTargetBR, kittyTargetBL, kittyTargetTL);

    float cursorDiag2 = max(length(newSize) * 0.5, 1e-4);
    float dots[4];
    float minDot = 1e20;
    float maxDot = -1e20;
    for (int i = 0; i < 4; ++i) {
        vec2 d = kittyTarget[i] - kittyStart[i];
        float len = length(d);
        if (len < 1e-6) {
            dots[i] = 0.0;
        } else {
            dots[i] = dot(d, kittyTarget[i] - newCenter) / cursorDiag2 / len;
        }
        minDot = min(minDot, dots[i]);
        maxDot = max(maxDot, dots[i]);
    }

    vec2 kittyCorners[4];
    for (int i = 0; i < 4; ++i) {
        vec2 d = kittyTarget[i] - kittyStart[i];
        if (length(d) < 1e-6) {
            kittyCorners[i] = kittyTarget[i];
            continue;
        }

        float decay = (maxDot - minDot < 1e-6)
            ? KITTY_TRAIL_DECAY_SLOW
            : KITTY_TRAIL_DECAY_SLOW +
              (KITTY_TRAIL_DECAY_FAST - KITTY_TRAIL_DECAY_SLOW) *
              (dots[i] - minDot) / (maxDot - minDot);

        kittyCorners[i] = kittyTarget[i] +
            (kittyStart[i] - kittyTarget[i]) * hybridKittyDecay(t, decay);
    }

    vec2 konsoleCorners[4] = vec2[4](konsoleTR, konsoleBR, konsoleBL, konsoleTL);

    vec2 corners[4];
    for (int i = 0; i < 4; ++i) {
        corners[i] = mix(konsoleCorners[i], kittyCorners[i], blend);
    }

    // Kitty stops within half a cell. Konsole must keep going for its full
    // duration, otherwise one-cell typing looks much faster than Konsole.
    float dxThreshold = cell.x * 0.5;
    float dyThreshold = cell.y * 0.5;
    bool kittyNeedsRender = false;
    for (int i = 0; i < 4; ++i) {
        if (abs(kittyTarget[i].x - corners[i].x) >= dxThreshold ||
            abs(kittyTarget[i].y - corners[i].y) >= dyThreshold) {
            kittyNeedsRender = true;
            break;
        }
    }
    bool konsoleNeedsRender = t < KONSOLE_DURATION;
    if (!kittyNeedsRender && !(blend < 1.0 && konsoleNeedsRender)) {
        return;
    }

    float opacity = mix(iCurrentCursorColor.a, KITTY_TRAIL_OPACITY, blend);
    if (opacity <= 0.0) {
        return;
    }

    float sdf = hybridSdQuad(fragCoord, corners[3], corners[2], corners[1], corners[0]);

    const float AA = 1.0;
    float alpha = 1.0 - smoothstep(-AA, AA, sdf);

    // Fade only the Konsole extension tail.
    if (extendPx > 0.0 && KONSOLE_TRAIL_FADE > 0.0) {
        float fade = 1.0 - smoothstep(konsoleMoveDist, konsoleMoveDist + extendPx,
                                      distance(fragCoord, konsoleNewCenter));
        alpha *= mix(1.0, fade, (1.0 - blend) * KONSOLE_TRAIL_FADE);
    }

    // Mask the current cursor rect.
    float currentSdf = hybridSdRect(fragCoord, newPos, newSize);
    alpha *= smoothstep(-AA, AA, currentSdf);

    if (alpha <= 0.0) {
        return;
    }

    vec4 trailColor = iCurrentCursorColor;
    fragColor.rgb = mix(fragColor.rgb, trailColor.rgb, alpha * opacity);
}
