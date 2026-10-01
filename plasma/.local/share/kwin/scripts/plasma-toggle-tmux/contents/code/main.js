/*
 * plasma-toggle-tmux -- KWin script binding SUPER+F9 to a niri-style tmux
 * scratchpad, mirroring niri's Mod+F9 ("OpenCode") binding.
 *
 * KWin JavaScript cannot spawn processes, so each binding just asks systemd
 * to start the matching template unit; the unit runs the Perl helper
 * (plasma-toggle-tmux) which performs the actual toggle.
 *
 * Add more scratchpads by appending to `sessions` and rebinding in
 * System Settings -> Shortcuts -> KWin if the default key is taken.
 */
var sessions = [
    { key: "Meta+F9", session: "opencode" },
    { key: "Meta+\\", session: "work" }
    // { key: "Meta+Shift+F9", session: "kilo" },
    // { key: "Meta+F11",      session: "dgop" },
    // { key: "Meta+Shift+F11", session: "htop" },
];

function trigger(session) {
    callDBus("org.freedesktop.systemd1",
             "/org/freedesktop/systemd1",
             "org.freedesktop.systemd1.Manager",
             "StartUnit",
             "plasma-toggle-tmux@" + session + ".service",
             "replace");
}

for (var i = 0; i < sessions.length; i++) {
    var s = sessions[i];
    registerShortcut("Plasma Toggle Tmux: " + s.session,
                     "Toggle " + s.session + " scratchpad",
                     s.key,
                     (function (session) {
                         return function () { trigger(session); };
                     })(s.session));
}
