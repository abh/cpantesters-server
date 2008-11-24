package CPAN::Testers::Server::DB;
use strict;
use Net::CouchDB;
use base 'Exporter';

our @EXPORT_OK = qw(db);

my $couch_url = $ENV{COUCHDB_URL} || 'http://localhost:5984/';

my $db_name   = $ENV{COUCHDB}     || 'cpantesters';
my $db = Net::CouchDB->new($couch_url)->db($db_name);

sub db {
    return $db;
}



1;
