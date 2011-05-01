package WOA::REST::ServiceProvider;
use strict;
use strict;
use base 'WOA::REST::Interface::ServiceProvider';

use constant DEFAULT_ENGINE_CLASS => 'WOA::REST::Engine';

sub new {
    my ( $class, $param, $service_param ) = @_;

    my $self = $class->SUPER::new($param);
    bless $self, $class;

    $self->init($service_param);

    return $self;
}

sub service_object {
    my ( $self, $param ) = @_;

    if ( $param->{pre_process} ) {
        $param->{pre_process}->();
    }

    # backend engine map view
    my $view    = $self->get_view();
    my $engine  = $self->get_engine() || DEFAULT_ENGINE_CLASS;
    my $map     = $self->get_map();
    my $backend = $self->get_backend();

    my $rest = $engine->new(
        {
            map     => $map->get_map,
            backend => $backend,
            view    => $view,
        }
    );

    if ( $param->{post_process} ) {
        $param->{post_process}->();
    }

    return $rest;
}

sub init {
    my ( $self, $param ) = @_;
    return;
}

1;

__END__


=head1 NAME

WOA::REST::ServiceProvider

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

TODO

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
