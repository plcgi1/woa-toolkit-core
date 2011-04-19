package WOAx::Helper::Service;
use strict;
use base 'WOAx::Helper';

use Data::Dumper;

__PACKAGE__->mk_accessors(qw//);

sub run {
    my ($self,$namespace) = @_;
    
    my $tpl = $self->tpl();
    
    my $app_namespace = (split '/',$ENV{PWD})[-1];
    # load Map module
    # get map from Map
    # 
    # create Backend module - by map
    # create SP module
    # create test file
    
    #my $name_as_path = $name;
    #$name_as_path=~s/::/\//g;
    #my $page = ucfirst $app_namespace.'::Page::'.$name;
    #my $full_path = $pwd.'/lib/'.ucfirst $app_namespace.'/Page/'.$name_as_path.'.pm';
    #$self->set_app_namespace($pwd);
    #$self->set_page_module_name($full_path);
    
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