package WOAx::App::Test::REST::Simple::SP;
use strict;
use base 'WOA::REST::ServiceProvider';
use Data::Dumper;
use WOAx::App::Test::REST::Simple::Backend;
use WOAx::App::Test::REST::Simple::Map;
use WOAx::App::Test::REST::Simple::Engine;
use WOAx::App::Test::REST::Simple::ViewAsXML;

sub init {
    my ( $self, $env ) = @_;
    $self->{param} = $env;
    return;
}

sub service_object {
    my ( $self, $env ) = @_;
    
    my $view    = WOAx::App::Test::REST::Simple::ViewAsXML->new();
    my $backend = WOAx::App::Test::REST::Simple::Backend->new(
        {
            model       => $env->{model},
            config      => $env->{config},
            session     => $env->{'session'},
            formatter   => $env->{formatter},
            env         => $env->{env},
        }
    );
    
    my $rest = WOAx::App::Test::REST::Simple::Engine->new({
        map         =>  WOAx::App::Test::REST::Simple::Map->get_map,
        backend     =>  $backend,
        view        =>  $view,
        formatter   =>  $env->{formatter},
    });
    $rest->env($env->{env});
    
    return $rest;
}

1;


__END__


=head1 WOAx::App::Test::REST::Simple::SP

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

TODO

=head1 SEE ALSO

TODO



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
