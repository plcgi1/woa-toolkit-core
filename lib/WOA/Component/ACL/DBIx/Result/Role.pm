package WOA::Component::ACL::DBIx::Result::Role;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

AclManager::Model::DBIx::Result::Role

=cut

__PACKAGE__->table("role");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 description

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 actions

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 created

  data_type: 'bigint'
  is_nullable: 0

=head2 updated

  data_type: 'bigint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "description",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "actions",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "created",
  { data_type => "bigint", is_nullable => 0 },
  "updated",
  { data_type => "bigint", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");
__PACKAGE__->add_unique_constraint("role_name_idx", ["name"]);


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-09-26 20:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:S6VqLrt4vyqGIC/IJx8nRQ


# You can replace this text with custom content, and it will be preserved on regeneration
1;
