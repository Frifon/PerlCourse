use strict;
use warnings;
use IO::Socket;
use feature 'say';

my $socket = IO::Socket::INET -> new(
    PeerAddr=> '172.20.10.2',
    PeerPort=> 8081,
    Proto => 'tcp',
    Type => SOCK_STREAM) 
    or die "Can`t connect to server :-($/";
say $socket 'new';
my $id = <$socket>;
close ($socket);

chomp($id);
say 'my id: '.$id;

while (1 == 1)
{
    my $inp = <STDIN>;
    my $socket = IO::Socket::INET -> new(
        PeerAddr=> '172.20.10.2',
        PeerPort=> 8081,
        Proto => 'tcp',
        Type => SOCK_STREAM) 
        or die "Can`t connect to server :-($/";
    say $id.':'.$inp;
    print $socket $id.':'.$inp; 
    my @answer = <$socket>;
    say(join($/, @answer));
    close($socket);
}