#!/usr/bin/perl -w
package main;
use strict;
use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
	$Bin.'/lib',
);

BEGIN { use_ok 'WOA::REST::Engine' }

Tester->process();

package Tester;
use strict;
use base 'WOA::Test::Base';
use WOA::REST::Demo::Map;
use WOA::REST::Demo::Backend;
use WOA::REST::Demo::ViewAsXML;
use WOA::REST::Demo::Engine;
use WOA::REST::Generic::Request;

my $CLASS = __PACKAGE__;

my ($map,$factory,$rest,$req);

sub set_up {
    my $tb = __PACKAGE__->builder;
    $map = WOA::REST::Demo::Map::get_map();
    
    my $backend = WOA::REST::Demo::Backend->new();
    
    $rest = WOA::REST::Demo::Engine->new({
        map         =>  $map,
        backend     =>  WOA::REST::Demo::Backend->new(),
        view        =>  WOA::REST::Demo::ViewAsXML->new()
    });
    
	return;
}

sub tear_down {}

sub run {
    my $tb = __PACKAGE__->builder;

    my $res;
    my $req = WOA::REST::Generic::Request->new ( PUT => '/put/1/2') ;
    $rest->request($req);

    $res = $rest->process;
    
    $tb->like($rest->status, qr/303/,"PUT: response OK");
    $tb->is_eq($rest->location, '/redirect/location',"PUT: redirect");
    bad_data(
        $tb,
        $req,
        'PUT',
        ['/put/12d/3','/put/12/3d','/put/12/3/']
    );
    bad_method(
        $tb,
        $req,
        '/put/1/2',
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
    $tb->like($rest->status, qr/400/,"POST: response ".$rest->status);
    
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

sub bad_data {
    my($self,$req,$method,$data)=@_;
    
    foreach ( @$data ){
        $req = WOA::REST::Generic::Request->new ( $method => $_) ;
        $rest->request($req);
        my $res = $rest->process;
        $self->like($rest->status, qr/400/,"$method: response status: 400");
    }
    
    return;
}

sub bad_method {
    my($self,$req,$uri,$data)=@_;
    
    foreach ( @$data ){
        $req = WOA::REST::Generic::Request->new ( $_ => $uri ) ;
        $rest->request($req);
        my $res = $rest->process;
        $self->like($rest->status, qr/400/,"Request method: $_: response status: ".$rest->status);
    }
}

1;