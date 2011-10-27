package WOA::Component::ACL;
use strict;
use parent 'Class::Accessor::Fast';
use Data::Dumper;

__PACKAGE__->mk_accessors(qw//);

sub check_access {
    my ( $self, $method, $method_data, $user_data, $request, $env ) = @_;
    if ( $method_data->{public} && $method_data->{public} eq 1 ) {
        return 1;
    }
    if ( $user_data && ref $user_data eq 'HASH' && $user_data->{id} ) {
        my $acl    = $user_data->{acl};
        my $access = 0;

        #   acl - { path => [POST, GET, PUT, DELETE] }
        if ($acl) {
            my $path = $request->request_uri;
            if ( $request->method =~ /get|delete|post|put/i ) {
                $path = ( split '\?', $path )[0];
            }
            my $re = qr|$method_data->{regexp}|;

            if ( $acl->{$path} && $path =~ /$re/ ) {
                my $access_count = 0;
                foreach ( @{ $acl->{$path} } ) {
                    if ( $_ eq $method_data->{req_method} ) {
                        $access = 1;
                        last;
                    }
                }
            }
        }
        return $access;
    }
    return;
}

1;

__END__

=head1 NAME

WOAx::Component::ACL

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

TODO

=head1 SEE ALSO

TODO


=head1 GIT repository

=begin html

<a href="https://github.com/plcgi1/woa-toolkit-core">https://github.com/plcgi1/woa-toolkit-core</a>

=end html


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
