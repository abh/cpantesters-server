package CPAN::Testers::Server::Control::Home;
use strict;
use base qw(CPAN::Testers::Server::Control);

use CPAN::Testers::Server::DB qw(db);

sub homepage {
    my ($self, $c) = @_;

    my $db = db();

    my @recent = $db->all_documents({count => 20});

    return $c->render(recent => \@recent);
}


1;
