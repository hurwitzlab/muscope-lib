use utf8;
package MuScope::Schema::Result::Cruise;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::Cruise

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<cruise>

=cut

__PACKAGE__->table("cruise");

=head1 ACCESSORS

=head2 cruise_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 cruise_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 start_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=head2 end_date

  data_type: 'date'
  datetime_undef_if_invalid: 1
  is_nullable: 1

=cut

__PACKAGE__->add_columns(
  "cruise_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "cruise_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "start_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
  "end_date",
  { data_type => "date", datetime_undef_if_invalid => 1, is_nullable => 1 },
);

=head1 PRIMARY KEY

=over 4

=item * L</cruise_id>

=back

=cut

__PACKAGE__->set_primary_key("cruise_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<cruise_name_2>

=over 4

=item * L</cruise_name>

=back

=cut

__PACKAGE__->add_unique_constraint("cruise_name_2", ["cruise_name"]);

=head1 RELATIONS

=head2 cruise_core_ctds

Type: has_many

Related object: L<MuScope::Schema::Result::CruiseCoreCtd>

=cut

__PACKAGE__->has_many(
  "cruise_core_ctds",
  "MuScope::Schema::Result::CruiseCoreCtd",
  { "foreign.cruise_id" => "self.cruise_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);

=head2 stations

Type: has_many

Related object: L<MuScope::Schema::Result::Station>

=cut

__PACKAGE__->has_many(
  "stations",
  "MuScope::Schema::Result::Station",
  { "foreign.cruise_id" => "self.cruise_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-04-06 13:48:57
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:XmvAQY3CggFiZF5hrQ4Z6g

# --------------------------------------------------
sub investigators {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    $dbh->selectall_arrayref(
        q[
            select distinct i.investigator_id, i.first_name, i.last_name
            from   investigator i, sample s, cast c, station st
            where  st.cruise_id=?
            and    st.station_id=c.station_id
            and    c.cast_id=s.cast_id
            and    s.investigator_id=i.investigator_id
        ],
        { Columns => {} },
        $self->id
    );
}

# --------------------------------------------------
sub cast_ids {
    my $self     = shift;
    my $dbh      = $self->result_source->storage->dbh;
    return @{ $dbh->selectcol_arrayref(
        q[
            select c.cast_id
            from   cast c, station s
            where  s.cruise_id=?
            and    s.station_id=c.station_id
        ],
        {},
        $self->id
    ) };
}

# --------------------------------------------------
sub num_casts {
    my $self   = shift;
    return scalar $self->cast_ids;
}

# --------------------------------------------------
sub casts {
    my $self   = shift;
    my $schema = $self->result_source->storage->schema;
    return map { $schema->resultset('Cast')->find($_) } $self->cast_ids;
}

# --------------------------------------------------
sub num_samples {
    my $self = shift;
    return scalar $self->sample_ids;
}

# --------------------------------------------------
sub sample_ids {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;

    return @{ $dbh->selectcol_arrayref(
        q[
            select s.sample_id
            from   sample s, cast c, station st
            where  st.cruise_id=?
            and    st.station_id=c.station_id
            and    c.cast_id=s.cast_id
            order by s.sample_name
        ],
        {},
        $self->id
    ) };
}

# --------------------------------------------------
sub samples {
    my $self   = shift;
    my $schema = $self->result_source->storage->schema;
    return map { $schema->resultset('Sample')->find($_) } $self->sample_ids;
}

__PACKAGE__->meta->make_immutable;
1;
