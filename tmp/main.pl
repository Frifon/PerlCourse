use warnings;
use strict;
use feature 'say';
use Data::Dumper;

my $a = 1;
my $b = "abababa";
$b =~ s/a/@{[do{$a++}]}/g;
say $b;

say $a++;
say "@{[do{$a++}]}";
say "@{[do{$a++}]}";
say "@{[do{$a++}]}";