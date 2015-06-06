use warnings;
use strict;
use Data::Dumper;
use feature 'say';

sub to_bits
{
    my ($ip) = @_;
    my $pos = 8;
    my @res;
    push @res, 0 for (1 .. 32);
    for (split(/\./, $ip))
    {
        my ($number, $cur) = ($_ + 0, 1);
        while ($number)
        {
            $res[$pos - $cur] = 1 if ($number % 2);
            $number = int($number / 2);
            $cur++;
        }
        $pos += 8;
    }
    return @res;
}

sub check
{
    my ($ip, $mask) = @_;
    my ($mask_ip, $mask_num) = split(/\//, $mask);
    my @ip_bits = to_bits($ip);
    my @mask_bits = to_bits($mask_ip);
    for (1 .. 32)
    {
        if ($mask_num < $_)
        {
            $ip_bits[$_ - 1] = 0;
            $mask_bits[$_ - 1] = 0;
        }
    }
    my $ok = 1;
    for (0 .. 31)
    {
        $ok = 0 if $mask_bits[$_] != $ip_bits[$_];
    }
    return $ok;


}

if (check('127.0.0.7', '127.0.0.1/29'))
{
    say 'yes';
}
else
{
    say 'no';
}