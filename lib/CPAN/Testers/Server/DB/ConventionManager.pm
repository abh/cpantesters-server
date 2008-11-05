package CPANTesters::DB::ConventionManager;
use strict;

use base qw(Rose::DB::Object::ConventionManager);
use Rose::DB::Object::Metadata;

Rose::DB::Object::Metadata->convention_manager_classes
    (Rose::DB::Object::Metadata->convention_manager_classes,
     default => __PACKAGE__);

sub table_to_class {
    my ($self, $table, $prefix) = @_;
    $table =~ s/^cpantesters_//;
    $self->SUPER::table_to_class($table, $prefix);
}

1;
