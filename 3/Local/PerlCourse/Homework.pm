package Local::PerlCourse::Homework;

use strict;
use warnings;
use Exporter 'import';
our @EXPORT_OK = qw(homework2_calc homework2_poland);

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

sub homework2_calc
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    if (substr($expression, 0, 1) eq '(' and balanced(substr($expression, 1, length($expression) - 2)))
    {
        return homework2_calc(substr($expression, 1, length($expression) - 2));
    }
    my ($sign, $calculated, $balance, $result, $current_expression) = (1);
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if (($_ eq '+' or $_ eq '-') and !$balance)
        {
            $calculated = 1;
            $result += $sign * homework2_calc($current_expression);
            $current_expression = '';
            $sign = 1 if ($_ eq '+');
            $sign = -1 if ($_ eq '-');
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $result += $sign * homework2_calc($current_expression) if ($current_expression and $calculated);
    return $result if $calculated;

    ($balance, $result, $current_expression) = (0, 1, '');
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if ($_ eq '*' and !$balance)
        {
            $result *= homework2_calc($current_expression);
            $current_expression = '';
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $result *= homework2_calc($current_expression) if $current_expression;
    return $result;
}

sub homework2_poland
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression.' ' unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    if (substr($expression, 0, 1) eq '(' and balanced(substr($expression, 1, length($expression) - 2)))
    {
        return homework2_poland(substr($expression, 1, length($expression) - 2));
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
            $notation .= homework2_poland($current_expression);
            $current_expression = '';
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $notation .= homework2_poland($current_expression) if ($current_expression and $calculated);
    return $notation if $calculated;

    ($balance, $current_expression) = (0, ''); ##### rem nota
    for (split //, $expression)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        if ($_ eq '*' and !$balance)
        {
            $notation .= '* ';
            $notation .= homework2_poland($current_expression);
            $current_expression = '';
        }
        else
        {
            $current_expression .=  $_;
        }
    }
    $notation .= homework2_poland($current_expression) if ($current_expression);
    return $notation;
}

0x179;