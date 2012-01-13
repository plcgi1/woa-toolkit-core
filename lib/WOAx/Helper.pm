package WOAx::Helper;
use strict;
use Template;
use WOA::Loader qw/create_object/;
use File::Basename;
use File::Find;

use base 'Class::Accessor::Fast';

__PACKAGE__->follow_best_practice();
__PACKAGE__->mk_accessors(
    qw/app_full_path app_lib app_namespace config file_name app_route_class/);

my (@rules);

sub process {
    my ( $self, $param ) = @_;

    if ( $param->{sub} && ref $param->{sub} eq 'CODE' ) {
        $param->{sub}->();
    }
    return;
}

sub tpl {
    my ( $self, $param ) = @_;
    my $tpl = Template->new(
        {
            INCLUDE_PATH     => [ $self->get_config->{template_root}, ],
            TIMER            => 1,
            DEFAULT_ENCODING => 'utf8',
        }
    );
    return $tpl;
}

sub get_app_route_class {
    my ( $self, $app_name ) = @_;
    return ucfirst $app_name.'::RouteMap';
}

sub mk_dirs {
    my ( $self, $page_pm_name ) = @_;

    my @a = split '/', $page_pm_name;
    shift @a;
    my $fname = pop @a;
    my $dir   = "/" . $a[0];
    shift @a;
    for ( my $i = 0 ; $i <= int scalar @a ; $i++ ) {
        unless ( -d $dir ) {
            print "[CREATE DIR] " . $dir . "\n";
            mkdir $dir;
        }
        if ( $a[$i] ) {
            $dir = $dir . '/' . $a[$i];
        }
    }
    $self->set_file_name($page_pm_name);
    return;
}

sub get_template_root {
    my ( $self, $conf ) = @_;
    $conf =~ s/conf/Templates/;
    return $conf;
}

sub get_config_file {
    my ($self) = @_;

    my $conf_file;
    if ( -f $ENV{HOME} . '/.woa-toolkit/conf' ) {
        $conf_file = $ENV{HOME} . '/.woa-toolkit/conf';
    }
    elsif ( -f '/usr/share/woa-toolkit/conf' ) {
        $conf_file = '/usr/share/woa-toolkit/conf';
    }
    elsif ( -f '/usr/local/share/woa-toolkit/conf' ) {
        $conf_file = '/usr/local/woa-toolkit/wapp/conf';
    }
    elsif ( -f dirname(__FILE__) . '/Helper/conf' ) {
        $conf_file = dirname(__FILE__) . '/Helper/conf';
    }
    else {
        die "Cant find config file";
    }
    return $conf_file;
}

sub get_object {
    my ( $self, $type, $config ) = @_;
    my $classname = __PACKAGE__ . '::' . ucfirst $type;
    my $object    = create_object($classname);
    if ( $object->can('set_config') ) {
        $object->set_config($config);
    }
    return $object;
}

sub mk_dir {
    my ( $self, $path ) = @_;
    unless ( -d $path ) {
        print "[CREATING] $path\n";
        mkdir $path;
    }
    return;
}

sub mk_file {
    my ( $self, $filename, $content, $topic ) = @_;
    print "[CREATING $topic] " . $filename . "\n";
    open F, ">" . $filename;
    print F $content;
    close F;
}

sub normalize_app_name {
    my ( $self, $app_name ) = @_;
    if ( $app_name =~ /(\-)/ ) {
        my @arr = split $1, $app_name;
        foreach my $i (@arr) {
            $i = ucfirst $i;
        }
        $app_name = lcfirst( join '', @arr );
    }
    else {
        $app_name = ucfirst $app_name;
    }
    return $app_name;
}

sub get_rules {
    my($self,$app_root,$service_prefix,$app_name) = @_;
    my $rules = [];
    my @hash;
    push @INC,$ENV{PWD} . '/lib';
    if ( -d $app_root.'/REST' ){
        opendir D,$app_root.'/REST';
        while ( my $dir = readdir D ){
            next if $dir=~/(\.|\.\.)/;
            my $map_class = ucfirst $service_prefix.'::'.$dir.'::Map';
            
            WOA::Loader::import_module($map_class);
            my $map = $map_class->get_map();
            my %hash;
            foreach my $item ( @$map ) {
                $hash{$item->{regexp}} = { class => $service_prefix.'::'.$dir.'::SP' }; 
            }
            foreach my $path ( keys %hash ) {
                push @hash, {
                    path    => $path,
                    class   => $hash{$path}->{class},
                    app     => $app_name
                };
            }
        }
        closedir D;
    }
 	# page map save in global  @rules;
    find(\&recursive_find,$app_root.'/Page');
    @hash = (@hash,@rules);
    return \@hash;
}

sub update_route_map {
    my($self,$tpl,$app_name) = @_;
    my $pm_name = $ENV{PWD} . '/lib/'.ucfirst $app_name.'/RouteMap.pm';
    my $vars = {
        app_name    => $app_name,
        lc_app_name => lc $app_name,
        rules       => $self->get_rules($ENV{PWD} . '/lib/'.ucfirst $app_name,ucfirst $app_name . '::REST',$app_name)
    };
    my $out;
    $tpl->process( 'url_mapper.tpl', $vars, \$out );
    $self->mk_file( $pm_name, $out, 'RouteMap module' );
    return;
}

sub recursive_find {
	if ( (-f $File::Find::name) && $File::Find::name=~/.*(\.pm)$/ ) {
		my $map_class = $File::Find::name;
        $map_class =~s/.*\/lib//g;
        $map_class=~s/\.pm$//;
        $map_class=~s/^\///;
        $map_class=~s/\//::/g;
        $map_class = ucfirst $map_class;
        #my $map_class = $service_prefix.'::'.$dir.'::Map';
        
        WOA::Loader::import_module($map_class);
        my $map = $map_class->get_map();
        my %hash;
        foreach my $item ( @$map ) {
            $hash{$item->{regexp}} = { class => $map_class }; 
        }
        foreach my $path ( keys %hash ) {
            push @rules, {
                path    => $path,
                class   => $map_class,
            };
        }
	}
}

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

TODO

=head1 SEE ALSO

TODO


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
