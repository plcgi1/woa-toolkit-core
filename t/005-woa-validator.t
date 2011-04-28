# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Validator.t'

#########################
package Fake::RulesObject;
use strict;
use base 'WOA::Validator::Rules::Base';


use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib $Bin. '/../lib';
use WOA::Validator;
use Data::Dumper;

BEGIN { use_ok('WOA::Validator') }

#########################

my $validator = WOA::Validator->new();
ok( ref $validator eq 'WOA::Validator', "WOA::Validator->new()" );

#$validator = WOA::Validator->new(request => Fake::RulesObject->new);
#ok( ref $validator eq 'WOA::Validator', "WOA::Validator->new(with custom request)" );
#
#$validator = WOA::Validator->new(errorClass => Fake::RulesObject->new);
#ok( ref $validator eq 'WOA::Validator', "WOA::Validator->new(with custom errorClass)" );
#
#$validator = WOA::Validator->new(rulesObj => Fake::RulesObject->new);
#ok( ref $validator eq 'WOA::Validator', "WOA::Validator->new(with custom rulesObject{})" );

my $res;
my $fields = getOK(); 
foreach ( @$fields ) {
	$validator->clear();
	$validator->fields( [$_] );
	$res = $validator->isValid();
	ok( $res == 1, "OK test isValid().Result: $res.Name: $_->{name}.Value: $_->{value}" );	
}

$fields = getBAD();
foreach ( @$fields ) {
	$validator->clear();
	$validator->fields([$_]);
	$res = $validator->isValid();
	ok( ref $res eq 'WOA::Validator::ErrorCode',
		"BAD test isValid().Result: Name: $_->{name}.Value: $_->{value} " );	
}

sub getOK {
	my $inputValidatorOK = [
		{
			name     => 'Integer',
			required => 1,
			value    => 2,
			rules    =>
			  [ { rule => 'integer' }, { rule => 'maxlength', param => 2 }, ]
		},
		{
			name     => 'Integer',
			required => 1,
			error    => 'Integer not in min max',
			value    => 2,
			rules    => [
				{ rule => 'integer' },
				{ rule => 'minlength', param => 1 },
				{ rule => 'maxlength', param => 2 },
			]
		},
		{
			name     => 'Pattern',
			required => 1,
			value    => 'Test string&&',
			rules    => [ { rule => 'pattern', param => '^(Test string&&)$' }, ]
		},
		{
			name     => 'IP',
			required => 1,
			value    => '127.0.0.11',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name  => 'EMAIL',
			value => 'plcgi1@gmail.com',
			rules => [ { rule => 'email' }, ]
		},
		{
			name  => 'AnyText',
			value => 'фывыв АПРО е 123 <>^&*',
			rules => [ { rule => 'anyText' }, ]
		},
		{
			name  => 'Equals',
			value => '1',
			rules => [ { rule => 'equals', param => '1' }, ]
		},
		{
			name  => 'NOTEquals',
			value => '1',
			rules => [ { rule => 'notEquals', param => '5' }, ]
		},
		{
			name  => 'LATINSTRING',
			value => 'asdfg',
			rules => [ { rule => 'latinString' }, ]
		},
        {
			name  => 'NOT NULL',
			value => '1',
			rules => [ { rule => 'notNull' }, ]
		},
        {
			name  => 'MAX STRING LENGTH',
			value => '2009-03-03T12:12:59',
			rules => [ { rule => 'maxStringLength', param => 30 }, ]
		},
		{
			name  => 'HOURS_MINUTES',
			value => '12:59',
			rules => [ { rule => 'hoursMinutes' }, ]
		},
		#additionalEmail
		{
			name  => 'additionalEmail',
			value => 'aaa@aa.asd,aaa@aa.asd',
			rules => [ { rule => 'additionalEmail' }, ]
		},
		# iso8601
		{
			name  => 'iso8601',
			value => '2011-12-23T11:22:22',
			rules => [ { rule => 'iso8601' }, ]
		},
		#soft_iso8601
		{
			name  => 'soft_iso8601',
			value => '2011-12-23',
			rules => [ { rule => 'soft_iso8601' }, ]
		},
		# date_dd_mm_yyyy
		{
			name  => 'date_dd_mm_yyyy',
			value => '12-23-2001',
			rules => [ { rule => 'date_dd_mm_yyyy' }, ]
		},
		# boolean
		{
			name  => 'boolean',
			value => 'true',
			rules => [ { rule => 'boolean' }, ]
		},
		# boolean
		{
			name  => 'boolean',
			value => 'false',
			rules => [ { rule => 'boolean' }, ]
		},
		# latinString
		{
			name  => 'latinString',
			value => 'false',
			rules => [ { rule => 'latinString' }, ]
		},
		# path
		{
			name  => 'path',
			value => '/false/asdad/',
			rules => [ { rule => 'path' }, ]
		},
		# url
		{
			name  => 'url',
			value => 'http://false.asdad.qwe',
			rules => [ { rule => 'url' }, ]
		},
		# allSymbols
		{
			name  => 'allSymbols',
			value => 'http://false.asdad.qwe',
			rules => [ { rule => 'allSymbols' }, ]
		},
		# simple_date_dmy
		{
			name  => 'simple_date_dmy',
			value => '12.12.2010',
			rules => [ { rule => 'simple_date_dmy',param=>'.' }, ]
		},
	];
	return $inputValidatorOK;
}

sub getBAD {
	my $inputValidatorBAD = [
		{
			name  => 'EMAIL',
			value => '<script>@gmail.com',
			rules => [ { rule => 'email' }, ]
		},
		{
			name  => 'Integer',
			error => 'Bad format for Integer',
			value => 43,
			rules =>
			  [ { rule => 'integer' }, { rule => 'maxlength', param => 1 }, ]
		},
		{
			name     => 'Integer',
			required => 1,
			error    => 'Integer not in min max',
			value    => 234,
			rules    => [
				{ rule => 'integer' },
				{ rule => 'minlength', param => 1 },
				{ rule => 'maxlength', param => 2 },
			]
		},
		{
			name     => 'Pattern',
			required => 1,
			error    => 'Bad format for Pattern',
			value    => 'Test stringa',
			rules    => [ { rule => 'pattern', param => '^(Test string)$' }, ]
		},
		{
			name     => 'IP',
			required => 1,
			error    => 'Bad format for IP',
			value    => '1127.0.0.1',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name     => 'IP',
			required => 1,
			error    => 'Bad format for IP',
			value    => '127.0.10.1000',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name     => 'IP',
			required => 1,
			error    => 'Bad format for IP',
			value    => '127.10.1.1111',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name  => 'AnyText',
			value => 'фывыв АПРО е 123 <>^&*',
			rules => [ 
				{ rule => 'anyText' },
				{ rule => 'minlength', param=>1 },
				{ rule => 'maxlength', param=>3 },
			]
		},
		{
			name  => 'Equals',
			value => '1',
			rules => [ { rule => 'equals', param => 'rr' }, ]
		},
		{
			name  => 'NOTEquals',
			value => '1',
			rules => [ { rule => 'notEquals', param => '1' }, ]
		},
		{
			name  => 'LATINSTRING',
			value => 'as фыв$%asd',
			rules => [ { rule => 'latinString' }, ]
		},
		{
			name  => 'HOURS_MINUTES',
			value => '122:12:59',
			rules => [ { rule => 'hoursMinutes' }, ]
		},
		{
			name  => 'additionalEmail',
			value => 'aaa@aa.asd.aaa@aa.asd',
			rules => [ { rule => 'additionalEmail' }, ]
		},
		# iso8601
		{
			name  => 'iso8601',
			value => '211-23-2T111:22:22',
			rules => [ { rule => 'iso8601' }, ]
		},
		#soft_iso8601
		{
			name  => 'soft_iso8601',
			value => '2011-12-233',
			rules => [ { rule => 'soft_iso8601' }, ]
		},
		# date_dd_mm_yyyy
		{
			name  => 'date_dd_mm_yyyy',
			value => '12-233-33',
			rules => [ { rule => 'date_dd_mm_yyyy' }, ]
		},
		# boolean
		{
			name  => 'boolean',
			value => 'true1',
			rules => [ { rule => 'boolean' }, ]
		},
		# boolean
		{
			name  => 'boolean',
			value => '1false',
			rules => [ { rule => 'boolean' }, ]
		},
		# latinString
		{
			name  => 'latinString',
			value => 'falseфыв',
			rules => [ { rule => 'latinString' }, ]
		},
		# path
		{
			name  => 'path',
			value => 'falseфыв',
			rules => [ { rule => 'path' }, ]
		},
		# url
		{
			name  => 'url',
			value => 'http1://false/asdad/',
			rules => [ { rule => 'url' }, ]
		},
		# simple_date_dmy
		{
			name  => 'simple_date_dmy',
			value => '12-.12.2010',
			rules => [ { rule => 'simple_date_dmy',param=>'.' }, ]
		},
		# simpleDate
		{
			name  => 'simpleDate',
			value => '12-.12.2010',
			rules => [ { rule => 'simpleDate',param=>'.' }, ]
		},
	];
	return $inputValidatorBAD;    
}

1;
