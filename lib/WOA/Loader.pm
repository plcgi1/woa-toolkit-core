package WOA::Loader;
use strict;
use Class::Inspector;

use vars qw(@ISA @EXPORT @EXPORT_OK $VERSION);

use Error;

@ISA       = qw(Exporter);
@EXPORT    = qw(import_module create_object create_instance);
@EXPORT_OK = qw(import_module create_object create_instance);

$VERSION = "0.01";

sub create_instance {
	my $pack = shift;
	my $opt  = shift;

	my $package = join '::', ( $opt->{namespace}, $opt->{class} );

	WOA::Loader::import_module($package);

	my $object = WOA::Loader::create_object( $package, %$opt );

	return $object;
}

sub import_module {
	my $module = shift;
	$module =~ s/::/\//g;
	$module .= '.pm';

	eval { require $module; };

	if ($@) {
		loader_die( 'import_module', "Cant load module $module - $@.",
			__LINE__ );
	}
	return;
}

sub create_object {
	my $module = shift;

	unless ( Class::Inspector->loaded($module) ) {
		WOA::Loader::import_module($module);
	}

	my $object;
	eval { $object = $module->new(@_); };

	if ($@) {
		loader_die( 'create_object',
			"Cant create object for module $module - $@.", __LINE__ );
	}

	return $object;
}

sub loader_die {
	my $method  = shift;
	my $message = shift;
	my $line    = shift;

	die "[ERROR LOAD MODULE] "
	  . __PACKAGE__
	  . " line "
	  . $line . " "
	  . $method . " "
	  . $message
	  . " Caller : "
	  . caller(0);

	return;
}

1;

__END__


=head1 WOA::Loader

=head1 SYNOPSIS

use WOA::Loader;

my $obj = WOA::Loader->create_object('Some::Module');
my $inst = WOA::Loader->create_instance('Some::Module',{ param_hash });
WOA::Loader->import_module('Module::Name');

=head1 DESCRIPTION

Simple module loader

=head3 create_instance

Create instance of object from loaded module

=head3 create_object

Create object from loaded module

=head3 loader_die

Kill programmer error (

=head3 import_module

Load module on demand

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
