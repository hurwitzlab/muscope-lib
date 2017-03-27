use utf8;
package MuScope::Schema::Result::Sample;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::Sample

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample>

=cut

__PACKAGE__->table("sample");

=head1 ACCESSORS

=head2 sample_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cast_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 investigator_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 filter_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 sample_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 sequencing_method_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 library_kit_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 seq_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 depth

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 filter_min

  data_type: 'decimal'
  is_nullable: 1
  size: [10,4]

=cut

__PACKAGE__->add_columns(
  "sample_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cast_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "investigator_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "filter_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "sample_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "sequencing_method_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "library_kit_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "sample_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "seq_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "depth",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "filter_min",
  { data_type => "decimal", is_nullable => 1, size => [10, 4] },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_id");

=head1 RELATIONS

=head2 cast

Type: belongs_to

Related object: L<MuScope::Schema::Result::Cast>

=cut

__PACKAGE__->belongs_to(
  "cast",
  "MuScope::Schema::Result::Cast",
  { cast_id => "cast_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 filter_type

Type: belongs_to

Related object: L<MuScope::Schema::Result::FilterType>

=cut

__PACKAGE__->belongs_to(
  "filter_type",
  "MuScope::Schema::Result::FilterType",
  { filter_type_id => "filter_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 investigator

Type: belongs_to

Related object: L<MuScope::Schema::Result::Investigator>

=cut

__PACKAGE__->belongs_to(
  "investigator",
  "MuScope::Schema::Result::Investigator",
  { investigator_id => "investigator_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 library_kit

Type: belongs_to

Related object: L<MuScope::Schema::Result::LibraryKit>

=cut

__PACKAGE__->belongs_to(
  "library_kit",
  "MuScope::Schema::Result::LibraryKit",
  { library_kit_id => "library_kit_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 sample_ctds

Type: has_many

Related object: L<MuScope::Schema::Result::SampleCtd>

=cut

__PACKAGE__->has_many(
  "sample_ctds",
  "MuScope::Schema::Result::SampleCtd",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_files

Type: has_many

Related object: L<MuScope::Schema::Result::SampleFile>

=cut

__PACKAGE__->has_many(
  "sample_files",
  "MuScope::Schema::Result::SampleFile",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 sample_type

Type: belongs_to

Related object: L<MuScope::Schema::Result::SampleType>

=cut

__PACKAGE__->belongs_to(
  "sample_type",
  "MuScope::Schema::Result::SampleType",
  { sample_type_id => "sample_type_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);

=head2 sequencing_method

Type: belongs_to

Related object: L<MuScope::Schema::Result::SequencingMethod>

=cut

__PACKAGE__->belongs_to(
  "sequencing_method",
  "MuScope::Schema::Result::SequencingMethod",
  { sequencing_method_id => "sequencing_method_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-03-07 15:29:37
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:EjpkTlhwo0TTOOly7e5s0Q


# You can replace this text with custom code or comments, and it will be preserved on regeneration

sub cruise {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    my ($cruise_id) = $dbh->selectrow_array(
        q[
            select st.cruise_id
            from   sample s, cast c, station st
            where  s.sample_id=?
            and    s.cast_id=c.cast_id
            and    c.station_id=st.station_id
        ],
        {},
        ($self->id)
    );

    my $schema  = $self->result_source->storage->schema;
    return $schema->resultset('Cruise')->find($cruise_id);
}

__PACKAGE__->meta->make_immutable;

1;
