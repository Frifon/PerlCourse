use strict;
use warnings;
# use bigint; WTF?!?!?!?!?!? 1.1 -> NaN O_\\
use feature 'say';

sub balanced
{
    my $balance = 0;
    for (split //, shift)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        return 0 if ($balance < 0);
    }
    return $balance == 0;
}

sub calc
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    if (substr($expression, 0, 1) eq '(' and balanced(substr($expression, 1, length($expression) - 2)))
    {
        return calc(substr($expression, 1, length($expression) - 2));
    }
    my ($sign, $calculated, $balance, $result, $current_expression) = (1);
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if (($_ eq '+' or $_ eq '-') and !$balance)
        {
            $calculated = 1;
            $result += $sign * calc($current_expression);
            $current_expression = '';
            $sign = 1 if ($_ eq '+');
            $sign = -1 if ($_ eq '-');
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $result += $sign * calc($current_expression) if ($current_expression and $calculated);
    return $result if $calculated;

    ($balance, $result, $current_expression) = (0, 1, '');
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if ($_ eq '*' and !$balance)
        {
            $result *= calc($current_expression);
            $current_expression = '';
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $result *= calc($current_expression) if $current_expression;
    return $result;
}

say calc(scalar(<stdin>));