use PerlIO::via::Numerator;
use feature 'say';
use Data::Dumper;

$a = 0;

if ($a)
{
    open(my $fh, ">:via(Numerator)", "foo.hex");;
    my $h = {
        a => 1,
        b => 2
    };
    print $fh Dumper($h) for (0 .. 10);
    say $fh '';
    say $fh 'c';
    say $fh 'd';
    
    open(my $fh1, ">:via(Numerator)", "boo.hex");;
    my $g = {
        c => 3,
        d => 4
    };
    print $fh1 main::Dumper($g);
    say $fh1 'e';
    say $fh1 'f';

    close $fh;
    close $fh1;
}
else
{
    open(my $fh, "<:via(Numerator)", "foo.hex");
    print $_ for (<$fh>);
    say '===';
    open(my $fh1, "<:via(Numerator)", "boo.hex");
    print $_ for (<$fh1>);
    close $fh;
    close $fh1;
}