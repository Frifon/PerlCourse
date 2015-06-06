use strict;
use warnings;

use AnyEvent::HTTP;
use Web::Query;
use Data::Dumper;
use feature 'say';

my $HOME_DOMAIN;

sub get_domain
{
    my $link = shift;
    $link = substr($link, 7, length($link) - 7) if ($link =~ /^http:\/\//);
    $link = substr($link, 4, length($link) - 4) if ($link =~ /^www./);
    if (index($link, '/') != -1)
    {
        $link = substr($link, 0, index($link, '/'));
    }
    return $link;
}

sub make_good_link
{
    my $link = shift;
    $link = substr($link, 0, length($link)) if ($link =~ /\/$/);
    return '' unless (get_domain($link) eq $HOME_DOMAIN);
    return $link;
}

sub build_link
{
    my ($base_link, $link) = @_;
    return '' unless (defined($base_link));
    return '' unless (defined($link));
    return '' if ($link =~ /^#/);
    if ($link =~ /^\//)
    {
        return make_good_link('http://'.make_good_link(get_domain($base_link).$link));
    }
    return make_good_link($link) if ($link =~ /^http:\/\//);
    return make_good_link($link) if ($link =~ /^www./);

    return make_good_link('http://'.make_good_link(get_domain($base_link).'/'.$link));
}

my $exit_wait = AnyEvent->condvar;

my %uniq;
my $start_link = 'http://perldoc.perl.org/index.html';
$HOME_DOMAIN = get_domain($start_link);
my @queue = ($start_link);
$uniq{''} = 0;
my $cnt = 0;
my $sum_size = 0;
my $requests = 0;
my @max_pages;
push @max_pages, '' for (1 .. 10);

my $w = AnyEvent->timer (after => 0.5, interval => 1, cb => sub {
    
    say '';
    say 'Statistics';
    say "Uniq pages: $cnt";
    say "Summary size: $sum_size";
    say "Requests: $requests";
    say 'Biggest pages:';
    my $max_len = 0;
    for (@max_pages)
    {
        $max_len = length($_) if (length($_) > $max_len);
    }
    for (@max_pages)
    {
        say $_, ' ' x ($max_len + 10 - length($_)), $uniq{$_} if ($_);        
    }
    say '';

    $exit_wait->send if (scalar(@queue) == 0 && $requests == 0);

    while (scalar @queue)
    {
        my $link = shift @queue;
        
        # say "New Event <$link>";
        $requests++;

        my $request;
        $request = http_request (
            GET => $link,
            TIMEOUT => 10,
            sub {
                $requests--;
                undef $request;
                my ($body, $hdr) = @_;
                my $url = $hdr->{URL};
                
                # say "Callback caught";
                # say "Url is <$url>";
                # say $hdr->{Status};
                
                if ($hdr->{Status} =~ /^2/ && (!defined($uniq{$url}) || $uniq{$url} == -1))
                {
                    # say $hdr->{Status}, " is ok";
                    # say "Url is <$url>";
                    
                    $cnt++;
                    $sum_size += length($body);
                    $uniq{$url} = length($body);

                    push @max_pages, $url;
                    @max_pages = sort {$uniq{$b} <=> $uniq{$a}} @max_pages;
                    @max_pages = @max_pages[0 .. 9];
                    
                    
                    my $wq = wq($body);

                    $wq->find('a')->each(sub {
                        my $link = $_->attr('href');
                        my $new_link = build_link($url, $link);
                        if ($new_link =~ /.html$/)
                        {
                            unless (defined($uniq{$new_link}))
                            {
                             
                                # say "New link found <$new_link>";
                             
                                $uniq{$new_link} = -1;
                                push @queue, $new_link;
                            }
                        }
                    });
                }
            }
        );
    }
});

$exit_wait->recv;