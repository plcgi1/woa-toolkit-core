package WOA::Component::Notify::Mail;
use strict;
use Mail::Mailer;
use MIME::Base64;
use Encode;
use utf8;
use Encode qw/from_to decode/;

use base 'WOA::Component::Notify::Base';

my @fields = qw(from to cc subject tt mailer vars view contentType out headers);

__PACKAGE__->mk_accessors(@fields);

sub init {
    my ( $self, %opt ) = @_;

    foreach (@fields) {
        if ( $opt{$_} ) {
            $self->$_( $opt{$_} );
        }
    }

    return $self;
}

sub done {
    my $self = shift;

    unless ( $self->out ) {
        $self->SUPER::done();
    }

    $self->sendMail();
}

sub sendMail {
    my $self = shift;

    my $subj = $self->subject();

    $subj = $self->_utf_decoder($subj);

    $self->subject($subj);

    my $out = $self->out();
    if ( utf8::is_utf8($out) ) {
        Encode::_utf8_off($out);
    }

    my $contentType = $self->contentType || 'text/plain';

    my %data = (
        From                        => $self->from,
        To                          => $self->to,
        CC                          => $self->cc,
        Subject                     => Encode::encode( "MIME-Header", $subj ),
        'Content-Type'              => $contentType,
        'MIME-Version'              => '1.0',
        'Content-transfer-encoding' => '8bit',
    );
    if ( $self->headers ) {
        %data = ( %data, %{ $self->headers } );
    }
    eval {
        $self->mailer( Mail::Mailer->new("sendmail") );

        $self->mailer->open( \%data );

        my $mailH = $self->mailer();

        print $mailH $out;

        $self->mailer->close();
    };

    if ($@) {
        $self->error("Eval error: $@");
        warn "[ERROR OPEN MAIL]. " . $@;
    }

    return $self;
}

sub _utf_decoder {
    my ( $self, $str, $from ) = @_;
    $from = 'utf8' unless $from;
    unless ( utf8::is_utf8($str) ) {
        from_to( $str, $from, 'utf8' );
        $str = decode( 'utf8', $str );
    }
    return $str;
}

1;

__END__

=head1 NAME

WOAx::Component::Notify::Mail

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
