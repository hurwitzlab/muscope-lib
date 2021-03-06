#!/usr/bin/env perl

use strict;
use warnings;
use autodie;
use feature 'say';
use Data::Dump 'dump';
use DateTime;
use Getopt::Long;
use HTTP::Request;
use JSON::XS;
use LWP::UserAgent;
use MongoDB;
use MuScope::DB;
use Pod::Usage;
use Readonly;
use String::Trim qw(trim);
use Time::ParseDate 'parsedate';

Readonly my %INDEX_FLDS = (
    investigator => [qw(first_name last_name institution)],
    cruise       => [qw(cruise_name)],
    sample       => [qw(sample_name)],
    sample_file  => [qw(file)],
);

Readonly my %MONGO_SQL => {
    sample => [
        q'select "sample_id" as name, sample_id as value
          from   sample
          where  sample_id=?
        ',
        q'select "sample_name" as name, sample_name as value
          from   sample
          where  sample_id=?
        ',
        q'select "cruise_id" as name, cruise_id as value
          from   sample
          where  sample_id=?
        ',
        q'select "cruise_name" as name, c.cruise_name as value
          from   sample s, cruise c
          where  s.sample_id=?
          and    s.cruise_id=c.cruise_id
        ',
        q'select "investigator_id" as name, s2i.investigator_id as value
          from   sample s, sample_to_investigator s2i
          where  s.sample_id=?
          and    s.sample_id=s2i.sample_id
        ',
        q'select "investigator_name" as name, 
                 concat_ws(" ", i.first_name, i.last_name) as value
          from   sample s, sample_to_investigator s2i, investigator i
          where  s.sample_id=?
          and    s.sample_id=s2i.sample_id
          and    s2i.investigator_id=i.investigator_id
        ',
        q'select "collection_date" as name, collection_start as value
          from   sample 
          where  sample_id=?
        ',
        q'select "latitude" as name, s.latitude_start as value
          from   sample s
          where  s.sample_id=?
        ',
        q'select "longitude" as name, s.longitude_start as value
          from   sample s
          where  s.sample_id=?
        ',
        q'select t.type as name, a.value as value
          from   sample_attr a, 
                 sample_attr_type t
          where  a.sample_id=?
          and    a.sample_attr_type_id=t.sample_attr_type_id
        ',
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

                        if ($key =~ /_date$/) {
                            my $epoch = parsedate($val);
                            my $dt = DateTime->from_epoch(epoch => $epoch);
                            $mongo_rec{ $key } = $dt;
                        }
                        else {
                            if ($mongo_rec{ $key }) {
                                $mongo_rec{ $key } .= " $val";
                            }
                            else {
                                $mongo_rec{ $key } = $val;
                            }
                        }
                    }
                }

                $mongo_rec{'location'} = 
                    $mongo_rec{'latitude'} =~ /\d/ &&
                    $mongo_rec{'longitude'} =~ /\d/
                    ? { type        => 'Point',
                        coordinates => 
                            [$mongo_rec{'longitude'}, $mongo_rec{'latitude'}]
                    }
                    : {};

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
