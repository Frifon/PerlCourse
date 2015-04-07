# http://ok.ru/group/54129200201728/
# $group->id; OK
# $group->name; OK
# $group->content; OK
# $group->url; OK

# http://ok.ru/goodfood
# $group->id;
# $group->name; OK
# $group->content; OK
# $group->url; OK

package Local::OK::Group;
require LWP::UserAgent;
use Mojo::DOM;
use feature 'say';

sub new
{
    my ($class, $link) = @_;
    my %data = (
        url => $link
    );
    my $ua = LWP::UserAgent->new;
    $ua->timeout(10);
    $ua->env_proxy;
    my $response = $ua->get($link);
    if ($response->is_success)
    {
        $data{content} = $response->decoded_content;
        my $dom = Mojo::DOM->new($data{content});
        $dom->find('div')->map(attr => 'data-log-click')->each(
            sub {
                if ((my $ind = index($_, 'owners')) != -1)
                {
                    my $openbr = index($_, '[', $ind);
                    my $closebr = index($_, ']', $ind);
                    $data{id} = substr($_, $openbr + 1, $closebr - $openbr - 1);
                    last;
                }
            }
        );
        chomp(my $name = shift([split(' : ', $dom->find("title")->[0]->content)]));
        $data{name} = $name;
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

sub name
{
    my ($self) = @_;
    return $self->{name};
}

sub content
{
    my ($self) = @_;
    return $self->{content};
}

sub url
{
    my ($self) = @_;
    return $self->{url};
}

1;