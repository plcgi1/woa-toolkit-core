# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Validator.t'

#########################

use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib (
    $Bin. '/../lib',
);
use WOA::Validator;
use Data::Dumper;
use WOA::Config::Provider;
use WOAx::Helper;

BEGIN { use_ok('WOAx::Helper') }

#########################

my $conf_file = WOAx::Helper->get_config_file();
my $config = WOA::Config::Provider->get_config($conf_file);

$config->{template_root} = WOAx::Helper->get_template_root($conf_file);

my $namespace = 'woaxtest';

my $obj = WOAx::Helper->get_object('app',$config);
#$obj->run($namespace);
WOAx::Helper->process({
    sub => sub {
        $obj->run($namespace);
    }
});

ok(-d $obj->get_app_full_path,"app_full_path exists");

foreach ( keys %{$config->{app}} ) {
    my $fname = $obj->get_app_full_path.'/'.$config->{app}->{$_};
    ok(-d $fname,"app_full_path exists - $fname");
}

foreach ( qw/css i js/ ) {
    my $fname = $obj->get_app_full_path.'/'.$config->{app}->{public}.'/'.$_;
    ok(-d $fname,"public_path exists - $fname");
}

foreach ( qw/dev min/ ) {
    my $fname = $obj->get_app_full_path.'/'.$config->{app}->{public}.'/js/'.$_;
    ok(-d $fname,"public_path exists - $fname");
}

foreach ( qw/app_sh app_conf app_psgi/ ) {
    my $fn = 'get_'.$_;
    my $fname = $obj->$fn;
    ok(-f $fname,"$_ exists - $fname");
}
my $app_full_path = $obj->get_app_full_path;

$ENV{PWD} = $app_full_path;

$obj = WOAx::Helper->get_object('map',$config);
WOAx::Helper->process({
    sub => sub {
        $obj->run($namespace);
    }
});
ok(-f $obj->get_file_name,"map file exists - ".$obj->get_file_name);

$obj = WOAx::Helper->get_object('page',$config);
WOAx::Helper->process({
    sub => sub {
        $obj->run($namespace);
    }
});
foreach (qw/page_module_name tpl_name test_name/) {
    my $f = 'get_'.$_;
    ok(-f $obj->$f,"file exists - ".$obj->$f);    
}

system 'rm','-R',$app_full_path;