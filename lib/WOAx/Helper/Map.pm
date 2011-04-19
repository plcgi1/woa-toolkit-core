package WOAx::Helper::Map;
use strict;
use base 'WOAx::Helper';
use Template;
use Data::Dumper;

sub run {
    my ($self,$service_name) = @_;
    my $root = $ENV{PWD};
    
    my $tpl = $self->tpl();
    
    my $app_namespace = (split '/',$root)[-1];
    
    my $full_path = $root.'/lib/'.ucfirst $app_namespace.'/REST/'.ucfirst $service_name;
    $self->set_app_namespace($root);
        
    my $page_pm_name = $full_path.'/Map.pm';
    $self->mk_dirs($page_pm_name);
    $self->set_file_name($page_pm_name);
    my $vars = {
        service_name => $app_namespace.'::REST::'.ucfirst $service_name.'::Map',
    };    

    my $out;
    $tpl->process('map_pm.tt',$vars,\$out);
    $self->mk_file($page_pm_name,$out,'Map file');
    
    return;
}

1;

__END__

=head1 WOAx::Helper::Map


=head2 SYNOPSIS


=head2 DESCRIPTION


=head2 SEE ALSO

TODO

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut