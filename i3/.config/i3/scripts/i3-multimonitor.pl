#!/usr/bin/env perl
use v5.36;
use warnings;
use FindBin qw($Bin);
use lib "$Bin";
use I3Connect qw(i3_connect find_focused_workspace has_modifier send_command);
use AnyEvent;

my %KEYS = map { $_ => $_ } 1 .. 8;
my %MONITOR_SUFFIX = (
    "HDMI-A-1"    => "a",
    "DisplayPort-3" => "b",
);

my $i3 = i3_connect();
$i3->connect->recv or die "Failed to connect to i3";

my $pending = 0;

sub on_binding($msg) {
    my $binding = $msg->{binding} or return;
    return unless $binding->{command} eq 'nop';
    my $local_index = $KEYS{$binding->{symbol}};
    return unless defined $local_index;
    return if $pending;

    $pending = 1;
    $i3->get_workspaces->cb(sub {
        my ($cv) = @_;
        $pending = 0;
        my $workspaces = $cv->recv;
        my $focused = find_focused_workspace($workspaces);
        return unless $focused;

        my $suffix = $MONITOR_SUFFIX{$focused->{output}};
        return unless defined $suffix;

        my $target = "$local_index$suffix";
        return if $target eq ($focused->{name} // '');

        my $mask = $binding->{event_state_mask};
        my $command;
        if (has_modifier($mask, 'ctrl')) {
            $command = "move container to workspace $target";
        } elsif (has_modifier($mask, 'shift')) {
            $command = "move container to workspace $target; workspace $target";
        } else {
            $command = "workspace $target";
        }
        send_command($i3, $command);
    });
}

my %callbacks = (
    binding  => \&on_binding,
    shutdown => sub { exit 0 if ($_[0]{change} // '') eq 'restart' },
    _error   => sub { warn "i3 connection lost\n"; exit 1 },
);

my $reply = $i3->subscribe(\%callbacks)->recv;
die "Failed to subscribe to i3 events\n" unless $reply->{success};

AE::cv->recv;
