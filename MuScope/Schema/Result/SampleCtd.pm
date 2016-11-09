use utf8;
package MuScope::Schema::Result::SampleCtd;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::SampleCtd

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_ctd>

=cut

__PACKAGE__->table("sample_ctd");

=head1 ACCESSORS

=head2 sample_ctd_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 sample_id

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

  data_type: 'decimal'
  is_nullable: 0
  size: [10,4]

=cut

__PACKAGE__->add_columns(
  "sample_ctd_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "sample_id",
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
  { data_type => "decimal", is_nullable => 0, size => [10, 4] },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_ctd_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_ctd_id");

=head1 RELATIONS

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

=head2 sample

Type: belongs_to

Related object: L<MuScope::Schema::Result::Sample>

=cut

__PACKAGE__->belongs_to(
  "sample",
  "MuScope::Schema::Result::Sample",
  { sample_id => "sample_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-09 14:55:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:zGtUcIOhLEUG2n1qism+WQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
