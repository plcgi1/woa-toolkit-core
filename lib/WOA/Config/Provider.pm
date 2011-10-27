package WOA::Config::Provider;
use strict;
use Config::General;
use base 'Class::Accessor::Fast';

sub get_config {
    my ( $self, $paths, $dont_check_mode ) = @_;
    my $config;
    if ($paths) {
        if ( ref $paths ne 'ARRAY' ) {
            $paths = [$paths];
        }
        my %config;
        foreach ( @{$paths} ) {
            my %cfg = Config::General->new(
                -InterPolateVars => 1,
                -ConfigFile      => $_
            )->getall();
            %config = %cfg;
        }

        if ($dont_check_mode) {
            $config = \%config;
        }
        else {
            my $mode = $ENV{APP_MODE} || $config{mode};
            if ($mode) {
                $config = $config{$mode};
            }
            else {
                $config = \%config;
            }
        }
    }
    return $config;
}

1;

__END__


=head1 NAME

WOA::Config::Provider - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]


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
