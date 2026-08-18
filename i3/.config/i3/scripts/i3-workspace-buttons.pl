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
            for my $w (@$workspaces) {
                my $name = $w->{name} // "";
                if ( length($name) > 1 && $name =~ /[a-z]\z/i ) {
                    $w->{name} = substr( $name, 0, -1 );
                }
            }
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
