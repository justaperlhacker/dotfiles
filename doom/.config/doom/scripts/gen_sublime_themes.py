#!/usr/bin/env python3
"""Generate Sublime Text color schemes from the same palettes used by
$DOOMDIR/scripts/gen_doom_themes.py.

Source of truth is identical to the Doom generator: the fresh-editor theme
JSONs, nvim's mini.hues seasons, the vscode-themes repo, naysayer, and the
10x Editor palettes. Face roles are taken from the Doom theme template, so
the Sublime schemes match the Emacs ones (comment/keyword/type/string/...).

Output: ~/.config/sublime-text/Packages/User/Doom Themes/
        Doom <Name>.sublime-color-scheme

Regenerate with:  python3 ~/.config/doom/scripts/gen_sublime_themes.py
"""

import json
import os
import sys

HERE = os.path.dirname(os.path.realpath(__file__))
sys.path.insert(0, HERE)
import gen_doom_themes as G  # noqa: E402

OUT = os.path.expanduser(
    "~/.config/sublime-text/Packages/User/Doom Themes")

# token casing fixes for the palette slugs
NAME_FIX = {"vs": "VS", "vscode": "VSCode", "github": "GitHub", "vax": "Vax"}


def pretty(name):
    out = []
    for tok in name.split("-"):
        if tok in NAME_FIX:
            out.append(NAME_FIX[tok])
        elif tok and tok[0].isalpha():
            out.append(tok[0].upper() + tok[1:])
        else:
            out.append(tok)
    return " ".join(out)


def build(name, v, kw_bold, kw_italic, type_bold, type_italic,
          comment_italic=True, variable_italic=False):
    """Translate a Doom palette into a Sublime color scheme."""

    def g(key, fallback=None):
        val = v.get(key)
        if val:
            return val
        return fallback if fallback else v["fg"]

    def pick(key, default):
        return v.get(key) or default

    bg = v["bg"]
    fg = v["fg"]
    comment = g("comments")
    doc = g("doc-comments", comment)
    kw = g("keywords")
    builtin = g("builtin")
    func = g("functions")
    var = g("variables")
    typ = g("type")
    const = g("constants")
    num = g("numbers", const)
    string = g("strings")
    oper = g("operators")
    magenta = g("magenta")
    violet = g("violet")
    red = g("red")
    green = g("green")
    yellow = g("yellow")
    blue = g("blue")
    cyan = g("cyan")
    orange = g("orange")
    err = g("error")
    warn = g("warning")
    succ = g("success")
    highlight = g("highlight")
    bracket = g("bracket-match", highlight)
    sel = g("region", g("sel-bg"))
    curline = g("cur-line")
    lineno = g("line-nr")
    lineno_bg = g("line-nr-bg", bg)
    match_bg = g("match-bg")
    match_fg = g("match-fg", fg)
    label_bg = g("label-bg")
    label_fg = g("label-fg", bg)
    popup_bg = g("popup-bg")
    inline_bg = g("inline-bg", popup_bg)
    base = {i: g("base%d" % i) for i in range(9)}
    storage = pick("storage", kw)
    tag = pick("tag", highlight)
    attr = pick("attr", typ)
    css_class = pick("css-class", kw)
    css_id = pick("css-id", kw)
    css_tag = pick("css-tag", kw)
    css_prop = pick("css-prop", green)
    prop = pick("property", green)

    def style(*flags):
        on = [f for f, enabled in flags if enabled]
        return " ".join(on) if on else None

    kw_style = style(("bold", kw_bold), ("italic", kw_italic))
    type_style = style(("bold", type_bold), ("italic", type_italic))
    storage_style = "bold" if v.get("storage-bold") else kw_style

    variables = {
        "bg": bg, "fg": fg, "comment": comment, "doc": doc,
        "keyword": kw, "storage": storage, "builtin": builtin,
        "function": func,
        "variable": var, "type": typ, "constant": const, "number": num,
        "string": string, "operator": oper, "magenta": magenta,
        "violet": violet, "red": red, "green": green, "yellow": yellow,
        "blue": blue, "cyan": cyan, "orange": orange,
        "error": err, "warning": warn, "success": succ,
        "highlight": highlight, "bracket": bracket, "selection": sel,
        "curline": curline, "lineno": lineno, "lineno_bg": lineno_bg,
        "match_bg": match_bg, "match_fg": match_fg,
        "label_bg": label_bg, "label_fg": label_fg,
        "popup_bg": popup_bg, "inline_bg": inline_bg,
        "tag": tag, "attr": attr, "property": prop,
        "css_class": css_class, "css_id": css_id, "css_tag": css_tag,
        "css_prop": css_prop,
        "shadow": G.darken(bg, 0.3),
        "guide": base[2], "stack_guide": G.mix(base[2], bg, 0.5),
        "inactive_sel": G.mix(sel, bg, 0.5),
    }
    variables.update({"base%d" % i: base[i] for i in range(9)})

    globals_ = {
        "foreground": "var(fg)",
        "background": "var(bg)",
        "accent": "var(highlight)",
        "caret": "var(fg)",
        "line_highlight": "var(curline)",
        "selection": "var(selection)",
        "inactive_selection": "var(inactive_sel)",
        "find_highlight": "var(match_bg)",
        "find_highlight_foreground": "var(match_fg)",
        "gutter": "var(lineno_bg)",
        "gutter_foreground": "var(lineno)",
        "gutter_foreground_highlight": "var(highlight)",
        "misspelling": "var(error)",
        "shadow": "var(shadow)",
        "active_guide": "var(guide)",
        "stack_guide": "var(stack_guide)",
        "highlight": "var(match_bg)",
        "brackets_options": "underline",
        "brackets_foreground": "var(bracket)",
        "bracket_contents_options": "underline",
        "bracket_contents_foreground": "var(type)",
        "tags_options": "stippled_underline",
        "tags_foreground": "var(highlight)",
    }

    def rule(name, scope, fg=None, bg=None, font_style=None):
        r = {"name": name, "scope": scope}
        if fg:
            r["foreground"] = fg if fg.startswith("#") else "var(%s)" % fg
        if bg:
            r["background"] = bg if bg.startswith("#") else "var(%s)" % bg
        if font_style:
            r["font_style"] = font_style
        return r

    rules = [
        rule("Comment", "comment, punctuation.definition.comment", "comment",
             font_style="italic" if comment_italic else None),
        rule("Doc Comment", "comment.block.documentation", "doc",
             font_style="italic"),
        rule("String",
             "string, constant.other.symbol, constant.other.key, "
             "meta.attribute-selector", "string"),
        rule("Docstring", "string.quoted.docstring", "doc",
             font_style="italic"),
        rule("Regexp", "string.regexp", "violet"),
        rule("Escape", "constant.character.escape", "magenta"),
        rule("Number", "constant.numeric", "number"),
        rule("Constant",
             "constant.language, constant.other, support.constant, "
             "variable.other.constant", "constant"),
        rule("Keyword", "keyword", "keyword", font_style=kw_style),
        rule("Storage", "storage.type, storage.modifier", "storage",
             font_style=storage_style),
        rule("Preprocessor",
             "meta.preprocessor, keyword.control.import, "
             "keyword.control.include, keyword.control.export, "
             "entity.name.import", "magenta"),
        rule("Operator", "keyword.operator", "operator"),
        rule("Punctuation",
             "punctuation.definition, punctuation.separator, "
             "punctuation.terminator, punctuation.section, "
             "punctuation.accessor", "operator"),
        rule("Variable", "variable, support.variable", "variable",
             font_style="italic" if variable_italic else None),
        rule("Variable Language",
             "variable.language, keyword.other.this", "builtin"),
        rule("Parameter", "variable.parameter", "orange"),
        rule("Property",
             "variable.other.property, meta.object-literal.key, "
             "support.variable.property", "property"),
        rule("Function",
             "entity.name.function, variable.function, "
             "meta.function-call, entity.name.method", "function"),
        rule("Type",
             "entity.name.type, entity.name.class, entity.name.namespace, "
             "support.type, support.class", "type", font_style=type_style),
        rule("Builtin",
             "support.function, support.function.builtin, "
             "support.constant.math", "builtin"),
        rule("Tag", "entity.name.tag", "tag"),
        rule("Tag Bracket", "punctuation.definition.tag", "base6"),
        rule("Attribute", "entity.other.attribute-name", "attr"),
        rule("CSS Class", "entity.other.attribute-name.class", "css_class"),
        rule("CSS Id", "entity.other.attribute-name.id", "css_id"),
        rule("CSS Tag", "entity.name.tag.css", "css_tag"),
        rule("CSS Property", "support.type.property-name", "css_prop"),
        rule("Markup Heading", "markup.heading, entity.name.section",
             "highlight", font_style="bold"),
        rule("Markup Bold", "markup.bold", "orange", font_style="bold"),
        rule("Markup Italic", "markup.italic", "violet",
             font_style="italic"),
        rule("Markup Underline", "markup.underline", font_style="underline"),
        rule("Markup Link", "markup.underline.link, string.other.link",
             "highlight", font_style="underline"),
        rule("Markup URL", "string.other.link.title", "violet"),
        rule("Markup Raw", "markup.raw, markup.inline.raw", "highlight",
             bg="inline_bg"),
        rule("Markup Quote", "markup.quote", "base7", font_style="italic"),
        rule("Markup Punctuation", "punctuation.definition.markdown",
             "base6"),
        rule("Decorator", "meta.decorator, entity.name.function.decorator",
             "function"),
        rule("Label", "entity.name.label", "highlight"),
        rule("Invalid", "invalid, invalid.illegal", "error"),
        rule("Deprecated", "invalid.deprecated", "base6",
             font_style="strikethrough"),
        rule("Inserted", "markup.inserted", "success"),
        rule("Deleted", "markup.deleted", "error"),
        rule("Changed", "markup.changed", "warning"),
    ]

    return {
        "name": "Doom " + pretty(name),
        "author": "Generated from the Doom Emacs palette (gen_sublime_themes.py)",
        "variables": variables,
        "globals": globals_,
        "rules": rules,
    }


# --------------------------------------------------------------------------
# Official VS Code "Red" theme (extensions/theme-red/themes/Red-color-theme.json)
# --------------------------------------------------------------------------
RED_THEME = os.environ.get(
    "VSCODE_RED_THEME",
    "/usr/share/code/resources/app/extensions/theme-red/themes/"
    "Red-color-theme.json")


def palette_from_vscode_red(path=RED_THEME):
    """Read VS Code's built-in Red theme and map it onto Doom's roles.

    Colors are taken verbatim from the shipped theme (editor colors plus
    token colors), with 8-digit alpha values flattened over the background.
    """
    with open(path) as fh:
        data = json.load(fh)
    colors = data.get("colors", {})

    bg = G._vsc_resolve(colors.get("editor.background"), "#390000")

    def col(key, default):
        return G._vsc_resolve(colors.get(key), bg) or default

    tokens = {}
    for rule in data.get("tokenColors", []):
        fg = (rule.get("settings") or {}).get("foreground")
        if not fg:
            continue
        scopes = rule.get("scope") or []
        if isinstance(scopes, str):
            scopes = scopes.split(",")
        flat = G._vsc_resolve(fg, bg)
        for sc in scopes:
            tokens.setdefault(sc.strip(), flat)

    def tok(key, default):
        return tokens.get(key, default)

    fg = col("editor.foreground", "#f8f8f8")
    comment = tok("comment", "#e7c0c0")
    keyword = tok("keyword", "#f12727")
    storage = tok("storage", "#ff6262")
    entity = tok("entity", "#fec758")
    string = tok("string", "#cd8d8d")
    support = tok("support", "#9df39f")
    variable = tok("variable", "#fb9a4b")
    constant = tok("constant", "#994646")
    support_fn = tok("support.function", "#ffb454")
    escape = tok("constant.character.escape", "#ffe862")
    css_prop = tok("support.type.property-name.css", "#96dd3b")

    v = {
        "bg": bg, "fg": fg,
        "comments": comment, "doc-comments": comment,
        "keywords": keyword, "storage": storage,
        "storage-bold": True,
        "builtin": support_fn, "functions": entity,
        "variables": variable, "type": entity,
        "constants": constant, "numbers": constant,
        "strings": string, "operators": fg,

        "magenta": tok("constant.character", "#ec0d1e"),
        "violet": tok("entity.other.inherited-class", "#aa5507"),
        "red": "#ff6262", "green": support, "yellow": escape,
        "blue": support_fn, "cyan": css_prop, "orange": variable,

        "error": "#ff6262", "warning": escape, "success": "#41a83e",
        "highlight": col("editorLink.activeForeground", "#ffd0aa"),
        "region": col("editor.selectionBackground", "#750000"),
        "cur-line": col("editor.lineHighlightBackground", bg),
        "line-nr": col("editorLineNumber.foreground", "#a23f3f"),
        "line-nr-bg": bg,
        "bracket-match": col("editorLink.activeForeground", "#ffd0aa"),
        "match-bg": "#990000", "match-fg": fg,
        "label-bg": "#cc3333", "label-fg": "#ffffff",
        "popup-bg": col("editorWidget.background", "#300000"),
        "popup-fg": fg,
        "popup-sel-bg": col("input.background", "#580000"),
        "border": col("input.background", "#580000"),
        "inline-bg": col("editorWidget.background", "#300000"),

        "base0": "#2a0000", "base1": "#330000", "base2": "#3d0000",
        "base3": "#490000", "base4": "#580000", "base5": "#6b0000",
        "base6": "#8f5050", "base7": "#cf9090", "base8": fg,

        # VS Code Red specifics
        "tag": tok("meta.tag", "#ec0d1e"),
        "attr": entity,
        "property": entity,
        "css-class": tok("meta.selector.css entity.other.attribute-name.class",
                         "#41a83e"),
        "css-id": tok("meta.selector.css entity.other.attribute-name.id",
                      entity),
        "css-tag": tok("meta.selector.css entity.name.tag", "#aa5507"),
        "css-prop": css_prop,
    }

    return v, False, False, False, False, None, True


def emit(name, palette, display=None, author=None):
    v, kw_bold, kw_italic, type_bold, type_italic, _note = palette[:6]
    variable_italic = palette[6] if len(palette) > 6 else False
    scheme = build(name, v, kw_bold, kw_italic, type_bold, type_italic,
                   variable_italic=variable_italic)
    if display:
        scheme["name"] = display
    if author:
        scheme["author"] = author
    dest = os.path.join(OUT, scheme["name"] + ".sublime-color-scheme")
    with open(dest, "w") as fh:
        json.dump(scheme, fh, indent="\t")
        fh.write("\n")
    return dest


def main():
    os.makedirs(OUT, exist_ok=True)
    written = []

    # 1) fresh-editor palettes (same skips as the Doom generator)
    for fn in sorted(os.listdir(G.FRESH)):
        if not fn.endswith(".json"):
            continue
        name = fn[:-len(".json")]
        if name in G.SKIP or name.startswith("10x-"):
            continue
        with open(os.path.join(G.FRESH, fn)) as fh:
            data = json.load(fh)
        written.append(emit(name, G.palette_from_fresh(name, data)))

    # 2) mini.hues seasons
    if os.path.isdir(G.MINI):
        for name in G.MINI_THEMES:
            written.append(emit(name, G.palette_from_mini(name)))

    # 3) naysayer
    written.append(emit("naysayer", G.palette_naysayer()))

    # 3b) official VS Code "Red" (not a Doom palette: read from VS Code)
    if os.path.exists(RED_THEME):
        written.append(emit("vscode-red", palette_from_vscode_red(),
                            display="VSCode Red (Exact)",
                            author="Direct token-level port of VS Code's "
                                   "built-in Red theme (keeps storage bold)"))
    else:
        print("skipping VSCode Red, theme not found at", RED_THEME)

    # 4) vscode-themes repo
    if os.path.isdir(G.VSC):
        for fn_name in G.VSC_THEMES:
            short = fn_name[len("doom-"):] if fn_name.startswith("doom-") else fn_name
            written.append(emit(short, G.palette_from_vscode(fn_name)))

    # 5) 10x Editor schemes
    try:
        import tenx
    except Exception as exc:  # pragma: no cover
        print("skipping 10x themes:", exc)
    else:
        for name, _path, data in tenx.all_palettes():
            v, meta = tenx.normalize(name, data)
            written.append(emit(
                "10x-" + meta["slug"], (v, meta["kw_bold"], meta["kw_italic"],
                                        meta["type_bold"], meta["type_italic"],
                                        None)))

    print("wrote %d schemes to %s" % (len(written), OUT))


if __name__ == "__main__":
    main()
