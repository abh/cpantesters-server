package CPAN::Testers::Server::Control::Report;
use strict;
use base qw(CPAN::Testers::Server::Control);
use Combust::Constant qw(OK NOT_FOUND);

use CPAN::Testers::Server::DB qw(db);

use JSON::XS;

my $json = JSON::XS->new->utf8->pretty(1);

sub render {
    my $self = shift;

    my $db = db();

    my ($report_id) = ($self->request->uri =~ m!^/report/(.*)!);

    my $doc = $db->document($report_id);

    return NOT_FOUND unless $doc;
    
    my $hash = $doc->data;

    return OK, $json->encode($hash), 'text/plain';
}

1;
