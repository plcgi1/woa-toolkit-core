package WOAx::I18n;
use strict;
use base qw/Locale::Maketext/;
use Encode;

sub new {
    my($class,$session) = @_;
    my $self = $class->SUPER::new(@_);
    bless $self,$class;
    return $self;
}

sub loc {
    my $self    = shift;
    my $string  = shift;
    my @params  = @_;
    
    for (my $i=0;$i<@params;$i++ ) {
        Encode::_utf8_off($params[$i]);
    }
    
    return $string unless defined $string;
    return $string if $string=~/^(~)$/;

    my $text = $self->maketext($string, @params);

    Encode::_utf8_on($text);
    
    $text = Encode::encode('utf8',$text);
        
    return $text;
}

1;

__END__

=head1 WOAx::I18n


=head1 SYNOPSIS


=head1 DESCRIPTION

Localization module
 
=head2 EXPORT

TODO

=head1 SEE ALSO

TODO


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
