package PerlIO::via::Numerator;

my %indices;

sub PUSHED
{
    my ($class, $mode, $fh) = @_;
    my $buf = '';
    my $obj = bless \$buf,$class;
    $indices{$obj} = 0;
    return $obj;
}

sub FILL
{
    my ($obj,$fh) = @_;
    my $line = <$fh>;
    if (defined $line)
    {
        $line =~ s/^\d+\s//;
        return $line;
    }
    return undef;
}

sub WRITE
{
    my ($obj,$buf,$fh) = @_;
    if ($indices{$obj} == 0)
    {
        $buf = "0 ".$buf;
        $indices{$obj}++;
    }
    $buf =~ s/\n/\n@{[do{$indices{$obj}++}]} /g;
    $$obj .= $buf;
    return length($buf);
}

sub FLUSH
{
    my ($obj,$fh) = @_;
    print $fh $$obj or return -1;
    $$obj = '';
    return 0;
}

1;