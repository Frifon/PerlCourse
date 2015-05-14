use warnings;
use strict;
use feature 'say';
use Devel::Size qw(size total_size);

my $a = "1";
say 'value <', $a, '> ref <', \$a, '> size <', size($a), '>';
$a = "111".$a;
say 'value <', $a, '> ref <', \$a, '> size <', size($a), '>';
