use strict;
use warnings;

use Data::Dumper;
use feature 'say';

sub statistics
{
    my $letters;
    $letters .= $_ for ('a' .. 'z');

    my($_) = @_;
    my %result;
    while (/([^.]*\.)/g)
    {
        if (index($1, ',') != -1)
        {
            my $cur = lc($1);
            my @arr = split(/\s/, $cur);
            for my $word (@arr)
            {
                if (length($word))
                {
                    my ($start, $end) = (0, length($word) - 1);
                    $start++ while ($start < length($word) && index($letters, substr($word, $start, 1)) == -1);
                    $end-- while ($end >= 0 && index($letters, substr($word, $end, 1)) == -1);
                    if ($start <= $end && $end - $start < 4)
                    {
                        $word = substr($word, $start, $end - $start + 1);
                        $result{$word}++;
                    }
                }
            }
        }
    }
    my @ret;
    for (keys %result)
    {
        push(@ret, $result{$_});
        push(@ret, $_);
    }
    push(@ret, scalar(keys %result));
    return @ret;
}