use warnings;
use strict;
use feature 'say';

my $a = pack('CA*', (length("Test"), "Test"));
say $a;
# my $b = unpack($a);
# say $b;