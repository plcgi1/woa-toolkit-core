package WOA::Test::Base;
use strict;
use WOA::Test::Methods;
use base qw/Test::Builder::Module/;
use Data::Dumper;

sub process {
    my $self    = shift;
    my $param   = shift;
    
    my $methods = WOA::Test::Methods->new;
    $self->set_up();
    
    $self->run($methods);
    $self->tear_down();
    
    return;
}

sub set_up { warn "Nothing to set_up"; }
sub run { warn "Nothing to run"; }
sub tear_down { warn "Nothing to tear_down"; }

sub comment_case {
    my $self = shift;
    print "\n\n";
    print '#'x80;
    print "\n";
    print "We are testing: \n";
    print '='x80;
    print "\n\n";
}

1;

__END__


=head1 WOA::Test::Base

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