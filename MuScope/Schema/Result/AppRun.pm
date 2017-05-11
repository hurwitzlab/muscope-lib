use utf8;
package MuScope::Schema::Result::AppRun;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::AppRun

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<app_run>

=cut

__PACKAGE__->table("app_run");

=head1 ACCESSORS

=head2 app_run_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 app_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 user_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 app_ran_at

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 params

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "app_run_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "app_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "user_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 0,
  },
  "app_ran_at",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "params",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</app_run_id>

=back

=cut

__PACKAGE__->set_primary_key("app_run_id");

=head1 RELATIONS

=head2 app

Type: belongs_to

Related object: L<MuScope::Schema::Result::App>

=cut

__PACKAGE__->belongs_to(
  "app",
  "MuScope::Schema::Result::App",
  { app_id => "app_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);

=head2 user

Type: belongs_to

Related object: L<MuScope::Schema::Result::User>

=cut

__PACKAGE__->belongs_to(
  "user",
  "MuScope::Schema::Result::User",
  { user_id => "user_id" },
  { is_deferrable => 1, on_delete => "RESTRICT", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-05-01 14:30:21
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:BtlPlbEccmqZtQ1cVW/r/Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
