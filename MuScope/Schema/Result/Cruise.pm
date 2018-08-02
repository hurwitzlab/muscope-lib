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

=head2 website

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 100

=head2 deployment

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 100

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
  "website",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 100 },
  "deployment",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 100 },
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

=head2 samples

Type: has_many

Related object: L<MuScope::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "MuScope::Schema::Result::Sample",
  { "foreign.cruise_id" => "self.cruise_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2018-05-15 10:20:31
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:qMIrcWdm3gf5hbfMXlONTQ

# --------------------------------------------------
sub investigators {
    my $self = shift;
    my $dbh  = $self->result_source->storage->dbh;
    $dbh->selectall_arrayref(
        q[
            select distinct i.investigator_id, i.first_name, i.last_name
            from   investigator i, sample_to_investigator s2i, sample s
            where  i.investigator_id=s2i.investigator_id
            and    s2i.sample_id=s.sample_id
            and    s.cruise_id=?
        ],
        { Columns => {} },
        $self->id
    );
}

__PACKAGE__->meta->make_immutable;
1;
