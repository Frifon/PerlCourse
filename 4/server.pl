use warnings;
use strict;

use IO::Socket;
use Parse::RecDescent;
use Data::Dumper;

use feature 'say';

my $server = IO::Socket::INET->new (
    LocalPort => 8081,
    Type => SOCK_STREAM,
    ReuseAddr => 1,
    Listen => 10
) 
or die "Can't create server on port 8081: $@ $/";

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
                    @item = main::decode(@item);
                    shift @item;
                    $item[1] *= -1 if ($item[0] eq '-');
                    $return = main::encode(1 * $item[1]);
                }
            | ABS_NUMBER
                {
                    $return = main::encode($item[1]);
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
                    @item = main::decode(@item);
                    my $cnt = 0;
                    do {$cnt += 1 if (@{$_}[1] eq '-')} for (@{$item[1]});
                    $item[3] *= -1 if ($cnt % 2 == 1);
                    $return = main::encode($item[3]);
                }

    startrule : SUMMARY

_END_OF_GRAMMAR_

sub expression
{
    my @item = decode(@_);
    my $return = $item[1];
    for (@{$item[2]})
    {
        @{$_} = decode(@{$_});
        $return .= @{$_}[1].'('.@{$_}[2].')';
    }
    $return =~ s/\^/\*\*/g;
    $return = encode(eval($return));
    return $return;
}

sub decode
{
    my @args = @_;
    for my $i (0 .. ~~@args - 1)
    {
        $args[$i] =~ s/ZERO/0/g;
    }
    return $args[0] if (~~@args == 1);
    return @args;
}

sub encode
{
    my @args = @_;
    for my $i (0 .. ~~@args - 1)
    {
        $args[$i] =~ s/0/ZERO/g;
    }
    return $args[0] if (~~@args == 1);
    return @args;
}

sub calculate
{
    my $input = shift;
    my $parser = Parse::RecDescent->new($grammar);
    $input = $parser->startrule($input);
    return decode($input);
}


sub ENC
{
    my $nums = "0123456789";
    my %help = (
        '+' => 0,
        '-' => 1,
        '*' => 2,
        '(' => 3,
        ')' => 4
    );
    my @arr;
    my $template = '';
    my $number = '';
    my $str = shift;
    $str =~ s/ //g;
    for (split //, $str)
    {
        if (index($nums, $_) != -1)
        {
            $number .= $_;
        }
        else
        {
            if ($number)
            {
                push @arr, 7;
                push @arr, 0 + $number;
                $template .= 'Cl';
                $number = '';
            }
            if (exists($help{$_}))
            {
                push @arr, $help{$_};
                $template .= 'C';
            }
        }
    }
    if ($number ne '')
    {
        push @arr, 7;
        push @arr, 0 + $number;
        $template .= 'Cl';
        $number = '';
    }
    $template .= 'C';
    push(@arr, 255);
    return pack($template, @arr);
}

sub DEC
{
    my $enc = shift;
    my $nums = "0123456789";
    my %help = (
        '0' => '+',
        '1' => '-',
        '2' => '*',
        '3' => '(',
        '4' => ')'
    );
    my $template = 'C';
    my $number = 0;
    my $result = '';
    while (1)
    {
        my @arr = unpack($template, $enc);
        if (@arr[~~@arr - 1] == 255)
        {
            last;
        }
        if (@arr[~~@arr - 1] == 7)
        {
            $template .= "lC";
        }
        elsif (@arr[~~@arr - 1] <= 4)
        {
            $template .= "C";
        }
    }
    for (unpack($template, $enc))
    {
        if ($_ == 7)
        {
            $number = 1;
        }
        else
        {
            if ($number)
            {
                $result .= $_;
                $number = 0;
            }
            elsif ($_ != 255)
            {
                $result .= $help{$_};
            }
        }
    }
    return $result;
}

say 'Server is on!';

while (my $client = $server->accept())
{
    say "New connection!";
    $client -> autoflush(1);
    my $message;
    $client->recv($message, 1024);
    $message = DEC($message);
    my $calc = calculate($message);
    say "<$message> = $calc";
    say $client ENC(decode($calc));
}
close($server);