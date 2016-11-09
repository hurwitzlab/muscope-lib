use utf8;
package MuScope::Schema::Result::FilterType;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::FilterType

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<filter_type>

=cut

__PACKAGE__->table("filter_type");

=head1 ACCESSORS

=head2 filter_type_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 filter_type

  data_type: 'varchar'
  default_value: (empty string)
  is_nullable: 1
  size: 50

=cut

__PACKAGE__->add_columns(
  "filter_type_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "filter_type",
  { data_type => "varchar", default_value => "", is_nullable => 1, size => 50 },
);

=head1 PRIMARY KEY

=over 4

=item * L</filter_type_id>

=back

=cut

__PACKAGE__->set_primary_key("filter_type_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<filter_type>

=over 4

=item * L</filter_type>

=back

=cut

__PACKAGE__->add_unique_constraint("filter_type", ["filter_type"]);

=head1 RELATIONS

=head2 samples

Type: has_many

Related object: L<MuScope::Schema::Result::Sample>

=cut

__PACKAGE__->has_many(
  "samples",
  "MuScope::Schema::Result::Sample",
  { "foreign.filter_type_id" => "self.filter_type_id" },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-04 13:44:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:F3hwTV4F/EXa80qNWfD6Ow


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
