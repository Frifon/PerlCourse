package PerlIO::via::Numerator;
use Data::Dumper;
use DDP;

my %indices;

sub PUSHED
{
    my ($class, $mode, $fh) = @_;
    p $class;
    my $buf = '';
    my $obj = bless \$buf,$class;
    $indices{$obj} = 0;
    return $obj, $mode;
}

sub OPEN
{
    # my ($self, $path, $mode, $fh) = @_;
    print Dumper(\@_), $/;
    # open (my $fh, $mode)
    # return $self->SUPER::OPEN(@_);
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