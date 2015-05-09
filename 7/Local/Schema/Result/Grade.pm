use utf8::all;
package Local::Schema::Result::Grade;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::Grade

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<grade>

=cut

__PACKAGE__->table("grade");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 grade

  data_type: 'integer'
  is_nullable: 0

=head2 time

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 0

=head2 student_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=head2 subject_id

  data_type: 'integer'
  is_foreign_key: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "grade",
  { data_type => "integer", is_nullable => 0 },
  "time",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 0,
  },
  "student_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
  "subject_id",
  { data_type => "integer", is_foreign_key => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 student

Type: belongs_to

Related object: L<Local::Schema::Result::Student>

=cut

__PACKAGE__->belongs_to(
  "student",
  "Local::Schema::Result::Student",
  { id => "student_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);

=head2 subject

Type: belongs_to

Related object: L<Local::Schema::Result::Subject>

=cut

__PACKAGE__->belongs_to(
  "subject",
  "Local::Schema::Result::Subject",
  { id => "subject_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "RESTRICT",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-09 00:52:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6+hemjxHhr3Rc89IH928Kw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
