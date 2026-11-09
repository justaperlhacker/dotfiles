#!/usr/bin/env perl
# PATH-friendly entry point for i3bar's workspace_command.
# i3's docs only guarantee shell/env expansion for `include`; a bare command
# found through PATH avoids relying on $HOME in the i3 config.
exec "$ENV{HOME}/.config/i3/scripts/i3-workspace-buttons.pl", @ARGV;
