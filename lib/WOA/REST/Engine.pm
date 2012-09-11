package WOA::REST::Engine;
use strict;
use base 'WOA::REST::Interface::Engine';
use WOA::Validator;
use Data::Dumper;
use Encode qw(from_to decode is_utf8);
use URI::Escape qw/uri_unescape/;

__PACKAGE__->mk_accessors(
    qw/args_filled req_method_matched ok_status_map error_message_map env logger cookies headers formatter app_name res/
);

# from parent: accessors (qw/request map backend view content_type output status location error_message current_method/);

my $OK_STATUS_MAP = {
    PUT    => 200,
    GET    => 200,
    POST   => 201,
    DELETE => 204
};

my $ERROR_MESSAGE_MAP = {
    400 => '[BAD REQUEST]',
    401 => '[FORBIDDEN]',
    404 => '[NOT FOUND]'
};

sub cleanup {
    my ($self) = @_;
    foreach (
        qw/content_type output status location error_message current_method args_filled/
      )
    {
        delete $self->{$_};
    }
    return;
}

sub process {
    my ( $self, $query_args ) = @_;

    my $validator = WOA::Validator->new();

    $self->cleanup;
    
    if ( $self->app_name ) {
        $self->request->headers->header({'X_HTTP_APPNAME' => $self->app_name});
    }
    # get_item_from_map
    my $method_data = $self->get_from_map($validator);

    # get_method_name
    my $method = $self->get_method($method_data);

    my $error_message_map = $self->error_message_map || $ERROR_MESSAGE_MAP;

    # check access - if it needed
    my $access = $self->check_access( $method, $method_data );
    unless ($access) {
        return $self->set_error( 401, $error_message_map->{401}, $method_data );
    }

    # if_method_not_found
    unless ($method) {

        #    set_error(http_status,"Method ~p not implemented")
        return $self->set_error( 404, $error_message_map->{404}, $method_data );
    }

    my $res;

    # check_if_req_meth_has_implemented
    unless ( $self->req_method_matched ) {

        #    set_error(http_status,"Method ~p for request not implemented")
        return $self->set_error(
            400,
            "[BAD REQUEST] Request Method for '"
              . $self->request->method
              . "' not implemented or not defined in map",
            $method_data
        );
    }

    # get_args_for_method
    my $args = $self->args_for_method($method_data);

    # validate_params
    my $is_valid = $self->validate( $validator, $args );

    # if_bad_params
    if ( ref $is_valid eq 'WOA::Validator::ErrorCode' ) {
        my $msg;
        if ( $error_message_map->{400} eq $ERROR_MESSAGE_MAP->{400} ) {
            $msg =
              "[BAD REQUEST] Method: $method. Input params not valid.Data: "
              . Dumper $args;
        }
        else {
            $msg = $error_message_map->{400};
        }
        return $self->set_error( 400, $msg, $method_data, $is_valid );
    }

    unless ( $self->backend ) {
        return $self->set_error( 500,
            "[BACKEND NOT DEFINED] You must define backend object",
            $method_data );
    }

    # call_method
    my $adopted_args = $self->adopt_args( $method_data, $args );

    $res = $self->backend->$method($adopted_args);
    
    $self->res($res);
    # if_errors
    unless ($res) {
        return $self->set_error( 404,
            "[NOT FOUND] Method: $method. Params:" . Dumper $adopted_args,
            $method_data );
    }

    if ( ref $res eq 'WOA::REST::Error' ) {
        return $self->set_error( $res->status, $res->message, $method_data );
    }

    $self->log_request();

    # finalize all actions in response
    $self->finalize( $method_data, $res );

    return;
}

sub finalize {
    my ( $self, $method_data, $res ) = @_;
    my ($status);

    my $status_map = $self->ok_status_map || $OK_STATUS_MAP;

    if ( $method_data->{redirect} ) {
        $self->status(303);
        $self->location($res);
        return;
    }
    else {
        $status = $status_map->{ uc( $self->request->method ) };
    }
    $self->status($status);

    my $view_method = $method_data->{out}->{view_method};

    $self->output( $self->view->$view_method($res) );
    $self->content_type( $method_data->{out}->{mime_type} );

    return;
}

sub get_from_map {
    my ( $self, $validator ) = @_;

    my $ru = $self->get_request_uri;

    my ( $path, $query ) = split '\?', $ru;
    my $res;
    my $url_matched;
    my $qs_matched;
    
    my $index = 0;
    foreach ( @{ $self->map } ) {
        my $req_meth = $self->get_req_meth($_);
        my $req_method_matched = ( $self->request->method eq $req_meth );
        unless ($req_method_matched) {
            next;
        }

        if ( $_->{regexp} ) {
            my $re = qr|$_->{regexp}|;
            
            if ( $path =~ /$re/ ) {
                $url_matched = 1;
                unless ( ( $_->{in} )
                    && ( ref $_->{in} eq 'HASH' )
                    && ( $_->{in}->{param} ) )
                {
                    $qs_matched = 1;
                }
            }
            if ( $_->{in} && $url_matched ) {
                if ( $_->{in}->{param} && ref $_->{in}->{param} eq 'ARRAY' ) {
                    $validator->clear();
                    if ( ref $_->{in} eq 'HASH' && $_->{in}->{how} ) {
                        my $method        = $_->{in}->{how};
                        if ( ref $method eq 'HASH' ) {
                            $method = $method->{method}; 
                        }
                        my $skip_from_uri = $_->{in}->{skip_from_uri};
                
                        unless ($skip_from_uri) {
                            my $rule = ( $method && $self->can($method) );
                            if ($rule) {
                                $self->$method($_);
                            }
                            else {
                                die('[BAD DATA FOR DEFINING ARGS]');
                            }
                        } # END unless ($skip_from_uri)
                    } # END if ( ref $_->{in} eq 'HASH' && $_->{in}->{how} )
                    else {
                        $self->_fill_args( $_->{in}->{param} );    
                    }
                    
                    $validator->fields( $_->{in}->{param} );
                    my $is_valid = $validator->isValid();
                    if ( ref $is_valid eq 'WOA::Validator::ErrorCode' ) {
                        $res = $is_valid;
                        last;
                    }
                    else {
                        $qs_matched = 1;
                    }
                } # END if ( $_->{in}->{param} && ref $_->{in}->{param} eq 'ARRAY' )
                elsif ( $_->{in}->{param} && ref $_->{in}->{param} eq 'HASH' ) {
                    $self->req_method_matched($req_method_matched);
                    $res = $_;
                    last;
                }
            }    # END if( $_->{in} )
            if ( $url_matched && $qs_matched ) {
                $self->req_method_matched($req_method_matched);
                $res = $_;
                last;
            }
        }
    }

    return $res;
}

sub get_method {
    my ( $self, $data ) = @_;

    my $res = $data->{func_name};

    return $res;
}

#sub set_error {
#    my ( $self, $http_status, $log_msg, $method_data, $is_valid ) = @_;
#
#    $self->status($http_status);
#    $self->output("Error occuried.Mail to admin");
#    my $content_type = $method_data->{out}->{mime_type} || "text/plain";
#    $self->content_type($content_type);
#
#    $self->error_message($log_msg);
#
#    return;
#}

sub set_error {
    my($self,$http_status,$msg,$message_data,$is_valid)=@_;
    
    $self->status($http_status);
    my $error_obj;
    
    my $session = $self->backend->{'session'};
    my $user = $session->{'user'};
    if ( ref $message_data eq 'HASH' ) {
        if( $message_data->{out}->{mime_type} eq 'text/html' && !$message_data->{public} && !$user ){
            $self->status(303);
            $self->location($self->backend->{config}->{default}->{location});
            return;
        }
        if( $message_data->{out}->{mime_type} eq 'text/html' && !$message_data->{public} && $user ){
            $self->status(303);
            $self->location($self->backend->{config}->{error}->{$http_status});
            return;
        }
    }
    unless ( $message_data ) {
        my $out = $self->view->as_json({Mesasge=>$msg,Class=>'error'});
        $self->output($out);
    }
    if ( ref $message_data eq 'WOA::Validator::ErrorCode' ) {
        $error_obj = $message_data;
    }
    elsif ( ref $is_valid eq 'WOA::Validator::ErrorCode' ) {
        $error_obj = $is_valid;
    }
    elsif ( ref $message_data eq 'HASH' ) {
        $self->error_message(Dumper $message_data);
        my $out = $self->view->as_json({
            Message => $msg,
            Class   => 'error'
        });
        $self->output($out);
    }
    
    if ( $error_obj && ref $error_obj eq 'WOA::Validator::ErrorCode' ){
        my $errFields = $error_obj->errorFields;
        my @newFields;
        if ( ref $errFields eq 'ARRAY' ){
            foreach ( @$errFields ){
                if ( ref $_ eq 'HASH' && $_->{name} ){
                    $_->{error} = $self->encode_utf( $_->{error} );
                    push @newFields,$_;
                }
            }
        }
        my $out = $self->view->as_json({
            Message => $error_obj->errorMsg,
            Fields  => \@newFields
        },1);
        $self->output($out);
        $self->error_message(Dumper $error_obj);
    }
        
    $self->content_type("text/javascript");
    
    return;
}

sub get_req_meth {
    my ( $self, $method_data ) = @_;

    my $res = $method_data->{req_method};

    return $res;
}

sub args_for_method {
    my ( $self, $method_data ) = @_;
    my $args;
    
    my $rule =
      ( $method_data->{in}->{param}
          && ref $method_data->{in}->{param} eq 'ARRAY' );
    if ( !$self->args_filled() ) {
        if ($rule) {
            foreach ( @{ $method_data->{in}->{param} } ) {
                my $v = $self->request->param( $_->{name} );
                $_->{value} = $v;
            }
            $args = $method_data->{in}->{param};
        }
    }
    if ( $rule && $args ) {
        push @{$args}, @{ $method_data->{in}->{param} };
    }
    unless ($args) {
        $args = $method_data->{in}->{param};
    }

    return $args;
}

sub validate {
    my ( $self, $validator, $args ) = @_;

    unless ($args) {
        return 1;
    }

    $validator->clear();
    $validator->fields($args);
    my $res = $validator->isValid();

    return $res;
}

sub adopt_args {
    my ( $self, $method_data, $args ) = @_;
    my %res;
    foreach ( @{$args} ) {
        if ( $_->{value} && $_->{name} ) {
            $res{ $_->{name} } = uri_unescape( $_->{value} );
        }
    }
    return \%res;
}

sub req_method {
    my ($self) = @_;
    my $uri = $self->request->method;
}

sub version {
    my ($self) = @_;
    return;
}

sub log_request {
    my ($self) = @_;
    return;
}

sub check_access {
    my ($self) = @_;
    return 1;
}

sub from_uri {
    my ( $self, $method_data ) = @_;
    my @res = ();
    
    my $ru = $self->get_request_uri;
    
    # fill params from query string
    $self->_fill_args($method_data->{in}->{param});
    
    my ( $path, $query ) = split '\?', $ru;
    
    my @arr_from_pattern = split '/',$method_data->{in}->{how}->{pattern};
    
    my @arr_from_path = split '/',$path;
    if ( $arr_from_path[0]=~/^(http(s)*)/ ) {
        # shift protocol name(http(s)) and and hostname from path
        shift @arr_from_path;
        shift @arr_from_path;
    }
    my %hash;
    for ( my $i=0;$i<int(@arr_from_pattern);$i++ ) {
        if ( $arr_from_pattern[$i] =~/^:/ ) {
            $arr_from_pattern[$i] =~s/^://;
            $hash{$arr_from_pattern[$i]} = $arr_from_path[$i];
        }
    }
    foreach ( @{$method_data->{in}->{param}} ) {
        if ( $hash{$_->{name}} ) {
            $_->{value} = $hash{$_->{name}};
        }
    }
    
    
    $self->args_filled(1);
    return $method_data;
}

sub _fill_args {
    my ( $self, $data ) = @_;
    foreach ( @{$data} ) {
        my @v = $self->request->param( $_->{name} );
        if ( $self->request->can('uploads') && $self->request->uploads->{$_->{name}} ) {
            push @v,$self->request->uploads->{$_->{name}};
        }
        if ( @v > 1 ) {
            $_->{value} = \@v;
        }
        else {
            $_->{value} = $v[0];
        }
    }
    $self->args_filled(1);

    return;
}

sub get_request_uri {
    my ($self) = @_;
    my $ru;
    if ( $self->request->can('request_uri') ) {
        $ru = $self->request->request_uri;
    }
    else {
        if ( $self->request->uri->can('to_string') ) {
            $ru = $self->request->uri->to_string;
        }
        else {
            $ru = $self->request->uri->as_string;
        }
    }
    return $ru;
}

sub encode_utf {
	my ( $self, $string ) = @_;

	my $res;
	if ( is_utf8($string) ) {
		$res = $string;
	}
	else {
		from_to( $string, 'utf8', 'utf8' );
		$res = decode( 'utf8', $string );
	}

	return $res;
}

1;

__END__


=head1 NAME

WOA::REST::Engine

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


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut
