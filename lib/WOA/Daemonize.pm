package WOA::Daemonize;
use strict;
use Carp qw/croak/;
use base 'Class::Accessor::Fast';
use POSIX;

sub daemonize {
    my $self = shift;
    my $stderr_log_file = shift;
    my $pid_file_name = shift;
    
    my @fh = ( \*STDIN, \*STDOUT );

    open (\*STDERR, ">$stderr_log_file");
    select( ( select( \*STDERR ), $| = 1 )[0] );

    my $ppid = $$;

    $SIG{'HUP'} = 'IGNORE';    
    my $pid = fork;
    if( $pid ){
        exit(0);
    }

    !defined $pid && croak "No Fork: ", $!;

    while ( kill 0, $ppid ) {
        select undef, undef, undef, .001;
    }

    my $session_id = POSIX::setsid();
    chdir '/' || croak "Could not cd to /", $!;
    my $oldmask = umask 00;
    close $_ || croak $! for @fh;

    return;
}

sub daemonize2 {
    my ($self,$user,$pid_file) = @_;
    
    my $euid = POSIX::geteuid();

    ## default current user
    my ($uid, $gid) = ($euid, POSIX::getegid());
    
    if ( defined($user) )  {
        ($uid, $gid) = (getpwnam( $user ))[2,3]	or
            die "Unable to determine uid/gid for $user\n";

        if ( $euid != 0  &&  $uid != $euid ) {
            die "Can't drop privileges as uid $euid to $uid:$gid \n";
        }
    }

    chdir '/'                 or die "Can't chdir to /: $!";
    defined(my $pid = fork)   or die "Can't fork: $!";

    if ( $pid ) {
        open(PIDF, ">$pid_file") or die "$!";
        print PIDF "$pid\n";
        close(PIDF);
        exit(0);
    }
    
    POSIX::setsid()           or die "Can't start a new session: $!";
    POSIX::setgid($gid)       or die "Unable to change gid: $!\n";
    POSIX::setuid($uid)       or die "Unable to change uid: $!\n";
    
    if ( $pid ) {
        open(PIDF, ">$pid_file") or die "$!";
        print PIDF "$pid\n";
        close(PIDF);
        exit(0);
    }
     
    print "Working in background, pid=$$\n"; 

    open STDIN, '/dev/null'   or die "Can't read /dev/null: $!";
    open STDOUT, '>/dev/null' or die "Can't write to /dev/null: $!";
    open STDERR, '>&STDOUT'   or die "Can't dup stdout: $!";
    
    return;
}

sub write_pid_file {
    my $self = shift;
    my $fname = shift or return;
    my $pid = shift; 
    if (!open PIDFILE, ">$fname") {
        warn("open: $fname: $!");
        return;
    }
    print PIDFILE $pid."\n";
    close PIDFILE;
    
    return;
}

sub remove_pid_file {
    my $self = shift;
    my $fname = shift or return;
    my $ret = unlink($fname) or warn("unlink: $fname: $!");
    return $ret;
}

1;

__END__


=head1 WOA::Daemonize

=head1 SYNOPSIS

[TODO]

=head1 DESCRIPTION

Run your process in background

=head2 EXPORT

=head3 daemonize

=head3 daemonize2

=head3 write_pid_file

=head3 remove_pid_file

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut