use warnings;
use strict;

use Data::Dumper;

use feature 'say';

sub parse_attrs
{
    my ($attrs, $href) = @_;
    $_ = $attrs;
    while (/\s*([a-z][\w0-9-]*)\s*=\s*(["'])(.*?)\g2/gsi)
    {
        ${$href}{"-$1"} = $3;
    }
}

sub xml_parse
{
    my %result = ();
    my ($input, $attrs) = @_;

    parse_attrs($attrs, \%result) if (defined($attrs) and $attrs);

    if ($input !~ /.*<.*/s)
    {
        $result{data} = $input if ($input);
        return $input if (not((defined($attrs) and $attrs)));
        return \%result;
    }  

    $_ = $input;
    my @tmp;
    push @tmp, [$1, $2, $6] while (/<\s*((?!XML)[a-z][\w0-9-]*)((\s+[a-z][\w0-9-]*\s*=\s*(["'])(.*?)\g4)*)\s*>(.*?)<\s*\/\s*\g1\s*>/gsi);
    for (@tmp)
    {
        my @arr = @{$_};
        if (exists($result{$arr[0]}))
        {
            push $result{$arr[0]}, xml_parse($arr[2], $arr[1]);
        }
        else
        {
            $result{$arr[0]} = [xml_parse($arr[2], $arr[1])];
        }
    }
    for (keys %result)
    {
        if ((ref($result{$_}) eq 'ARRAY') and ~~@{$result{$_}} == 1)
        {
            $result{$_} = @{$result{$_}}[0];
        }
    }

    return \%result;
}

my @lines = <>;
my $start = '';

for my $line (@lines)
{
    chomp($line);
    last if ($line eq '###exit###');
    $start .= $line;
}

$start =~ s/<!--.*-->//s;
my $href = xml_parse($start);
say Dumper($href);
