use strict;
use warnings;

use Math::Geom;
use Data::Dumper;
use feature 'say';

my %point = (
    x => 10,
    y => 5
);

my %circle = (
    x => 2,
    y => 3,
    r => 4
);

my $A = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9]
];

my $B = [
    [10, 11],
    [12, 13],
    [14, 15]
];

say Math::Geom::distance_p2c(\%point, \%circle);
say Math::Geom::circle_area(\%circle);

say Dumper(Math::Geom::MMP($A, $B));
Math::Geom::MMC($A);