package WOAx::Helper::Page;
use strict;
use base 'WOAx::Helper';
use Data::Dumper;

__PACKAGE__->mk_accessors(qw/page_module_name tpl_name test_name/);

sub run {
    my ( $self, $name ) = @_;
    my $pwd = $ENV{PWD};
    my $tpl = $self->tpl();

    my $app_namespace = ( split '/', $pwd )[-1];
    my $name_as_path = $name;
    $name_as_path =~ s/::/\//g;
    my $page = ucfirst $app_namespace . '::Page::' . $name;
    my $full_path =
        $pwd . '/lib/'
      . ucfirst $app_namespace
      . '/Page/'
      . $name_as_path . '.pm';
    $self->set_app_namespace($pwd);
    $self->set_page_module_name($full_path);

    $self->mk_dirs($full_path);
    my $path_to_tpl = $page;
    $path_to_tpl =~ s/::/\//g;
    $path_to_tpl .= '.tt';

    $self->mk_dirs( $pwd . '/templates/' . $path_to_tpl );

    my $vars = {
        page    => $page,
        tt_name => $path_to_tpl
    };
    my $out;
    $tpl->process( 'page_pm.tt', $vars, \$out );
    $self->mk_file( $full_path, $out, 'Page controller' );

    $out = undef;
    $tpl->process( 'page_tpl.tt', $vars, \$out );
    $self->mk_file( $pwd . '/templates/' . $path_to_tpl, $out,
        'Page template' );
    $self->set_tpl_name( $pwd . '/templates/' . $path_to_tpl );

    $out = undef;
    my $test_name = $pwd . '/t/page_' . $name . '.t';
    $self->mk_dirs($test_name);
    $tpl->process( 'page_t.tt', { page => $page }, \$out );
    $self->mk_file( $test_name, $out, 'Page test' );
    $self->set_test_name($test_name);

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
