use strict;
use warnings;
use IO::Socket;
use feature 'say';

sub calc
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    my ($current, $sign, $balance, $result, $last, $index) = (1, 1, 0, 0, 0, 0);
    for (split //, $expression.'_')
    {
        $balance += $_ eq '(' ? 1 : $_ eq ')' ? -1 : 0;
        if (!$balance and ($_ eq '+' or $_ eq '*' or $_ eq '-' or $_ eq '_'))
        {
            last if ($_ eq '_' and !$last);
            $current *= calc(substr($expression, $last, $index - $last));
            $result += $sign * $current, $current = 1 if (!($_ eq '*'));
            $sign = $_ eq '+' ? 1 : $_ eq '-' ? -1 : $sign;
            $last = $index + 1;
        }
        $index++;
    }
    return $result = $last == 0 ? calc(substr($expression, 1, length($expression) - 2)) : $ result;
}

my $server = IO::Socket::INET -> new(
    LocalPort => 8081,
    Type => SOCK_STREAM,
    ReuseAddr => 1,
    Listen => 10) 
    or die "Can't create server on port 8081: $@ $/";

say 'Start server';

my %new_messages;
my $id = 1;

while (my $client = $server->accept())
{
    say "New connection!";
    say %new_messages;
    $client -> autoflush(1);
    my $message = <$client>;
    say 'get '.$message;
    chomp($message);
    if ($message eq 'new')
    {
        say 'new user! id: '.$id;
        $new_messages{$id} = '';
        say $client $id;
        close ($client);
        $id++;
    }
    else
    {
        my ($name, @arr) = split(':', $message);
        $message = join(':', @arr);
        for (keys %new_messages)
        {
            if ($_ != $name)
            {
                $new_messages{$_} .= $message.$/;
            }
        }
        say $client join($/, $new_messages{$name});
        $new_messages{$name} = '';
        close($client);
    }
}
close($server);