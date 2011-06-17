#!/usr/bin/perl -w
use strict;
use Test::More tests => 5; 
use FindBin qw($Bin);
use lib ($Bin,$Bin.'/../lib');
use WOA::REST::ServiceProvider::Loader;
use Data::Dumper;
use Cache::Memcached;

BEGIN { use_ok('WOA::REST::ServiceProvider::Loader'); }

my $l = WOA::REST::ServiceProvider::Loader->new;
$l->load('/woax/test/rest/simple');

ok( $l->loaded_class,'Loaded: '.$l->loaded_class );
ok( !$l->error,'Loaded: '.$l->loaded_class );

$l->loaded_class(undef);

$l->load('/woatest/rest/simple');

ok( !$l->loaded_class,'Not loaded: '.$l->loaded_class );
ok( $l->error,'Has error: '.$l->error );
