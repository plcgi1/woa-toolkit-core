package WOA::Validator::Rules::Base;
use 5.008007;
use strict;
use warnings;
use base 'Class::Accessor::Fast';

sub new {
	my $class = shift;
	my $this  = {};
	bless $this, $class;
	return $this;
}

sub float {
	my $this       = shift;
	my $fieldValue = shift;
	my $res;
	if ($fieldValue) {
		$res = ( $fieldValue =~ /^(-){0,1}(\d+)\.(\d+)$/ );
	}
	return $res;
}

sub integer {
	my $this       = shift;
	my $fieldValue = shift;
	my $res;
	if ($fieldValue) {
		$res = ( $fieldValue =~ /^\d+$/ );
	}
	return $res;
}

sub notNull {
	my $this       = shift;
	my $fieldValue = shift;
	my $res        = $this->integer($fieldValue);
	$res = ( $fieldValue > 0 );
	return $res;
}

sub pattern {
	my $this       = shift;
	my $fieldValue = shift;
	my $pattern    = shift;
	my $reOpts     = shift;
	my $res;
	if ($fieldValue) {
		$res = ( $fieldValue =~ /$pattern/ );
	}
	return $res;
}

sub hoursMinutes {
	my $this       = shift;
	my $fieldValue = shift;
#	my $res =
#	  ( $fieldValue =~
#/^((0)*(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23):((0)*(0|1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31|32|33|34|35|36|37|38|39|40|41|42|43|44|45|46|47|48|49|50|51|52|53|54|55|56|57|58|59)))$/
#	  );
	my $res = (
		 $fieldValue =~/^((0)*[0-9]|1[0-9]|2[0-3]):((0)*[0-9]|[1-5][0-9])$/
	);
	return $res;
}

sub ip {
	my $this       = shift;
	my $fieldValue = shift;

	my $res =
	  ( $fieldValue =~
/^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/
	  );
	return $res;
}

sub real_ip {
	my $self = shift;
	my $ip 	= shift;
	my $res;
	if ($ip =~/^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/) {
		my $ip_int = _ip_to_int($ip);
		if( defined $ip && $ip_int > 0 ){
            my $private_ips = [
                ['10.0.0.0','10.255.255.255'],
				['172.16.0.0','172.31.255.255'],
				['192.168.0.0','192.168.255.255'],
				['127.0.0.0','127.255.255.255'],
            ];
            foreach my $r ( @$private_ips ) {
                my $min = _ip_to_int ($r->[0]);
                my $max = _ip_to_int ($r->[1]);
                
                my $rule = (
                    ( $ip_int >= $min )
                    && ( $ip_int <= $max )
                );
                
                if ( $rule ) {
                    undef $res;
                    last;
                }
                else {
                    $res = 1;
                }
            } # foreach my $r ( @$private_ips )
		}
	}
	return $res;
}

sub email {
	my $this       = shift;
	my $fieldValue = shift;

	#my $res = valid($fieldValue);
	my $res = ( $fieldValue =~
		  /^[a-zA-Z0-9][a-zA-Z0-9_.-]*\@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/ );

	return $res;
}

# additional email list - separated with comma
# 	ex: email1@sdfsdf.sdf,email2@asdasd.asda
sub additionalEmail {
	my $this       = shift;
	my $fieldValue = shift;
	my @arr;
	if ( $fieldValue =~ /,/ ) {
		@arr = split ',', $fieldValue;
	}
	else {
		@arr = ($fieldValue);
	}
	my $res;
	foreach my $e (@arr) {
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
	my $this       = shift;
	my $fieldValue = shift;
	my $maxLength  = shift;

	$fieldValue = length($fieldValue);
	my $res = ( $fieldValue <= $maxLength );
	return $res;
}

sub minlength {
	my $this       = shift;
	my $fieldValue = shift;
	my $minLength  = shift;
	unless ( $fieldValue =~ /^[\p{IsDigit}]+$/ ) {
		$fieldValue = length($fieldValue);
	}
	my $res = ( $fieldValue >= $minLength );
	return $res;
}

sub maxStringLength {
	my $this       = shift;
	my $fieldValue = shift;
	my $maxLength  = shift;

	$fieldValue = length($fieldValue);
	my $res = ( $fieldValue <= $maxLength );
	return $res;
}

sub iso8601 {
	my $this       = shift;
	my $fieldValue = shift;
	my $res =
	  $this->pattern( $fieldValue, '\d\d\d\d-\d\d-\d\d(T)*(\d\d:\d\d:\d\d)*(\.\d\d\dZ)*' );
	return $res;
}

sub soft_iso8601 {
	my $this       = shift;
	my $fieldValue = shift;
	my $res        = $this->pattern( $fieldValue,
		'^(\d\d\d\d-\d\d-\d\d(T){0,1}(\d\d:\d\d:\d\d){0,8})$' );
	return $res;
}

sub date_dd_mm_yyyy {
	my $this       = shift;
	my $fieldValue = shift;
	my $res        = $this->pattern( $fieldValue,
		'^(\d\d-\d\d-\d\d\d\d(T){0,1}(\d\d:\d\d:\d\d){0,8})$' );
	return $res;
}

sub date_yyyy_mm_dd {
	my $this       = shift;
	my $fieldValue = shift;
	my $res        = $this->pattern( $fieldValue,
		'^(\d\d\d\d-\d\d-\d\d)$' );
	return $res;
}

sub boolean {
	my $this       = shift;
	my $fieldValue = shift;
	my $res        = $this->pattern( $fieldValue, '^(true|false)$' );
	return $res;
}

sub anyText {
	my $this       = shift;
	my $fieldValue = shift;

#my $re = q/^[\p{IsAlpha}|\p{IsDigit}|\p{IsSpace}|\p{IsS}|\p{IsP}|\p{IsZ}|\p{InCyrillic}]+$/;
	my $re = '.*';
	my $res = $this->pattern( $fieldValue, $re );
	return 1;
}

sub allSymbols {
	my ( $this, $fieldValue ) = @_;
	return 1;
}

sub latinString {
	my $this       = shift;
	my $fieldValue = shift;
	my $re         = '^[a-zA-Z0-9\s_-]+$';
	my $res        = $this->pattern( $fieldValue, $re );
	return $res;
}

sub path {
	my $this       = shift;
	my $fieldValue = shift;

	my $re = '^(/)+(\w|\d|/)+(/)*';

	my $res = $this->pattern( $fieldValue, $re );

	return $res;
}

sub url {
	my $this       = shift;
	my $fieldValue = shift;
	my $re         = '^(http://)?(wwww\.)?.+\w{2,5}$';
	my $res        = $this->pattern( $fieldValue, $re );
	$res = 1 if $fieldValue eq '&nbsp;';
	return $res;
}

sub equals {
	my ( $this, $p1, $p2 ) = @_;
	my $res;
	if ( $p1 && $p2 ) {
		$res = ( $p1 eq $p2 );
	}
	return $res;
}

sub notEquals {
	my $this   = shift;
	my $value1 = shift;
	my $value2 = shift;
	my $res    = $this->equals( $value1, $value2 );
	return !$res;
}

sub simple_date_dmy {
	my $this       = shift;
	my $fieldValue = shift;
	my $param      = shift;

	my $re = join $param,
	  (
		'(' . $this->_makeRangePattern( [ 1 .. 31 ] ) . ')',
		'(' . $this->_makeRangePattern( [ 1 .. 12 ] ) . ')',
		'(' . $this->_makeRangePattern( [ 1920 .. 2035 ] ) . ')'
	  );
	$re = '^(' . $re . ')$';

	my $res = $this->pattern( $fieldValue, $re );

	return $res;
}

sub simpleDate {
	my $this       = shift;
	my $fieldValue = shift;
	my $param      = shift;

	my $re = join $param,
	  (
		'(' . $this->_makeRangePattern( [ 1920 .. 2035 ] ) . ')',
		'(' . $this->_makeRangePattern( [ 1 .. 12 ] ) . ')',
		'(' . $this->_makeRangePattern( [ 1 .. 31 ] ) . ')'
	  );
	$re = '^(' . $re . ')$';

	my $res = $this->pattern( $fieldValue, $re );

	return $res;
}

sub year {
	my $this       = shift;
	my $fieldValue = shift;

	my $re = $this->_makeRangePattern( [ 1920 .. 2012 ] );
	my $res = $this->pattern( $fieldValue, $re );

	return $res;
}

sub month {
	my $this       = shift;
	my $fieldValue = shift;

	my $re = $this->_makeRangePattern( [ 1 .. 12 ] );
	my $res = $this->pattern( $fieldValue, $re );

	return $res;
}

sub mday {
	my $this       = shift;
	my $fieldValue = shift;

	my $re = $this->_makeRangePattern( [ 1 .. 31 ] );
	my $res = $this->pattern( $fieldValue, $re );

	return $res;
}

sub from_to {
	my ( $this, $value, $param ) = @_;
	my $re = $this->_makeRangePattern( [ $param->{from} .. $param->{to} ] );
	my $res = ( $value =~ /^($re)$/ );
	return $res;
}

# in:
#	param: hashref { values => {}, field_names => []}
sub one_of_the_fields_reduired {
	my ( $this, $value, $param ) = @_;
	my $res;
	foreach ( @{ $param->{field_names} } ) {
		if ( defined $param->{values}->{$_} ) {
			$res = 1;
			last;
		}
	}
	return $res;
}

sub real_ip {
	my $self = shift;
	my $ip 	= shift;
	my $res;
	if ($ip =~/^(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])\.(\d|[01]?\d\d|2[0-4]\d|25[0-5])$/) {
		my $ip_int = _ip_to_int($ip);
		if( defined $ip && $ip_int > 0 ){
            my $private_ips = [
                ['0.0.0.0','2.255.255.255'],
                ['10.0.0.0','10.255.255.255'],
                ['127.0.0.0','127.255.255.255'],
                ['169.254.0.0','169.254.255.255'],
                ['172.16.0.0','172.31.255.255'],
                ['192.0.2.0','192.0.2.255'],
                ['192.168.0.0','192.168.255.255'],
                ['255.255.255.0','255.255.255.255']
            ];
            foreach my $r ( @$private_ips ) {
                my $min = _ip_to_int ($r->[0]);
                my $max = _ip_to_int ($r->[1]);
                
                my $rule = (
                    ( $ip_int >= $min )
                    && ( $ip_int <= $max )
                );
                
                if ( $rule ) {
                    undef $res;
                    last;
                }
                else {
                    $res = 1;
                }
            } # foreach my $r ( @$private_ips )
		}
	}
	return $res;
}

sub _ip_to_int {
	my($ip) = @_;
	my $x3  = 256**3;
	my $x2  = 256**2;
	my $x   = 256;
	my ($a,$b,$c,$d) = split '\.',$ip;
	# 256³*a+256²*b+256*c+d
	my $ip_int = int($x3 * $a + $x2 * $b + $x * $c + $d);
	return $ip_int;
}

sub _makeRangePattern {
	my $this = shift;
	my $arr  = shift;

	foreach (@$arr) {
		if ( length $_ == 1 ) {
			push @$arr, '0' . $_;
		}
		else { last; }
	}
	my $res = join '|', @$arr;

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
