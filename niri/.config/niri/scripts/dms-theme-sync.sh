#!/bin/sh
# Keep the system color-scheme and GTK dark preference in sync with DMS's
# light/dark mode.
#
# DMS writes "prefer-dark" for dark mode, but in light mode it only writes
# "default" unless the current value is already "prefer-light". The portal then
# reports "no preference" (0), so Electron apps such as Discord stop following
# the system.
#
# GTK3 has no color-scheme support at all; it obeys the static
# gtk-application-prefer-dark-theme key in ~/.config/gtk-{3,4}.0/settings.ini,
# which Plasma's kde-gtk-config leaves behind from the last Plasma session.
# Rewrite that key on every mode change so the niri session owns the file while
# it is running (Plasma rewrites it again when it applies its own theme).

set_gtk_dark() {
    dark=$1
    if [ "$dark" = true ]; then
        theme=Breeze-Dark
    else
        theme=Breeze
    fi

    for file in "$HOME/.config/gtk-3.0/settings.ini" \
        "$HOME/.config/gtk-4.0/settings.ini"; do
        [ -f "$file" ] || continue

        # Keep prefer-dark false: it is startup-only and cannot be changed in
        # a running app. The explicit Breeze/Breeze-Dark theme name is the
        # live channel Chromium/Brave watches (notify::gtk-theme-name).
        current=$(sed -n 's/^gtk-application-prefer-dark-theme=//p' "$file" | tail -1)
        if [ "$current" != false ]; then
            if [ -n "$current" ]; then
                sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=false/" "$file"
            else
                printf 'gtk-application-prefer-dark-theme=false\n' >> "$file"
            fi
            echo "gtk theme: $file gtk-application-prefer-dark-theme=false"
        fi

        current_theme=$(sed -n 's/^gtk-theme-name=//p' "$file" | tail -1)
        if [ "$current_theme" != "$theme" ]; then
            if [ -n "$current_theme" ]; then
                sed -i "s/^gtk-theme-name=.*/gtk-theme-name=$theme/" "$file"
            else
                printf 'gtk-theme-name=%s\n' "$theme" >> "$file"
            fi
            echo "gtk theme: $file gtk-theme-name=$theme"
        fi
    done

    # Running apps (Chromium/Brave) watch notify::gtk-theme-name, so switch
    # the name itself as well; rewriting settings.ini alone is not noticed.
    current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null | tr -d "'")
    if [ "$current_theme" != "$theme" ]; then
        if gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null; then
            echo "gtk theme: gsettings gtk-theme $current_theme -> $theme"
        fi
    fi
}

# Plasma's colors.css pins the Breeze color map to the last Plasma scheme, and
# older Matugen runs left a full dark palette inline in gtk.css. Neither
# follows DMS. Keep only the live DMS palette (dank-colors.css); the Breeze
# theme's own light/dark variant is selected by the prefer-dark flag above.
set_gtk_css() {
    for file in "$HOME/.config/gtk-3.0/gtk.css" \
        "$HOME/.config/gtk-4.0/gtk.css"; do
        [ -f "$file" ] || continue
        grep -qE 'Generated with Matugen|dank-colors\.css|colors\.css|i3-theme-sync' "$file" || continue
        [ "$(cat "$file")" = '@import url("dank-colors.css");' ] && continue

        [ -e "$file.niri-sync-backup" ] || cp -p "$file" "$file.niri-sync-backup"
        printf '@import url("dank-colors.css");\n' > "$file"
        echo "gtk css: $file -> dank-colors.css only"
    done
}

# DMS regenerates the Ghostty palette (themes/dankcolors) on light/dark and
# wallpaper changes, but Ghostty only rereads config/theme files on SIGUSR2.
ghostty_theme=$HOME/.config/ghostty/themes/dankcolors
ghostty_theme_hash=
reload_ghostty() {
    [ -f "$ghostty_theme" ] || return 0
    _g_hash=$(sha256sum "$ghostty_theme" 2>/dev/null | cut -d' ' -f1)
    [ -n "$_g_hash" ] || return 0
    if [ -n "$ghostty_theme_hash" ] && [ "$_g_hash" != "$ghostty_theme_hash" ]; then
        if pkill -USR2 -x ghostty 2>/dev/null; then
            echo "ghostty: theme changed, sent SIGUSR2"
        fi
    fi
    ghostty_theme_hash=$_g_hash
}

# Session-local terminal overrides.  i3 writes gruvbox palettes here; when
# niri is in charge, restore the DMS-generated palette.  Keeping the override
# in a separate file preserves the real DMS outputs (dankcolors/dank-theme)
# for the next niri/DMS run.
ghostty_session=$HOME/.config/ghostty/theme-session.conf
kitty_theme=$HOME/.config/kitty/dank-theme.conf
kitty_tabs=$HOME/.config/kitty/dank-tabs.conf
kitty_session_dir=$HOME/.config/kitty/theme-session.d
kitty_session=$kitty_session_dir/active.conf
kitty_theme_hash=
last_terminal_mode=

ensure_terminal_session() {
    case $mode in
        dark|light) ;;
        *) return 0 ;;
    esac

    changed=0

    want='theme = dankcolors'
    if [ "$(cat "$ghostty_session" 2>/dev/null)" != "$want" ]; then
        mkdir -p "$(dirname "$ghostty_session")"
        printf '%s\n' "$want" > "$ghostty_session"
        changed=1
    fi

    if [ -f "$kitty_theme" ]; then
        hash=$(cat "$kitty_tabs" "$kitty_theme" 2>/dev/null | sha256sum | cut -d' ' -f1)
        if [ -n "$hash" ] && { [ "$hash" != "$kitty_theme_hash" ] || [ ! -f "$kitty_session" ]; }; then
            mkdir -p "$kitty_session_dir"
            {
                [ -f "$kitty_tabs" ] && cat "$kitty_tabs"
                cat "$kitty_theme"
            } > "$kitty_session"
            changed=1
        fi
        kitty_theme_hash=$hash
    fi

    if [ "$changed" = 1 ] || [ "$mode" != "$last_terminal_mode" ]; then
        pkill -USR2 -x ghostty 2>/dev/null && echo "ghostty: session theme refreshed"
        pkill -USR1 -x kitty 2>/dev/null && echo "kitty: session theme refreshed"
    fi
    last_terminal_mode=$mode
}

# The GTK portal (Settings + FileChooser) reads the GTK settings at startup, so
# restart it on mode changes to keep the file dialog in the current theme.
last_mode=
restart_gtk_portal() {
    [ "$mode" = "$last_mode" ] && return 0
    if systemctl --user try-restart xdg-desktop-portal-gtk.service 2>/dev/null; then
        echo "restarted xdg-desktop-portal-gtk for $mode theme"
    fi
    last_mode=$mode
}

# KDE/Qt: apply DMS's generated color scheme so KDE apps follow light/dark.
# The tracked repo copy of kdeglobals is only a base template (stow ignores
# it); the live ~/.config/kdeglobals is a real file owned by this service.
dotfiles=${DOTFILES:-$HOME/.dotfiles}
kde_base=$dotfiles/kde/.config/kdeglobals
kde_live=$HOME/.config/kdeglobals
kde_scheme=
kde_scheme_hash=

ensure_kdeglobals() {
    if [ -L "$kde_live" ]; then
        # Migrate the stow symlink to a real file so applying a scheme does
        # not rewrite the tracked base.
        cp -L "$kde_live" "$kde_live.niri-sync" 2>/dev/null &&
            mv -f "$kde_live.niri-sync" "$kde_live" 2>/dev/null &&
            echo "kde theme: migrated $kde_live from stow symlink to real file"
    elif [ ! -e "$kde_live" ] && [ -r "$kde_base" ]; then
        cp "$kde_base" "$kde_live" 2>/dev/null &&
            echo "kde theme: seeded $kde_live from the tracked base"
    fi
}

apply_kde_scheme() {
    case $mode in
        dark)  scheme=DankMatugenDark ;;
        light) scheme=DankMatugenLight ;;
        *)     return 0 ;;
    esac

    file=$HOME/.local/share/color-schemes/$scheme.colors
    [ -r "$file" ] || return 0

    hash=$(sha256sum "$file" 2>/dev/null | cut -d' ' -f1)
    [ -n "$hash" ] || return 0
    [ "$scheme" = "$kde_scheme" ] && [ "$hash" = "$kde_scheme_hash" ] && return 0

    ensure_kdeglobals
    if command -v plasma-apply-colorscheme >/dev/null 2>&1; then
        if plasma-apply-colorscheme "$scheme" >/dev/null 2>&1; then
            echo "kde theme: applied $scheme"
            kde_scheme=$scheme
            kde_scheme_hash=$hash

            # The KDE portal caches its palette at startup; restart it so its
            # non-filechooser dialogs (the file chooser is routed to GTK)
            # repaint with the new scheme.
            if systemctl --user try-restart plasma-xdg-desktop-portal-kde.service 2>/dev/null; then
                echo "kde theme: restarted plasma-xdg-desktop-portal-kde"
            fi
        fi
    fi
}

while :; do
    mode=$(dms ipc call theme getMode 2>/dev/null) || mode=

    case $mode in
        dark)  want=prefer-dark;  gtk_dark=true ;;
        light) want=prefer-light; gtk_dark=false ;;
        *)     want=; gtk_dark= ;;
    esac

    if [ -n "$want" ]; then
        current=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null | tr -d "'")
        if [ "$current" != "$want" ]; then
            if gsettings set org.gnome.desktop.interface color-scheme "$want" 2>/dev/null; then
                echo "theme mode $mode: color-scheme $current -> $want"
            fi
        fi

        set_gtk_dark "$gtk_dark"
        restart_gtk_portal
        apply_kde_scheme
    fi

    set_gtk_css
    reload_ghostty
    ensure_terminal_session

    sleep 2
done
