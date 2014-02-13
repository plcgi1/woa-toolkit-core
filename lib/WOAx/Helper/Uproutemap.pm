package WOAx::Helper::Uproutemap;
use strict;

use FindBin qw/$Bin/;
use base 'WOAx::Helper';

sub run {
    my ( $self, $namespace ) = @_;

    my $tpl = $self->tpl();
    
    my $app_name = $self->app_name;
    
    my $service_ns    = ucfirst $app_name . '::REST::' . $namespace;

    # recreate urlmapping config
    $self->update_route_map($tpl,$app_name,$service_ns);
    
    return;
}

1;

__END__

=head1 NAME

WOAx::Helper::Uproutemap

=head1 SYNOPSIS

=head1 DESCRIPTION

Helper for woa-toolkit - route map updater

=head2 EXPORT

TODO

=head1 SEE ALSO

woax-toolkit.pl -h


=head1 GIT repository

=begin html

<a href="https://github.com/plcgi1/woa-toolkit-core">https://github.com/plcgi1/woa-toolkit-core</a>

=end html



=head1 BUGS

Please report any bugs or suggestions at L<https://github.com/plcgi1/woa-toolkit-core>


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
