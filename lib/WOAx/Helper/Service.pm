package WOAx::Helper::Service;
use strict;
use base 'Class::Accessor::Fast';
use Template;
use Data::Dumper;

__PACKAGE__->follow_best_practice();
__PACKAGE__->mk_accessors(qw/config file_name/);

sub run {
    my ($self,$namespace,$service_name) = @_;
    my $tpl = Template->new({
        INCLUDE_PATH => [
            $self->get_config->{template_root},
        ],
        TIMER               => 1,
        DEFAULT_ENCODING    => 'utf8',
    }); 
    
    my @a = split '::',$namespace;
    my $path = join '/',@a;
    my $page_pm_name = $ENV{PWD}.'/lib/'.$path.'.pm';
    $self->mk_dirs($page_pm_name);
    
    my $tt_name = $self->get_file_name;
    $tt_name=~s/lib/templates/;
    $tt_name=~s/\.pm$/\.tt/;
    my $name_for_vars = $tt_name;
    my $pwd = $ENV{PWD};
    $name_for_vars =~s/$pwd\/templates//;
    $name_for_vars =~s/^\///;
    my $vars = {
        page    => $namespace,
        tt_name => $name_for_vars
    };    
    my $out;
    $tpl->process('page_pm.tt',$vars,\$out);
    print "[CREATING Page controller] ".$self->get_file_name."\n"; 
    open F,">".$self->get_file_name;
    print F $out;
    close F;
    
    $page_pm_name = $ENV{PWD}.'/templates/'.$path.'.pm';
    $self->mk_dirs($page_pm_name);
        
    @a = undef;
    my $tpl_file_name = $self->get_config->{template_root}."/page_tpl.tt";
    unless ( -f $tpl_file_name ){
        die "You must define template file for your templates in app";
    }
    open F,$tpl_file_name;
    while(<F>){ push @a,$_;}
    close F;
    print Dumper \@a;    
    print "[FROM TEMPLATE] $tpl_file_name\n";
    print "[CREATING TEMPLATE] $tt_name\n";
    open F,">$tt_name";
    print F join '',@a;
    close F;
    
    return;
}

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

TODO

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut