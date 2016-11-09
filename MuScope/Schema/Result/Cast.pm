use utf8;
package MuScope::Schema::Result::Cast;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::Cast

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<cast>

=cut

__PACKAGE__->table("cast");

=head1 ACCESSORS

=head2 cast_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 station_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_foreign_key: 1
  is_nullable: 1

=head2 cast_number

  data_type: 'integer'
  extra: {unsigned => 1}
  is_nullable: 1

=head2 collection_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 collection_time

  data_type: 'time'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cast_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "station_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_foreign_key => 1,
    is_nullable => 1,
  },
  "cast_number",
  { data_type => "integer", extra => { unsigned => 1 }, is_nullable => 1 },
  "collection_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "collection_time",
  { data_type => "time", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cast_id>

=back

=cut

__PACKAGE__->set_primary_key("cast_id");

=head1 RELATIONS

=head2 samples

Type: has_many

Related object: L<MuScope::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "MuScope::Schema::Result::Sample",
  { "foreign.cast_id" => "self.cast_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 station

Type: belongs_to

Related object: L<MuScope::Schema::Result::Station>

=cut

__PACKAGE__->belongs_to(
  "station",
  "MuScope::Schema::Result::Station",
  { station_id => "station_id" },
  {
    is_deferrable => 1,
    join_type     => "LEFT",
    on_delete     => "CASCADE",
    on_update     => "RESTRICT",
  },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-04 14:20:50
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dPN/g4haW0xwUwc71TmNfQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
