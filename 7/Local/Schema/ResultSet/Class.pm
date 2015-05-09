use utf8::all;
use feature 'say';
use strict;
use warnings;

package Local::Schema::ResultSet::Class;
use base 'DBIx::Class::ResultSet';

sub search_best_student
{
    my ($self) = @_;
    my $best = undef;
    for my $group ($self->search({}, {prefetch => 'students'}))
    {
        for my $student ($group->students)
        {
            if (!(defined $best) or ($best->gpa() < $student->gpa()))
            {
                $best = $student;
            }
        }
    }
    return $best;
}
    

1;