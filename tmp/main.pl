use strict;
use warnings;
use feature 'say';

sub calc
{
    my $e = join('', split(' ', shift));
    chomp($e);
    my $w = $e;
    say $w;
    $w = $w + 3;
    say $w;
    return $w;
}

say calc(scalar(<stdin>));