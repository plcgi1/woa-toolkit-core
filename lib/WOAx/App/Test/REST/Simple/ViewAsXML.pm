package WOAx::App::Test::REST::Simple::ViewAsXML;
use strict;
use base 'WOA::REST::Generic::View';

sub xml {
    my ( $self, $obj ) = @_;
	
    my $res = '<response>'.$obj.'</response>';
	
	return $res;    
}

1;

__END__


=head1 NAME

WOAx::App::Test::REST::Simple::ViewAsXML - []

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