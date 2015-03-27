package Local::PerlCourse::Homework;

use strict;
use warnings;
use Exporter 'import';
use feature "switch";
our @EXPORT_OK = qw(homework2_calc homework2_poland homework2_xml);

sub balanced
{
    my $balance = 0;
    for (split //, shift)
    {
        $balance++ if ($_ eq '(');
        $balance-- if ($_ eq ')');
        return 0 if ($balance < 0);
    }
    return $balance == 0;
}

sub homework2_calc
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    my ($current, $sign, $balance, $result, $last, $index) = (1, 1, 0, 0, 0, 0);
    for (split //, $expression.'_')
    {
        $balance += $_ eq '(' ? 1 : $_ eq ')' ? -1 : 0;
        if (!$balance and ($_ eq '+' or $_ eq '*' or $_ eq '-' or $_ eq '_'))
        {
            last if ($_ eq '_' and !$last);
            $current *= homework2_calc(substr($expression, $last, $index - $last));
            $result += $sign * $current, $current = 1 if (!($_ eq '*'));
            $sign = $_ eq '+' ? 1 : $_ eq '-' ? -1 : $sign;
            $last = $index + 1;
        }
        $index++;
    }
    return $result = $last == 0 ? homework2_calc(substr($expression, 1, length($expression) - 2)) : $result;
}

sub homework2_poland
{
    chomp(my $expression = join('', split(' ', shift)));
    return $expression.' ' unless +grep {index($expression, $_) != -1} split (//, '+-*()');
    my ($balance, $result, $last, $index) = (0, '', 0, 0);
    for (split //, $expression.'_')
    {
        $balance += $_ eq '(' ? 1 : $_ eq ')' ? -1 : 0;
        if (!$balance and ($_ eq '+' or $_ eq '*' or $_ eq '-' or $_ eq '_'))
        {
            last if ($_ eq '_' and !$last);
            $result .= $_.' ' if (!($_ eq '_'));
            $result .= homework2_poland(substr($expression, $last, $index - $last));
            $last = $index + 1;
        }
        $index++;
    }
    return $result = $last == 0 ? homework2_poland(substr($expression, 1, length($expression) - 2)) : $result;
}

sub trim
{
    my $ans = "";
    my $started = 0;
    for (split(//, shift))
    {
        if ($started or !($_ eq ' '))
        {
            $ans .= $_;
            $started = 1;
        }
    }
    return $ans;
}

sub homework2_xml
{
    my $curhash = {
        name => "",
        backref => undef,
        refs => [],
        data => "",
        attrs => {}
    };

    my $state = "Read";
    my $tmpname = "";
    my $tmpval = "";
    my $openquote = '';

    my %actions = (

        Read => sub {
            given (my $c = shift) {
                when ('<') {
                    $state = "WaitTagName";
                }
                default {
                    $curhash -> {data} .= $c;
                }
            }
        },

        WaitTagName => sub {
            given (my $c = shift) {
                when (' ') {
                    return;
                }
                when ('/') {
                    $state = 'Exit';
                }
                default {
                    my $newhash = {
                        name => "",
                        backref => $curhash,
                        refs => [],
                        data => "",
                        attrs => {}
                    };
                    push($curhash -> {refs}, $newhash);
                    $curhash = $newhash;
                    $curhash -> {name} .= $c;
                    $state = "ReadTagName";
                }
            }
        },

        ReadTagName => sub {
            given (my $c = shift) {
                when (' ') {
                    $state = "WaitAttrName";
                    $tmpname = "";
                }
                when ('>') {
                    $state = "Read";
                }
                default {
                    $curhash -> {name} .= $c;
                }
            }
        },

        WaitAttrName => sub {
            given (my $c = shift) {
                when (' ') {
                    return;
                }
                when ('>') {
                    $state = "Read";
                }
                default {
                    $tmpname = $c;
                    $state = "ReadAttrName";
                }
            }
        },

        ReadAttrName => sub {
            given (my $c = shift) {
                when (' ') {
                    return;
                }
                when ('=') {
                    $curhash -> {attrs} -> {$tmpname} = undef;
                    $state = "WaitValue";
                }
                default {
                    $tmpname .= $c;
                }
            }
        },

        WaitValue => sub {
            given (my $c = shift) {
                when (' ') {
                    return;
                }
                when ("'") {
                    $state = "ReadValue";
                    $openquote = "'";
                    $tmpval = "";
                }
                when ('"') {
                    $state = "ReadValue";
                    $openquote = '"';
                    $tmpval = "";
                }
            }
        },

        ReadValue => sub {
            given (my $c = shift) {
                when ($openquote) {
                    $curhash -> {attrs} -> {$tmpname} = $tmpval;
                    $tmpval = "";
                    $state = "WaitAttrName";
                }
                default {
                    $tmpval .= $c;
                }
            }
        },

        Exit => sub {
            given (my $c = shift) {
                when (' ') {
                    return;
                }
                when ('>') {
                    $curhash = $curhash -> {"backref"};
                    $state = "Read";
                }
                default {
                    return;
                }
            }
        }
    );

    while (+@_)
    {
        my $line = shift;
        chomp($line);
        $line = trim($line);
        for (split(//, $line))
        {
            &{$actions{$state}}($_);
        }
    }

    return $curhash;
}

0x179;