#!/usr/bin/env perl

use strict;
use feature 'say';
use MuScope::DB;

my $schema = MuScope::DB->new->schema;
my $FilterTypeAttrType = $schema->resultset('SampleAttrType')->find_or_create({ 
    type => 'filter_type'
});

my $SampleTypeAttrType = $schema->resultset('SampleAttrType')->find_or_create({ 
    type => 'sample_type'
});

my $LibraryKitAttrType = $schema->resultset('SampleAttrType')->find_or_create({ 
    type => 'library_kit'
});

my $SeqMethodAttrType = $schema->resultset('SampleAttrType')->find_or_create({ 
    type => 'sequencing_method'
});

my $i = 0;
my $Samples = $schema->resultset('Sample')->search;
while (my $Sample = $Samples->next) {
    printf "%5d: %s (%s)\n", ++$i, $Sample->sample_name, $Sample->id; 

    if (my $filter_type = $Sample->filter_type->filter_type) {
        say "\tfilter_type = $filter_type";
        my $Attr = $schema->resultset('SampleAttr')->find_or_create({ 
            sample_attr_type_id => $FilterTypeAttrType->id,
            sample_id           => $Sample->id,
            value               => $filter_type,
        });
    }

    if (my $sample_type = $Sample->sample_type->sample_type) {
        say "\tsample_type = $sample_type";
        my $Attr = $schema->resultset('SampleAttr')->find_or_create({ 
            sample_attr_type_id => $SampleTypeAttrType->id,
            sample_id           => $Sample->id,
            value               => $sample_type,
        });
    }

    if (my $library_kit = $Sample->library_kit->library_kit) {
        say "\tlibrary_kit = $library_kit";
        my $Attr = $schema->resultset('SampleAttr')->find_or_create({ 
            sample_attr_type_id => $LibraryKitAttrType->id,
            sample_id           => $Sample->id,
            value               => $library_kit,
        });
    }

    if (my $seq_method = $Sample->sequencing_method->sequencing_method) {
        say "\tseq_method = $seq_method";
        my $Attr = $schema->resultset('SampleAttr')->find_or_create({ 
            sample_attr_type_id => $SeqMethodAttrType->id,
            sample_id           => $Sample->id,
            value               => $seq_method,
        });
    }
}

say "Done.";
