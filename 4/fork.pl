use warnings;
use strict;
use Time::HiRes qw(usleep nanosleep);
use POSIX qw(:sys_wait_h);
use Fcntl qw(:flock);
use feature 'say';

$SIG{ALRM} = sub {return 0};
$SIG{CHLD} = sub
{
    while (my $pid = waitpid(-1, WNOHANG))
    {
        last if $pid == -1;
        if (WIFEXITED($?))
        {
            my $status = $? >> 8;
            print "Process $pid exited with status $status$/";
        }
        else
        {
            print"Process $pid sleep$/";
        } 
    }
};

sub kill
{
    our @pids;
    say "forks will die in 3";
    sleep(1);
    say "forks will die in 2";
    sleep(1);
    say "forks will die in 1";
    sleep(1);
    say 'killing';
    set_command('exit');
    for (@pids)
    {
        say "wait for $_";
        waitpid($_, 0);
        say "$_ is dead";
    }
    exit;
}

sub read_command
{
    open(my $fh, '<', 'commands');
    my $line = <$fh> or return '';
    chomp($line);
    close($fh);
    return $line;
}

sub set_command
{
    my $command = shift;
    open(my $fh, '>', "commands");
    flock($fh, LOCK_EX);
    say $fh $command;
    close($fh);
}

my $N = 5;
my $K = 100;
my $fork_id = -1;
my @arr = ('a' .. 'z');
our @pids;
set_command('');

say @arr;

for (my $i = 0; $i < $N; $i++)
{
    my $pid = fork();
    if (!$pid)
    {
        die 'Can\'t fork' unless defined $pid;
        say 'new fork: '.$i;
        $fork_id = $i;
        last;
    }
    else
    {
        push @pids, $pid;
    }
}

if ($fork_id != -1)
{
    say $fork_id.' make new file ';
    open(my $fh, '>', "$fork_id\.dat");
    flock($fh, LOCK_EX);
    for (my $i = 0; $i < $K; $i++)
    {
        print $fh $arr[int(rand(26))].' ';
    }
    close($fh);
    say "$fork_id is ready. waiting 5 sec";
    sleep(5);
    while (1)
    {
        my $command = read_command();
        exit if ($command eq 'exit');

        open(my $my_file, '+<', "$fork_id\.dat");
        alarm(rand(5) + 1);
        if (flock($my_file, LOCK_EX))
        {
            alarm(0);
            # say $fork_id, ' flocked his file';
            my $to = $fork_id;
            $to = int(rand($N)) while ($to == $fork_id);
            # say $fork_id, ': to ', $to;
            open(my $to_file, '+<', "$to\.dat");
            # say $fork_id, ': opened';
            alarm(rand(5) + 1);
            if (flock($to_file, LOCK_EX))
            {
                alarm(0);
                # say "fork $fork_id locked two files ($to)";
                my @my_cards = split(' ', <$my_file>);
                my @his_cards = split(' ', <$to_file>);
                seek($my_file, 0, 0);
                seek($to_file, 0, 0);

                my %uniq;
                $uniq{$_}++ for (@my_cards);
                my $min = 0;
                for (my $i = 0; $i < $K; $i++)
                {
                    $min = $i if ($uniq{$my_cards[$i]} < $uniq{$my_cards[$min]});
                }
                if ($fork_id != 0)
                {
                    $min = int(rand($K));
                }

                my $to_card = int(rand($K));

                # say $fork_id, ': ', join(' ', @my_cards), ' : ', $min;
                # say $fork_id, ': ', join(' ', @his_cards), ' : ', $to_card;

                ($my_cards[$min], $his_cards[$to_card]) = ($his_cards[$to_card], $my_cards[$min]);

                # say $fork_id, ': ', join(' ', @my_cards);
                # say $fork_id, ': ', join(' ', @his_cards);

                say $my_file join(' ', @my_cards);
                say $to_file join(' ', @his_cards);

                close($my_file);
                close($to_file);
            }
            else
            {
                # say $fork_id, ' couldn\'t flock to file';
                close($to_file);
                close($my_file);
                alarm(0);
            }
        }
        else
        {
            # say $fork_id, ' couldn\'t flock his file';
            close($my_file);
            alarm(0);
        }
        alarm(0);
        my $sleep_time = rand(500) + 500;
        # say "$fork_id sleep $sleep_time";
        usleep($sleep_time);
    }
}
else
{
    say 'master is ready. waiting 5 sec';
    sleep(5);
    say join ' ', @pids, 'are ready';
    while (1)
    {
        say 'calculating...';
        my @results;
        for my $i (0 .. $N - 1)
        {
            # say "$i\.dat";
            open(my $fh, '<', "$i\.dat");
            flock($fh, LOCK_EX);
            my @cards = split(' ', <$fh>);
            # say join(' ', @cards);
            my %uniq;
            $uniq{$arr[$_]} = 0 for (0 .. 25);
            my $best = 'a';
            for (@cards)
            {
                $uniq{$_}++;
                if ($uniq{$_} >= $uniq{$best})
                {
                    $best = $_;
                }
            }
            push @results, $best;
            push @results, $uniq{$best};
            # say $best, ' ', $uniq{$best};
            # say join(' ', @cards);
            close($fh);
        }
        my $s;
        for my $i (0 .. $N - 1)
        {
            $s .= $i.': '.$results[$i * 2].' '.$results[$i * 2 + 1].$/;
        }
        say $s;
        sleep(10);
    }
}