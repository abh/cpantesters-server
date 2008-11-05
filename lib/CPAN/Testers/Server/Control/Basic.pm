package CPAN::Testers::Server::Control::Basic;
use strict;
use base qw(CPAN::Testers::Server::Control);
use Apache::Constants qw(OK NOT_FOUND);

sub render {
    my $self = shift;

    warn "basic render!";

    return $self->logout if $self->request->uri =~ m!^/account/logout$!;
    return $self->render_account if $self->request->uri =~ m!^/account$!;

    return $self->SUPER::render;
}

sub render_account {
    my $self = shift;

    return $self->login unless $self->is_logged_in;

    unless ($self->user->api_key) {
        $self->user->reset_api_key;
        $self->user->save;
    }

    if ($self->check_auth_token) {
        my $reset_password = $self->req_param('reset_password') || '';
        if ($reset_password eq 'yes') {
            $self->tpl_param('reset_password_confirmation' => 1);
        }
        elsif ($reset_password eq 'absolutely') {
            $self->user->reset_api_key;
            $self->user->save;
        }
    }

    return OK, $self->evaluate_template('tpl/account.html');
}

1;
