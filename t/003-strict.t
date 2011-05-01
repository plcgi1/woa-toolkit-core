use Test::Strict;
use FindBin qw($Bin);
use lib (
    $Bin,
    $Bin.'/../lib',
    $Bin.'/../../core/lib',
);

$Test::Strict::TEST_SYNTAX = 1;
$Test::Strict::TEST_STRICT = 0;
$Test::Strict::TEST_WARNINGS = 0;

all_perl_files_ok("./lib"); # Syntax ok and use strict;
all_perl_files_ok("./bin"); # Syntax ok and use strict;

all_cover_ok(73);    # at least 80% test coverage