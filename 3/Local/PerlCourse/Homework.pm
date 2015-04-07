package Local::PerlCourse::Homework;

use strict;
use warnings;
use Exporter 'import';
use feature "switch";
our @EXPORT_OK = qw(homework2_calc homework2_poland homework2_xml);

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
    my ($current, $sign, $balance, $result, $last, $index, $cnt) = ('', 1, 0, '', 0, 0, 0);
    for (split //, $expression.'_')
    {
        $balance += $_ eq '(' ? 1 : $_ eq ')' ? -1 : 0;
        if (!$balance and ($_ eq '+' or $_ eq '*' or $_ eq '-' or $_ eq '_'))
        {
            last if ($_ eq '_' and !$last);
            $current .= homework2_poland(substr($expression, $last, $index - $last));
            $cnt++;
            $sign = $_ eq '+' ? 1 : $_ eq '-' ? -1 : $sign;
            my $pref = '';
            $pref = '+' if (!($_ eq '_') and $sign == 1);
            $pref = '-' if (!($_ eq '_') and $sign == -1);
            if (!($_ eq '*'))
            {
                $current = ('* ' x ($cnt - 1)).$current;
                $result .= "$pref " if (!($_ eq '_'));
                $result .= $current;
                $current = '';
                $cnt = 0;
            }
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
        attrs => {},
        comment => ""
    };

    my $state = "Read";
    my $tmpname = "";
    my $tmpval = "";
    my $openquote = '';
    my @last_chars = ();

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
            my $c = shift;
            if ($c eq '!')
            {
                $curhash -> {comment} .= '<';
                $state = "ReadComment";
                return;
            }
            given ($c) {
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
        },

        ReadComment => sub {
            my $c = shift;
            $curhash -> {comment} .= $c;
            if ($c eq '>' and $last_chars[4] eq '-' and $last_chars[3] eq '-') {
                $state = "Read";
            }
        }
    );

    my @lines = @_;

    for my $line (@lines)
    {
        chomp($line);
        last if ($line eq '###exit###');
        $line = trim($line);
        for (split(//, $line))
        {
            &{$actions{$state}}($_);
            push @last_chars, $_;
            shift @last_chars if +@last_chars > 5;
        }
    }
    return $curhash;
}

0x179;