use utf8::all;
use feature 'say';
package Local::Schema::Result::Student;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::Student

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 TABLE: C<student>

=cut

__PACKAGE__->table("student");

=head1 ACCESSORS

=head2 id

    data_type: 'integer'
    is_auto_increment: 1
    is_nullable: 0

=head2 name

    data_type: 'varchar'
    default_value: 'NULL'
    is_nullable: 0
    size: 256

=head2 class_id

    data_type: 'integer'
    is_foreign_key: 1
    is_nullable: 1

=cut

__PACKAGE__->add_columns(
    "id",
    { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
    "name",
    {
        data_type => "varchar",
        default_value => "NULL",
        is_nullable => 0,
        size => 256,
    },
    "class_id",
    { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 class

Type: belongs_to

Related object: L<Local::Schema::Result::Class>

=cut

__PACKAGE__->belongs_to(
    "class",
    "Local::Schema::Result::Class",
    { id => "class_id" },
    {
        is_deferrable => 1,
        join_type         => "LEFT",
        on_delete         => "RESTRICT",
        on_update         => "RESTRICT",
    },
);

=head2 grades

Type: has_many

Related object: L<Local::Schema::Result::Grade>

=cut

__PACKAGE__->has_many(
    "grades",
    "Local::Schema::Result::Grade",
    { "foreign.student_id" => "self.id" },
    { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-09 00:52:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F/olK9BAEEk1VX8Ht5Uhew

sub grades_count
{
    my ($self) = shift;
    my $grades = $self->grades();
    my %result = (
        1 => 0,
        2 => 0,
        3 => 0,
        4 => 0,
        5 => 0
    );
    while (my $grade = $grades->next())
    {
        $result{$grade->grade()} += 1;
    }
    return %result;
}

sub gpa
{
    my ($self) = shift;
    my %grades = $self->grades_count();
    my $count = 0;
    my $sum = 0;
    for my $i (1 .. 5)
    {
        $sum += $grades{$i} * $i;
        $count += $grades{$i};
    }
    return 0 if ($count == 0);
    return $sum / $count;

}

# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
