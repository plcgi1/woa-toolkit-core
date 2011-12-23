package WOA::Component::ACL::DBIx::Result::UserApplication;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

use strict;
use warnings;

use base 'DBIx::Class::Core';


=head1 NAME

AclManager::Model::DBIx::Result::UserApplication

=cut

__PACKAGE__->table("user_application");

=head1 ACCESSORS

=head2 id

  data_type: 'bigint'
  is_auto_increment: 1
  is_nullable: 0

=head2 user_id

  data_type: 'bigint'
  is_nullable: 0

=head2 appid

  data_type: 'bigint'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "id",
  { data_type => "bigint", is_auto_increment => 1, is_nullable => 0 },
  "user_id",
  { data_type => "bigint", is_nullable => 0 },
  "appid",
  { data_type => "bigint", is_nullable => 0 },
);
__PACKAGE__->set_primary_key("id");


# Created by DBIx::Class::Schema::Loader v0.07002 @ 2011-09-26 21:03:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:6U9FOShAAZLbAdDJvOXgBg


# You can replace this text with custom content, and it will be preserved on regeneration

__PACKAGE__->belongs_to("users", "WOA::Component::ACL::DBIx::Result::User", { id => "user_id" });
__PACKAGE__->belongs_to("app", "WOA::Component::ACL::DBIx::Result::Application", { id => "appid" });
1;
