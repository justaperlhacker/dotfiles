-- Window rules + layer rules.

-- Noctalia settings window floats.
hl.window_rule({
  name = "noctalia-settings-float",
  match = { class = "dev\\.noctalia\\.Noctalia" },
  float = true,
  size = { 1080, 920 },
})

-- Always-floating utilities / dialogs.
hl.window_rule({ name = "calc", match = { class = "^(org\\.gnome\\.Calculator|gnome-calculator|galculator|qalculate-gtk)$" }, float = true })
hl.window_rule({ name = "blueman", match = { class = "blueman-manager" }, float = true })
hl.window_rule({ name = "nautilus", match = { class = "^(org\\.gnome\\.Nautilus|nautilus)$" }, float = true })
hl.window_rule({ name = "xdg-portal", match = { class = "xdg-desktop-portal" }, float = true })
hl.window_rule({ name = "kwallet", match = { title = "(?i).*kwallet.*" }, float = true, size = { 800, 600 }, center = true })
hl.window_rule({ name = "pinentry", match = { class = "^(pinentry|org\\.kde\\.kwalletd6)$" }, float = true })
hl.window_rule({ name = "yakuake", match = { class = "^(org\\.kde\\.yakuake|yakuake)$" }, float = true })
hl.window_rule({ name = "wfica", match = { class = "^(wfica|icaclient)$" }, float = true })
hl.window_rule({ name = "bitwarden", match = { class = "(?i)bitwarden" }, float = true })
hl.window_rule({ name = "system-monitor", match = { title = "^System Monitor$" }, float = true })
hl.window_rule({ name = "variety", match = { class = "(?i)variety" }, float = true })
hl.window_rule({ name = "onedrive-gui", match = { title = "(?i)^onedrivegui$" }, float = true })
hl.window_rule({ name = "steam-toasts", match = { class = "steam", title = "^notificationtoasts_" }, float = true, pin = true, no_focus = true })
hl.window_rule({ name = "firefox-pip", match = { class = "firefox", title = "^Picture-in-Picture$" }, float = true })
hl.window_rule({ name = "zoom", match = { class = "zoom" }, float = true })

-- Fix XWayland drag issues.
hl.window_rule({
  name = "fix-xwayland-drags",
  match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
  no_focus = true,
})

-- Noctalia blur for bar/panels/dock/notifications.
hl.layer_rule({
  name = "noctalia",
  match = { namespace = "^noctalia-(bar-.+|notification|dock|panel|attached-panel|osd|window-switcher)$" },
  no_anim = true,
  ignore_alpha = 0.5,
  blur = true,
  blur_popups = true,
})
