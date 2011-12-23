package WOA::Component::ACL::DBIx::Result::Navigation;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

AclManager::Model::DBIx::Result::Navigation

=cut

__PACKAGE__->table("navigation");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 30

=head2 parent

  data_type: 'varchar'
  is_nullable: 1
  size: 30

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 125

=head2 print_name

  data_type: 'varchar'
  is_nullable: 0
  size: 125

=head2 created

  data_type: 'bigint'
  is_nullable: 0

=head2 updated

  data_type: 'bigint'
  is_nullable: 0

=head2 action_id

  data_type: 'bigint'
  is_foreign_key: 1
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 30 },
  "parent",
  { data_type => "varchar", is_nullable => 1, size => 30 },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 125 },
  "print_name",
  { data_type => "varchar", is_nullable => 0, size => 125 },
  "created",
  { data_type => "bigint", is_nullable => 0 },
  "updated",
  { data_type => "bigint", is_nullable => 0 },
  "action_id",
  { data_type => "bigint", is_foreign_key => 1, is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("nav_name_idx", ["name"]);

=head1 RELATIONS

=head2 action

Type: belongs_to

Related object: L<AclManager::Model::DBIx::Result::Action>

=cut

__PACKAGE__->belongs_to(
  "action",
  "AclManager::Model::DBIx::Result::Action",
  { id => "action_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "CASCADE" },
);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-09-26 20:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:MmwnmF2LwEMDr8a2bxlWjw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
