use utf8;
package MuScope::Schema::Result::SampleAttrTypeCategory;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

MuScope::Schema::Result::SampleAttrTypeCategory

=cut

use strict;
use warnings;

use Moose;
use MooseX::NonMoose;
use MooseX::MarkAsMethods autoclean => 1;
extends 'DBIx::Class::Core';

=head1 TABLE: C<sample_attr_type_category>

=cut

__PACKAGE__->table("sample_attr_type_category");

=head1 ACCESSORS

=head2 sample_attr_type_category_id

  data_type: 'integer'
  extra: {unsigned => 1}
  is_auto_increment: 1
  is_nullable: 0

=head2 category

  data_type: 'varchar'
  is_nullable: 0
  size: 100

=cut

__PACKAGE__->add_columns(
  "sample_attr_type_category_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "category",
  { data_type => "varchar", is_nullable => 0, size => 100 },
);

=head1 PRIMARY KEY

=over 4

=item * L</sample_attr_type_category_id>

=back

=cut

__PACKAGE__->set_primary_key("sample_attr_type_category_id");

=head1 UNIQUE CONSTRAINTS

=head2 C<category>

=over 4

=item * L</category>

=back

=cut

__PACKAGE__->add_unique_constraint("category", ["category"]);

=head1 RELATIONS

=head2 sample_attr_types

Type: has_many

Related object: L<MuScope::Schema::Result::SampleAttrType>

=cut

__PACKAGE__->has_many(
  "sample_attr_types",
  "MuScope::Schema::Result::SampleAttrType",
  {
    "foreign.sample_attr_type_category_id" => "self.sample_attr_type_category_id",
  },
  { cascade_copy => 0, cascade_delete => 0 },
);


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2017-04-03 09:49:47
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:ZVOQuxxcgVnSF2PAWasQYQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
