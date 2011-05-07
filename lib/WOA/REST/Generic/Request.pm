package WOA::REST::Generic::Request;
use strict;
use base qw/HTTP::Request HTTP::Request::AsCGI/;
use URI::Escape qw/uri_unescape uri_escape/;

sub to_qs {
	my($self,$data)=@_;
	my @arr;
	foreach ( keys %$data ) {
		push @arr,$_.'='.uri_escape($data->{$_});
	}
	my $res = join '&',@arr;
	return $res;
}

sub param {
    my($self,$name)=@_;
    
    my %args;
    
    if($self->method =~/get|delete/i ){    
        my @q = split '\?',$self->{_uri}->as_string;
        if($q[1]) {
            my @common = split '&',$q[1];
                
            foreach ( @common ) {
                my ($key,$value) = split '=',$_;
                $key=~s/^\?//;
                $args{$key} = uri_unescape($value);		
            }
        }
    }
    elsif ( $self->method =~/put|post/i ){
        my @q = split '&',$self->content;
        foreach( @q ){
            my($key,$val)=split '=',$_;
            $args{$key} = uri_unescape($val);
        }
    }
	return $args{$name};
}

1;

__END__


=head1 NAME

WOA::REST::Generic::Request - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]

=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut