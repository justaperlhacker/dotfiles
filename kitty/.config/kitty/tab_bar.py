"""Full-width tab bar with backward-compatible styles.

Styles (set via TAB_STYLE below or KITTY_TAB_STYLE env var):
  flat              - GNOME-like flat blocks, equal width (default).
                      2 tabs -> 50/50, 3 tabs -> 33/33/33.
  powerline         - Legacy content-sized powerline (exact previous behavior).
                      Preserved so no previous capability is lost.
  powerline_stretch - Powerline glyphs but stretched to equal widths.

Switch without editing: KITTY_TAB_STYLE=powerline kitty
Reload after edit: ctrl+shift+F5 or `kitty @ load-config`
"""
import os

from kitty.fast_data_types import Screen, get_boss
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

# Change this to "powerline" to restore the old look, or use the env var.
TAB_STYLE = os.environ.get("KITTY_TAB_STYLE", "flat").lower().strip()

# Legacy powerline appearance (unchanged from previous config).
PADDING = 5
LEFT_GLYPH = '\ue0b0'
RIGHT_GLYPH = '\ue0b0'


def _tab_width(screen: Screen, index: int) -> int:
    # index is 1-based. Distribute remainder over first tabs so bar fills exactly.
    try:
        ntabs = len(get_boss().active_tab_manager.tabs) or 1
    except Exception:
        ntabs = 1
    base = screen.columns // max(1, ntabs)
    rem = screen.columns % max(1, ntabs)
    return base + (1 if index <= rem else 0)


def _draw_flat_tab(draw_data, screen, tab, before, index, is_last) -> int:
    width = max(1, _tab_width(screen, index))
    if width <= 3:
        screen.draw(' … '[:width].ljust(width))
        return screen.cursor.x
    screen.draw(' ')
    draw_title(draw_data, screen, tab, index, width - 2)
    extra = screen.cursor.x - before - width
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw('…')
    pad = before + width - screen.cursor.x
    if pad > 0:
        screen.draw(' ' * pad)
    if is_last:
        tail = screen.columns - screen.cursor.x
        if tail > 0:
            screen.draw(' ' * tail)
    return screen.cursor.x


def _draw_powerline_classic(draw_data, screen, tab, index, is_last) -> int:
    # Exact legacy behavior: content-sized, left-aligned, bar fill at end.
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    bar_bg = as_rgb(color_as_int(draw_data.default_bg))

    def fill_bar(width: int) -> None:
        if width > 0:
            screen.cursor.bg = bar_bg
            screen.cursor.fg = bar_bg
            screen.draw(' ' * width)

    fill_bar(1)

    screen.cursor.fg = bar_bg
    screen.cursor.bg = tab_bg
    screen.draw(LEFT_GLYPH)

    screen.cursor.bg = tab_bg
    screen.cursor.fg = tab_fg
    screen.cursor.bold = screen.cursor.italic = False
    screen.draw(' ' * PADDING)
    draw_title(draw_data, screen, tab, index)
    screen.draw(' ' * PADDING)

    screen.cursor.fg = tab_bg
    screen.cursor.bg = bar_bg
    screen.draw(RIGHT_GLYPH)

    fill_bar(1)

    if is_last:
        fill_bar(max(0, screen.columns - screen.cursor.x))

    return screen.cursor.x


def _draw_powerline_stretch(draw_data, screen, tab, before, index, is_last) -> int:
    # Powerline glyphs + equal widths: title area expands to fill the share.
    width = max(1, _tab_width(screen, index))
    tab_bg = screen.cursor.bg
    tab_fg = screen.cursor.fg
    bar_bg = as_rgb(color_as_int(draw_data.default_bg))
    overhead = 2 + 2 * PADDING  # 2 glyphs + padding both sides
    title_area = max(1, width - overhead)

    screen.cursor.fg = bar_bg
    screen.cursor.bg = tab_bg
    screen.draw(LEFT_GLYPH)

    screen.cursor.bg = tab_bg
    screen.cursor.fg = tab_fg
    screen.cursor.bold = screen.cursor.italic = False
    screen.draw(' ' * PADDING)
    title_before = screen.cursor.x
    draw_title(draw_data, screen, tab, index, title_area)
    extra = screen.cursor.x - title_before - title_area
    if extra > 0:
        screen.cursor.x -= extra + 1
        screen.draw('…')
    pad = title_before + title_area - screen.cursor.x
    if pad > 0:
        screen.draw(' ' * pad)
    screen.draw(' ' * PADDING)

    screen.cursor.fg = tab_bg
    screen.cursor.bg = bar_bg
    screen.draw(RIGHT_GLYPH)

    if is_last:
        tail = screen.columns - screen.cursor.x
        if tail > 0:
            screen.cursor.bg = bar_bg
            screen.cursor.fg = bar_bg
            screen.draw(' ' * tail)

    return screen.cursor.x


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_tab_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
    style = TAB_STYLE if TAB_STYLE in ("flat", "powerline", "powerline_stretch") else "flat"

    # Layout pass: stretched styles report fixed width so kitty allocates
    # correctly; legacy powerline falls through and draws so kitty can
    # measure its natural content-sized width.
    if extra_data.for_layout and style != "powerline":
        screen.cursor.x += max(1, _tab_width(screen, index))
        return screen.cursor.x

    if style == "powerline":
        return _draw_powerline_classic(draw_data, screen, tab, index, is_last)
    if style == "powerline_stretch":
        return _draw_powerline_stretch(draw_data, screen, tab, before, index, is_last)
    return _draw_flat_tab(draw_data, screen, tab, before, index, is_last)
