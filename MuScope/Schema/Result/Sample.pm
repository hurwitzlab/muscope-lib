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

=head2 cruise_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 sample_name

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 station_number

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 cast_number

  data_type: 'integer'
  default_value: 0
  extra: {unsigned => 1}
  is_nullable: 0

=head2 latitude_start

  data_type: 'float'
  is_nullable: 1

=head2 latitude_stop

  data_type: 'float'
  is_nullable: 1

=head2 longitude_start

  data_type: 'float'
  is_nullable: 1

=head2 longitude_stop

  data_type: 'float'
  is_nullable: 1

=head2 depth

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 collection_start

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 collection_stop

  data_type: 'datetime'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 collection_time_zone

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 0
  size: 20

=cut

__PACKAGE__->add_columns(
  "sample_id",
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
  "sample_name",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "station_number",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "cast_number",
  {
    data_type => "integer",
    default_value => 0,
    extra => { unsigned => 1 },
    is_nullable => 0,
  },
  "latitude_start",
  { data_type => "float", is_nullable => 1 },
  "latitude_stop",
  { data_type => "float", is_nullable => 1 },
  "longitude_start",
  { data_type => "float", is_nullable => 1 },
  "longitude_stop",
  { data_type => "float", is_nullable => 1 },
  "depth",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "collection_start",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "collection_stop",
  {
    data_type => "datetime",
    datetime_undef_if_invalid => 1,
    is_nullable => 1,
  },
  "collection_time_zone",
  { data_type => "varchar", default_value => "", is_nullable => 0, size => 20 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<cruise_id>

=over 4

=item * L</cruise_id>

=item * L</sample_name>

=back

=cut

__PACKAGE__->add_unique_constraint("cruise_id", ["cruise_id", "sample_name"]);

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

=head2 sample_attrs

Type: has_many

Related object: L<MuScope::Schema::Result::SampleAttr>

=cut

__PACKAGE__->has_many(
  "sample_attrs",
  "MuScope::Schema::Result::SampleAttr",
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

=head2 sample_to_investigators

Type: has_many

Related object: L<MuScope::Schema::Result::SampleToInvestigator>

=cut

__PACKAGE__->has_many(
  "sample_to_investigators",
  "MuScope::Schema::Result::SampleToInvestigator",
  { "foreign.sample_id" => "self.sample_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-11-28 15:05:59
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:DYCuK7O4oQVCn78vv9fMpg


# You can replace this text with custom code or comments, and it will be preserved on regeneration

# --------------------------------------------------
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

# --------------------------------------------------
sub depth {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    my ($depth, $unit) = $dbh->selectrow_array(
        q[
            select a.value, t.unit
            from   sample_attr a, sample_attr_type t
            where  a.sample_id=?
            and    a.sample_attr_type_id=t.sample_attr_type_id
            and    t.type=?
        ],
        {},
        ($self->id, 'depth')
    );

    return $depth ? "$depth $unit" : '';
}

# --------------------------------------------------
sub type {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    my ($depth, $unit) = $dbh->selectrow_array(
        q[
            select a.value, t.unit
            from   sample_attr a, sample_attr_type t
            where  a.sample_id=?
            and    a.sample_attr_type_id=t.sample_attr_type_id
            and    t.type=?
        ],
        {},
        ($self->id, 'sequence_type')
    );

    return $depth ? "$depth $unit" : '';
}

__PACKAGE__->meta->make_immutable;

1;
