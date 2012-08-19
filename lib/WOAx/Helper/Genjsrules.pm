package WOAx::Helper::Genjsrules;
use strict;
use WOA::Loader qw/import_module/;

use Data::Dumper;
use FindBin qw/$Bin/;
use JSON::XS qw/encode_json/;
use Encode qw(from_to decode is_utf8);
use base 'WOAx::Helper';

sub run {
    my ( $self, $namespace ) = @_;

    my $tpl = $self->tpl();
    
    my $app_name = $self->app_name;
    
    my $service_ns    = ucfirst $app_name . '::REST::' . ucfirst $namespace;
    my $map_class     = $service_ns . '::Map';

    print __PACKAGE__." $map_class\n";

    my $map_file = $map_class;
    $map_file =~s/::/\//g;
    $map_file = $self->get_config->{root}.'/'.$self->get_config->{app}->{lib}.'/'.$map_file.'.pm';
    unless ( -f $map_file ) {
        die "[ERROR TO CREATE JAVASCRIPT RULES FROM MAP] '$map_file'.You should create map file at first with run 'woax-toolkit -a map -n YouServiceName' and fill it";
    }

    # load Map module
    require $map_file;

    # get map from Map
    my $map = $map_class->get_map();
    unless ( scalar @$map > 0 ) {
        die "[ERROR TO CREATE JAVASCRIPT RULES FROM MAP] '$map_file'.You should fill map file at first";
    }
    my %rules;
    foreach ( @$map ) {
        $rules{$_->{name}} = $_->{in}->{param};
    }
    my $json = encode_json(\%rules);
    $json = 'validator.'.$namespace.'='.$json.';';
    from_to( $json, 'utf8', 'utf8' );
    $json = decode( 'utf8', $json );
    
    my $file_name = $self->get_config->{app}->{javascript}->{validator_path}.'/'.$namespace.'.js';
    $self->mk_file( $file_name, $json, 'JSON VALIDATOR rules file' );
    
    return;
}

1;

__END__

=head1 NAME

WOAx::Helper::Genjsrules

=head1 SYNOPSIS

=head1 DESCRIPTION

Helper for woa-toolkit javascript rules from service map creating

=head2 EXPORT

TODO

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

Copyright (C) 2012 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
