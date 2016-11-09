use utf8;
package MuScope::Schema::Result::CruiseCoreCtd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::CruiseCoreCtd

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<cruise_core_ctd>

=cut

__PACKAGE__->table("cruise_core_ctd");

=head1 ACCESSORS

=head2 cruise_core_ctd_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cruise_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 ctd_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 ctd_value

  data_type: 'float'
  is_nullable: 0

=cut

__PACKAGE__->add_columns(
  "cruise_core_ctd_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cruise_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "ctd_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "ctd_value",
  { data_type => "float", is_nullable => 0 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cruise_core_ctd_id>

=back

=cut

__PACKAGE__->set_primary_key("cruise_core_ctd_id");

=head1 RELATIONS

=head2 cruise

Type: belongs_to

Related object: L<MuScope::Schema::Result::Cruise>

=cut

__PACKAGE__->belongs_to(
  "cruise",
  "MuScope::Schema::Result::Cruise",
  { cruise_id => "cruise_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 ctd_type

Type: belongs_to

Related object: L<MuScope::Schema::Result::CtdType>

=cut

__PACKAGE__->belongs_to(
  "ctd_type",
  "MuScope::Schema::Result::CtdType",
  { ctd_type_id => "ctd_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-02 10:50:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZJSF/FyuMeo+wgj/wAXfOg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
