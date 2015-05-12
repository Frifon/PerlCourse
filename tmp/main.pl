use warnings;
use strict;
use feature 'say';
use Data::Dumper;


sub ENC
{
    my $nums = "0123456789";
    my %help = (
        '+' => 0,
        '-' => 1,
        '*' => 2,
        '(' => 3,
        ')' => 4
    );
    my @arr;
    my $template = '';
    my $number = '';
    my $str = shift;
    $str =~ s/ //g;
    for (split //, $str)
    {
        if (index($nums, $_) != -1)
        {
            $number .= $_;
        }
        else
        {
            if ($number)
            {
                push @arr, 7;
                push @arr, 0 + $number;
                $template .= 'Cl';
                $number = '';
            }
            if (exists($help{$_}))
            {
                push @arr, $help{$_};
                $template .= 'C';
            }
        }
    }
    if ($number ne '')
    {
        push @arr, 7;
        push @arr, 0 + $number;
        $template .= 'Cl';
        $number = '';
    }
    $template .= 'C';
    push(@arr, 255);
    say $template;
    return pack($template, @arr);
}

sub DEC
{
    my $enc = shift;
    my $nums = "0123456789";
    my %help = (
        '0' => '+',
        '1' => '-',
        '2' => '*',
        '3' => '(',
        '4' => ')'
    );
    my $template = 'C';
    my $number = 0;
    my $result = '';
    while (1)
    {
        my @arr = unpack($template, $enc);
        if (@arr[~~@arr - 1] == 255)
        {
            last;
        }
        if (@arr[~~@arr - 1] == 7)
        {
            $template .= "lC";
        }
        elsif (@arr[~~@arr - 1] <= 4)
        {
            $template .= "C";
        }
    }
    for (unpack($template, $enc))
    {
        if ($_ == 7)
        {
            $number = 1;
        }
        else
        {
            if ($number)
            {
                $result .= $_;
                $number = 0;
            }
            elsif ($_ != 255)
            {
                $result .= $help{$_};
            }
        }
    }
    return $result;
}

my $a = ENC('(10-3)');
my @arr = unpack("CClC", $a);
say join(' ', @arr[~~@arr - 1]);