use common::sense;
use Log::Log4perl;
use File::Basename;
use Plack::Builder;
use Plack::Middleware::WOAx::App;

use WOA::Config::Provider;
use Log::Log4perl;
use Template;
use Template::Provider::Encoding;
use Template::Stash::ForceUTF8;
use Plack::App::File;
use Cache::Memcached;
use WOA::REST::ServiceProvider::Loader;
use WOA::Component::AppRegistrator;
use [%app_route_class%];

# use your app model classes

# define your app services classes

# define your app pages classes


my $app_root    = dirname(__FILE__).'/../';

my $config = WOA::Config::Provider->get_config($app_root.'/etc/[%app_name%].conf');
my $tpl = Template->new({
    INCLUDE_PATH => [
        $config->{template_root},
    ],
    TIMER               => 1,
    DEFAULT_ENCODING    => 'utf8',
});

Log::Log4perl::init($config->{log4perl});

my $controller_param = {
    config              => $config,
    renderer            => $tpl
};

# create handlers for your services
#    my $rest = Plack::Middleware::WOAx::App->new({
#        service_provider    => 'ServiceProviderClassName',
#        %$controller_param
#    });

# create handlers for your pages
#    my $page = Plack::Middleware::WOAx::App->new({
#        service_provider    => 'PageClassName',
#        %$controller_param
#    });

### Uncomment this - if need
#my $rules = [%app_route_class%]->get_rules;
#my $ar = WOA::Component::AppRegistrator->new({
#    storage     => Cache::Memcached->new($config->{cache}),
#});
#$ar->register($config->{app_name},$rules);
#my $app = Plack::Middleware::WOAx::App->new({
#    service_provider =>  WOA::REST::ServiceProvider::Loader->new({
            # app_registrator => $ar,
#            rules => $rules
#        }
#    }),
#    %$controller_param
#});

builder {
    enable "Plack::Middleware::Static",  path => qr{\.(i|js|css|html|png|gif|ico|jpg|json|xml|txt)$}, root => "$app_root/public";
    enable "Plack::Middleware::AccessLog", format => "combined";
    enable "Plack::Middleware::ContentMD5";
    enable "Session",   store       => "File";
    
    # uncomment it if you need some state for all pages and request
    #enable "Plack::Middleware::WOAx::Project";
    
    # from $env->{'psgix.logger'}
    enable "Log4perl", category => "main";
        
    # mount pages
    #   mount "/any/path/to/page/method" => $page;
    
    # mount services
    #   mount "/any/path/to/service/method" => $rest;
    
    # or with dynamic mapping
    #foreach ( @{$rules} ) {
    #    mount $_->{path} => $app;    
    #}
    #$app;
};