#!/usr/bin/perl -w
use strict;
use Getopt::Long;
use Pod::Usage;
use FindBin qw($Bin);
use File::Basename;
use lib ( $Bin . '/../lib' );
use WOA::Config::Provider;
use WOAx::Helper;

my ( $help, $action, $namespace, $service_name );

GetOptions(
    'help|?'          => \$help,
    'action|a=s'      => \$action,
    'ns|n=s'          => \$namespace,
);

pod2usage(1) if $help;
pod2usage(1) unless $action;
if ( $action eq 'page' ) {
    pod2usage(1) unless $namespace;
}

my $conf_file = WOAx::Helper->get_config_file();
my $config    = WOA::Config::Provider->get_config($conf_file);

$config->{template_root} = WOAx::Helper->get_template_root($conf_file);

my $obj = WOAx::Helper->get_object( $action, $config );

WOAx::Helper->process(
    {
        sub       => sub {
            $obj->run($namespace);
        }
    }
);

exit(0);

__END__

=head1 NAME

woax-toolkit.pl  - create woax application,pages and services

=head1 SYNOPSIS

woax-toolkit.pl [options]
 
 Options:
   -? -help         help for usage
   -a -action       page|service|map|app|genjsrules
   -n -ns           application namespace
   
=head1 DESCRIPTION

Code generator for WOAx applications

=head1 USAGE

woax-toolkit.pl -a app -n woaxtest - create skeleton for application in dir config/woaxtest

cd blabla/woaxtest

blabla/woaxtest# woax-toolkit.pl -a map -n ServiceName - create map module blabla/woaxtest/lib/Woaxtest/REST/ServiceName/Map.pm

blabla/woaxtest# woax-toolkit.pl -a page -n Page - create page module blabla/woaxtest/lib/Woaxtest/Page.pm

blabla/woaxtest# woax-toolkit.pl -a service -n ServiceName - create modules for Map.pm in

        blabla/woaxtest/lib/Woaxtest/REST/ServiceName
        blabla/woaxtest/lib/Woaxtest/REST/ServiceName/Backend.pm
        blabla/woaxtest/lib/Woaxtest/REST/ServiceName/SP.pm
        blabla/woaxtest/t/Woaxtest/REST/ServiceName.t - with tests from Map.pm data description

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.

=cut