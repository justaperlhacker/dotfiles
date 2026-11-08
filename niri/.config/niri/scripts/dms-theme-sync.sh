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
    for file in "$HOME/.config/gtk-3.0/settings.ini" \
        "$HOME/.config/gtk-4.0/settings.ini"; do
        [ -f "$file" ] || continue

        current=$(sed -n 's/^gtk-application-prefer-dark-theme=//p' "$file" | tail -1)
        [ "$current" = "$dark" ] && continue

        if [ -n "$current" ]; then
            sed -i "s/^gtk-application-prefer-dark-theme=.*/gtk-application-prefer-dark-theme=$dark/" "$file"
        else
            printf 'gtk-application-prefer-dark-theme=%s\n' "$dark" >> "$file"
        fi
        echo "gtk theme: $file gtk-application-prefer-dark-theme=$dark"
    done
}

# Plasma's colors.css pins the Breeze color map to the last Plasma scheme, and
# older Matugen runs left a full dark palette inline in gtk.css. Neither
# follows DMS. Keep only the live DMS palette (dank-colors.css); the Breeze
# theme's own light/dark variant is selected by the prefer-dark flag above.
set_gtk_css() {
    for file in "$HOME/.config/gtk-3.0/gtk.css" \
        "$HOME/.config/gtk-4.0/gtk.css"; do
        [ -f "$file" ] || continue
        grep -qE 'Generated with Matugen|dank-colors\.css|colors\.css' "$file" || continue
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
    fi

    set_gtk_css
    reload_ghostty

    sleep 2
done
