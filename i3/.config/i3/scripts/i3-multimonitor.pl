#!/usr/bin/env perl
# i3-multimonitor.pl — per-monitor workspaces driven by hostname-aware config
#
# Config file: ~/.config/i3/monitors/monitors.conf
#
# Format:
#   [blackslate]
#   eDP-1 = a
#   HDMI-A-1 = b
#
#   [destro]
#   HDMI-A-1 = a
#   DisplayPort-3 = b
#
#   [default]
#   HDMI-A-1 = a
#   DisplayPort-3 = b
#
# Each section key is a hostname. Values map output names to workspace suffixes.
# The current hostname section is used; falls back to [default].
# For [default], unmapped connected outputs are auto-assigned suffixes (a, b, c...).

use v5.36;
use warnings;
use FindBin qw($Bin);
use lib "$Bin";
use I3Connect qw(i3_connect find_focused_workspace has_modifier);
use AnyEvent;
use Sys::Hostname;

my $CONFIG = "$ENV{HOME}/.config/i3/monitors/monitors.conf";

my %MONITOR_SUFFIX;

sub read_monitor_config($path) {
    my %config;
    my $section = 'default';

    if (open my $fh, '<', $path) {
        while (my $line = <$fh>) {
            chomp $line;
            $line =~ s/\s*#.*$//;
            $line =~ s/^\s+//;
            next if $line =~ /^$/;

            if ($line =~ /^\[(.+?)\]\s*$/) {
                $section = $1;
                next;
            }

            if ($line =~ /^\s*(.+?)\s*=\s*(.+?)\s*$/) {
                my ($output, $suffix) = ($1, $2);
                $config{$section}{$output} = $suffix;
            }
        }
        close $fh;
    }
    return \%config;
}

sub auto_assign_suffixes($config, $host) {
    my %suffixes;

    # Collect explicitly configured suffixes first
    for my $section ($host, 'default') {
        next unless exists $config->{$section};
        for my $output (keys $config->{$section}->%*) {
            $suffixes{$output} = $config->{$section}{$output};
        }
    }

    # If we're falling back to default and have unmapped outputs,
    # auto-assign suffixes a, b, c... to connected outputs
    if (!exists $config->{$host} && exists $config->{default}) {
        my $suffix = ord('a');
        my @connected = `xrandr --query 2>/dev/null | awk '/ connected/ {print \$1}'`;
        chomp @connected;
        for my $output (@connected) {
            next if exists $suffixes{$output};
            $suffixes{$output} = chr($suffix++);
        }
    }

    return \%suffixes;
}

sub send_command($i3, $cmd) {
    my $cv = $i3->command($cmd);
    $cv->cb(sub {
        my ($cv) = @_;
        my $reply = $cv->recv;
        if ($reply) {
            for my $r (@$reply) {
                warn "i3 command FAILED: $cmd\n" unless $r->{success};
            }
        } else {
            warn "i3 command no reply: $cmd\n";
        }
    });
}

my $host = hostname();
my $cfg = read_monitor_config($CONFIG);
my $suffixes = auto_assign_suffixes($cfg, $host);

%MONITOR_SUFFIX = %$suffixes;

my %KEYS = map { $_ => $_ } 1 .. 8;

my $i3 = i3_connect();
$i3->connect->recv or die "Failed to connect to i3";

my $pending = 0;

sub on_binding($msg) {
    my $binding = $msg->{binding} or return;
    return unless $binding->{command} eq 'nop';
    my $local_index = $KEYS{ $binding->{symbol} };
    return if $pending;
    return unless defined $local_index || $binding->{symbol} eq 'b';

    $pending = 1;
    $i3->get_workspaces->cb(
        sub {
            my ($cv) = @_;
            $pending = 0;
            my $workspaces = $cv->recv;
            my $focused    = find_focused_workspace($workspaces);
            return unless $focused;

            my $suffix = $MONITOR_SUFFIX{ $focused->{output} };
            return unless defined $suffix;

            my $mask = $binding->{event_state_mask};
            my $command;

            if ( $binding->{symbol} eq 'b' ) {
                # $mod+Shift+b: move the focused window to the same-index
                # workspace on the other monitor
                return unless has_modifier( $mask, 'shift' );
                my ($index) = $focused->{name} =~ /(\d+)/;
                return unless defined $index;
                my $other_suffix = $suffix eq 'a' ? 'b' : 'a';
                my $target       = "$index$other_suffix";
                $command = "move container to workspace $target; workspace $target";
            }
            else {
                my $target = "$local_index$suffix";
                return if $target eq ( $focused->{name} // '' );

                if ( has_modifier( $mask, 'ctrl' ) && has_modifier( $mask, 'shift' ) ) {
                    my $other_suffix = $suffix eq 'a' ? 'b' : 'a';
                    my $target = "$local_index$other_suffix";
                    $command = "move container to workspace $target; workspace $target";
                }
                elsif ( has_modifier( $mask, 'ctrl' ) ) {
                    my $target = "$local_index$suffix";
                    $command = "move container to workspace $target";
                }
                elsif ( has_modifier( $mask, 'shift' ) ) {
                    my $target = "$local_index$suffix";
                    $command = "move container to workspace $target; workspace $target";
                }
                else {
                    my $target = "$local_index$suffix";
                    $command = "workspace $target";
                }
            }
            warn "CMD: $command\n";
            send_command( $i3, $command );
        }
    );
}

my %callbacks = (
    binding  => \&on_binding,
    shutdown => sub { exit 0 if ( $_[0]{change} // '' ) eq 'restart' },
    _error   => sub { warn "i3 connection lost\n"; exit 1 },
);

my $reply = $i3->subscribe( \%callbacks )->recv;
die "Failed to subscribe to i3 events\n" unless $reply->{success};

AE::cv->recv;
