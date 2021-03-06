package WOAx::App::Test::REST::Simple::Backend;
use strict;

use base 'WOA::REST::Generic::Backend';

sub put {
    my ($self,$param)=@_;

    my $res = { one => $param->{one}, two => $param->{two} };
    return $res;
}

sub post {
    my ($self,$param)=@_;
    my $res = '/'.$param->{one}.'/'.$param->{two};
    return $res;
}

sub delete	{
    my ($self,$param)=@_;
    my $res = 'Deleted';
    return $res;
}

sub getparams {
    my ($self,$param)=@_;
    my $res = $param->{what} . ' ' . $param->{what2};
    return $res;
}

sub version {
    my ($self)=@_;
    
    my $res = 'VERSION';
    my $env = $self->get_env;
    if ( $env ) {
        my $localize = $self->get_env->{'psgix.localize'};
        if( $localize ) {
            $res = $localize->loc('Version');
        }
    }
    return $res;
}

1;

__END__


=head1 NAME

WOA::REST::Demo::Backend - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]



=head1 BUGS

Please report any bugs or suggestions at L<https://github.com/plcgi1/woa-toolkit-core>


=head1 AUTHOR

WOA.LABS E<lt>woa.develop.labs at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by WOA.LABS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut