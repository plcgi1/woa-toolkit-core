package WOA::Component::UploadHandler;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors(qw/model request target saved_info/);

sub tmp_save {
    my ( $self, $session ) = @_;
    die "[tmp_save] must be implemented";
}

sub commit {
    my($self) = @_;
    die "[commit] must be implemented";
}

1;


__END__


=head1 WOA::Component::UploadHandler - interface for handle upload operations

=head1 SYNOPSIS

my $u = WOA::Component::UploadHandler->new({
    model       => $your_database_storage_handler, # DBI
    request     => $request_object, # interface: as HTTP::Request
    target      => $path_to_filesystem_where_save_uploaded_file,
});

# after first request with uploaded file we save some data in session storage and filecontent - to tmp filesystem
$u->tmp_save($session_object_or_hashref);

# after second request - save all data to database and filesystem
$u->commit();

# get files list

=head1 DESCRIPTION

Component for hanlde operations with uploaded files

=head2 EXPORT


=head3 


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
