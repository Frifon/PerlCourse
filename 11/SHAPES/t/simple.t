use Test::Simple tests => 4;

use Local::Cone;
use Local::Circle;

my $cone = Local::Cone->new(
    base => Local::Circle->new(radius => 1.5),
    height => 12
);

ok (defined($cone) && ref($cone) eq 'Local::Cone', 'init works');
ok (defined($cone->base) && ref($cone->base) eq 'Local::Circle', 'circle init works');

ok ($cone->height == 12, 'height is ok');
ok ($cone->base->radius == 1.5, 'base radius is ok');
