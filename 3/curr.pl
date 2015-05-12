use warnings;
use strict;
no warnings 'qw';
use Local::PerlCourse::Currency qw(
    eur => 1,
    rur => 65.5,
    usd => 1.2
);
use warnings 'qw';
use feature 'say';

say Local::PerlCourse::Currency::usd_to_eur(2);

package Test2::qwe;

no warnings 'qw';
use Local::PerlCourse::Currency qw(
    eur => 100,
    rur => 65.5,
    usd => 1.2
);
use warnings 'qw';
use feature 'say';
say Local::PerlCourse::Currency::usd_to_eur(2);