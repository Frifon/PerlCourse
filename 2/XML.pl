use strict;
use warnings;
use feature 'say';

# name
# tagsrefs
# properties

my %root = (name => '', tagsrefs => (), properties => ());
my @input = <>;
my $text = join '', @input;

my $start_index = 0;
while ((my $current_index = index($text, '<', $start_index)) != -1)
{
    my @tag = split ' ', substr($text, $current_index + 1, index($text, '>', $current_index) - $current_index - 1);
    $, = ' ';
    say @tag;
    $start_index = $current_index + 1;
}