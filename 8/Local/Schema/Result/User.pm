use utf8;
package Local::Schema::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Local::Schema::Result::User

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<user>

=cut

__PACKAGE__->table("user");

=head1 ACCESSORS

=head2 id

  data_type: 'integer'
  is_auto_increment: 1
  is_nullable: 0

=head2 login

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 password

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 avatar

  data_type: 'varchar'
  is_nullable: 1
  size: 256

=head2 reg_time

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "integer", is_auto_increment => 1, is_nullable => 0 },
  "login",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "password",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "avatar",
  { data_type => "varchar", is_nullable => 1, size => 256 },
  "reg_time",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
    set_on_create => 1,
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</id>

=back

=cut

__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2015-05-09 18:19:51
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:3crZRTWwCKjfEXpUrSx1ew


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
