package WOA::REST::Generic::Backend;
use strict;
use base 'Class::Accessor::Fast';
use Date::Manip qw(UnixDate);

__PACKAGE__->follow_best_practice;
__PACKAGE__->mk_accessors(qw/config session model env request formatter/);

my $DEFAULT_LIMIT = 10;

sub make_interval_query {
    my ( $self, $param, $param_name_from, $param_name_to, $field_date_name ) =
      @_;

    my ( $from, $to );
    if ($param_name_from) {
        $from = $param->{$param_name_from};
    }
    if ($param_name_to) {
        $to = $param->{$param_name_to};
    }

    my ( $where, $time );
    if ( $from && length $from > 0 ) {
        $time = UnixDate( $from, "%s" );
        $from = { $field_date_name => { '>' => $time } };
    }
    if ( $to && length $to > 0 ) {
        $time = UnixDate( $to, "%s" );
        $to = { $field_date_name => { '<' => $time } };
    }
    foreach ( ( $from, $to ) ) {
        if ( defined $_ ) {
            push @{ $where->{-and} }, $_;
        }
    }
    return $where;
}

sub define_post_query {
    my ( $self, $param ) = @_;
    my $res = {
        page => $param->{page} || 1,
        rows => $param->{rows} || $DEFAULT_LIMIT,
    };
    if ( $param->{sidx} && $param->{sord} ) {
        $res->{order_by} = $param->{sidx} . ' ' . $param->{sord};
    }
    elsif ( $param->{sidx} && !$param->{sord} ) {
        $res->{order_by} = $param->{sidx} . ' asc';
    }
    return $res;
}

sub pager_data {
    my ( $self, $param, $where, $post_query_params, $table_name ) = @_;
    delete $post_query_params->{page};
    delete $post_query_params->{rows};

    my $res;
    if ( $self->can('get_model') ) {
        my $limit = $param->{rows} || $DEFAULT_LIMIT;
        my $total =
          $self->get_model()->resultset($table_name)
          ->search( $where, $post_query_params )->count();

        my $lastpage = int( $total / $limit );
        my $mod      = int( $total % $limit );
        if ( $mod > 0 ) {
            $lastpage++;
        }
        $res = {
            total   => $lastpage,
            records => $total,
            page    => $param->{page} || 1
        };
    }
    return $res;
}

sub fill_hash {
    my ( $self, $id, @args ) = @_;
    my $hash = {
        id   => $id,
        cell => \@args
    };
    return $hash;
}

1;

__END__


=head1 NAME

WOA::REST::Generic::Backend - []

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
