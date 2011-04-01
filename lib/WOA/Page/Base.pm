package WOA::Page::Base;
use common::sense;
use base 'WOA::REST::ServiceProvider';

sub get_map {}

sub service_object {
    my ( $self, $env ) = @_;
    
    my $view    = WOAx::Service::REST::View->new({view=>$self->{param}->{view}});
    my $rest = $env->{engine}->new({
        map         =>  $self->get_map,
        backend     =>  $self,
        view        =>  $view,
    });

    return $rest;
}

1;

__END__


=head1 WOA::Page::Base

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by WOA.LABS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut