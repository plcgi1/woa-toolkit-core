package WOA::Component::RealIP;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/env debug/);
__PACKAGE__->follow_best_practice();

my $x3  = 256**3;
my $x2  = 256**2;
my $x   = 256;

sub ip2int {
    my $self = shift;
    return _ip2int(shift);
}

sub _ip2int {
    my $ip      = shift;
    
    my ($a,$b,$c,$d) = split '\.',$ip;
    # 256³*a+256²*b+256*c+d
    my $int = int($x3 * $a + $x2 * $b + $x * $c + $d);
    
    return $int;
}

sub _check_ip {
    my $self    = shift;
    my $ip      = shift;
    my $res;
    if( defined $ip ){
        unless ($ip =~/^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/) {
            return undef ;
        }
    
        if (defined $self->{debug}) {
            return 1;
        }
        
        my $ip_int = _ip2int ($ip);
        
        if( defined $ip && $ip_int > 0 ){
            my $private_ips = [
                ['0.0.0.0','2.255.255.255'],
                ['10.0.0.0','10.255.255.255'],
                ['127.0.0.0','127.255.255.255'],
                ['169.254.0.0','169.254.255.255'],
                ['172.16.0.0','172.31.255.255'],
                ['192.0.2.0','192.0.2.255'],
                ['192.168.0.0','192.168.255.255'],
                ['255.255.255.0','255.255.255.255']
            ];
            foreach my $r ( @$private_ips ) {
                my $min = _ip2int ($r->[0]);
                my $max = _ip2int ($r->[1]);
                
                my $rule = (
                    ( $ip_int >= $min )
                    && ( $ip_int <= $max )
                );
                
                if ( $rule ) {
                    undef $res;
                    last;
                }
                else {
                    $res = 1;
                }
            } # foreach my $r ( @$private_ips )
        } # END if( defined $ip && $ip_obj->intip > 0 )
    }
    return $res;
}

sub real_ip {
    my $self    = shift;
    
    my $res_ip;
    my $env = $self->{env};
    
    my @header_names = qw/
        HTTP_CLIENT_IP
        HTTP_X_FORWARDED
        HTTP_X_CLUSTER_CLIENT_IP
        HTTP_FORWARDED_FOR
        HTTP_FORWARDED
        HTTP_X_REAL_IP
    /;
    foreach ( @header_names ) {
        if ( $self->_check_ip($env->{$_} ) ) {
            $res_ip = $env->{$_};
            last;
        }
    }
    unless ( defined $res_ip ){
        if( defined $env->{"HTTP_X_FORWARDED_FOR"} ){
            my @arr = split ',',$env->{"HTTP_X_FORWARDED_FOR"};
            foreach ( @arr ) {
                if ( $self->_check_ip( $_ )) {
                    $res_ip = $arr[0];
                }
                else {
                    undef $res_ip;
                    last;
                }
            } # END foreach ( @arr )
        } # END if( defined $env->{"HTTP_X_FORWARDED_FOR"} )
        unless ( defined $res_ip ){
            $res_ip = $self->_check_ip( $env->{REMOTE_ADDR} ) ? $env->{REMOTE_ADDR} : undef;
        }
    }
    return $res_ip;
}

1;

__END__

=head1 WOAx::Component::RealIP

=head1 SYNOPSIS

my $rip = WOAx::Component::RealIP->new({
    env     => %ENV,
    debug   => 1
});
my $real_ip = $rip->real_ip();
print $real_ip;

=head1 DESCRIPTION

Utils funcs for work with ip addresses

=head2 EXPORT

=head3 ip2int


=head3 real_ip


=head1 SEE ALSO

TODO

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut