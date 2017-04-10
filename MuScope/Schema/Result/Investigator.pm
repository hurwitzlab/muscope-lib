use utf8;
package MuScope::Schema::Result::Investigator;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::Investigator

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<investigator>

=cut

__PACKAGE__->table("investigator");

=head1 ACCESSORS

=head2 investigator_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 first_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 last_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 institution

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 website

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=head2 project

  data_type: 'text'
  is_nullable: 1

=head2 bio

  data_type: 'text'
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "investigator_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "first_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "last_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "institution",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "website",
  { data_type => "varchar", is_nullable => 1, size => 255 },
  "project",
  { data_type => "text", is_nullable => 1 },
  "bio",
  { data_type => "text", is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</investigator_id>

=back

=cut

__PACKAGE__->set_primary_key("investigator_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<first_name>

=over 4

=item * L</first_name>

=item * L</last_name>

=back

=cut

__PACKAGE__->add_unique_constraint("first_name", ["first_name", "last_name"]);

=head1 RELATIONS

=head2 samples

Type: has_many

Related object: L<MuScope::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "MuScope::Schema::Result::Sample",
  { "foreign.investigator_id" => "self.investigator_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-04-06 13:48:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dqLquh+pGucDmPZaSkAB3w

# --------------------------------------------------
sub cruise_ids {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    return @{ $dbh->selectcol_arrayref(
        q[
            select distinct st.cruise_id
            from   sample s, cast c, station st
            where  s.investigator_id=?
            and    s.cast_id=c.cast_id
            and    c.station_id=st.station_id
        ],
        {},
        $self->id
    ) };
}

# --------------------------------------------------
sub cruises {
    my $self   = shift;
    my $schema = $self->result_source->storage->schema;
    return map { $schema->resultset('Cruise')->find($_) } $self->cruise_ids;
}

# --------------------------------------------------
sub num_cruises {
    my $self = shift;
    return scalar $self->cruise_ids;
}

__PACKAGE__->meta->make_immutable;
1;
