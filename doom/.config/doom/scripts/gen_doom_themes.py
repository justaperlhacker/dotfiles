#!/usr/bin/env python3
"""Generate Doom Emacs themes from the fresh-editor theme JSON palettes.

Source of truth: ~/.config/fresh/themes/*.json  (and, where they exist,
~/.config/nvim/colors/*.lua for extra roles/ANSI colors).

Output: $DOOMDIR/themes/doom-<name>-theme.el
"""

import json
import os
import re
import sys
from string import Template

# Resolve paths relative to this script:  <dotfiles>/doom/.config/doom/scripts/
DOOMDIR = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
REPO = os.path.abspath(os.path.join(DOOMDIR, "..", "..", ".."))
HOME = os.path.expanduser("~")

FRESH = os.path.join(REPO, "fresh", ".config", "fresh", "themes")
NVIM = os.path.join(REPO, "nvim", ".config", "nvim", "colors")
MINI = os.path.join(HOME, ".local", "share", "nvim", "lazy", "miniwinter", "colors")
VSC = os.path.join(HOME, "Projects", "vscode-themes", "themes")
OUT = os.path.join(DOOMDIR, "themes")

# 10x Editor palettes live with the Kakoune theme family (the shared source of
# truth for these ports).
KAK_SCRIPTS = os.path.join(HOME, "Projects", "kakoune-themes", "scripts")
if KAK_SCRIPTS not in sys.path:
    sys.path.insert(0, KAK_SCRIPTS)
import tenx

# Themes produced by hand or by another source; skip in the fresh-editor pass.
SKIP = {"vscode-red", "miniwinter", "monochrome"}

# The four "mini.hues" season schemes, generated from nvim's miniwinter plugin.
MINI_THEMES = ["miniwinter", "minispring", "minisummer", "miniautumn"]

# Themes sourced from the vscode-themes repo (~/Projects/vscode-themes).
# NOTE: the dankshell-* themes are intentionally excluded (not wanted).
VSC_THEMES = ["monochrome", "monochrome-amber", "monochrome-chroma",
              "monochrome-green", "chocolatier",
              "batman", "black-metal", "doom-rouge",
              "black-metal-light", "black-metal-gorgoroth-light",
              "miniwinter-light", "minispring-light",
              "minisummer-light", "miniautumn-light"]

# nvim ANSI terminal palettes (terminal_color_0..15) per theme, where ported.
NVIM_ANSI = {
    "vscode-red": ["#300000", "#ff5555", "#98c379", "#ffd75f", "#82aaff",
                   "#ff79c6", "#56d4dd", "#F8F8F8", "#8f5050", "#ff8888",
                   "#b5e890", "#ffe49c", "#aac4ff", "#ffa3d6", "#8ee4ea", "#ffffff"],
    "kraihnight": ["#1a1a1a", "#d6b67f", "#9fac7f", "#d6b67f", "#899ab4",
                   "#ac98ac", "#d08356", "#f9f9f9", "#34383c", "#d6b67f",
                   "#9fac7f", "#d6b67f", "#899ab4", "#ac98ac", "#d08356", "#ffffff"],
    "fleury": ["#020202", "#bd2d2d", "#6eb535", "#f0c674", "#2895c7",
               "#c9598a", "#8ffff2", "#b99468", "#666666", "#ff0000",
               "#a7eb13", "#ffae00", "#6fb3e0", "#e08bb0", "#bffff5", "#f0dcc0"],
}


# ---------------------------------------------------------------- color utils
def clamp(x):
    return max(0, min(255, int(round(x))))


def to_rgb(h):
    h = h.lstrip("#")
    return tuple(int(h[i:i + 2], 16) for i in (0, 2, 4))


def hexs(rgb):
    return "#%02x%02x%02x" % tuple(clamp(c) for c in rgb)


def mix(a, b, t):
    ra, rb = to_rgb(a), to_rgb(b)
    return hexs([ra[i] + (rb[i] - ra[i]) * t for i in range(3)])


def darken(c, t):
    return mix(c, "#000000", t)


def lighten(c, t):
    return mix(c, "#ffffff", t)


def pick(candidates, fallback):
    for c in candidates:
        if c:
            return c
    return fallback


# --------------------------------------------------------------- json access
def path(d, *keys, default=None):
    cur = d
    for k in keys:
        if not isinstance(cur, dict) or k not in cur:
            return default
        cur = cur[k]
    return cur


def rgb(d, *keys, default=None):
    val = path(d, *keys)
    if val is None:
        return default
    if isinstance(val, dict):
        val = val.get("color")
    if isinstance(val, list) and len(val) >= 3:
        return hexs(val)
    if isinstance(val, str):
        return val
    return default


def modifier(d, *keys):
    val = path(d, *keys)
    if isinstance(val, dict):
        return val.get("modifier", [])
    return []


# --------------------------------------------------------------- theme build
def palette_from_fresh(name, data):
    bg = pick([rgb(data, "editor", "bg")], "#1e1e1e")
    fg = pick([rgb(data, "editor", "fg")], "#d4d4d4")
    cursor = pick([rgb(data, "editor", "cursor")], fg)
    inactive_cursor = pick([rgb(data, "editor", "inactive_cursor")], mix(bg, fg, 0.6))
    selection = pick([rgb(data, "editor", "selection_bg")], mix(bg, fg, 0.25))
    cur_line = pick([rgb(data, "editor", "current_line_bg")], mix(bg, fg, 0.08))
    line_nr = pick([rgb(data, "editor", "line_number_fg")], mix(bg, fg, 0.35))
    line_nr_bg = pick([rgb(data, "editor", "line_number_bg")], bg)
    ws = pick([rgb(data, "editor", "whitespace_indicator_fg")], mix(bg, fg, 0.3))
    bracket_match = pick([rgb(data, "editor", "bracket_match_fg")], fg)

    diff_add_bg = pick([rgb(data, "editor", "diff_add_bg")], mix(bg, "#00ff00", 0.15))
    diff_remove_bg = pick([rgb(data, "editor", "diff_remove_bg")], mix(bg, "#ff0000", 0.15))
    diff_modify_bg = pick([rgb(data, "editor", "diff_modify_bg")], mix(bg, "#ffff00", 0.15))

    rain = [pick([rgb(data, "editor", "indent_rainbow_%d" % i),
                  rgb(data, "editor", "bracket_rainbow_%d" % i)], fg) for i in range(1, 7)]

    keyword = pick([rgb(data, "syntax", "keyword")], fg)
    string = pick([rgb(data, "syntax", "string")], fg)
    comment = pick([rgb(data, "syntax", "comment")], mix(bg, fg, 0.5))
    function = pick([rgb(data, "syntax", "function")], fg)
    type_ = pick([rgb(data, "syntax", "type")], fg)
    variable = pick([rgb(data, "syntax", "variable")], fg)
    var_builtin = pick([rgb(data, "syntax", "variable_builtin")], keyword)
    constant = pick([rgb(data, "syntax", "constant")], fg)
    operator = pick([rgb(data, "syntax", "operator")], fg)

    kw_bold = "bold" in modifier(data, "syntax", "keyword")
    kw_italic = "italic" in modifier(data, "syntax", "keyword")
    type_bold = "bold" in modifier(data, "syntax", "type")
    type_italic = "italic" in modifier(data, "syntax", "type")

    diag_err = pick([rgb(data, "diagnostic", "error_fg")], "#ff5555")
    diag_warn = pick([rgb(data, "diagnostic", "warning_fg")], "#ffd75f")
    diag_info = pick([rgb(data, "diagnostic", "info_fg")], "#82aaff")
    diag_hint = pick([rgb(data, "diagnostic", "hint_fg")], "#98c379")
    diag_err_bg = pick([rgb(data, "diagnostic", "error_bg")], darken(diag_err, 0.7))

    match_bg = pick([rgb(data, "search", "match_bg")], mix(bg, diag_warn, 0.35))
    match_fg = pick([rgb(data, "search", "match_fg")], fg)
    label_bg = pick([rgb(data, "search", "label_bg")], keyword)
    label_fg = pick([rgb(data, "search", "label_fg")], bg)

    popup_bg = pick([rgb(data, "ui", "popup_bg"), rgb(data, "ui", "menu_bg"),
                     rgb(data, "ui", "prompt_bg")], mix(bg, fg, 0.08))
    popup_fg = pick([rgb(data, "ui", "popup_text_fg"), rgb(data, "ui", "menu_fg")], fg)
    sel_bg = pick([rgb(data, "ui", "popup_selection_bg"),
                   rgb(data, "ui", "menu_active_bg"),
                   rgb(data, "ui", "prompt_selection_bg")], mix(bg, fg, 0.2))
    border = pick([rgb(data, "ui", "popup_border_fg"), rgb(data, "ui", "split_separator_fg"),
                   rgb(data, "ui", "menu_border_fg")], mix(bg, fg, 0.3))
    tab_active_bg = pick([rgb(data, "ui", "tab_active_bg")], mix(bg, fg, 0.15))
    tab_active_fg = pick([rgb(data, "ui", "tab_active_fg")], fg)
    tab_inactive_bg = pick([rgb(data, "ui", "tab_inactive_bg")], mix(bg, fg, 0.06))
    tab_inactive_fg = pick([rgb(data, "ui", "tab_inactive_fg")], inactive_cursor)
    status_bg = pick([rgb(data, "ui", "status_bar_bg")], mix(bg, fg, 0.12))
    status_fg = pick([rgb(data, "ui", "status_bar_fg")], fg)
    inline_bg = pick([rgb(data, "ui", "inline_code_bg")], popup_bg)

    base0 = darken(bg, 0.5)
    base1 = mix(bg, fg, 0.05)
    base2 = mix(bg, fg, 0.10)
    base3 = mix(bg, fg, 0.15)
    base4 = border
    base5 = ws
    base6 = mix(bg, fg, 0.45)
    base7 = inactive_cursor
    base8 = fg

    v = {
        "bg": bg, "bg-alt": popup_bg,
        "base0": base0, "base1": base1, "base2": base2, "base3": base3,
        "base4": base4, "base5": base5, "base6": base6, "base7": base7, "base8": base8,
        "fg": fg, "fg-alt": inactive_cursor, "grey": base6,

        "red": diag_err, "light-red": lighten(diag_err, 0.25),
        "orange": constant, "green": diag_hint, "yellow": diag_warn,
        "blue": variable if variable != fg else diag_info,
        "magenta": var_builtin, "cyan": diag_info, "teal": type_,
        "violet": keyword, "pink": string, "rose": type_, "salmon": string,

        "highlight": keyword, "vertical-bar": base4, "selection": selection,
        "builtin": var_builtin, "comments": comment,
        "doc-comments": mix(comment, fg, 0.25), "constants": constant,
        "functions": function, "keywords": keyword, "methods": function,
        "operators": operator, "type": type_, "strings": string,
        "variables": variable, "numbers": constant,
        "region": selection, "error": diag_err, "warning": diag_warn,
        "success": diag_hint, "vc-modified": diag_warn, "vc-added": diag_hint,
        "vc-deleted": diag_err,

        "modeline-bg": status_bg, "modeline-bg-alt": base1,
        "modeline-fg": status_fg, "modeline-fg-alt": base7,
        "modeline-bg-l": darken(bg, 0.1), "modeline-bg-inactive": base1,
        "modeline-bg-inactive-l": bg,

        "cursor": cursor, "cur-line": cur_line,
        "line-nr": line_nr, "line-nr-bg": line_nr_bg,
        "sel-bg": selection, "bracket-match": bracket_match,
        "match-bg": match_bg, "match-fg": match_fg,
        "label-bg": label_bg, "label-fg": label_fg,
        "popup-bg": popup_bg, "popup-fg": popup_fg, "popup-sel-bg": sel_bg,
        "border": border,
        "tab-active-bg": tab_active_bg, "tab-active-fg": tab_active_fg,
        "tab-inactive-bg": tab_inactive_bg, "tab-inactive-fg": tab_inactive_fg,
        "status-bg": status_bg, "status-fg": status_fg, "inline-bg": inline_bg,
        "err-bg": diag_err_bg,

        "diff-add-bg": diff_add_bg, "diff-remove-bg": diff_remove_bg,
        "diff-modify-bg": diff_modify_bg,

        "rain1": rain[0], "rain2": rain[1], "rain3": rain[2],
        "rain4": rain[3], "rain5": rain[4], "rain6": rain[5],
    }

    if name in NVIM_ANSI:
        ansi = NVIM_ANSI[name]
    else:
        ansi = [base0, diag_err, diag_hint, diag_warn, v["blue"], var_builtin,
                diag_info, fg, base6, lighten(diag_err, 0.3), lighten(diag_hint, 0.3),
                lighten(diag_warn, 0.3), lighten(v["blue"], 0.3), lighten(var_builtin, 0.3),
                lighten(diag_info, 0.3), "#ffffff"]
    for i, c in enumerate(ansi):
        v["term%d" % i] = c

    # extra names referenced by doom-themes-base
    v["dark-blue"] = darken(v["blue"], 0.4)
    v["dark-cyan"] = darken(v["cyan"], 0.4)
    v["dark-violet"] = darken(v["violet"], 0.4)
    v["dark-red"] = darken(v["red"], 0.35)
    v["dark-green"] = darken(v["green"], 0.35)
    v["light-green"] = lighten(v["green"], 0.2)
    v["light-blue"] = lighten(v["blue"], 0.2)
    v["light-yellow"] = lighten(v["yellow"], 0.2)

    return v, kw_bold, kw_italic, type_bold, type_italic, FRESH_NOTE.format(name=name)


# ------------------------------------------------------------ mini.hues palettes
def parse_mini(path):
    """Extract the dark palette table from a mini.hues colorscheme."""
    text = open(path).read()
    seg = text[text.find("== 'dark'"):]
    block = seg[seg.find("{") + 1:seg.find("}")]
    return dict(re.findall(r"(\w+)\s*=\s*'(#[0-9a-fA-F]{6})'", block))


def palette_from_mini(name):
    p = parse_mini(os.path.join(MINI, name + ".lua"))
    bg, bg_edge, bg_edge2 = p["bg"], p["bg_edge"], p["bg_edge2"]
    bg_mid, bg_mid2 = p["bg_mid"], p["bg_mid2"]
    fg, fg_mid, fg_mid2 = p["fg"], p["fg_mid"], p["fg_mid2"]
    fg_edge, fg_edge2 = p["fg_edge"], p["fg_edge2"]
    accent, accent_bg = p["accent"], p["accent_bg"]
    red, orange = p["red"], p["orange"]
    yellow, green = p["yellow"], p["green"]
    cyan, azure = p["cyan"], p["azure"]
    blue, purple = p["blue"], p["purple"]

    v = {
        "bg": bg, "bg-alt": bg_edge,
        "base0": bg_edge2, "base1": bg_edge, "base2": bg_mid, "base3": bg_mid2,
        "base4": mix(bg_mid2, fg_mid2, 0.5), "base5": fg_mid2, "base6": fg_mid,
        "base7": fg_edge, "base8": fg_edge2,
        "fg": fg, "fg-alt": fg_mid, "grey": fg_mid,

        "red": red, "light-red": red, "orange": orange, "green": green,
        "teal": cyan, "yellow": yellow, "blue": blue, "magenta": purple,
        "violet": purple, "cyan": cyan, "pink": red, "rose": purple, "salmon": orange,

        "highlight": accent, "vertical-bar": accent, "selection": bg_mid2,
        "builtin": azure, "comments": fg_mid2, "doc-comments": fg_mid2,
        "constants": purple, "functions": azure, "keywords": fg, "methods": azure,
        "operators": fg, "type": fg, "strings": green, "variables": yellow,
        "numbers": purple, "region": bg_mid2, "error": red, "warning": yellow,
        "success": green, "vc-modified": cyan, "vc-added": green, "vc-deleted": red,

        "modeline-bg": accent_bg, "modeline-bg-alt": bg_edge,
        "modeline-fg": fg_mid, "modeline-fg-alt": fg_mid2,
        "modeline-bg-l": bg_edge, "modeline-bg-inactive": bg_edge,
        "modeline-bg-inactive-l": bg,

        "cursor": accent, "cur-line": bg_mid, "line-nr": bg_mid2, "line-nr-bg": bg,
        "sel-bg": bg_mid2, "bracket-match": accent,
        "match-bg": accent, "match-fg": bg,
        "label-bg": yellow, "label-fg": bg,
        "popup-bg": bg_edge, "popup-fg": fg, "popup-sel-bg": bg_mid2,
        "border": accent,
        "tab-active-bg": bg_edge, "tab-active-fg": accent,
        "tab-inactive-bg": bg_edge, "tab-inactive-fg": fg_mid,
        "status-bg": accent_bg, "status-fg": fg_mid, "inline-bg": bg_edge,
        "err-bg": p["red_bg"],

        "diff-add-bg": p["green_bg"], "diff-remove-bg": p["red_bg"],
        "diff-modify-bg": p["cyan_bg"],

        "rain1": red, "rain2": orange, "rain3": yellow,
        "rain4": green, "rain5": cyan, "rain6": purple,
    }
    v.update({"term%d" % i: c for i, c in enumerate(
        [bg, red, green, yellow, blue, purple, cyan, fg,
         fg_mid2, red, green, yellow, azure, purple, cyan, fg_edge2])})

    return v, True, False, False, False, MINI_NOTE.format(name=name)


# ------------------------------------------------------------------ naysayer
def palette_naysayer():
    bg = "#062329"
    v = {
        "bg": bg, "bg-alt": "#0c272c",
        "base0": darken(bg, 0.35), "base1": "#0c272c", "base2": "#102a2f",
        "base3": "#142d31", "base4": "#223838", "base5": "#334441",
        "base6": "#43504a", "base7": "#9e937c", "base8": "#f0e6d8",
        "fg": "#d1b897", "fg-alt": "#afc6ce", "grey": "#43504a",

        "red": "#c74138", "light-red": "#ff0000", "orange": "#ffaa00",
        "green": "#22b59e", "teal": "#8cde94", "yellow": "#ffaa00",
        "blue": "#afc6ce", "magenta": "#7ad0c6", "violet": "#7ad0c6",
        "cyan": "#7ad0c6", "pink": "#15ed05", "rose": "#8cde94", "salmon": "#22b59e",

        "highlight": "#8cde94", "vertical-bar": "#223838", "selection": mix(bg, "#8cde94", 0.30),
        "builtin": "#8cde94", "comments": "#15ed05", "doc-comments": "#15ed05",
        "constants": "#7ad0c6", "functions": "#d1b897", "keywords": "#ffffff",
        "methods": "#d1b897", "operators": "#8cde94", "type": "#8cde94",
        "strings": "#22b59e", "variables": "#afc6ce", "numbers": "#7ad0c6",
        "region": mix(bg, "#8cde94", 0.30), "error": "#c74138", "warning": "#ffaa00",
        "success": "#22b59e", "vc-modified": "#ffaa00", "vc-added": "#22b59e",
        "vc-deleted": "#c74138",

        "modeline-bg": "#102a2f", "modeline-bg-alt": "#0c272c",
        "modeline-fg": "#d1b897", "modeline-fg-alt": "#9e937c",
        "modeline-bg-l": "#0c272c", "modeline-bg-inactive": "#0c272c",
        "modeline-bg-inactive-l": bg,

        "cursor": "#8cde94", "cur-line": "#0c272c", "line-nr": "#43504a",
        "line-nr-bg": bg, "sel-bg": mix(bg, "#8cde94", 0.30), "bracket-match": "#8cde94",
        "match-bg": "#8cde94", "match-fg": bg,
        "label-bg": "#8cde94", "label-fg": bg,
        "popup-bg": "#102a2f", "popup-fg": "#d1b897", "popup-sel-bg": "#223838",
        "border": "#223838",
        "tab-active-bg": "#142d31", "tab-active-fg": "#8cde94",
        "tab-inactive-bg": "#0c272c", "tab-inactive-fg": "#7ad0c6",
        "status-bg": "#102a2f", "status-fg": "#d1b897", "inline-bg": "#0c272c",
        "err-bg": "#3a1512",

        "diff-add-bg": mix(bg, "#22b59e", 0.28), "diff-remove-bg": "#3a1512",
        "diff-modify-bg": mix(bg, "#ffaa00", 0.22),

        "rain1": "#8cde94", "rain2": "#7ad0c6", "rain3": "#ffaa00",
        "rain4": "#22b59e", "rain5": "#afc6ce", "rain6": "#15ed05",
    }
    v.update({"term%d" % i: c for i, c in enumerate(
        [bg, "#c74138", "#22b59e", "#ffaa00", "#afc6ce", "#7ad0c6", "#8cde94",
         "#d1b897", "#43504a", "#ff0000", "#15ed05", "#ffaa00", "#afc6ce",
         "#7ad0c6", "#8cde94", "#f0e6d8"])})

    return v, False, True, False, False, NAYSAYER_NOTE


# ------------------------------------------------------------------- rendering
ORDER = ["bg", "bg-alt", "base0", "base1", "base2", "base3", "base4", "base5",
         "base6", "base7", "base8", "fg", "fg-alt", "grey", "red", "light-red",
         "orange", "green", "teal", "yellow", "blue", "magenta", "violet", "cyan",
         "pink", "rose", "salmon",
         "dark-blue", "dark-cyan", "dark-violet", "dark-red", "dark-green",
         "light-green", "light-blue", "light-yellow",
         "highlight", "vertical-bar", "selection", "builtin", "comments",
         "doc-comments", "constants", "functions", "keywords", "methods",
         "operators", "type", "strings", "variables", "numbers", "region",
         "error", "warning", "success", "vc-modified", "vc-added", "vc-deleted",
         "modeline-bg", "modeline-bg-alt", "modeline-fg", "modeline-fg-alt",
         "modeline-bg-l", "modeline-bg-inactive", "modeline-bg-inactive-l",
         "cursor", "cur-line", "line-nr", "line-nr-bg", "sel-bg", "bracket-match",
         "match-bg", "match-fg", "label-bg", "label-fg", "popup-bg", "popup-fg",
         "popup-sel-bg", "border", "tab-active-bg", "tab-active-fg",
         "tab-inactive-bg", "tab-inactive-fg", "status-bg", "status-fg",
         "inline-bg", "err-bg", "diff-add-bg", "diff-remove-bg", "diff-modify-bg",
         "rain1", "rain2", "rain3", "rain4", "rain5", "rain6"] + \
        ["term%d" % i for i in range(16)]

ANSI16 = {"bg": "nil", "base0": '"black"', "base8": '"white"',
          "fg": '"brightwhite"', "base1": '"brightblack"', "grey": '"brightblack"'}


def render(name, v, kw_bold, kw_italic, type_bold, type_italic, source_note,
           comment_italic=True):
    v.setdefault("dark-blue", darken(v["blue"], 0.4))
    v.setdefault("dark-cyan", darken(v["cyan"], 0.4))
    v.setdefault("dark-violet", darken(v["violet"], 0.4))
    v.setdefault("dark-red", darken(v["red"], 0.35))
    v.setdefault("dark-green", darken(v["green"], 0.35))
    v.setdefault("light-green", lighten(v["green"], 0.2))
    v.setdefault("light-blue", lighten(v["blue"], 0.2))
    v.setdefault("light-yellow", lighten(v["yellow"], 0.2))

    light = sum(to_rgb(v["bg"])) / 765.0 > 0.5
    a16 = dict(ANSI16)
    if light:
        a16.update({"fg": '"black"', "base0": '"white"', "base8": '"black"',
                    "base1": '"brightwhite"'})

    spec_lines = []
    for key in ORDER:
        hexv = v[key]
        ansi = a16.get(key, "nil")
        spec_lines.append("   (%-14s '(\"%s\" \"%s\" %s))" % (key, hexv, hexv, ansi))
    spec = "\n".join(spec_lines)

    def attrs(bold, italic):
        parts = []
        if bold:
            parts.append(":weight 'bold")
        if italic:
            parts.append(":slant 'italic")
        return " ".join(parts)

    bg_decl = "\n  :background-mode 'light" if light else ""
    comment_slant = "italic" if comment_italic else "normal"

    return Template(FILE_HEAD + FILE_TAIL).safe_substitute(
        v, spec=spec, name=name, source_note=source_note, bg_decl=bg_decl,
        kw_attrs=attrs(kw_bold, kw_italic),
        type_attrs=attrs(type_bold, type_italic),
        comment_slant=comment_slant)


FRESH_NOTE = (";; Generated from the fresh-editor palette:\n"
              ";;   ~/.config/fresh/themes/{name}.json\n"
              ";;   ~/.config/nvim/colors/{name}.lua  (where ported)")
MINI_NOTE = (";; Generated from Neovim's mini.hues palette (nvim-mini/mini.nvim):\n"
             ";;   ~/.local/share/nvim/lazy/miniwinter/colors/{name}.lua")
NAYSAYER_NOTE = (";; Generated from p0209p/naysayer.vim (Neovim) and the\n"
                 ";; justaperlhacker VSCode \"naysayer\" theme.")
VSC_NOTE = (";; Generated from the justaperlhacker vscode-themes source:\n"
            ";;   ~/Projects/vscode-themes/themes/{name}-color-theme.json")
TENX_NOTE = (";; Generated from the 10x Editor color scheme:\n"
             ";;   ~/Projects/kakoune-themes/palettes/10x/{name}.10x_settings")


SPEC_TEMPLATE = r'''  ;; name        default      256          16
${spec}

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-${name}-padded-modeline
      (if (integerp doom-${name}-padded-modeline) doom-${name}-padded-modeline 4)))

'''


FILE_HEAD = r''';;; doom-${name}-theme.el --- Port of the "${name}" theme -*- lexical-binding: t; no-byte-compile: t; -*-
;;
${source_note}
;;
;;; Commentary:
;;
;; A Doom Emacs port kept in sync with the fresh-editor, Neovim and VSCode
;; builds of the same theme, so all editors share one palette.
;;
;;; Code:

(require 'doom-themes)


;;
;;; Variables

(defgroup doom-${name}-theme nil
  "Options for the `doom-${name}' theme."
  :group 'doom-themes)

(defcustom doom-${name}-padded-modeline doom-themes-padded-modeline
  "If non-nil, adds a 4px padding to the mode-line.
Can be an integer to determine the exact padding."
  :group 'doom-${name}-theme
  :type '(choice integer boolean))

(defcustom doom-${name}-comment-bg nil
  "If non-nil, comments will have a subtle, darker background."
  :group 'doom-${name}-theme
  :type 'boolean)


;;
;;; Theme definition

(def-doom-theme doom-${name}
  "A Doom port of the ${name} theme."
${bg_decl}
  ;; name        default      256          16
  (${spec}

   (hidden     `(,(car bg) "black" "black"))
   (-modeline-pad
    (when doom-${name}-padded-modeline
      (if (integerp doom-${name}-padded-modeline) doom-${name}-padded-modeline 4))))
'''

FILE_TAIL = r'''
  ;;;; Base theme face overrides
  (((font-lock-comment-face &override)
    :background (if doom-${name}-comment-bg bg-alt 'unspecified)
    :slant '${comment_slant})
   ((font-lock-keyword-face &override) :foreground keywords ${kw_attrs})
   ((font-lock-builtin-face &override) :foreground builtin)
   ((font-lock-function-name-face &override) :foreground functions)
   ((font-lock-variable-name-face &override) :foreground variables)
   ((font-lock-type-face &override) :foreground type ${type_attrs})
   ((font-lock-constant-face &override) :foreground constants)
   ((font-lock-string-face &override) :foreground strings)
   ((font-lock-warning-face &override) :foreground error :weight 'bold)
   ((line-number &override) :foreground line-nr)
   ((line-number-current-line &override)
    :foreground highlight :background cur-line :weight 'bold)

   (font-lock-comment-delimiter-face :foreground comments)
   (font-lock-doc-face :foreground doc-comments :slant 'italic)
   (font-lock-number-face :foreground numbers)
   (font-lock-operator-face :foreground operators)
   (font-lock-preprocessor-face :foreground magenta)
   (font-lock-negation-char-face :foreground operators)
   (font-lock-regexp-grouping-backslash :foreground magenta)
   (font-lock-regexp-grouping-construct :foreground violet)

   (cursor :background cursor :foreground bg)
   (region :background region :foreground fg :extend t)
   (secondary-selection :background popup-sel-bg :extend t)
   (hl-line :background cur-line :extend t)
   (highlight :background highlight :foreground base0)
   (fringe :background bg :foreground base5)
   (vertical-border :foreground vertical-bar)
   (border :foreground border :background border)
   (shadow :foreground base6)
   (link :foreground highlight :underline t :weight 'bold)
   (link-visited :foreground violet :underline t :weight 'normal)
   (success :foreground success :weight 'bold)
   (warning :foreground warning :weight 'bold)
   (error :foreground error :weight 'bold)
   (match :background match-bg :foreground match-fg :weight 'bold)

   (isearch :background label-bg :foreground label-fg :weight 'bold)
   (isearch-fail :background err-bg :foreground error :weight 'bold)
   (lazy-highlight :background match-bg :foreground match-fg :weight 'bold)
   (show-paren-match :background sel-bg :foreground bracket-match :weight 'ultra-bold)
   (show-paren-mismatch :background error :foreground bg :weight 'ultra-bold)

   (minibuffer-prompt :foreground highlight :weight 'bold)

   (mode-line
    :background modeline-bg :foreground modeline-fg
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg)))
   (mode-line-inactive
    :background modeline-bg-inactive :foreground modeline-fg-alt
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive)))
   (mode-line-emphasis :foreground fg :weight 'bold)
   (mode-line-buffer-id :foreground highlight :weight 'bold)
   (mode-line-highlight :inherit 'highlight :distant-foreground bg)

   (tooltip :background bg-alt :foreground fg)
   (file-name-shadow :foreground base6)

   ;;;; all-the-icons
   (all-the-icons-red :foreground red)
   (all-the-icons-dred :foreground error)

   ;;;; centaur-tabs
   (centaur-tabs-default :background bg-alt :foreground base7)
   (centaur-tabs-selected :background tab-active-bg :foreground tab-active-fg :weight 'bold)
   (centaur-tabs-unselected :background tab-inactive-bg :foreground tab-inactive-fg)
   (centaur-tabs-selected-modified :background tab-active-bg :foreground highlight :weight 'bold)
   (centaur-tabs-unselected-modified :background tab-inactive-bg :foreground highlight)
   (centaur-tabs-active-bar-face :background highlight)
   (centaur-tabs-modified-marker-selected :inherit 'centaur-tabs-selected :foreground highlight)
   (centaur-tabs-modified-marker-unselected :inherit 'centaur-tabs-unselected :foreground highlight)

   ;;;; company
   (company-tooltip :background bg-alt :foreground fg)
   (company-tooltip-selection :background popup-sel-bg :foreground fg :weight 'bold)
   (company-tooltip-common :foreground highlight :weight 'bold)
   (company-tooltip-common-selection :foreground highlight)
   (company-tooltip-annotation :foreground orange)
   (company-scrollbar-fg :background base4)
   (company-scrollbar-bg :background bg-alt)
   (company-preview :foreground base7 :slant 'italic)
   (company-preview-common :foreground highlight :slant 'italic)

   ;;;; corfu
   (corfu-default :background bg-alt :foreground fg)
   (corfu-current :background popup-sel-bg :foreground fg :weight 'bold)
   (corfu-bar :background highlight)
   (corfu-border :background base4)

   ;;;; css-mode <built-in> / scss-mode
   (css-proprietary-property :foreground orange)
   (css-property :foreground green)
   (css-selector :foreground keywords)

   ;;;; dired
   (dired-directory :foreground highlight :weight 'bold)
   (dired-flagged :foreground error)
   (dired-header :foreground highlight :weight 'bold)
   (dired-ignored :foreground base6)
   (dired-mark :foreground error :weight 'bold)
   (dired-marked :foreground error :weight 'bold)
   (dired-perm-write :foreground warning)
   (dired-symlink :foreground violet :slant 'italic)
   (dired-warning :foreground warning)

   ;;;; doom-modeline
   (doom-modeline-bar :background highlight)
   (doom-modeline-buffer-file :inherit 'mode-line-buffer-id :weight 'bold)
   (doom-modeline-buffer-path :foreground fg)
   (doom-modeline-buffer-major-mode :inherit 'doom-modeline-buffer-path)
   (doom-modeline-buffer-modified :foreground highlight :weight 'bold)
   (doom-modeline-buffer-minor-mode :foreground base7)
   (doom-modeline-project-dir :foreground highlight :weight 'bold)
   (doom-modeline-project-root-dir :foreground highlight)
   (doom-modeline-info :foreground success :weight 'bold)
   (doom-modeline-warning :foreground warning :weight 'bold)
   (doom-modeline-urgent :foreground error :weight 'bold)
   (doom-modeline-debug :foreground base7)
   (doom-modeline-lsp-success :foreground success :weight 'bold)

   ;;;; ediff <built-in>
   (ediff-fine-diff-A :background diff-modify-bg :weight 'bold)
   (ediff-current-diff-A :background base0)

   ;;;; help / info
   (help-key-binding :foreground highlight :background bg-alt :weight 'bold)
   (info-title-1 :foreground highlight :weight 'bold :height 1.3)
   (info-title-2 :foreground keywords :weight 'bold :height 1.2)
   (info-title-3 :foreground type :weight 'bold)
   (info-title-4 :foreground functions :weight 'bold)
   (Info-quoted :foreground orange)

   ;;;; ivy
   (ivy-current-match :background popup-sel-bg :foreground fg :weight 'bold)
   (ivy-minibuffer-match-face-1 :foreground base7)
   (ivy-minibuffer-match-face-2 :foreground highlight :weight 'extra-bold)
   (ivy-minibuffer-match-face-3 :foreground type)
   (ivy-minibuffer-match-face-4 :foreground warning)
   (ivy-posframe :background bg-alt)
   (ivy-posframe-border :background highlight)

   ;;;; magit
   (magit-section-highlight :background (doom-blend highlight bg 0.12) :extend t)
   (magit-section-heading :foreground highlight :weight 'bold)
   (magit-section-heading-selection :foreground highlight :weight 'bold)
   (magit-diff-hunk-heading :foreground bg :background (doom-blend highlight bg 0.3) :extend t)
   (magit-diff-hunk-heading-highlight :foreground bg :background highlight :weight 'bold :extend t)
   (magit-diff-context :foreground base7 :background bg :extend t)
   (magit-diff-context-highlight :foreground fg :background (doom-blend highlight bg 0.12) :extend t)
   (magit-diff-added :foreground success :background diff-add-bg)
   (magit-diff-added-highlight :foreground success :background (doom-lighten diff-add-bg 0.08))
   (magit-diff-removed :foreground error :background diff-remove-bg)
   (magit-diff-removed-highlight :foreground error :background (doom-lighten diff-remove-bg 0.08))
   (magit-diff-base :foreground warning :background diff-modify-bg)
   (magit-diff-base-highlight :foreground warning :background (doom-lighten diff-modify-bg 0.08))
   (magit-hash :foreground base6)
   (magit-branch-local :foreground highlight :weight 'bold)
   (magit-branch-remote :foreground keywords :weight 'bold)
   (magit-tag :foreground warning)
   (magit-log-author :foreground base7)
   (magit-log-date :foreground base6)
   (magit-process-ok :foreground success :weight 'bold)
   (magit-process-ng :foreground error :weight 'bold)

   ;;;; markdown-mode
   (markdown-header-face :foreground highlight :weight 'bold)
   (markdown-header-delimiter-face :foreground highlight)
   (markdown-inline-code-face :foreground highlight :background inline-bg)
   ((markdown-code-face &override) :background inline-bg)
   (markdown-link-face :foreground highlight :underline t)
   (markdown-url-face :foreground violet :underline t)
   (markdown-markup-face :foreground base6)

   ;;;; mic-paren
   ((paren-face-match &override) :foreground bracket-match :background sel-bg :weight 'ultra-bold)
   ((paren-face-mismatch &override) :foreground bg :background error :weight 'ultra-bold)

   ;;;; org <built-in>
   (org-hide :foreground hidden)
   (org-level-1 :foreground highlight :weight 'bold :height 1.2)
   (org-level-2 :foreground keywords :weight 'bold :height 1.1)
   (org-level-3 :foreground type :weight 'bold)
   (org-level-4 :foreground functions :weight 'bold)
   (org-level-5 :foreground orange :weight 'bold)
   (org-level-6 :foreground warning :weight 'bold)
   (org-level-7 :foreground success :weight 'bold)
   (org-level-8 :foreground cyan :weight 'bold)
   (org-document-title :foreground highlight :weight 'bold :height 1.35)
   (org-document-info :foreground base7)
   (org-todo :foreground error :weight 'bold)
   (org-done :foreground success :weight 'bold)
   (org-headline-done :foreground base6)
   (org-ellipsis :foreground highlight :underline nil)
   (org-table :foreground violet)
   (org-formula :foreground warning)
   (org-checkbox :foreground highlight :weight 'bold)
   (org-date :foreground highlight :underline t)
   (org-special-keyword :foreground base7)
   (org-tag :foreground base6 :weight 'normal)
   (org-link :foreground highlight :underline t :weight 'bold)
   (org-priority :foreground error :weight 'bold)
   (org-code :foreground highlight)
   (org-verbatim :foreground violet)
   ((org-block &override) :background inline-bg)
   ((org-block-background &override) :background inline-bg)
   ((org-block-begin-line &override) :background inline-bg :foreground base7 :slant 'italic)
   ((org-block-end-line &override) :background inline-bg :foreground base7 :slant 'italic)
   (org-quote :foreground base7 :background inline-bg :slant 'italic)

   ;;;; rainbow-delimiters
   (rainbow-delimiters-depth-1-face :foreground rain1)
   (rainbow-delimiters-depth-2-face :foreground rain2)
   (rainbow-delimiters-depth-3-face :foreground rain3)
   (rainbow-delimiters-depth-4-face :foreground rain4)
   (rainbow-delimiters-depth-5-face :foreground rain5)
   (rainbow-delimiters-depth-6-face :foreground rain6)
   (rainbow-delimiters-depth-7-face :foreground rain1)
   (rainbow-delimiters-depth-8-face :foreground rain2)
   (rainbow-delimiters-depth-9-face :foreground rain3)
   (rainbow-delimiters-mismatched-face :foreground error :weight 'bold)
   (rainbow-delimiters-unmatched-face :foreground error :weight 'bold)

   ;;;; solaire-mode
   (solaire-mode-line-face
    :inherit 'mode-line :background modeline-bg-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-l)))
   (solaire-mode-line-inactive-face
    :inherit 'mode-line-inactive :background modeline-bg-inactive-l
    :box (if -modeline-pad `(:line-width ,-modeline-pad :color ,modeline-bg-inactive-l)))
   (solaire-default-face :background bg-alt :foreground fg)
   (solaire-hl-line-face :background cur-line :extend t)
   (solaire-region-face :background region)

   ;;;; tab-bar
   (tab-bar :background bg-alt :foreground base7 :box nil)
   (tab-bar-tab :background tab-active-bg :foreground tab-active-fg :weight 'bold :box nil)
   (tab-bar-tab-inactive :background tab-inactive-bg :foreground tab-inactive-fg :box nil)

   ;;;; tab-line
   (tab-line :background bg-alt :foreground base7 :box nil)
   (tab-line-tab :background tab-inactive-bg :foreground tab-inactive-fg :box nil)
   (tab-line-tab-current :background tab-active-bg :foreground tab-active-fg :weight 'bold :box nil)
   (tab-line-tab-inactive :background tab-inactive-bg :foreground tab-inactive-fg :box nil)
   (tab-line-highlight :background popup-sel-bg :foreground fg)

   ;;;; terminal
   (term-color-black :foreground term0 :background term0)
   (term-color-red :foreground term1 :background term1)
   (term-color-green :foreground term2 :background term2)
   (term-color-yellow :foreground term3 :background term3)
   (term-color-blue :foreground term4 :background term4)
   (term-color-magenta :foreground term5 :background term5)
   (term-color-cyan :foreground term6 :background term6)
   (term-color-white :foreground term7 :background term7)

   ;;;; treemacs
   (treemacs-root-face :foreground highlight :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-root-face :foreground highlight :weight 'ultra-bold :height 1.2)
   (doom-themes-treemacs-file-face :foreground fg)
   (treemacs-directory-face :foreground highlight :weight 'bold)
   (treemacs-file-face :foreground fg)
   (treemacs-git-modified-face :foreground warning)
   (treemacs-git-untracked-face :foreground base7)
   (treemacs-git-added-face :foreground success)
   (treemacs-git-conflict-face :foreground error)

   ;;;; vc / diff-hl
   (diff-hl-insert :background diff-add-bg :foreground success)
   (diff-hl-delete :background diff-remove-bg :foreground error)
   (diff-hl-change :background diff-modify-bg :foreground warning)

   ;;;; vimish-fold
   ((vimish-fold-overlay &override) :inherit 'font-lock-comment-face :background base3 :weight 'light)
   ((vimish-fold-fringe &override) :foreground teal)

   ;;;; web-mode
   (web-mode-html-tag-face :foreground highlight)
   (web-mode-html-tag-bracket-face :foreground base6)
   (web-mode-html-attr-name-face :foreground type)
   (web-mode-html-attr-value-face :foreground strings)
   (web-mode-css-selector-face :foreground keywords)
   (web-mode-css-property-name-face :foreground green)
   (web-mode-css-string-face :foreground strings)

   ;;;; which-key
   (which-key-key-face :foreground keywords :weight 'bold)
   (which-key-separator-face :foreground base6)
   (which-key-note-face :foreground base7)
   (which-key-command-description-face :foreground fg)
   (which-key-group-description-face :foreground highlight)
   (which-key-local-map-description-face :foreground orange)
   (which-key-special-key-face :foreground warning :weight 'bold))

  ;;;; Base theme variable overrides
  ())
;;; doom-${name}-theme.el ends here
'''


def _vsc_resolve(color, bg):
    if not color:
        return None
    h = color.lstrip("#")
    try:
        if len(h) == 8:
            r, g, b, a = (int(h[i:i + 2], 16) for i in range(0, 8, 2))
            if a >= 254:
                return "#%02x%02x%02x" % (r, g, b)
            a /= 255.0
            br, bgc, bb = to_rgb(bg)
            return hexs([r * a + br * (1 - a), g * a + bgc * (1 - a), b * a + bb * (1 - a)])
        if len(h) == 6:
            return "#" + h.lower()
        if len(h) == 3:
            return "#" + "".join(c * 2 for c in h).lower()
    except ValueError:
        return None
    return None


def _vsc_find(tokens, targets):
    # Prefer exact scope matches, then fall back to more specific token scopes.
    for target in targets:
        for scopes, fg, style in tokens:
            if fg and target in scopes:
                return fg.lower(), style
    for target in targets:
        for scopes, fg, style in tokens:
            if not fg:
                continue
            if any(s.startswith(target + ".") for s in scopes):
                return fg.lower(), style
    return None, ""


def palette_from_vscode(name):
    d = json.load(open(os.path.join(VSC, name + "-color-theme.json")))
    c = d.get("colors", {})
    tokens = []
    for t in d.get("tokenColors", []):
        scope = t.get("scope")
        if isinstance(scope, str):
            scope = [scope]
        settings = t.get("settings", {})
        tokens.append((scope or [], settings.get("foreground"),
                       settings.get("fontStyle", "")))

    def col(*keys, default=None):
        for k in keys:
            v = _vsc_resolve(c.get(k), bg0 if default is None else default)
            if v:
                return v
        return default

    bg = _vsc_resolve(c.get("editor.background"), "#000000") or "#000000"
    bg0 = bg
    fg = _vsc_resolve(c.get("editor.foreground"), "#ffffff") or "#ffffff"

    selection = col("editor.selectionBackground", default=mix(bg, fg, 0.25))
    cur_line = col("editor.lineHighlightBackground", default=mix(bg, fg, 0.08))
    line_nr = col("editorLineNumber.foreground", default=mix(bg, fg, 0.35))
    line_nr_active = col("editorLineNumber.activeForeground", default=fg)
    cursor = col("editorCursor.foreground", default=fg)
    ws = col("editorWhitespace.foreground", default=mix(bg, fg, 0.3))
    widget = col("editorWidget.background", "editorSuggestWidget.background",
                 "menu.background", default=mix(bg, fg, 0.08))
    panel = col("panel.background", "sideBar.background", default=mix(bg, fg, 0.06))
    border = col("panel.border", "editorGroup.border", "focusBorder", default=mix(bg, fg, 0.3))
    status_bg = col("statusBar.background", default=panel)
    status_fg = col("statusBar.foreground", default=fg)
    tab_ab = col("tab.activeBackground", default=widget)
    tab_af = col("tab.activeForeground", default=fg)
    tab_ib = col("tab.inactiveBackground", default=panel)
    tab_if = col("tab.inactiveForeground", default=mix(bg, fg, 0.6))
    err = col("editorError.foreground", default="#ff5555")
    warn = col("editorWarning.foreground", default="#ffd75f")
    info = col("editorInfo.foreground", default="#82aaff")
    find = col("editor.findMatchBackground", default=mix(bg, fg, 0.3))
    find_hl = col("editor.findMatchHighlightBackground", default=mix(bg, fg, 0.2))
    list_sel = col("list.activeSelectionBackground", "list.hoverBackground",
                   default=selection)

    def syn(*targets):
        fg_, _ = _vsc_find(tokens, list(targets))
        return fg_ or fg

    comment = syn("comment.block.documentation", "comment")
    string = syn("string", "string.quoted", "string.template")
    number = syn("constant.numeric", "constant.numeric.integer")
    constant = syn("constant.language", "constant", "support.constant")
    keyword, kw_style = _vsc_find(tokens, ["keyword", "storage", "storage.type"])
    keyword = (keyword or fg)
    operator = syn("keyword.operator", "punctuation.definition.operator")
    variable = syn("variable.parameter", "variable.other", "variable")
    var_builtin = syn("variable.language", "variable.special", "variable.other")
    function = syn("entity.name.function", "support.function", "meta.function-call")
    type_, type_style = _vsc_find(tokens, ["entity.name.type", "support.type",
                                           "entity.name.class", "meta.type"])
    type_ = type_ or fg
    preproc = syn("meta.preprocessor", "entity.name.function.macro",
                  "entity.name.function.preprocessor")

    kw_bold, kw_italic = "bold" in kw_style, "italic" in kw_style
    type_bold, type_italic = "bold" in type_style, "italic" in type_style

    if sum(to_rgb(bg)) / 765.0 > 0.5:  # light palette: base ramps toward bg
        base = {
            "base0": lighten(bg, 0.5), "base1": lighten(bg, 0.3),
            "base2": lighten(bg, 0.15), "base3": mix(bg, fg, 0.12),
            "base4": border, "base5": mix(bg, fg, 0.35),
            "base6": mix(bg, fg, 0.5), "base7": mix(bg, fg, 0.7), "base8": fg,
        }
    else:
        base = {
            "base0": darken(panel, 0.35), "base1": panel, "base2": widget,
            "base3": mix(bg, fg, 0.12), "base4": border, "base5": ws,
            "base6": line_nr, "base7": mix(bg, fg, 0.6), "base8": fg,
        }

    v = {
        **base,
        "bg": bg, "bg-alt": widget,
        "fg": fg, "fg-alt": mix(bg, fg, 0.6), "grey": line_nr,
        "red": err, "light-red": lighten(err, 0.25), "orange": warn,
        "green": function, "teal": type_, "yellow": warn, "blue": info,
        "magenta": preproc, "violet": preproc, "cyan": info, "pink": string,
        "rose": type_, "salmon": string,

        "highlight": cursor, "vertical-bar": border, "selection": selection,
        "builtin": var_builtin, "comments": comment, "doc-comments": comment,
        "constants": constant, "functions": function, "keywords": keyword,
        "methods": function, "operators": operator, "type": type_,
        "strings": string, "variables": variable, "numbers": number,
        "region": selection, "error": err, "warning": warn, "success": function,
        "vc-modified": warn, "vc-added": function, "vc-deleted": err,

        "modeline-bg": status_bg, "modeline-bg-alt": panel,
        "modeline-fg": status_fg, "modeline-fg-alt": mix(bg, fg, 0.6),
        "modeline-bg-l": panel, "modeline-bg-inactive": panel,
        "modeline-bg-inactive-l": bg,

        "cursor": cursor, "cur-line": cur_line, "line-nr": line_nr,
        "line-nr-bg": bg, "sel-bg": list_sel, "bracket-match": cursor,
        "match-bg": find_hl, "match-fg": fg, "label-bg": find, "label-fg": bg,
        "popup-bg": widget, "popup-fg": fg, "popup-sel-bg": list_sel,
        "border": border,
        "tab-active-bg": tab_ab, "tab-active-fg": tab_af,
        "tab-inactive-bg": tab_ib, "tab-inactive-fg": tab_if,
        "status-bg": status_bg, "status-fg": status_fg, "inline-bg": widget,
        "err-bg": mix(bg, err, 0.30),

        "diff-add-bg": mix(bg, function, 0.30), "diff-remove-bg": mix(bg, err, 0.30),
        "diff-modify-bg": mix(bg, warn, 0.30),

        "rain1": cursor, "rain2": type_, "rain3": function,
        "rain4": warn, "rain5": err, "rain6": preproc,
    }
    v.update({"term%d" % i: cc for i, cc in enumerate(
        [bg, err, function, warn, info, preproc, type_, fg,
         line_nr, lighten(err, 0.3), lighten(function, 0.3), lighten(warn, 0.3),
         lighten(info, 0.3), lighten(preproc, 0.3), lighten(type_, 0.3), "#ffffff"])})

    return v, kw_bold, kw_italic, type_bold, type_italic, VSC_NOTE.format(name=name)


def write_theme(name, v, kw_bold, kw_italic, type_bold, type_italic, note,
                comment_italic=True):
    dest = os.path.join(OUT, "doom-%s-theme.el" % name)
    with open(dest, "w") as fh:
        fh.write(render(name, v, kw_bold, kw_italic, type_bold, type_italic,
                        note, comment_italic))
    print("wrote", dest)
    return name


def main():
    os.makedirs(OUT, exist_ok=True)
    names = []

    # 1) fresh-editor palettes (hand-written / separately-sourced themes skipped)
    for fn in sorted(os.listdir(FRESH)):
        if not fn.endswith(".json"):
            continue
        name = fn[:-len(".json")]
        if name in SKIP or name.startswith("10x-"):
            continue
        with open(os.path.join(FRESH, fn)) as fh:
            data = json.load(fh)
        names.append(write_theme(name, *palette_from_fresh(name, data)))

    # 2) nvim mini.hues "four seasons" schemes
    if os.path.isdir(MINI):
        for name in MINI_THEMES:
            names.append(write_theme(name, *palette_from_mini(name)))

    # 3) naysayer (nvim + vscode)
    names.append(write_theme("naysayer", *palette_naysayer()))

    # 4) vscode-themes repo (monochrome variants + chocolatier)
    if os.path.isdir(VSC):
        for fn_name in VSC_THEMES:
            short = fn_name[len("doom-"):] if fn_name.startswith("doom-") else fn_name
            names.append(write_theme(short, *palette_from_vscode(fn_name)))

    # 5) 10x Editor color schemes
    for name, path, data in tenx.all_palettes():
        v, meta = tenx.normalize(name, data)
        names.append(write_theme(
            "10x-" + meta["slug"], v, meta["kw_bold"], meta["kw_italic"],
            meta["type_bold"], meta["type_italic"],
            TENX_NOTE.format(name=name),
            comment_italic=meta["comment_italic"]))

    print("total:", len(names))


if __name__ == "__main__":
    main()
