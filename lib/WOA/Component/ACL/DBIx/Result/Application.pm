package WOA::Component::ACL::DBIx::Result::Application;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

AclManager::Model::DBIx::Result::Application

=cut

__PACKAGE__->table("application");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'bigint'
  is_nullable: 0

=head2 created

  data_type: 'bigint'
  is_nullable: 0

=head2 updated

  data_type: 'bigint'
  is_nullable: 0

=head2 name

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=head2 token

  data_type: 'varchar'
  is_nullable: 0
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "bigint", is_nullable => 0 },
  "created",
  { data_type => "bigint", is_nullable => 0 },
  "updated",
  { data_type => "bigint", is_nullable => 0 },
  "name",
  { data_type => "varchar", is_nullable => 0, size => 255 },
  "token",
  { data_type => "varchar", is_nullable => 0, size => 255 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-09-26 20:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:r0NN3CRvjdQ9jVbVebCSBw


# You can replace this text with custom content, and it will be preserved on regeneration
1;
