package WOAx::Helper;
use strict;
use Template;
use WOA::Loader qw/create_object/;
use File::Basename;
use base 'Class::Accessor::Fast';

__PACKAGE__->follow_best_practice();
__PACKAGE__->mk_accessors(
    qw/app_full_path app_lib app_namespace config file_name app_route_class/);

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
    if ( -f dirname(__FILE__) . '/Helper/conf' ) {
        $conf_file = dirname(__FILE__) . '/Helper/conf';
    }
    elsif ( -f $ENV{HOME} . '/.woax-toolkit/conf' ) {
        $conf_file = $ENV{HOME} . '/.woax-toolkit/conf';
    }
    elsif ( -f '/usr/share/woax-toolkit/conf' ) {
        $conf_file = '/usr/share/woax-toolkit/conf';
    }
    elsif ( -f '/usr/local/share/woax-toolkit/conf' ) {
        $conf_file = '/usr/local/woax-toolkit/wapp/conf';
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

1;

__END__

=head1 NAME


=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 EXPORT

TODO

=head1 SEE ALSO

TODO

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
