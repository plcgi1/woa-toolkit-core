package WOAx::App::Test::REST::Simple::Engine;
use strict;
use base 'WOA::REST::Engine';

sub from_uri {
    my ($self,$param) = @_;
    
    my $path = $self->request->uri->path;
    $path=~s/\/put//;
    my @arr = split '/',$path;
    my @fields;
    foreach ( @arr ){
        next unless $_;
        push @fields,{
            name    => $_,
            value   => $_,
            rules   => [ {rule => $param->{in}->{rule_for_all}} ]
        };
    }
    return \@fields;
}

1;

__END__


=head1 NAME

WOA::REST::Demo::Engine - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]

=head1 AUTHOR

WOA.LABS E<lt>woa.develop.labs at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by WOA.LABS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut