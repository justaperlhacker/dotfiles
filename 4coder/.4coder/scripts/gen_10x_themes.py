#!/usr/bin/env python3
"""Generate 4coder themes from the 10x Editor color schemes.

Palettes are read from the shared Kakoune theme family source:
  ~/Projects/kakoune-themes/palettes/10x/*.10x_settings

Outputs:
  ~/.4coder/themes/theme-10x-<slug>.4coder
  ~/.dotfiles/4coder-fleury/.4coder-fleury/themes/theme-10x-<slug>.4coder

Run:
  python3 ~/.4coder/scripts/gen_10x_themes.py
"""

import os
import sys

HOME = os.path.expanduser("~")
KAK_SCRIPTS = os.path.join(HOME, "Projects", "kakoune-themes", "scripts")
if KAK_SCRIPTS not in sys.path:
    sys.path.insert(0, KAK_SCRIPTS)
import tenx

MAIN_OUT = os.path.join(HOME, ".4coder", "themes")
FLEURY_REPO_OUT = os.path.join(
    HOME, ".dotfiles", "4coder-fleury", ".4coder-fleury", "themes")
FLEURY_LIVE_OUT = os.path.join(HOME, ".4coder-fleury", "themes")


def argb(color, alpha="FF"):
    return "0x%s%s" % (alpha, color[1:].upper())


def color_list(colors, alpha="FF"):
    return "{ " + ", ".join(argb(c, alpha) for c in colors) + " }"


def build(name, data):
    v, meta = tenx.normalize(name, data)

    back_cycle = [tenx.mix(v["bg"], v["fg"], i * 0.03) for i in range(11)]

    lines = [
        "// 10x Editor \"%s\" color scheme" % name,
        "// Generated from ~/Projects/kakoune-themes/palettes/10x/%s.10x_settings" % name,
        "// Source: https://github.com/slynch8/10x/tree/main/ColorSchemes",
        "",
        "defcolor_bar                   = %s;" % argb(v["status-bg"]),
        "defcolor_bar_active            = %s;" % argb(v["base2"]),
        "defcolor_base                  = %s;" % argb(v["status-fg"]),
        "defcolor_pop1                  = %s;" % argb(v["highlight"]),
        "defcolor_pop2                  = %s;" % argb(v["warning"]),
        "defcolor_back                  = %s;" % argb(v["bg"]),
        "defcolor_margin                = %s;" % argb(v["base1"]),
        "defcolor_margin_hover          = %s;" % argb(v["highlight"]),
        "defcolor_margin_active         = %s;" % argb(v["tab-active-bg"]),
        "defcolor_list_item             = { %s, defcolor_back };" % argb(v["base1"]),
        "defcolor_list_item_hover       = { %s, defcolor_margin };" % argb(v["base2"]),
        "defcolor_list_item_active      = { %s, defcolor_margin };" % argb(v["popup-sel-bg"]),
        "defcolor_cursor                = %s;" % color_list(
            [v["cursor"], v["warning"], v["success"], v["highlight"]]),
        "defcolor_at_cursor             = %s;" % argb(v["bg"]),
        "defcolor_highlight_cursor_line = %s;" % argb(v["cur-line"]),
        "defcolor_highlight             = %s;" % argb(v["selection"]),
        "defcolor_at_highlight          = %s;" % argb(v["selection-fg"]),
        "defcolor_mark                  = %s;" % argb(v["match-bg"]),
        "defcolor_text_default          = %s;" % argb(v["fg"]),
        "defcolor_comment               = %s;" % argb(v["comments"]),
        "defcolor_comment_pop           = { %s, %s };" % (
            argb(v["success"]), argb(v["error"])),
        "defcolor_keyword               = %s;" % argb(v["keywords"]),
        "defcolor_str_constant          = %s;" % argb(v["strings"]),
        "defcolor_char_constant         = %s;" % argb(v["strings"]),
        "defcolor_int_constant          = %s;" % argb(v["numbers"]),
        "defcolor_float_constant        = %s;" % argb(v["numbers"]),
        "defcolor_bool_constant         = %s;" % argb(v["constants"]),
        "defcolor_preproc               = %s;" % argb(v["preproc"]),
        "defcolor_include               = %s;" % argb(v["preproc"]),
        "defcolor_special_character     = %s;" % argb(v["violet"]),
        "defcolor_ghost_character       = %s;" % argb(v["base5"]),
        "defcolor_highlight_junk        = %s;" % argb(
            tenx.mix(v["bg"], v["error"], 0.35)),
        "defcolor_highlight_white       = %s;" % argb(
            tenx.mix(v["bg"], v["fg"], 0.25)),
        "defcolor_paste                 = %s;" % argb(v["warning"]),
        "defcolor_undo                  = %s;" % argb(v["blue"]),
        "defcolor_back_cycle            = %s;" % color_list(back_cycle),
        "defcolor_text_cycle            = %s;" % color_list(
            [v["fg"], v["base8"], v["base7"], v["highlight"]]),
        "defcolor_line_numbers_back     = %s;" % argb(v["line-nr-bg"]),
        "defcolor_line_numbers_text     = %s;" % argb(v["line-nr"]),
        "defcolor_line_numbers_text_highlight = %s;" % argb(v["highlight"]),
        "",
        "// QOL colors",
        "defcolor_non_text              = %s;" % argb(v["base5"]),
        "defcolor_function              = %s;" % argb(v["functions"]),
        "defcolor_function_name         = defcolor_function;",
        "defcolor_type                  = %s;" % argb(v["type"]),
        "defcolor_type_name             = defcolor_type;",
        "defcolor_macro                 = %s;" % argb(v["preproc"]),
        "defcolor_enum                  = %s;" % argb(v["enum"]),
        "defcolor_control               = %s;" % argb(v["keywords"]),
        "defcolor_primitive             = %s;" % argb(v["type"]),
        "defcolor_struct                = %s;" % argb(v["type"]),
        "defcolor_global                = %s;" % argb(v["variables"]),
        "defcolor_vim_chord_text        = %s;" % argb(v["fg"]),
        "defcolor_vim_chord_unresolved  = %s;" % argb(v["base6"]),
        "defcolor_vim_chord_error       = %s;" % argb(v["error"]),
        "defcolor_vim_filebar_pop       = %s;" % argb(v["warning"]),
        "",
        "fleury_color_border                = %s;" % argb(v["border"]),
        "fleury_color_syntax_crap           = %s;" % argb(v["brace"]),
        "fleury_color_operators             = %s;" % argb(v["operators"]),
        "fleury_color_inactive_pane_overlay = 0x44000000;",
        "fleury_color_inactive_pane_background = %s;" % argb(
            tenx.darken(v["bg"], 0.10)),
        "fleury_color_file_progress_bar     = %s;" % argb(v["highlight"], "60"),
        "fleury_color_brace_highlight       = %s;" % color_list([v["cursor"]]),
        "fleury_color_brace_line            = %s;" % color_list([v["border"]], "80"),
        "fleury_color_brace_annotation      = %s;" % color_list([v["border"]], "80"),
        "fleury_color_index_product_type    = %s;" % argb(v["type"]),
        "fleury_color_index_sum_type        = %s;" % argb(v["success"]),
        "fleury_color_index_function        = %s;" % argb(v["functions"]),
        "fleury_color_index_macro           = %s;" % argb(v["preproc"]),
        "fleury_color_index_constant        = %s;" % argb(v["constants"]),
        "fleury_color_index_comment_tag     = %s;" % argb(v["warning"]),
        "fleury_color_index_decl            = %s;" % argb(v["variables"]),
        "fleury_color_index_4coder_command  = %s;" % argb(v["highlight"]),
        "fleury_color_cursor_macro          = %s;" % argb(v["violet"]),
        "fleury_color_cursor_power_mode     = %s;" % argb(v["warning"]),
        "fleury_color_cursor_inactive       = %s;" % argb(v["base6"]),
        "fleury_color_plot_cycle            = %s;" % color_list(
            [v["cyan"], v["success"], v["warning"], v["error"]]),
        "fleury_color_token_highlight       = %s;" % argb(v["selection"], "88"),
        "fleury_color_token_minor_highlight = %s;" % argb(v["base4"], "44"),
        "fleury_color_error_annotation      = %s;" % argb(v["error"]),
        "fleury_color_lego_grab             = %s;" % argb(v["warning"]),
        "fleury_color_lego_splat            = %s;" % argb(v["violet"]),
        "fleury_color_comment_user_name     = %s;" % argb(v["highlight"]),
        "",
    ]
    return "\n".join(lines)


def write_theme(path, content):
    with open(path, "w", encoding="utf-8") as fh:
        fh.write(content)


def main():
    os.makedirs(MAIN_OUT, exist_ok=True)
    os.makedirs(FLEURY_REPO_OUT, exist_ok=True)
    live = os.path.isdir(FLEURY_LIVE_OUT)
    count = 0
    for name, path, data in tenx.all_palettes():
        content = build(name, data)
        slug = "theme-10x-" + tenx.slug(name) + ".4coder"
        write_theme(os.path.join(MAIN_OUT, slug), content)
        fleury_path = os.path.join(FLEURY_REPO_OUT, slug)
        write_theme(fleury_path, content)

        if live:
            link = os.path.join(FLEURY_LIVE_OUT, slug)
            if os.path.islink(link) or os.path.exists(link):
                os.remove(link)
            os.symlink(os.path.relpath(fleury_path, FLEURY_LIVE_OUT), link)

        print("wrote", slug)
        count += 1
    print("total:", count)


if __name__ == "__main__":
    main()
