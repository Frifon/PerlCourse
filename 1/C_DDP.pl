use warnings;
use strict;

use DDP;

my @matrix = ();

while (<>)
{
    chomp $_;
    push @matrix, [split ':', $_];
}

p @matrix;