package WOAx::Helper::App;
use strict;

use base 'WOAx::Helper';
use Data::Dumper;

__PACKAGE__->mk_accessors(qw/app_sh app_conf app_psgi/);

sub run {
    my ( $self, $namespace ) = @_;
    my $pwd = $ENV{PWD};

    my $tpl = $self->tpl();

    my @a = split '::', $namespace;
    my $a = lc $self->get_config->{name} || lc $a[0];
    my $app_name = $self->normalize_app_name($a);

    my $path = join '/', @a;
    my $app_full_path = $self->get_config->{root} . '/' . $app_name;
    $self->mk_dir($app_full_path);
    $self->set_app_full_path($app_full_path);

    foreach ( keys %{ $self->get_config->{app} } ) {
        my $path = $app_full_path . '/' . $self->get_config->{app}->{$_};
        $self->mk_dir($path);
    }
    foreach (qw/css i js/) {
        my $path =
          $app_full_path . '/' . $self->get_config->{app}->{public} . '/' . $_;
        $self->mk_dir($path);
    }
      
    foreach (qw/dev min/) {
        my $path =
            $app_full_path . '/'
          . $self->get_config->{app}->{public} . '/js/'
          . $_;
        $self->mk_dir($path);
    }
    my $out;
    $tpl->process( 'app_main_module.tpl', { app_name => ucfirst $app_name },
        \$out )
      || die $tpl->error;
    
    if($app_name=~/\-/){
        my @a = split '-',$app_name;
        foreach (@a) {
            $_=ucfirst $_;
        }
        $app_name = join '',@a;
    }
        
    my $filename = $app_full_path . '/lib/' . ucfirst $app_name . '.pm';
    $self->mk_file( $filename, $out, 'Main app module' );

    $filename =
        $app_full_path . '/'
      . $self->get_config->{app}->{bin} . '/'
      . $app_name . '.sh';
    my $psgi =
        $app_full_path . '/'
      . $self->get_config->{app}->{psgi} . '/'
      . $app_name . '.psgi';
    $out = 'plackup -I' . $app_full_path . '/lib -p 3030 -a ' . $psgi;
    $self->mk_file( $filename, $out, 'App run script' );
    chmod 0755, $filename;
    $self->set_app_sh($filename);

    $out = undef;
    $tpl->process( 'app_conf.tpl',
        { app_name => ucfirst $app_name, app_root => $app_full_path }, \$out )
      || die $tpl->error;

    $filename =
        $app_full_path . '/'
      . $self->get_config->{app}->{etc} . '/'
      . $app_name . '.conf';
    $self->mk_file( $filename, $out, 'App config file' );
    $self->set_app_conf($filename);
    
    $out = undef;
    $tpl->process( 'psgi.tpl',
        { app_name => $app_name, app_root => $app_full_path, app_route_class=>$self->get_app_route_class($app_name) }, \$out )
      || die $tpl->error;

    $filename =
        $app_full_path . '/'
      . $self->get_config->{app}->{psgi} . '/'
      . $app_name . '.psgi';
    $self->mk_file( $filename, $out, 'App psgi file' );

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

woax-toolkit.pl -h


=head1 GIT repository

=begin html

<a href="https://github.com/plcgi1/woa-toolkit-core">https://github.com/plcgi1/woa-toolkit-core</a>

=end html



=head1 BUGS

Please report any bugs or suggestions at L<https://github.com/plcgi1/woa-toolkit-core>


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
