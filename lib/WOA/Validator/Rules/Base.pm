package WOA::Validator::Rules::Base;
use 5.008007;
use strict;
use warnings;
use base 'Class::Accessor::Fast';
#use  Mail::RFC822::Address qw(valid);

sub new {
	my $class = shift;
	my $this = {};
	bless $this,$class;
	return $this;
}

sub integer {
	my $this = shift;
	my $fieldValue = shift;
	my $res;
	if($fieldValue) {
		$res = ( $fieldValue =~/^\d+$/ );
	}
	return $res;
}

sub notNull {
	my $this = shift;
	my $fieldValue = shift;
	my $res = $this->integer($fieldValue);
	$res = ( $fieldValue > 0 );
	return $res;
}

sub pattern	{
	my $this = shift;
	my $fieldValue 	= shift;
	my $pattern		= shift;
	my $reOpts		= shift;
	my $res;
	if( $fieldValue ) {
		$res = ( $fieldValue =~ /$pattern/ );
	}
	return $res;
}

sub hoursMinutes	{
	my $this = shift;
	my $fieldValue 	= shift;
	my $res = ( $fieldValue =~ /^((0|1|2|3|4|5|6|7|8|9|10|11|12):(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59))$/ );

	return $res;
}

sub ip {
	my $this = shift;
	my $fieldValue 	= shift;

	my $res = ( $fieldValue=~/^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/ );
	return $res;
}

sub email {
	my $this = shift;
	my $fieldValue 	= shift;

	#my $res = valid($fieldValue);
	my $res = ( $fieldValue =~/^[a-zA-Z0-9][a-zA-Z0-9_.-]*\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/);

	return $res;
}

# additional email list - separated with comma
# 	ex: email1@sdfsdf.sdf,email2@asdasd.asda
sub additionalEmail {
	my $this 		= shift;
	my $fieldValue 	= shift;
	my @arr;
	if ( $fieldValue =~/,/ ) {
		@arr = split ',',$fieldValue;
	}
	else {
		@arr = ($fieldValue);
	}
	my $res;
	foreach my $e( @arr ){
		for ($e) {
			s/^\s+//;
			s/\s//;
		}
		$res = $this->email($e);
		unless ($res) {
			$res = undef;
			last;
		}
	}

	return $res;
}

sub maxlength {
	my $this = shift;
	my $fieldValue 	= shift;
	my $maxLength 	= shift;
	
	$fieldValue = length($fieldValue);
	my $res = ( $fieldValue <= $maxLength ) ;
	return $res;
}

sub minlength {
	my $this = shift;
	my $fieldValue 	= shift;
	my $minLength 	= shift;
	unless ( $fieldValue =~/^[\p{IsDigit}]+$/) {$fieldValue = length($fieldValue);}
	my $res = ( $fieldValue >= $minLength ) ;
	return $res;
}

sub maxStringLength {
	my $this = shift;
	my $fieldValue 	= shift;
	my $maxLength 	= shift;
	
	$fieldValue = length($fieldValue);
	my $res = ( $fieldValue <= $maxLength ) ;
	return $res;
}

sub iso8601 {
	my $this = shift;
	my $fieldValue 	= shift;
	my $res = $this->pattern($fieldValue,'\d\d\d\d-\d\d-\d\dT\d\d:\d\d:\d\d');
	return $res;
}

sub soft_iso8601 {
	my $this = shift;
	my $fieldValue 	= shift;
	my $res = $this->pattern($fieldValue,'^(\d\d\d\d-\d\d-\d\d(T){0,1}(\d\d:\d\d:\d\d){0,8})$');
	return $res;
}

sub date_dd_mm_yyyy {
	my $this = shift;
	my $fieldValue 	= shift;
	my $res = $this->pattern($fieldValue,'^(\d\d-\d\d-\d\d\d\d(T){0,1}(\d\d:\d\d:\d\d){0,8})$');
	return $res;
}

sub boolean {
	my $this = shift;
	my $fieldValue 	= shift;
	my $res = $this->pattern($fieldValue,'^(true|false)$');
	return $res;
}

sub anyText {
	my $this = shift;
	my $fieldValue 	= shift;

	#my $re = q/^[\p{IsAlpha}|\p{IsDigit}|\p{IsSpace}|\p{IsS}|\p{IsP}|\p{IsZ}|\p{InCyrillic}]+$/;
	my $re = '.*';
	my $res = $this->pattern($fieldValue,$re);
	return 1;
}

sub allSymbols {
	my ($this,$fieldValue) 	= @_;
	return 1;
}

sub latinString {
	my $this = shift;
	my $fieldValue 	= shift;
	my $re = '^[a-zA-Z0-9\s_-]+$';
	my $res = $this->pattern($fieldValue,$re);
	return $res;
}

sub path {
	my $this = shift;
	my $fieldValue 	= shift;
    
    my $re = '^(/)+(\w|\d|/)+(/)*';
		
    my $res = $this->pattern($fieldValue,$re);
	
	return $res;
}

sub url {
	my $this = shift;
	my $fieldValue 	= shift;
	my $re = '^(http://)?(wwww\.)?.+\w{2,5}$';
	my $res = $this->pattern($fieldValue,$re);
	$res = 1 if $fieldValue eq '&nbsp;';
	return $res;
}

sub equals {
	my ($this,$p1,$p2) 	= @_;
	my $res;
	if( $p1 && $p2 ){
		$res = ($p1 eq $p2);
	}
	return $res;
}

sub notEquals {
	my $this 	= shift;
	my $value1 	= shift;
	my $value2 	= shift;
	my $res = $this->equals($value1,$value2);
	return !$res;
}

sub simple_date_dmy	{
	my $this = shift;
	my $fieldValue 	= shift;
    my $param = shift;
    
	my $re = join $param,('('.$this->_makeRangePattern([1..31]).')','('.$this->_makeRangePattern([1..12]).')','('.$this->_makeRangePattern([1920..2035]).')' );
    $re = '^('.$re.')$';
    
	my $res = $this->pattern($fieldValue,$re);
		
	return $res;		
}

sub simpleDate	{
	my $this = shift;
	my $fieldValue 	= shift;
    my $param = shift;
    
	my $re = join $param,('('.$this->_makeRangePattern([1920..2015]).')','('.$this->_makeRangePattern([1..12]).')','('.$this->_makeRangePattern([1..31]).')' );
    $re = '^('.$re.')$';
    
	my $res = $this->pattern($fieldValue,$re);
		
	return $res;		
}

sub year {
	my $this = shift;
	my $fieldValue 	= shift;
    
	my $re = $this->_makeRangePattern([1920..2012]);
	my $res = $this->pattern($fieldValue,$re);
	
	return $res;
}

sub month {
	my $this = shift;
	my $fieldValue 	= shift;
    
	my $re = $this->_makeRangePattern([1..12]);
	my $res = $this->pattern($fieldValue,$re);
	
	return $res;	
}

sub mday {
	my $this = shift;
	my $fieldValue 	= shift;
    
	my $re = $this->_makeRangePattern([1..31]);
	my $res = $this->pattern($fieldValue,$re);
	
	return $res;
}

sub from_to {
	my ($this,$value,$param) = @_;
	my $re = $this->_makeRangePattern([$param->{from}..$param->{to}]);
	
	my $res = ( $value =~ /^($re)$/ );
	
	return $res;
}

# in:
#	param: hashref { values => {}, field_names => []}
sub one_of_the_fields_reduired {
	my ($this,$value,$param) = @_;
	my $res;
	foreach ( @{$param->{field_names}} ){
		if( defined $param->{values}->{$_} ){
			$res = 1;
			last;
		}
	}
	return $res;
}

sub _makeRangePattern {
	my $this 	= shift;
    my $arr = shift;

    foreach (@$arr){
        if(length $_ == 1 ) {
            push @$arr,'0'.$_;
        }
        else { last; }
    }
    my $res = join '|',@$arr;

    return $res;
}

1;

__END__


=head1 NAME

WOA::Validator::Rules::Base

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