use Test::More;

BEGIN {
    use_ok('Local::Circle');
    use_ok('Local::Cone');
}

my $circle = Local::Circle->new(
    radius => 2
);

ok(defined($circle) && ref($circle) eq 'Local::Circle', 'circle init');
can_ok($circle, qw(length area));

is($circle->area() / $circle->length(), 1, 'Area and Lenghth are ok');

$circle->radius(0);
is($circle->area(), 0, 'area of circle(0)');
is($circle->length(), 0, 'length of circle(0)');

done_testing();