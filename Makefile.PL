use inc::Module::Install;

# Define metadata
name 'WOA';
abstract 'web oriented toolkit for easy building REST services';
version '0.001';
author 'plcgi1@gmail.com';
license 'perl';

# Specific dependencies
requires 'Carp';
requires 'Error'          => 0.17010;
requires 'File::Basename' => 2.77;
requires 'MIME::Base64'   => 3.08;
requires 'Mail::Mailer'   => 2.06;
requires 'Template'       => 2.22;

requires 'Config::General';
requires 'Config::Any';

requires 'Class::Accessor::Fast' => 0.31;
requires 'Class::Singleton';
requires 'Class::Inspector' => 1.25;

requires 'Encode::Guess' => 2.03;
requires 'POSIX'         => 1.17;

requires 'Test::Strict';
requires 'Test::Pod';
requires 'Test::Builder';
requires 'Test::Builder::Module';

requires 'Getopt::Long' => 2.38;
requires 'Pod::Usage'   => 1.36;

requires 'JSON::XS' => 2.3;
requires 'Data::Dumper';

requires 'Exception::Class';

requires 'URI::Escape'   => 3.30;
requires 'interface'     => 0.03;
requires 'Date::Manip'   => 6.22;
requires 'base'          => 2.14;
requires 'common::sense' => 3.4;
requires 'parent'        => 0.225;
requires 'Locale::Maketext';

install_script glob('bin/*.pl');
install_share glob('share/*.');
auto_install;
WriteAll;

1;
