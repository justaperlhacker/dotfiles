// Konsole-style cursor animation for Ghostty.
// Source: konsole/src/terminalDisplay/TerminalPainter.cpp
//
// 200 ms OutCubic morph with shear/taper, matching Konsole's
// "Animation: Make the cursor animate smoothly" option. The style
// (block/bar/underline) is auto-detected from Ghostty.
//
// Ghostty shaders run after the frame is rendered, so the new cursor is
// already in iChannel0; the morph is masked under it.

const float KONSOLE_DURATION = 0.2;
const float KONSOLE_SHEAR_PER_PX = 0.015;
const float KONSOLE_SHEAR_MAX = 0.25;
const float KONSOLE_TAPER_PER_PX = 0.02;
const float KONSOLE_TAPER_MAX = 0.30;

// Block-only extra trail; 0 = exact Konsole morph.
const float KONSOLE_BLOCK_TRAIL_EXTEND = 0.9;
const float KONSOLE_IBEAM_TRAIL_EXTEND = 0.0;
const float KONSOLE_TRAIL_FADE = 0.75;

// Cell width / height, used for bar/underline cell reconstruction.
const float KONSOLE_CELL_ASPECT = 0.6;

float konsoleEaseOutCubic(float t) {
    float u = 1.0 - t;
    return 1.0 - u * u * u;
}

void konsoleQuadEdge(vec2 p, vec2 a, vec2 b, inout float minDistSq, inout float inside) {
    vec2 edge = b - a;
    vec2 pa = p - a;

    float t = clamp(dot(pa, edge) / dot(edge, edge), 0.0, 1.0);
    vec2 diff = pa - edge * t;
    minDistSq = min(minDistSq, dot(diff, diff));

    float cross = edge.x * pa.y - edge.y * pa.x;
    inside = min(inside, step(0.0, cross));
}

float konsoleSdQuad(vec2 p, vec2 v0, vec2 v1, vec2 v2, vec2 v3) {
    float minDistSq = 1e20;
    float inside = 1.0;

    konsoleQuadEdge(p, v0, v1, minDistSq, inside);
    konsoleQuadEdge(p, v1, v2, minDistSq, inside);
    konsoleQuadEdge(p, v2, v3, minDistSq, inside);
    konsoleQuadEdge(p, v3, v0, minDistSq, inside);

    float dist = sqrt(max(minDistSq, 0.0));
    return mix(dist, -dist, inside);
}

float konsoleSdRect(vec2 p, vec2 topLeft, vec2 size) {
    vec2 center = topLeft + vec2(size.x * 0.5, -size.y * 0.5);
    vec2 halfSize = size * 0.5;
    vec2 d = abs(p - center) - halfSize;
    return length(max(d, 0.0)) + min(max(d.x, d.y), 0.0);
}

float konsoleShapeAnchorX(vec2 pos, vec2 size, int style) {
    return (style == CURSORSTYLE_BAR)
        ? pos.x + (size.x + 1.0) * 0.5
        : pos.x;
}

vec4 konsoleCellRect(vec2 pos, vec2 size, int style) {
    if (style == CURSORSTYLE_BAR) {
        float cellLeft = pos.x + (size.x + 1.0) * 0.5;
        float cellHeight = size.y;
        float cellWidth = cellHeight * KONSOLE_CELL_ASPECT;
        return vec4(cellLeft, pos.y, cellWidth, cellHeight);
    }

    if (style == CURSORSTYLE_UNDERLINE) {
        float cellWidth = size.x;
        float cellHeight = cellWidth / KONSOLE_CELL_ASPECT;
        float cellTop = pos.y + (cellHeight - size.y);
        return vec4(pos.x, cellTop, cellWidth, cellHeight);
    }

    return vec4(pos, size);
}

void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    vec4 base = texture(iChannel0, fragCoord / iResolution.xy);
    fragColor = base;

    float progress = (iTime - iTimeCursorChange) / KONSOLE_DURATION;
    if (progress < 0.0 || progress >= 1.0) {
        return;
    }

    vec2 oldPos = iPreviousCursor.xy;
    vec2 oldSize = iPreviousCursor.zw;
    vec2 newPos = iCurrentCursor.xy;
    vec2 newSize = iCurrentCursor.zw;

    if (oldSize.x <= 0.0 || oldSize.y <= 0.0 || newSize.x <= 0.0 || newSize.y <= 0.0) {
        return;
    }

    // Konsole starts from the previous cell and ends at the current shape.
    vec4 oldCell = konsoleCellRect(oldPos, oldSize, iPreviousCursorStyle);
    vec4 newShape = vec4(newPos, newSize);

    float newAnchorX = konsoleShapeAnchorX(newPos, newSize, iCurrentCursorStyle);
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

    vec2 oldCenter = oldCell.xy + vec2(oldCell.z * 0.5, -oldCell.w * 0.5);
    vec2 newCenter = newShape.xy + vec2(newShape.z * 0.5, -newShape.w * 0.5);
    vec2 moveVec = newCenter - oldCenter;
    float moveDist = length(moveVec);
    vec2 moveDir = moveDist > 0.0 ? moveVec / moveDist : vec2(0.0);
    float extendPx = (moveDist > 0.0) ? min(oldCell.w * trailExtend, moveDist) : 0.0;

    if (extendPx > 0.0) {
        vec2 relTL = normalize(oldTL - oldCenter);
        vec2 relTR = normalize(oldTR - oldCenter);
        vec2 relBR = normalize(oldBR - oldCenter);
        vec2 relBL = normalize(oldBL - oldCenter);

        float wTL = 1.0 - smoothstep(-1.0, 1.0, dot(relTL, moveDir));
        float wTR = 1.0 - smoothstep(-1.0, 1.0, dot(relTR, moveDir));
        float wBR = 1.0 - smoothstep(-1.0, 1.0, dot(relBR, moveDir));
        float wBL = 1.0 - smoothstep(-1.0, 1.0, dot(relBL, moveDir));

        oldTL -= moveDir * extendPx * wTL;
        oldTR -= moveDir * extendPx * wTR;
        oldBR -= moveDir * extendPx * wBR;
        oldBL -= moveDir * extendPx * wBL;
    }

    float eased = konsoleEaseOutCubic(clamp(progress, 0.0, 1.0));

    vec2 bl = mix(oldBL, newBL, eased);
    vec2 br = mix(oldBR, newBR, eased);
    vec2 tr = mix(oldTR, newTR, eased);
    vec2 tl = mix(oldTL, newTL, eased);

    float sdf = konsoleSdQuad(fragCoord, bl, br, tr, tl);

    const float AA = 1.0;
    float alpha = 1.0 - smoothstep(-AA, AA, sdf);

    // Fade the extra tail.
    if (extendPx > 0.0 && KONSOLE_TRAIL_FADE > 0.0) {
        float fade = 1.0 - smoothstep(moveDist, moveDist + extendPx,
                                      distance(fragCoord, newCenter));
        alpha *= mix(1.0, fade, KONSOLE_TRAIL_FADE);
    }

    // Mask the current cursor rect for filled styles.
    bool filledCursor = iCurrentCursorStyle == CURSORSTYLE_BLOCK
                     || iCurrentCursorStyle == CURSORSTYLE_BAR
                     || iCurrentCursorStyle == CURSORSTYLE_UNDERLINE;
    if (filledCursor && iCursorVisible != 0) {
        float currentSdf = konsoleSdRect(fragCoord, newShape.xy, newShape.zw);
        alpha *= smoothstep(-AA, AA, currentSdf);
    }

    if (alpha <= 0.0) {
        return;
    }

    vec4 cursor = iCurrentCursorColor;
    fragColor.rgb = mix(fragColor.rgb, cursor.rgb, alpha * cursor.a);
}
