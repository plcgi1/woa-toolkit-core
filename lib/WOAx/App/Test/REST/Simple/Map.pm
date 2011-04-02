package WOAx::App::Test::REST::Simple::Map;
use strict;

my $map = [
    {
        regexp      =>  '/put/(\d\/\d)$',
		func_name	=>	'put',
        in          =>  {
            how => 'from_uri',
            rule_for_all => 'integer'
        }, 
		redirect	=>	1,
        req_method  => 'PUT'
    },
    {
        regexp      =>  '/post',
		func_name	=>	'post',
        in          =>  {
            skip_from_uri => 1,
            param => [
                { name => 'one', rules => [ {rule => 'integer'} ] },
                { name => 'two', rules => [ {rule => 'integer'} ] },
            ]
        },
		redirect	=>	1,
        req_method  => 'POST'
    },
    {
        regexp      =>  '/delete',
		func_name	=>	'delete',
        in          =>  {
            skip_from_uri => 1,
            param => [
                {
                    name => 'what',
                    rules => [{ rule => 'anyText' }]
                }
            ]
        },
		out			=>	{ mime_type => 'application/xml', view_method => 'xml' },
        req_method  => 'DELETE'
    },
    {
        regexp      => '/version$',
        func_name	=>	'version',
        out			=>	{ mime_type => 'application/xml', view_method => 'xml' },
        req_method  => 'GET'
    },
    {
        regexp      => '/getparams$',
        func_name	=>	'getparams',
        in          =>  {
            skip_from_uri => 1,
            param => [
                {
                    name        => 'what',
                    required    => 1,
                    rules => [
                        { rule => 'equals', param => 'thing' }
                    ]
                },
                {
                    name        => 'what2',
                    required    => 1,
                    rules => [
                        { rule => 'equals', param => 'thing2' }
                    ]
                }
            ]
        },
        out			=>	{ mime_type => 'application/xml', view_method => 'xml' },
        req_method  => 'GET'
    },
    {
        regexp      => '/woax/test/rest/simple$',
        func_name	=>	'getparams',
        in          =>  {
            skip_from_uri => 1,
            param => [
                {
                    name        => 'what',
                    required    => 1,
                    rules => [
                        { rule => 'equals', param => 'thing' }
                    ]
                },
                {
                    name        => 'what2',
                    required    => 1,
                    rules => [
                        { rule => 'equals', param => 'thing2' }
                    ]
                }
            ]
        },
        out			=>	{ mime_type => 'application/xml', view_method => 'xml' },
        req_method  => 'GET'
    },
];

sub get_map { return $map; }

1;

__END__


=head1 NAME

WOA::REST::Demo::Map - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]

=head1 AUTHOR

WOA.LABS E<lt>woa.develop.labs at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by WOA.LABS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut