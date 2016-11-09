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

=head2 investigator_name

  data_type: 'varchar'
  is_nullable: 1
  size: 50

=head2 institution

  data_type: 'varchar'
  is_nullable: 1
  size: 255

=cut

__PACKAGE__->add_columns(
  "investigator_id",
  {
    data_type => "integer",
    extra => { unsigned => 1 },
    is_auto_increment => 1,
    is_nullable => 0,
  },
  "investigator_name",
  { data_type => "varchar", is_nullable => 1, size => 50 },
  "institution",
  { data_type => "varchar", is_nullable => 1, size => 255 },
);

=head1 PRIMARY KEY

=over 4

=item * L</investigator_id>

=back

=cut

__PACKAGE__->set_primary_key("investigator_id");

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


# Created by DBIx::Class::Schema::Loader v0.07042 @ 2016-11-02 10:50:32
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:b3hvTxaRst4XPW1mWe4PLw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
__PACKAGE__->meta->make_immutable;
1;
