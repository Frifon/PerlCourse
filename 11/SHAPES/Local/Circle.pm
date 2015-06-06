package Local::Circle;

use Moose;
use Math::Trig;

has radius => (
    is => 'rw',
    isa => 'Num'
);

sub area
{
    my ($self) = @_;
    return pi * $self->radius ** 2;
}

sub length
{
    my ($self) = @_;
    return 2 * pi * $self->radius;
}

__PACKAGE__->meta->make_immutable;

1;