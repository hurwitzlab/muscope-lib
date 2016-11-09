use utf8;
package MuScope::Schema::Result::Station;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::Station

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<station>

=cut

__PACKAGE__->table("station");

=head1 ACCESSORS

=head2 station_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cruise_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 0

=head2 station_number

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 latitude

  data_type: 'float'
  is_nullable: 1

=head2 longitude

  data_type: 'float'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "station_id",
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
    is_nullable => 0,
  },
  "station_number",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "latitude",
  { data_type => "float", is_nullable => 1 },
  "longitude",
  { data_type => "float", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</station_id>

=back

=cut

__PACKAGE__->set_primary_key("station_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<cruise_id>

=over 4

=item * L</cruise_id>

=item * L</station_number>

=back

=cut

__PACKAGE__->add_unique_constraint("cruise_id", ["cruise_id", "station_number"]);

=head1 RELATIONS

=head2 casts

Type: has_many

Related object: L<MuScope::Schema::Result::Cast>

=cut

__PACKAGE__->has_many(
  "casts",
  "MuScope::Schema::Result::Cast",
  { "foreign.station_id" => "self.station_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 cruise

Type: belongs_to

Related object: L<MuScope::Schema::Result::Cruise>

=cut

__PACKAGE__->belongs_to(
  "cruise",
  "MuScope::Schema::Result::Cruise",
  { cruise_id => "cruise_id" },
  { is_deferrable => 1, on_delete => "CASCADE", on_update => "RESTRICT" },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-02 10:50:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:PcvKk3/aPWb+Hp7+5b4NTA

sub num_samples {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    return $dbh->selectrow_array(
        q[
            select count(s.sample_id)
            from   sample s, cast c
            where  c.station_id=?
            and    c.cast_id=s.cast_id
        ],
        { Columns => {} },
        $self->id
    );
}

sub samples {
    my $self       = shift;
    my $dbh        = $self->result_source->storage->dbh;
    my $sample_ids = $dbh->selectcol_arrayref(
        q[
            select s.sample_id
            from   sample s, cast c
            where  c.station_id=?
            and    c.cast_id=s.cast_id
            order by s.sample_name
        ],
        {},
        $self->id
    );

    my $schema  = $self->result_source->storage->schema;
    return map { $schema->resultset('Sample')->find($_) } @$sample_ids;
}
__PACKAGE__->meta->make_immutable;
1;
