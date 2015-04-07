use warnings;
use strict;
use Local::PerlCourse::Homework qw(homework2_calc homework2_xml);
use Data::Dumper;
use feature 'say';

say homework2_calc("(1+10*(6+3)-6+(((1 + 1) * 2 * (2 + 3)) + 10)) + 0 - 60 * 100 * (10 - 10) + 30 * 31 * (42 - 43) + ((((((((((0-0)))))))))) - 45 + 30 + 30 * (30 * (30 * 30 * (1 * (1 + 1 + 1 + (1 * (2 * (3 * 4 + 10 + 45 - 12 * (33)))))))) + 10 - 30 * (1 + 3 - 69 * (4 + 2 + 10 * (42 - 42 + 42))) - 37 + 1 + 2 + 3 + 3 + (0 + (0 + (0 + (0 + (0 + (10 * 13))) - 35)) * 71) + 32 + 1000000000");
say Local::PerlCourse::Homework::homework2_poland("(1+10*(6+3)-6+(((1 + 1) * 2 * (2 + 3)) + 10)) + 0 - 60 * 100 * (10 - 10) + 30 * 31 * (42 - 43) + ((((((((((0-0)))))))))) - 45 + 30 + 30 * (30 * (30 * 30 * (1 * (1 + 1 + 1 + (1 * (2 * (3 * 4 + 10 + 45 - 12 * (33)))))))) + 10 - 30 * (1 + 3 - 69 * (4 + 2 + 10 * (42 - 42 + 42))) - 37 + 1 + 2 + 3 + 3 + (0 + (0 + (0 + (0 + (0 + (10 * 13))) - 35)) * 71) + 32 + 1000000000");
print Dumper(homework2_xml("<note attr = '2  3 4 ' check = 'true!!!'><to>Tove</to><from>Jani</from><heading>Reminder</heading><body>Don't forget me this weekend!</body></note>"))