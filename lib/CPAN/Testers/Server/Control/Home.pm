package CPAN::Testers::Server::Control::Home;
use strict;
use base qw(CPAN::Testers::Server::Control);

use CPAN::Testers::Server::DB qw(db);

sub homepage {
    my ($self, $c) = @_;

    my $db = db();

  VIEW:
    my $documents = eval { $db->document('_design/report')->view('timestamp')->search({ descending => JSON::true, count => 30 }) };
    if ($@) {
        warn "Error getting view, retrying in 5 seconds: $@";
        sleep 5;
        goto VIEW; 
    }

    my @rows;
    while (my $row = $documents->next) {
        push @rows, $row;
    }

    #use Data::Dump qw(dump);
    #dump(\@rows);

    return $c->render(recent => \@rows);
}


1;
