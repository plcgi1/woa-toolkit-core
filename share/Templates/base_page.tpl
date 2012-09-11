package [%service_name%]::Page;
use common::sense;
use base 'WOA::REST::ServiceProvider';
use [%service_name%]::REST::View;
use [%service_name%]::REST::Engine;

__PACKAGE__->mk_accessors(qw/view model session config formatter env request log/); 

sub get_map { die "Must be implemented" }

sub service_object {
    my ( $self, $env ) = @_;

    $self->set_session($env->{'session'});
    $self->set_config($env->{config});
    $self->set_model($env->{model});
    $self->set_request($env->{request});
    $self->set_env($env->{env});
    $self->set_formatter($env->{formatter});
    $self->set_log($env->{log});
    $self->set_stash({
        acl => $env->{'session'}->{acl}
    });
    my $view    = [%service_name%]::REST::View->new({ renderer => $env->{renderer} });
    my $rest    = [%service_name%]::REST::Engine->new({
        map     =>  $self->get_map,
        backend =>  $self,
        view    =>  $view,
    });
        
    return $rest;
}

1;