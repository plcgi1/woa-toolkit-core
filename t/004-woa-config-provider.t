#!/usr/bin/perl -w
use strict;
use Test::More tests => 6;#qw/no_plan/; 
use FindBin qw($Bin);
use lib ($Bin,$Bin.'/../lib');
use Data::Dumper;

BEGIN { use_ok('WOA::Config::Provider'); }

my $config = WOA::Config::Provider->get_config();
ok( ref $config ne 'HASH', "WOA::Config::Provider->get_config()" );
$config = WOA::Config::Provider->get_config($Bin.'/conf',1);
ok( ref $config eq 'HASH', "WOA::Config::Provider->get_config($Bin/conf)" );

$config = WOA::Config::Provider->get_config($Bin.'/conf',1);
ok( ref $config eq 'HASH', "WOA::Config::Provider->get_config($Bin/conf,1)" );

$config = WOA::Config::Provider->get_config([$Bin.'/conf']);
ok( ref $config eq 'HASH', "WOA::Config::Provider->get_config([$Bin/conf])" );

$ENV{APP_MODE} = 'app';
$config = WOA::Config::Provider->get_config([$Bin.'/conf']);
ok( ref $config eq 'HASH', "WOA::Config::Provider->get_config([$Bin/conf]) with mode in ENV{APP_MODE}" );
