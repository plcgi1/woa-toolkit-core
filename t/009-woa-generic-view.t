#!/usr/bin/perl -w
package main;
use strict;
use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);

BEGIN { use_ok 'WOA::REST::Generic::View' }

Tester->process();

package Tester;
use strict;
use FindBin qw($Bin);
use lib (
    $Bin.'/../lib',
);

use base 'WOA::Test::Base';
use WOA::REST::Generic::View;
use FindBin;
use Template;
use JSON::XS qw/decode_json/;
my $CLASS = __PACKAGE__;

my ($view,$renderer);

sub set_up {
    my $tb = __PACKAGE__->builder;
    my $app_root    = $FindBin::Bin;
    my $tpl = Template->new({
        INCLUDE_PATH => [
            $app_root,
        ],
        TIMER               => 1,
        DEFAULT_ENCODING    => 'utf8',
    });
    $renderer = WOA::REST::Generic::View->new({renderer => $tpl});
    
	return;
}

sub tear_down {}

sub run {
    my $tb = __PACKAGE__->builder;
    
    my $data = {type=>'as_is',text=>'blabla',template=>'test_tt',rows=>20,page=>1};
    my $res = $renderer->dispatch($data);
    $tb->ok($res->{text},'Res is hash');
    $res = $renderer->as_is($data);
    $tb->ok($res->{text},'Res is hash - from as_is');
    $res = $renderer->as_json($data);
    $res = decode_json($res);
    $tb->ok($res->{text},'Res is json');
    
    $res = $renderer->as_html($data);
    $tb->ok($res eq $data->{text},'Res is html');
    
    $res = $renderer->empty($data);
    $tb->ok(!($res eq $data->{text}),'Res is empty');
    
    $res = $renderer->pager_data($data,20);
    $tb->ok($res->{page} eq $data->{page},'Res from pager_data');
    
    return;
}

#sub bad_data {
#    my($self,$req,$method,$data)=@_;
#    
#    foreach ( @$data ){
#        $req = WOA::REST::Generic::Request->new ( $method => $_) ;
#        $rest->request($req);
#        my $res = $rest->process;
#        $self->like($rest->status, qr/400/,"$method: response status: 400");
#    }
#    
#    return;
#}
#
#sub bad_method {
#    my($self,$req,$uri,$data)=@_;
#    
#    foreach ( @$data ){
#        $req = WOA::REST::Generic::Request->new ( $_ => $uri ) ;
#        $rest->request($req);
#        my $res = $rest->process;
#        $self->like($rest->status, qr/400/,"Request method: $_: response status: ".$rest->status);
#    }
#}

1;