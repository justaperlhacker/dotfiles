-- Session environment: KDE/Qt integration + Wayland hints.

hl.env("XCURSOR_THEME", "Qogir-Recolored-Gruvbox-Orange")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_SIZE", "24")

hl.env("XDG_CURRENT_DESKTOP", "Hyprland:KDE:gnome")
hl.env("KDE_FULL_SESSION", "true")
hl.env("KDE_SESSION_VERSION", "6")

hl.env("QT_QPA_PLATFORMTHEME", "kde")
hl.env("QT_STYLE_OVERRIDE", "Breeze")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")

hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("TERMINAL", "kitty")
