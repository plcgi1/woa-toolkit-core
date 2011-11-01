package WOA::Component::Notify::Base;
use strict;
use Encode;
use WOA::Component::Notify::Exception;

use base 'Class::Accessor::Fast';
__PACKAGE__->mk_accessors(qw/error out view vars tt/);

sub new {
    my $class = shift;
    my %opt   = @_;
    my $self  = bless {}, $class;

    $self->init(%opt);
    return $self;
}

sub init {
    my $self = shift;
    my %opt  = @_;

}

sub run {
    my $self = shift;
}

sub done {
    my $self = shift;

    if ( $self->view() && $self->tt() ) {
        my $out;
        my $vars = $self->vars();
        $self->view->process( $self->tt(), $vars, \$out, )
          || WOAx::Component::Notify::Exception::View->throw(
            error => "Template toolkit error - " . $self->view->error() );

        #encode('utf8', $out);
        $self->out($out);
    }
}

sub process {
    my $self = shift;

    foreach (qw(run done)) {
        $self->$_();
    }

    return $self;
}

1;

__END__

=head1 NAME

WOAx::Component::Notify::Base

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
