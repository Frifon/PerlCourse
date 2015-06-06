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

    my $obj = bless(\%data, $class);
    $obj->init();

    return $obj;
}

sub init {
    my ($self) = @_;

    my $dom = Mojo::DOM->new($self->content);
    $dom->find('div')->map(attr => 'data-log-click')->each(
        sub {
            if ((my $ind = index($_, 'owners')) != -1)
            {
                my $openbr = index($_, '[', $ind);
                my $closebr = index($_, ']', $ind);
                $self->{id} = substr($_, $openbr + 1, $closebr - $openbr - 1);
                last;
            }
        }
    );
    my $tmp = $dom->find('span[class=mctc_name_holder textWrap]')->[0]->content;
    my $dom_for_name = Mojo::DOM->new($tmp);
    my $name = $dom_for_name->content;
    if ($dom_for_name->at('div'))
    {
        my ($new_name, $start, $len) = ("", index($name, $dom_for_name->at('div')), length($dom_for_name->at('div')));
        for my $i (0 .. length($name) - 1)
        {
            if ($i < $start or $i >= $start + $len)
            {
                $new_name .= substr($name, $i, 1);
            }
        }
        $name = $new_name;
    }
    if ($dom_for_name->at('span'))
    {
        my ($new_name, $start, $len) = ("", index($name, $dom_for_name->at('span')), length($dom_for_name->at('span')));
        for my $i (0 .. length($name) - 1)
        {
            if ($i < $start or $i >= $start + $len)
            {
                $new_name .= substr($name, $i, 1);
            }
        }
        $name = $new_name;
    }
    $self->{name} = $name;

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

sub url
{
    my ($self) = @_;
    return $self->{url};
}

1;