#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use Getopt::Long;
use HTTP::Request;
use MuScope::DB;
use MongoDB;
use JSON::XS;
use LWP::UserAgent;
use Pod::Usage;
use Readonly;
use String::Trim qw(trim);

Readonly my %INDEX_FLDS = (
    investigator => [qw(first_name last_name institution)],
    cruise       => [qw(cruise_name)],
    sample       => [qw(sample_name seq_name)],
);

Readonly my %MONGO_SQL => {
    sample => [
        q'select "station_number" as name, station_number as value
          from   station st, cast c, sample s
          where  s.sample_id=?
          and    s.cast_id=c.cast_id
          and    c.station_id=st.station_id
        ',
        q'select "sample_id" as name, sample_id as value
          from   sample
          where  sample_id=?
        ',
        q'select "sample_name" as name, sample_name as value
          from   sample
          where  sample_id=?
        ',
        q'select "cruise_name" as name, cr.cruise_name as value
          from   sample sa, cast ca, station st, cruise cr
          where  sa.sample_id=?
          and    sa.cast_id=ca.cast_id
          and    ca.station_id=st.station_id
          and    st.cruise_id=cr.cruise_id
        ',
        q'select "cruise_id" as name, st.cruise_id as value
          from   sample sa, cast ca, station st
          where  sa.sample_id=?
          and    sa.cast_id=ca.cast_id
          and    ca.station_id=st.station_id
        ',
        q'select "library_kit" as name, l.library_kit as value
          from   sample s, library_kit l
          where  s.sample_id=?
          and    s.library_kit_id=l.library_kit_id
        ',
        q'select "sequencing_method" as name, 
                 m.sequencing_method as value
          from   sample s, sequencing_method m
          where  s.sample_id=?
          and    s.sequencing_method_id=m.sequencing_method_id
        ',
        q'select "sample_type" as name, 
                 t.sample_type as value
          from   sample s, sample_type t
          where  s.sample_id=?
          and    s.sample_type_id=t.sample_type_id
        ',
        q'select "filter_type" as name, f.filter_type as value
          from   sample s, filter_type f
          where  s.sample_id=?
          and    s.filter_type_id=f.filter_type_id
        ',
        q'select "investigator" as name, 
                 concat_ws(" ", i.first_name, i.last_name) as value
          from   sample s, investigator i
          where  s.sample_id=?
          and    s.investigator_id=i.investigator_id
        ',
        q'select "cast_number" as name, c.cast_number as value
          from   sample s, cast c
          where  s.sample_id=?
          and    s.cast_id=c.cast_id
        ',
        q'select "collection_date" as name, c.collection_date as value
          from   sample s, cast c
          where  s.sample_id=?
          and    s.cast_id=c.cast_id
        ',
        q'select "collection_time" as name, c.collection_time as value
          from   sample s, cast c
          where  s.sample_id=?
          and    s.cast_id=c.cast_id
        ',
        q'select "latitude" as name, st.latitude as value
          from   sample sa, cast ca, station st
          where  sa.sample_id=?
          and    sa.cast_id=ca.cast_id
          and    ca.station_id=st.station_id
        ',
        q'select "longitude" as name, st.longitude as value
          from   sample sa, cast ca, station st
          where  sa.sample_id=?
          and    sa.cast_id=ca.cast_id
          and    ca.station_id=st.station_id
        ',
        q'select t.type as name, a.value as value
          from   sample_attr a, 
                 sample_attr_type t
          where  a.sample_id=?
          and    a.sample_attr_type_id=t.sample_attr_type_id
        ',
#        q'select distinct concat("data__", replace(t.type, ".", "_")) as name, 
#                 "true" as value
#          from   sample_file f, sample_file_type t
#          where  f.sample_file_type_id=t.sample_file_type_id
#          and    f.sample_id=?
#        ',
    ],
};

$MongoDB::BSON::looks_like_number = 1;

main();

# --------------------------------------------------
sub main {
    my $tables = '';
    my $list   = '';
    my ($help, $man_page);
    GetOptions(
        'l|list'     => \$list,
        't|tables:s' => \$tables,
        'help'       => \$help,
        'man'        => \$man_page,
    ) or pod2usage(2);

    if ($help || $man_page) {
        pod2usage({
            -exitval => 0,
            -verbose => $man_page ? 2 : 1
        });
    }; 

    if ($list) {
        say join "\n", 
            "Valid tables:",
            (map { " - $_" } sort keys %INDEX_FLDS),
            '',
        ;
        exit 0;
    }

    my %valid  = map { $_, 1 } keys %INDEX_FLDS;
    my @tables = $tables ? split /\s*,\s*/, $tables : keys %valid;
    my @bad    = grep { !$valid{ $_ } } @tables;
    
    if (@bad) {
        die join "\n", "Bad tables:", (map { "  - $_" } @bad), '';
    }

    process(@tables);
}

# --------------------------------------------------
sub process {
    my @tables     = @_;
    my $db         = MuScope::DB->new;
    my $mongo_conf = MuScope::Config->new->get('mongo');
    my $dbh        = $db->dbh;
    my $mongo      = $db->mongo;
    my $db_name    = $mongo_conf->{'dbname'};
    my $host       = $mongo_conf->{'host'};
    my $coll_name  = 'sampleKeys';
    my $mongo_db   = $mongo->get_database($db_name);
    $mongo_db->drop($coll_name);

    for my $table (@tables) {
        my $coll = $mongo_db->get_collection($table);
        $coll->drop();

        my @flds    = @{ $INDEX_FLDS{$table} } or next;
        my $pk_name = $table . '_id'; 
        unshift @flds, $pk_name;

        my @records = @{$dbh->selectall_arrayref(
            sprintf('select %s from %s', join(', ', @flds), $table), 
            { Columns => {} }
        )};

        printf "Processing %s from table '%s.'\n", scalar(@records), $table;

        $dbh->do('delete from search where table_name=?', {}, $table);

        my @mongo_sql = @{ $MONGO_SQL{ $table } || [] };

        my $i;
        for my $rec (@records) {
            my $pk  = $rec->{ $pk_name } or next;
            my $raw = join(' ', map { trim($rec->{$_} // '') } 
                      grep { $_ ne $pk } @flds);

            my @tmp;
            for my $w (split(/\s+/, $raw)) {
                push @tmp, $w;
                if ($w =~ /[_-]/) {
                    $w =~ s/_/ /g;
                    $w =~ s/-//g;
                    push @tmp, $w;
                }
            }

            my $text = join(' ', @tmp);

            $rec->{'primary_key'} = $pk;

            printf "%-78s\r", ++$i;

            my %mongo_rec;
            if ($table eq 'sample') {
                for my $sql (@mongo_sql) {
                    my $data =
                      $dbh->selectall_arrayref($sql, { Columns => {} }, $pk);

                    for my $rec (@$data) {
                        my $key = normalize($rec->{'name'}) or next;
                        my $val = trim($rec->{'value'})     or next;
                        if ($mongo_rec{ $key }) {
                            $mongo_rec{ $key } .= " $val";
                        }
                        else {
                            $mongo_rec{ $key } = $val;
                        }
                    }
                }

                $mongo_rec{'text'} = join(' ', 
                    grep { ! /^-?\d+(\.\d+)?$/ }
                    map  { split(/\s+/, $_) }
                    values %mongo_rec
                );

                $coll->insert(\%mongo_rec);
            }

            $dbh->do(
                q[
                    insert
                    into   search (table_name, primary_key, search_text)
                    values (?, ?, ?)
                ],
                {},
                ($table, $pk, join(' ', $text, $mongo_rec{'text'} // ''))
            );
        }
        print "\n";
    }

    say "Updating Mongo keys";

    `/usr/bin/mongo $host/$db_name --quiet --eval "var collection = 'sample', outputFormat='json'" /usr/local/imicrobe/variety/variety.js | mongoimport --host $host --db $db_name --collection $coll_name --jsonArray`;

    say "Done.";
}

# --------------------------------------------------
sub lean_hash {
    my $in = shift;
    my %out;
    while (my ($k, $v) = each %$in) {
        if (defined $v && $v ne '') {
            $out{ $k } = $v;
        }
    }
    return \%out;
}

# --------------------------------------------------
sub normalize {
    my $s   = shift or return;
    my $ret = trim($s);
    $ret    =~ s/[\s,-]+/_/g;
    $ret    =~ s/_parameter//;
    $ret    =~ s/[^\w:_]//g;
    return $ret;
}

__END__

# --------------------------------------------------

=pod

=head1 NAME

load-search.pl - a script

=head1 SYNOPSIS

  load-search.pl 

Options:

  -t|--tables  Comma-separated list of tables to index
  --help       Show brief help and exit
  --man        Show full documentation

=head1 DESCRIPTION

Indexes the iMicrobe "search" table.

=head1 AUTHOR

Ken Youens-Clark E<lt>E<gt>.

=head1 COPYRIGHT

Copyright (c) 2015 Ken Youens-Clark

This module is free software; you can redistribute it and/or
modify it under the terms of the GPL (either version 1, or at
your option, any later version) or the Artistic License 2.0.
Refer to LICENSE for the full license text and to DISCLAIMER for
additional warranty disclaimers.

=cut
