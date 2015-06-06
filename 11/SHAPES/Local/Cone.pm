package Local::Cone;

use Moose;
use Math::Trig;

has height => (
    is => 'rw',
    isa => 'Num'
);

has base => (
    is => 'rw',
    isa => 'Item'
);

sub slant_height
{
    my ($self) = @_;
    return sqrt($self->height ** 2 + $self->base->radius ** 2);
}

sub surface_area
{
    my ($self) = @_;
    return pi * $self->base->radius * ($self->base->radius + $self->height);
}

sub volume
{
    my ($self) = @_;
    return 1. / 3 * $self->base->area() * $self->height;
}


__PACKAGE__->meta->make_immutable;
1;