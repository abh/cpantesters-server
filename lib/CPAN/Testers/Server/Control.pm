package CPANTesters::Control;
use strict;
use Apache::Constants qw(OK NOT_FOUND);
use base qw(Combust::Control::Basic Combust::Control::Bitcard::RDBO);
use CPANTesters::API;


sub init {
    my $self = shift;

    if ($self->bc_check_login_parameters) {
        # TODO: should know to just filter out the bc_ parameters
        return $self->redirect($self->request->uri)
    }
    return OK;
}

sub bc_user_class {
    CPANTesters::Model->user;
  }

sub bc_info_required {
    'username,email';
}

sub logout {
    my $self = shift;
    $self->cookie('uiq' => '');
    return $self->SUPER::logout(@_);
}


1;

