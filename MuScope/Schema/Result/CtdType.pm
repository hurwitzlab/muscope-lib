use utf8;
package MuScope::Schema::Result::CtdType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::CtdType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<ctd_type>

=cut

__PACKAGE__->table("ctd_type");

=head1 ACCESSORS

=head2 ctd_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 ctd_type

  data_type: 'varchar'
  is_nullable: 1
  size: 100

=head2 unit

  data_type: 'varchar'
  is_nullable: 1
  size: 20

=cut

__PACKAGE__->add_columns(
  "ctd_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "ctd_type",
  { data_type => "varchar", is_nullable => 1, size => 100 },
  "unit",
  { data_type => "varchar", is_nullable => 1, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</ctd_type_id>

=back

=cut

__PACKAGE__->set_primary_key("ctd_type_id");

=head1 RELATIONS

=head2 cruise_core_ctds

Type: has_many

Related object: L<MuScope::Schema::Result::CruiseCoreCtd>

=cut

__PACKAGE__->has_many(
  "cruise_core_ctds",
  "MuScope::Schema::Result::CruiseCoreCtd",
  { "foreign.ctd_type_id" => "self.ctd_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_ctds

Type: has_many

Related object: L<MuScope::Schema::Result::SampleCtd>

=cut

__PACKAGE__->has_many(
  "sample_ctds",
  "MuScope::Schema::Result::SampleCtd",
  { "foreign.ctd_type_id" => "self.ctd_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-02 12:23:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:+nesdL5cq86NWRoSJkS9mA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
