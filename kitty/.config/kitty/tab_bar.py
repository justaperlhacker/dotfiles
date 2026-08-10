from kitty.fast_data_types import Screen
from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title
from kitty.utils import color_as_int

PADDING = 5

LEFT_GLYPH = '\ue0b0'
RIGHT_GLYPH = '\ue0b0'


def draw_tab(
    draw_data: DrawData, screen: Screen, tab: TabBarData,
    before: int, max_tab_length: int, index: int, is_last: bool,
    extra_data: ExtraData
) -> int:
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
