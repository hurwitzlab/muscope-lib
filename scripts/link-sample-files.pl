#!/usr/bin/env perl

use common::sense;
use autodie;
use File::Basename qw(basename fileparse);
use MuScope::DB;
use Getopt::Long;
use Pod::Usage;
use Readonly;

Readonly my %FILE_TYPE   => (
    'contigs.fastq'      => 'Contigs FASTQ',
    'genes.fna'          => 'Genes FASTA',
    'prodigal.gff'       => 'Genes GFF',
    'proteins.faa'       => 'Proteins FASTA',
    'readpool.fastq'     => 'Raw reads FASTQ',
    'ribosomal_rRNA.fna' => 'Ribosomal rRNA FASTA',
    'ribosomal_rRNA.gff' => 'Ribosomal rRNA GFF',
    'rrna.arc.gff'       => 'rRNA Archaea GFF',
    'rrna.bac.gff'       => 'rRNA Bacteria GFF',
    'rrna.euk.gff'       => 'rRNA Eukaryote GFF',
    'rrna.mito.gff'      => 'rRNA Mitochondria GFF',
);
Readonly my %SKIP_EXT => map { $_, 1 } ('.md5');

main();

# --------------------------------------------------
sub main {
    my %args = get_args();

    if ($args{'help'} || $args{'man_page'}) {
        pod2usage({
            -exitval => 0,
            -verbose => $args{'man_page'} ? 2 : 1
        });
    }

    my $files_list = $args{'files'} or die "No files list\n";
    open my $fh, '<', $files_list;

    my $schema = MuScope::DB->new->schema;

    my $i = 0;
    while (my $file = <$fh>) {
        chomp($file);
        my ($name, $path, $suffix) = fileparse($file, qr/\.[^.]*/);
        next if $SKIP_EXT{ $suffix };
        my $basename = basename($file);
        my $sample   = basename($path);
        my $type     = $FILE_TYPE{ $basename } 
                       or die "Unknown file type: $basename\n";
        my ($Sample) = $schema->resultset('Sample')->search({
            sample_name => $sample,
        });

        unless ($Sample) {
            print STDERR "Cannot find sample '$sample'\n";
            next;
        }

        printf "%3d: %s %s (%s)\n", ++$i, $basename, $sample, $type;
        last;
    }

    say "OK";
}

# --------------------------------------------------
sub get_args {
    my %args;
    GetOptions(
        \%args,
        'files|f=s',
        'help',
        'man',
    ) or pod2usage(2);

    return %args;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

link-sample-files.pl - a script

=head1 SYNOPSIS

  link-sample-files.pl 

Options:

  --help   Show brief help and exit
  --man    Show full documentation

=head1 DESCRIPTION

Describe what the script does, what input it expects, what output it
creates, etc.

=head1 SEE ALSO

perl.

=head1 AUTHOR

Ken Youens-Clark E<lt>kyclark@email.arizona.eduE<gt>.

=head1 COPYRIGHT

Copyright (c) 2017 kyclark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
