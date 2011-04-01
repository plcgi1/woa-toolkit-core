package WOA::Component::Util;
use strict;
use base 'Class::Accessor::Fast';

__PACKAGE__->follow_best_practice;

sub prepare_select_4jqgrid {
    my($self,$array_ref) = @_;
    
    my @arr;
    foreach ( @$array_ref ) {
        push @arr,$_->{value}.':'.$_->{label}.'';
    }
    my $res = join ';',@arr;
    
    return $res;    
}

sub options_from_dbic {
    my ( $self, $rs, $label, $value, $selected, $no_set_first_empty ) = @_;
    my @res = ();
    
    unless( defined $no_set_first_empty){
        push @res,{label=>'~',value=>''};
    }
    if(defined $rs->[0]){
        foreach ( @{$rs} ){
            my $v = $_->get_column($value);
            my $l = $_->get_column($label);
            my $hashref = { label => $l, value => $v };
            if( ($v && $selected) && ( $v eq $selected )){
                $hashref->{selected} = 1;
            }
            push @res,$hashref;
        }
    }
    return \@res;
}

1;


__END__


=head1 WOA::Component::Util

=head1 SYNOPSIS

my $u = WOA::Component::Util->new();

# model - DBIx::Class object
my @rs = $model->resultset('Role')->search({},{order_by=>'me.name'});

# opts for select box in html page
# format:
# [ { label => 'LABEL', value => 'VALUE' }]
my $opts = $u->options_from_dbic(\@rs, 'name', 'id');

=head1 DESCRIPTION

Some util funcs for woa apps

=head2 EXPORT

=head3 prepare_select_4jqgrid

=head3 options_from_dbic


=head1 AUTHOR

plcgi E<lt>plcgi1 at gmail dot com<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by plcgi1

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.7 or,
at your option, any later version of Perl 5 you may have available.


=cut