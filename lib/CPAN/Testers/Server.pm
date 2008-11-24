package CPAN::Testers::Server;

use strict;
use warnings;

use base 'Mojolicious';

use lib '/Users/ask/src/MojoX-Renderer-TT/lib/';

use MojoX::Renderer::TT;

sub dispatch {
    my ($self, $c) = @_;

    # Try to find a static file
    return if $self->static->dispatch($c);

    # Use routes if we don't have a response code yet
    my $done = $self->routes->dispatch($c);

    # Nothing found
    unless ($c->res->code) {
        $self->static->serve($c, '/404.html');
        $c->res->code(404);
    }
}

# run once on startup 
sub startup {
    my $self = shift;

    $self->ctx_class('CPAN::Testers::Server::Context');
    $self->routes->namespace('CPAN::Testers::Server::Control');

    my $include_path = $self->home->rel_dir('templates'). ":.";

    my $tt = MojoX::Renderer::TT->build
      ( mojo => $self,
        template_options => { 
                             INCLUDE_PATH => $include_path,
                             PROCESS => 'tpl/wrapper',
                             PRE_PROCESS => 'tpl/defaults',
                            },
      );
    my $renderer = $self->renderer;
    $renderer->default_ext('html');
    $renderer->add_handler( html => $tt );

    my $r = $self->routes;
    
    #        $r->route('/:controller/:action')
    #          ->to(controller => 'foo', action => 'bar');
    
    $r->route('/')->to(controller => 'home', action => 'homepage');
    $r->route('/info/:name')->to(controller => 'home', action => 'info');
    $r->route('/:controller/:action/:id')->to(action => 'default');

}

1;
