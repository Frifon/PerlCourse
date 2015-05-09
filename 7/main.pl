
# OK 1. while (fetch)
# OK 2. selectall
# OK 3. search + join
# OK 4. search + prefetch
# OK 5. result-method
# OK 6. resultset-method
# OK 7. create
# OK 8. update
# OK 9. delete


use Local::Schema;
use utf8::all;
use DateTime::Format::MySQL;
use feature 'say';

my $INIT = 0;

my $schema = Local::Schema->connect('dbi:mysql:perl', "root", "", {mysql_enable_utf8 => 1});

my $_students = $schema->resultset('Student');
my $_classes = $schema->resultset('Class');
my $_grades = $schema->resultset('Grade');
my $_subjects = $schema->resultset('Subject');

sub classes_init {
    say "classes initializing...";
    my $connection = shift;
    for my $i (1 .. 5)
    {
        for my $j (1 .. 12)
        {
            $connection->create (
                {
                    name => $i * 100 + $j,
                }
            );
        }
    }
    say "amount: $_classes";
    say "completed";
}

sub students_init {
    say "students initializing...";
    my $connection = shift;
    open(my $fh, '<:encoding(UTF-8)', 'surnames.txt');
    my @surnames = <$fh>;
    close $fh;
    open(my $fh, '<:encoding(UTF-8)', 'names.txt');
    my @names = <$fh>;
    close $fh;

    for my $i (@surnames)
    {
        chomp $i;
    }

    for my $i (@names)
    {
        chomp $i;
    }

    for my $i (1..1000)
    {
        if ($i % 100 == 0)
        {
            say "completed: ".($i / 10)."%";
        }
        my $name = $names[int(rand(~~@names))];
        my $surname = $surnames[int(rand(~~@surnames))];
        $connection->create (
            {
                name => "$surname $name",
                class_id => int(rand(5 * 12)) + 1
            }
        );
    }
    say "amount: $_students";
    say "completed";
}

sub subjects_init {
    say "subjects initializing...";
    my $connection = shift;
    open(my $fh, '<:encoding(UTF-8)', 'subjects.txt');
    my @subjects = <$fh>;
    close $fh;
    for my $i (@subjects)
    {
        chomp $i;
        $connection->create(
            {
                name => $i
            }
        );
    }
    say "amount: $_subjects";
    say "completed";
}

sub grades_init {
    say "grades initializing...";
    my $connection = shift;
    for my $i (1..10000)
    {
        if ($i % 1000 == 0)
        {
            say "completed: ".($i / 100)."%";
        }
        my $time = '2015-'.int(1 + rand(5)).'-'.int(1 + rand(28)).' '.int(9 + rand(5)).':'.int(rand(60)).':'.int(rand(60));
        $connection->create(
            {
                grade => int(rand(5)) + 1,
                time => DateTime::Format::MySQL->format_datetime(
                    DateTime::Format::MySQL->parse_datetime(
                        $time
                    )
                ),
                student_id => int(rand($_students)) + 1,
                subject_id => int(rand($_subjects)) + 1
            }
        );
    }
    say "amount: $_grades";
    say "completed";
}

sub init
{
    classes_init($_classes);
    students_init($_students);
    subjects_init($_subjects);
    grades_init($_grades);
}

sub get_best_student_by_class_name
{
    my ($connection, $class_name) = @_;
    my $resultset = $connection->search(
        {
            'class.name' => $class_name,
        },
        {
            join => 'class'
        }
    );
    my $best = undef;
    while (my $student = $resultset->next)
    {
        if (!(defined $best) or ($student->gpa() > $best->gpa()))
        {
            $best = $student;
        }
    }
    return $best;
}

sub change_grades_from_to
{
    my ($student, $from, $to) = @_;
    for my $grade ($student->grades)
    {
        if ($grade->grade == $from)
        {
            $grade->update({grade => $to});
        }
    }
}

sub delete_grades_by_value
{
    my ($student, $value) = @_;
    for my $grade ($student->grades)
    {
        if ($grade->grade == $value)
        {
            $grade->delete();
        }
    }
}

if ($INIT)
{
    # 7.
    init();
}
else
{
    # 3. 5.
    # say get_best_student_by_class_name($_students, '310')->name();


    # 6. 4.
    # my $good = $_classes->search_best_student();
    # say $good->name(), ' ', $good->gpa(), ' ', $good->class->name;


    # 8.
    # my $student = get_best_student_by_class_name($_students, '103');
    # say $student->name;
    # my %grades = $student->grades_count();
    # for my $i (1 .. 5)
    # {
    #     say $i, ' ', $grades{$i};
    # }
    # say;
    # change_grades_from_to($student, 5, 2);
    # %grades = $student->grades_count();
    # for my $i (1 .. 5)
    # {
    #     say $i, ' ', $grades{$i};
    # }


    # 9.
    # my $student = get_best_student_by_class_name($_students, '103');
    # say $student->name;
    # my %grades = $student->grades_count();
    # for my $i (1 .. 5)
    # {
    #     say $i, ' ', $grades{$i};
    # }
    # say;
    # delete_grades_by_value($student, 5);
    # %grades = $student->grades_count();
    # for my $i (1 .. 5)
    # {
    #     say $i, ' ', $grades{$i};
    # }
}
