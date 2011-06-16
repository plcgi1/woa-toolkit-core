package main;
use strict;
use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);

BEGIN { use_ok 'WOA::Component::AppRegistrator' }

Tester->process();

package Tester;
use strict;
use Cache::Memcached;
use Data::Dumper;
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);

use base 'WOA::Test::Base';
use WOA::Component::AppRegistrator;
use FindBin;

my $CLASS = __PACKAGE__;

my ($ar);

sub set_up {
    my $tb = __PACKAGE__->builder;
    my $app_root    = $FindBin::Bin;
	
    my $cm = Cache::Memcached->new({servers=>['localhost:11211']});
    $ar = WOA::Component::AppRegistrator->new({storage => $cm});
    
	return;
}

sub tear_down {}

sub run {
    my $tb = __PACKAGE__->builder;
    
	my $app1 = 'app1';
	my $app2 = 'app2';
    my $data = {
        $app1 => [{ path => '/fake1',class => 'Fake::Class1'},{ path => '/fake12',class => 'Fake::Class12'}],
        $app2 => [{ path => '/fake21',class => 'Fake::Class21'},{ path => '/fake22',class => 'Fake::Class22'}]
    };
	
	#warn $ar->storage->set('aa',1);
	$tb->ok($ar->register($app1,$data->{$app1}),"Register $app1");
	$tb->ok($ar->register($app2,$data->{$app2}),"Register $app2");
	
	my $rules1 = $ar->get_rules($app1);
	$tb->ok(ref $rules1 eq 'ARRAY',"ref rules eq ARRAY");
	$tb->ok($rules1->[0]->{path} eq $data->{$app1}->[0]->{path},"Check rules->[0]");
	
	my $all = $ar->get_all();
	$tb->ok(ref $all eq 'HASH',"ref \$all eq 'HASH'");
	
	my $updated_data = { path => '/fake1/updated',class => 'Fake::Class1::updated'};
	my $res = $ar->update_rule($app1,$updated_data,'0');
	$tb->ok($updated_data->{path} eq $res->{$app1}->[0]->{path},'$updated_data->{path} eq $res->{$app1}->[0]->{path}');
	
	$res = $ar->delete_rule($app1,$updated_data);
	$tb->ok($res->{$app1}->[0]->{path} eq $data->{$app1}->[1]->{path},'$res->{$app1}->[0]->{path} eq $data->{$app1}->[1]->{path}');
	
    return;
}

1;