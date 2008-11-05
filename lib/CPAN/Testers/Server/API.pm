package CPANTesters::API;
use strict;
use base qw(Combust::API);
use CPANTesters::Model;

__PACKAGE__->setup_api
  ('report'  => 'Report',
  );

sub call {
    my $self = shift;

    my $db = CPANTesters::Model->db;
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
