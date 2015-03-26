use warnings;
use strict;

use Data::Dumper;

my @matrix;

while (<>)
{
    chomp $_;
    push @matrix, [split ':', $_];
}

print Dumper(@matrix);