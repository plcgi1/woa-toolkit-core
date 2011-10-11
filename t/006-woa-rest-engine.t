#!/usr/bin/perl -w
package main;
use strict;
use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);

BEGIN { use_ok 'WOA::REST::Engine' }

Tester->process();

package Tester;
use strict;
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);

use base 'WOA::Test::Base';
use WOAx::App::Test::REST::Simple::Map;
use WOAx::App::Test::REST::Simple::Backend;
use WOAx::App::Test::REST::Simple::ViewAsXML;
use WOAx::App::Test::REST::Simple::Engine;
use WOAx::App::Test::REST::Simple::SP;
use WOA::REST::Generic::Request;

my $CLASS = __PACKAGE__;

my ($map,$factory,$rest,$req,$sp);

sub set_up {
    my $tb = __PACKAGE__->builder;
    $map = WOAx::App::Test::REST::Simple::Map::get_map();
    
    my $backend = WOAx::App::Test::REST::Simple::Backend->new();
    
    $rest = WOAx::App::Test::REST::Simple::Engine->new({
        map         =>  $map,
        backend     =>  WOAx::App::Test::REST::Simple::Backend->new(),
        view        =>  WOAx::App::Test::REST::Simple::ViewAsXML->new()
    });
    $sp = WOAx::App::Test::REST::Simple::SP->new;
	
	return;
}

sub tear_down {}

sub run {
    my $tb = __PACKAGE__->builder;

    my $res;
    my $req = WOA::REST::Generic::Request->new ( PUT => '/put/1/blabla/2') ;
    $rest->request($req);

    $res = $rest->process;
    
	# check creating SP object
	
	sp($tb,$sp);
	
	backend_methods($tb,$rest->backend);
	
    $tb->like($rest->status, qr/200/,"PUT: response OK");
	
    bad_data(
        $tb,
        $req,
        'PUT',
        ['/put/12d/blabla/3','/put/12/blabla/3d']
    );
    bad_method(
        $tb,
        $req,
        '/put/1/blabla/2',
        ['GET','POST','DELETE']
    );
    
    $req = WOA::REST::Generic::Request->new ( POST => '/post') ;
    $req->content('one=12&two=3');
    $rest->request($req);

    $res = $rest->process;
    
    $tb->like($rest->status, qr/303/,"POST: response OK");
    $tb->is_eq($rest->location, '/12/3',"POST: redirect");
    bad_method(
        $tb,
        $req,
        '/post',
        ['GET','PUT','DELETE']
    );

    $req->content('one=12b&two=3');
    $rest->request($req);
    $res = $rest->process;
    $tb->like($rest->status, qr/404/,"POST: response ".$rest->status);
    
    $req = WOA::REST::Generic::Request->new ( DELETE => '/delete') ;
    $req->content('what=12');
    $rest->request($req);
    $res = $rest->process;
    $tb->like($rest->status, qr/204/,"DELETE: response OK");
    bad_method(
        $tb,
        $req,
        '/delete',
        ['GET','PUT','POST']
    );
    
    $req = WOA::REST::Generic::Request->new ( GET => '/version') ;
    $rest->request($req);
    $res = $rest->process;
    $tb->like($rest->status, qr/200/,"GET: response OK");
    $tb->like($rest->output, qr/VERSION/,"GET: content");
    bad_method(
        $tb,
        $req,
        '/version',
        ['DELETE','PUT','POST']
    );
    
    $req = WOA::REST::Generic::Request->new ( GET => '/getparams?what=thing&what2=thing2') ;
    $rest->request($req);
    $res = $rest->process;
    $tb->like($rest->status, qr/200/,"GET: response OK");
    $tb->like($rest->output, qr/thing thing2/,"GET: content");
    bad_data(
        $tb,
        $req,
        'GET',
        [
            '/getparams?what=thing&what2=thing',
            '/getparam?what=thing&what2=thing2',
            '/getparams?what=thing2&what2=thing2',
            '/getparams?what2=thing2',
            '/getparams?what=thing'
        ]
    );
    bad_method(
        $tb,
        $req,
        '/getparams?what=thing&what2=thing2',
        ['DELETE','PUT','POST']
    );
    
    return;
}

sub sp {
	my($tb,$sp)=@_;
	$tb->ok($sp,'Creating ServiceProvider object');
	$tb->ok($sp->init,'Init ServiceProvider object');
	#$tb->ok(ref $sp->service_object,'service object ServiceProvider object');
	
	#$tb->ok(ref $sp->get_engine eq 'WOA::REST::Engine','service object ServiceProvider object');
	
	$tb->ok(ref $sp->service_object({pre_process=>sub { 1; }}),'service object ServiceProvider pre_process');
	$tb->ok(ref $sp->service_object({post_process=>sub { 1; }}),'service object ServiceProvider post_process');
	
	return;
}

sub backend_methods {
	my($self,$rest)=@_;
	use Data::Dumper;
	#make_interval_query($self,$param,$param_name_from,$param_name_to,$field_date_name)
	my $where = $rest->make_interval_query({from=>'2010-12-12',to=>'2011-12-12'},'from','to','mydate');
	$self->ok(ref $where eq 'HASH','Check if where is hash');
	$self->ok(ref $where->{-and} eq 'ARRAY','Check if where->{-and} is ARRAY');
	
	$where = $rest->make_interval_query({from=>'2010-12-12'},'from',undef,'mydate');
	$self->ok(ref $where eq 'HASH','Check if where is hash without "to"');
	$self->ok(ref $where->{-and} eq 'ARRAY','Check if where->{-and} is ARRAY');
	
	$where = $rest->make_interval_query({to=>'2010-12-12'},undef,'to','mydate');
	$self->ok(ref $where eq 'HASH','Check if where is hash without "from"');
	$self->ok(ref $where->{-and} eq 'ARRAY','Check if where->{-and} is ARRAY');
	
	#define_post_query({page rows sidx sord})
	my $post = $rest->define_post_query({page=>1,rows=>1,sidx=>1,sord=>1});
	$self->ok(ref $post eq 'HASH','Check if postquery is hash');
	$self->ok($post->{page},'Check if postquery has key "page"');
	$self->ok($post->{order_by},'Check if postquery has key "order_by"');
	$self->ok($post->{rows},'Check if postquery has key "rows"');
	
	$post = $rest->define_post_query({page=>1,sidx=>1,sord=>1});
	$self->ok(ref $post eq 'HASH','Check if postquery is hash');
	$self->ok($post->{page},'Check if postquery has key "page"');
	$self->ok($post->{order_by},'Check if postquery has key "order_by"');
	$self->ok($post->{rows},'Check if postquery has key "rows"');
	
	$post = $rest->define_post_query({rows=>1,sidx=>1,sord=>1});
	$self->ok(ref $post eq 'HASH','Check if postquery is hash');
	$self->ok($post->{page},'Check if postquery has key "page"');
	$self->ok($post->{order_by},'Check if postquery has key "order_by"');
	$self->ok($post->{rows},'Check if postquery has key "rows"');
	
	$post = $rest->define_post_query({rows=>1,sidx=>1});
	$self->ok(ref $post eq 'HASH','Check if postquery is hash');
	$self->ok($post->{page},'Check if postquery has key "page"');
	$self->ok($post->{order_by},'Check if postquery has key "order_by"');
	$self->ok($post->{rows},'Check if postquery has key "rows"');
	
	$post = $rest->define_post_query({});
	$self->ok(ref $post eq 'HASH','Check if postquery is hash');
	$self->ok($post->{page},'Check if postquery has key "page"');
	
	$self->ok($post->{rows},'Check if postquery has key "rows"');
	
	return;
}

sub bad_data {
    my($self,$req,$method,$data)=@_;
    
    foreach ( @$data ){
        $req = WOA::REST::Generic::Request->new ( $method => $_) ;
        $rest->request($req);
        my $res = $rest->process;
        $self->like($rest->status, qr/404/,"$method: response status: 404");
    }
    
    return;
}

sub bad_method {
    my($self,$req,$uri,$data)=@_;
    
    foreach ( @$data ){
        $req = WOA::REST::Generic::Request->new ( $_ => $uri ) ;
        $rest->request($req);
        my $res = $rest->process;
        $self->like($rest->status, qr/404/,"Request method: $_: response status: ".$rest->status);
    }
}

1;