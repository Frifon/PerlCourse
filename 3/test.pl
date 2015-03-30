use strict;
use warnings;
use feature "say";

use Local::PerlCourse::Currency (usd => 1.2, eur => 1, rur => 60, god => 299, pound => 0.8, sss => 228, lalka => 42);

say Local::PerlCourse::Currency::lalka_to_usd(200);
say Local::PerlCourse::Currency::usd_to_rur(300);
say Local::PerlCourse::Currency::god_to_god(400);
say Local::PerlCourse::Currency::usd_to_eur(500);
say Local::PerlCourse::Currency::eur_to_god(12);
say Local::PerlCourse::Currency::sss_to_sss('212');
say Local::PerlCourse::Currency::sss_to_lalka(0+2);
say Local::PerlCourse::Currency::lalka_to_lalka(200 + 200);
say Local::PerlCourse::Currency::god_to_rur(499);
say Local::PerlCourse::Currency::sss_to_eur(300);
say Local::PerlCourse::Currency::usd_to_god(228);
say Local::PerlCourse::Currency::lalka_to_rur(288);
say Local::PerlCourse::Currency::sss_to_sss(1000);
#say Local::PerlCourse::Currency::sss_to_xss(1000);

our $add = 1;

sub sum
{
    my $res = 0;

    for my $elem (@_)
    {
        $res += $elem;
    }
    return $res + $add;
}

sub price
{
    my %goods = (nine_wings => 199, five_wings => 149, potato => 50, pepsi => 61);
    return $goods{$_[0]};
}

Local::PerlCourse::Currency::generate_functions(['sum', eur => 'usd'], ['price', rur => 'sss'], ['sum', eur => 'eur'], ['sum', eur => 'god'], ['price', 'rur' => 'lalka']);

say sum_usd(2, 3, 4, 5, 6);
say price_lalka("nine_wings");
say sum_eur(2, 2, 8);
say sum_god(2);
say price_sss("pepsi");