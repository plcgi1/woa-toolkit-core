package WOA::REST::Generic::View;
use strict;
use parent 'Class::Accessor::Fast';
use JSON::XS qw/encode_json/;
use Encode qw/from_to decode is_utf8/;

__PACKAGE__->mk_accessors(qw/view renderer/);

my $DEFAULT_LIMIT = 10;

sub as_is {
    my ( $self, $obj ) = @_;
    
    my $res;
    if ( $obj ) {
		$res = $obj;
    }
	
    return $res;	
}

sub as_json {
    my ( $self, $obj, $is_utf8 ) = @_;
    
    my $res;
    if ( $obj ) {
		my $coder = JSON::XS->new();
		$res = JSON::XS->new->utf8->allow_nonref->encode($obj);
    }
	
    return $res;
}

sub empty {
    my ( $self, $obj ) = @_;
    return ' ';    
}

sub as_html {
	my ($self,$obj) = @_;
	my $out;
	$self->renderer->error(undef);
	$self->renderer->process($obj->{template},$obj,\$out);
	if ( $self->renderer->error() ){
		$out = $self->renderer->error();
	}
	return $out;
}

sub encoder {
	my($self,$str)=@_;
	my $res;
	if ( is_utf8($str) ) {
		$res = $str;
	}
	else {
		from_to($str,'utf8','utf8');
		$res = decode('utf8',$str);
	}
	return $res;
}

#############################
##### util methods ##################################
sub pager_data {
    my($self,$param,$total)=@_;
    
    my $res;
	my $limit 		= $param->{rows} || $DEFAULT_LIMIT;
	my $lastpage 	= int( $total / $limit );
	
	my $mod = int( $total % $limit );
	if ( $mod > 0 ){
		$lastpage++;
	}
	$res = {
		total   => $lastpage,
		records	=> $total,
		page    => $param->{page} || 1
	};
    return $res;
}
################################## END util methods ##############################

1;


__END__


=head1 NAME

WOA::REST::Generic::View - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

TODO

=head1 SEE ALSO

TODO

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by WOA.LABS

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut