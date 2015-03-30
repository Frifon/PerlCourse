use strict;
use warnings;
use Data::Dumper;
use feature 'say';
use feature "switch";

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

# name: scalar
# backref: scalar
# refs: array of scalars
# data: scalar
# attrs: hash
# comment: scalar

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

my @lines = <>;

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

print Dumper($curhash);



# <jmynal>
# <title lal = "1">Very Useful Jmynal</title>
# <contacts>
#     <address>sdsds</address>
#     <tel>8-3232-121212</tel>
#     <tel>8-3232-121212</tel>
#     <email>j@j.ru</email>
# <url>www.j.ru</url>
# </contacts>
# </jmynal>  