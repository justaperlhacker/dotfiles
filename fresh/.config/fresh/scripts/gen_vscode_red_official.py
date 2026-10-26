#!/usr/bin/env python3
"""Generate the Fresh editor palette for VS Code's built-in "Red" theme.

Source of truth: the Red theme shipped with VS Code:
  /usr/share/code/resources/app/extensions/theme-red/themes/Red-color-theme.json

Every color VS Code defines is copied verbatim (8-digit alpha values are
flattened over the editor background). Colors VS Code leaves undefined get a
deterministic derivation, marked with `derived` comments in build().

Output:
  ~/.config/fresh/themes/vscode-red-official.json

Run:
  python3 ~/.config/fresh/scripts/gen_vscode_red_official.py

Then regenerate the downstream ports:
  python3 ~/.config/doom/scripts/gen_doom_themes.py
  python3 ~/.config/doom/scripts/gen_sublime_themes.py
"""

import json
import os

HOME = os.path.expanduser("~")
THEME = os.environ.get(
    "VSCODE_RED_THEME",
    "/usr/share/code/resources/app/extensions/theme-red/themes/"
    "Red-color-theme.json")
OUT = os.path.join(HOME, ".config", "fresh", "themes")


# ------------------------------------------------------------------ helpers
def to_rgb(value):
    h = value.lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def to_hex(rgb):
    return "#%02x%02x%02x" % tuple(max(0, min(255, round(c))) for c in rgb)


def rgb(value):
    return list(to_rgb(value))


def mix(a, b, t):
    ra, rb = to_rgb(a), to_rgb(b)
    return to_hex([ra[i] + (rb[i] - ra[i]) * t for i in range(3)])


def lighten(c, t):
    return mix(c, "#ffffff", t)


def flatten(value, bg):
    """Resolve #rrggbbaa (VS Code alpha) over bg to a solid color."""
    h = value.lstrip("#")
    if len(h) == 3:
        h = "".join(c * 2 for c in h)
    if len(h) == 8:
        r, g, b, a = (int(h[i:i + 2], 16) for i in range(0, 8, 2))
        return mix(bg, "#%02x%02x%02x" % (r, g, b), a / 255.0)
    return "#" + h[:6].lower()


def build(colors, tokens):
    bg = flatten(colors.get("editor.background", "#390000"), "#000000")

    def col(key, default):
        return flatten(colors.get(key, default), bg)

    fg = col("editor.foreground", "#f8f8f8")
    comment = tokens.get("comment", "#e7c0c0")
    keyword = tokens.get("keyword", "#f12727")
    string = tokens.get("string", "#cd8d8d")
    entity = tokens.get("entity", "#fec758")
    constant = tokens.get("constant", "#994646")
    support = tokens.get("support", "#9df39f")
    variable = tokens.get("variable", "#fb9a4b")
    support_fn = tokens.get("support.function", "#ffb454")
    escape = tokens.get("constant.character.escape", "#ffe862")
    css_prop = tokens.get("support.type.property-name.css", "#96dd3b")

    base0, base1, base2 = "#2a0000", "#330000", "#3d0000"
    base3, base4, base5 = "#490000", "#580000", "#6b0000"
    base6, base7 = "#8f5050", "#cf9090"

    return {
        "name": "vscode-red-official",
        "editor": {
            "bg": rgb(bg),
            "fg": rgb(fg),
            "cursor": rgb(col("editorCursor.foreground", "#970000")),
            # derived: VS Code defines no inactive cursor
            "inactive_cursor": rgb(base6),
            "selection_bg": rgb(col("editor.selectionBackground", "#750000")),
            "current_line_bg": rgb(
                col("editor.lineHighlightBackground", mix(bg, "#ff0000", 0.2))),
            "line_number_fg": rgb(
                col("editorLineNumber.foreground", base6)),
            "line_number_bg": rgb(bg),
            # derived: Red defines no diff colors
            "diff_add_bg": rgb(mix(bg, "#41a83e", 0.18)),
            "diff_remove_bg": rgb(mix(bg, "#ec9799", 0.18)),
            "diff_add_highlight_bg": rgb(mix(bg, "#41a83e", 0.30)),
            "diff_remove_highlight_bg": rgb(mix(bg, "#ec9799", 0.30)),
            "diff_modify_bg": rgb(mix(bg, escape, 0.18)),
            "diff_add_collision_fg": rgb(fg),
            "diff_remove_collision_fg": rgb(fg),
            "diff_modify_collision_fg": rgb(fg),
            # derived: Red defines no rulers/indent guides
            "ruler_bg": rgb(base2),
            "indentation_guide_fg": rgb(base2),
            "indent_rainbow_1": rgb(keyword),
            "indent_rainbow_2": rgb(entity),
            "indent_rainbow_3": rgb(support),
            "indent_rainbow_4": rgb(support_fn),
            "indent_rainbow_5": rgb(string),
            "indent_rainbow_6": rgb(variable),
            "whitespace_indicator_fg": rgb(
                col("editorWhitespace.foreground", "#c10000")),
            "whitespace_indicator_selected_fg": rgb(base7),
            "bracket_match_fg": rgb(
                col("editorLink.activeForeground", "#ffd0aa")),
            "bracket_rainbow_1": rgb(keyword),
            "bracket_rainbow_2": rgb(entity),
            "bracket_rainbow_3": rgb(support),
            "bracket_rainbow_4": rgb(support_fn),
            "bracket_rainbow_5": rgb(string),
            "bracket_rainbow_6": rgb(variable),
            "after_eof_bg": rgb(base1),
        },
        "ui": {
            "tab_active_fg": rgb(fg),
            "tab_active_bg": rgb(col("tab.activeBackground", "#490000")),
            "tab_inactive_fg": rgb(base7),
            "tab_inactive_bg": rgb(col("tab.inactiveBackground", "#300a0a")),
            "tab_separator_bg": rgb(
                col("editorGroupHeader.tabsBackground", "#330000")),
            "tab_close_hover_fg": rgb("#ff6262"),
            "tab_hover_bg": rgb(col("list.hoverBackground", "#800000")),
            "menu_bg": rgb(col("editorWidget.background", "#300000")),
            "menu_fg": rgb(fg),
            "menu_active_bg": rgb(
                col("list.activeSelectionBackground", "#880000")),
            "menu_active_fg": rgb(
                col("list.highlightForeground", "#ff4444")),
            "menu_dropdown_bg": rgb(
                col("editorWidget.background", "#300000")),
            "menu_dropdown_fg": rgb(fg),
            "menu_highlight_bg": rgb(col("list.hoverBackground", "#800000")),
            "menu_highlight_fg": rgb(fg),
            "menu_border_fg": rgb(col("input.background", "#580000")),
            "menu_separator_fg": rgb(base5),
            "menu_hover_bg": rgb(col("list.hoverBackground", "#800000")),
            "menu_hover_fg": rgb(fg),
            "menu_disabled_fg": rgb("#713636"),
            "menu_disabled_bg": rgb(col("editorWidget.background", "#300000")),
            "status_bar_fg": rgb("#ffffff"),
            "status_bar_bg": rgb(col("statusBar.background", "#700000")),
            "status_palette_fg": rgb(bg),
            "status_palette_bg": rgb(
                col("editorLink.activeForeground", "#ffd0aa")),
            "status_separator_fg": rgb(base1),
            "status_separator_bg": rgb(col("statusBar.background", "#700000")),
            "status_lsp_on_fg": rgb(bg),
            "status_lsp_on_bg": rgb("#41a83e"),
            "status_lsp_actionable_fg": rgb(bg),
            "status_lsp_actionable_bg": rgb(escape),
            "prompt_fg": rgb(fg),
            "prompt_bg": rgb(col("editorWidget.background", "#300000")),
            "prompt_selection_fg": rgb(fg),
            "prompt_selection_bg": rgb(col("input.background", "#580000")),
            "popup_border_fg": rgb(col("input.background", "#580000")),
            "popup_bg": rgb(col("editorWidget.background", "#300000")),
            "popup_selection_bg": rgb(col("input.background", "#580000")),
            "popup_selection_fg": rgb(fg),
            "popup_text_fg": rgb(fg),
            "text_input_selection_bg": rgb(
                col("editor.selectionBackground", "#750000")),
            "suggestion_bg": rgb(col("editorWidget.background", "#300000")),
            "suggestion_fg": rgb(base7),
            "suggestion_selected_bg": rgb(col("input.background", "#580000")),
            "help_bg": rgb(bg),
            "help_fg": rgb(fg),
            "help_key_fg": rgb(col("list.highlightForeground", "#ff4444")),
            "help_separator_fg": rgb(base7),
            "help_indicator_fg": rgb("#ff6262"),
            "help_indicator_bg": rgb(bg),
            "inline_code_bg": rgb(col("editorWidget.background", "#300000")),
            "split_separator_fg": rgb(col("input.background", "#580000")),
            "split_separator_hover_fg": rgb(
                flatten(colors.get("focusBorder", "#ff6666"), bg)),
            "scrollbar_track_fg": rgb(bg),
            "scrollbar_thumb_fg": rgb("#754e4e"),
            "scrollbar_track_hover_fg": rgb(base2),
            "scrollbar_thumb_hover_fg": rgb(base6),
            "compose_margin_bg": rgb(base1),
            "blame_header_fg": rgb(fg),
            "blame_header_bg": rgb(base4),
            "semantic_highlight_bg": rgb(base4),
            "tour_step_bg": rgb(base3),
            "terminal_bg": rgb(bg),
            "terminal_fg": rgb(fg),
            "status_warning_indicator_bg": rgb(escape),
            "status_warning_indicator_fg": rgb("#000000"),
            "status_error_indicator_bg": rgb("#ff6262"),
            "status_error_indicator_fg": rgb("#ffffff"),
            "status_warning_indicator_hover_bg": rgb(lighten(escape, 0.15)),
            "status_warning_indicator_hover_fg": rgb("#000000"),
            "status_error_indicator_hover_bg": rgb(lighten("#ff6262", 0.15)),
            "status_error_indicator_hover_fg": rgb("#ffffff"),
            "tab_drop_zone_bg": rgb(col("input.background", "#580000")),
            "tab_drop_zone_border": rgb("#cc3333"),
            "settings_selected_bg": rgb(col("input.background", "#580000")),
            "settings_selected_fg": rgb(fg),
            "file_status_added_fg": rgb("#41a83e"),
            "file_status_modified_fg": rgb(escape),
            "file_status_deleted_fg": rgb("#ff6262"),
            "file_status_renamed_fg": rgb(variable),
            "file_status_untracked_fg": rgb(base7),
            "file_status_conflicted_fg": rgb("#ff6262"),
        },
        "search": {
            "match_bg": rgb("#990000"),
            "match_fg": rgb(fg),
            "label_bg": rgb("#cc3333"),
            "label_fg": rgb("#ffffff"),
        },
        "diagnostic": {
            "error_fg": rgb("#ff6262"),
            "error_bg": rgb(mix(bg, "#ff6262", 0.25)),
            "warning_fg": rgb(escape),
            "warning_bg": rgb(mix(bg, escape, 0.25)),
            "info_fg": rgb(support_fn),
            "info_bg": rgb(mix(bg, support_fn, 0.20)),
            "hint_fg": rgb(support),
            "hint_bg": rgb(mix(bg, support, 0.20)),
        },
        "syntax": {
            "keyword": rgb(keyword),
            "string": rgb(string),
            "comment": {"color": rgb(comment), "modifier": ["italic"]},
            "function": rgb(entity),
            "type": rgb(entity),
            "variable": rgb(variable),
            "variable_builtin": rgb(support_fn),
            "constant": rgb(constant),
            "operator": rgb(fg),
            "punctuation_bracket": rgb(fg),
            "punctuation_delimiter": rgb(fg),
        },
    }


def main():
    with open(THEME) as fh:
        data = json.load(fh)

    tokens = {}
    for rule in data.get("tokenColors", []):
        fg = (rule.get("settings") or {}).get("foreground")
        scopes = rule.get("scope") or []
        if not fg:
            continue
        if isinstance(scopes, str):
            scopes = scopes.split(",")
        for scope in scopes:
            tokens.setdefault(scope.strip(),
                              flatten(fg, data["colors"]["editor.background"]))

    theme = build(data.get("colors", {}), tokens)
    os.makedirs(OUT, exist_ok=True)
    dest = os.path.join(OUT, theme["name"] + ".json")
    with open(dest, "w", encoding="utf-8") as fh:
        json.dump(theme, fh, indent=2)
        fh.write("\n")
    print("wrote", dest)


if __name__ == "__main__":
    main()
