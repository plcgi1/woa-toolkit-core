package WOAx::Helper::Page;
use strict;
use base 'WOAx::Helper';
use Template;
use Data::Dumper;

__PACKAGE__->follow_best_practice();
__PACKAGE__->mk_accessors(qw/config file_name app_full_path page_module_name tpl_name test_name/);

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
    my $mod_name = uc $a[-1];
    
    my $path = join '/',@a;
    my $full_path = $self->get_config->{root}.'/'.$app_name.'/lib/'.$path;
    $self->mk_dirs($full_path);
    $self->set_app_full_path($self->get_config->{root}.'/'.$app_name);
    
    my $vars = {
        page    => $namespace,
        tt_name => $path
    };    
    my $out;
    $tpl->process('page_pm.tt',$vars,\$out);
    my $filename = $full_path.'.pm';
    $self->mk_file($filename,$out,'Page controller');
    $self->set_page_module_name($filename);
    
    $full_path = $self->get_config->{root}.'/'.$app_name.'/'.$self->get_config->{app}->{templates}.'/'.$path;
    $self->mk_dirs($full_path);
    
    $out = undef;
    $filename = $full_path.'.tt';
    $tpl->process('page_tpl.tt',$vars,\$out);
    $self->mk_file($filename,$out,'Page template');
    $self->set_tpl_name($filename);
    
    $out = undef;
    $full_path = $self->get_config->{root}.'/'.$app_name.'/'.$self->get_config->{app}->{t}.'/'.$path;
    $self->mk_dirs($full_path);
    $tpl->process('page_t.tt',{page => $namespace},\$out);
    $filename = $full_path.'.t';
    $self->mk_file($filename,$out,'Page test');
    $self->set_test_name($filename);
    
    return;
}

1;

__END__

=head1 WOAx::Helper::Page


=head1 SYNOPSIS

TODO

=head1 DESCRIPTION

TODO

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