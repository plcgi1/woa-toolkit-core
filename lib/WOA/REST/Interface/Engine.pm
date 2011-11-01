package WOA::REST::Interface::Engine;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/request map backend view content_type output status location error_message current_method/);

sub cleanup {
    die "cleanup not implemented";
}

sub process {
    die "cleanup not implemented";    
}

sub get_from_map {
    die "get_from_map not implemented";    
}

sub get_method {
    die "get_method not implemented";        
}

sub set_error {
    die "set_error not implemented";            
}

sub get_req_meth {
    die "get_req_meth not implemented";    
}

sub args_for_method {
    die "args_for_method  not implemented";        
}

sub validate {
    die "validate not implemented";            
}

sub adopt_args {
    die "adopt_args not implemented";                
}

sub version {
    die "version not implemented";                    
}

sub log_request {
    die "log_request not implemented";                        
}

sub check_access {
    die "check_access not implemented";                        
}

sub finalize {
    die "finalize not implemented";                            
}

1;

__END__


=head1 NAME

WOA::REST::Interface::Engine

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