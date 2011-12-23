package WOA::Component::ACL;
use strict;
use parent 'Class::Accessor::Fast';
use Data::Dumper;
use Digest::SHA1 qw/sha1_hex/;
use Time::HiRes;
use JSON::XS qw/encode_json decode_json/;
use WOA::Component::ACL::DBIx;

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors(qw/config model fast_storage/);

# length for message sign
my $DEFAULT_LENGTH = 64;

# length for idKey
my $DEFAULT_UNIQID_LENGTH = 12;

my $DEFAULT_TTL = 86400;

sub new {
    my($class,$param)=@_;
    
    my $self = $class->SUPER::new($param);
    bless $self,$class;
    
    my $config = $param->{config};
    
    my $model = WOA::Component::ACL::DBIx->connect(
        $config->{acl}->{connect_info}->[0],
        $config->{acl}->{connect_info}->[1],
        $config->{acl}->{connect_info}->[2],
        {
            on_connect_do => $config->{acl}->{on_connect_do}
        }
    );
    $self->set_model($model);
    
    return $self;
}

sub default {
    return {
        length          => $DEFAULT_LENGTH,
        uniqid_length   => $DEFAULT_UNIQID_LENGTH,
        ttl             => $DEFAULT_TTL
    };
}

sub login {
    my ($self,$param) = @_;
    my $res;
    my @rs = $self->get_model()->resultset('Application')->search({token => $param->{token}},{ limit => 1 });
    if ( $rs[0] ) {
        my @user = $self->get_model()->resultset('UserApplication')->search(
            {
                'users.login'       => $param->{login},
                'users.password'    => sha1_hex($param->{password}),
                'app.id'            => $rs[0]->get_column('id')
            },
            {
                join    => [qw/users app/],
                select  => [qw/users.login users.actions/],
                as      => [qw/login actions/],
                limit   => 1
            }
        );
        if ( $user[0] ) {
            # get ACL user data
            $res->{acl} = $self->_get_acl_data($user[0],$rs[0]);
            # create token with TTL
            # set ACL user data to response
            $res->{token} = $self->_uniqid();
            
            # save ACL user data to fast_storage with token
            $param->{ttl} ||= $self->default->{ttl};
                        
            $self->get_fast_storage()->set($res->{token},$res->{acl},$param->{ttl});
        } # END if ( $user[0] )
    } # END if ( $rs[0] )
    return $res;
}

sub logout {
    my ( $self, $param ) = @_;

    # make return with values - for tests
    my $d = $self->get_fast_storage()->delete($param->{token});
        
    return;
}

sub is_auth {}

sub check_access {
    my ( $self, $method, $method_data, $user_data, $request, $env ) = @_;
    if ( $method_data->{public} && $method_data->{public} eq 1 ) {
        return 1;
    }
    if ( $user_data && ref $user_data eq 'HASH' && $user_data->{id} ) {
        my $acl    = $user_data->{acl};
        my $access = 0;

        #   acl - { path => [POST, GET, PUT, DELETE] }
        if ($acl) {
            my $path = $request->request_uri;
            if ( $request->method =~ /get|delete|post|put/i ) {
                $path = ( split '\?', $path )[0];
            }
            my $re = qr|$method_data->{regexp}|;

            if ( $acl->{$path} && $path =~ /$re/ ) {
                my $access_count = 0;
                foreach ( @{ $acl->{$path} } ) {
                    if ( $_ eq $method_data->{req_method} ) {
                        $access = 1;
                        last;
                    }
                }
            }
        }
        return $access;
    }
    return;
}

sub _get_acl_data {
    my ($self,$user,$app) = @_;
    my $action_id_array = decode_json($user->get_column('actions'));
    my @actions = $self->get_model()->resultset('Action')->search({
        id      => { -in => $action_id_array },
        appid   => $app->get_column('id')
    });
    my %hash;
    if ( $actions[0] ) {
        foreach ( @actions ) {
            $hash{$_->get_column('path')} = decode_json($_->get_column('method_type'));
        }
    }
    return \%hash;
}

sub _uniqid {
    my ($self,$length) = @_;

    my $unique = $ENV{UNIQUE_ID} || ( [] . rand() );
    $length ||= $self->default->{length};
    my $res = substr(
        sha1_hex( Time::HiRes::gettimeofday() . $unique ),
        0,
        $length
    );
            
    return $res;
}

1;

__END__

=head1 NAME

WOAx::Component::ACL

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
