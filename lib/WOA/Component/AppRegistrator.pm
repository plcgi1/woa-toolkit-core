package WOA::Component::AppRegistrator;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/storage global_key/);

sub new {
    my($class,$param)=@_;
    my $self = $class->SUPER::new($param);
    bless $self,$class;
    $self->{global_key} ||= 'woa-toolkit';
    return $self;
}

sub register {
    my ( $self, $app_name, $rules ) = @_;
    my $all_app_info = $self->storage->get($self->global_key);
        
    $all_app_info->{$app_name} = $rules;
        
    my $res = $self->storage->set($self->global_key,$all_app_info);
    
    return $res;
}

sub get_rules {
    my ( $self,$app_name ) = @_;
    my $all_app_info = $self->storage->get($self->global_key);
    return $all_app_info->{$app_name};
}

sub get_all {
    my ( $self ) = @_;
    my $all_app_info = $self->storage->get($self->global_key);
    return $all_app_info;
}

sub update_rule {
    my ( $self,$app_name,$rule_as_hash,$index ) = @_;
    
    my $all_app_info = $self->storage->get($self->global_key);
    $all_app_info->{$app_name}->[$index] = $rule_as_hash;
    $self->storage->set($self->global_key,$all_app_info);
    
    return { $app_name => $all_app_info->{$app_name} };
}

sub delete_rule {
    my ( $self,$app_name,$rule_as_hash ) = @_;
    
    my $all_app_info = $self->storage->get($self->global_key);
    my $rules = $all_app_info->{$app_name};
    my @new_rules;
    foreach ( @$rules ) {
        if ( $_->{path} eq $rule_as_hash->{path} ) {
            next;
        }
        push @new_rules,$_;
    }
    $all_app_info->{$app_name} = \@new_rules;
    $self->storage->set($self->global_key,$all_app_info);
    return { $app_name => \@new_rules };
}

1;


__END__

=head1 NAME

WOA::Component::AppRegistrator

=head1 SYNOPSIS

TODO

=head1 DESCRIPTION

Registration rules for routing in storage and get info foreach application.Used in L<WOA::REST::ServiceProvider::Loader>

=head2 METHODS

TODO

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

