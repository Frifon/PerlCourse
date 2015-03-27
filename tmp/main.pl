use strict;
use warnings;
use feature 'say';

package A;
my $t = 1;
{
    $t = 2;
    say $t;
}
say $t;