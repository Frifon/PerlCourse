use utf8::all;
package Local::Schema::Result::Subject;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::Subject

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<subject>

=cut

__PACKAGE__->table("subject");

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
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");

=head1 RELATIONS

=head2 grades

Type: has_many

Related object: L<Local::Schema::Result::Grade>

=cut

__PACKAGE__->has_many(
  "grades",
  "Local::Schema::Result::Grade",
  { "foreign.subject_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-09 00:52:44
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:isih+6JLjkkLs7Y+hUakvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;