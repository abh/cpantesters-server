package CPAN::Testers::Server::Model::User;
use strict;
use Combust::Secret qw(get_secret);
use Digest::MD5 qw(md5_hex);

sub insert {
    my $self = shift;
    unless ($self->api_key) {
        $self->api_key($self->_create_api_key);
        # TODO: we really should check for races here, but it's so unlikely...
    }
    return $self->SUPER::insert(@_);
}

sub reset_api_key {
    my $self = shift;
    warn "reset foo!";
    my $new = $self->_create_api_key;
    return $self->api_key(substr($new, 0, 20));
}

sub _create_api_key {
    my $self = shift;
    my $new = md5_hex(join ";", time, $$, rand(), get_secret(type => 'api_key_reset', time => time));
    return $new;
}

1;
