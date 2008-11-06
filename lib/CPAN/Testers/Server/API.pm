package CPAN::Testers::Server::API;
use strict;
use base qw(Combust::API);

__PACKAGE__->setup_api
  ('report'  => 'Report',
  );


1;

__END__

use CPAN::Testers::Server::Model;

sub __call {
    my $self = shift;

    my $db = CPAN::Testers::Server::Model->db;
    $db->begin_work;

    $_[2]->{db} = $db;

    my ($result, $meta) = eval { $self->SUPER::call(@_) };

    if (my $err = $@) {
        $db->rollback;
        die $err;
    }
    
    $db->commit;
    
    return ($result, $meta);
}




1;
