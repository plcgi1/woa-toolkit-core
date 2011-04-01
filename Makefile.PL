use inc::Module::Install;
  
# Define metadata
name        'WOA';
abstract    'web oriented arch';
version     '1.00';
author      'nobody lab';

# Specific dependencies
requires    'Config::General';
requires    'Config::Any';

requires    'Class::Accessor::Fast'         => 0.31;
requires    'Class::Singleton';
requires    'Class::Inspector';

requires    'Encode::Guess';
requires    'POSIX'; 

requires    'Test::Unit';
requires    'Test::Strict';
requires    'Test::Pod';
requires    'Test::Builder';
requires    'Test::Builder::Module';

requires    'Getopt::Long';
requires    'Pod::Usage';

requires    'JSON::XS';
requires    'Data::Dumper';

requires    'Exception::Class';

requires    'URI::Escape';
requires    'interface';
requires    'Date::Manip';

install_script glob('bin/*.pl');
auto_install;
WriteAll;

1;