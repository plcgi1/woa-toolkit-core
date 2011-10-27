package WOA::REST::ServiceProvider::Loader;
use strict;
use WOA::Component::AppRegistrator;
use Class::Inspector;
use Data::Dumper;
use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/error loaded_class rules app_registrator/);

my $DEFAULT_RULES = [
    {
        class => sub {
            my ( $self, $path ) = @_;
            my $res;

# rule: /woax/appname/rest/servicename -> WOAx::App::AppName::REST::ServiceName::SP
            if ( $path =~ /\/woax\/(.*)\/rest\/(.*)(\/)*/g ) {
                $res =
                    'WOAx::App::'
                  . ucfirst($1)
                  . '::REST::'
                  . ucfirst($2) . '::SP';
            }

            return $res;
          },
        path => qr{\/woax\/(.*)\/rest\/(.*)(\/)*}
    }
];

sub new {
    my($class,$param)=@_;
    my $self = $class->SUPER::new($param);
    bless $self,$class;
    $self->rules($param->{rules} || $DEFAULT_RULES);
    return $self;
}

sub load {
    my ( $self, $path, $app_name ) = @_;
    
    my $rules;
    if( $self->app_registrator ) {
        $rules = $self->app_registrator->get_rules($app_name);  
    }
    else {
        $rules = $self->rules;
    }
    
    if ( ref $rules eq 'ARRAY' ) {
        foreach ( @{ $rules } ) {
            my $sp_class_name;
            if ( ref $_->{class} eq 'CODE' ) {
                $sp_class_name = $_->{class}->( $self, $path, $app_name );
            }
            else {
                $sp_class_name = $_->{class};
            }
            my $re_from_path = $_->{path};
            
            if ($sp_class_name && $path && $_->{path} && ($path eq $_->{path} || $path=~/$re_from_path/)) {
                # load class
                if ( Class::Inspector->loaded($sp_class_name) ) {
                    $self->loaded_class($sp_class_name);
                }
                else {
                    my $sp_file_name = Class::Inspector->filename($sp_class_name);

                    eval { require $sp_file_name; };
                    if ($@) {
                        $self->process_error( $sp_file_name, $@ );
                    }
                    else {
                        $self->loaded_class($sp_class_name);
                    }
                }
                last;
            } # END if ( $sp_class_name )
            else {
                $self->process_error( 'Empty class',
                    'I dont know - what to load' );
            }
        }# END foreach ( @{$self->rules} )
    }

    return;
}

sub process_error {
    my ( $self, $module, $error ) = @_;
    if ($error) {
        $self->error("[CANT LOAD MODULE - NOT FOUND] $module - \"$error\".");
    }
    return;
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


=head1 GIT repository

=begin html

<a href="https://github.com/plcgi1/woa-toolkit-core">https://github.com/plcgi1/woa-toolkit-core</a>

=end html


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
