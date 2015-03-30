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

sub price {5};
sub sum {42};

# say Local::PerlCourse::Currency::usd_to_rure(2);
# say Local::PerlCourse::Currency::usd_to_rur(3);
# say Local::PerlCourse::Currency::eur_to_rur(4);
# say Local::PerlCourse::Currency::eur_to_eur(5);
# say Local::PerlCourse::Currency::usd_to_eur(6);
# say Local::PerlCourse::Currency::eur_to_lalka(6);
Local::PerlCourse::Currency::generate_functions(
    ['sum', rur => 'usd'],
    ['price', usd => 'eur'],
    # ['price', usd1 => 'eur'],
    # ['price', usd => 'eu1r'],
    # ['pr1ice', usd => 'eur']
);
say sum_usd();
say price_eur();