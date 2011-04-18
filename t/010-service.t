# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Validator.t'

#########################

use Test::More qw(no_plan);
use FindBin qw($Bin);
use lib (
    $Bin. '/../lib',
    $Bin. '/../../core/lib'
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

my $namespace = 'Aaa::Bbbbb::Ccc';

my $obj = WOAx::Helper->get_object('service',$config);

WOAx::Helper->process({
    sub => sub {
        $obj->run($namespace);
    }
});

#foreach (qw/page_module_name tpl_name test_name/) {
#    my $f = 'get_'.$_;
#    ok(-f $obj->$f,"file exists - ".$obj->$f);    
#}

system 'rm -R '.$obj->get_app_full_path;
