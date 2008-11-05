package CPAN::Testers::Server::API::Search;
use strict;
use base qw(CPAN::Testers::Server::API);
use JSON::XS;
use Net::CouchDB;



sub nntp_id {
    my $self = shift;
    
    my $id = $self->_required_param('id');
    
    
}

1;
