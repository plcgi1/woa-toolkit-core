package WOA::REST::Generic::Filter;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->mk_accessors(qw/where/);
__PACKAGE__->follow_best_practice;

my $DEFAULT_LIMIT = 10;

sub make_interval_query {
    my ( $self, $param, $param_name_from, $param_name_to, $field_date_name ) =
      @_;

    my $from = $param->{$param_name_from};
    my $to   = $param->{$param_name_to};

    my ( $where, $time );
    if ( $from && length $from > 0 ) {
        $from = { $field_date_name => { '>' => $from } };
    }
    if ( $to && length $to > 0 ) {
        $to = { $field_date_name => { '<' => $to } };
    }
    foreach ( ( $from, $to ) ) {
        if ( defined $_ ) {
            push @{ $where->{-and} }, $_;
        }
    }
    return $where || {};
}

# in:
#   field_name - имя поля в форме
#   db_field_name - имя поля - как в запросе к БД
sub make_param {
    my ( $self, $field_name, $db_field_name, $params ) = @_;

    my $value = $params->{$field_name};

    $self->where( {} ) unless ref $self->where eq 'HASH';

    if( defined $value  ) {
        my $is = $params->{$field_name.'_is'} || '-in';
        if( $is eq '-not' ){
            push @{$self->where()->{-and}},{ $db_field_name => { '!=' => $value  } } ;
        }
        else {
            if ( ref $value eq 'ARRAY' ){
                $self->where()->{$db_field_name} = { $is => $value };
            }
            else {
                $self->where()->{$db_field_name} = { $is => [$value] };
            }
        }
    }

    return;
}

1;

__END__


=head1 NAME

WOA::REST::Generic::Filter - []

=head1 SYNOPSIS

[]

=head1 DESCRIPTION

[]

=head2 EXPORT

[]

=head1 SEE ALSO

[]


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
