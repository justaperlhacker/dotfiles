package I3Connect;
use v5.36;
use Exporter 'import';
use AnyEvent::I3;

our @EXPORT_OK = qw(
    i3_connect
    find_by_id
    find_first_workspace
    find_focused
    find_focused_workspace
    find_parent_of
    focused_workspace
    get_leaves
    has_modifier
    send_command
);

our %EXPORT_TAGS = ( all => [@EXPORT_OK] );

sub i3_connect() {
    my $dir = "$ENV{XDG_RUNTIME_DIR}/i3";
    if (opendir my $dh, $dir) {
        my @sockets = sort { (stat("$dir/$b"))[9] <=> (stat("$dir/$a"))[9] }
                      grep { /^ipc-socket\./ } readdir $dh;
        closedir $dh;
        return i3("$dir/$sockets[0]") if @sockets;
    }
    return i3();
}

sub find_focused($node) {
    return $node if $node->{focused};
    for my $child (($node->{nodes} // [])->@*, ($node->{floating_nodes} // [])->@*) {
        my $found = find_focused($child);
        return $found if $found;
    }
    return undef;
}

sub find_by_id($node, $id) {
    return $node if $node->{id} && $node->{id} == $id;
    for my $child (($node->{nodes} // [])->@*, ($node->{floating_nodes} // [])->@*) {
        my $found = find_by_id($child, $id);
        return $found if $found;
    }
    return undef;
}

sub find_parent_of($node, $id) {
    for my $child (($node->{nodes} // [])->@*) {
        return $node if $child->{id} && $child->{id} == $id;
        my $found = find_parent_of($child, $id);
        return $found if $found;
    }
    for my $child (($node->{floating_nodes} // [])->@*) {
        return $node if $child->{id} && $child->{id} == $id;
    }
    return undef;
}

sub get_leaves($node) {
    my @leaves;
    if ($node->{window}) {
        push @leaves, $node;
    }
    for my $child (($node->{nodes} // [])->@*, ($node->{floating_nodes} // [])->@*) {
        push @leaves, get_leaves($child);
    }
    return @leaves;
}

sub find_focused_workspace($workspaces) {
    for my $ws ($workspaces->@*) {
        return $ws if $ws->{focused};
    }
    return undef;
}

sub focused_workspace($i3) {
    my $workspaces = $i3->get_workspaces->recv;
    return find_focused_workspace($workspaces);
}

sub has_modifier($mask, $mod) {
    return 0 unless $mask;
    $mod = lc $mod;
    return 0 + grep { lc($_) eq $mod } $mask->@*;
}

sub send_command($i3, $cmd) {
    $i3->command($cmd)->cb(sub {
        my ($cv) = @_;
        my $reply = $cv->recv;
        for my $r (@$reply) {
            warn "i3 command failed: $cmd\n" unless $r->{success};
        }
    });
}

sub find_first_workspace($node) {
    if (($node->{type} // '') eq 'workspace' && $node->{nodes} && $node->{nodes}->@*) {
        return $node;
    }
    for my $child (($node->{nodes} // [])->@*) {
        my $found = find_first_workspace($child);
        return $found if $found;
    }
    return undef;
}

1;
