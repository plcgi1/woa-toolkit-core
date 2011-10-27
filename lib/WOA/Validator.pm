package WOA::Validator;

use 5.008007;
use strict;
use warnings;

use JSON::XS qw(encode_json);

our $VERSION = '0.01';

use WOA::Validator::ErrorCode;
use WOA::Validator::Rules::Base;
use Class::Accessor::Fast;
use base 'Class::Accessor::Fast';

use constant DEFAULT_ERROR_CLASS => 'WOA::Validator::ErrorCode';

__PACKAGE__->mk_accessors(qw/fields errorCount errorCode rulesObj request errorClass/);

my @web_symbols = ( '&#35;','&#38;','&quot;','&lt;','&gt;','&brvbar;','&#40;','&#47;',,'&#41;','&#123;','&#125;','&#145;','&#146;' );
	
sub new {
	my $class = shift;
	my %opt = @_;
	
	my $this = $class->SUPER::new();
	
	bless $this,$class;
	
	$this->init(%opt);
	
	return $this;
}

sub init {
	my $this = shift;
	my %opt = @_;

	if ( $opt{rulesObj} ) {
		$this->rulesObj($opt{rulesObj});
	}
	else {
		$this->rulesObj(WOA::Validator::Rules::Base->new());
	}
	if( $opt{request} ){
        $this->request($opt{request});
    }
    if( $opt{errorClass} ){
        $this->errorClass($opt{errorClass});
    }
    else {
        $this->errorClass(DEFAULT_ERROR_CLASS->new);
    }
}

sub clear {
	my $this = shift;
	
	$this->fields([]);
	$this->{errFields} = undef;	
}

sub isValid {
	my $this = shift;

	my $rulesObj = $this->rulesObj();

	foreach my $f ( @{ $this->fields } ) {
		my $fieldName  = $f->{name};
		my $required   = $f->{required};
		my $fieldValue = $f->{value} || $this->_get_value($fieldName);
		$fieldValue = _unfilter($fieldValue);
		my $rules      = $f->{rules};
		my $count      = 0;
		
		$f->{value} = $fieldValue;
		
		# checking on required
		if ( $required && $required == 1 && !$fieldValue ) {
			$f->{error} = "Param $fieldName required" unless $f->{error};
			$this->appendErrField($f);
			next;
		}    # END if ( $required eq '1' && !length($fieldValue) )
		if ( ref $f->{value} eq 'ARRAY' ) {
			foreach my $it ( @{$f->{value}} ){
				$this->processRules($rules,$required,$rulesObj,$f,$fieldName,$it);
			}
		}
		else {
			$this->processRules($rules,$required,$rulesObj,$f,$fieldName,$fieldValue);
			#foreach my $r (@$rules) {
			#	my $func = $r->{rule};
			#	
			#	next if ( !$required && !$fieldValue );
			#		
			#	my $res = $rulesObj->$func( $fieldValue, $r->{param} );
			#		
			#	if ( !$res ) {
			#		$f->{error} = "Wrong format for $fieldName" unless $f->{error};
			#		$this->appendErrField($f);
			#	}
			#}    # END foreach my $r ( keys %$rules )
		}	
		if ( !$this->{errFields} ) {
			unless ( $rules->[0]->{rule} =~ /allSymbols|path/ ){
				$f->{value} = _filter($f->{value});
			}
		}
	}    # END foreach my $f ( @{$this->fields} )
	my $errors = ++$#{ $this->{errFields} };
	if ( $errors > 0 ) {
		my $err = $this->errorClass();

		$err->errorCount($errors);
		$err->errorFields( $this->{errFields} );
		$err->errorMsg();

		return $err;
	}    # END if( $this->errCount() > 0 )
	
	return 1;
}

sub processRules {
	my ($self,$rules,$required,$rulesObj,$field,$fieldName,$fieldValue) = @_;
	foreach my $r (@$rules) {
		my $func = $r->{rule};
		next if ( !$required && !$fieldValue );
		my $res = $rulesObj->$func( $fieldValue, $r->{param} );
		if ( !$res ) {
			$field->{error} = "Wrong format for $fieldName" unless $field->{error};
			$self->appendErrField($field);
		}
	}    # END foreach my $r ( keys %$rules )
	return;
}

sub appendField {
	my $this  = shift;
	my $field = shift;

	push @{ $this->{fields} }, $field;
    
    return;
}

sub appendErrField {
	my $this  = shift;
	my $field = shift;

	push @{ $this->{errFields} }, $field;
    
    return;
}

sub fieldsAsJSON {
	my $this = shift;
	my $formName = shift;
	
	return unless $this->fields();

	my $json = encode_json( $this->fields() );
	
	if ( $formName ) {
		$json = '<script type="text/javascript">window.'.$formName.'FieldArray = { fields: '.$json.' }</script>';		
	}
	return $json;
}

#------------------------------------------------------------------------------
sub _get_value {
	my $self = shift;
	my $field_name = shift;
	my $value;
	if( defined $self->request && ref $self->request && $self->request->can('param') ){
		$value = $self->request->param($field_name);
	}
	return $value;
}

sub _filter {
    my $str = shift;
	unless ( ref $str eq 'ARRAY' ) {
		my $re = join '|',@web_symbols;
		
		my $regexp = qr/\0|#|\&|"|'|<|>|\(|\)|\||\[|\]|\\|\{|\}|\//;
		if ( ref ( $str ) eq 'ARRAY' ) {
			foreach ( @{$str} ) {
				unless ( $str =~ /($re)/ ) {
					$str =~ s/($regexp)/_translateSymbols($1)/ge;
				}
			}
		}
		else {
			if ( $str ) {
				unless ( $str =~ /($re)/ ) {
					$str =~ s/($regexp)/_translateSymbols($1)/ge;
				}
			}
		}
	}
    return $str;
}

#------------------------------------------------------------------------------
sub _translateSymbols {
    my $sym = shift;
    if ( $sym eq "\0" ) { $sym= ''; }
    elsif ( $sym eq '#' ) { $sym = '&#35;'; }
    elsif ( $sym eq '&' ) { $sym = '&#38;'; }
    elsif ( $sym eq '"' ) { $sym = '&quot;'; }
	elsif ( $sym eq '‘' ) { $sym = '&#145;'; }
	elsif ( $sym eq '’' ) { $sym = '&#146;'; }
    elsif ( $sym eq '<' ) { $sym = '&lt;'; }
    elsif ( $sym eq '>' ) { $sym = '&gt;'; }
    elsif ( $sym eq '|' ) { $sym = '&brvbar;'; }
    elsif ( $sym eq '(' ) { $sym = '&#40;'; }
    elsif ( $sym eq ')' ) { $sym = '&#41;'; }
	
	elsif ( $sym eq '[' ) { $sym = '&#91;'; }
	elsif ( $sym eq ']' ) { $sym = '&#93;'; }
	
	elsif ( $sym eq '/' ) { $sym = '&#47;'; }
	elsif ( $sym eq '\\' ) { $sym = '&#92;'; }
	
	elsif ( $sym eq '{' ) { $sym = '&#123;'; }
	elsif ( $sym eq '}' ) { $sym = '&#125;'; }
	
    return $sym;
}
#------------------------------------------------------------------------------

sub _unfilter {
    my $str = shift;
	unless ( ref $str eq 'ARRAY' ) {	
		my $regexp = qr/\0|\&#35;|\&#38;|\&quot;|\&lt;|\&gt;|\&#40;|\&#41;|\&brvbar;|\&#91;|\&#93;|\&#92;|\&#47;|\&#123;|\&#125;|\&#145;|\&#146;/;
		if ( ref ( $str ) eq 'ARRAY' ) {
			foreach ( @{$str} ) {
				$str =~ s/($regexp)/_unTranslateSymbols($1)/ge;
			}
		}
		else {
			$str =~ s/($regexp)/_unTranslateSymbols($1)/ge if $str;
		}
	}
    return $str;
}

#------------------------------------------------------------------------------
sub _unTranslateSymbols {
    my $sym = shift;
    if ( $sym eq "\0" ) { $sym= ''; }
    elsif ( $sym eq '&#35;' ) { $sym = '#'; }
    elsif ( $sym eq '&#38;' ) { $sym = '&'; }
    elsif ( $sym eq '&quot;' ) { $sym = '"'; }
    elsif ( $sym eq '&lt;' ) { $sym = '<'; }
    elsif ( $sym eq '&gt;' ) { $sym = '>'; }
    elsif ( $sym eq '&brvbar;' ) { $sym = '|'; }
    elsif ( $sym eq '&#40;' ) { $sym = '('; }
    elsif ( $sym eq '&#41;' ) { $sym = ')'; }
	
	elsif ( $sym eq '&#91;' ) { $sym = '['; }
	elsif ( $sym eq '&#92;' ) { $sym = '\\'; }
	elsif ( $sym eq '&#93;' ) { $sym = ']'; }
	
	elsif ( $sym eq '&#123;' ) { $sym = '{'; }
	elsif ( $sym eq '&#125;' ) { $sym = '}'; }
	
	elsif ( $sym eq '&#47;' ) { $sym = '/'; }
	
	elsif ( $sym eq '&#145;' ) { $sym = '‘'; }
	elsif ( $sym eq '&#146;' ) { $sym = '’'; }
	
    return $sym;
}
#------------------------------------------------------------------------------

1;

__END__

=head1 WOA::Validator - Input params validator

=head1 SYNOPSIS

  	use WOA::Validator;
  	
  	my $fields = [
		{
			name		=>	'Integer',
			error		=>	'Bad format for Integer',
			value		=>	43,
			rules	=>	[
				{ rule => 'integer' },
				{ rule => 'maxlength', param => 1 },
			]
		},
		{ ... }
	];
	
	my $validator = WOA::Validator->new();
	$validator->fields($fields);
	my $valid = $validator->isValid();
	
	if ( ref $valid eq 'Validator::ErrorCode' ) {
		# error handling
		$valid->errorCode();
		# or 
		$valid->errorMsg();
	}		


=head1 DESCRIPTION

Class for input method validation by rules from WOA::Validator::Rules::Base 
See all examples from t/005-woa-validator.t

=head1 SEE ALSO

TODO


=head1 GIT repository

=begin html

<a href="https://github.com/plcgi1/woa-toolkit-core">https://github.com/plcgi1/woa-toolkit-core</a>

=end html


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
