package WOA::Test::Data;
use warnings;
use strict;

use Class::Accessor::Fast;

sub good_data {
	return [
		{
			name     => 'integer',
			required => 1,
			value    => 2,
			rules =>
			  [ { rule => 'integer' }, { rule => 'maxlength', param => 2 }, ]
		},
		{
			name     => 'integer',
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
			name     => 'pattern',
			required => 1,
			value    => 'Test string&&',
			rules    => [ { rule => 'pattern', param => '^(Test string&&)$' }, ]
		},
		{
			name     => 'ip',
			required => 1,
			value    => '127.0.0.11',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name  => 'email',
			value => 'plcgi1@gmail.com',
			rules => [ { rule => 'email' }, ]
		},
		{
			name  => 'anyText',
			value => 'фывыв АПРО е 123 <>^&*',
			rules => [ { rule => 'anyText' }, ]
		},
		{
			name  => 'equals',
			value => '1',
			rules => [ { rule => 'equals', param => '1' }, ]
		},
		{
			name  => 'notEquals',
			value => '1',
			rules => [ { rule => 'notEquals', param => '5' }, ]
		},
		{
			name  => 'latinString',
			value => 'asdfg',
			rules => [ { rule => 'latinString' }, ]
		},
		{
			name  => 'notNull',
			value => '1',
			rules => [ { rule => 'notNull' }, ]
		},
		{
			name  => 'maxStringLength',
			value => '2009-03-03T12:12:59',
			rules => [ { rule => 'maxStringLength', param => 30 }, ]
		},
		{
			name  => 'hoursMinutes',
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
		}
	];
}

sub bad_data {
	return [
		{
			name  => 'email',
			value => '<script>@gmail.com',
			rules => [ { rule => 'email' }, ]
		},
		{
			name  => 'integer',
			error => 'Bad format for Integer',
			value => '43x',
			rules =>
			  [ { rule => 'integer' }, { rule => 'maxlength', param => 1 }, ]
		},
		{
			name     => 'integer',
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
			name     => 'pattern',
			required => 1,
			error    => 'Bad format for Pattern',
			value    => 'Test stringa',
			rules    => [ { rule => 'pattern', param => '^(Test string)$' }, ]
		},
		{
			name     => 'ip',
			required => 1,
			error    => 'Bad format for IP',
			value    => '1127.0.0.1',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name     => 'ip',
			required => 1,
			error    => 'Bad format for IP',
			value    => '127.0.10.1000',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name     => 'ip',
			required => 1,
			error    => 'Bad format for IP',
			value    => '127.10.1.1111',
			rules    => [ { rule => 'ip' }, ]
		},
		{
			name  => 'anyText',
			value => 'фывыв АПРО е 123 <>^&*',
			rules => [
				{ rule => 'anyText' },
				{ rule => 'minlength', param => 1 },
				{ rule => 'maxlength', param => 3 },
			]
		},
		{
			name  => 'equals',
			value => '1',
			rules => [ { rule => 'equals', param => 'rr' }, ]
		},
		{
			name  => 'notEquals',
			value => '1',
			rules => [ { rule => 'notEquals', param => '1' }, ]
		},
		{
			name  => 'latinString',
			value => 'as фыв$%asd',
			rules => [ { rule => 'latinString' }, ]
		},
		{
			name  => 'hoursMinutes',
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
		}
	];
}    #

# ------------------------------------------------------------
1;    # modules have to return a true value

__END__


=head1 WOA::Test::Data

=head1 SYNOPSIS

=head1 DESCRIPTION

Some test data for REST services

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