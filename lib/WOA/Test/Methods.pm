package WOA::Test::Methods;
use strict;
use WOA::REST::Generic::Request;
use base qw/Class::Accessor::Fast/;

sub bad_data {
    my($self,$tb,$rest,$req,$method,$data)=@_;
    
    foreach ( @$data ){
        $req = WOA::REST::Generic::Request->new ( $method => $_) ;
        $rest->request($req);
        my $res = $rest->process;
        $tb->like($rest->status, qr/400/,"$method: response status: 400");
    }
    
    return;
}

sub bad_method {
    my($self,$tb,$rest,$req,$uri,$data)=@_;
    
    foreach ( @$data ){
        $req = WOA::REST::Generic::Request->new ( $_ => $uri ) ;
        $rest->request($req);
        my $res = $rest->process;
        $tb->like($rest->status, qr/400/,"Request method: $_: response status: ".$rest->status);
    }
    
    return;
}

sub data_for_service {
    my ($self,$hash,$map,$data,$is_bad) = @_;
    foreach my $m( @$map ) {
        # get method name
        my $method_name =$m->{func_name};
        if ( $m->{in}->{param} ) {
            # for method params
            foreach my $param ( @{$m->{in}->{param}} ) {
                my $name = $param->{name};
                #   get rule name
                my $rule_type = $param->{rules}->[0]->{rule};
                my $rule_param;
                if ( $param->{rules}->[0]->{param} ) {
                    $rule_param = $param->{rules}->[0]->{param};
                }
                #   by rule type - get data from $data
                #   save it in method_name => { param_name => value_from_data_by_rule }
                if ( $rule_type eq 'pattern' ) {
                    # TODO 
                }
                else {
                    $hash->{$method_name}->{$name} = $self->_get_data($data,$rule_type);
                }
            }
        }
    }
    return $hash;
}

sub status_re_for_test {
    my ($self,$method_type) = @_;
    my %S = (
        POST    => 201,
        GET     => 200,
        PUT     => 200,
        DELETE  => 204
    );
    return qr/$S{$method_type}/;
}

sub set_request {
    my ($self,$map_data,$test_data) = @_;
    my $req;
    $map_data->{regexp} =~s/[\$\^\(\)\.\*]//g;
    $req = WOA::REST::Generic::Request->new ();
    my $qs = $req->to_qs($test_data);
    if ( $map_data->{req_method} =~/(GET|DELETE)/i ) {
        
        $req->method($map_data->{req_method});
        $req->uri($map_data->{regexp}.'?'.$qs);
    }
    else {
        $req = WOA::REST::Generic::Request->new ( $map_data->{req_method} => $map_data->{regexp});
        $req->content($qs);
    }
    return $req;
}

sub _get_data {
    my($self,$data,$name) = @_;
    my $res;
    foreach ( @$data ) {
        if ($_->{name} eq $name) {
            $res = $_->{value};
            last;
        }
    }
    return $res;
}

1;

__END__


=head1 WOA::Test::Methods

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

Utilite methods for testing services

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