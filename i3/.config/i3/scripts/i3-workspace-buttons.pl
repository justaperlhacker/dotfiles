#!/usr/bin/env perl
use v5.36;
use warnings;
use utf8;
use IO::Handle qw();
use FindBin    qw($Bin);
use lib "$Bin", "$ENV{HOME}/.config/i3/scripts";
use I3Connect qw(i3_connect);

STDOUT->autoflush(1);

use AnyEvent;
use JSON::XS qw(encode_json);

my $i3 = i3_connect();
$i3->connect->recv or die "Failed to connect to i3";

sub emit_workspaces {
    $i3->get_workspaces->cb(
        sub {
            my ($cv) = @_;
            my $workspaces = $cv->recv;
            # NOTE: names are passed through unmodified. A previous version
            # stripped the per-monitor suffix (1a -> 1) for display, but
            # i3bar activates buttons by the displayed name, so clicking "1"
            # created/switched to a phantom workspace literally named "1".
            say encode_json($workspaces);
        }
    );
}

my %callbacks = (
    workspace => sub { emit_workspaces() },
    output    => sub { emit_workspaces() },
);

$i3->subscribe( \%callbacks )->recv;

emit_workspaces();

AE::cv->recv;
