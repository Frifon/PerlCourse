use DBI;
use utf8::all;
use feature 'say';

my $dbh = DBI->connect("DBI:mysql:database=perl;host=localhost;port=3306", 'root', '', {mysql_enable_utf8 => 1});

# 1.
# my $sth = $dbh->prepare("SELECT * FROM student WHERE name LIKE 'А%'");
# $sth->execute();
# while (my $ref = $sth->fetchrow_hashref())
# {
#     print "Found a row: id = $ref->{'id'}, name = $ref->{'name'}\n";
# }
# $sth->finish();

# 2.
# $results = $dbh->selectall_hashref("SELECT * FROM grade JOIN student ON grade.student_id = student.id WHERE grade = '5'", 'id');
# for my $id (keys %$results)
# {
#     say "$results->{$id}->{name} получил 5! УРА!";
# }

$dbh->disconnect();