package [%app_name%]::RouteMap;
use strict;

# autogenerated by woax-toolkit.pl
# if you want edit  - edit Map.pm file for service and run "woax-toolkit.pl -a service -n YourServiceName "
# !!! DONT EDIT THIS FILE !!! #

my $rules = [
    [%FOREACH key IN rules.keys%]
    { path => '[%key%]', class => '[%rules.$key%]' },
    [%END%]
];
sub get_rules { return $rules; }

1;

__END__