package Local::PerlCourse::Currency;

use strict;
use warnings;
use feature 'say';

sub import
{
    our %currency = map {join('', split(',', $_))} grep {!($_ eq '=>')} @_[1 .. +@_ - 1];
}

sub AUTOLOAD
{
    our $AUTOLOAD;
    our %currency;
    my @func = split('::', $AUTOLOAD);
    if (scalar(@func) == 4 and check_name($func[scalar(@func) - 1]) and scalar(@_))
    {
        my @values = split('_', $func[scalar(@func) - 1]);
        my $from = $currency{$values[0]};
        my $to = $currency{$values[2]};
        my $value = shift;
        return $value / $from * $to;
    }
    else
    {
        my $keys = join(', ', keys %currency);
        die "Bad call. [@func]$/Pattern: src_to_dst(value)$/src, dst = [$keys]$/";
    }
}

sub check_name
{
    our %currency;
    my $name = shift;
    my @values = split('_', $name);
    return (scalar(@values) == 3 
            and $values[1] eq 'to' 
            and exists($currency{$values[0]}) 
            and exists($currency{$values[2]}));
}

sub make_function
{
    my ($name, $from, $to) = @_;
    our %currency;
    my $func_name = "::main::$name\_$to";
    $name = "::main::$name";

    if (!exists($currency{$from}) or !exists($currency{$to}))
    {
        my $keys = join(', ', keys %currency);
        die "Bad call. [$from, $to]$/src, dst = [$keys]$/";
    }

    if (!exists(&$name))
    {
        die "Bad call. [$name]$/Function doesn't exist.$/"
    }

    no strict 'refs';
    *$func_name = sub {
        my $val = $name -> (@_);
        return +$val / $currency{"$from"} * $currency{"$to"};
    };
    use strict 'refs';
}

sub generate_functions
{
    while (+@_)
    {
        my $ref = shift;
        make_function(@$ref);
    }
}

0x179;