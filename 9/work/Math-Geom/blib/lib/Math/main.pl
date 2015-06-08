use strict;
use warnings;

use Math::Geom;
use Data::Dumper;
use Data::Compare;
use Time::HiRes qw( time );
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

my $C = [11, 22, 33, 44, 55, 66];


my $D = [
    [10, 11, 1, 2],
    [12],
    [14, 15]
];

my @bigA;
my @bigB;
my $MAXN = 614;
my $comp = 1;

# 300 7s/2s


for (1 .. $MAXN)
{
    my @tmp;
    for (1 .. $MAXN)
    {
        push(@tmp, 1);
    }
    push(@bigA, \@tmp);
}

for (1 .. $MAXN)
{
    my @tmp;
    for (1 .. $MAXN)
    {
        push(@tmp, 1);
    }
    push(@bigB, \@tmp);
}

# say Math::Geom::distance_p2c(\%point, \%circle);
# say Math::Geom::circle_area(\%circle);

my $start = time();
my $res1 = Dumper(Math::Geom::MMC(\@bigA, \@bigB));
my $end = time();
printf("%.2f\n", $end - $start);

$start = time();
my $res2 = Dumper(Math::Geom::MMP(\@bigA, \@bigB));
$end = time();
printf("%.2f\n", $end - $start);


if ($comp)
{
    if (Compare($res1, $res2))
    {
        say 'OK';
    }
    else
    {
        say 'NOT OK';
    }
}
