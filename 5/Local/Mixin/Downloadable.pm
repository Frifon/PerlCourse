package Local::Mixin::Downloadable;
require LWP::UserAgent;

sub download
{
    my ($class, $link) = @_;
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    my $response = $ua->get($link);
    if ($response->is_success)
    {
        return $response->decoded_content;
    }
    else
    {
        die $response->status_line;
    }
}

1;