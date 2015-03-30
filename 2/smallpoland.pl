use strict;
use warnings;
# use bigint; WTF?!?!?!?!?!? 1.1 -> NaN O_\\
use feature 'say';

sub calc
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression.' ' unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    my ($current, $sign, $balance, $result, $last, $index, $cnt) = ('', 1, 0, '', 0, 0, 0);
    for (split //, $expression.'_')
    {
        $balance += $_ eq '(' ? 1 : $_ eq ')' ? -1 : 0;
        if (!$balance and ($_ eq '+' or $_ eq '*' or $_ eq '-' or $_ eq '_'))
        {
            last if ($_ eq '_' and !$last);
            $current .= calc(substr($expression, $last, $index - $last));
            $cnt++;
            $sign = $_ eq '+' ? 1 : $_ eq '-' ? -1 : $sign;
            my $pref = '';
            $pref = '+' if (!($_ eq '_') and $sign == 1);
            $pref = '-' if (!($_ eq '_') and $sign == -1);
            if (!($_ eq '*'))
            {
                $current = ('* ' x ($cnt - 1)).$current;
                $result .= "$pref " if (!($_ eq '_'));
                $result .= $current;
                $current = '';
                $cnt = 0;
            }
            $last = $index + 1;
        }
        $index++;
    }
    return $result = $last == 0 ? calc(substr($expression, 1, length($expression) - 2)) : $result;
}

say calc(scalar(<stdin>));