#!/usr/bin/perl -w
use strict;
use Test::More tests => 3; 
use FindBin qw($Bin);
use lib ($Bin,$Bin.'/../lib');
use WOA::REST::ServiceProvider::Loader;
use Data::Dumper;

BEGIN { use_ok('WOA::REST::ServiceProvider::Loader'); }

my $l = WOA::REST::ServiceProvider::Loader->new;
$l->load('/woax/test/rest/simple');

ok( $l->loaded_class,'Loaded: '.$l->loaded_class );
ok( !$l->error,'Loaded: '.$l->loaded_class );
