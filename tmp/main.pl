use warnings;
use strict;
use feature 'say';
use Data::Dumper;

my $foo = pack("ClCClCClC", 7, 33, 0, 7, 41, 1, 7, 32, 255); 
say Dumper($foo);
say Dumper(unpack("ClCCl", $foo));