package WOA::Component::Notify;
use strict;

use WOA::Loader qw(import_module create_object);

sub create_and_run {
    my $class = shift;
    my %opt   = @_;

    my $module = join '::', ( __PACKAGE__, $opt{type} );

    import_module($module);

    my $object = create_object( $module, %{ $opt{param} } );

    $object->process();

    return $object;
}

1;

__END__

=head1 NAME

WOAx::Component::Notify

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
