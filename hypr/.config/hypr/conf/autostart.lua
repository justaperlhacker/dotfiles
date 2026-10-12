-- Autostart: Noctalia, KDE/Qt session integration, tray apps.

hl.on("hyprland.start", function()
  hl.exec_cmd("dbus-update-activation-environment --systemd XDG_CURRENT_DESKTOP=Hyprland:KDE:gnome KDE_FULL_SESSION=true KDE_SESSION_VERSION=6 QT_QPA_PLATFORMTHEME=kde QT_STYLE_OVERRIDE=Breeze")

  -- KDE wallet (SDDM PAM already unlocks the wallet via pam_kwallet5)
  hl.exec_cmd("kwalletd6")
  hl.exec_cmd("/usr/lib/pam_kwallet_init")

  -- KDE polkit agent (Noctalia polkit_agent is disabled)
  hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")

  -- Tray/network applets (Hyprland has no native XDG autostart)
  hl.exec_cmd("nm-applet")
  hl.exec_cmd("blueman-applet")

  -- X11/Xwayland settings
  hl.exec_cmd("$HOME/.config/hypr/scripts/session-autostart.sh")

  -- Discord tray icon: wait for StatusNotifierWatcher, then launch
  hl.exec_cmd("$HOME/.config/hypr/scripts/exec-after-sni discord")

  -- Shell
  hl.exec_cmd("noctalia")
end)
