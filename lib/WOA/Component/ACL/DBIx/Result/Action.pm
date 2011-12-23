package WOA::Component::ACL::DBIx::Result::Action;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

AclManager::Model::DBIx::Result::Action

=cut

__PACKAGE__->table("action");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 125

=head2 path

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 method_type

  data_type: 'varchar'
  is_nullable: 1
  size: 60

=head2 created

  data_type: 'bigint'
  is_nullable: 0

=head2 updated

  data_type: 'bigint'
  is_nullable: 0

=head2 type

  data_type: 'varchar'
  is_nullable: 0
  size: 10

=head2 appid

  data_type: 'bigint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 125 },
  "path",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "method_type",
  { data_type => "varchar", is_nullable => 1, size => 60 },
  "created",
  { data_type => "bigint", is_nullable => 0 },
  "updated",
  { data_type => "bigint", is_nullable => 0 },
  "type",
  { data_type => "varchar", is_nullable => 0, size => 10 },
  "appid",
  { data_type => "bigint", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("action_name_idx", ["name"]);

=head1 RELATIONS

=head2 navigations

Type: has_many

Related object: L<AclManager::Model::DBIx::Result::Navigation>

=cut

__PACKAGE__->has_many(
  "navigations",
  "WOA::Component::ACL::DBIx::Result::Navigation",
  { "foreign.action_id" => "self.id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-09-26 20:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m4raNYkfHaSxECeMr5nmpw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
