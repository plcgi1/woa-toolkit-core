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