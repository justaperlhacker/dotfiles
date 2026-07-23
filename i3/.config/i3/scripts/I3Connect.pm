package I3Connect;
use v5.36;
use Exporter 'import';
use AnyEvent::I3;

our @EXPORT_OK = qw(i3_connect);

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

1;
