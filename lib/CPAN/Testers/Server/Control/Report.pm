package CPAN::Testers::Server::Control::Report;
use strict;
use base qw(CPAN::Testers::Server::Control);

use CPAN::Testers::Server::DB qw(db);

use JSON::XS;

my $json = JSON::XS->new->utf8->pretty(1);

use Data::Dump qw(dump);

sub view {
    my ($self, $c) = @_;

    dump($c);

    my $id = $c->match->captures->{id};

    warn "ID: $id";

    my $db = db();

    #my ($report_id) = ($c->req->path =~ m!^/report/(.*)!);

    my $doc = $id && $db->document($id);

    return unless $doc;
    
    my $hash = $doc->data;
    
    $c->res->code(200);
    $c->res->body($json->encode($hash));
}

1;
