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
use base qw(Local::Mixin::Downloadable);
use Mojo::DOM;

sub new
{
    my ($class, $link) = @_;
    my %data = (
        url => $link
    );


    $data{content} = Local::Mixin::Downloadable->download($link);
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