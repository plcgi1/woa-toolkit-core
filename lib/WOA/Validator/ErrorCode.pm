package WOA::Validator::ErrorCode;

use 5.008007;
use strict;
use warnings;

our $VERSION = '0.01';

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw/errorCount errorFields errorMsg/);

#  
sub errorMsg {
	my $this = shift;
	
	my @msg = ();
	if ( ref $this->errorFields eq 'ARRAY' ) {
		foreach ( @{$this->errorFields} ) {
			push @msg,$_->{error} if ($_->{error});
		}
		$this->{errorMsg} = join '.',@msg;
	}
	
	return $this->{errorMsg};
}

sub errorMsgAsString {
	my $this = shift;
	
	return $this->{errorMsg};
}

sub errorCode {
	my $this = shift;
	
	return {
		errorCount	=> 	$this->errorCount(),
		errorFields	=>	$this->errorFields()
	}
}

1;
__END__



=head1 NAME

WOA::Validator::ErrorCode

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