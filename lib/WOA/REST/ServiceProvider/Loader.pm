package WOA::REST::ServiceProvider::Loader;
use strict;
use base 'Class::Accessor::Fast';
use Class::Inspector;
use Data::Dumper;

__PACKAGE__->mk_accessors(qw/error loaded_class/);

sub load {
    my ($self,$path) = @_;

    if ( ref $self->rules eq 'ARRAY') {
        foreach ( @{$self->rules} ) {
            my $sp_class_name = $_->{sub}->($self,$path);
            if ( $sp_class_name ) {
                # load class
                if ( Class::Inspector->loaded($sp_class_name) ) {
                    $self->loaded_class($sp_class_name);
                }
                else {
                    my $sp_file_name = Class::Inspector->filename($sp_class_name);
                    
                    eval {
                        require $sp_file_name;
                    };
                    if ( $@ ) {
                        $self->process_error($sp_file_name,$@);
                    }
                    else {
                        $self->loaded_class($sp_class_name);
                    }
                }
                last;
            } # END if ( $sp_class_name ) 
        } # END foreach ( @{$self->rules} )
    }

    return;
}

sub process_error {
    my($self,$module,$error)=@_;
    if ( $error ) {
        $self->error("[CANT LOAD MODULE] $module - \"$error\".");
    }
    return;
}

sub rules {
    return [
        {
            sub => sub {
                my($self,$path) = @_;
                my $res;
                # rule: /woax/appname/rest/servicename -> WOAx::App::AppName::REST::ServiceName::SP
                if ( $path=~/\/woax\/(.*)\/rest\/(.*)(\/)*/g ) {
                    $res = 'WOAx::App::'.ucfirst($1).'::REST::'.ucfirst ($2).'::SP';
                }
                
                return $res;
            }
        }
    ];
}

1;

__END__


=head1 WOA::REST::ServiceProvider::Loader

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