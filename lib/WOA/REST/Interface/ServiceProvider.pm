package WOA::REST::Interface::ServiceProvider;
use strict;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->follow_best_practice();
__PACKAGE__->mk_accessors(qw/backend engine map view localize session model config formatter stash/);

sub pre_process {
    die "pre_process not implemented";
}

sub post_process {
    die "post_process not implemented";
}

sub service_object {
    die "service_object not implemented";
}

sub init {
    die "init not implemented";    
}

1;

__END__


=head1 NAME

WOA::REST::Interface::ServiceProvider

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