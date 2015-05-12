use strict;
use warnings;
use IO::Socket;
use feature 'say';

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
    for (split //, shift)
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
    if ($number)
    {
        push @arr, 7;
        push @arr, 0 + $number;
        $template .= 'Cl';
        $number = '';
    }
    say $template;
    say(join(' ', @arr));
    return pack($template, @arr);
}

while (1)
{
    my $inp = <>;
    my $socket = IO::Socket::INET -> new(
        PeerAddr=> '0.0.0.0',
        PeerPort=> 8081,
        Proto => 'tcp',
        Type => SOCK_STREAM) 
    or die "Can`t connect to server :-($/";
    say $inp;
    say $socket ENC($inp);
    my @answer = <$socket>;
    say(join($/, @answer));
    close($socket);
}