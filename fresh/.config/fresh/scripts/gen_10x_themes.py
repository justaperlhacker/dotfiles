#!/usr/bin/env python3
"""Generate Fresh editor themes from the 10x Editor color schemes.

Palettes are read from the shared Kakoune theme family source:
  ~/Projects/kakoune-themes/palettes/10x/*.10x_settings

Output:
  ~/.config/fresh/themes/10x-<slug>.json

Run:
  python3 ~/.config/fresh/scripts/gen_10x_themes.py
"""

import json
import os
import sys

HOME = os.path.expanduser("~")
KAK_SCRIPTS = os.path.join(HOME, "Projects", "kakoune-themes", "scripts")
if KAK_SCRIPTS not in sys.path:
    sys.path.insert(0, KAK_SCRIPTS)
import tenx

OUT = os.path.join(HOME, ".config", "fresh", "themes")


def rgb(v):
    return list(tenx.to_rgb(v))


def build(name, data):
    v, meta = tenx.normalize(name, data)

    return {
        "name": "10x-" + meta["slug"],
        "editor": {
            "bg": rgb(v["bg"]),
            "fg": rgb(v["fg"]),
            "cursor": rgb(v["cursor"]),
            "inactive_cursor": rgb(v["base6"]),
            "selection_bg": rgb(v["selection"]),
            "current_line_bg": rgb(v["cur-line"]),
            "line_number_fg": rgb(v["line-nr"]),
            "line_number_bg": rgb(v["line-nr-bg"]),
            "diff_add_bg": rgb(v["diff-add-bg"]),
            "diff_remove_bg": rgb(v["diff-remove-bg"]),
            "diff_add_highlight_bg": rgb(
                tenx.mix(v["bg"], v["success"], 0.28)),
            "diff_remove_highlight_bg": rgb(
                tenx.mix(v["bg"], v["error"], 0.28)),
            "diff_modify_bg": rgb(v["diff-modify-bg"]),
            "diff_add_collision_fg": rgb(v["fg"]),
            "diff_remove_collision_fg": rgb(v["fg"]),
            "diff_modify_collision_fg": rgb(v["fg"]),
            "ruler_bg": rgb(v["base2"]),
            "indentation_guide_fg": rgb(v["base3"]),
            "indent_rainbow_1": rgb(v["rain1"]),
            "indent_rainbow_2": rgb(v["rain2"]),
            "indent_rainbow_3": rgb(v["rain3"]),
            "indent_rainbow_4": rgb(v["rain4"]),
            "indent_rainbow_5": rgb(v["rain5"]),
            "indent_rainbow_6": rgb(v["rain6"]),
            "whitespace_indicator_fg": rgb(v["base5"]),
            "whitespace_indicator_selected_fg": rgb(v["base6"]),
            "bracket_match_fg": rgb(v["bracket-match"]),
            "bracket_rainbow_1": rgb(v["rain1"]),
            "bracket_rainbow_2": rgb(v["rain2"]),
            "bracket_rainbow_3": rgb(v["rain3"]),
            "bracket_rainbow_4": rgb(v["rain4"]),
            "bracket_rainbow_5": rgb(v["rain5"]),
            "bracket_rainbow_6": rgb(v["rain6"]),
            "after_eof_bg": rgb(v["base1"]),
        },
        "ui": {
            "tab_active_fg": rgb(v["tab-active-fg"]),
            "tab_active_bg": rgb(v["tab-active-bg"]),
            "tab_inactive_fg": rgb(v["tab-inactive-fg"]),
            "tab_inactive_bg": rgb(v["tab-inactive-bg"]),
            "tab_separator_bg": rgb(v["tab-inactive-bg"]),
            "tab_close_hover_fg": rgb(v["error"]),
            "tab_hover_bg": rgb(v["base3"]),
            "menu_bg": rgb(v["popup-bg"]),
            "menu_fg": rgb(v["popup-fg"]),
            "menu_active_bg": rgb(v["menu-hl"]),
            "menu_active_fg": rgb(v["highlight"]),
            "menu_dropdown_bg": rgb(v["popup-bg"]),
            "menu_dropdown_fg": rgb(v["popup-fg"]),
            "menu_highlight_bg": rgb(v["menu-hl"]),
            "menu_highlight_fg": rgb(v["popup-fg"]),
            "menu_border_fg": rgb(v["border"]),
            "menu_separator_fg": rgb(v["base5"]),
            "menu_hover_bg": rgb(v["base3"]),
            "menu_hover_fg": rgb(v["fg"]),
            "menu_disabled_fg": rgb(v["base6"]),
            "menu_disabled_bg": rgb(v["popup-bg"]),
            "status_bar_fg": rgb(v["status-fg"]),
            "status_bar_bg": rgb(v["status-bg"]),
            "status_palette_fg": rgb(v["bg"]),
            "status_palette_bg": rgb(v["highlight"]),
            "status_separator_fg": rgb(v["base1"]),
            "status_separator_bg": rgb(v["status-bg"]),
            "status_lsp_on_fg": rgb(v["bg"]),
            "status_lsp_on_bg": rgb(v["success"]),
            "status_lsp_actionable_fg": rgb(v["bg"]),
            "status_lsp_actionable_bg": rgb(v["warning"]),
            "prompt_fg": rgb(v["fg"]),
            "prompt_bg": rgb(v["popup-bg"]),
            "prompt_selection_fg": rgb(v["selection-fg"]),
            "prompt_selection_bg": rgb(v["popup-sel-bg"]),
            "popup_border_fg": rgb(v["border"]),
            "popup_bg": rgb(v["popup-bg"]),
            "popup_selection_bg": rgb(v["popup-sel-bg"]),
            "popup_selection_fg": rgb(v["popup-fg"]),
            "popup_text_fg": rgb(v["popup-fg"]),
            "text_input_selection_bg": rgb(v["selection"]),
            "suggestion_bg": rgb(v["popup-bg"]),
            "suggestion_fg": rgb(v["fg-alt"]),
            "suggestion_selected_bg": rgb(v["popup-sel-bg"]),
            "help_bg": rgb(v["bg"]),
            "help_fg": rgb(v["fg"]),
            "help_key_fg": rgb(v["highlight"]),
            "help_separator_fg": rgb(v["base6"]),
            "help_indicator_fg": rgb(v["error"]),
            "help_indicator_bg": rgb(v["bg"]),
            "inline_code_bg": rgb(v["base2"]),
            "split_separator_fg": rgb(v["border"]),
            "split_separator_hover_fg": rgb(v["highlight"]),
            "scrollbar_track_fg": rgb(v["base1"]),
            "scrollbar_thumb_fg": rgb(v["base4"]),
            "scrollbar_track_hover_fg": rgb(v["base2"]),
            "scrollbar_thumb_hover_fg": rgb(v["base5"]),
            "compose_margin_bg": rgb(v["base1"]),
            "blame_header_fg": rgb(v["base8"]),
            "blame_header_bg": rgb(v["base4"]),
            "semantic_highlight_bg": rgb(v["base4"]),
            "tour_step_bg": rgb(v["base3"]),
            "terminal_bg": rgb(v["bg"]),
            "terminal_fg": rgb(v["fg"]),
            "status_warning_indicator_bg": rgb(v["warning"]),
            "status_warning_indicator_fg": rgb(v["bg"]),
            "status_error_indicator_bg": rgb(v["error"]),
            "status_error_indicator_fg": rgb(v["bg"]),
            "status_warning_indicator_hover_bg": rgb(
                tenx.lighten(v["warning"], 0.15)),
            "status_warning_indicator_hover_fg": rgb(v["bg"]),
            "status_error_indicator_hover_bg": rgb(
                tenx.lighten(v["error"], 0.15)),
            "status_error_indicator_hover_fg": rgb(v["bg"]),
            "tab_drop_zone_bg": rgb(v["popup-sel-bg"]),
            "tab_drop_zone_border": rgb(v["highlight"]),
            "settings_selected_bg": rgb(v["popup-sel-bg"]),
            "settings_selected_fg": rgb(v["popup-fg"]),
            "file_status_added_fg": rgb(v["success"]),
            "file_status_modified_fg": rgb(v["warning"]),
            "file_status_deleted_fg": rgb(v["error"]),
            "file_status_renamed_fg": rgb(v["blue"]),
            "file_status_untracked_fg": rgb(v["base6"]),
            "file_status_conflicted_fg": rgb(v["error"]),
        },
        "search": {
            "match_bg": rgb(v["match-bg"]),
            "match_fg": rgb(v["selection-fg"]),
            "label_bg": rgb(v["label-bg"]),
            "label_fg": rgb(v["label-fg"]),
        },
        "diagnostic": {
            "error_fg": rgb(v["error"]),
            "error_bg": rgb(tenx.mix(v["bg"], v["error"], 0.25)),
            "warning_fg": rgb(v["warning"]),
            "warning_bg": rgb(tenx.mix(v["bg"], v["warning"], 0.25)),
            "info_fg": rgb(v["blue"]),
            "info_bg": rgb(tenx.mix(v["bg"], v["blue"], 0.20)),
            "hint_fg": rgb(v["cyan"]),
            "hint_bg": rgb(tenx.mix(v["bg"], v["cyan"], 0.20)),
        },
        "syntax": {
            "keyword": rgb(v["keywords"]),
            "string": rgb(v["strings"]),
            "comment": rgb(v["comments"]),
            "function": rgb(v["functions"]),
            "type": rgb(v["type"]),
            "variable": rgb(v["variables"]),
            "variable_builtin": rgb(v["builtin"]),
            "constant": rgb(v["constants"]),
            "operator": rgb(v["operators"]),
            "punctuation_bracket": rgb(v["bracket"]),
            "punctuation_delimiter": rgb(v["comma"]),
        },
    }


def main():
    os.makedirs(OUT, exist_ok=True)
    count = 0
    for name, path, data in tenx.all_palettes():
        theme = build(name, data)
        dest = os.path.join(OUT, theme["name"] + ".json")
        with open(dest, "w", encoding="utf-8") as fh:
            json.dump(theme, fh, indent=2)
            fh.write("\n")
        print("wrote", dest)
        count += 1
    print("total:", count)


if __name__ == "__main__":
    main()
