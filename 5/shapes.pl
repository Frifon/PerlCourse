use strict;
use warnings;

use Local::Cone;
use Local::Circle;

use feature 'say';

my $cone = Local::Cone->new(
    base => Local::Circle->new(radius => 1.5),
    height => 12
);

say $cone->height; 
say $cone->slant_height;
say $cone->surface_area;
say $cone->volume;
say $cone->base;
say $cone->base->radius;
say $cone->base->area;
say $cone->base->length;