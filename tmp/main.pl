use warnings;
use strict;
use feature 'say';
use Data::Dumper;

my %a = ();

$a{a} = [1];

if (exists($a{a}))
{

    push $a{a}, 1;
}
if (exists($a{a}))
{
    push $a{a}, 1;
}

say Dumper(\%a);