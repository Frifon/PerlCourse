use warnings;
use strict;

use Parse::RecDescent;
use Data::Dumper;

use feature 'say';

$::RD_ERRORS = 1;
$::RD_WARN = 1;
$::RD_HINT = 1;
# $::RD_TRACE = 1;

my $grammar = <<'_END_OF_GRAMMAR_';

    OP : m([-+*\/%])
    ABS_NUMBER : /[0-9]*\.?[0-9]+([eE][-+]?[0-9]+)?/
    UNARY_SIGN : /[+-]/

    NUMBER : UNARY_SIGN NUMBER
                {
                    @item = @item;
                    shift @item;
                    $item[1] *= -1 if ($item[0] eq '-');
                    $return = eval(1 * $item[1]);
                }
            | ABS_NUMBER
                {
                    $return = eval($item[1]);
                }

    SUMMARY : PRODUCT (UNARY_SIGN PRODUCT{\@item})(s?)
                {
                    $return = main::expression(@item);
                }
    PRODUCT : POW (/[\*\/]/ POW{\@item})(s?)
                {
                    $return = main::expression(@item);
                }

    POW : FACTOR (/\^|\*\*/ FACTOR{\@item})(s?)
                {
                    $return = main::expression(@item);
                }

    FACTOR  : NUMBER
            | (/[-\+]/{\@item})(s?) /\(/ SUMMARY /\)/
                {
                    my $cnt = 0;
                    do {$cnt += 1 if (@{$_}[1] eq '-')} for (@{$item[1]});
                    $item[3] .= "-1 * " if ($cnt % 2 == 1);
                    $return = $item[3];
                }

    startrule : SUMMARY

_END_OF_GRAMMAR_

sub expression
{
    my @item = @_;
    my $return = $item[1];
    for (@{$item[2]})
    {
        $return .= ' '.@{$_}[2].' '.@{$_}[1];
    }
    return $return;
}

sub calculate
{
    my $input = shift;
    my $parser = Parse::RecDescent->new($grammar);
    $input = $parser->startrule($input);
    return $input;
}

my $input = <>;
chomp $input;

my $calc = calculate($input);

if ($calc)
{
    say "<$input> is valid";
    say $calc;
}
else
{
    say "<$input> us invalid";
}