# http://ok.ru/goodfood/topic/66791673176064
# $topic->id; OK
# $topic->content; OK
# $topic->text;
# $topic->group; OK

package Local::OK::Topic;
use base qw(Local::Mixin::Downloadable);
use Local::OK::Group;
use Mojo::DOM;

sub new
{
    my ($class, $url) = @_;
    my %data = (
        url => $url
    );
    
    my $obj =  bless \%data, $class;
    $obj->init();

    return $obj;
}

sub init 
{
    my ($self) = @_;

    my $start = index($self->url, '/topic/');
    $self->{group} = Local::OK::Group->new(substr($self->url, 0, $start + 1));

    $start += length('/topic/');
    if ((my $end = index($self->url, '/', $start)) != -1)
    {
        $self->{id} = substr($self->url, $start, $end - $start);
    }
    else
    {
        $self->{id} = substr($self->url, $start, length($self->url) - $start);
    }

    my $dom = Mojo::DOM->new($self->content);
    $self->{text} = $dom->find('div.media-text_cnt_tx')->[0]->content;

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

sub group
{
    my ($self) = @_;
    return $self->{group};
}

sub url
{
    my ($self) = @_;
    return $self->{url};
}

1;