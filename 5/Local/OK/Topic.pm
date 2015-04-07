# http://ok.ru/goodfood/topic/66791673176064
# $topic->id; OK
# $topic->content; OK
# $topic->text;
# $topic->group; OK

package Local::OK::Topic;
require LWP::UserAgent;
use Local::OK::Group;
use Mojo::DOM;
use feature 'say';

sub new
{
    my ($class, $link) = @_;
    my %data;

    my $start = index($link, '/topic/');

    $data{group} = Local::OK::Group->new(substr($link, 0, $start + 1));

    $start += length('/topic/');
    if ((my $end = index($link, '/', $start)) != -1)
    {
        $data{id} = substr($link, $start, $end - $start);
    }
    else
    {
        $data{id} = substr($link, $start, length($link) - $start);
    }

    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    my $response = $ua->get($link);
    if ($response->is_success)
    {
        $data{content} = $response->decoded_content;
        my $dom = Mojo::DOM->new($data{content});
        $data{text} = $dom->find('div.media-text_cnt_tx')->[0]->content;
    }
    else
    {
        die $response->status_line;
    }
    return bless \%data, $class;
}

sub id
{
    my ($self) = @_;
    return $self->{id};
}

sub text
{
    my ($self) = @_;
    return $self->{text};
}

sub content
{
    my ($self) = @_;
    return $self->{content};
}

sub group
{
    my ($self) = @_;
    return $self->{group};
}

1;