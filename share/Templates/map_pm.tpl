package [%service_name %];
use strict;

my $map = [
    {
        regexp    => '/path/to/service',
        func_name => 'handler_name_for_method',
        in        => {
            how          => 'from_uri',
            rule_for_all => 'integer'
        },
        redirect => 1,

        # maybe POST GET PUT DELETE
        req_method => 'PUT'
    },
    {
        regexp    => '/path/to/service',
        func_name => 'handler_name_for_method2',
        in        => {
            skip_from_uri => 1,
            param         => [
                # some patterns to define field names and validation rules
                # all rule names - in WOA::Validator::Rules::Base
                #{ name => 'id',         rules => [ {rule => 'integer' } ], required => 1,error => "Some error message" },
                #{ name => 'title',      rules => [ {rule => 'anyText'} ], error => "Some error message" },
                #{ name => 'sord',       rules => [ {rule => 'pattern',param => '^(asc|desc)$'} ], error => "Some error message" },
                #{ name => 'email',      rules => [ {rule => 'email'} ], error => "Some error message" },
                #{ name => 'time_from',  rules => [ {rule => 'soft_iso8601'} ], error => "Some error message" },
            ]
        },
        # redirect   => 1,
        out			=>	{ mime_type => 'text/javascript', view_method => 'as_json' },
        req_method => 'POST'
    },
    {
        regexp    => '/path/to/service',
        func_name => 'handler_name_for_method3',
        in        => {
            skip_from_uri => 1,
            param         => [
                # some patterns to define field names and validation rules
                # all rule names - in WOA::Validator::Rules::Base
                #{ name => 'id',         rules => [ {rule => 'integer' } ], required => 1,error => "Some error message" },
                #{ name => 'title',      rules => [ {rule => 'anyText'} ], error => "Some error message" },
                #{ name => 'sord',       rules => [ {rule => 'pattern',param => '^(asc|desc)$'} ], error => "Some error message" },
                #{ name => 'email',      rules => [ {rule => 'email'} ], error => "Some error message" },
                #{ name => 'time_from',  rules => [ {rule => 'soft_iso8601'} ], error => "Some error message" },
            ]
        },
        # redirect   => 1,
        out			=>	{ mime_type => 'text/javascript', view_method => 'as_json' },
        req_method => 'PUT'
    },
    {
        regexp    => '/path/to/service',
        func_name => 'handler_name_for_method4',
        in        => {
            skip_from_uri => 1,
            param         => [
                # some patterns to define field names and validation rules
                # all rule names - in WOA::Validator::Rules::Base
                #{ name => 'id',         rules => [ {rule => 'integer' } ], required => 1,error => "Some error message" },
                #{ name => 'title',      rules => [ {rule => 'anyText'} ], error => "Some error message" },
                #{ name => 'sord',       rules => [ {rule => 'pattern',param => '^(asc|desc)$'} ], error => "Some error message" },
                #{ name => 'email',      rules => [ {rule => 'email'} ], error => "Some error message" },
            ]
        },
        # redirect   => 1,
        out			=>	{ mime_type => 'text/javascript', view_method => 'as_json' },
        req_method => 'GET'
    },
    {
        regexp    => '/path/to/service',
        func_name => 'handler_name_for_method5',
        in        => {
            skip_from_uri => 1,
            param         => [
                # some patterns to define field names and validation rules
                # all rule names - in WOA::Validator::Rules::Base
                #{ name => 'id',         rules => [ {rule => 'integer' } ], required => 1,error => "Some error message" },
            ]
        },
        # redirect   => 1,
        out			=>	{ mime_type => 'text/javascript', view_method => 'as_json' },
        req_method => 'DELETE'
    },
];

sub get_map { return $map; }

1;

__END__


=head1 [%ns%]REST::[%service_name%] - [TODO]

=head2 SYNOPSIS

[TODO]

=head2 DESCRIPTION

[TODO]

=head2 EXAMPLES

[TODO]

=head2 EXPORT

[TODO]

=head2 SEE ALSO

[TODO]

=head2 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
