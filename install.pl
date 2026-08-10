#!/usr/bin/env perl
use strict;
use warnings;

use Cwd qw(abs_path);
use File::Basename qw(dirname basename);
use File::Find;
use File::Path qw(make_path);
use Getopt::Long;
use POSIX qw(strftime);

Getopt::Long::Configure(qw(no_ignore_case));

my $DOTFILES = abs_path(dirname($0)) || die "cannot resolve dotfiles dir\n";
my $TARGET   = $ENV{HOME};
my $BACKUP_ROOT = "$DOTFILES/.backup";
my $BACKUP_DIR  = "$BACKUP_ROOT/" . strftime('%Y%m%d-%H%M%S', localtime);

my $all      = 0;
my $list     = 0;
my $help     = 0;
my @packages;

GetOptions(
    'all|a'       => \$all,
    'package|p=s@' => \@packages,
    'list|l'      => \$list,
    'help|h'      => \$help,
) or usage_error();

sub usage_error {
    print STDERR usage();
    exit 2;
}

sub usage {
    return <<"EOF";
Usage: install.pl [OPTIONS]

Stow packages from this repo into your home directory. Any existing
file or directory that would be clobbered is first moved into a backup.

Options:
  -a, --all             Stow every package in the repo
  -p, --package NAME    Stow only the named package (repeatable)
  -l, --list            List available packages and exit
  -h, --help            Show this help and exit

Examples:
  install.pl --all
  install.pl --package bash --package nvim --package i3
  install.pl --list

Backups are stored under $BACKUP_ROOT/<timestamp>/
EOF
}

sub find_packages {
    my @pkgs;
    opendir my $dh, $DOTFILES or die "cannot read $DOTFILES: $!\n";
    for my $name (readdir $dh) {
        next if $name =~ /^[._]/;
        push @pkgs, $name if -d "$DOTFILES/$name";
    }
    closedir $dh;
    return sort @pkgs;
}

if ($help) {
    print usage();
    exit 0;
}

if ($list) {
    my @pkgs = find_packages();
    if (@pkgs) {
        print join("\n", @pkgs), "\n";
    } else {
        print "(no packages found in $DOTFILES)\n";
    }
    exit 0;
}

if ($all && @packages) {
    print STDERR "error: --all and --package cannot be used together\n";
    usage_error();
}

my @pkgs;
if ($all) {
    @pkgs = find_packages();
    die "error: no packages found in $DOTFILES\n" unless @pkgs;
} elsif (@packages) {
    @pkgs = @packages;
} else {
    usage_error();
}

for my $p (@pkgs) {
    die "error: unknown package '$p' (no directory $DOTFILES/$p)\n" unless -d "$DOTFILES/$p";
}

my @conflicts;

sub is_stowed {
    my ($path) = @_;
    return 0 unless -l $path;
    my $resolved = abs_path($path);
    return defined $resolved && $resolved =~ m{^\Q$DOTFILES\E(?:/|$)};
}

# True if $path sits under a stow-managed symlink, i.e. it is already
# covered by a folded directory and must never be backed up or clobbered.
sub has_stowed_ancestor {
    my ($path) = @_;
    while ($path ne $TARGET) {
        my $parent = dirname($path);
        return 1 if is_stowed($parent);
        $path = $parent;
    }
    return 0;
}

sub collect_conflicts {
    my ($pkg) = @_;
    my $pkgdir  = "$DOTFILES/$pkg";
    my $prefix  = "$pkgdir/";
    my $wanted  = sub {
        my $full = $File::Find::name;
        return if $full eq $pkgdir;
        my $rel    = substr($full, length($prefix));
        my $target = "$TARGET/$rel";
        return if has_stowed_ancestor($target);
        if (-l $target) {
            push @conflicts, $target unless is_stowed($target);
            return;
        }
        if (-e $target) {
            return if -d $full && -d $target;
            push @conflicts, $target;
        }
    };
    find({ wanted => $wanted, no_chdir => 1 }, $pkgdir);
}

for my $p (@pkgs) {
    collect_conflicts($p);
}

if (@conflicts) {
    make_path($BACKUP_DIR);
    print "Backing up ", scalar(@conflicts), " existing item(s) to $BACKUP_DIR:\n";
    for my $c (@conflicts) {
        my $rel  = substr($c, length("$TARGET/"));
        my $dest = "$BACKUP_DIR/$rel";
        make_path(dirname($dest));
        rename($c, $dest) or die "error: failed to back up $c: $!\n";
        print "  $c -> $dest\n";
    }
} else {
    print "No conflicts to back up.\n";
}

print "Stowing: @pkgs\n";
system('stow', '-d', $DOTFILES, '-t', $TARGET, @pkgs) == 0
    or die "error: stow failed (exit ", ($? >> 8), ")\n";

print "Done. Backups in: $BACKUP_DIR\n";
