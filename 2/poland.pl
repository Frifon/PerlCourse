use strict;
use warnings;
# use bigint;
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
    return $expression.' ' unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    if (substr($expression, 0, 1) eq '(' and balanced(substr($expression, 1, length($expression) - 2)))
    {
        return calc(substr($expression, 1, length($expression) - 2));
    }
    my ($calculated, $balance, $current_expression, $notation);
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if (($_ eq '+' or $_ eq '-') and !$balance)
        {
            $notation .= $_ eq '+' ? '+ ' : '- ';
            $calculated = 1;
            $notation .= calc($current_expression);
            $current_expression = '';
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $notation .= calc($current_expression) if ($current_expression and $calculated);
    return $notation if $calculated;

    ($balance, $current_expression) = (0, ''); ##### rem nota
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if ($_ eq '*' and !$balance)
        {
            $notation .= '* ';
            $notation .= calc($current_expression);
            $current_expression = '';
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $notation .= calc($current_expression) if ($current_expression);
    return $notation;
}

say calc(<stdin>);