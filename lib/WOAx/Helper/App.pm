package WOAx::Helper::App;
use strict;
use base 'WOAx::Helper';
use Template;
use Data::Dumper;

__PACKAGE__->follow_best_practice();
__PACKAGE__->mk_accessors(qw/config file_name app_full_path app_sh app_conf app_psgi/);

sub run {
    my ($self,$namespace) = @_;
    my $pwd = $ENV{PWD};
    my $tpl = Template->new({
        INCLUDE_PATH => [
            $self->get_config->{template_root},
        ],
        TIMER               => 1,
        DEFAULT_ENCODING    => 'utf8',
    }); 
    
    my @a = split '::',$namespace;
    my $app_name = lc $a[0];
    
    my $path = join '/',@a;
    my $app_full_path = $self->get_config->{root}.'/'.$app_name;
    $self->mk_dir($app_full_path);
    $self->set_app_full_path($app_full_path);
    
    if ( $app_name =~/(\-)/ ) {
        my @arr = split $1,$app_name;
        foreach my $i( @arr ) {
            $i = ucfirst $i;
        }
        $app_name = lcfirst (join '',@arr);
    }
    foreach ( keys %{$self->get_config->{app}}) {
        my $path = $app_full_path.'/'.$self->get_config->{app}->{$_};
        $self->mk_dir($path);
    }
    foreach ( qw/css i js/ ) {
        my $path = $app_full_path.'/'.$self->get_config->{app}->{public}.'/'.$_;
        $self->mk_dir($path);
    }
    foreach ( qw/dev min/ ) {
        my $path = $app_full_path.'/'.$self->get_config->{app}->{public}.'/js/'.$_;
        $self->mk_dir($path);
    }
    my $out;
    $tpl->process('app_main_module.tt',{app_name=>ucfirst $app_name},\$out) || die $tpl->error;
    
    my $filename = $app_full_path.'/lib/'.ucfirst $app_name.'.pm';
    $self->mk_file($filename,$out,'Main app module');
        
    $filename = $app_full_path.'/'.$self->get_config->{app}->{bin}.'/'.$app_name.'.sh';
    my $psgi = $app_full_path.'/'.$self->get_config->{app}->{psgi}.'/'.$app_name.'.psgi';
    $out = 'plackup -I'.$app_full_path.'/lib -p 3030 -a '.$psgi;
    $self->mk_file($filename,$out,'App run script');
    chmod 0755,$filename; 
    $self->set_app_sh($filename);
    
    $out = undef;
    $tpl->process('app_conf.tt',{app_name=>ucfirst $app_name,app_root=>$app_full_path},\$out) || die $tpl->error;
    
    $filename = $app_full_path.'/'.$self->get_config->{app}->{etc}.'/'.$app_name.'.conf';
    $self->mk_file($filename,$out,'App config file');
    $self->set_app_conf($filename);
    
    $out = undef;
    $tpl->process('psgi.tt',{app_name=>$app_name,app_root=>$app_full_path},\$out) || die $tpl->error;
    
    $filename = $app_full_path.'/'.$self->get_config->{app}->{psgi}.'/'.$app_name.'.psgi';
    $self->mk_file($filename,$out,'App psgi file');
    
    $self->set_app_psgi($filename);
    return;
}

1;

__END__

=head1 WOAx::Helper::App

=head1 SYNOPSIS

use it via wapp-create.pl script

=head1 DESCRIPTION

create skeleton for woax-psgi application

=head1 SEE ALSO

wapp-create.pl -h

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut