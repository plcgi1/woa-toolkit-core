package WOA::Formatter;
use strict;
use Encode::Guess;
use Encode qw(from_to decode is_utf8);
use POSIX qw/strftime/;
use base qw/Class::Singleton Class::Accessor::Fast/;

sub _new_instance {
	my $c = shift;
	return bless {}, $c;
}

sub format_ts {
	my ( $self, $ts ) = @_;
	my $res = strftime( "%d-%m-%Y %H:%M", localtime($ts) );
	return $res;
}

#2005-12-13T18:30:02Z
sub format_iso_801 {
	my ( $self, $ts ) = @_;
	my $res = strftime( "%Y-%m-%dT%H:%M:%SZ", localtime($ts) );
	return $res;
}

sub encode_utf {
	my ( $self, $string ) = @_;

	my $res;
	if ( is_utf8($string) ) {
		$res = $string;
	}
	else {
		from_to( $string, 'utf8', 'utf8' );
		$res = decode( 'utf8', $string );
	}

	return $res;
}

sub get_encoding {
	my ( $self, $str ) = @_;
	my $encoding;
	foreach (qw/cp1251 koi8-r utf8/) {
		my $enc = guess_encoding( $str, $_ );
		if ( ref $enc ) {
			$encoding = $enc->name;
			last;
		}
	}
	return $encoding;
}

1;

__END__


=head1 WOA::Formatter

=head1 SYNOPSIS

my $fmt = WOA::Formatter->instance;
print $fmt->format_ts(unixtimestamp);

=head1 DESCRIPTION

format any formats in your apps

=head2 EXPORT

TODO

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
