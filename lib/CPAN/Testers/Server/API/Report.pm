package CPANTesters::API::Report;
use strict;
use base qw(CPANTesters::API);
use JSON::XS;
use CPANTesters::Report;

sub post {
    my $self = shift;

    my ($api_key, $via) = $self->_required_param(qw(api_key via));

    my $user = CPANTesters::Model->user->fetch(api_key => $api_key);
    die "Invalid API key\n" unless $user;

    my $data = "";
    while ($self->request->read(my $buf, 32768)) {
        $data .= $buf;
        die "request too large" if length $data > 1_000_000;
    }

    my $reports = decode_json($data);

    die "Invalid input data (require a list of reports)" unless ref $reports eq 'ARRAY';

    my $response = {};

    $response->{from_name} = $user->name || $user->username;
    $response->{from_email} = $user->email;

    # $response->{mail} = 

    return $response;
}


1;
