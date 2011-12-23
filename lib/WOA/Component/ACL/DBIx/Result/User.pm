package WOA::Component::ACL::DBIx::Result::User;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

AclManager::Model::DBIx::Result::User

=cut

__PACKAGE__->table("users");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 login

  data_type: 'varchar'
  is_nullable: 0
  size: 50

=head2 password

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 email

  data_type: 'varchar'
  is_nullable: 0
  size: 40

=head2 created

  data_type: 'bigint'
  is_nullable: 0

=head2 updated

  data_type: 'bigint'
  is_nullable: 0

=head2 fio

  data_type: 'varchar'
  is_nullable: 0
  size: 125

=head2 sessionid

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 actions

  data_type: 'text'
  is_nullable: 1

=head2 appid

  data_type: 'bigint'
  is_nullable: 0

=head2 roles

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "login",
  { data_type => "varchar", is_nullable => 0, size => 50 },
  "password",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "email",
  { data_type => "varchar", is_nullable => 0, size => 40 },
  "created",
  { data_type => "bigint", is_nullable => 0 },
  "updated",
  { data_type => "bigint", is_nullable => 0 },
  "fio",
  { data_type => "varchar", is_nullable => 0, size => 125 },
  "sessionid",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "actions",
  { data_type => "text", is_nullable => 1 },
  "appid",
  { data_type => "bigint", is_nullable => 0 },
  "roles",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-09-26 20:47:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:/Tw0n0ttH8goOiodS2cS2Q


# You can replace this text with custom content, and it will be preserved on regeneration

__PACKAGE__->has_many(
    "ua",
    "WOA::Component::ACL::DBIx::Result::UserApplication",
    { "foreign.user_id" => "self.id" },
);

1;
