-- Keybinds: niri muscle memory + Noctalia IPC + KDE apps.

local MOD = "SUPER"
local ipc = "noctalia msg "

-- Noctalia surfaces
hl.bind(MOD .. " + Space", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(MOD .. " + D", hl.dsp.exec_cmd(ipc .. "panel-toggle launcher"))
hl.bind(MOD .. " + Comma", hl.dsp.exec_cmd(ipc .. "settings-toggle"))
hl.bind(MOD .. " + V", hl.dsp.exec_cmd(ipc .. "panel-toggle clipboard"))
hl.bind(MOD .. " + N", hl.dsp.exec_cmd(ipc .. "panel-toggle notifications"))
hl.bind(MOD .. " + X", hl.dsp.exec_cmd(ipc .. "panel-toggle session"))
hl.bind(MOD .. " + Y", hl.dsp.exec_cmd(ipc .. "panel-toggle wallpaper"))
hl.bind(MOD .. " + M", hl.dsp.exec_cmd("plasma-systemmonitor"))
hl.bind(MOD .. " + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))
hl.bind("ALT + Tab", hl.dsp.exec_cmd(ipc .. "window-switcher hold"))
hl.bind(MOD .. " + ALT + L", hl.dsp.exec_cmd(ipc .. "session lock"))

-- Terminal + scratchpads
hl.bind(MOD .. " + T", hl.dsp.exec_cmd([[sh -c 'test -n "$TERMINAL" && exec "$TERMINAL" || exec konsole']]))
hl.bind(MOD .. " + grave", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-tmux --terminal kitty --session work --class kitty --title work"))
hl.bind(MOD .. " + F9", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-tmux --terminal konsole --session opencode --cmd opencode --class org.kde.konsole --title opencode"))
hl.bind(MOD .. " + SHIFT + F9", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-tmux --terminal konsole --session kilo --cmd kilo --class org.kde.konsole --title kilo"))
hl.bind(MOD .. " + F11", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-tmux --terminal kitty --session dgop --cmd dgop --class kitty --title dgop"))
hl.bind(MOD .. " + SHIFT + F11", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-tmux --terminal konsole --session htop --cmd htop --class org.kde.konsole --title htop"))
hl.bind(MOD .. " + F12", hl.dsp.exec_cmd("yakuake"))
hl.bind(MOD .. " + CTRL + period", hl.dsp.exec_cmd("$HOME/.config/hypr/scripts/toggle-float-center"))

-- Scrolling: focus
hl.bind(MOD .. " + H", hl.dsp.layout("focus l"))
hl.bind(MOD .. " + L", hl.dsp.layout("focus r"))
hl.bind(MOD .. " + J", hl.dsp.focus({ direction = "down" }))
hl.bind(MOD .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(MOD .. " + Left", hl.dsp.layout("focus l"))
hl.bind(MOD .. " + Right", hl.dsp.layout("focus r"))
hl.bind(MOD .. " + Up", hl.dsp.focus({ direction = "up" }))
hl.bind(MOD .. " + Down", hl.dsp.focus({ direction = "down" }))

-- Scrolling: move / expel
hl.bind(MOD .. " + SHIFT + H", hl.dsp.layout("swapcol l"))
hl.bind(MOD .. " + SHIFT + L", hl.dsp.layout("swapcol r"))
hl.bind(MOD .. " + SHIFT + J", hl.dsp.layout("movewindowto d"))
hl.bind(MOD .. " + SHIFT + K", hl.dsp.layout("movewindowto u"))
hl.bind(MOD .. " + SHIFT + Left", hl.dsp.layout("swapcol l"))
hl.bind(MOD .. " + SHIFT + Right", hl.dsp.layout("swapcol r"))
hl.bind(MOD .. " + SHIFT + Up", hl.dsp.layout("movewindowto u"))
hl.bind(MOD .. " + SHIFT + Down", hl.dsp.layout("movewindowto d"))
hl.bind(MOD .. " + bracketleft", hl.dsp.layout("consume"))
hl.bind(MOD .. " + bracketright", hl.dsp.layout("expel"))
hl.bind(MOD .. " + period", hl.dsp.layout("expel"))

-- Scrolling: resize / fit
hl.bind(MOD .. " + R", hl.dsp.layout("colresize +conf"))
hl.bind(MOD .. " + equal", hl.dsp.layout("colresize +0.1"))
hl.bind(MOD .. " + minus", hl.dsp.layout("colresize -0.1"))
hl.bind(MOD .. " + C", hl.dsp.layout("fit active"))
hl.bind(MOD .. " + CTRL + C", hl.dsp.layout("fit visible"))
hl.bind(MOD .. " + CTRL + F", hl.dsp.layout("fit expand"))

-- Scrolling: maximize / fullscreen / tabbed column (group)
hl.bind(MOD .. " + F", hl.dsp.window.fullscreen({ mode = "maximized", action = "toggle", window = "activewindow" }))
hl.bind(MOD .. " + SHIFT + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle", window = "activewindow" }))
hl.bind(MOD .. " + W", hl.dsp.exec_cmd("hyprctl dispatch togglegroup"))

-- Floating toggle
hl.bind(MOD .. " + SHIFT + T", hl.dsp.window.float({ action = "toggle" }))
hl.bind(MOD .. " + SHIFT + V", hl.dsp.window.float({ action = "toggle" }))

-- Workspaces
for i = 1, 9 do
  hl.bind(MOD .. " + " .. i, hl.dsp.focus({ workspace = i }))
  hl.bind(MOD .. " + SHIFT + " .. i, hl.dsp.window.move({ workspace = i }))
end
hl.bind(MOD .. " + I", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MOD .. " + U", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(MOD .. " + Page_Up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MOD .. " + Page_Down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(MOD .. " + CTRL + I", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(MOD .. " + CTRL + U", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(MOD .. " + CTRL + Page_Up", hl.dsp.window.move({ workspace = "e+1" }))
hl.bind(MOD .. " + CTRL + Page_Down", hl.dsp.window.move({ workspace = "e-1" }))
hl.bind(MOD .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(MOD .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))

-- Monitor focus / move (exec_cmd for robust dispatchers)
hl.bind(MOD .. " + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch focusmonitor l"))
hl.bind(MOD .. " + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch focusmonitor r"))
hl.bind(MOD .. " + CTRL + K", hl.dsp.exec_cmd("hyprctl dispatch focusmonitor u"))
hl.bind(MOD .. " + CTRL + J", hl.dsp.exec_cmd("hyprctl dispatch focusmonitor d"))
hl.bind(MOD .. " + CTRL + Left", hl.dsp.exec_cmd("hyprctl dispatch focusmonitor l"))
hl.bind(MOD .. " + CTRL + Right", hl.dsp.exec_cmd("hyprctl dispatch focusmonitor r"))
hl.bind(MOD .. " + SHIFT + CTRL + H", hl.dsp.exec_cmd("hyprctl dispatch movewindowmonitor l"))
hl.bind(MOD .. " + SHIFT + CTRL + L", hl.dsp.exec_cmd("hyprctl dispatch movewindowmonitor r"))
hl.bind(MOD .. " + CTRL + SHIFT + Left", hl.dsp.exec_cmd("hyprctl dispatch movewindowmonitor l"))
hl.bind(MOD .. " + CTRL + SHIFT + Right", hl.dsp.exec_cmd("hyprctl dispatch movewindowmonitor r"))

-- Window management
hl.bind(MOD .. " + Q", hl.dsp.window.close())
hl.bind(MOD .. " + SHIFT + E", hl.dsp.exit())
hl.bind(MOD .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(MOD .. " + SHIFT + P", hl.dsp.exec_cmd("hyprctl dispatch dpms toggle"))

-- Mouse drag/resize
hl.bind(MOD .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(MOD .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Screenshots (Noctalia)
hl.bind("Print", hl.dsp.exec_cmd(ipc .. "screenshot-region"))
hl.bind("ALT + Print", hl.dsp.exec_cmd(ipc .. "screenshot-region"))
hl.bind("CTRL + Print", hl.dsp.exec_cmd(ipc .. "screenshot-fullscreen"))

-- Media keys
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
