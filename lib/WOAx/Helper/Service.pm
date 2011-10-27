package WOAx::Helper::Service;
use strict;
use WOA::Loader qw/import_module/;

use Data::Dumper;
use FindBin qw/$Bin/;
use base 'WOAx::Helper';

sub run {
    my ( $self, $namespace ) = @_;

    my $tpl = $self->tpl();

    my $app_name      = $self->normalize_app_name(( split '/', $ENV{PWD} )[-1]);
    
    my $service_ns    = ucfirst $app_name . '::REST::' . $namespace;
    my $map_class     = $service_ns . '::Map';
    my $backend_class = $service_ns . '::Backend';
    my $sp_class      = $service_ns . '::SP';
    print "$map_class\n";

    # load Map module
    use lib ( $ENV{PWD} . '/lib' );
    WOA::Loader::import_module($map_class);

    # get map from Map
    my $map = $map_class->get_map();

    # create SP module
    $self->mk_dirs($sp_class);
    my $vars = { service_name => $service_ns };
    my $out;
    my $pm_name = $sp_class;
    $pm_name =~ s/::/\//g;
    $pm_name = $ENV{PWD} . '/lib/' . $pm_name . '.pm';

    $tpl->process( 'sp_pm.tpl', $vars, \$out );
    $self->mk_file( $pm_name, $out, 'SP file' );

    # create Backend module - by map
    $pm_name = $backend_class;
    $pm_name =~ s/::/\//g;
    $pm_name = $ENV{PWD} . '/lib/' . $pm_name . '.pm';
    foreach (@$map) {
        push @{ $vars->{methods} }, $_->{func_name};
    }
    $out = undef;
    $tpl->process( 'backend_pm.tpl', $vars, \$out );
    $self->mk_file( $pm_name, $out, 'Backend file' );

    # create test file
    $pm_name = $ENV{PWD} . '/t/' . $sp_class . '.t';
    $out     = undef;
    $tpl->process( 'sp_t.tpl', $vars, \$out );
    $self->mk_file( $pm_name, $out, 'Test file' );
    
    # recreate urlmapping config
    $pm_name = $ENV{PWD} . '/lib/'.ucfirst $app_name.'/RouteMap.pm';
    $vars = {
        app_name    => $app_name,
        lc_app_name => lc $app_name,
        rules       => $self->get_rules($ENV{PWD} . '/lib/'.ucfirst $app_name,ucfirst $app_name . '::REST',$app_name)
    };
    
    $out     = undef;
    $tpl->process( 'url_mapper.tpl', $vars, \$out );
    $self->mk_file( $pm_name, $out, 'RouteMap module' );

    return;
}

#sub get_rules {
#    my($self,$app_root,$app_name) = @_;
#    my $rules = [];
#    my %hash;
#    opendir D,$app_root.'/REST';
#    while ( my $dir = readdir D ){
#        next if $dir=~/(\.|\.\.)/;
#        my $map_class = $app_name.'::'.$dir.'::Map';
#        WOA::Loader::import_module($map_class);
#        my $map = $map_class->get_map();
#        foreach my $item ( @$map ) {
#            #push @$rules,{ path => $item->{regexp}, class => $app_name.'::'.$dir.'::SP' };
#            $hash{$item->{regexp}} = $app_name.'::'.$dir.'::SP';
#        }
#    }
#    closedir D;
#    return \%hash;
#}

1;

__END__

=head1 NAME

WOAx::Helper::Service

=head1 SYNOPSIS

=head1 DESCRIPTION

Helper for woa-toolkit service creating

=head2 EXPORT

TODO

=head1 SEE ALSO

woax-toolkit.pl -h


=head1 GIT repository

=begin html

<a href="https://github.com/plcgi1/woa-toolkit-core">https://github.com/plcgi1/woa-toolkit-core</a>

=end html


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
